import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../picker/picker_option.dart';
import '../picker/wheel_behavior.dart';
import '../picker/wheel_column.dart';
import 't_date_time_picker_column.dart';
import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';
import 't_date_time_picker_model.dart';

/// 日期/时间专用多列滚轮（@internal）。
///
/// 列联动、options 局部更新均在内部完成，滚动时不触发外层 `setState`。
@internal
class DateTimePickerWheel extends StatefulWidget {
  const DateTimePickerWheel({
    super.key,
    required this.snapshot,
    required this.labels,
    required this.start,
    required this.end,
    required this.showWeek,
    required this.steps,
    required this.renderLabel,
    required this.height,
    required this.itemCount,
    required this.onChanged,
  });

  final DateTimePickerSnapshot snapshot;
  final DateTimePickerLabels labels;
  final DateTime? start;
  final DateTime? end;
  final bool showWeek;
  final DateTimePickerSteps? steps;
  final DateTimePickerRenderLabel? renderLabel;
  final double height;
  final int itemCount;
  final void Function(
    DateTimePickerSnapshot snapshot,
    TDateTimePickerValue result,
  ) onChanged;

  @override
  State<DateTimePickerWheel> createState() => _DateTimePickerWheelState();
}

class _DateTimePickerWheelState extends State<DateTimePickerWheel> {
  late DateTimePickerSnapshot _snapshot;
  late List<List<PickerOption>> _columns;
  late List<FixedExtentScrollController> _controllers;
  late List<GlobalKey<WheelColumnState>> _columnKeys;
  bool _controllersReady = false;
  final _scrollBehavior = WheelBehavior();

  double get _itemHeight => widget.height / widget.itemCount;

  @override
  void initState() {
    super.initState();
    _snapshot = widget.snapshot;
    _initColumns();
  }

  DateTimePickerLabels get _labels => widget.labels;

  void _initColumns() {
    _columns = List.generate(
      _snapshot.columns.length,
      (i) => _snapshot.columnOptionsAt(
        i,
        start: widget.start,
        end: widget.end,
        showWeek: widget.showWeek,
        labels: _labels,
        renderLabel: widget.renderLabel,
        steps: widget.steps,
      ),
    );
    _columnKeys = List.generate(
      _columns.length,
      (_) => GlobalKey<WheelColumnState>(),
    );
    _controllers = List.generate(_columns.length, (i) {
      return FixedExtentScrollController(
        initialItem: _indexForValue(i, _snapshot.values[i]),
      );
    });
    _controllersReady = true;
  }

