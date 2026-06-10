import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 'multi_wheel_layout.dart';
import 'wheel_column.dart';

// 整组禁用时的透明度
const double _kDisabledOpacity = 0.5;

/// 纯滚轮选择器。数据用 [TPickerColumns]（多列独立）或 [TPickerLinked]（联动）。
/// 选中变化通过 [onChange]；列底分页建议用 [onColumnScrollEnd]。弹窗确认请配合 [TPopup]。
class TPicker extends StatefulWidget {
  const TPicker({
    super.key,
    required this.items,
    this.initialValue,
    this.onChange,
    this.onColumnScrollEnd,
    this.height = 200,
    this.itemCount = 5,
    this.disabled = false,
    this.itemBuilder,
  });

  /// 数据源（必填）。独立选 [TPickerColumns]，内存联动树选 [TPickerLinked]；接口/字面量用对应 `fromRaw`。
  final TPickerItems items;

  /// 初始选中（按各列 `value` 匹配），仅首次构建生效；运行期请用 [onChange] 维护选中态。
  final List<dynamic>? initialValue;

  /// 值改变回调（滚动实时触发，非确认）。`col` 为触发列；`value` 为各列选中快照。
  final void Function(int col, TPickerValue value)? onChange;

  /// 列滚动结束回调（滚停时触发，适合列底分页）。`col` 为滚停列；`value` 为当前选中快照。
  final void Function(int col, TPickerValue value)? onColumnScrollEnd;

  /// 滚轮视窗高度（像素），默认 200
  final double height;

  /// 每屏显示项数（奇数更利于中央高亮），默认 5
  final int itemCount;

  /// 是否禁用整个选择器（禁止滚动与无障碍操作），默认 false
  final bool disabled;

  /// 自定义子项构建器 `(context, content, colIndex, index, itemDistanceCalculator, distance) => Widget?`；`distance` 为 0 表示选中项，返回 null 用默认样式，disabled 项不走此 builder。
  final ItemBuilderType? itemBuilder;

  @override
  State<TPicker> createState() => _TPickerState();
}

class _TPickerState extends State<TPicker> {
  late bool _isLinked;
  late List<List<TPickerOption>> _columns;
  late List<FixedExtentScrollController> _controllers;

  // 联动模式：每层选中的 value 路径
  late List<dynamic> _selectedPath;

  // 联动模式：每列对应的父级 Map，叶子列为 null
  late List<Map<TPickerOption, dynamic>?> _mapStack;

  // 命令式控制各列 WheelColumnState
  late List<GlobalKey<WheelColumnState>> _columnKeys;

  // 各列项数快照：检测原地 addAll（共享 List 引用时 == 漏判）及列替换筛选
  List<int> _columnLengths = [];

  // 联动刷新窗口内用户手滚列；屏蔽下游 attach 噪声，保证 onChange 的 col 语义
  int? _linkedNotifyOriginCol;

  // 联动模式：同帧 onChange 是否已排队（合并多次选中事件）
  bool _linkedNotifyScheduled = false;

  double get _itemHeight => widget.height / widget.itemCount;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  void didUpdateWidget(covariant TPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isLinked && widget.items is TPickerColumns) {
      final newCols = (widget.items as TPickerColumns).columns;
      if (_tryGrowColumns(newCols)) {
        return;
      }
      if (_trySwapDependentColumns(newCols)) {
        return;
      }
    }

