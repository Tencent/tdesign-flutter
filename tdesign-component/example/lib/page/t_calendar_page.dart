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
/// 通过 [TCell] 以 [TPopup.show] 打开底部浮层，浮层内为独立 [TCalendar] 实例：
/// - 单选 / 多选 / 区间：确认后回写业务 State（[initialValue] 仅打开时生效）
/// - 锚点：有 initialValue 时首屏跟已选月，无则跟 anchorDate
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
/// 4. 锚点与 initialValue：同一入口，靠是否传入 initialValue 区分首屏逻辑
class _SimpleDemo extends StatelessWidget {
  const _SimpleDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SingleCalendarCell(),
        _MultipleCalendarCell(),
        _RangeCalendarCell(),
        _AnchorCalendarCell(),
      ],
    );
  }
}

// ========================= 弹层日历（TPopup + 新 TCalendar 实例，确认后回写业务 State） =========================

/// [TPopup] 浮层内容区：日历 + 可选 footer。
///
/// - [seedInitial] 非 null 时传给 [TCalendar.initialValue]（仅首挂载）
/// - [pending] 记录点选草稿，供 footer 与头部「确认」读取
/// - **单选**且 [autoPopOnSingleSelect]：在 [onChange] 内 [onConfirm] 并 [closePopup]
class _CalendarPickerPanel extends StatelessWidget {
  const _CalendarPickerPanel({
    required this.type,
    this.seedInitial,
    required this.pending,
    required this.onConfirm,
    required this.closePopup,
    this.anchorDate,
    this.animateTo = false,
    this.footer,
    this.minDate,
    this.maxDate,
    this.style,
    this.subtitleBuilder,
    this.cellBuilder,
    this.autoPopOnSingleSelect = true,
  });

  final CalendarType type;
  final List<DateTime>? seedInitial;
  final ValueNotifier<List<DateTime>> pending;
  final ValueChanged<List<DateTime>> onConfirm;
  final VoidCallback closePopup;
  final DateTime? anchorDate;
  final bool animateTo;
  final Widget Function(List<DateTime> selected)? footer;
  final DateTime? minDate;
  final DateTime? maxDate;
  final TCalendarStyle? style;
  final TCalendarSubtitleBuilder? subtitleBuilder;
  final TCalendarCellBuilder? cellBuilder;
  final bool autoPopOnSingleSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TCalendar(
            type: type,
            initialValue: seedInitial != null
                ? List<DateTime>.from(seedInitial!)
                : null,
            minDate: minDate,
            maxDate: maxDate,
            style: style,
            anchorDate: anchorDate,
            animateTo: animateTo,
            subtitleBuilder: subtitleBuilder,
            cellBuilder: cellBuilder,
            onChange: (value) {
              final dates = _normalizeDateList(value);
              pending.value = dates;
              if (type == CalendarType.single && autoPopOnSingleSelect) {
                onConfirm(dates);
                closePopup();
              }
            },
          ),
        ),
        if (footer != null)
          ValueListenableBuilder<List<DateTime>>(
            valueListenable: pending,
            builder: (context, selected, _) => footer!(selected),
          ),
      ],
    );
  }
}

