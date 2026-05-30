import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'no_wave_behavior.dart';

// =============== 文件级常量（魔法数字归一） ===============

/// disabled 项修正动画 - 距离 ≤ 2 时的时长
const int _kCorrectAnimShortMs = 200;

/// disabled 项修正动画 - 距离 > 2 时的时长
const int _kCorrectAnimLongMs = 350;

/// 距离阈值：≤ 2 使用短动画，> 2 使用长动画
const int _kCorrectAnimDistanceThreshold = 2;

/// 滚轮透视比例（越大越平）
const double _kWheelDiameterRatio = 3;

/// 整组禁用时的透明度
const double _kDisabledOpacity = 0.5;

/// 纯滚轮选择器组件
///
/// 数据决定形态（编译期类型安全）：
/// - [TPickerColumns] → 多列独立选择
/// - [TPickerLinked] → 联动选择
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
    this.height = 200,
    this.itemCount = 5,
    this.disabled = false,
    this.itemBuilder,
  });

  /// 数据源（必填）
  ///
  /// 使用密封类 [TPickerItems] 编译期强制二选一：
  /// - [TPickerColumns] → 多列独立选择
  /// - [TPickerLinked] → 联动选择
  ///
  /// 自由结构数据通过 `.fromRaw()` 工厂构造归一化。
  final TPickerItems items;

  /// 初始选中值列表（按 value 匹配）
  final List<dynamic>? initialValue;

  /// 值改变回调（滚动时实时触发）
  ///
  /// 触发时机：
  /// - 用户滚动经过某个 enabled 项并稳定时
  /// - disabled 修正动画完成后，回调最终落点
  ///
  /// **注意**：此回调代表"滚动时实时变化"，不代表"用户已确认选择"。
  /// 弹窗场景请配合 [TPopup] 头部确认按钮，在关闭前读取 draft 值提交。
  ///
  /// 如需做网络请求/埋点等去抖处理，请在业务层自行 debounce。
  ///
  /// 按需加载更多：在回调里根据 [TPickerValue.indexes] 判断是否接近列底，
  /// 请求完成后更新 [items] 即可（无需组件内置加载 API）。
  final void Function(TPickerValue)? onChange;

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
  late List<List<TPickerOption>> _columns;
  late List<FixedExtentScrollController> _controllers;
  /// 联动模式：每层选中的 value 路径（长度 == _columns.length）
  late List<dynamic> _selectedPath;
  /// 联动模式：每列对应的父级 Map，叶子列为 null（长度 == _columns.length）
  late List<Map<TPickerOption, dynamic>?> _mapStack;
  /// 标记某列正在动画修正中，防止重复触发
  final Set<int> _animatingCols = {};
  /// 复用同一实例，避免每次 _buildColumn 都 new
  final _scrollBehavior = NoWaveBehavior();

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
    _animatingCols.clear();

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

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: _scrollBehavior,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, colIndex, data),
          child: ListWheelScrollView.useDelegate(
            itemExtent: _itemHeight,
            diameterRatio: _kWheelDiameterRatio,
            controller: _controllers[colIndex],
            physics: widget.disabled
                ? const NeverScrollableScrollPhysics()
                : const FixedExtentScrollPhysics(),
            onSelectedItemChanged: widget.disabled
                ? null
                : (index) => _onItemSelected(colIndex, index, data),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: data.length,
              builder: (_, index) => TItemWidget(
                content: data[index].label,
                fixedExtentScrollController: _controllers[colIndex],
                colIndex: colIndex,
                index: index,
                itemHeight: _itemHeight,
                disabled: data[index].disabled,
                itemBuilder: widget.itemBuilder,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _onScrollNotification(
      ScrollNotification notification, int col, List<TPickerOption> data) {
    // 仅处理"滚动结束"事件
    if (notification is! ScrollEndNotification) {
      return false;
    }

    final controller = _controllers[col];
    final currentIndex = controller.selectedItem;

    // 当前位置越界或非 disabled 项：无需修正
    if (currentIndex < 0 ||
        currentIndex >= data.length ||
        !data[currentIndex].disabled) {
      return false;
    }

    final target = _nearestEnabled(data, currentIndex);
    // 找不到可用项或目标就是自己：无需修正
    if (target < 0 || target == currentIndex) {
      return false;
    }

    // 同一列若已在修正动画中，跳过
    if (!_animatingCols.add(col)) {
      return false;
    }

    _animateCorrect(col, data, currentIndex, target);
    return false;
  }

  /// 把某列从 [from] 动画滚动到 [to]，并在动画完成后派发 [TPicker.onChange]
  void _animateCorrect(
      int col, List<TPickerOption> data, int from, int to) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final c = _controllers[col];

      // 动画调度到这一帧前，用户可能已经手动滚到 enabled 项了
      final newIndex = c.selectedItem;
      if (newIndex >= 0 && newIndex < data.length && !data[newIndex].disabled) {
        _animatingCols.remove(col);
        return;
      }

      final distance = (to - from).abs();
      final ms = distance <= _kCorrectAnimDistanceThreshold
          ? _kCorrectAnimShortMs
          : _kCorrectAnimLongMs;
      c
          .animateToItem(
        to,
        duration: Duration(milliseconds: ms),
        curve: Curves.easeOutCubic,
      )
          .then((_) {
        if (mounted) {
          _animatingCols.remove(col);
          _notifyChange();
        }
      }).catchError((Object e, StackTrace stack) {
        debugPrint('TPicker animation interrupted: $e');
        _animatingCols.remove(col);
      });
    });
  }

  void _onItemSelected(int col, int index, List<TPickerOption> data) {
    if (data[index].disabled) {
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

  /// 从 [start] 出发双向搜索最近一个 enabled 索引，全 disabled 时返回 -1
  ///
  /// 双向同时推进，先命中者胜出；若同距离，偏向前向。
  int _nearestEnabled(List<TPickerOption> data, int start) {
    for (var step = 1; step < data.length; step++) {
      final forward = start + step;
      if (forward < data.length && !data[forward].disabled) {
        return forward;
      }
      final backward = start - step;
      if (backward >= 0 && !data[backward].disabled) {
        return backward;
      }
    }
    return -1;
  }

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

  /// 读取当前选中态，disabled 项就地修正到最近 enabled
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
        final fixed = _nearestEnabled(column, idx);
        if (fixed >= 0) {
          idx = fixed;
        }
      }
      indexes.add(idx);
      selectedOptions.add(column[idx]);
    }

    return TPickerValue(selectedOptions: selectedOptions, indexes: indexes);
  }

  void _notifyChange() {
    widget.onChange?.call(_buildValue());
  }
}

/// 联动模式下一列的归一化结果 Record。
/// `options` 是该列候选项，`parentMap` 是该列的父级 Map（叶子列为 null）。
typedef _ChildColumn = ({List<TPickerOption> options, Map<TPickerOption, dynamic>? parentMap});
