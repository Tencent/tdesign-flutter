import 'picker_keys.dart';
import 'picker_option.dart';

/// 数据归一化工具
///
/// 把任意结构的 picker 数据统一成 `List<List<PickerOption>>`（多列独立）
/// 或 `Map<PickerOption, dynamic>`（联动）。
class PickerNormalize {
  PickerNormalize._();

  /// 归一化多列独立数据
  static List<List<PickerOption>> normalizeColumns(
      List rawColumns, PickerKeys keys) {
    if (rawColumns is List<List<PickerOption>>) {
      return rawColumns;
    }
    return [
      for (final col in rawColumns)
        if (col is List)
          [for (final raw in col) _toOption(raw, keys)]
        else
          <PickerOption>[],
    ];
  }

  /// 归一化联动树数据
  static Map<PickerOption, dynamic> normalizeLinked(
      Map rawTree, PickerKeys keys) {
    if (rawTree is Map<PickerOption, dynamic>) {
      return rawTree;
    }
    return _convertLinkedMap(rawTree, keys);
  }

  static PickerOption _toOption(dynamic raw, PickerKeys keys) {
    if (raw is PickerOption) {
      return raw;
    }
    if (raw is Map) {
      final label = raw[keys.label]?.toString() ?? '';
      final value = raw[keys.value];
      final disabledRaw = raw[keys.disabled];
      final disabled = disabledRaw is bool ? disabledRaw : false;
      return PickerOption(label: label, value: value, disabled: disabled);
    }
    return PickerOption(label: raw?.toString() ?? '', value: raw);
  }

  static Map<PickerOption, dynamic> _convertLinkedMap(
      Map src, PickerKeys keys) {
    final result = <PickerOption, dynamic>{};
    src.forEach((rawKey, rawVal) {
      final keyOpt = _toOption(rawKey, keys);
      result[keyOpt] = _convertChild(rawVal, keys);
    });
    return result;
  }

  static dynamic _convertChild(dynamic child, PickerKeys keys) {
    if (child is Map) {
      return _convertLinkedMap(child, keys);
    }
    if (child is List) {
      return [for (final r in child) _toOption(r, keys)];
    }
    return const <PickerOption>[];
  }
}
