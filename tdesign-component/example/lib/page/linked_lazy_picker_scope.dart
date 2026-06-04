import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 第 0 列分页加载： [nextStart] 为下一项序号（从 1 起）
typedef LinkedLazyPrimaryLoader = Future<List<TPickerOption>> Function(
  int nextStart,
);

/// 第 1 列联动加载： [primaryValue] 为第 0 列选中 value，[nextStart] 为下一项序号
typedef LinkedLazyLinkedLoader = Future<List<TPickerOption>> Function(
  dynamic primaryValue,
  int nextStart,
);

/// LinkedLazyPickerScope: 双列联动按需加载的演示层封装（不扩展 TPicker API）
///
/// 适用于首列/子列数据量大或需接口分页的场景；静态多级联动请用 [TPickerLinked]。
///
/// - 第 0 列：滚近底部时分页
/// - 第 1 列：随第 0 列 value 拉取/读缓存，并支持当前主项下分页
class LinkedLazyPickerScope extends StatefulWidget {
  const LinkedLazyPickerScope({
    super.key,
    required this.initialPrimary,
    required this.initialPrimaryValue,
    required this.initialLinked,
    required this.onLoadPrimary,
    required this.onLoadLinked,
    required this.builder,
    this.threshold = 5,
    this.primaryLabel = '主列',
    this.linkedLabel = '子列',
  });

  /// 第 0 列初始数据
  final List<TPickerOption> initialPrimary;

  /// 第 0 列初始选中 value
  final dynamic initialPrimaryValue;

  /// 第 1 列初始数据（对应 [initialPrimaryValue]）
  final List<TPickerOption> initialLinked;

  /// 第 0 列追加一页
  final LinkedLazyPrimaryLoader onLoadPrimary;

  /// 第 1 列按主项追加一页（含首屏 nextStart == 1）
  final LinkedLazyLinkedLoader onLoadLinked;

  /// 距列底剩余项数 ≤ [threshold] 时触发加载
  final int threshold;

  /// 加载提示文案
  final String primaryLabel;
  final String linkedLabel;

  final Widget Function(BuildContext context, LinkedLazyPickerViewModel vm)
      builder;

  @override
  State<LinkedLazyPickerScope> createState() => _LinkedLazyPickerScopeState();
}

/// LinkedLazyPickerViewModel: 供 builder 读取状态并渲染 TPicker
class LinkedLazyPickerViewModel {
  const LinkedLazyPickerViewModel({
    required this.primaryOptions,
    required this.linkedOptions,
    required this.activePrimaryValue,
    required this.loadingCols,
    required this.initialValue,
    required this.onChange,
    required this.primaryLabel,
    required this.linkedLabel,
  });

  final List<TPickerOption> primaryOptions;
  final List<TPickerOption> linkedOptions;
  final dynamic activePrimaryValue;
  final Set<int> loadingCols;
  final List<dynamic>? initialValue;
  final void Function(TPickerValue value) onChange;
  final String primaryLabel;
  final String linkedLabel;

  /// 纯滚轮（items + initialValue + onChange）
  Widget buildPicker() {
    return TPicker(
      items: TPickerColumns([primaryOptions, linkedOptions]),
      initialValue: initialValue,
      onChange: onChange,
    );
  }

  String get activePrimaryLabel => primaryOptions
      .firstWhere(
        (o) => o.value == activePrimaryValue,
        orElse: () => const TPickerOption(label: '—', value: ''),
      )
      .label;

  String get statusLine =>
      '已加载 $primaryLabel ${primaryOptions.length} 条 · 当前 $activePrimaryLabel · $linkedLabel ${linkedOptions.length} 条';

  String? get loadingHint {
    if (loadingCols.isEmpty) {
      return null;
    }
    return loadingCols
        .map((col) => col == 0 ? '$primaryLabel下一页' : '$linkedLabel')
        .join('、');
  }
}

class _LinkedLazyPickerScopeState extends State<LinkedLazyPickerScope> {
  late List<TPickerOption> _primaryOptions;
  late List<TPickerOption> _linkedOptions;
  late dynamic _activePrimaryValue;
  late List<dynamic>? _initialValue;
  late final Map<dynamic, List<TPickerOption>> _linkedCache;

  final Set<int> _loadingCols = {};
  List<int>? _lastIndexes;

