import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';
import '../lunar_data_source_example.dart';
import '../lunar_info.dart';

/// TCalendar 日历组件示例页
///
/// ## 组件类型
///
/// 通过 [TCell] 打开底部弹层，弹层内为独立 [TCalendar] 实例：
/// - 单选 / 多选 / 区间：确认后回写业务 State（[initialValue] 仅打开时生效）
/// - 锚点对比：无锚点 vs [anchorDate] 首屏月份差异
///
/// ## 组件样式
///
/// - [subtitleBuilder]：自定义**副标题**（节日、价格）
/// - [cellBuilder]：自定义**整格**单元格
///
/// ## 农历日历
///
/// 内嵌 [TCalendar] + 外置控制栏；控制栏改 [anchorDate] 滚动月份，
/// 点格改选中（[onChange]），二者职责分离。
class TCalendarPage extends StatelessWidget {
  const TCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '按照日历形式展示数据或日期的容器。',
      exampleCodeGroup: 'calendar',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildSimple);
            },
          ),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(
            desc: '自定义副标题、按钮、单元格',
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildStyle);
            },
          ),
          ExampleItem(
            desc: '农历日历',
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildLunar);
            },
          ),
        ]),
      ],
      test: const [],
    );
  }
}

@Demo(group: 'calendar')
Widget _buildSimple(BuildContext context) {
  return const _SimpleDemo();
}

/// 「组件类型」演示容器
///
/// 包含 4 种 [TCalendar] 纯日历模式：
/// 1. 单选 + 天气信息展示
/// 2. 多选 + 已选汇总
/// 3. 区间选择 + 区间摘要
/// 4. 锚点：对比「无锚点 / 有锚点」打开时首屏月份
class _SimpleDemo extends StatelessWidget {
  const _SimpleDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SingleCalendarCell(),
        _MultipleCalendarCell(),
        _RangeCalendarCell(),
        _AnchorCompareSection(),
      ],
    );
  }
}

// ========================= 弹层日历（新实例 + 弹层内选中，确认后回写业务 State） =========================

/// 底部弹层内的日历选择器。
///
/// - [TCalendar.initialValue] 仅在弹层打开时传入一次（非受控）
/// - 点选过程在弹层内更新 `_pending`，避免外层 `setState` 重建日历
/// - **单选**：点选即确认并关闭
/// - **多选 / 区间**：底部「确认」后 [onConfirm] 回写
class _CalendarPickerSheet extends StatefulWidget {
  const _CalendarPickerSheet({
    required this.title,
    required this.type,
    this.initialValue,
    required this.onConfirm,
    this.anchorDate,
    this.animateTo = false,
    this.footer,
    this.minDate,
    this.maxDate,
    this.style,
    this.subtitleBuilder,
    this.cellBuilder,
    this.autoPopOnSingleSelect = true,
    bool? showConfirmButton,
  }) : showConfirmButton = showConfirmButton ??
            (type != CalendarType.single || !autoPopOnSingleSelect);

  final String title;
  final CalendarType type;
  /// 打开弹层时的初值；不传则日历无预选（对应 [TCalendar.initialValue] 为 null）。
  final List<DateTime>? initialValue;
  final ValueChanged<List<DateTime>> onConfirm;
  final DateTime? anchorDate;
  final bool animateTo;
  final Widget Function(List<DateTime> selected)? footer;
  final DateTime? minDate;
  final DateTime? maxDate;
  final TCalendarStyle? style;
  final TCalendarSubtitleBuilder? subtitleBuilder;
  final TCalendarCellBuilder? cellBuilder;

  /// 单选模式下点选日期后是否自动关闭弹层并回传，默认 true。
  final bool autoPopOnSingleSelect;

  /// 是否展示底部「确认」按钮。
  ///
  /// 默认：单选且 [autoPopOnSingleSelect] 时不展示（点选即确认）；
  /// 多选 / 区间始终展示，用于在弹层内完成选点后一次性回写。
  final bool showConfirmButton;

