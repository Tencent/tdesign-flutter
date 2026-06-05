import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';

/// 日历滚动主体（月份列表 + 日期格），由 [TCalendar] 内部组装，一般无需直接使用。
class TCalendarBody extends StatefulWidget {
  const TCalendarBody({
    Key? key,
    required this.type,
    this.initialValue,
    required this.firstDayOfWeek,
    required this.minDate,
    required this.maxDate,
    required this.builder,
    required this.bodyPadding,
    required this.monthNames,
    this.monthTitleStyle,
    this.monthTitleBuilder,
    required this.cellHeight,
    required this.monthTitleHeight,
    required this.verticalGap,
    required this.animateTo,
    this.onMonthChange,
    this.anchorDate,
    this.onCellGenerated,
    this.onCacheInvalidated,
  }) : super(key: key);

  final CalendarType type;

  /// 用于新建单元格时标记选中/区间态的快照（来自 [TCalendar] 内部缓存，非运行期受控 prop）。
  final List<DateTime>? initialValue;

  /// 首屏及运行期滚动目标月份；优先于 [initialValue] 决定 [_calcScrollOffset]。
  final DateTime? anchorDate;
  final int firstDayOfWeek;
  final DateTime minDate;
  final DateTime maxDate;
  final Widget Function(
    TCalendarCellModel? cell,
    List<TCalendarCellModel?> dateList,
    int rowIndex,
    int colIndex,
  ) builder;
  final double bodyPadding;
  final List<String> monthNames;
  final TextStyle? monthTitleStyle;
  final Widget Function(
    BuildContext context,
    DateTime monthDate,
  )? monthTitleBuilder;
  final double monthTitleHeight;
  final double verticalGap;
  final double cellHeight;
  final bool animateTo;
  final ValueChanged<DateTime>? onMonthChange;

  /// 在每个月份的单元格列表新生成时回调，便于上层登记选中引用。
  final void Function(DateTime monthDate, List<TCalendarCellModel?> cells)?
      onCellGenerated;

  /// 当 `_data` 整体被清空时回调，上层清空选中映射。
  final VoidCallback? onCacheInvalidated;

  @override
  State<TCalendarBody> createState() => _TCalendarBodyState();
}

class _TCalendarBodyState extends State<TCalendarBody> {
  late final ScrollController _scrollController;
  int? _lastNotifiedMonthKey;
  final _data = <DateTime, List<TCalendarCellModel?>>{};
  final _monthHeight = <int, double>{};
  late List<DateTime> _months;
  late DateTime _min;
  late DateTime _max;

  /// 月份累计高度的前缀和：`_prefixHeights[i]` = 第 0..i-1 月的高度之和。
  /// 长度为 `_months.length + 1`，用于 O(log n) 二分查找可见月份。
  late List<double> _prefixHeights;

  /// 程序化滚动期间静默 onMonthChange 回调，避免高频中间值打扰外部。
  ///
  /// 生命周期：
  /// - 由 `_smoothScrollTo` 在滚动开始时设为 true；
  /// - 由 `_runAnimateTo.whenComplete` 在动画完成或被打断时复位 false；
  /// - `addPostFrameCallback` 中检测到 controller 已分离时也会兜底复位，
  ///   避免外部永久收不到 onMonthChange 回调。
  bool _programmaticScroll = false;

  @override
  void initState() {
    super.initState();
    _initMonths();
    final initialOffset = _calcScrollOffset();
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
    // 首屏预热：在第一帧之前生成初始可见月份的数据，避免 itemBuilder
    // 第一次 build 时缓存为空，回退路径产生不必要的重算。
    _warmupCacheAround(_indexAtOffset(initialOffset));
  }

