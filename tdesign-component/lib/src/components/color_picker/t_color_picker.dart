import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/t_color_object.dart';
import 't_color_picker_palette.dart';
import 't_color_picker_theme_data.dart';
import 't_color_picker_types.dart';

/// mobile-vue `DEFAULT_SYSTEM_SWATCH_COLORS` 前 10 个，作为默认系统预设色板。
const List<String> _kDefaultSwatchColors = [
  '#ECF2FE',
  '#D4E3FC',
  '#BBD3FB',
  '#96BBF8',
  '#699EF5',
  '#4787F0',
  '#266FE8',
  '#0052D9',
  '#0034B5',
  '#001F97',
];

/// mobile-vue `DEFAULT_COLOR`，当 [TColorPicker.value] 为空时使用。
const String _kDefaultColor = '#001F97';

/// 颜色选择器组件，对齐 tdesign-mobile-vue `TColorPicker`。
///
/// 支持 `base`（仅系统预设色板）与 `multiple`（色板 + 色相条 + 透明条 +
/// 系统预设色板）两种类型，可输出 HEX / RGB / HSL / HSV / CMYK / CSS 等格式。
class TColorPicker extends StatefulWidget {
  const TColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.type = TColorPickerType.base,
    this.format = TColorPickerFormat.rgb,
    this.enableAlpha = false,
    this.swatchColors,
    this.clearable = false,
    this.onPaletteBarChange,
    this.themeData,
  });

  /// 受控色值，支持 HEX / RGB / RGBA / HSL / HSLA / HSV / HSVA / CMYK / CSS
  /// 任一格式。为空时使用默认色 `#001F97`。
  final String value;

  /// 选中色值变化时触发。`value` 为按 [format] 格式化后的新色值，
  /// [TColorPickerChangeContext.color] 为当前颜色对象，
  /// [TColorPickerChangeContext.trigger] 为触发来源。
  final ValueChanged<(String, TColorPickerChangeContext)> onChanged;

  /// 颜色选择器类型。默认 [TColorPickerType.base]。
  final TColorPickerType type;

  /// 输出格式。默认 [TColorPickerFormat.rgb]。
  final TColorPickerFormat format;

  /// 是否开启透明通道。为 true 时展示透明条，并输出带 alpha 的格式。
  final bool enableAlpha;

  /// 系统预设的颜色样例。`null` 使用内置默认色板；
  /// 空列表 `[]` 隐藏系统色板。
  final List<String>? swatchColors;

  /// 是否可清空。为 true 时展示"清除"按钮。
  final bool clearable;

  /// 调色板（饱和度/明度色板）拖拽过程回调，`color` 为当前颜色对象。
  final ValueChanged<TColorObject>? onPaletteBarChange;

  /// 实例级主题覆盖。
  final TColorPickerThemeData? themeData;

  @override
  State<TColorPicker> createState() => _TColorPickerState();
}

class _TColorPickerState extends State<TColorPicker> {
  late TColorObject _color;

  @override
  void initState() {
    super.initState();
    _color = _initColor();
  }