  @override
  State<_CalendarPickerSheet> createState() => _CalendarPickerSheetState();
}

class _CalendarPickerSheetState extends State<_CalendarPickerSheet> {
  late List<DateTime> _pending;

  @override
  void initState() {
    super.initState();
    _pending = widget.initialValue != null
        ? List<DateTime>.from(widget.initialValue!)
        : <DateTime>[];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      expand: false,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TCalendar(
                  type: widget.type,
                  initialValue: widget.initialValue != null ? _pending : null,
                  minDate: widget.minDate,
                  maxDate: widget.maxDate,
                  style: widget.style,
                  anchorDate: widget.anchorDate,
                  animateTo: widget.animateTo,
                  subtitleBuilder: widget.subtitleBuilder,
                  cellBuilder: widget.cellBuilder,
                  onChange: (value) {
                    final dates = _normalizeDateList(value);
                    setState(() => _pending = dates);
                    if (widget.type == CalendarType.single &&
                        widget.autoPopOnSingleSelect) {
                      widget.onConfirm(dates);
                      Navigator.pop(ctx);
                    }
                  },
                ),
              ),
              if (widget.footer != null) widget.footer!(_pending),
              if (widget.showConfirmButton)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TButton(
                    text: '确认',
                    theme: TButtonTheme.primary,
                    isBlock: true,
                    onTap: () {
                      widget.onConfirm(_pending);
                      Navigator.pop(ctx);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

void _showCalendarPickerSheet({
  required BuildContext context,
  required String title,
  required CalendarType type,
  List<DateTime>? initialValue,
  required ValueChanged<List<DateTime>> onConfirm,
  DateTime? anchorDate,
  bool animateTo = false,
  Widget Function(List<DateTime> selected)? footer,
  DateTime? minDate,
  DateTime? maxDate,
  TCalendarStyle? style,
  TCalendarSubtitleBuilder? subtitleBuilder,
  TCalendarCellBuilder? cellBuilder,
  bool autoPopOnSingleSelect = true,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CalendarPickerSheet(
      title: title,
      type: type,
      initialValue: initialValue,
      onConfirm: onConfirm,
      anchorDate: anchorDate,
      animateTo: animateTo,
      footer: footer,
      minDate: minDate,
      maxDate: maxDate,
      style: style,
      subtitleBuilder: subtitleBuilder,
      cellBuilder: cellBuilder,
      autoPopOnSingleSelect: autoPopOnSingleSelect,
    ),
  );
}

// ========================= 1. 单选 + 天气 =========================
/// 单选日历 + 天气信息展示
///
/// 演示 [TCalendar] 单选模式：
/// - 选中日期后显示天气信息
/// - 回传选中值
class _SingleCalendarCell extends StatefulWidget {
  const _SingleCalendarCell();
  @override
  State<_SingleCalendarCell> createState() => _SingleCalendarCellState();
}

class _SingleCalendarCellState extends State<_SingleCalendarCell> {
  List<DateTime> _selected = const <DateTime>[];

  @override
  Widget build(BuildContext context) {
    return TCell(
      title: '单个选择日历',
      arrow: true,
      note: _formatYmd(_selected),
      onClick: (_) {
        _showCalendarPickerSheet(
          context: context,
          title: '请选择日期',
          type: CalendarType.single,
          initialValue: _selected,
          onConfirm: (value) => setState(() => _selected = value),
        );
      },
    );
  }
}

// ========================= 2. 多选 =========================
/// 多选日历 + 已选汇总
///
/// 演示 [CalendarType.multiple] 多选模式，展示已选日期列表。
class _MultipleCalendarCell extends StatefulWidget {
  const _MultipleCalendarCell();
  @override
  State<_MultipleCalendarCell> createState() => _MultipleCalendarCellState();
}

class _MultipleCalendarCellState extends State<_MultipleCalendarCell> {
  List<DateTime> _dates = const <DateTime>[];

  @override
  Widget build(BuildContext context) {
    return TCell(
      title: '多个选择日历',
      arrow: true,
      note: _dates.isEmpty ? '--' : '已选 ${_dates.length} 天',
      onClick: (_) {
        _showCalendarPickerSheet(
          context: context,
          title: '请选择日期',
          type: CalendarType.multiple,
          initialValue: _dates,
          footer: (selected) => _MultipleSummary(selected: selected),
          onConfirm: (value) => setState(() => _dates = value),
        );
      },
    );
  }
}

// ========================= 3. 区间 =========================
/// 区间选择日历 + 区间摘要
///
/// 演示 [CalendarType.range] 区间模式，展示开始/结束日期及天数。
class _RangeCalendarCell extends StatefulWidget {
  const _RangeCalendarCell();
  @override
  State<_RangeCalendarCell> createState() => _RangeCalendarCellState();
}

class _RangeCalendarCellState extends State<_RangeCalendarCell> {
  late List<DateTime> _dates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 6)),
  ];

