import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 'no_wave_behavior.dart';

// =============== 文件级常量（魔法数字归一） ===============

/// 工具栏高度（px）
const double _kToolbarHeight = 48;

/// 按钮按压态动画时长
const Duration _kPressAnimDuration = Duration(milliseconds: 100);

/// 按钮按压态透明度
const double _kPressedOpacity = 0.5;

/// disabled 项修正动画 - 距离 ≤ 2 时的时长
const int _kCorrectAnimShortMs = 200;

/// disabled 项修正动画 - 距离 > 2 时的时长
const int _kCorrectAnimLongMs = 350;

/// 距离阈值：≤ 2 使用短动画，> 2 使用长动画
const int _kCorrectAnimDistanceThreshold = 2;

/// 滚轮透视比例（越大越平）
const double _kWheelDiameterRatio = 3;

/// 默认字号（fontTitleMedium fallback）
const double _kDefaultFontSize = 16;

/// 默认图标大小
const double _kDefaultIconSize = 22;

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
    this.onLoad,
    this.height = 200,
    this.itemCount = 5,
    this.disabled = false,
    this.itemBuilder,
    this.itemDistanceCalculator,
    this.title,
    this.cancel,
    this.confirm,
    this.titleWidget,
    this.onCancel,
    this.onConfirm,
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
  /// 如需"已确认"语义，请使用 [onConfirm]。
  ///
  /// 如需做网络请求/埋点等去抖处理，请在业务层自行 debounce。
  final void Function(TPickerValue)? onChange;

  /// 列选中项变化的事件回调
  ///
  /// **触发时机**：每次用户滚动到一个 enabled 项后都会触发（联动模式下还会
  /// 在新展开的列就位后触发）。组件本身不做"距底部多少项"的阈值判断——把
  /// 决策权交给业务层。
  ///
  /// **事件参数**包含：
  /// - [TPickerLoadEvent.column]：触发列索引
  /// - [TPickerLoadEvent.remaining]：当前列距底部剩余项数
  /// - [TPickerLoadEvent.displayedCount]：当前列总项数
  /// - [TPickerLoadEvent.parentValue]：联动模式下父级选中值（首列为 null）
  ///
  /// **典型用法**：业务层根据 [TPickerLoadEvent.remaining] 自行判断是否加载更多。
  /// ```dart
  /// onLoad: (e) async {
  ///   if (e.remaining > 5 || _isLoading) return; // 距底部还远 / 已在加载，跳过
  ///   _isLoading = true;
  ///   final more = await fetchMore(parent: e.parentValue);
  ///   setState(() {
  ///     _data.addAll(more);
  ///     _isLoading = false;
  ///   });
  /// }
  /// ```
  final void Function(TPickerLoadEvent)? onLoad;

  /// 视窗高度，默认 200
  final double height;

  /// 每屏显示 item 数，默认 5
  final int itemCount;

  /// 是否禁用整个选择器（禁止滚动和操作），默认 false
  final bool disabled;

  /// 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder）
  final ItemBuilderType? itemBuilder;

  /// 自定义距离计算器（控制颜色/字重/字号随"离中心距离"的变化）
  final ItemDistanceCalculator? itemDistanceCalculator;

  /// 工具栏中部标题（可选，不传时中部留白）
  ///
  /// 顶部工具栏永远显示，包含「取消」「标题」「确认」三块。
  /// 用户点击「取消」触发 [onCancel]，点击「确认」触发 [onConfirm]。
  /// 选择器与弹窗（popup）完全解耦——关闭/打开弹窗的逻辑由业务层在
  /// 这两个回调中自行控制。
  ///
  /// 典型用法（与 popup 弹窗组合）：
  /// ```dart
  /// TPicker(
  ///   items: items,
  ///   title: '请选择地区',
  ///   onCancel: () => setState(() => visible = false),
  ///   onConfirm: (value) {
  ///     setState(() {
  ///       selected = value;
  ///       visible = false;
  ///     });
  ///   },
  /// )
  /// ```
  final String? title;

  /// 工具栏左侧自定义插槽，默认使用 [TResourceDelegate.cancel]
  ///
  /// 可用于渲染图标、图标+文字组合等。点击事件依然由外层 [GestureDetector]
  /// 处理，触发 [onCancel] 回调——所以插槽内的 Widget 不需要自己处理点击。
  ///
  /// ```dart
  /// // 简单改文字
  /// TPicker(
  ///   cancel: const Text('关闭'),
  ///   onCancel: () => Navigator.of(context).pop(),
  /// )
  ///
  /// // 带图标
  /// TPicker(
  ///   cancel: const Icon(Icons.close, size: 22),
  ///   onCancel: () => Navigator.of(context).pop(),
  /// )
  /// ```
  final Widget? cancel;

  /// 工具栏右侧自定义插槽，默认使用 [TResourceDelegate.confirm]
  ///
  /// 可用于渲染图标、图标+文字组合等。点击事件依然由外层 [GestureDetector]
  /// 处理，触发 [onConfirm] 回调——所以插槽内的 Widget 不需要自己处理点击。
  ///
  /// ```dart
  /// // 简单改文字
  /// TPicker(
  ///   confirm: const Text('确定'),
  ///   onConfirm: (v) => Navigator.of(context).pop(v),
  /// )
  ///
  /// // 带图标
  /// TPicker(
  ///   confirm: const Icon(Icons.check, size: 22),
  ///   onConfirm: (v) => Navigator.of(context).pop(v),
  /// )
  /// ```
  final Widget? confirm;

  /// 工具栏中部自定义标题插槽
  ///
  /// 传入后会**完全替换**默认的 [title] 文字，可用于渲染更复杂的标题（副标题、图标+文字等）。
  /// 标题区域不响应点击。
  final Widget? titleWidget;

  /// 点击「取消」按钮回调
  ///
  /// 仅作为点击事件通知，不携带任何参数。组件本身不会做任何 popup
  /// 操作，业务层可在此自行决定是否关闭弹窗、重置状态等。
  final VoidCallback? onCancel;

  /// 点击「确认」按钮回调
  ///
  /// 携带当前选中的完整 [TPickerValue]，包含：
  /// - `selectedOptions`: 当前选中的所有 [TPickerOption]
  /// - `values`: 各列选中项的 value 列表
  /// - `labels`: 各列选中项的 label 列表
  /// - `indexes`: 各列选中项的索引
  ///
  /// 与 [onChange] 不同——只有用户点击「确认」时才触发，代表"已确认选择"。
  /// 组件本身不会做任何 popup 操作，业务层可在此自行决定是否关闭弹窗、
  /// 提交表单等。
  final void Function(TPickerValue)? onConfirm;

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

  /// 工具栏按钮按压态（参考 TCheckbox 的反馈方式）
  bool _cancelPressed = false;
  bool _confirmPressed = false;

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
    final theme = TTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToolbar(theme),
        _buildWheel(context, theme),
      ],
    );
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

  /// 构建顶部工具栏（取消 / 标题 / 确认）
  Widget _buildToolbar(TThemeData theme) {
    final cancelText = widget.cancel ?? Text(context.resource.cancel);
    final confirmText = widget.confirm ?? Text(context.resource.confirm);
    return SizedBox(
      height: _kToolbarHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacer16),
        child: Row(
          children: [
            _buildToolbarButton(
              theme: theme,
              pressed: _cancelPressed,
              onPressChange: (v) => setState(() => _cancelPressed = v),
              onTap: () => widget.onCancel?.call(),
              defaultColor: theme.fontGyColor2,
              child: cancelText,
            ),
            Expanded(
              child: Center(child: _buildTitle(theme)),
            ),
            _buildToolbarButton(
              theme: theme,
              pressed: _confirmPressed,
              onPressChange: (v) => setState(() => _confirmPressed = v),
              onTap: () => widget.onConfirm?.call(_buildValue()),
              defaultColor: theme.brandNormalColor,
              child: confirmText,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建工具栏标题（优先自定义 [TPicker.titleWidget]，其次 [TPicker.title] 文字）
  Widget _buildTitle(TThemeData theme) {
    if (widget.titleWidget != null) {
      return widget.titleWidget!;
    }
    return Text(
      widget.title ?? '',
      style: TextStyle(
        fontSize: theme.fontTitleMedium?.size ?? _kDefaultFontSize,
        fontWeight: FontWeight.w600,
        color: theme.fontGyColor1,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 带按压反馈的工具栏按钮
  ///
  /// - 按下时 [AnimatedOpacity] 平滑过渡到 [_kPressedOpacity]
  /// - [DefaultTextStyle] / [IconTheme] 为默认 [Text] / [Icon] 提供统一样式，
  ///   用户传入的 Widget 若已指定样式，会优先采用自己的样式（merge 语义）
  Widget _buildToolbarButton({
    required TThemeData theme,
    required bool pressed,
    required ValueChanged<bool> onPressChange,
    required VoidCallback onTap,
    required Color defaultColor,
    required Widget child,
  }) {
    final styledChild = DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: theme.fontTitleMedium?.size ?? _kDefaultFontSize,
        color: defaultColor,
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: defaultColor, size: _kDefaultIconSize),
        child: child,
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onPressChange(true),
      onTapUp: (_) => onPressChange(false),
      onTapCancel: () => onPressChange(false),
      onTap: onTap,
      child: AnimatedOpacity(
        duration: _kPressAnimDuration,
        opacity: pressed ? _kPressedOpacity : 1.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: theme.spacer8, vertical: theme.spacer12),
          child: styledChild,
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
                itemDistanceCalculator: widget.itemDistanceCalculator,
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
          _notifyLoadEvent(col, index, data.length);
        }
      });
    } else {
      _notifyChange();
      _notifyLoadEvent(col, index, data.length);
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

  /// 派发 [TPickerLoadEvent] 给 [TPicker.onLoad]
  ///
  /// 组件本身不做"接近底部"的阈值判断，每次选中变化都会派发；业务层
  /// 通过 [TPickerLoadEvent.remaining] 等字段自行决定是否加载更多。
  void _notifyLoadEvent(int col, int currentIndex, int total) {
    final onLoad = widget.onLoad;
    if (onLoad == null) {
      return;
    }
    final remaining = total - currentIndex - 1;
    if (remaining < 0) {
      return;
    }
    onLoad(TPickerLoadEvent(
      column: col,
      parentValue: col > 0 ? _selectedPath[col - 1] : null,
      displayedCount: total,
      remaining: remaining,
    ));
  }
}

/// 联动模式下一列的归一化结果 Record。
/// `options` 是该列候选项，`parentMap` 是该列的父级 Map（叶子列为 null）。
typedef _ChildColumn = ({List<TPickerOption> options, Map<TPickerOption, dynamic>? parentMap});
