import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 'multi_wheel_layout.dart';
import 'wheel_column.dart';

/// 整组禁用时的透明度
const double _kDisabledOpacity = 0.5;

/// 纯滚轮选择器组件。
///
/// 与 [`TCalendar`]、[`TDateTimePicker`] 为三个独立对外组件；[`TDateTimePicker`]
/// 经内部滚轮复用本组件能力，[`TCalendar`] 与本组件无代码耦合。
///
/// 不包含工具栏、确认按钮或内置 loading；弹窗场景请配合 [TPopup] 在用户确认后再提交。
///
/// 数据形态（编译期二选一）：
/// - [TPickerColumns]：多列独立，各列选项互不影响
/// - [TPickerLinked]：联动树，上游变更后下游列裁剪并按新分支展开，默认选中各列首项
///
/// [items] 相对上一帧值不相等时会释放全部 ScrollController 并重新初始化；
/// 内容相等的新实例不会触发重建。
///
/// ### 多列独立模式（[TPickerColumns]）数据更新契约
///
/// | 场景 | 推荐做法 | 避免 |
/// |------|----------|------|
/// | 列尾分页 append | 原地 `addAll` 或 immutable 追加；组件会走列增长路径 | 每帧回写 [initialValue] |
/// | 联动换子列 | 仅替换后续某一列；旧 controller 位置会被 clamp 到新列范围 | 双列全量替换导致主列 controller 重建 |
/// | 实时选中 | 由 [onChange] / 业务 draft 维护 | 用 [initialValue] 当滚动中的选中源 |
///
/// 多列独立模式下若仅为列尾追加，会原地刷新 [WheelColumn] 并保留当前滚动位置；
/// 若首列不变且仅后续某一列整列替换，则只刷新该列并保留首列 ScrollController。
///
/// [onChange] 在选中项变化时触发（惯性滚动中会多次回调），适合维护 draft；
/// `col` 为本次触发的列索引（0-based，从左到右），可用于按列响应；
/// 按需分页加载更推荐配合 [onColumnScrollEnd] 在滚动结束时判定是否接近列底。
///
/// 详细选型与能力边界见站点文档「Picker - 能力边界」。
///
/// ```dart
/// // 多列独立
/// TPicker(
///   items: TPickerColumns.fromRaw([['北京', '上海', '广州']]),
/// )
///
/// // 联动
/// TPicker(
///   items: TPickerLinked.fromRaw({'广东': {'深圳': ['南山', '福田']}}),
/// )
/// ```
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

  /// 数据源（必填）
  ///
  /// - **类型**：密封类 [TPickerItems]，编译期强制二选一
  /// - **多列独立**：[TPickerColumns] —— 各列候选项互不影响
  /// - **联动选择**：[TPickerLinked] —— 上游列变更后下游列自动裁剪并按新分支展开
  /// - **自由结构**：通过 `.fromRaw()` 工厂构造并自动归一化
  /// - **重建语义**：实例值与上一帧不等时整组重初始化；内容相等的新实例不重建
  final TPickerItems items;

  /// 初始选中值列表（按 `value` 匹配各列），仅在首次构建时生效。
  ///
  /// - **语义**：initState-only —— 仅首次构建生效，后续传入被忽略
  /// - **机制**：`FixedExtentScrollController` 拥有滚动位置所有权，频繁回灌会触发 `dispose+reinit`，破坏惯性滚动
  /// - **典型症状**：滚轮"每次只能滚 1 项"
  /// - **正确做法**：选中态用 [onChange] 维护 draft；"重置"时用 [Key] 强制重建；数据源变更时改 [items]
  final List<dynamic>? initialValue;

  /// 值改变回调（滚动时实时触发，不代表用户已确认选择）
  ///
  /// - **触发时机**：用户滚动经过 enabled 项时 / disabled 修正动画完成后
  /// - **频率**：多列独立模式下惯性滚动可能连续触发多次（每经过一项一次）；
  ///   联动模式同帧内合并为一次，且相同 [TPickerValue] 快照不会重复通知
  /// - **`col`**：本次触发的列索引（0-based）；联动模式下仅指用户手滚列
  /// - **`value`**：当前各列选中快照
  /// - **与 [onColumnScrollEnd] 关系**：两者独立、互不阻塞；同一次滚动可能先多次
  ///   [onChange] 再触发一次 [onColumnScrollEnd]（滚停时）
  /// - **典型用法**：维护 draft 状态 / 联动缓存
  /// - **分页加载**：更推荐 [onColumnScrollEnd] 在滚停后判定列底
  final void Function(int col, TPickerValue value)? onChange;

  /// 指定列滚动结束回调（惯性停止或手指抬起后）
  ///
  /// - **触发时机**：该列 [ScrollEndNotification] 到达时，每列独立
  /// - **`col`**：滚停的那一列索引
  /// - **`value`**：滚停时刻的各列选中快照（与最后一次 [onChange] 通常一致）
  /// - **与 [onChange] 关系**：两者独立；本回调仅在滚停时触发一次，适合分页加载
  /// - **典型用法**：判断 `value.indexes[col]` 是否接近列底并触发分页
  final void Function(int col, TPickerValue value)? onColumnScrollEnd;

  /// 滚轮视窗高度（像素），默认 200
  final double height;

  /// 每屏显示 item 数（奇数更利于中央高亮），默认 5
  final int itemCount;

  /// 是否禁用整个选择器（禁止滚动和操作），默认 false
  ///
  /// - **禁用态**：同时屏蔽无障碍手势与列级语义聚焦（`Semantics.enabled = false`）
  /// - **视觉**：组件整体叠加 `_kDisabledOpacity` 透明层
  final bool disabled;

  /// 自定义子项构建器
  ///
  /// - **不接管**：disabled 项仍由内部统一渲染，不会走此 builder
  /// - **典型用法**：emoji、单位、富文本、动态颜色等场景
  /// - **距离样式**：通过回调的 `itemDistanceCalculator` 参数复用 4 档默认颜色/字号
  final ItemBuilderType? itemBuilder;

  @override
  State<TPicker> createState() => _TPickerState();
}