  @override
  Widget build(BuildContext context) {
    return TCell(
      title: '区间选择日历',
      arrow: true,
      note: _dates.length >= 2
          ? '${_formatMd(_dates.first)} ~ ${_formatMd(_dates[1])}'
          : '--',
      onClick: (_) {
        _showCalendarPickerSheet(
          context: context,
          title: '请选择日期区间',
          type: CalendarType.range,
          initialValue: _dates,
          footer: (selected) => _RangeSummary(selected: selected),
          onConfirm: (value) => setState(() => _dates = value),
        );
      },
    );
  }
}

// ========================= 4. 锚点 =========================

/// 锚点对比 demo 常量：无锚点场景的初值 2026-05-01；有锚点场景 anchor 为 2026-01。
class _AnchorDemoData {
  static final selected = [DateTime(2026, 5, 1)];
  static final anchorMonth = DateTime(2026, 1, 1);
}

/// 锚点对比区：「无锚点」打开弹层时带入 [initialValue]（仅新实例生效）；
/// 「有锚点」仅 [anchorDate]，不设 initialValue。
class _AnchorCompareSection extends StatefulWidget {
  const _AnchorCompareSection();

  @override
  State<_AnchorCompareSection> createState() => _AnchorCompareSectionState();
}

class _AnchorCompareSectionState extends State<_AnchorCompareSection> {
  List<DateTime> _selected = List<DateTime>.from(_AnchorDemoData.selected);

  void _clearSelected() => setState(() => _selected = const <DateTime>[]);