  @override
  void didUpdateWidget(covariant TCalendarBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final rangeChanged = oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate;
    final weekStartChanged =
        oldWidget.firstDayOfWeek != widget.firstDayOfWeek;
    final layoutMetricsChanged = oldWidget.cellHeight != widget.cellHeight ||
        oldWidget.monthTitleHeight != widget.monthTitleHeight ||
        oldWidget.verticalGap != widget.verticalGap ||
        oldWidget.bodyPadding != widget.bodyPadding;
    final selectionChanged =
        !_listEqualsDate(oldWidget.initialValue, widget.initialValue);

    if (rangeChanged) {
      // 可选范围变更：重建月份列表并清空格点/高度缓存，与 refactor 前行为一致。
      _monthHeight.clear();
      _data.clear();
      widget.onCacheInvalidated?.call();
      _lastNotifiedMonthKey = null;
      _initMonths();
    } else if (selectionChanged || weekStartChanged || layoutMetricsChanged) {
      // 选中、周起始或布局参数变更：重建格点；布局变更时同步月份高度缓存。
      if (layoutMetricsChanged) {
        _monthHeight.clear();
        _rebuildIndex();
      }
      _data.clear();
      widget.onCacheInvalidated?.call();
    }
    if (_shouldScrollToAnchor(oldWidget)) {
      _scrollToItem();
    }
  }

  bool _shouldScrollToAnchor(TCalendarBody oldWidget) {
    final anchor = widget.anchorDate;
    if (anchor == null) {
      return false;
    }
    final oldAnchor = oldWidget.anchorDate;
    if (oldAnchor == null) {
      return true;
    }
    return anchor.year != oldAnchor.year || anchor.month != oldAnchor.month;
  }

  static bool _listEqualsDate(List<DateTime>? a, List<DateTime>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _initMonths() {
    _min = widget.minDate;
    _max = widget.maxDate;
    _months = _monthsBetween(_min, _max);
    _rebuildIndex();
  }

  /// 重建月份前缀和。
  ///
  /// 性能考量：
  /// - 此前 `_calcScrollOffset` / `_onScroll` 都是 O(n) 线性扫描，
  ///   `_months.length` 默认 ~1572 时滚动期间累计开销显著。
  /// - 改为预计算前缀和 + 二分查找后，单次查询 O(log n)，
  ///   滚动监听不再因列表长度而劣化。
  ///
  /// 月份索引不再使用反查 Map：因为 `_months` 按月份单调递增，
  /// 给定 monthKey 只需 `monthKey - firstKey` 即可 O(1) 算出索引。
  void _rebuildIndex() {
    _prefixHeights = List<double>.filled(_months.length + 1, 0.0);
    var acc = 0.0;
    for (var i = 0; i < _months.length; i++) {
      _prefixHeights[i] = acc;
      acc += _getMonthHeight(_months, i, _monthHeight);
    }
    _prefixHeights[_months.length] = acc;
  }

  static int _monthKey(DateTime d) => d.year * 12 + d.month;

  /// 二分查找：给定滚动偏移量，返回当前可见的月份索引。
  int _indexAtOffset(double offset) {
    if (_months.isEmpty) {
      return 0;
    }
    var lo = 0;
    var hi = _months.length - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) >> 1;
      if (_prefixHeights[mid] <= offset) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    return lo;
  }

  /// 计算首屏滚动偏移：优先 [anchorDate]，否则取 [initialValue] 最早一日，再否则为 0。
  ///
  /// 越界时 clamp 到 [minDate]/[maxDate] 对应的首尾月，避免锚点落在范围外时静默回顶。
  double _calcScrollOffset() {
    var scrollToDate = widget.anchorDate;
    if (scrollToDate == null) {
      if (widget.initialValue == null || widget.initialValue!.isEmpty) {
        return 0.0;
      }
      scrollToDate = widget.initialValue!.reduce((a, b) => a.isBefore(b) ? a : b);
    }
    if (_months.isEmpty) {
      return 0.0;
    }
    // 用 (年*12 + 月) 作为可比较的标量，规避日级别比较带来的边界陷阱。
    final firstKey = _monthKey(_months.first);
    final lastKey = _monthKey(_months.last);
    final targetKey = _monthKey(scrollToDate);
    final clampedKey = targetKey.clamp(firstKey, lastKey);
    // O(1) 算术：月份 key 是单调递增的整数，索引 = clampedKey - firstKey。
    final idx = clampedKey - firstKey;
    return _prefixHeights[idx];
  }

