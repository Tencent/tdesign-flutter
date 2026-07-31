import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import 'multi_wheel_layout.dart';
import 't_picker_theme_data.dart';
import 't_picker_types.dart';
import 'wheel_column.dart';

const double _disabledOpacity = 0.5;

/// 严格受控的滚轮选择器。
///
/// 独立多列使用 [TPickerColumns]，层级联动使用 [TPickerLinked]。弹层和确认
/// 操作由调用方组合，组件本身只负责滚轮选择。
class TPicker extends StatefulWidget {
  const TPicker({
    super.key,

    /// 数据源。
    required this.items,

    /// 各列受控值。
    required this.value,

    /// 值变化回调；为 null 时禁用。
    this.onChanged,

    /// 某列滚动结束回调。
    this.onColumnScrollEnd,

    /// 自定义选项构建器。
    this.itemBuilder,
  });

  /// 数据源。
  final TPickerItems items;

  /// 各列受控值。
  final List<Object?> value;

  /// 值变化回调；为 null 时禁用。
  final ValueChanged<TPickerValue>? onChanged;

  /// 某列滚动结束回调。
  final void Function(int columnIndex, TPickerValue value)? onColumnScrollEnd;

  /// 自定义选项构建器。
  final TPickerItemBuilder? itemBuilder;

  @override
  State<TPicker> createState() => _TPickerState();
}

class _TPickerState extends State<TPicker> {
  late List<List<TPickerOption>> _columns;
  late List<FixedExtentScrollController> _controllers;
  late List<GlobalKey<WheelColumnState>> _columnKeys;
  List<Object?>? _pendingValue;

  bool get _enabled => widget.onChanged != null;

  TPickerThemeData? get _theme =>
      Theme.of(context).extension<TPickerThemeData>();

  double get _height => _theme?.height ?? 200;

  int get _itemCount => _theme?.itemCount ?? 5;

