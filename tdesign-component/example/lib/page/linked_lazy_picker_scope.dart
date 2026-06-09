import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'linked_lazy_picker_policy.dart';

/// 第 0 列分页加载： [nextStart] 为下一项序号（从 1 起）
typedef LinkedLazyPrimaryLoader = Future<LazyLoadPage> Function(int nextStart);

/// 第 1 列联动加载： [primaryValue] 为第 0 列选中 value，[nextStart] 为下一项序号
typedef LinkedLazyLinkedLoader = Future<LazyLoadPage> Function(
  dynamic primaryValue,
  int nextStart,
);

/// LinkedLazyPickerScope: 双列联动按需加载的演示层封装（不扩展 TPicker API）
///
/// 适用于首列/子列数据量大或需接口分页的场景；静态多级联动请用 [TPickerLinked]。
///
/// - 第 0 列：滚近底部时分页
/// - 第 1 列：随第 0 列 value 拉取/读缓存，并支持当前主项下分页
///
/// 分页在 [TPicker.onColumnScrollEnd] 判定（滚动结束 + 向下滚 + hasMore）；
/// [TPicker.onChange] 仅维护选中 draft 与联动切换。
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
    this.initialPrimaryHasMore = true,
    this.initialLinkedHasMore = true,
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

  /// 首屏主列是否还有下一页
  final bool initialPrimaryHasMore;

  /// 首屏子列是否还有下一页
  final bool initialLinkedHasMore;

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
    required this.onColumnScrollEnd,
    required this.primaryLabel,
    required this.linkedLabel,
  });

  final List<TPickerOption> primaryOptions;
  final List<TPickerOption> linkedOptions;
  final dynamic activePrimaryValue;
  final Set<int> loadingCols;
  final List<dynamic>? initialValue;
  final void Function(int col, TPickerValue value) onChange;
  final void Function(int col, TPickerValue value) onColumnScrollEnd;
  final String primaryLabel;
  final String linkedLabel;

  /// 纯滚轮（items + initialValue + onChange + onColumnScrollEnd）
  Widget buildPicker() {
    return TPicker(
      items: TPickerColumns([primaryOptions, linkedOptions]),
      initialValue: initialValue,
      onChange: onChange,
      onColumnScrollEnd: onColumnScrollEnd,
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
  late LinkedColumnCache _cache;
  late dynamic _activePrimaryValue;
  late List<TPickerOption> _linkedOptions;
  late List<dynamic>? _initialValue;

  /// 子列切换序号，丢弃过期的异步加载结果
  int _linkedSwitchGeneration = 0;

  /// 各列上一次 scroll-end 时的索引，用于判定滚动方向
  final Map<int, int> _scrollEndIndexesByCol = {};

  /// 各列加载判定的触发来源
  final Map<int, LoadTriggerSource> _loadSourceByCol = {
    0: LoadTriggerSource.initial,
    1: LoadTriggerSource.initial,
  };

  List<TPickerOption> get _primaryOptions => _cache.primary.options;

  Set<int> get _loadingCols {
    final cols = <int>{};
    if (_cache.primary.loading) {
      cols.add(0);
    }
    final linked = _cache.linkedFor(_activePrimaryValue);
    if (linked?.loading ?? false) {
      cols.add(1);
    }
    return cols;
  }

  @override
  void initState() {
    super.initState();
    _cache = LinkedColumnCache(
      initialPrimary: widget.initialPrimary,
      initialLinked: widget.initialLinked,
      initialPrimaryValue: widget.initialPrimaryValue,
      primaryHasMore: widget.initialPrimaryHasMore,
      linkedHasMore: widget.initialLinkedHasMore,
    );
    _activePrimaryValue = widget.initialPrimaryValue;
    _linkedOptions = List<TPickerOption>.from(widget.initialLinked);
    _initialValue = [
      widget.initialPrimaryValue,
      widget.initialLinked.first.value,
    ];
    _scrollEndIndexesByCol[0] = 0;
    _scrollEndIndexesByCol[1] = 0;
  }

  LinkedLazyPickerViewModel _viewModel() {
    return LinkedLazyPickerViewModel(
      primaryOptions: _primaryOptions,
      linkedOptions: _linkedOptions,
      activePrimaryValue: _activePrimaryValue,
      loadingCols: _loadingCols,
      initialValue: _initialValue,
      onChange: _handleChange,
      onColumnScrollEnd: _handleColumnScrollEnd,
      primaryLabel: widget.primaryLabel,
      linkedLabel: widget.linkedLabel,
    );
  }

  /// onChange：选中 draft、主列联动换子列（不触发分页）
  Future<void> _handleChange(int col, TPickerValue value) async {
    if (value.values.length > 1) {
      _cache.rememberLinkedSelection(value.values[0], value.values[1]);
    }

    final primaryValue = value.values[0];
    if (primaryValue != _activePrimaryValue) {
      await _switchLinkedForPrimary(primaryValue);
    }
  }

  /// scroll-end：按 [LazyLoadPolicy] 判定是否分页
  Future<void> _handleColumnScrollEnd(int col, TPickerValue value) async {
    final source = _loadSourceByCol[col] ?? LoadTriggerSource.userScroll;

    if (source == LoadTriggerSource.programmaticRestore) {
      _loadSourceByCol[col] = LoadTriggerSource.userScroll;
      _scrollEndIndexesByCol[col] = value.indexes[col];
      return;
    }

    if (source != LoadTriggerSource.userScroll) {
      _loadSourceByCol[col] = LoadTriggerSource.userScroll;
    }

    final indexAtEnd = value.indexes[col];
    final prevAtEnd = _scrollEndIndexesByCol[col] ?? indexAtEnd;
    _scrollEndIndexesByCol[col] = indexAtEnd;

    if (col == 0) {
      await _loadMorePrimaryIfNeeded(value, prevAtEnd, indexAtEnd);
    } else if (col == 1) {
      await _loadMoreLinkedIfNeeded(value, prevAtEnd, indexAtEnd);
    }
  }

  /// picker: 切换主列选中项时恢复或请求子列
  Future<void> _switchLinkedForPrimary(dynamic primaryValue) async {
    final switchGen = ++_linkedSwitchGeneration;

    final cached = _cache.linkedFor(primaryValue);
    if (cached != null && cached.options.isNotEmpty) {
      if (!mounted || switchGen != _linkedSwitchGeneration) {
        return;
      }
      final linkedValue = _cache.resolveLinkedValue(
        primaryValue,
        cached.options,
      );
      setState(() {
        _activePrimaryValue = primaryValue;
        _linkedOptions = List<TPickerOption>.from(cached.options);
        _initialValue = [primaryValue, linkedValue];
        _loadSourceByCol[1] = LoadTriggerSource.programmaticRestore;
      });
      return;
    }

    _cache.linkedForOrCreate(primaryValue).loading = true;
    setState(() {});

    final page = await widget.onLoadLinked(primaryValue, 1);
    if (!mounted || switchGen != _linkedSwitchGeneration) {
      return;
    }

    setState(() {
      _cache.replaceLinked(
        primaryValue,
        page.items,
        hasMore: page.hasMore,
      );
      _activePrimaryValue = primaryValue;
      _linkedOptions = List<TPickerOption>.from(page.items);
      final linkedValue = _cache.resolveLinkedValue(primaryValue, page.items);
      _initialValue = [primaryValue, linkedValue];
      _cache.linkedFor(primaryValue)!.loading = false;
      _loadSourceByCol[1] = LoadTriggerSource.programmaticRestore;
    });
  }

  /// picker: 主列 scroll-end 接近底部且向下滚时分页
  Future<void> _loadMorePrimaryIfNeeded(
    TPickerValue value,
    int prevIndexAtEnd,
    int indexAtEnd,
  ) async {
    final state = _cache.primary;
    if (!LazyLoadPolicy.shouldLoadAtScrollEnd(
      prevIndexAtScrollEnd: prevIndexAtEnd,
      indexAtScrollEnd: indexAtEnd,
      loadedCount: state.options.length,
      threshold: widget.threshold,
      hasMore: state.hasMore,
      loading: state.loading,
      source: LoadTriggerSource.userScroll,
    )) {
      return;
    }

    state.loading = true;
    setState(() {});

    final page = await widget.onLoadPrimary(state.options.length + 1);
    if (!mounted) {
      return;
    }

    setState(() {
      _cache.appendPrimary(page);
      state.loading = false;
    });
  }

  /// picker: 子列 scroll-end 接近底部且向下滚时分页
  Future<void> _loadMoreLinkedIfNeeded(
    TPickerValue value,
    int prevIndexAtEnd,
    int indexAtEnd,
  ) async {
    final primaryValue = value.values[0];
    if (primaryValue != _activePrimaryValue) {
      return;
    }

    final state = _cache.linkedForOrCreate(primaryValue);
    if (!LazyLoadPolicy.shouldLoadAtScrollEnd(
      prevIndexAtScrollEnd: prevIndexAtEnd,
      indexAtScrollEnd: indexAtEnd,
      loadedCount: state.options.length,
      threshold: widget.threshold,
      hasMore: state.hasMore,
      loading: state.loading,
      source: LoadTriggerSource.userScroll,
    )) {
      return;
    }

    state.loading = true;
    setState(() {});

    final page = await widget.onLoadLinked(
      primaryValue,
      state.options.length + 1,
    );
    if (!mounted) {
      return;
    }

    setState(() {
      _cache.appendLinked(primaryValue, page);
      _linkedOptions = List<TPickerOption>.from(state.options);
      state.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _viewModel());
  }
}
