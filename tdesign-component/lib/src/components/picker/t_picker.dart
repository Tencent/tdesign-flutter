import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'picker_item.dart';
import 'wheel_column.dart';
import '../../../tdesign_flutter.dart';

/// 整组禁用时的透明度
const double _kDisabledOpacity = 0.5;

/// 纯滚轮选择器组件
///
/// 不包含工具栏、确认按钮或内置 loading；弹窗场景请配合 [TPopup] 在用户确认后再提交。
///
/// 数据形态（编译期二选一）：
/// - [PickerColumns]：多列独立，各列选项互不影响
/// - [PickerLinked]：联动树，上游变更后下游列裁剪并按新分支展开，默认选中各列首项
///
/// [items] 或 [initialValue] 相对上一帧值不相等时会释放全部 ScrollController 并重新初始化；
/// 内容相等的新实例不会触发重建。分页追加后请同步更新 [initialValue] 以恢复选中。
///
/// [onChange] 为滚动实时回调，不代表用户已确认；如需去抖请在业务层自行处理。
///
/// 详细选型与能力边界见站点文档「Picker - 能力边界」。
///
/// ```dart
/// // 多列独立
/// TPicker(
///   items: PickerColumns.fromRaw([['北京', '上海', '广州']]),
/// )
///
/// // 联动
/// TPicker(
///   items: PickerLinked.fromRaw({'广东': {'深圳': ['南山', '福田']}}),
/// )
/// ```
class TPicker extends StatefulWidget {
  const TPicker({
    super.key,
    required this.items,
    this.initialValue,
    this.onChange,
    this.height = 200,
    this.itemCount = 5,
    this.disabled = false,
    this.itemBuilder,
  });

  /// 数据源（必填）
  ///
  /// 使用密封类 [PickerItems] 编译期强制二选一：
  /// - [PickerColumns] → 多列独立选择
  /// - [PickerLinked] → 联动选择
  ///
  /// 自由结构数据通过 `.fromRaw()` 工厂构造归一化。
  ///
  /// 相对上一帧值不相等时会触发组件重新初始化；内容相等的新实例不会重建。
  final PickerItems items;

  /// 初始选中值列表（按 value 匹配各列）
  ///
  /// 与 [items] 一并参与重建判断：相对上一帧值不相等时会重新初始化。
  final List<dynamic>? initialValue;

  /// 值改变回调（滚动时实时触发）
  ///
  /// 触发时机：
  /// - 用户滚动经过某个 enabled 项并稳定时
  /// - disabled 修正动画完成后，回调最终落点
  ///
  /// 注意：此回调代表滚动时实时变化，不代表用户已确认选择。
  /// 弹窗场景请配合 [TPopup] 头部确认按钮，在关闭前读取 draft 值提交。
  ///
  /// 如需做网络请求/埋点等去抖处理，请在业务层自行 debounce。
  ///
  /// 按需加载更多：在回调里根据 [PickerValue.indexes] 判断是否接近列底，
  /// 请求完成后更新 [items] 即可（无需组件内置加载 API）。
  final void Function(PickerValue)? onChange;

  /// 视窗高度，默认 200
  final double height;

  /// 每屏显示 item 数，默认 5
  final int itemCount;

  /// 是否禁用整个选择器（禁止滚动和操作），默认 false
  final bool disabled;

  /// 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder）
  final ItemBuilderType? itemBuilder;

  @override
  State<TPicker> createState() => _TPickerState();
}

class _TPickerState extends State<TPicker> {
  late bool _isLinked;
  late List<List<PickerOption>> _columns;
  late List<FixedExtentScrollController> _controllers;

  /// 联动模式：每层选中的 value 路径（长度 == _columns.length）
  late List<dynamic> _selectedPath;

  /// 联动模式：每列对应的父级 Map，叶子列为 null（长度 == _columns.length）
  late List<Map<PickerOption, dynamic>?> _mapStack;

