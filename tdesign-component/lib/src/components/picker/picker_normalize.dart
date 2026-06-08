import 'package:meta/meta.dart';

import 'picker_keys.dart';
import 'picker_option.dart';

/// 自由结构数据 → 规范化 `TPickerOption` 树的归一化工具
///
/// `TPickerColumns.fromRaw` / `TPickerLinked.fromRaw` 在构造时调用本类的
/// 静态方法把 `List` / `Map` 转成 `List<List<TPickerOption>>` 或
/// `Map<TPickerOption, dynamic>`，让 `TPicker` 内部只需面对一种数据形态。
///
/// 类型短路：若传入的 `raw` 已经是目标类型，**直接返回**而不深拷贝，
/// 避免在父级每帧用 `.fromRaw(...)` 构造 items 时产生大量临时对象。
@internal
class TPickerNormalize {
  TPickerNormalize._();

  /// 归一化多列独立数据
  ///
  /// - 已是 `List<List<TPickerOption>>` 时直接返回（无拷贝）。
  /// - 否则按 `keys` 字段映射每个元素为 [TPickerOption]；非 `List` 列
  ///   退化为空列（保留列数，避免下游索引越界）。
  static List<List<TPickerOption>> normalizeColumns(
      List rawColumns, TPickerKeys keys) {
    if (rawColumns is List<List<TPickerOption>>) {
      return rawColumns;
    }
    return [
      for (final col in rawColumns)
        if (col is List)
          [for (final raw in col) _toOption(raw, keys)]
        else
          <TPickerOption>[],
    ];
  }

  /// 归一化联动树数据
  ///
  /// - 已是 `Map<TPickerOption, dynamic>` 时直接返回（无拷贝）。
  /// - 否则按 `keys` 逐层下钻：value 为 `Map` 视为下一级联动，为
  ///   `List` 视为叶子级选项；非 `Map`/`List` 退化为空叶子。
  static Map<TPickerOption, dynamic> normalizeLinked(
      Map rawTree, TPickerKeys keys) {
    if (rawTree is Map<TPickerOption, dynamic>) {
      return rawTree;
    }
    return _convertLinkedMap(rawTree, keys);
  }

  /// 单条 `raw` → [TPickerOption] 的转换
  ///
  /// 优先级：已是 [TPickerOption] → 透传；是 `Map` → 按 `keys` 读字段；
  /// 其他 → `toString()` 作为 label，原值作为 value。
  static TPickerOption _toOption(dynamic raw, TPickerKeys keys) {
    if (raw is TPickerOption) {
      return raw;
    }
    if (raw is Map) {
      final label = raw[keys.label]?.toString() ?? '';
      final value = raw[keys.value];
      final disabledRaw = raw[keys.disabled];
      final disabled = disabledRaw is bool ? disabledRaw : false;
      return TPickerOption(label: label, value: value, disabled: disabled);
    }
    return TPickerOption(label: raw?.toString() ?? '', value: raw);
  }

  static Map<TPickerOption, dynamic> _convertLinkedMap(
      Map src, TPickerKeys keys) {
    final result = <TPickerOption, dynamic>{};
    src.forEach((rawKey, rawVal) {
      final keyOpt = _toOption(rawKey, keys);
      result[keyOpt] = _convertChild(rawVal, keys);
    });
    return result;
  }

  static dynamic _convertChild(dynamic child, TPickerKeys keys) {
    if (child is Map) {
      return _convertLinkedMap(child, keys);
    }
    if (child is List) {
      return [for (final r in child) _toOption(r, keys)];
    }
    return const <TPickerOption>[];
  }
}
