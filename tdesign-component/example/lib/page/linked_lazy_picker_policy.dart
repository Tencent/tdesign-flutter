import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 分页接口返回的一页数据
class LazyLoadPage {
  const LazyLoadPage({
    required this.items,
    this.hasMore = true,
  });

  final List<TPickerOption> items;

  /// 是否还有下一页；为 false 时不再触发 near-end 加载
  final bool hasMore;
}

/// 加载判定的触发来源
enum LoadTriggerSource {
  /// 用户手势滚动结束
  userScroll,

  /// 主列切换后程序恢复子列位置（jumpToItem）
  programmaticRestore,

  /// 首屏初始化
  initial,
}

/// 单列分页状态
class ColumnLoadState {
  ColumnLoadState({
    required List<TPickerOption> options,
    this.hasMore = true,
    this.lastSelectedValue,
  }) : options = List<TPickerOption>.from(options);

  List<TPickerOption> options;
  bool hasMore;
  dynamic lastSelectedValue;
  bool loading = false;
}

/// 双列联动按需加载的缓存与分页状态
class LinkedColumnCache {
  LinkedColumnCache({
    required List<TPickerOption> initialPrimary,
    required List<TPickerOption> initialLinked,
    required dynamic initialPrimaryValue,
    bool primaryHasMore = true,
    bool linkedHasMore = true,
  })  : primary = ColumnLoadState(
          options: initialPrimary,
          hasMore: primaryHasMore,
        ),
        _linkedByPrimary = {
          initialPrimaryValue: ColumnLoadState(
            options: initialLinked,
            hasMore: linkedHasMore,
            lastSelectedValue:
                initialLinked.isEmpty ? null : initialLinked.first.value,
          ),
        };

  final ColumnLoadState primary;
  final Map<dynamic, ColumnLoadState> _linkedByPrimary;

  ColumnLoadState? linkedFor(dynamic primaryValue) =>
      _linkedByPrimary[primaryValue];

  ColumnLoadState linkedForOrCreate(dynamic primaryValue) {
    return _linkedByPrimary.putIfAbsent(
      primaryValue,
      () => ColumnLoadState(options: const []),
    );
  }

  void putLinked(dynamic primaryValue, ColumnLoadState state) {
    _linkedByPrimary[primaryValue] = state;
  }

  void appendPrimary(LazyLoadPage page) {
    primary.options.addAll(page.items);
    primary.hasMore = page.hasMore;
  }

  void appendLinked(dynamic primaryValue, LazyLoadPage page) {
    final state = linkedForOrCreate(primaryValue);
    state.options.addAll(page.items);
    state.hasMore = page.hasMore;
  }

  void replaceLinked(
    dynamic primaryValue,
    List<TPickerOption> options, {
    bool? hasMore,
    dynamic lastSelectedValue,
  }) {
    final state = linkedForOrCreate(primaryValue);
    state.options = List<TPickerOption>.from(options);
    if (hasMore != null) {
      state.hasMore = hasMore;
    }
    if (lastSelectedValue != null) {
      state.lastSelectedValue = lastSelectedValue;
    }
  }

  /// 解析子列应恢复的 value
  dynamic resolveLinkedValue(
    dynamic primaryValue,
    List<TPickerOption> options,
  ) {
    if (options.isEmpty) {
      return null;
    }
    final saved = _linkedByPrimary[primaryValue]?.lastSelectedValue;
    if (saved != null && options.any((o) => o.value == saved)) {
      return saved;
    }
    return options.first.value;
  }

  void rememberLinkedSelection(dynamic primaryValue, dynamic linkedValue) {
    linkedForOrCreate(primaryValue).lastSelectedValue = linkedValue;
  }
}

/// 纯函数：是否应在滚动结束时加载下一页
class LazyLoadPolicy {
  const LazyLoadPolicy._();

  /// [prevIndexAtScrollEnd] 为上一次 scroll-end 时该列索引（非 onChange 逐步索引）
  static bool shouldLoadAtScrollEnd({
    required int prevIndexAtScrollEnd,
    required int indexAtScrollEnd,
    required int loadedCount,
    required int threshold,
    required bool hasMore,
    required bool loading,
    required LoadTriggerSource source,
  }) {
    if (source != LoadTriggerSource.userScroll) {
      return false;
    }
    if (!hasMore || loading || loadedCount <= 0) {
      return false;
    }
    if (indexAtScrollEnd <= prevIndexAtScrollEnd) {
      return false;
    }
    return indexAtScrollEnd >= loadedCount - threshold;
  }
}