  @override
  void initState() {
    super.initState();
    _primaryOptions = List<TPickerOption>.from(widget.initialPrimary);
    _linkedOptions = List<TPickerOption>.from(widget.initialLinked);
    _activePrimaryValue = widget.initialPrimaryValue;
    _linkedCache = {
      widget.initialPrimaryValue: List<TPickerOption>.from(widget.initialLinked),
    };
    _initialValue = [
      widget.initialPrimaryValue,
      widget.initialLinked.first.value,
    ];
  }

  LinkedLazyPickerViewModel _viewModel() {
    return LinkedLazyPickerViewModel(
      primaryOptions: _primaryOptions,
      linkedOptions: _linkedOptions,
      activePrimaryValue: _activePrimaryValue,
      loadingCols: Set<int>.from(_loadingCols),
      initialValue: _initialValue,
      onChange: _handleChange,
      primaryLabel: widget.primaryLabel,
      linkedLabel: widget.linkedLabel,
    );
  }

  Future<void> _handleChange(TPickerValue value) async {
    final col0Changed =
        _lastIndexes == null || _lastIndexes![0] != value.indexes[0];
    final col1Changed = _lastIndexes != null &&
        value.indexes.length > 1 &&
        _lastIndexes!.length > 1 &&
        _lastIndexes![1] != value.indexes[1];

    if (col0Changed) {
      final primaryValue = value.values[0];
      if (primaryValue != _activePrimaryValue) {
        await _switchLinkedForPrimary(primaryValue);
      }
      await _loadMorePrimaryIfNeeded(value);
    }

    if (col1Changed) {
      await _loadMoreLinkedIfNeeded(value);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _lastIndexes = List<int>.from(value.indexes);
      _initialValue = value.values;
    });
  }

  /// picker: 切换主列选中项时恢复或请求子列
  Future<void> _switchLinkedForPrimary(dynamic primaryValue) async {
    if (_loadingCols.contains(1)) {
      return;
    }

    final cached = _linkedCache[primaryValue];
    if (cached != null) {
      setState(() {
        _activePrimaryValue = primaryValue;
        _linkedOptions = List<TPickerOption>.from(cached);
        _initialValue = [primaryValue, _linkedOptions.first.value];
      });
      return;
    }

    _loadingCols.add(1);
    setState(() {});

    final items = await widget.onLoadLinked(primaryValue, 1);
    if (!mounted) {
      return;
    }

    setState(() {
      _activePrimaryValue = primaryValue;
      _linkedOptions = items;
      _linkedCache[primaryValue] = List<TPickerOption>.from(items);
      _initialValue = [primaryValue, items.first.value];
      _loadingCols.remove(1);
    });
  }

  /// picker: 主列接近底部时分页
  Future<void> _loadMorePrimaryIfNeeded(TPickerValue value) async {
    if (_loadingCols.contains(0)) {
      return;
    }
    final idx = value.indexes[0];
    if (idx < _primaryOptions.length - widget.threshold) {
      return;
    }

    _loadingCols.add(0);
    setState(() {});

    final nextStart = _primaryOptions.length + 1;
    final more = await widget.onLoadPrimary(nextStart);
    if (!mounted) {
      return;
    }

    setState(() {
      _primaryOptions.addAll(more);
      _initialValue = value.values;
      _loadingCols.remove(0);
    });
  }

  /// picker: 子列接近底部且仍对应当前主项时分页
  Future<void> _loadMoreLinkedIfNeeded(TPickerValue value) async {
    if (_loadingCols.contains(1)) {
      return;
    }
    final primaryValue = value.values[0];
    if (primaryValue != _activePrimaryValue) {
      return;
    }

    final idx = value.indexes[1];
    if (idx < _linkedOptions.length - widget.threshold) {
      return;
    }

    _loadingCols.add(1);
    setState(() {});

    final nextStart = _linkedOptions.length + 1;
    final more = await widget.onLoadLinked(primaryValue, nextStart);
    if (!mounted) {
      return;
    }

    setState(() {
      _linkedOptions.addAll(more);
      _linkedCache[primaryValue] = List<TPickerOption>.from(_linkedOptions);
      _initialValue = value.values;
      _loadingCols.remove(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _viewModel());
  }
}