  @override
  void didUpdateWidget(covariant DateTimePickerWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapshot == widget.snapshot &&
        oldWidget.showWeek == widget.showWeek &&
        oldWidget.start == widget.start &&
        oldWidget.end == widget.end &&
        oldWidget.steps == widget.steps &&
        oldWidget.renderLabel == widget.renderLabel &&
        oldWidget.labels == widget.labels &&
        oldWidget.height == widget.height &&
        oldWidget.itemCount == widget.itemCount) {
      return;
    }
    final previousControllers = List<FixedExtentScrollController>.from(
      _controllers,
    );
    _snapshot = widget.snapshot;
    _initColumns();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in previousControllers) {
        if (!_controllers.contains(c)) {
          c.dispose();
        }
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onItemSelected(int col, int index, List<PickerOption> data) {
    final rawValues = List<int>.from(_snapshot.values);
    final value = data[index].value;
    if (value is! int) {
      return;
    }
    rawValues[col] = value;

    final prev = _snapshot;
    final next = _snapshot.applySelection(
      rawValues: rawValues,
      start: widget.start,
      end: widget.end,
      steps: widget.steps,
    );
    final rebuildIndices = next.columnIndicesWithChangedOptions(
      prev,
      showWeek: widget.showWeek,
      start: widget.start,
      end: widget.end,
    );
    final outOfSync = !_valuesEqual(rawValues, next.values);
    final syncIndices =
        outOfSync ? _outOfSyncIndices(rawValues, next.values) : const <int>{};

    if (next == prev && rebuildIndices.isEmpty && syncIndices.isEmpty) {
      return;
    }

    _snapshot = next;

    for (final i in rebuildIndices) {
      _replaceColumn(i, syncValue: next.values[i]);
    }
    for (final i in syncIndices) {
      if (rebuildIndices.contains(i)) {
        continue;
      }
      _syncColumn(i, next.values[i]);
    }

    setState(() {});
    widget.onChanged(next, next.toResult());
  }

  void _nudgeColumn(int col, int delta) {
    if (col < 0 || col >= _columns.length || _columns[col].isEmpty) {
      return;
    }
    final maxIndex = _columns[col].length - 1;
    final currentIdx = _indexForValue(col, _snapshot.values[col]);
    final nextIdx = (currentIdx + delta).clamp(0, maxIndex);
    if (nextIdx == currentIdx) {
      return;
    }
    _onItemSelected(col, nextIdx, _columns[col]);
  }

  void _replaceColumn(int col, {required int syncValue}) {
    final newData = _snapshot.columnOptionsAt(
      col,
      start: widget.start,
      end: widget.end,
      showWeek: widget.showWeek,
      labels: _labels,
      renderLabel: widget.renderLabel,
      steps: widget.steps,
    );
    final oldData = _columns[col];
    _columns[col] = newData;

    final targetIdx = _indexForValue(col, syncValue);
    final previousController = _controllers[col];
    FixedExtentScrollController controller;
    if (oldData.length != newData.length) {
      controller = FixedExtentScrollController(initialItem: targetIdx);
      _controllers[col] = controller;
    } else {
      controller = _controllers[col];
      if (controller.selectedItem != targetIdx) {
        controller.jumpToItem(targetIdx);
      }
    }

    final columnState = _columnKeys[col].currentState;
    columnState?.applyColumnUpdate(
      options: newData,
      controller: controller,
    );
    //列尚未挂载时由本层延迟释放旧 controller，避免与 applyColumnUpdate 重复 dispose
    if (oldData.length != newData.length &&
        columnState == null &&
        !identical(previousController, controller)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!identical(_controllers[col], previousController)) {
          previousController.dispose();
        }
      });
    }
  }

  void _syncColumn(int col, int syncValue) {
    final targetIdx = _indexForValue(col, syncValue);
    if (_controllers[col].selectedItem != targetIdx) {
      _controllers[col].jumpToItem(targetIdx);
    }
  }

  int _indexForValue(int col, dynamic value) {
    if (_columns[col].isEmpty) {
      return 0;
    }
    if (value != null) {
      final found = _columns[col].indexWhere((o) => o.value == value);
      if (found >= 0) {
        return found;
      }
    }
    if (_controllersReady && col < _controllers.length) {
      return _controllers[col].selectedItem.clamp(0, _columns[col].length - 1);
    }
    return 0;
  }

  static bool _valuesEqual(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  static Set<int> _outOfSyncIndices(List<int> raw, List<int> normalized) {
    final count =
        raw.length < normalized.length ? raw.length : normalized.length;
    final out = <int>{};
    for (var i = 0; i < count; i++) {
      if (raw[i] != normalized[i]) {
        out.add(i);
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    return Semantics(
      label: '日期时间选择器',
      container: true,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacer32),
              child: Row(
                children: [
                  for (var i = 0; i < _controllers.length; i++)
                    Expanded(child: _buildColumnSemantics(i)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///单列无障碍包装（边界处不提供 increase/decrease）
  Widget _buildColumnSemantics(int col) {
    final value = _columnSemanticsValue(col);
    final increased = _columnSemanticsAdjustedValue(col, 1);
    final decreased = _columnSemanticsAdjustedValue(col, -1);
    return Semantics(
      label: _columnSemanticsLabel(col),
      value: value,
      onIncrease: increased != null ? () => _nudgeColumn(col, 1) : null,
      increasedValue: increased,
      onDecrease: decreased != null ? () => _nudgeColumn(col, -1) : null,
      decreasedValue: decreased,
      child: ExcludeSemantics(
        child: WheelColumn(
          key: _columnKeys[col],
          colIndex: col,
          options: _columns[col],
          controller: _controllers[col],
          itemHeight: _itemHeight,
          disabled: false,
          scrollBehavior: _scrollBehavior,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }

  ///列无障碍 label
  String _columnSemanticsLabel(int col) {
    final column = _snapshot.columns[col];
    final suffix = _labels.unitSuffix[column] ?? '';
    return switch (column) {
      DateTimeColumn.year => '年份$suffix',
      DateTimeColumn.month => '月份$suffix',
      DateTimeColumn.day => '日期$suffix',
      DateTimeColumn.hour => '小时$suffix',
      DateTimeColumn.minute => '分钟$suffix',
      DateTimeColumn.second => '秒$suffix',
    };
  }

  ///列当前选中值的无障碍文案
  String _columnSemanticsValue(int col) {
    if (_columns[col].isEmpty) {
      return '';
    }
    final idx = _indexForValue(col, _snapshot.values[col]);
    return _columns[col][idx].label;
  }

  ///增减一格后的无障碍预览文案
  String? _columnSemanticsAdjustedValue(int col, int delta) {
    if (_columns[col].isEmpty) {
      return null;
    }
    final currentIdx = _indexForValue(col, _snapshot.values[col]);
    final nextIdx = (currentIdx + delta).clamp(0, _columns[col].length - 1);
    if (nextIdx == currentIdx) {
      return null;
    }
    return _columns[col][nextIdx].label;
  }
}