  /// 用于命令式控制各列的 State
  late List<GlobalKey<WheelColumnState>> _columnKeys;

  double get _itemHeight => widget.height / widget.itemCount;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  void didUpdateWidget(covariant TPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final itemsChanged = oldWidget.items != widget.items;
    final initChanged =
        !listEquals(oldWidget.initialValue, widget.initialValue);
    if (itemsChanged || initChanged) {
      _disposeAllControllers();
      _initState();
    }
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

    switch (widget.items) {
      case PickerColumns(:final columns):
        _isLinked = false;
        _initColumns(columns);
      case PickerLinked(:final tree):
        _isLinked = true;
        _initLinked(tree);
    }
  }

  void _initColumns(List<List<PickerOption>> columns) {
    _columns = columns;
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

  void _initLinked(Map<PickerOption, dynamic> tree) {
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
    return _buildWheel(context, TTheme.of(context));
  }

  /// 构建滚轮主体（含禁用状态遮罩与中央高亮条）
  Widget _buildWheel(BuildContext context, TThemeData theme) {
    return Opacity(
      opacity: widget.disabled ? _kDisabledOpacity : 1.0,
      child: AbsorbPointer(
        absorbing: widget.disabled,
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 中央选中行高亮背景
              Positioned(
                top: (widget.height - _itemHeight) / 2,
                left: theme.spacer16,
                right: theme.spacer16,
                child: Container(
                  height: _itemHeight,
                  decoration: BoxDecoration(
                    color: theme.bgColorSecondaryContainer,
                    borderRadius: BorderRadius.circular(theme.radiusDefault),
                  ),
                ),
              ),
              // 各列滚轮
              Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacer32),
                child: Row(
                  children: [
                    for (var i = 0; i < _controllers.length; i++)
                      Expanded(child: _buildColumn(i)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(int colIndex) {
    final data = _columns[colIndex];
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExcludeSemantics(
      child: WheelColumn(
        key: _columnKeys[colIndex],
        colIndex: colIndex,
        options: data,
        controller: _controllers[colIndex],
        itemHeight: _itemHeight,
        disabled: false,
        itemBuilder: widget.itemBuilder,
        onItemSelected: (col, index, _) => _onColumnItemSelected(col, index),
        onAnimationComplete: (col, index, _) =>
            _onColumnAnimationComplete(col, index),
      ),
    );
  }

  void _onColumnItemSelected(int col, int index) {
    final data = _columns[col];
    if (data[index].disabled) {
      // 触发 WheelColumn 的禁用项修正动画
      _columnKeys[col].currentState?.animateToNearestEnabled();
      return;
    }

    if (_isLinked) {
      _refreshLinked(col, index);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _notifyChange();
        }
      });
    } else {
      _notifyChange();
    }
  }

  void _onColumnAnimationComplete(int col, int index) {
    // 动画完成后触发 onChange
    _notifyChange();
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
    required List<PickerOption> firstOptions,
    required Map<PickerOption, dynamic>? firstParent,
    required int Function(int depth, List<PickerOption> options) initialIdxAt,
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
    if (childData is Map<PickerOption, dynamic>) {
      if (childData.isEmpty) {
        return null;
      }
      return (options: childData.keys.toList(), parentMap: childData);
    }
    if (childData is List<PickerOption>) {
      if (childData.isEmpty) {
        return null;
      }
      return (options: childData, parentMap: null); // 叶子列
    }
    return null;
  }

  /// 读取当前选中态
  PickerValue _buildValue() {
    final selectedOptions = <PickerOption>[];
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

    return PickerValue(selectedOptions: selectedOptions, indexes: indexes);
  }

  void _notifyChange() {
    widget.onChange?.call(_buildValue());
  }
}

/// 联动模式下一列的归一化结果 Record。
/// `options` 是该列候选项，`parentMap` 是该列的父级 Map（叶子列为 null）。
typedef _ChildColumn = ({
  List<PickerOption> options,
  Map<PickerOption, dynamic>? parentMap
});
