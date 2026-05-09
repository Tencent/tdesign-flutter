import 'package:flutter/foundation.dart';

import 't_picker_keys.dart';
import 't_picker_normalize.dart';
import 't_picker_option.dart';

/// 选择器数据源密封类
///
/// 编译期强制二选一，消除运行时类型错误：
/// - [TPickerColumns] → 多列独立选择
/// - [TPickerLinked] → 联动选择
@immutable
sealed class TPickerItems {
  const TPickerItems();
}

/// 多列独立选择的数据源
///
/// ```dart
/// TPicker(
///   items: TPickerColumns([
///     [TPickerOption(label: '北京', value: 'BJ'), ...],
///     [TPickerOption(label: '朝阳区', value: 'CY'), ...],
///   ]),
/// )
/// ```
@immutable
class TPickerColumns extends TPickerItems {
  const TPickerColumns(this.columns);

  /// 从自由结构的 raw 数据创建，自动归一化
  ///
  /// ```dart
  /// TPickerColumns.fromRaw(
  ///   [['北京', '上海', '广州']],
  ///   keys: const TPickerKeys(label: 'name', value: 'code'),
  /// )
  /// ```
  factory TPickerColumns.fromRaw(
    List rawColumns, {
    TPickerKeys keys = TPickerKeys.defaults,
  }) {
    final normalized = TPickerNormalize.normalizeColumns(rawColumns, keys);
    return TPickerColumns(normalized);
  }

  /// 每列的选项列表
  final List<List<TPickerOption>> columns;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerColumns &&
          runtimeType == other.runtimeType &&
          _columnsEqual(columns, other.columns);

  /// 比较两个「多列独立」数据源是否相等（外层长度 + 内层逐元素）
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

/// 联动选择的数据源
///
/// ```dart
/// TPicker(
///   items: TPickerLinked({
///     TPickerOption(label: '广东', value: 'GD'): {
///       TPickerOption(label: '深圳', value: 'SZ'): [
///         TPickerOption(label: '南山', value: 'NS'),
///       ],
///     },
///   }),
/// )
/// ```
@immutable
class TPickerLinked extends TPickerItems {
  const TPickerLinked(this.tree);

  /// 从自由结构的 raw Map 数据创建，自动归一化
  ///
  /// ```dart
  /// TPickerLinked.fromRaw({
  ///   '广东': {'深圳': ['南山', '福田'], '广州': ['天河']},
  ///   '浙江': {'杭州': ['西湖']},
  /// })
  /// ```
  factory TPickerLinked.fromRaw(
    Map rawTree, {
    TPickerKeys keys = TPickerKeys.defaults,
  }) {
    final normalized = TPickerNormalize.normalizeLinked(rawTree, keys);
    return TPickerLinked(normalized);
  }

  /// 联动树结构：`Map<TPickerOption, dynamic>`
  ///
  /// value 可以是：
  /// - `Map<TPickerOption, dynamic>` → 下一级联动
  /// - `List<TPickerOption>` → 叶子级选项
  final Map<TPickerOption, dynamic> tree;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerLinked &&
          runtimeType == other.runtimeType &&
          _treeEqual(tree, other.tree);

  /// 比较两个联动树是否相等
  ///
  /// 注意：Map 的语义上是无序的，但联动选择器场景下 **插入顺序就是展示顺序**，
  /// 所以这里按**顺序**对比 key-value 对（效率高且符合业务语义）。
  /// 若业务层确实需要无序比较，请自行在调用前归一化。
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
  int get hashCode => Object.hashAll(tree.keys);
}