class _TPickerState extends State<TPicker> {
  late bool _isLinked;
  late List<List<TPickerOption>> _columns;
  late List<FixedExtentScrollController> _controllers;

  /// 联动模式：每层选中的 value 路径（长度 == _columns.length）
  late List<dynamic> _selectedPath;

  /// 联动模式：每列对应的父级 Map，叶子列为 null（长度 == _columns.length）
  late List<Map<TPickerOption, dynamic>?> _mapStack;

  /// 用于命令式控制各列的 State
  late List<GlobalKey<WheelColumnState>> _columnKeys;

  /// 各列项数快照，用于在 [didUpdateWidget] 中检测"外部原地 `addAll`"——
  /// 此时 `oldWidget.items` 与 `widget.items` 共享同一 `List` 引用，
  /// 仅靠 `==` 比对会漏判；比较 `[i].length` 才能识别"列尾追加"路径。
  /// 也用于 `_trySwapDependentColumns` 中"哪些列实际未变"的快速筛选。
  List<int> _columnLengths = [];

  /// 联动刷新窗口内用户实际滚动的列索引；下游列 attach 触发的
  /// `onSelectedItemChanged` 应忽略，确保 [onChange] 的 `col` 仅来自用户手滚列。
  int? _linkedNotifyOriginCol;

  /// 联动模式：同帧内是否已排队 [onChange] 通知（合并多次选中事件）
  bool _linkedNotifyScheduled = false;

  /// 上次已通过 [onChange] 通知的快照；相同快照不重复回调
  TPickerValue? _lastNotifiedValue;

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
      _lastNotifiedValue = null;
      _disposeAllControllers();
      _initState();
    }
  }

  /// 多列独立模式：仅列尾追加时刷新 WheelColumn，保留 ScrollController 与选中位置。
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

  /// 多列独立模式：首列数据不变、仅后续某一列整列替换时，保留首列 ScrollController。
  ///
  /// 替换列的目标选中项：保留旧 controller 位置（clamp 到新列长度），避免业务
  /// 滚动过程中被任何外部"目标值"反向回写。这是 `initialValue` initState-only
  /// 语义的延伸：滚动位置的所有权在组件内部，不接受外部事后干预。
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

  /// 释放所有 scroll controller（不清理其它并列数组，由调用方负责）
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

  /// 构建滚轮主体（含禁用状态遮罩与中央高亮条）
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

  /// 无障碍手势：将指定列沿 [delta]（+1/-1）方向移动一格（严格单步，不跨
  /// disabled —— 与 Flutter `CupertinoPicker._handleIncrease` 同款契约）。
  /// 委托给 [WheelColumnState.nudge]；本方法无需 setState。
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

  /// H1 修复：当前列的无障碍 `value` 文案。
  ///
  /// 若当前选中项是 disabled（处于回弹动画过程中），回退到最近 enabled
  /// 项的 label —— 与 `_buildValue` 物理语义一致。
  ///
  /// 注：首次 build 时 `controller` 尚未 attach 到 ListWheelScrollView
  /// （`hasClients == false`），此时回退到首项 label，与 `WheelColumn.
  /// currentSelectedIndex` 同款防御。
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

  /// 严格 ±1 步进的预览文案（不跨 disabled）。越界返回 null。
  ///
  /// 同样在 controller 无 client 时回退到首项（与 `_a11yValue` 保持一致），
  /// 保证首屏 a11y 文本与视觉一致。
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

  /// 联动模式：下一帧再通知，同帧内多次选中事件合并为一次 [onChange]
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

  /// 联动刷新：变更 [col] 后，裁剪其下所有列并按新分支重新展开；
  /// 下游每一列均为新数据且默认选中首项（如切换第 1 级，其下所有下游列全部换新）。
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

  /// 裁剪 [col]+1 之后的所有列（释放 controllers 后移除并列数组尾部）
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

  /// 通用的联动列展开器：从给定的起点 options/parent 开始，把后续每一层都 push 进
  /// `_columns / _controllers / _selectedPath / _mapStack` 四个并列数组，直到叶子层。
  ///
  /// - [initialIdxAt] 决定当前 depth 下使用哪个 idx 作为初始选中项：
  ///   - 初始化场景：按 `widget.initialValue` 匹配
  ///   - 滚动刷新场景：固定返回 0（首项）
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

  /// 把一个 childData（来自 `Map[option]` 的取值结果）归一为下一列所需的
  /// options + parentMap；返回 null 表示不可构建下一列（空/非法/数据耗尽）。
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

  /// 读取当前选中态
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
    final value = _buildValue();
    if (_lastNotifiedValue == value) {
      return;
    }
    _lastNotifiedValue = value;
    widget.onChange?.call(col, value);
  }
}

/// 联动模式下一列的归一化结果 Record。
/// `options` 是该列候选项，`parentMap` 是该列的父级 Map（叶子列为 null）。
typedef _ChildColumn = ({
  List<TPickerOption> options,
  Map<TPickerOption, dynamic>? parentMap
});
