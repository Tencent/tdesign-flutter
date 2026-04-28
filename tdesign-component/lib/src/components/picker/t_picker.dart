import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'no_wave_behavior.dart';
import 't_item_widget.dart';
import 't_picker_option.dart';
import 't_picker_scroll_physics.dart';

/// 纯滚轮选择器组件
///
/// 数据决定形态：
/// - `List<List<TPickerOption>>` → 多列独立选择
/// - `Map` → 联动选择（Key 必须是 `TPickerOption`）
class TPicker extends StatefulWidget {
  /// 数据源（必填）
  final dynamic items;

  /// 初始选中值列表（按 value 匹配）
  final List? initialValue;

  /// 值改变回调
  final void Function(TPickerValue)? onChange;

  /// 接近底部时加载回调
  final void Function(TPickerLoadEvent)? onLoad;

  /// 预加载阈值（距底部剩余 N 项时触发），默认 5
  final int preloadThreshold;

  /// 视窗高度，默认 200
  final double height;

  /// 每屏显示 item 数，默认 5
  final int itemCount;

  /// 是否禁用整个选择器（禁止滚动和操作），默认 false
  final bool disabled;

  const TPicker({
    super.key,
    required this.items,
    this.initialValue,
    this.onChange,
    this.onLoad,
    this.preloadThreshold = 5,
    this.height = 200,
    this.itemCount = 5,
    this.disabled = false,
  });

  @override
  State<TPicker> createState() => _TPickerState();
}

class _TPickerState extends State<TPicker> {
  late final bool _isLinked = widget.items is Map;
  late final List<List<TPickerOption>> _columns;
  late final List<FixedExtentScrollController> _controllers;
  // 联动模式：每层选中的 value 路径
  late final List<dynamic> _selectedPath;
  // 联动模式：每层的父级 Map（用于查找子数据）
  late final List<Map> _mapStack;
  // 记录每列上次选中的 index，用于判断滚动方向
  late final List<int> _lastSelectedIndex;
  // 标记某列正在动画修正中，防止重复触发 _notifyChange
  final Set<int> _animatingCols = {};

  double get _itemHeight => widget.height / widget.itemCount;

  @override
  void initState() {
    super.initState();
    if (_isLinked) {
      _initLinked();
    } else {
      _initColumns();
    }
  }

  // ========== 初始化 ==========

  void _initColumns() {
    _columns = (widget.items as List).cast<List<TPickerOption>>();
    _selectedPath = [];
    _mapStack = [];
    _lastSelectedIndex = [];

    final initValues = widget.initialValue as List?;
    _controllers = List.generate(_columns.length, (i) {
      int index = 0;
      if (initValues != null && i < initValues.length) {
        final targetIdx = _columns[i].indexWhere((o) => o.value == initValues[i]);
        if (targetIdx >= 0) index = targetIdx;
      }
      _lastSelectedIndex.add(index);
      return FixedExtentScrollController(initialItem: index);
    });
  }

  void _initLinked() {
    final rootMap = widget.items as Map;
    _columns = [];
    _controllers = [];
    _selectedPath = [];
    _mapStack = [];
    _lastSelectedIndex = [];

    var currentMap = rootMap;
    var options = _keysToOptions(currentMap);
    if (options.isEmpty) return;

    _columns.add(options);
    final initValues =
        widget.initialValue is List ? widget.initialValue as List : <dynamic>[];

    for (int depth = 0; depth <= initValues.length; depth++) {
      int idx = 0;
      if (depth < initValues.length) {
        final found = options.indexWhere((o) => o.value == initValues[depth]);
        if (found >= 0) idx = found;
      }

      if (_controllers.length <= depth) {
        _controllers.add(FixedExtentScrollController(initialItem: idx));
        _lastSelectedIndex.add(idx);
      }
      if (options.isNotEmpty && idx < options.length) {
        _selectedPath.add(options[idx].value);
      }
      if (depth >= initValues.length) break;

      final childData = currentMap[options[idx]];
      if (childData == null) break;

      _mapStack.add(currentMap);

      if (childData is Map) {
        currentMap = childData as Map;
        options = _keysToOptions(currentMap);
        if (options.isNotEmpty) _columns.add(options);
        else break;
      } else if (childData is List) {
        final leaf = (childData as List).cast<TPickerOption>();
        if (leaf.isNotEmpty) _columns.add(leaf);
        break;
      }
    }
  }

