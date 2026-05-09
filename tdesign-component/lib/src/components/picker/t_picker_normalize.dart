import 't_picker_keys.dart';
import 't_picker_option.dart';

/// 数据归一化工具
///
/// 把任意结构的 picker 数据统一成 `List<List<TPickerOption>>`（多列独立）
/// 或 `Map<TPickerOption, dynamic>`（联动）。
class TPickerNormalize {
  TPickerNormalize._();

  /// 归一化多列独立数据
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
  static Map<TPickerOption, dynamic> normalizeLinked(
      Map rawTree, TPickerKeys keys) {
    if (rawTree is Map<TPickerOption, dynamic>) {
      return rawTree;
    }
    return _convertLinkedMap(rawTree, keys);
  }

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