  void _onScroll() {
    if (_months.isEmpty) {
      return;
    }
    final i = _indexAtOffset(_scrollController.offset);
    final currentMonth = _months[i];
    final currentKey = _monthKey(currentMonth);
    // 只在月份真正变化时回调，且程序化滚动期间静默，避免动画中间值打扰外部。
    if (_lastNotifiedMonthKey != currentKey) {
      _lastNotifiedMonthKey = currentKey;
      if (!_programmaticScroll) {
        widget.onMonthChange?.call(currentMonth);
      }
    }
    _warmupCacheAround(i);
    _cleanupCache(i);
  }

  /// 预热当前可见月份及其前后相邻月份的缓存。
  ///
  /// 把"写入 _data"这一副作用从 itemBuilder 中分离出来，避免 build 阶段写状态。
  /// 范围 ±2 月（共 5 个月）足以覆盖单屏可见与上下少量预渲染月份，超出部分
  /// 由 itemBuilder 走 fallback 直接计算（仍不写缓存）。
  void _warmupCacheAround(int currentIndex) {
    if (_months.isEmpty) {
      return;
    }
    const radius = 2;
    final lo = (currentIndex - radius).clamp(0, _months.length - 1);
    final hi = (currentIndex + radius).clamp(0, _months.length - 1);
    for (var i = lo; i <= hi; i++) {
      final monthDate = _months[i];
      if (!_data.containsKey(monthDate)) {
        final tdates = _getDaysInMonth(monthDate, _min, _max);
        _data[monthDate] = tdates;
        widget.onCellGenerated?.call(monthDate, tdates);
      }
    }
  }

