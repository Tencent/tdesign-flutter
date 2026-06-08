import 'package:flutter/foundation.dart';

import 'picker_keys.dart';
import 'picker_normalize.dart';
import 'picker_option.dart';

/// 选择器数据源密封类
///
/// 编译期强制二选一，消除运行时类型错误：
/// - [TPickerColumns] → 多列独立选择（各列候选项互不影响）
/// - [TPickerLinked] → 联动选择（上游列变更后下游列自动裁剪并按新分支展开）
///
/// 自由结构数据（`List<List<String>>` / `Map<String, dynamic>` 等）请用
/// 对应子类的 `.fromRaw(...)` 工厂，**避免在 build 阶段直接 `new` 出已
/// 规范化的实例** —— `.fromRaw` 内部会做类型短路，传入已规范化的实例
/// 不产生额外拷贝；手动 `new` 时需要自行保证数据形态合规。
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
  /// [rawColumns] 原始多列数据；每列元素可为 `String` / `Map` / [TPickerOption]。
  ///
  /// [keys] 字段映射配置，默认 [TPickerKeys.defaults]。
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
  ///
  /// - **类型**：`List<List<TPickerOption>>`（外层为列，内层为该列候选项）
  /// - **空列**：保留列数与位置；组件内会做范围保护，越界访问回落首项
  /// - **不可变**：内容比较用 `==` 判等，原地 `addAll` 与 immutable 追加都会触发"列增长"路径
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
/// 适用于整棵联动树已在内存的场景（如省市区、月日联动、多级地址）；
/// 每列候选项建议在百级以内。上游列变更后，`TPicker` 会裁剪下游列并按新分支
/// 重新展开，默认选中各列首项。
///
/// 若需接口分页或远程逐级拉取，请改用 [TPickerColumns] 并在业务层封装 Scope
/// （见 example `LinkedLazyPickerScope`）。
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
  /// [rawTree] 原始联动树；key / value 可为 `String` / `Map` / `List` / [TPickerOption]。
  ///
  /// [keys] 字段映射配置，默认 [TPickerKeys.defaults]。
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
  /// - **类型**：`Map<TPickerOption, dynamic>`，key 为该列候选项
  /// - **下一级联动**：value 为 `Map<TPickerOption, dynamic>` 时继续下钻
  /// - **叶子级选项**：value 为 `List<TPickerOption>` 时结束递归
  /// - **顺序敏感**：插入顺序即展示顺序；`==` 判等按 entry 顺序遍历
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
  int get hashCode => Object.hashAll([
        ...tree.keys,
        ...tree.values.map((v) => v.hashCode),
      ]);
}
