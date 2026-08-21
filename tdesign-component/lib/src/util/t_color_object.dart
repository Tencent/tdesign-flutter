import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 颜色格式枚举，对齐 tdesign-mobile-vue `TdColorPickerProps.format`。
///
/// 默认 [TColorPickerFormat.rgb]。当 [TColorObject.format] 的
/// [TColorPickerFormat.isAlphaConvertible] 对应格式不存在时，自动升级为带
/// alpha 的格式（`hex`→`hex8`、`rgb`→`rgba`、`hsl`→`hsla`、`hsv`→`hsva`）。
enum TColorPickerFormat {
  /// HEX，如 `#0052D9`
  hex,

  /// HEX8，如 `#0052D9FF`，含 alpha
  hex8,

  /// RGB，如 `rgb(0, 82, 217)`
  rgb,

  /// RGBA，如 `rgba(0, 82, 217, 1)`
  rgba,

  /// HSL，如 `hsl(337, 100%, 42%)`
  hsl,

  /// HSLA，如 `hsla(337, 100%, 42%, 1)`
  hsla,

  /// HSV，如 `hsv(337, 100%, 85%)`
  hsv,

  /// HSVA，如 `hsva(337, 100%, 85%, 1)`
  hsva,

  /// CMYK，如 `cmyk(100, 62, 0, 15)`
  cmyk,

  /// CSS，等价于 rgba
  css;

  /// 判断当前格式是否为非透明格式，且存在对应的透明升级格式。
  bool get isAlphaConvertible => switch (this) {
        TColorPickerFormat.hex ||
        TColorPickerFormat.rgb ||
        TColorPickerFormat.hsl ||
        TColorPickerFormat.hsv =>
          true,
        _ => false,
      };

  /// 升级为带 alpha 的格式（对齐 tdesign-common `ALPHA_FORMAT_MAP`）。
  TColorPickerFormat get alphaFormat => switch (this) {
        TColorPickerFormat.hex => TColorPickerFormat.hex8,
        TColorPickerFormat.rgb => TColorPickerFormat.rgba,
        TColorPickerFormat.hsl => TColorPickerFormat.hsla,
        TColorPickerFormat.hsv => TColorPickerFormat.hsva,
        _ => this,
      };
}

/// 纯 Dart 颜色工具类，无第三方依赖。
///
/// 负责从字符串解析颜色、在 RGB / HSL / HSV / CMYK / HEX 色彩空间间转换，
/// 并按需格式化为字符串。内部以 HSV 作为规范状态存储（对齐 tdesign-mobile-vue
/// 的 `Color` 类），对外通过 getter / setter 读写分量，分量 setter 会做范围裁剪。
class TColorObject {
  double _hue = 0; // 0-360
  double _saturation = 1; // 0-1
  double _value = 1; // 0-1
  double _alpha = 1; // 0-1

  /// 从 [input] 构造颜色对象。支持 HEX / HEX8 / RGB / RGBA / HSL / HSLA /
  /// HSV / HSVA / CMYK / CSS（rgba）等常见字符串格式。
  TColorObject(String input) {
    _parse(input);
  }

  /// 从 HSV 分量构造。
  TColorObject.fromHsv(
    double hue,
    double saturation,
    double value, {
    double alpha = 1,
  }) {
    _hue = _clamp(hue, 0, 360);
    _saturation = _clamp(saturation, 0, 1);
    _value = _clamp(value, 0, 1);
    _alpha = _clamp(alpha, 0, 1);
  }

  /// 复制当前颜色对象。
  TColorObject copy() {
    return TColorObject.fromHsv(_hue, _saturation, _value, alpha: _alpha);
  }

  /// 色相（0-360）。
  double get hue => _hue;

  set hue(double value) {
    _hue = _clamp(value, 0, 360);
  }

  /// 饱和度（0-1）。
  double get saturation => _saturation;

  set saturation(double value) {
    _saturation = _clamp(value, 0, 1);
  }

  /// 明度 / 值（0-1）。
  double get value => _value;

  set value(double value) {
    _value = _clamp(value, 0, 1);
  }

  /// 透明度（0-1）。
  double get alpha => _alpha;

  set alpha(double value) {
    _alpha = _clamp(value, 0, 1);
  }