  // ========== 构建 UI ==========

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: AbsorbPointer(
        absorbing: widget.disabled,
        child: SizedBox(
          height: widget.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: (widget.height - _itemHeight) / 2,
                left: 16,
                right: 16,
                child: Container(
                  height: _itemHeight,
                  decoration: BoxDecoration(
                    color: TTheme.of(context).bgColorSecondaryContainer,
                    borderRadius:
                        BorderRadius.circular(TTheme.of(context).radiusDefault),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    for (int i = 0; i < _controllers.length; i++)
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
    if (data.isEmpty) return const SizedBox.shrink();

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: NoWaveBehavior(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, colIndex, data),
          child: ListWheelScrollView.useDelegate(
            itemExtent: _itemHeight,
            diameterRatio: 3, // 圆柱直径/视窗高度比，值越小弧度越明显（iOS 风格约 2~4）
            controller: _controllers[colIndex],
            physics: widget.disabled
                ? const NeverScrollableScrollPhysics()
                : const TPickerScrollPhysics(),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========== 滚动通知处理 ==========

  /// 统一处理所有滚动通知，实现 disabled 项修正：
  ///
  /// **修正策略**：
  /// 1. Physics 层完全不干预（避免延迟和抖动）
  /// 2. 滚动完全停止后，用 animateToItem 平滑修正（有动画、无冲突）
  /// 3. 使用 addPostFrameCallback 确保在正确时机执行
  /// 4. 使用 _animatingCols 防止重复触发
  bool _onScrollNotification(
      ScrollNotification notification, int col, List<TPickerOption> data) {
    // 只在滚动结束时处理
    if (notification is! ScrollEndNotification) return false;

    final controller = _controllers[col];
    final currentIndex = controller.selectedItem;

    // 边界检查
    if (currentIndex < 0 || currentIndex >= data.length) return false;
    if (!data[currentIndex].disabled) return false; // 已在 enabled 上 → OK

    // 双向搜索最近 enabled
    final forward = _findNearestEnabled(data, currentIndex, 1);
    final backward = _findNearestEnabled(data, currentIndex, -1);

    int target = currentIndex;
    if (forward >= 0 && backward >= 0) {
      target = (forward - currentIndex).abs() <= (backward - currentIndex).abs()
          ? forward : backward;
    } else if (forward >= 0) {
      target = forward;
    } else if (backward >= 0) {
      target = backward;
    } else {
      return false; // 全部 disabled
    }

    // 🔑 关键：在下一帧执行 animateToItem，此时滚动已完全停止
    // 使用 addPostFrameCallback 避免与当前帧的滚动状态冲突
    // 动画时长根据距离动态调整：近距离 200ms，远距离 350ms
    if (_animatingCols.contains(col)) return false; // 防止重复触发
    _animatingCols.add(col);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = _controllers[col];
      
      // 再次检查：如果当前已在 enabled 上，无需修正
      final newIndex = c.selectedItem;
      if (newIndex >= 0 && newIndex < data.length && !data[newIndex].disabled) {
        _animatingCols.remove(col);
        return;
      }
      
      final distance = (target - currentIndex).abs();
      final duration = distance <= 2 ? 200 : 350;
      c.animateToItem(
        target,
        duration: Duration(milliseconds: duration),
        curve: Curves.easeOutCubic,
      ).then((_) {
        // 动画完成后再更新状态，确保数据层与 UI 同步
        if (mounted) {
          _animatingCols.remove(col);
          _lastSelectedIndex[col] = target;
          _notifyChange();
        }
      }).catchError((_) {
        // 动画被中断（如用户再次拖动），清理状态
        _animatingCols.remove(col);
      });
    });

    return false;
  }

  // ========== 选择事件回调 ==========

  void _onItemSelected(int col, int index, List<TPickerOption> data) {
    // disabled 项静默忽略（不干预滚动），由 ScrollEnd 统一兜底修正
    if (data[index].disabled) return;

    _lastSelectedIndex[col] = index;

    if (_isLinked) {
      // 联动模式：先刷新后续列（会 setState 并重建新 controller），
      // 然后 postFrameCallback 等 rebuild 完成后再通知 onChange，
      // 避免"cannot access selectedItem before scroll view is built"异常。
      _refreshLinked(col, index);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _notifyChange();
          _checkPreload(col, index, data.length);
        }
      });
    } else {
      // 非联动模式：直接通知
      _notifyChange();
      _checkPreload(col, index, data.length);
    }
  }

