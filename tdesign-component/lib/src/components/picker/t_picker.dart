import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 'no_wave_behavior.dart';
import 't_item_widget.dart';
import 't_picker_option.dart';

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

  const TPicker({
    super.key,
    required this.items,
    this.initialValue,
    this.onChange,
    this.onLoad,
    this.preloadThreshold = 5,
    this.height = 200,
    this.itemCount = 5,
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

    final initValues = widget.initialValue as List?;
    _controllers = List.generate(_columns.length, (i) {
      int index = 0;
      if (initValues != null && i < initValues.length) {
        final targetIdx = _columns[i].indexWhere((o) => o.value == initValues[i]);
        if (targetIdx >= 0) index = targetIdx;
      }
      return FixedExtentScrollController(initialItem: index);
    });
  }

  void _initLinked() {
    final rootMap = widget.items as Map;
    _columns = [];
    _controllers = [];
    _selectedPath = [];
    _mapStack = [];

    var currentMap = rootMap;
    var options = _keysToOptions(currentMap);
    if (options.isEmpty) return;

    _columns.add(options);
    final initValues = widget.initialValue is List ? widget.initialValue as List : <dynamic>[];

    for (int depth = 0; depth <= initValues.length; depth++) {
      // 当前列选中索引
      int idx = 0;
      if (depth < initValues.length) {
        final found = options.indexWhere((o) => o.value == initValues[depth]);
        if (found >= 0) idx = found;
      }

      if (_controllers.length <= depth) {
        _controllers.add(FixedExtentScrollController(initialItem: idx));
      }
      if (options.isNotEmpty && idx < options.length) {
        _selectedPath.add(options[idx].value);
      }
      if (depth >= initValues.length) break;

      // 进入下一级
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
    return SizedBox(
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
                borderRadius: BorderRadius.circular(TTheme.of(context).radiusDefault),
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
        child: ListWheelScrollView.useDelegate(
          itemExtent: _itemHeight,
          diameterRatio: 100,
          controller: _controllers[colIndex],
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) => _onItemSelected(colIndex, index, data),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: data.length,
            builder: (_, index) => TItemWidget(
              content: data[index].label,
              fixedExtentScrollController: _controllers[colIndex],
              colIndex: colIndex,
              index: index,
              itemHeight: _itemHeight,
            ),
          ),
        ),
      ),
    );
  }

  // ========== 事件处理 ==========

  void _onItemSelected(int col, int index, List<TPickerOption> data) {
    // 跳过 disabled 项
    if (data[index].disabled) {
      int next = index + 1;
      while (next < data.length && data[next].disabled) next++;
      if (next < data.length) _controllers[col].jumpToItem(next);
      return;
    }

    // 联动刷新
    if (_isLinked) _refreshLinked(col, index);

    // 回调
    _notifyChange();
    _checkPreload(col, index, data.length);
  }

  /// 联动模式：前列变化 → 刷新后续列
  void _refreshLinked(int col, int newIndex) {
    if (col >= _columns.length - 1) return; // 最后一级无下级

    final selectedOpt = _columns[col][newIndex];
    _selectedPath..removeRange(col + 1, _selectedPath.length)..add(selectedOpt.value);

    // 截断后级数据
    _columns.removeRange(col + 1, _columns.length);
    _controllers.removeRange(col + 1, _controllers.length);
    _mapStack.removeRange(col, _mapStack.length);

    // 加载下一级
    final sourceMap = col < _mapStack.length ? _mapStack.last : widget.items as Map;
    final childData = _findChild(sourceMap, selectedOpt.value);
    if (childData != null) {
      if (childData is List) {
        final list = (childData as List).cast<TPickerOption>();
        if (list.isNotEmpty) {
          _columns.add(list);
          _controllers.add(FixedExtentScrollController(initialItem: 0));
        }
      } else if (childData is Map) {
        final map = childData as Map;
        final opts = _keysToOptions(map);
        if (opts.isNotEmpty) {
          _columns.add(opts);
          _controllers.add(FixedExtentScrollController(initialItem: 0));
          _mapStack.add(map);
        }
      }
    }

    setState(() {});
  }

  // ========== 回调通知 ==========

  void _notifyChange() {
    final values = <dynamic>[];
    final indexes = <int>[];

    for (int i = 0; i < _controllers.length; i++) {
      if (_columns[i].isEmpty) continue;
      final idx = _controllers[i].selectedItem.clamp(0, _columns[i].length - 1);
      indexes.add(idx);
      values.add(_columns[i][idx].value);
    }

    widget.onChange?.call(TPickerValue(values: values, indexes: indexes));
  }

  void _checkPreload(int col, int currentIndex, int total) {
    if (widget.onLoad == null) return;
    final remaining = total - currentIndex - 1;
    if (remaining <= widget.preloadThreshold && remaining > 0) {
      widget.onLoad?.call(TPickerLoadEvent(
        column: col,
        parentValue: col > 0 && col <= _selectedPath.length ? _selectedPath[col - 1] : null,
        displayedCount: total,
        remaining: remaining,
      ));
    }
  }

  // ========== 工具方法 ==========

  /// 从 Map 的 keys 提取为 TPickerOption 列表（唯一入口，消除重复）
  List<TPickerOption> _keysToOptions(Map map) {
    return [
      for (final key in map.keys)
        key is TPickerOption ? key : TPickerOption(label: key.toString(), value: key)
    ];
  }

  /// 在 Map 中通过 value 查找子数据（唯一入口）
  dynamic _findChild(Map map, dynamic targetValue) {
    for (final key in map.keys) {
      final kv = key is TPickerOption ? key.value : key;
      if (kv == targetValue) return map[key];
    }
    return null;
  }
}