  /// 解析输入字符串。
  void _parse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return;
    }

    // CMYK
    final cmykMatch = RegExp(
      r'^cmyk\s*\(\s*([\d.]+)%?\s*,\s*([\d.]+)%?\s*,\s*([\d.]+)%?\s*,\s*([\d.]+)%?\s*\)',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (cmykMatch != null) {
      _fromCmyk(
        double.parse(cmykMatch.group(1)!),
        double.parse(cmykMatch.group(2)!),
        double.parse(cmykMatch.group(3)!),
        double.parse(cmykMatch.group(4)!),
      );
      return;
    }

    // rgb / rgba
    final rgbMatch = RegExp(
      r'^rgba?\(([^)]*)\)',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (rgbMatch != null) {
      final parts = _splitComma(rgbMatch.group(1)!);
      if (parts.length >= 3) {
        final r = _parseComponent(parts[0], 255);
        final g = _parseComponent(parts[1], 255);
        final b = _parseComponent(parts[2], 255);
        final a = parts.length > 3 ? _parseAlpha(parts[3]) : 1;
        _fromRgb(r, g, b, a);
        return;
      }
    }

    // hsl / hsla
    final hslMatch = RegExp(
      r'^hsla?\(([^)]*)\)',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (hslMatch != null) {
      final parts = _splitComma(hslMatch.group(1)!);
      if (parts.length >= 3) {
        final h = _parseComponent(parts[0], 360);
        final s = _parseComponent(parts[1], 1);
        final l = _parseComponent(parts[2], 1);
        final a = parts.length > 3 ? _parseAlpha(parts[3]) : 1;
        _fromHsl(h, s, l, a);
        return;
      }
    }

    // hsv / hsva
    final hsvMatch = RegExp(
      r'^hsva?\(([^)]*)\)',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (hsvMatch != null) {
      final parts = _splitComma(hsvMatch.group(1)!);
      if (parts.length >= 3) {
        final h = _parseComponent(parts[0], 360);
        final s = _parseComponent(parts[1], 1);
        final v = _parseComponent(parts[2], 1);
        final a = parts.length > 3 ? _parseAlpha(parts[3]) : 1;
        _hue = _clamp(h, 0, 360);
        _saturation = _clamp(s, 0, 1);
        _value = _clamp(v, 0, 1);
        _alpha = _clamp(a, 0, 1);
        return;
      }
    }

    // hex / hex8
    final hexMatch = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8}|[0-9a-fA-F]{3})$')
        .firstMatch(trimmed);
    if (hexMatch != null) {
      final hex = hexMatch.group(1)!;
      if (hex.length == 3) {
        final r = int.parse(hex[0] * 2, radix: 16);
        final g = int.parse(hex[1] * 2, radix: 16);
        final b = int.parse(hex[2] * 2, radix: 16);
        _fromRgb(r, g, b, 1);
      } else if (hex.length == 6) {
        final r = int.parse(hex.substring(0, 2), radix: 16);
        final g = int.parse(hex.substring(2, 4), radix: 16);
        final b = int.parse(hex.substring(4, 6), radix: 16);
        _fromRgb(r, g, b, 1);
      } else {
        final r = int.parse(hex.substring(0, 2), radix: 16);
        final g = int.parse(hex.substring(2, 4), radix: 16);
        final b = int.parse(hex.substring(4, 6), radix: 16);
        final a = int.parse(hex.substring(6, 8), radix: 16) / 255;
        _fromRgb(r, g, b, a);
      }
      return;
    }
  }

  static double _clamp(double v, double min, double max) {
    return v.clamp(min, max).toDouble();
  }

  static List<String> _splitComma(String s) {
    return s.split(',').map((e) => e.trim()).toList();
  }

  /// 解析数值分量，支持百分比（此时按 [max] 折算）。
  static double _parseComponent(String s, double max) {
    final str = s.trim();
    if (str.endsWith('%')) {
      return double.parse(str.substring(0, str.length - 1)) / 100 * max;
    }
    return double.parse(str);
  }

  /// 解析 alpha，支持 0-1 数字或百分比。
  static double _parseAlpha(String s) {
    final str = s.trim();
    if (str.endsWith('%')) {
      return double.parse(str.substring(0, str.length - 1)) / 100;
    }
    return double.parse(str);
  }

  void _fromRgb(int r, int g, int b, double a) {
    final rd = _clamp(r / 255, 0, 1);
    final gd = _clamp(g / 255, 0, 1);
    final bd = _clamp(b / 255, 0, 1);
    final max = math.max(rd, math.max(gd, bd));
    final min = math.min(rd, math.min(gd, bd));
    final delta = max - min;

    double h = 0;
    if (delta != 0) {
      if (max == rd) {
        h = 60 * (((gd - bd) / delta) % 6);
      } else if (max == gd) {
        h = 60 * ((bd - rd) / delta + 2);
      } else {
        h = 60 * ((rd - gd) / delta + 4);
      }
    }
    if (h < 0) h += 360;

    final s = max == 0 ? 0 : delta / max;
    _hue = h;
    _saturation = s;
    _value = max;
    _alpha = _clamp(a, 0, 1);
  }

  void _fromHsl(double h, double s, double l, double a) {
    final hue = h % 360;
    final sat = _clamp(s, 0, 1);
    final lig = _clamp(l, 0, 1);

    final c = (1 - (2 * lig - 1).abs()) * sat;
    final x = c * (1 - (((hue / 60) % 2) - 1).abs());
    final m = lig - c / 2;

    double rd = 0, gd = 0, bd = 0;
    if (hue < 60) {
      rd = c;
      gd = x;
    } else if (hue < 120) {
      rd = x;
      gd = c;
    } else if (hue < 180) {
      gd = c;
      bd = x;
    } else if (hue < 240) {
      gd = x;
      bd = c;
    } else if (hue < 300) {
      rd = x;
      bd = c;
    } else {
      rd = c;
      bd = x;
    }
    _fromRgb(
      ((rd + m) * 255).round(),
      ((gd + m) * 255).round(),
      ((bd + m) * 255).round(),
      a,
    );
  }

  void _fromCmyk(double c, double m, double y, double k) {
    final cc = c / 100;
    final mm = m / 100;
    final yy = y / 100;
    final kk = k / 100;
    final r = (1 - cc) * (1 - kk);
    final g = (1 - mm) * (1 - kk);
    final b = (1 - yy) * (1 - kk);
    _fromRgb(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      1,
    );
  }

  /// RGB 分量（0-255 四舍五入）。
  ({int r, int g, int b}) getRgb() {
    final h = _hue;
    final s = _saturation;
    final v = _value;
    final c = v * s;
    final x = c * (1 - (((h / 60) % 2) - 1).abs());
    final m = v - c;

    double rd = 0, gd = 0, bd = 0;
    if (h < 60) {
      rd = c;
      gd = x;
    } else if (h < 120) {
      rd = x;
      gd = c;
    } else if (h < 180) {
      gd = c;
      bd = x;
    } else if (h < 240) {
      gd = x;
      bd = c;
    } else if (h < 300) {
      rd = x;
      bd = c;
    } else {
      rd = c;
      bd = x;
    }
    return (
      r: ((rd + m) * 255).round(),
      g: ((gd + m) * 255).round(),
      b: ((bd + m) * 255).round(),
    );
  }

  /// HSL 分量（h 0-360，s/l 0-1）。
  ({double h, double s, double l}) getHsl() {
    final rgb = getRgb();
    final rd = rgb.r / 255;
    final gd = rgb.g / 255;
    final bd = rgb.b / 255;
    final max = math.max(rd, math.max(gd, bd));
    final min = math.min(rd, math.min(gd, bd));
    final l = (max + min) / 2;
    final delta = max - min;

    double h = _hue;
    double s = 0;
    if (delta != 0) {
      s = delta / (1 - (2 * l - 1).abs());
      if (max == rd) {
        h = 60 * (((gd - bd) / delta) % 6);
      } else if (max == gd) {
        h = 60 * ((bd - rd) / delta + 2);
      } else {
        h = 60 * ((rd - gd) / delta + 4);
      }
      if (h < 0) h += 360;
    }
    return (h: h, s: s, l: l);
  }

  /// HSV 分量（h 0-360，s/v 0-1）。
  ({double h, double s, double v}) getHsv() {
    return (h: _hue, s: _saturation, v: _value);
  }

  /// CMYK 分量（0-100）。
  ({double c, double m, double y, double k}) getCmyk() {
    final rgb = getRgb();
    final rd = rgb.r / 255;
    final gd = rgb.g / 255;
    final bd = rgb.b / 255;

    if (rd == 0 && gd == 0 && bd == 0) {
      return (c: 0, m: 0, y: 0, k: 100);
    }
    final computedC = 1 - rd;
    final computedM = 1 - gd;
    final computedY = 1 - bd;
    final min = math.min(computedC, math.min(computedM, computedY));
    final c = (computedC - min) / (1 - min);
    final m = (computedM - min) / (1 - min);
    final y = (computedY - min) / (1 - min);
    final k = min;
    return (
      c: (c * 100).round().toDouble(),
      m: (m * 100).round().toDouble(),
      y: (y * 100).round().toDouble(),
      k: (k * 100).round().toDouble(),
    );
  }

  /// 十六进制色值，如 `#0052D9`。
  String get hex {
    final rgb = getRgb();
    return '#${_two(rgb.r)}${_two(rgb.g)}${_two(rgb.b)}';
  }

  /// 十六进制色值（含 alpha），如 `#0052D9FF`。
  String get hex8 {
    return '$hex${_two((_alpha * 255).round())}';
  }

  /// RGB 字符串，如 `rgb(0, 82, 217)`。
  String get rgb {
    final v = getRgb();
    return 'rgb(${v.r}, ${v.g}, ${v.b})';
  }

  /// RGBA 字符串，如 `rgba(0, 82, 217, 1)`。
  String get rgba {
    final v = getRgb();
    final a = _formatAlpha(_alpha);
    return 'rgba(${v.r}, ${v.g}, ${v.b}, $a)';
  }

  /// HSL 字符串，如 `hsl(337, 100%, 42%)`。
  String get hsl {
    final v = getHsl();
    return 'hsl(${_round(v.h)}, ${_round(v.s * 100)}%, ${_round(v.l * 100)}%)';
  }

  /// HSLA 字符串，如 `hsla(337, 100%, 42%, 1)`。
  String get hsla {
    final v = getHsl();
    final a = _formatAlpha(_alpha);
    return 'hsla(${_round(v.h)}, ${_round(v.s * 100)}%, ${_round(v.l * 100)}%, $a)';
  }

  /// HSV 字符串，如 `hsv(337, 100%, 85%)`。
  String get hsv {
    return 'hsv(${_round(_hue)}, ${_round(_saturation * 100)}%, ${_round(_value * 100)}%)';
  }

  /// HSVA 字符串，如 `hsva(337, 100%, 85%, 1)`。
  String get hsva {
    final a = _formatAlpha(_alpha);
    return 'hsva(${_round(_hue)}, ${_round(_saturation * 100)}%, ${_round(_value * 100)}%, $a)';
  }

  /// CMYK 字符串，如 `cmyk(100, 62, 0, 15)`。
  String get cmyk {
    final v = getCmyk();
    return 'cmyk(${_round(v.c)}, ${_round(v.m)}, ${_round(v.y)}, ${_round(v.k)})';
  }

  /// CSS 字符串，等价于 [rgba]。
  String get css => rgba;

  /// 按 [format] 与 [enableAlpha] 输出格式化字符串。
  ///
  /// 当 [enableAlpha] 为 true 且 [format] 为非透明格式（hex/rgb/hsl/hsv）时，
  /// 自动升级为对应带 alpha 的格式（hex8/rgba/hsla/hsva）。
  String format(TColorPickerFormat format, {bool enableAlpha = false}) {
    final effective =
        enableAlpha && format.isAlphaConvertible ? format.alphaFormat : format;
    return switch (effective) {
      TColorPickerFormat.hex => hex,
      TColorPickerFormat.hex8 => hex8,
      TColorPickerFormat.rgb => rgb,
      TColorPickerFormat.rgba => rgba,
      TColorPickerFormat.hsl => hsl,
      TColorPickerFormat.hsla => hsla,
      TColorPickerFormat.hsv => hsv,
      TColorPickerFormat.hsva => hsva,
      TColorPickerFormat.cmyk => cmyk,
      TColorPickerFormat.css => css,
    };
  }

  /// 输出为 Flutter [Color]（ARGB）。
  Color toFlutterColor() {
    final v = getRgb();
    return Color.fromARGB(
      (_alpha * 255).round(),
      v.r,
      v.g,
      v.b,
    );
  }

  static String _two(int v) {
    return v.toRadixString(16).padLeft(2, '0').toUpperCase();
  }

  static int _round(double v) => v.round();

  static String _formatAlpha(double a) {
    final rounded = (a * 100).round() / 100;
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toString();
  }
}