    // initialValue 严格 initState-only：它在 didUpdateWidget 中不被读取，
    // 也**不**参与重建判断。即便父级回灌一个新 initialValue，TPicker 也不
    // 重建 controller —— 因为重建会 dispose 正在动画的 ScrollController，
    // 把滚轮钉死。这条约束让"onChange → setState → 父级重建"的反馈环
    // 不再破坏滚动惯性。
    //
    // 若需要"重置"语义，配合 `Key` 强制重建本组件；或修改 [items] 触发
    // 整组重建（合理的数据重置场景）。
    final itemsChanged = oldWidget.items != widget.items;
    if (itemsChanged) {
      _disposeAllControllers();
      _initState();
    }
  }

  // 多列独立：仅列尾追加时原地刷新列，保留 ScrollController
  bool _tryGrowColumns(List<List<TPickerOption>> newCols) {
    if (newCols.length != _columns.length ||
        _columnLengths.length != _columns.length) {
      return false;
    }

    var anyGrew = false;
    for (var i = 0; i < newCols.length; i++) {
      final prevLen = _columnLengths[i];
      final newCol = newCols[i];
      final newLen = newCol.length;
      if (newLen < prevLen) {
        return false;
      }
      if (newLen == prevLen) {
        if (!listEquals(_columns[i], newCol)) {
          return false;
        }
        continue;
      }
      if (!listEquals(_columns[i], newCol.sublist(0, prevLen))) {
        return false;
      }
      anyGrew = true;
    }

    if (!anyGrew) {
      return false;
    }

    setState(() {
      for (var i = 0; i < newCols.length; i++) {
        _columns[i] = newCols[i];
        _columnLengths[i] = newCols[i].length;
        _columnKeys[i].currentState?.applyColumnUpdate(
          options: newCols[i],
          controller: _controllers[i],
        );
      }
    });
    return true;
  }

  // 多列独立：首列不变、仅后续列整列替换时保留首列 ScrollController
  bool _trySwapDependentColumns(List<List<TPickerOption>> newCols) {
    if (_columns.isEmpty ||
        newCols.length != _columns.length ||
        _columnLengths.length != _columns.length ||
        _columns.length < 2) {
      return false;
    }

    if (!listEquals(_columns[0], newCols[0])) {
      return false;
    }

    var changedCol = -1;
    for (var i = 1; i < newCols.length; i++) {
      if (listEquals(_columns[i], newCols[i])) {
        continue;
      }
      if (changedCol >= 0) {
        return false;
      }
      changedCol = i;
    }

    if (changedCol < 0) {
      return false;
    }

    final newCol = newCols[changedCol];
    if (newCol.isEmpty) {
      return false;
    }

    // 始终保留旧 controller 位置，clamp 到新列范围
    final targetIndex = _controllers[changedCol]
        .selectedItem
        .clamp(0, newCol.length - 1);

    final jumpIndex = targetIndex;
    setState(() {
      _columns[changedCol] = newCol;
      _columnLengths[changedCol] = newCol.length;
      _columnKeys[changedCol].currentState?.applyColumnUpdate(
        options: newCol,
        controller: _controllers[changedCol],
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final c = _controllers[changedCol];
      final idx = jumpIndex.clamp(0, newCol.length - 1);
      if (c.selectedItem != idx) {
        c.jumpToItem(idx);
      }
    });
    return true;
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  // 释放所有 scroll controller（不清理其它并列数组，由调用方负责）
  void _disposeAllControllers() {
    for (final c in _controllers) {
      c.dispose();
    }
  }

  void _initState() {
    _columns = [];
    _controllers = [];
    _selectedPath = [];
    _mapStack = [];
    _columnKeys = [];
    _columnLengths = [];

    switch (widget.items) {
      case TPickerColumns(:final columns):
        _isLinked = false;
        _initColumns(columns);
      case TPickerLinked(:final tree):
        _isLinked = true;
        _initLinked(tree);
    }
  }

  void _initColumns(List<List<TPickerOption>> columns) {
    _columns = columns;
    _columnLengths = columns.map((c) => c.length).toList();
    _columnKeys = List.generate(columns.length, (_) => GlobalKey());

    final initValues = widget.initialValue;
    _controllers = List.generate(_columns.length, (i) {
      var index = 0;
      if (initValues != null && i < initValues.length) {
        final targetIdx =
            _columns[i].indexWhere((o) => o.value == initValues[i]);
        if (targetIdx >= 0) {
          index = targetIdx;
        }
      }
      return FixedExtentScrollController(initialItem: index);
    });
  }

  void _initLinked(Map<TPickerOption, dynamic> tree) {
    final options = tree.keys.toList();
    if (options.isEmpty) {
      return;
    }
    // 初始化时：每列的初始选中 idx 由 widget.initialValue 决定
    final initValues = widget.initialValue ?? const <dynamic>[];
    _appendLinkedColumns(
      firstOptions: options,
      firstParent: tree,
      initialIdxAt: (depth, opts) {
        if (depth >= initValues.length) {
          return 0;
        }
        final found = opts.indexWhere((o) => o.value == initValues[depth]);
        return found >= 0 ? found : 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWheel(context);
  }

  Widget _buildWheel(BuildContext context) {
    return Semantics(
      // container: true 让本节点作为容器（语义不向下合并到 wheelColumn 子树）；
      // explicitChildNodes: true 阻止列 Semantics 向上合并到本节点 label，
      // 否则单列场景下 "选择器" 与 "第 1 列" 会被合并成同一 label。
      container: true,
      explicitChildNodes: true,
      enabled: !widget.disabled,
      label: context.resource.picker,
      child: Opacity(
        opacity: widget.disabled ? _kDisabledOpacity : 1.0,
        child: AbsorbPointer(
          absorbing: widget.disabled,
          child: MultiWheelLayout(
            height: widget.height,
            itemHeight: _itemHeight,
            columns: [
              for (var i = 0; i < _controllers.length; i++)
                _buildColumn(context, i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, int colIndex) {
    final data = _columns[colIndex];
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }
    // 列的 a11y 包装放在父组件（TPicker）：H1 修复 + 严格 ±1 nudge 入口
    // 在此计算与暴露，WheelColumn 只负责纯渲染。ListenableBuilder 让
    // a11y value/preview 跟随 controller 滚动更新。
    return ListenableBuilder(
      listenable: _controllers[colIndex],
      builder: (context, _) {
        final value = _a11yValue(colIndex);
        final inc = _a11yPreviewValue(colIndex, 1);
        final dec = _a11yPreviewValue(colIndex, -1);
        return Semantics(
          // container + explicitChildNodes 阻止列 label 与外层 "选择器"
          // label 合并；excludeSemantics 屏蔽列内 TText 节点。
          container: true,
          explicitChildNodes: true,
          enabled: !widget.disabled,
          label: context.resource.pickerColumn(colIndex + 1),
          value: value,
          onIncrease: !widget.disabled && inc != null
              ? () => _nudgeColumn(colIndex, 1)
              : null,
          increasedValue: inc ?? '',
          onDecrease: !widget.disabled && dec != null
              ? () => _nudgeColumn(colIndex, -1)
              : null,
          decreasedValue: dec ?? '',
          child: ExcludeSemantics(
            child: WheelColumn(
              key: _columnKeys[colIndex],
              colIndex: colIndex,
              options: data,
              controller: _controllers[colIndex],
              itemHeight: _itemHeight,
              disabled: widget.disabled,
              itemBuilder: widget.itemBuilder,
              onItemSelected: (col, index, _) => _onColumnItemSelected(col, index),
              onScrollEnd: _onColumnScrollEnd,
              onAnimationComplete: (col, index, _) =>
                  _onColumnAnimationComplete(col, index),
            ),
          ),
        );
      },
    );
  }

  // 无障碍手势：严格 ±1 步进，委托 WheelColumnState.nudge
  void _nudgeColumn(int col, int delta) {
    if (widget.disabled) {
      return;
    }
    if (col < 0 || col >= _columnKeys.length) {
      return;
    }
    final state = _columnKeys[col].currentState;
    if (state == null) {
      return;
    }
    state.nudge(delta);
  }

  // 当前列无障碍 value；disabled 落点回退到最近 enabled 项
  String _a11yValue(int colIndex) {
    final data = _columns[colIndex];
    if (data.isEmpty) {
      return '';
    }
    final c = _controllers[colIndex];
    final idx = c.hasClients
        ? c.selectedItem.clamp(0, data.length - 1)
        : 0;
    if (!data[idx].disabled) {
      return data[idx].label;
    }
    final nearest = WheelColumnState.nearestEnabledIndex(data, idx);
    if (nearest < 0) {
      return data[idx].label;
    }
    return data[nearest].label;
  }

  // 严格 ±1 步进的 a11y 预览文案，越界返回 null
  String? _a11yPreviewValue(int colIndex, int delta) {
    final data = _columns[colIndex];
    if (data.isEmpty) {
      return null;
    }
    final c = _controllers[colIndex];
    final idx = c.hasClients
        ? c.selectedItem.clamp(0, data.length - 1)
        : 0;
    final next = idx + delta;
    if (next < 0 || next >= data.length) {
      return null;
    }
    return data[next].label;
  }

  bool _onColumnScrollEnd(
    ScrollNotification notification,
    int col,
    List<TPickerOption> data,
  ) {
    if (notification is ScrollEndNotification && !widget.disabled) {
      widget.onColumnScrollEnd?.call(col, _buildValue());
    }
    return false;
  }

  void _onColumnItemSelected(int col, int index) {
    final data = _columns[col];
    // 滚动过程中经过 disabled 不立刻修正，等 WheelColumn scroll end 再处理
    if (data[index].disabled) {
      return;
    }

    if (_isLinked) {
      // 联动刷新期间：吞掉 origin 列下游 attach 触发的选中事件
      if (_linkedNotifyOriginCol != null && col > _linkedNotifyOriginCol!) {
        return;
      }
      _linkedNotifyOriginCol = col;
      _refreshLinked(col, index);
      _scheduleLinkedNotify();
    } else {
      _notifyChange(col);
    }
  }

  // 联动模式：下一帧再通知，同帧合并为一次 onChange
  void _scheduleLinkedNotify() {
    if (_linkedNotifyScheduled) {
      return;
    }
    _linkedNotifyScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _linkedNotifyScheduled = false;
      if (!mounted) {
        return;
      }
      final notifyCol = _linkedNotifyOriginCol;
      _linkedNotifyOriginCol = null;
      if (notifyCol != null) {
        _notifyChange(notifyCol);
      }
    });
  }

  void _onColumnAnimationComplete(int col, int index) {
    if (_isLinked &&
        _linkedNotifyOriginCol != null &&
        col > _linkedNotifyOriginCol!) {
      return;
    }
    // 动画完成后触发 onChange
    _notifyChange(col);
  }

  // 联动刷新：裁剪下游列并按新分支展开，默认选中各列首项
  void _refreshLinked(int col, int newIndex) {
    setState(() {
      final selectedOpt = _columns[col][newIndex];
      _selectedPath[col] = selectedOpt.value;

      // 裁剪 col+1 之后的所有列（释放 controllers，再裁剪所有并列数组）
      _disposeColumnsAfter(col);

      // 从当前列向下递归展开所有剩余列（与初始化共用同一展开逻辑）
      // _mapStack[col] 即为当前列的父级 Map，option 可直接作为 key 查子数据
      final parentMap = _mapStack[col];
      if (parentMap == null) {
        return; // 叶子列，无需下钻
      }
      final next = _resolveChildColumn(parentMap[selectedOpt]);
      if (next != null) {
        _appendLinkedColumns(
          firstOptions: next.options,
          firstParent: next.parentMap,
          initialIdxAt: (_, __) => 0, // 滚动联动：新展开的列默认选中首项
        );
      }
    });
  }

  void _disposeColumnsAfter(int col) {
    if (col >= _columns.length - 1) {
      return;
    }
    for (var i = col + 1; i < _controllers.length; i++) {
      _controllers[i].dispose();
    }
    _columns.removeRange(col + 1, _columns.length);
    _controllers.removeRange(col + 1, _controllers.length);
    _selectedPath.removeRange(col + 1, _selectedPath.length);
    _mapStack.removeRange(col + 1, _mapStack.length);
    _columnKeys.removeRange(col + 1, _columnKeys.length);
  }

  // 联动列展开：从起点递归 push 各层，直到叶子
  void _appendLinkedColumns({
    required List<TPickerOption> firstOptions,
    required Map<TPickerOption, dynamic>? firstParent,
    required int Function(int depth, List<TPickerOption> options) initialIdxAt,
  }) {
    var options = firstOptions;
    var parentMap = firstParent;

    while (true) {
      final depth = _columns.length;
      final idx = initialIdxAt(depth, options);
      final safeIdx = (idx >= 0 && idx < options.length) ? idx : 0;

      // push 当前列
      _columns.add(options);
      _controllers.add(FixedExtentScrollController(initialItem: safeIdx));
      _mapStack.add(parentMap);
      _selectedPath.add(options[safeIdx].value);
      _columnKeys.add(GlobalKey());

      // 已是叶子，无需再下钻
      if (parentMap == null) {
        break;
      }

      // 向下查子数据
      final next = _resolveChildColumn(parentMap[options[safeIdx]]);
      if (next == null) {
        break;
      }
      options = next.options;
      parentMap = next.parentMap;
    }
  }

  _ChildColumn? _resolveChildColumn(dynamic childData) {
    if (childData is Map<TPickerOption, dynamic>) {
      if (childData.isEmpty) {
        return null;
      }
      return (options: childData.keys.toList(), parentMap: childData);
    }
    if (childData is List<TPickerOption>) {
      if (childData.isEmpty) {
        return null;
      }
      return (options: childData, parentMap: null); // 叶子列
    }
    return null;
  }

  TPickerValue _buildValue() {
    final selectedOptions = <TPickerOption>[];
    final indexes = <int>[];

    for (var i = 0; i < _controllers.length; i++) {
      final column = _columns[i];
      if (column.isEmpty) {
        continue;
      }
      var idx = _controllers[i].selectedItem.clamp(0, column.length - 1);
      // disabled 项就地修正到最近 enabled（找不到则保持原位）
      if (column[idx].disabled) {
        final fixed = WheelColumnState.nearestEnabledIndex(column, idx);
        if (fixed >= 0) {
          idx = fixed;
        }
      }
      indexes.add(idx);
      selectedOptions.add(column[idx]);
    }

    return TPickerValue(selectedOptions: selectedOptions, indexes: indexes);
  }

  void _notifyChange(int col) {
    widget.onChange?.call(col, _buildValue());
  }
}

/// 联动模式下一列的归一化结果 Record。
/// `options` 是该列候选项，`parentMap` 是该列的父级 Map（叶子列为 null）。
typedef _ChildColumn = ({
  List<TPickerOption> options,
  Map<TPickerOption, dynamic>? parentMap
});