  @override
  Widget build(BuildContext context) {
    final hasSelected = _selected.isNotEmpty;
    final selectedNote = hasSelected ? _formatYmd(_selected) : '无';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasSelected)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TButton(
              text: '清除已选',
              size: TButtonSize.small,
              theme: TButtonTheme.defaultTheme,
              isBlock: true,
              onTap: _clearSelected,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              hasSelected
                  ? '当前 initialValue：$selectedNote（与 anchor 1 月错开）'
                  : '当前 initialValue：空（仅观察 anchor / 首屏月份）',
              style: TextStyle(
                fontSize: 12,
                color: TTheme.of(context).fontGyColor3,
              ),
            ),
          ),
        ),
        TCell(
          title: '无锚点',
          arrow: true,
          note: hasSelected
              ? '已选 $selectedNote，首屏应为 5 月'
              : '无已选，首屏为日历范围首月',
          onClick: (_) {
            _showCalendarPickerSheet(
              context: context,
              title: '无锚点：首屏 = 已选日期所在月',
              type: CalendarType.single,
              initialValue: _selected,
              onConfirm: (value) => setState(() => _selected = value),
              footer: (_) => _AnchorCompareHint(
                anchorMonth: _AnchorDemoData.anchorMonth,
                selected: _selected,
                useAnchor: false,
              ),
            );
          },
        ),
        TCell(
          title: '有锚点',
          arrow: true,
          note: '无 initialValue，首屏 = anchor 1 月',
          onClick: (_) {
            _showCalendarPickerSheet(
              context: context,
              title: '有锚点：首屏 = anchorDate 所在月',
              type: CalendarType.single,
              anchorDate: _AnchorDemoData.anchorMonth,
              animateTo: true,
              onConfirm: (_) {},
              footer: (_) => _AnchorCompareHint(
                anchorMonth: _AnchorDemoData.anchorMonth,
                useAnchor: true,
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 弹层底部说明：区分 [anchorDate]（首屏月份）与 [initialValue]（预选日期，仅无锚点 demo）。
class _AnchorCompareHint extends StatelessWidget {
  const _AnchorCompareHint({
    required this.anchorMonth,
    this.selected = const <DateTime>[],
    required this.useAnchor,
  });

  final DateTime anchorMonth;
  final List<DateTime> selected;
  final bool useAnchor;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final anchorLabel = '${anchorMonth.year}年${anchorMonth.month}月';
    final hasSelected = selected.isNotEmpty;
    final selectedLabel = _formatYmd(selected);

    final scrollLine = useAnchor
        ? 'anchorDate：打开定位到 $anchorLabel'
        : hasSelected
            ? '无 anchorDate：打开定位到已选 ${selected.first.month} 月'
            : '无 anchorDate 且无已选：打开定位到日历范围首月';

    final selectedLine = useAnchor
        ? '未设置 initialValue — 首屏仅由 anchorDate 决定'
        : hasSelected
            ? 'initialValue：$selectedLabel'
            : 'initialValue：空 — 首屏由已选或范围首月决定';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.brandColor1,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scrollLine,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.brandColor7,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            selectedLine,
            style: TextStyle(fontSize: 12, color: theme.fontGyColor2),
          ),
        ],
      ),
    );
  }
}

// ===== 顶层格式化辅助函数 =====
/// 将 onChange 回传的列表规范为仅含年月日的副本，避免 ValueNotifier 类型不匹配。
List<DateTime> _normalizeDateList(Iterable<DateTime> dates) {
  return dates
      .map((d) => DateTime(d.year, d.month, d.day))
      .toList(growable: false);
}

String _formatYmd(List<DateTime> dates) {
  if (dates.isEmpty) {
    return '--';
  }
  final d = dates.first;
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

String _formatMd(DateTime d) {
  return '${d.month}/${d.day}';
}

String _formatYmdFull(DateTime d) {
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

// ===== 共用 bottom 面板装饰 =====
BoxDecoration _bottomCardDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          blurRadius: 12,
          offset: Offset(0, -2),
        ),
      ],
    );

// ===== 拆分出的私有 widget =====

/// 自定义单元格容器：统一圆角 + 填充色 + 撑满约束
class _CustomCellContainer extends StatelessWidget {
  const _CustomCellContainer({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      constraints: const BoxConstraints.expand(),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _MultipleSummary extends StatelessWidget {
  const _MultipleSummary({required this.selected});

  final List<DateTime> selected;

  @override
  Widget build(BuildContext context) {
    final dates = [...selected]..sort();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _bottomCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('已选择 ${dates.length} 天',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: dates
                .map((d) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TTheme.of(context).brandColor1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatYmdFull(d),
                        style: TextStyle(
                            fontSize: 12,
                            color: TTheme.of(context).brandColor7),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RangeSummary extends StatelessWidget {
  const _RangeSummary({required this.selected});

  final List<DateTime> selected;

  @override
  Widget build(BuildContext context) {
    final hasStart = selected.isNotEmpty;
    final hasEnd = selected.length >= 2;
    final days = hasEnd
        ? selected[1].difference(selected[0]).inDays + 1
        : (hasStart ? 1 : 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _bottomCardDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: _RangeSegment(
                label: '开始',
                value: hasStart ? _formatYmdFull(selected[0]) : null),
          ),
          Icon(Icons.arrow_forward,
              size: 16, color: TTheme.of(context).fontGyColor3),
          const SizedBox(width: 12),
          Expanded(
            child: _RangeSegment(
                label: '结束',
                value: hasEnd ? _formatYmdFull(selected[1]) : null),
          ),
          if (days > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TTheme.of(context).brandColor1,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '共 $days 天',
                style: TextStyle(
                    fontSize: 12, color: TTheme.of(context).brandColor7),
              ),
            ),
        ],
      ),
    );
  }
}

class _RangeSegment extends StatelessWidget {
  const _RangeSegment({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, color: TTheme.of(context).fontGyColor3)),
        const SizedBox(height: 2),
        Text(
          value ?? '--',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: value != null
                ? TTheme.of(context).fontGyColor1
                : TTheme.of(context).fontGyColor3,
          ),
        ),
      ],
    );
  }
}