  /// 从 start 出发沿 direction 方向查找最近一个未禁用的索引
  int _findNearestEnabled(List<TPickerOption> data, int start, int direction) {
    int i = start + direction;
    while (i >= 0 && i < data.length) {
      if (!data[i].disabled) return i;
      i += direction;
    }
    return -1;
  }

  /// 联动模式：前列变化 → 刷新后续列
  void _refreshLinked(int col, int newIndex) {
    if (col >= _columns.length - 1) return;

    final selectedOpt = _columns[col][newIndex];
    _selectedPath.removeRange(col + 1, _selectedPath.length);
    _selectedPath.add(selectedOpt.value);

    _columns.removeRange(col + 1, _columns.length);
    _controllers.removeRange(col + 1, _controllers.length);
    _mapStack.removeRange(col, _mapStack.length);

    final sourceMap =
        col < _mapStack.length ? _mapStack.last : widget.items as Map;
    final childData = _findChild(sourceMap, selectedOpt.value);
    if (childData != null) {
      if (childData is List) {
        final list = (childData as List).cast<TPickerOption>();
        if (list.isNotEmpty) {
          _columns.add(list);
          _controllers.add(FixedExtentScrollController(initialItem: 0));
          _lastSelectedIndex.add(0);
        }
      } else if (childData is Map) {
        final map = childData as Map;
        final opts = _keysToOptions(map);
        if (opts.isNotEmpty) {
          _columns.add(opts);
          _controllers.add(FixedExtentScrollController(initialItem: 0));
          _lastSelectedIndex.add(0);
          _mapStack.add(map);
        }
      }
    }

    setState(() {});
  }

  // ========== 回调通知 ==========

  void _notifyChange() {
    final selectedOptions = <TPickerOption>[];
    final indexes = <int>[];

    for (int i = 0; i < _controllers.length; i++) {
      if (_columns[i].isEmpty) continue;
      // Layer 3 安全网：确保永远不会报告 disabled index
      int idx = _controllers[i].selectedItem.clamp(0, _columns[i].length - 1);
      if (idx < _columns[i].length && _columns[i][idx].disabled) {
        // 同时双向搜索，取距离更近的 enabled index
        final forward = _findNearestEnabled(_columns[i], idx, 1);
        final backward = _findNearestEnabled(_columns[i], idx, -1);
        if (forward >= 0 && backward >= 0) {
          // 两者都存在，取距离更近的
          idx = (forward - idx).abs() <= (backward - idx).abs() ? forward : backward;
        } else if (forward >= 0) {
          idx = forward;
        } else if (backward >= 0) {
          idx = backward;
        }
        // else: 全部 disabled，保持原 index
      }
      indexes.add(idx);
      selectedOptions.add(_columns[i][idx]);
    }

    widget.onChange?.call(TPickerValue(selectedOptions: selectedOptions, indexes: indexes));
  }

  void _checkPreload(int col, int currentIndex, int total) {
    if (widget.onLoad == null) return;
    final remaining = total - currentIndex - 1;
    if (remaining <= widget.preloadThreshold && remaining > 0) {
      widget.onLoad?.call(TPickerLoadEvent(
        column: col,
        parentValue:
            col > 0 && col <= _selectedPath.length ? _selectedPath[col - 1] : null,
        displayedCount: total,
        remaining: remaining,
      ));
    }
  }

  // ========== 工具方法 ==========

  List<TPickerOption> _keysToOptions(Map map) {
    return [
      for (final key in map.keys)
        key is TPickerOption
            ? key
            : TPickerOption(label: key.toString(), value: key)
    ];
  }

  dynamic _findChild(Map map, dynamic targetValue) {
    for (final key in map.keys) {
      final kv = key is TPickerOption ? key.value : key;
      if (kv == targetValue) return map[key];
    }
    return null;
  }
}
