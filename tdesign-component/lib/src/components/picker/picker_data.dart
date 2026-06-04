import 'package:flutter/foundation.dart';

import 'picker_keys.dart';
import 'picker_normalize.dart';
import 'picker_option.dart';

/// 选择器数据源密封类
///
/// 编译期强制二选一，消除运行时类型错误：
/// - [PickerColumns] → 多列独立选择
/// - [PickerLinked] → 联动选择
@immutable
sealed class PickerItems {
  const PickerItems();
}

/// 多列独立选择的数据源
///
/// ```dart
/// TPicker(
///   items: PickerColumns([
///     [PickerOption(label: '北京', value: 'BJ'), ...],
///     [PickerOption(label: '朝阳区', value: 'CY'), ...],
///   ]),
/// )
/// ```
@immutable
class PickerColumns extends PickerItems {
  const PickerColumns(this.columns);

  /// 从自由结构的 raw 数据创建，自动归一化
  ///
  /// ```dart
  /// PickerColumns.fromRaw(
  ///   [['北京', '上海', '广州']],
  ///   keys: const PickerKeys(label: 'name', value: 'code'),
  /// )
  /// ```
  factory PickerColumns.fromRaw(
    List rawColumns, {
    PickerKeys keys = PickerKeys.defaults,
  }) {
    final normalized = PickerNormalize.normalizeColumns(rawColumns, keys);
    return PickerColumns(normalized);
  }

  /// 每列的选项列表
  final List<List<PickerOption>> columns;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickerColumns &&
          runtimeType == other.runtimeType &&
          _columnsEqual(columns, other.columns);

  /// 比较两个「多列独立」数据源是否相等（外层长度 + 内层逐元素）
  static bool _columnsEqual(
      List<List<PickerOption>> a, List<List<PickerOption>> b) {
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
/// 适用于整棵联动树已在内存的场景（如省市区、月日联动、多级地址）；
/// 每列候选项建议在百级以内。上游列变更后，[TPicker] 会裁剪下游列并按新分支
/// 重新展开，默认选中各列首项。
///
/// 若需接口分页或远程逐级拉取，请改用 [PickerColumns] 并在业务层封装 Scope
/// （见 example LinkedLazyPickerScope）。
///
/// ```dart
/// TPicker(
///   items: PickerLinked({
///     PickerOption(label: '广东', value: 'GD'): {
///       PickerOption(label: '深圳', value: 'SZ'): [
///         PickerOption(label: '南山', value: 'NS'),
///       ],
///     },
///   }),
/// )
/// ```
@immutable
class PickerLinked extends PickerItems {
  const PickerLinked(this.tree);

  /// 从自由结构的 raw Map 数据创建，自动归一化
  ///
  /// ```dart
  /// PickerLinked.fromRaw({
  ///   '广东': {'深圳': ['南山', '福田'], '广州': ['天河']},
  ///   '浙江': {'杭州': ['西湖']},
  /// })
  /// ```
  factory PickerLinked.fromRaw(
    Map rawTree, {
    PickerKeys keys = PickerKeys.defaults,
  }) {
    final normalized = PickerNormalize.normalizeLinked(rawTree, keys);
    return PickerLinked(normalized);
  }

  /// 联动树结构：`Map<PickerOption, dynamic>`
  ///
  /// value 可以是：
  /// - `Map<PickerOption, dynamic>` → 下一级联动
  /// - `List<PickerOption>` → 叶子级选项
  final Map<PickerOption, dynamic> tree;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickerLinked &&
          runtimeType == other.runtimeType &&
          _treeEqual(tree, other.tree);

  /// 比较两个联动树是否相等
  ///
  /// 注意：Map 的语义上是无序的，但联动选择器场景下 **插入顺序就是展示顺序**，
  /// 所以这里按**顺序**对比 key-value 对（效率高且符合业务语义）。
  /// 若业务层确实需要无序比较，请自行在调用前归一化。
  static bool _treeEqual(
      Map<PickerOption, dynamic> a, Map<PickerOption, dynamic> b) {
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
    if (a is Map<PickerOption, dynamic> && b is Map<PickerOption, dynamic>) {
      return _treeEqual(a, b);
    }
    if (a is List<PickerOption> && b is List<PickerOption>) {
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