/// 命令式打开底部日历浮层（与 picker / date-time-picker 示例一致，使用 [TPopup]）。
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
  final pending = ValueNotifier<List<DateTime>>(
    initialValue != null ? List<DateTime>.from(initialValue) : <DateTime>[],
  );
  final showHeaderConfirm =
      type != CalendarType.single || !autoPopOnSingleSelect;
  final sheetHeight = MediaQuery.sizeOf(context).height * 0.6;

  final popupHandles = <TPopupHandle>[];
  final panel = Material(
    color: TTheme.of(context).bgColorContainer,
    child: SafeArea(
      top: false,
      child: _CalendarPickerPanel(
        type: type,
        seedInitial: initialValue,
        pending: pending,
        onConfirm: onConfirm,
        closePopup: () => popupHandles.first.close(),
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
    ),
  );

  void onVisibleChange(bool visible, TPopupTrigger trigger) {
    if (!visible) {
      if (trigger == TPopupTrigger.confirm) {
        onConfirm(_normalizeDateList(pending.value));
      }
      pending.dispose();
    }
  }

  final handle = showHeaderConfirm
      ? TPopup.show(
          context,
          options: TPopupOptions.bottom(
            height: sheetHeight,
            titleWidget: TText(title),
            onVisibleChange: onVisibleChange,
            child: panel,
          ),
        )
      : TPopup.show(
          context,
          options: TPopupOptions.bottom(
            height: sheetHeight,
            titleWidget: TText(title),
            confirmBuilder: null,
            onVisibleChange: onVisibleChange,
            child: panel,
          ),
        );
  popupHandles.add(handle);
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

// ========================= 4. 锚点与 initialValue =========================

/// 演示首屏定位：有 [initialValue] 时滚到已选所在月，否则用 [anchorDate]（2026-01）。
class _AnchorDemoData {
  static final initialSelected = [DateTime(2026, 5, 1)];
  static final anchorMonth = DateTime(2026, 1, 1);
}

/// 同一弹层入口：是否传入 initialValue 决定首屏月份逻辑。
class _AnchorCalendarCell extends StatefulWidget {
  const _AnchorCalendarCell();

  @override
  State<_AnchorCalendarCell> createState() => _AnchorCalendarCellState();
}

class _AnchorCalendarCellState extends State<_AnchorCalendarCell> {
  List<DateTime> _selected = List<DateTime>.from(_AnchorDemoData.initialSelected);

  void _clearSelected() => setState(() => _selected = const <DateTime>[]);

  void _openPicker() {
    final hasInitial = _selected.isNotEmpty;
    final anchorLabel =
        '${_AnchorDemoData.anchorMonth.year}年${_AnchorDemoData.anchorMonth.month}月';
    _showCalendarPickerSheet(
      context: context,
      title: hasInitial ? '选择日期' : '选择日期（$anchorLabel）',
      type: CalendarType.single,
      initialValue: hasInitial ? _selected : null,
      anchorDate: hasInitial ? null : _AnchorDemoData.anchorMonth,
      animateTo: !hasInitial,
      onConfirm: (value) => setState(() => _selected = value),
      footer: (_) => _AnchorPickerHint(
        anchorMonth: _AnchorDemoData.anchorMonth,
        hasInitialValue: hasInitial,
        selected: _selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasInitial = _selected.isNotEmpty;
    final selectedNote = hasInitial ? _formatYmd(_selected) : '无';
    final anchorLabel =
        '${_AnchorDemoData.anchorMonth.year}年${_AnchorDemoData.anchorMonth.month}月';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TButton(
            child: Text('清除已选'),
            size: TButtonSize.small,
            colorScheme: TButtonColorScheme.light,
            isBlock: true,
            disabled: !hasInitial,
            onPressed: _clearSelected,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              hasInitial
                  ? '已选 $selectedNote：打开日历会滚到该日所在月份'
                  : '未选日期：打开日历会滚到锚点月份 $anchorLabel（不自动选中）',
              style: TextStyle(
                fontSize: 12,
                color: TTheme.of(context).fontGyColor3,
              ),
            ),
          ),
        ),
        TCell(
          title: '锚点',
          arrow: true,
          note: hasInitial
              ? '已选 $selectedNote，打开显示该日所在月'
              : '未选日期，打开显示 $anchorLabel',
          onClick: (_) => _openPicker(),
        ),
      ],
    );
  }
}

/// 弹层底部说明：本次打开是否传入 initialValue / anchorDate。
class _AnchorPickerHint extends StatelessWidget {
  const _AnchorPickerHint({
    required this.anchorMonth,
    required this.hasInitialValue,
    this.selected = const <DateTime>[],
  });

  final DateTime anchorMonth;
  final bool hasInitialValue;
  final List<DateTime> selected;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final anchorLabel = '${anchorMonth.year}年${anchorMonth.month}月';
    final selectedLabel = _formatYmd(selected);

    final scrollLine = hasInitialValue
        ? '打开后滚到已选日期所在月（${selected.first.month}月）'
        : '打开后滚到锚点月份 $anchorLabel';

    final selectedLine = hasInitialValue
        ? '已预选 $selectedLabel'
        : '未预选日期，仅按锚点月份定位';

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
@Demo(group: 'calendar')
Widget _buildLunar(BuildContext context) {
  return const _LunarCalendarDemo();
}

/// 农历内嵌 demo：外置控制栏驱动 [TCalendar.anchorDate] 滚动，点格走 [TCalendar.onChange]。
///
/// - 控制栏改月 / 选年选月 → 父级更新 [anchorDate]，日历滚到对应月
/// - 手指滑日历 → [onMonthChanged] 只同步控制栏文案，不写 anchor
/// - 点选日期 → [onChange] 回传选中；[initialValue] 仅首挂载生效
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

/// 农历 demo 外置控制栏（◀ 年 月 ▶）。
///
/// 切换操作经 [onNavigate] 交给父级写 [TCalendar.anchorDate]；
/// [currentMonth] 由父级传入，滑动日历时仅同步展示文案。
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
                child: Text('选择年份'),
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
                      onPressed: () => Navigator.pop(ctx, y),
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
                child: Text('选择月份'),
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
                      onPressed: isDisabled
                          ? null
                          : () => Navigator.pop(ctx, month),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$month月'),
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
    final theme = TTheme.of(context);
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
                    style: TextStyle(fontSize: 12, color: theme.fontGyColor2),
                  )
                : const SizedBox.shrink(),
          ),
          Row(
            children: [
              TButton(
                child: Text('◀'),
                size: TButtonSize.small,
                colorScheme: TButtonColorScheme.defaultTheme,
                disabled: !canPrev,
                onPressed: canPrev
                    ? () => _navigateTo(DateTime(
                        _currentMonth.year, _currentMonth.month - 1, 1))
                    : null,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TButton(
                  child: Text('${_currentMonth.year}年'),
                  size: TButtonSize.small,
                  colorScheme: TButtonColorScheme.defaultTheme,
                  onPressed: _pickYear,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TButton(
                  child: Text('${_currentMonth.month}月'),
                  size: TButtonSize.small,
                  colorScheme: TButtonColorScheme.defaultTheme,
                  onPressed: _pickMonth,
                ),
              ),
              const SizedBox(width: 4),
              TButton(
                child: Text('▶'),
                size: TButtonSize.small,
                colorScheme: TButtonColorScheme.defaultTheme,
                disabled: !canNext,
                onPressed: canNext
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
