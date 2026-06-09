import 'package:flutter/foundation.dart';

import 'picker_keys.dart';
import 'picker_normalize.dart';
import 'picker_option.dart';

// 数据源密封基类（包内类型标记）；业务请用 [TPickerColumns] 或 [TPickerLinked]
@immutable
sealed class TPickerItems {
  const TPickerItems();
}

/// 多列独立数据源，各列互不影响。松散数据（String/Map 等）用 `fromRaw`；已全是 [TPickerOption] 时用 `TPickerColumns([...])`。
@immutable
class TPickerColumns extends TPickerItems {
  const TPickerColumns(this.columns);

  /// 松散数据入口：将多列原始数据归一化为 [TPickerOption]
  ///
  /// [rawColumns] 外层为列，内层元素可为 String / Map / [TPickerOption]。
  ///
  /// [keys] 接口字段名映射，默认 [TPickerKeys.defaults]。
  factory TPickerColumns.fromRaw(
    List rawColumns, {
    TPickerKeys keys = TPickerKeys.defaults,
  }) {
    final normalized = TPickerNormalize.normalizeColumns(rawColumns, keys);
    return TPickerColumns(normalized);
  }

  /// 每列候选项（外层列、内层选项）
  final List<List<TPickerOption>> columns;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerColumns &&
          runtimeType == other.runtimeType &&
          _columnsEqual(columns, other.columns);

  // 比较两个多列数据源是否相等
  static bool _columnsEqual(
      List<List<TPickerOption>> a, List<List<TPickerOption>> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (!listEquals(a[i], b[i])) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(columns);
}

/// 联动树数据源，改上游会刷新下游列。整树在内存时用（如省市区）；远程分页请改用 [TPickerColumns]。
@immutable
class TPickerLinked extends TPickerItems {
  const TPickerLinked(this.tree);

  /// 松散数据入口：将嵌套 Map/List 联动树归一化为 [TPickerOption]
  ///
  /// [rawTree] Map 为上级，子 Map 继续下钻，List 为叶子列；元素可为 String / Map / List / [TPickerOption]。
  ///
  /// [keys] 接口字段名映射，默认 [TPickerKeys.defaults]。
  factory TPickerLinked.fromRaw(
    Map rawTree, {
    TPickerKeys keys = TPickerKeys.defaults,
  }) {
    final normalized = TPickerNormalize.normalizeLinked(rawTree, keys);
    return TPickerLinked(normalized);
  }

  /// 联动树；key 为候选项，value 为子级 Map 或叶子 List
  final Map<TPickerOption, dynamic> tree;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerLinked &&
          runtimeType == other.runtimeType &&
          _treeEqual(tree, other.tree);

  // 按插入顺序比较联动树（展示顺序即插入顺序）
  static bool _treeEqual(
      Map<TPickerOption, dynamic> a, Map<TPickerOption, dynamic> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    final aEntries = a.entries.iterator;
    final bEntries = b.entries.iterator;
    while (aEntries.moveNext() && bEntries.moveNext()) {
      if (aEntries.current.key != bEntries.current.key ||
          !_childEqual(aEntries.current.value, bEntries.current.value)) {
        return false;
      }
    }
    return true;
  }

  static bool _childEqual(dynamic a, dynamic b) {
    if (identical(a, b)) {
      return true;
    }
    if (a is Map<TPickerOption, dynamic> && b is Map<TPickerOption, dynamic>) {
      return _treeEqual(a, b);
    }
    if (a is List<TPickerOption> && b is List<TPickerOption>) {
      return listEquals(a, b);
    }
    return a == b;
  }

  @override
  int get hashCode => Object.hashAll([
        ...tree.keys,
        ...tree.values.map((v) => v.hashCode),
      ]);
}