  double get _itemHeight => _height / _itemCount;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant TPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final acceptsPendingValue =
        _pendingValue != null && listEquals(widget.value, _pendingValue);
    if (acceptsPendingValue) {
      _pendingValue = null;
    }
    final linkedValueAccepted =
        acceptsPendingValue && widget.items is TPickerLinked;
    if (oldWidget.items != widget.items ||
        linkedValueAccepted ||
        (!acceptsPendingValue &&
            !listEquals(widget.value, _snapshot().values))) {
      final previousControllers = _controllers;
      _initialize();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final controller in previousControllers) {
          controller.dispose();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initialize() {
    _columns = switch (widget.items) {
      TPickerColumns(:final columns) => columns,
      TPickerLinked(:final options) => _linkedColumns(options, widget.value),
    };
    _controllers = List.generate(_columns.length, (columnIndex) {
      final options = _columns[columnIndex];
      final requested = columnIndex < widget.value.length
          ? options.indexWhere(
              (option) => option.value == widget.value[columnIndex],
            )
          : -1;
      return FixedExtentScrollController(
        initialItem: requested >= 0 ? requested : _firstEnabledIndex(options),
      );
    });
    _columnKeys = List.generate(_columns.length, (_) => GlobalKey());
  }

  static List<List<TPickerOption>> _linkedColumns(
    List<TPickerOption> roots,
    List<Object?> value,
  ) {
    final columns = <List<TPickerOption>>[];
    var options = roots;
    var depth = 0;
    while (options.isNotEmpty) {
      columns.add(options);
      final requested = depth < value.length
          ? options.indexWhere((option) => option.value == value[depth])
          : -1;
      final index = requested >= 0 ? requested : _firstEnabledIndex(options);
      options = options[index].children;
      depth += 1;
    }
    return columns;
  }

  static int _firstEnabledIndex(List<TPickerOption> options) {
    final index = options.indexWhere((option) => !option.disabled);
    return index < 0 ? 0 : index;
  }

  int _selectedIndex(int columnIndex) {
    final controller = _controllers[columnIndex];
    final options = _columns[columnIndex];
    final index = controller.hasClients
        ? controller.selectedItem
        : controller.initialItem;
    return index.clamp(0, options.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      enabled: _enabled,
      label: context.resource.picker,
      child: Opacity(
        opacity: _enabled ? 1 : _disabledOpacity,
        child: AbsorbPointer(
          absorbing: !_enabled,
          child: MultiWheelLayout(
            height: _height,
            itemHeight: _itemHeight,
            columns: [
              for (var index = 0; index < _columns.length; index++)
                _buildColumn(context, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, int columnIndex) {
    final options = _columns[columnIndex];
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListenableBuilder(
      listenable: _controllers[columnIndex],
      builder: (context, _) {
        final currentIndex = _selectedIndex(columnIndex);
        final previous = currentIndex > 0
            ? options[currentIndex - 1].label
            : null;
        final next = currentIndex < options.length - 1
            ? options[currentIndex + 1].label
            : null;
        return Semantics(
          container: true,
          explicitChildNodes: true,
          enabled: _enabled,
          label: context.resource.pickerColumn(columnIndex + 1),
          value: options[currentIndex].label,
          onIncrease: _enabled && next != null
              ? () => _columnKeys[columnIndex].currentState?.nudge(1)
              : null,
          increasedValue: next ?? '',
          onDecrease: _enabled && previous != null
              ? () => _columnKeys[columnIndex].currentState?.nudge(-1)
              : null,
          decreasedValue: previous ?? '',
          child: ExcludeSemantics(
            child: WheelColumn(
              key: _columnKeys[columnIndex],
              colIndex: columnIndex,
              options: options,
              controller: _controllers[columnIndex],
              itemHeight: _itemHeight,
              disabled: !_enabled,
              itemBuilder: widget.itemBuilder,
              onItemSelected: _onItemSelected,
              onAnimationComplete: _onItemSelected,
              onScrollEnd: _onScrollEnd,
            ),
          ),
        );
      },
    );
  }

  void _onItemSelected(
    int columnIndex,
    int itemIndex,
    List<TPickerOption> options,
  ) {
    if (!_enabled || options[itemIndex].disabled) {
      return;
    }
    final value = widget.items is TPickerLinked
        ? _linkedSnapshot(columnIndex, itemIndex)
        : _snapshot(overrideColumn: columnIndex, overrideIndex: itemIndex);
    if (!listEquals(value.values, widget.value)) {
      // 父级同步受控值时，滚轮的本帧位置尚未必然反映到 controller；
      // 标记该用户发起的快照，避免 didUpdateWidget 错误重建滚轮并中断拖动。
      _pendingValue = value.values;
      widget.onChanged?.call(value);
    }
  }

  bool _onScrollEnd(
    ScrollNotification notification,
    int columnIndex,
    List<TPickerOption> options,
  ) {
    if (notification is ScrollEndNotification && _enabled) {
      widget.onColumnScrollEnd?.call(columnIndex, _snapshot());
    }
    return false;
  }

  TPickerValue _snapshot({int? overrideColumn, int? overrideIndex}) {
    final selected = <TPickerOption>[];
    final indexes = <int>[];
    for (var columnIndex = 0; columnIndex < _columns.length; columnIndex++) {
      final options = _columns[columnIndex];
      if (options.isEmpty) {
        continue;
      }
      var index = columnIndex == overrideColumn
          ? overrideIndex!
          : _selectedIndex(columnIndex);
      if (options[index].disabled) {
        final enabled = WheelColumnState.nearestEnabledIndex(options, index);
        if (enabled >= 0) {
          index = enabled;
        }
      }
      selected.add(options[index]);
      indexes.add(index);
    }
    return TPickerValue(
      selectedOptions: List.unmodifiable(selected),
      indexes: List.unmodifiable(indexes),
    );
  }

  TPickerValue _linkedSnapshot(int changedColumn, int changedIndex) {
    final selected = <TPickerOption>[];
    final indexes = <int>[];
    var options = (widget.items as TPickerLinked).options;
    var columnIndex = 0;
    while (options.isNotEmpty) {
      var index = columnIndex == changedColumn
          ? changedIndex
          : columnIndex < changedColumn
          ? _selectedIndex(columnIndex)
          : _firstEnabledIndex(options);
      if (index < 0 || index >= options.length) {
        index = _firstEnabledIndex(options);
      }
      if (options[index].disabled) {
        index = _firstEnabledIndex(options);
      }
      final option = options[index];
      selected.add(option);
      indexes.add(index);
      options = option.children;
      columnIndex += 1;
    }
    return TPickerValue(
      selectedOptions: List.unmodifiable(selected),
      indexes: List.unmodifiable(indexes),
    );
  }
}