/// 「组件样式 - 自定义副标题 / 自定义单元格」
@Demo(group: 'calendar')
Widget _buildStyle(BuildContext context) {
  return const _StyleDemo();
}

/// 自定义样式演示容器
class _StyleDemo extends StatefulWidget {
  const _StyleDemo();

  @override
  State<_StyleDemo> createState() => _StyleDemoState();
}

class _StyleDemoState extends State<_StyleDemo> {
  static const _specialDays = {
    1: '初一',
    2: '初二',
    3: '初三',
    14: '情人节',
    15: '元宵节',
  };

  /// 副标题 demo 确认后的选中（仅用于 Cell note，不回灌运行中的 [TCalendar]）
  late final ValueNotifier<List<DateTime>> _customSubtitleSelected;
  /// 整格 demo 确认后的选中
  late final ValueNotifier<List<DateTime>> _customCellSelected;

  /// 自定义副标题 demo：通过 [subtitleBuilder] 按 [TCalendarSubtitleContext.date] 展示节日与价格。
  Widget? _buildPriceSubtitle(
    BuildContext context,
    TCalendarSubtitleContext subtitleContext,
  ) {
    final date = subtitleContext.date;
    final isSpecial =
        date.month == 2 && _specialDays.containsKey(date.day);
    final price = isSpecial ? '¥100' : '¥60';
    final label = isSpecial ? _specialDays[date.day] : null;
    final selected =
        subtitleContext.selectType == DateSelectType.selected;
    final theme = TTheme.of(context);
    final Color? color = selected
        ? theme.fontWhColor1
        : (isSpecial ? theme.errorColor6 : null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(label, style: TextStyle(fontSize: 9, color: color)),
        Text(price, style: TextStyle(fontSize: 9, color: color)),
      ],
    );
  }

  /// 自定义单元格 demo：通过 [cellBuilder] 整格绘制今天 / 已选 / 默认样式。
  Widget? _buildCustomDayCell(BuildContext context, TCalendarCellModel cell) {
    final today = DateTime.now();
    final isToday = cell.date ==
        DateTime(today.year, today.month, today.day);

    if (isToday && cell.selectType != DateSelectType.selected) {
      return _CustomCellContainer(
        color: TTheme.of(context).brandColor4,
        child: const Text(
          '今天',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    if (cell.selectType == DateSelectType.selected) {
      return _CustomCellContainer(
        color: TTheme.of(context).successColor8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${cell.date.day}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              '已选',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${cell.date.day}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('自定义', style: TextStyle(fontSize: 8)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _customSubtitleSelected = ValueNotifier<List<DateTime>>([DateTime(2022, 1, 15)]);
    _customCellSelected = ValueNotifier<List<DateTime>>(
        [DateTime.now().add(const Duration(days: 30))]);
  }

  @override
  void dispose() {
    _customSubtitleSelected.dispose();
    _customCellSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _customSubtitleSelected,
      builder: (context, textSelected, _) {
        return ValueListenableBuilder(
          valueListenable: _customCellSelected,
          builder: (context, cellValue, _) {
            final cellDate = cellValue[0];
            return TCellGroup(
              cells: [
                // 1. 自定义副标题（subtitleBuilder）
                TCell(
                  title: '自定义副标题',
                  arrow: true,
                  note: _formatYmd(textSelected),
                  onClick: (_) {
                    _showCalendarPickerSheet(
                      context: context,
                      title: '请选择日期',
                      type: CalendarType.single,
                      initialValue: textSelected,
                      minDate: DateTime(2022, 1, 1),
                      maxDate: DateTime(2022, 2, 15),
                      style: const TCalendarStyle(cellHeight: 80),
                      subtitleBuilder: _buildPriceSubtitle,
                      onConfirm: (value) =>
                          _customSubtitleSelected.value = _normalizeDateList(value),
                    );
                  },
                ),

                // 2. 自定义日期单元格（cellBuilder）
                TCell(
                  title: '自定义日期单元格',
                  arrow: true,
                  note:
                      '${cellDate.year}-${cellDate.month}-${cellDate.day}',
                  onClick: (_) {
                    _showCalendarPickerSheet(
                      context: context,
                      title: '请选择日期',
                      type: CalendarType.single,
                      initialValue: cellValue,
                      style: const TCalendarStyle(cellHeight: 80),
                      cellBuilder: _buildCustomDayCell,
                      onConfirm: (value) =>
                          _customCellSelected.value = _normalizeDateList(value),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// 「组件样式 - 农历日历」
///
/// 非弹窗内嵌模式，通过 [subtitleBuilder] 展示农历副标题，
/// 支持月份切换、年份/月份弹窗选择。
@Demo(group: 'calendar')
Widget _buildLunar(BuildContext context) {
  return const _LunarCalendarDemo();
}

/// 农历日历内嵌演示
///
/// 控制栏与 [TCalendar] 分工（常见「外置导航 + 内嵌日历」模式）：
/// - 控制栏改月 / 选年选月 → 更新 [anchorDate]，由日历滚动到对应月份
/// - 手指滑动日历 → [onMonthChanged] 只同步控制栏文案，不重建 [TCalendar]
/// - 点选日期 → [onChange] 回传选中值；[initialValue] 仅挂载生效，勿指望运行期回写同步选中
class _LunarCalendarDemo extends StatefulWidget {
  const _LunarCalendarDemo();

  @override
  State<_LunarCalendarDemo> createState() => _LunarCalendarDemoState();
}

class _LunarCalendarDemoState extends State<_LunarCalendarDemo> {
  final _lunarExample = LunarDataSourceExample();

  static final DateTime _minDate = DateTime(2020, 1, 1);
  static final DateTime _maxDate = DateTime(2030, 12, 31);

  /// 控制栏月份：用 [ValueNotifier] 更新，避免滑动日历时整页 setState 导致日历跳动。
  final ValueNotifier<DateTime> _controlBarMonth =
      ValueNotifier(DateTime.now());

  DateTime? _anchorDate;

  /// 当前选中日期，由 [TCalendar.onChange] 写入，供底部文案展示；日历选中态在组件内部维护。
  List<DateTime> _selected = [DateTime.now()];

  /// 底部「选中」文案专用，与日历本体解耦更新。
  late final ValueNotifier<List<DateTime>> _selectedDisplay =
      ValueNotifier<List<DateTime>>(List<DateTime>.from(_selected));

  @override
  void dispose() {
    _controlBarMonth.dispose();
    _selectedDisplay.dispose();
    super.dispose();
  }

  void _onCalendarMonthChanged(DateTime month) {
    final normalized = DateTime(month.year, month.month, 1);
    if (_controlBarMonth.value.year == normalized.year &&
        _controlBarMonth.value.month == normalized.month) {
      return;
    }
    _controlBarMonth.value = normalized;
  }

  void _onControlBarNavigate(DateTime anchor) {
    final month = DateTime(anchor.year, anchor.month, 1);
    _controlBarMonth.value = month;
    setState(() => _anchorDate = anchor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<DateTime>(
          valueListenable: _controlBarMonth,
          builder: (context, month, _) {
            return _LunarControlBar(
              currentMonth: month,
              getLunarInfo: _lunarExample.getLunarInfo,
              minDate: _minDate,
              maxDate: _maxDate,
              onNavigate: _onControlBarNavigate,
            );
          },
        ),
        TCalendar(
          type: CalendarType.single,
          minDate: _minDate,
          maxDate: _maxDate,
          initialValue: _selected,
          anchorDate: _anchorDate,
          animateTo: true,
          subtitleBuilder: _lunarExample.buildSubtitle,
          onMonthChanged: _onCalendarMonthChanged,
          onChange: (value) {
            final dates = _normalizeDateList(value);
            _selected = dates;
            _selectedDisplay.value = dates;
          },
          // 需要「每次点格」的副作用时用 onCellTap；选中结果仍以 onChange 为准
        ),
        ValueListenableBuilder<List<DateTime>>(
          valueListenable: _selectedDisplay,
          builder: (context, selected, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '选中：${_formatYmd(selected)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: TTheme.of(context).fontGyColor3,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 农历日历控制栏
///
/// 独立管理 _currentMonth 状态，滑动日历时只更新本 Widget，
/// 不触发上层日历重建，避免跳动。
class _LunarControlBar extends StatefulWidget {
  const _LunarControlBar({
    required this.currentMonth,
    required this.getLunarInfo,
    required this.minDate,
    required this.maxDate,
    required this.onNavigate,
  });

  final DateTime currentMonth;
  final LunarInfo? Function(DateTime) getLunarInfo;
  final DateTime minDate;
  final DateTime maxDate;

  /// 控制栏切换月份时回调，由父级更新 [TCalendar.anchorDate] 驱动日历滚动。
  final ValueChanged<DateTime> onNavigate;

  @override
  State<_LunarControlBar> createState() => _LunarControlBarState();
}

class _LunarControlBarState extends State<_LunarControlBar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    // 使用传入的 currentMonth 初始化，避免与父 Widget 状态不同步
    _currentMonth = _clampMonth(widget.currentMonth);
  }

  @override
  void didUpdateWidget(covariant _LunarControlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当父 Widget 通过 onMonthChanged 更新 currentMonth 时同步
    if (oldWidget.currentMonth.year != widget.currentMonth.year ||
        oldWidget.currentMonth.month != widget.currentMonth.month) {
      final clamped = _clampMonth(widget.currentMonth);
      if (_currentMonth.year != clamped.year ||
          _currentMonth.month != clamped.month) {
        _currentMonth = clamped;
      }
    }
  }

  /// 将任意 (year, month) clamp 到 [minDate, maxDate] 区间内。
  DateTime _clampMonth(DateTime date) {
    final minKey = widget.minDate.year * 12 + widget.minDate.month;
    final maxKey = widget.maxDate.year * 12 + widget.maxDate.month;
    final key = (date.year * 12 + date.month).clamp(minKey, maxKey);
    final year = (key - 1) ~/ 12;
    final month = (key - 1) % 12 + 1;
    return DateTime(year, month, 1);
  }

  bool _canGoPrev() {
    final cur = _currentMonth.year * 12 + _currentMonth.month;
    final minKey = widget.minDate.year * 12 + widget.minDate.month;
    return cur > minKey;
  }

  bool _canGoNext() {
    final cur = _currentMonth.year * 12 + _currentMonth.month;
    final maxKey = widget.maxDate.year * 12 + widget.maxDate.month;
    return cur < maxKey;
  }

  void _navigateTo(DateTime month) {
    final clamped = _clampMonth(month);
    // 命中相同月份时直接返回，避免触发上层无意义重建。
    if (_currentMonth.year == clamped.year &&
        _currentMonth.month == clamped.month) {
      return;
    }
    // 使用 addPostFrameCallback 避免在 build 期间调用 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _currentMonth = clamped;
      });
      widget.onNavigate(DateTime(clamped.year, clamped.month, 15));
    });
  }

  Future<void> _pickYear() async {
    final minYear = widget.minDate.year;
    final maxYear = widget.maxDate.year;
    final count = maxYear - minYear + 1;
    final selectedIndex = _currentMonth.year - minYear;
    // 让选中项默认居中（每行约 56 dp，参考 ListTile 默认高度）。
    const itemExtent = 56.0;
    final controller = ScrollController(
      initialScrollOffset: (selectedIndex * itemExtent - 120).clamp(
        0.0,
        (count * itemExtent - 200).clamp(0.0, double.infinity),
      ),
    );
    final year = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('选择年份',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemExtent: itemExtent,
                  itemCount: count,
                  itemBuilder: (ctx, index) {
                    final y = minYear + index;
                    final isSelected = y == _currentMonth.year;
                    return ListTile(
                      title: Text('$y年',
                          style: TextStyle(
                            color: isSelected ? Colors.blue : null,
                            fontWeight:
                                isSelected ? FontWeight.bold : null,
                          )),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () => Navigator.pop(ctx, y),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
    if (year != null) {
      // 切年时，目标月可能在端点年越界，_navigateTo 内部会兜底 clamp。
      _navigateTo(DateTime(year, _currentMonth.month, 1));
    }
  }

  Future<void> _pickMonth() async {
    final minKey = widget.minDate.year * 12 + widget.minDate.month;
    final maxKey = widget.maxDate.year * 12 + widget.maxDate.month;
    final m = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('选择月份',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 12,
                  itemBuilder: (ctx, index) {
                    final month = index + 1;
                    final monthKey = _currentMonth.year * 12 + month;
                    final isDisabled =
                        monthKey < minKey || monthKey > maxKey;
                    final isSelected =
                        !isDisabled && month == _currentMonth.month;
                    final bgColor = isDisabled
                        ? Colors.grey.shade100
                        : (isSelected ? Colors.blue : Colors.grey.shade200);
                    final fgColor = isDisabled
                        ? Colors.grey.shade400
                        : (isSelected ? Colors.white : Colors.black);
                    return InkWell(
                      onTap: isDisabled
                          ? null
                          : () => Navigator.pop(ctx, month),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$month月',
                            style: TextStyle(
                              color: fgColor,
                              fontWeight:
                                  isSelected ? FontWeight.bold : null,
                            )),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if (m != null) {
      _navigateTo(DateTime(_currentMonth.year, m, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lunarInfo = widget.getLunarInfo(_currentMonth);
    final lunarMonth = lunarInfo != null
        ? '${lunarInfo.yearText}年 ${lunarInfo.monthText}'
        : '';
    final canPrev = _canGoPrev();
    final canNext = _canGoNext();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 固定高度容器，防止农历文字有无时布局跳动
          SizedBox(
            height: 20,
            child: lunarMonth.isNotEmpty
                ? Text(
                    lunarMonth,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  )
                : const SizedBox.shrink(),
          ),
          Row(
            children: [
              TButton(
                text: '◀',
                size: TButtonSize.small,
                theme: TButtonTheme.defaultTheme,
                disabled: !canPrev,
                onTap: canPrev
                    ? () => _navigateTo(DateTime(
                        _currentMonth.year, _currentMonth.month - 1, 1))
                    : null,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TButton(
                  text: '${_currentMonth.year}年',
                  size: TButtonSize.small,
                  theme: TButtonTheme.defaultTheme,
                  onTap: _pickYear,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TButton(
                  text: '${_currentMonth.month}月',
                  size: TButtonSize.small,
                  theme: TButtonTheme.defaultTheme,
                  onTap: _pickMonth,
                ),
              ),
              const SizedBox(width: 4),
              TButton(
                text: '▶',
                size: TButtonSize.small,
                theme: TButtonTheme.defaultTheme,
                disabled: !canNext,
                onTap: canNext
                    ? () => _navigateTo(DateTime(
                        _currentMonth.year, _currentMonth.month + 1, 1))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