  @override
  void didUpdateWidget(TColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      // 仅当外部传入的 value 与当前内部输出不一致时重新解析，避免受控回传导致抖动。
      final current = _color.format(widget.format, enableAlpha: widget.enableAlpha);
      if (widget.value.isNotEmpty && widget.value != current) {
        _color = TColorObject(widget.value);
      }
    }
  }

  TColorObject _initColor() {
    if (widget.value.isNotEmpty) {
      return TColorObject(widget.value);
    }
    return TColorObject(_kDefaultColor);
  }

  List<String> get _swatchColors {
    final prop = widget.swatchColors;
    if (prop == null) {
      return _kDefaultSwatchColors;
    }
    return prop;
  }

  String get _formattedValue {
    return _color.format(widget.format, enableAlpha: widget.enableAlpha);
  }

  void _emitChange(TColorPickerChangeTrigger trigger) {
    final formatted = _formattedValue;
    widget.onChanged((formatted, TColorPickerChangeContext(_color, trigger)));
  }

  void _handleSaturationDrag(({double saturation, double value}) next) {
    setState(() {
      _color.saturation = next.saturation;
      _color.value = next.value;
    });
    widget.onPaletteBarChange?.call(_color);
  }

  void _handleHueChange(double hue) {
    setState(() => _color.hue = hue);
    _emitChange(TColorPickerChangeTrigger.paletteHueBar);
  }

  void _handleAlphaChange(double alpha) {
    setState(() => _color.alpha = alpha);
    _emitChange(TColorPickerChangeTrigger.paletteAlphaBar);
  }

  void _handleSwatchTap(String swatch) {
    setState(() => _color = TColorObject(swatch));
    _emitChange(TColorPickerChangeTrigger.preset);
  }

  void _handleClear() {
    _emitChange(TColorPickerChangeTrigger.clear);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TColorPickerThemeData>();
    final effectiveTheme = widget.themeData ?? theme;
    final panelBg = effectiveTheme?.panelBackgroundColor ?? context.tTheme.bgColorContainer;
    final panelRadius = effectiveTheme?.panelRadius ?? 12;
    final panelPadding = effectiveTheme?.panelPadding ?? const EdgeInsets.all(16);
    final swatchColors = _swatchColors;
    // 格式区文字 / 边框颜色使用全局 Token，保证深浅色模式下均可读。
    final formatTextColor = context.tTheme.textColorPrimary;
    final formatBorderColor = context.tTheme.componentBorderColor;

    return Container(
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(panelRadius),
      ),
      padding: panelPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.type == TColorPickerType.multiple) ...[
            TColorPickerSaturationPanel(
              color: _color,
              theme: effectiveTheme,
              onChanged: _handleSaturationDrag,
            ),
            // 区块间距对齐 mobile-vue：色板-滑块 16、滑块间 20、滑块-格式区 20。
            const SizedBox(height: 16),
            TColorPickerSlider(
              color: _color,
              isAlpha: false,
              theme: effectiveTheme,
              onChanged: _handleHueChange,
            ),
            if (widget.enableAlpha) ...[
              const SizedBox(height: 20),
              TColorPickerSlider(
                color: _color,
                isAlpha: true,
                theme: effectiveTheme,
                onChanged: _handleAlphaChange,
              ),
            ],
            const SizedBox(height: 20),
            _FormatDisplay(
              format: _effectiveFormat,
              color: _color,
              textColor: formatTextColor,
              borderColor: formatBorderColor,
            ),
            const SizedBox(height: 28),
          ],
          if (swatchColors.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.type == TColorPickerType.multiple)
                  const _SwatchesTitle(text: '系统预设色彩'),
                if (widget.clearable)
                  GestureDetector(
                    onTap: _handleClear,
                    child: Text(
                      '清除',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.tTheme.brandNormalColor,
                      ),
                    ),
                  ),
              ],
            ),
            // 对齐 mobile-vue：标题与色块行距 12，色块横向单行滚动、块间距 12。
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 12,
                children: [
                  for (final swatch in swatchColors)
                    _SwatchItem(
                      color: swatch,
                      selected: _isSelected(swatch),
                      theme: effectiveTheme,
                      onTap: () => _handleSwatchTap(swatch),
                    ),
                ],
              ),
            ),
          ],
          if (widget.clearable && swatchColors.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: _handleClear,
                child: Text(
                  '清除',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.tTheme.brandNormalColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  TColorPickerFormat get _effectiveFormat {
    if (widget.enableAlpha && widget.format.isAlphaConvertible) {
      return widget.format.alphaFormat;
    }
    return widget.format;
  }

  bool _isSelected(String swatch) {
    try {
      return TColorObject(swatch).toFlutterColor() == _color.toFlutterColor();
    } catch (_) {
      return false;
    }
  }
}

/// 格式区（对齐 mobile-vue `__format`）。
///
/// 左侧为格式名框（68px），右侧为各通道值连体分段框；与设计稿
/// `RGB | 0 | 26 | 87 | 100%` 一致。数值只读，输入属宿主层。
class _FormatDisplay extends StatelessWidget {
  const _FormatDisplay({
    required this.format,
    required this.color,
    required this.textColor,
    required this.borderColor,
  });

  final TColorPickerFormat format;
  final TColorObject color;

  /// 数值文字颜色，跟随全局 Token（深色模式为浅色）。
  final Color textColor;

  /// 分段框边框颜色，跟随全局 Token。
  final Color borderColor;

  static const double _firstWidth = 68;
  static const double _itemHeight = 36;

  TextStyle get _textStyle => TextStyle(
        fontSize: 14,
        height: 1,
        color: textColor,
      );

  @override
  Widget build(BuildContext context) {
    final segments = _buildSegments();
    return SizedBox(
      height: _itemHeight,
      child: Row(
        children: [
          // 格式名框。
          Container(
            width: _firstWidth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(6),
              ),
            ),
            child: Text(format.name.toUpperCase(), style: _textStyle),
          ),
          // 通道值框：相邻边共线合并，对齐 mobile-vue `__format-input`。
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < segments.length; i++)
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: borderColor),
                          bottom: BorderSide(color: borderColor),
                          right: BorderSide(color: borderColor),
                          left: i == 0
                              ? BorderSide(color: borderColor)
                              : BorderSide.none,
                        ),
                        borderRadius: BorderRadius.horizontal(
                          right: i == segments.length - 1
                              ? const Radius.circular(6)
                              : Radius.zero,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(segments[i], style: _textStyle, maxLines: 1),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建通道段：最后一段固定为百分比 alpha（CSS 只有一整段），
  /// 对齐 mobile-vue `getFormatList`。
  List<String> _buildSegments() {
    switch (format) {
      case TColorPickerFormat.hex:
        return [color.hex];
      case TColorPickerFormat.hex8:
        return [color.hex8];
      case TColorPickerFormat.css:
        return [color.css];
      case TColorPickerFormat.rgb:
        final v = color.getRgb();
        return ['${v.r}', '${v.g}', '${v.b}', _alphaText()];
      case TColorPickerFormat.rgba:
        final v = color.getRgb();
        return ['${v.r}', '${v.g}', '${v.b}', _alphaText()];
      case TColorPickerFormat.hsl:
      case TColorPickerFormat.hsla:
        final v = color.getHsl();
        return [
          '${v.h.round()}',
          '${(v.s * 100).round()}%',
          '${(v.l * 100).round()}%',
          _alphaText(),
        ];
      case TColorPickerFormat.hsv:
      case TColorPickerFormat.hsva:
        return [
          '${color.hue.round()}',
          '${(color.saturation * 100).round()}%',
          '${(color.value * 100).round()}%',
          _alphaText(),
        ];
      case TColorPickerFormat.cmyk:
        final v = color.getCmyk();
        return [
          '${v.c.round()}',
          '${v.m.round()}',
          '${v.y.round()}',
          '${v.k.round()}',
          _alphaText(),
        ];
    }
  }

  String _alphaText() => '${(color.alpha * 100).round()}%';
}

/// 系统预设色彩标题，字号加粗以贴近设计稿（mobile-vue font-title-medium）。
class _SwatchesTitle extends StatelessWidget {
  const _SwatchesTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: token.fontTitleSmall?.size ?? 14,
        fontWeight: FontWeight.w600,
        color: token.textColorPrimary,
      ),
    );
  }
}

/// 单个系统预设色块。
class _SwatchItem extends StatelessWidget {
  const _SwatchItem({
    required this.color,
    required this.selected,
    required this.onTap,
    this.theme,
  });

  final String color;
  final bool selected;
  final VoidCallback onTap;
  final TColorPickerThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final width = theme?.swatchWidth ?? 24;
    final height = theme?.swatchHeight ?? 24;
    final radius = theme?.swatchRadius ?? 3;
    final activeBorder = theme?.swatchActiveBorderColor ?? Colors.black26;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _parseColor(color),
          borderRadius: BorderRadius.circular(radius),
          border: selected
              ? Border.all(color: activeBorder, width: 1.5)
              : null,
        ),
      ),
    );
  }

  Color _parseColor(String c) {
    try {
      return TColorObject(c).toFlutterColor();
    } catch (_) {
      return Colors.transparent;
    }
  }
}
