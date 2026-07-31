import 'package:flutter/material.dart';

/// TInput 的内部装饰解析入口。
class TInputResolve {
  static InputDecoration resolveDecoration({
    InputDecoration? base,
    String? label,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
  }) {
    final source = base ?? const InputDecoration();
    return source.copyWith(
      labelText: source.labelText ?? label,
      hintText: source.hintText ?? hintText,
      hintMaxLines: source.hintMaxLines ?? 1,
      prefixIcon: source.prefixIcon ?? prefix,
      suffixIcon: source.suffixIcon ?? suffix,
      filled: source.filled ?? false,
      fillColor: source.fillColor ?? Colors.transparent,
      isCollapsed: source.isCollapsed ?? true,
      contentPadding: source.contentPadding ?? EdgeInsets.zero,
    );
  }
}