  /// 清理距离当前可见月份过远的缓存数据，避免在 itemBuilder 中执行副作用。
  ///
  /// `_data` 实际只会缓存可见月份附近的少量项（受本方法 ±10 范围限制，
  /// 上限约 21 项），遍历开销可忽略，无需额外节流。
  void _cleanupCache(int currentIndex) {
    if (_months.isEmpty) {
      return;
    }
    final firstKey = _monthKey(_months.first);
    _data.removeWhere((key, _) {
      // 用月份 key 算术替代 List.indexOf 的 O(n) 扫描。
      final monthIdx = _monthKey(key) - firstKey;
      return monthIdx < currentIndex - 10 || monthIdx > currentIndex + 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(widget.bodyPadding),
      controller: _scrollController,
      itemCount: _months.length,
      itemExtentBuilder: (index, dimensions) =>
          _getMonthHeight(_months, index, _monthHeight),
      itemBuilder: (context, index) {
        final monthDate = _months[index];
        final monthYear = monthDate.year.toString() + context.resource.year;
        final monthMonth = widget.monthNames[monthDate.month - 1];
        final monthDateText = '$monthYear $monthMonth';
        // 只读：build 不写状态。命中缓存直接用，未命中走纯函数计算并安排
        // 在下一帧补写缓存（postFrameCallback），避免 build 阶段副作用。
        List<TCalendarCellModel?> monthData;
        final cached = _data[monthDate];
        if (cached != null) {
          monthData = cached;
        } else {
          monthData = _getDaysInMonth(monthDate, _min, _max);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            // 仅当下一帧仍未被其他路径填充时写入，幂等。
            // 注册回调也只在真正写入这条新数据时触发，避免重复登记。
            if (!_data.containsKey(monthDate)) {
              _data[monthDate] = monthData;
              widget.onCellGenerated?.call(monthDate, monthData);
            }
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.monthTitleHeight,
              child: widget.monthTitleBuilder?.call(context, monthDate) ??
                  TText(monthDateText, style: widget.monthTitleStyle),
            ),
            ...List.generate(
              (monthData.length / 7).ceil(),
              (rowIndex) => [
                SizedBox(height: widget.verticalGap),
                Row(
                  children: [
                    for (int colIndex = 0; colIndex < 7; colIndex++) ...[
                      if (colIndex != 0)
                        SizedBox(width: widget.verticalGap / 2),
                      Expanded(
                        child: widget.builder(
                          (rowIndex * 7 + colIndex < monthData.length)
                              ? monthData[rowIndex * 7 + colIndex]
                              : null,
                          monthData,
                          rowIndex,
                          colIndex,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ).expand((element) => element).toList(),
            SizedBox(
                height: index == _months.length - 1 ? 0 : widget.bodyPadding),
          ],
        );
      },
    );
  }

  void _scrollToItem() {
    final height = _calcScrollOffset();
    // 等待 ScrollController 完成 attach 后再滚动，最多重试若干帧。
    void attemptScroll([int retry = 0]) {
      if (!mounted) {
        return;
      }
      if (!_scrollController.hasClients) {
        if (retry >= 5) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          attemptScroll(retry + 1);
        });
        return;
      }
      final position = _scrollController.position;
      final clamped = height.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      if (widget.animateTo) {
        _smoothScrollTo(position, clamped);
      } else {
        _scrollController.jumpTo(clamped);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      attemptScroll();
    });
  }

  /// 长距离滚动优化：先 jumpTo 到目标附近，再做一小段动画补尾。
  ///
  /// 背景：`ListView.builder` 在跨度极大（如跨年）时一次性高速滚动会引发：
  ///   1) itemBuilder 短时间内被调用数十次，每月还要计算农历/节气，主线程被打满
  ///   2) `_onScroll` 沿途反复触发，进一步加重负载
  /// 视觉表现就是"卡顿/掉帧"。
  ///
  /// 优化策略（参考 iOS 通讯录 / 微信会话列表的"远距离跳转"行为）：
  ///   - 跨度 ≤ 3 屏：保持原有 200ms 平滑动画，体验无变化
  ///   - 跨度  > 3 屏：先 jumpTo 到距离目标 1 屏的位置（瞬时，无 build 压力），
  ///                  再用 180ms 平滑滚完最后这 1 屏，仍保留"滑过去"的视觉过渡
  ///
  /// 同时把整段滚动标记为「程序化滚动」：期间 `_onScroll` 不向外回调
  /// onMonthChange，由调用方负责设置目标月份显示，避免中间月份打扰外部状态。
  void _smoothScrollTo(ScrollPosition position, double target) {
    final delta = (target - position.pixels).abs();
    final viewport = position.viewportDimension;
    // 阈值：超过 3 个屏幕高度就走 jump + animate 的组合方案
    const thresholdInViewports = 3.0;

    _programmaticScroll = true;

    if (viewport > 0 && delta > viewport * thresholdInViewports) {
      // 朝目标方向跳到距离目标 1 屏的位置，给最后一段留出动画空间
      final preJump = target > position.pixels
          ? target - viewport
          : target + viewport;
      _scrollController.jumpTo(preJump.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ));
      // 关键：jumpTo 后必须等 ListView 完成一次 layout（itemExtentBuilder 重新算
      // viewport，可见 item 重新生成），否则紧接着 animateTo 可能拿到陈旧的
      // maxScrollExtent / pixels，触发断言或滚到错误位置。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) {
          _programmaticScroll = false;
          return;
        }
        // 重新 clamp 一次：jumpTo 后 maxScrollExtent 可能因 itemExtentBuilder
        // 重算而变化（虽然我们用的是固定高度算法，但稳妥起见仍兜底）。
        final pos = _scrollController.position;
        final clampedTarget = target.clamp(
          pos.minScrollExtent,
          pos.maxScrollExtent,
        );
        _runAnimateTo(
          clampedTarget,
          const Duration(milliseconds: 180),
          Curves.easeOut,
        );
      });
    } else {
      _runAnimateTo(
        target,
        const Duration(milliseconds: 200),
        Curves.easeInOut,
      );
    }
  }

  /// 统一的 animateTo 包装：处理动画完成 / 中断时的状态恢复。
  void _runAnimateTo(double target, Duration duration, Curve curve) {
    if (!_scrollController.hasClients) {
      _programmaticScroll = false;
      return;
    }
    _scrollController
        .animateTo(target, duration: duration, curve: curve)
        .whenComplete(() {
      // State 已 dispose 时直接退出，不再触碰 _scrollController（已 dispose）。
      if (!mounted) {
        return;
      }
      _programmaticScroll = false;
      // 落定后补发一次 onMonthChange，让外部确认最终月份；
      // _onScroll 内部仅在 monthKey 变化时回调，幂等。
      if (_scrollController.hasClients) {
        _onScroll();
      }
    });
  }

  List<DateTime> _monthsBetween(DateTime min, DateTime max) {
    final months = <DateTime>[];
    var current = DateTime(min.year, min.month);
    while (current.compareTo(max) <= 0) {
      months.add(current);
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }

  List<TCalendarCellModel?> _getDaysInMonth(
      DateTime curDate, DateTime min, DateTime max) {
    final daysInMonth = List<TCalendarCellModel?>.generate(
        _getPreOffset(curDate), (index) => null);
    final daysInMonthCount = DateTime(curDate.year, curDate.month + 1, 0)
        .day; // 获取下个月的第一天的前一天，即当前月的最后一天
    for (var day = 1; day <= daysInMonthCount; day++) {
      final date = DateTime(curDate.year, curDate.month, day);
      var selectType = DateSelectType.empty;
      if (date.compareTo(min) == -1 || date.compareTo(max) == 1) {
        selectType = DateSelectType.disabled;
      } else if (widget.type == CalendarType.single &&
          (widget.initialValue?.length ?? 0) >= 1) {
        if (date.compareTo(widget.initialValue![0]) == 0) {
          selectType = DateSelectType.selected;
        }
      } else if (widget.type == CalendarType.multiple &&
          widget.initialValue != null) {
        if (widget.initialValue!.isContains((e) => date.compareTo(e) == 0)) {
          selectType = DateSelectType.selected;
        }
      } else if (widget.type == CalendarType.range &&
          (widget.initialValue?.length ?? 0) >= 1) {
        final end =
            (widget.initialValue?.length ?? 0) > 1 ? widget.initialValue![1] : null;
        if (date.compareTo(widget.initialValue![0]) == 0) {
          selectType = DateSelectType.start;
        }
        if (end != null && widget.initialValue![0].compareTo(end) < 0) {
          if (date.compareTo(end) == 0) {
            selectType = DateSelectType.end;
          }
          if (date.compareTo(widget.initialValue![0]) == 1 &&
              date.compareTo(end) == -1) {
            selectType = DateSelectType.centre;
          }
        }
      }
      daysInMonth.add(TCalendarCellModel(
        date: date,
        typeNotifier: DateSelectTypeNotifier(selectType),
        isLastDayOfMonth: daysInMonthCount == day,
      ));
    }
    var sufOffset = 7 - daysInMonth.length % 7;
    sufOffset = sufOffset == 7 ? 0 : sufOffset;
    for (var i = 0; i < sufOffset; i++) {
      daysInMonth.add(null);
    }
    return daysInMonth;
  }

  int _getPreOffset(DateTime date) {
    final year = date.year;
    final month = date.month;
    var dayOneWeek = DateTime(year, month).weekday;
    dayOneWeek = dayOneWeek == 7 ? 0 : dayOneWeek;
    var preOffset = dayOneWeek - widget.firstDayOfWeek;
    preOffset = preOffset < 0 ? preOffset + 7 : preOffset;
    return preOffset;
  }

  /// 获取月份高度，带缓存
  double _getMonthHeight(
      List<DateTime> months, int index, Map<int, double> monthHeight) {
    if (months.getOrNull(index) == null) {
      return 1;
    }
    if (monthHeight.containsKey(index)) {
      return monthHeight[index]!;
    }
    final item = months[index];
    final isLast = index == months.length - 1;
    final preOffset = _getPreOffset(item);
    final daysInMonthCount = DateTime(item.year, item.month + 1, 0).day;
    final daysInMonth = preOffset + daysInMonthCount;
    final height = widget.monthTitleHeight +
        (daysInMonth / 7).ceil() * (widget.verticalGap + widget.cellHeight) +
        (isLast ? 0 : widget.bodyPadding);
    monthHeight[index] = height;
    return height;
  }
}
