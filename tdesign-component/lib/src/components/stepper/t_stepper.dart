import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_stepper_theme_data.dart';
import 't_stepper_types.dart';

export 't_stepper_types.dart';

/// TDesign 数值步进器。
///
/// 组件严格受控：[value] 是唯一数据源，按钮、输入提交及失焦只通过
/// [onChanged] 请求变更，父组件需要以新 [value] 重建组件。若父组件不接受
/// 新值，输入内容会恢复为当前 [value]。
///
/// [onChanged] 为 null 时输入框和两个按钮整组禁用。样式优先级为实例
/// [size]/[variant]、[TStepperThemeData]、Flutter 子树及全局 ThemeData，
/// 最后回退 TDesign token。
class TStepper extends StatefulWidget {
  const TStepper({
    super.key,

    /// 受控数值，必须位于 [min] 与 [max] 之间。
    required this.value,

    /// 数值变化请求。
    ///
    /// 点击按钮、提交有效输入或输入框失焦时触发；一次操作最多触发一次。
    /// 为 null 时整组禁用。
    this.onChanged,

    /// 最小值，必须小于或等于 [max]。
    this.min = 0,

    /// 最大值，必须大于或等于 [min]。
    this.max = 100,

    /// 加减按钮使用的步长，必须大于 0。
    ///
    /// 输入提交不要求是步长的整数倍，但会限制在 [min] 与 [max] 之间。
    this.step = 1,

    /// 组件尺寸。
    ///
    /// 为空时依次使用 [TStepperThemeData.size] 和
    /// [TStepperSize.medium]。
    this.size,

    /// 组件形态。
    ///
    /// 为空时依次使用 [TStepperThemeData.variant] 和
    /// [TStepperVariant.normal]。
    this.variant,
  })  : assert(min <= max),
        assert(value >= min && value <= max),
        assert(step > 0);

  /// 唯一受控数值，必须位于 [min] 与 [max] 之间。
  ///
  /// 父组件需要在 [onChanged] 后以新值重建组件，否则输入内容会恢复。
  final num value;

  /// 数值变化请求；一次操作最多触发一次，为 null 时整组禁用。
  final ValueChanged<num>? onChanged;

  /// 最小值，必须小于或等于 [max]。
  final num min;

  /// 最大值，必须大于或等于 [min]。
  final num max;

  /// 加减按钮使用的正数步长；直接输入不要求是步长的整数倍。
  final num step;

  /// 组件尺寸；为空时依次使用组件主题和 [TStepperSize.medium]。
  final TStepperSize? size;

  /// 组件形态；为空时依次使用组件主题和 [TStepperVariant.normal]。
  final TStepperVariant? variant;

  @override
  State<TStepper> createState() => _TStepperState();
}

class _TStepperState extends State<TStepper> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  bool _editing = false;

  bool get _disabled => widget.onChanged == null;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _format(widget.value));
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant TStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _editing = false;
      _setText(widget.value);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _StepperStyle.resolve(context, widget);
    final canDecrease = !_disabled && widget.value > widget.min;
    final canIncrease = !_disabled && widget.value < widget.max;
    final spacing =
        style.variant == TStepperVariant.outline ? 0.0 : style.spacing;

    return Semantics(
      container: true,
      enabled: !_disabled,
      value: _format(widget.value),
      child: TextFieldTapRegion(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepperButton(
              icon: TIcons.minus,
              semanticLabel: '减少',
              position: _StepperButtonPosition.leading,
              style: style,
              globallyDisabled: _disabled,
              actionDisabled: !canDecrease,
              onPressed: () => _stepBy(-widget.step),
            ),
            SizedBox(width: spacing),
            _buildInput(style),
            SizedBox(width: spacing),
            _StepperButton(
              icon: TIcons.plus,
              semanticLabel: '增加',
              position: _StepperButtonPosition.trailing,
              style: style,
              globallyDisabled: _disabled,
              actionDisabled: !canIncrease,
              onPressed: () => _stepBy(widget.step),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(_StepperStyle style) {
    final globallyDisabled = _disabled;
    final inputTextStyle =
        globallyDisabled ? style.disabledTextStyle : style.textStyle;
    final backgroundColor = switch (style.variant) {
      TStepperVariant.normal => Colors.transparent,
      TStepperVariant.filled => globallyDisabled
          ? style.disabledBackgroundColor
          : style.backgroundColor,
      TStepperVariant.outline =>
        globallyDisabled ? style.disabledBackgroundColor : Colors.transparent,
    };
    final border = style.variant == TStepperVariant.outline
        ? Border(
            top: BorderSide(
              color: style.borderColor,
              width: style.borderWidth,
            ),
            bottom: BorderSide(
              color: style.borderColor,
              width: style.borderWidth,
            ),
          )
        : null;

    return SizedBox(
      width: style.inputWidth,
      height: style.controlSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: style.variant == TStepperVariant.outline
              ? null
              : style.borderRadius,
        ),
        child: IgnorePointer(
          ignoring: globallyDisabled,
          child: Center(
            child: EditableText(
              controller: _textController,
              focusNode: _focusNode,
              readOnly: globallyDisabled,
              autocorrect: false,
              enableSuggestions: false,
              maxLines: 1,
              textAlign: TextAlign.center,
              strutStyle: StrutStyle.fromTextStyle(
                inputTextStyle,
                forceStrutHeight: true,
              ),
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: widget.min < 0,
              ),
              style: inputTextStyle,
              cursorColor: style.foregroundColor,
              backgroundCursorColor: style.disabledForegroundColor,
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return RegExp(r'^-?\d*\.?\d*$').hasMatch(newValue.text)
                      ? newValue
                      : oldValue;
                }),
              ],
              onChanged: (_) => _editing = true,
              onSubmitted: (_) => _submitDraft(unfocus: true),
              onTapOutside: (_) => _submitDraft(unfocus: true),
            ),
          ),
        ),
      ),
    );
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _editing) {
      _submitDraft(unfocus: false);
    }
  }

  void _stepBy(num delta) {
    final draft = num.tryParse(_textController.text);
    final base = _editing && draft != null ? draft : widget.value;
    _requestChange(
      _normalizeStepResult(base + delta, base),
      unfocus: true,
    );
  }

  void _submitDraft({required bool unfocus}) {
    final parsed = num.tryParse(_textController.text);
    if (parsed == null) {
      _editing = false;
      _setText(widget.value);
      if (unfocus) {
        _focusNode.unfocus();
      }
      return;
    }
    _requestChange(parsed, unfocus: unfocus);
  }

  void _requestChange(num next, {required bool unfocus}) {
    final clamped = next.clamp(widget.min, widget.max);
    _editing = false;
    if (unfocus) {
      _focusNode.unfocus();
    }
    if (clamped == widget.value) {
      _setText(widget.value);
      return;
    }

    widget.onChanged?.call(clamped);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_focusNode.hasFocus) {
        _setText(widget.value);
      }
    });
  }

  num _normalizeStepResult(num value, num base) {
    final precision = [
      _decimalPlaces(widget.step),
      _decimalPlaces(base),
      _decimalPlaces(widget.min),
      _decimalPlaces(widget.max),
    ].reduce(math.max).clamp(0, 12);
    if (precision == 0) {
      return value.round();
    }
    final rounded = double.parse(value.toStringAsFixed(precision));
    return rounded % 1 == 0 ? rounded.toInt() : rounded;
  }

  int _decimalPlaces(num value) {
    final text = value.abs().toString().toLowerCase();
    final exponentIndex = text.indexOf('e');
    final mantissa =
        exponentIndex == -1 ? text : text.substring(0, exponentIndex);
    final exponent = exponentIndex == -1
        ? 0
        : int.tryParse(text.substring(exponentIndex + 1)) ?? 0;
    final decimalIndex = mantissa.indexOf('.');
    final decimals =
        decimalIndex == -1 ? 0 : mantissa.length - decimalIndex - 1;
    return math.max(0, decimals - exponent);
  }

  void _setText(num value) {
    final text = _format(value);
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String _format(num value) {
    if (value is int) {
      return value.toString();
    }
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }
}

enum _StepperButtonPosition { leading, trailing }

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.semanticLabel,
    required this.position,
    required this.style,
    required this.globallyDisabled,
    required this.actionDisabled,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final _StepperButtonPosition position;
  final _StepperStyle style;
  final bool globallyDisabled;
  final bool actionDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final disabled = globallyDisabled || actionDisabled;
    final backgroundColor = switch (style.variant) {
      TStepperVariant.normal => Colors.transparent,
      TStepperVariant.filled => globallyDisabled
          ? style.disabledBackgroundColor
          : style.backgroundColor,
      TStepperVariant.outline =>
        globallyDisabled ? style.disabledBackgroundColor : Colors.transparent,
    };
    final border = style.variant == TStepperVariant.outline
        ? Border.all(
            color: style.borderColor,
            width: style.borderWidth,
          )
        : null;
    final borderRadius = style.variant == TStepperVariant.outline
        ? BorderRadius.only(
            topLeft: position == _StepperButtonPosition.leading
                ? style.borderRadius.topLeft
                : Radius.zero,
            bottomLeft: position == _StepperButtonPosition.leading
                ? style.borderRadius.bottomLeft
                : Radius.zero,
            topRight: position == _StepperButtonPosition.trailing
                ? style.borderRadius.topRight
                : Radius.zero,
            bottomRight: position == _StepperButtonPosition.trailing
                ? style.borderRadius.bottomRight
                : Radius.zero,
          )
        : style.borderRadius;

    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: !disabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : onPressed,
        child: SizedBox.square(
          dimension: style.controlSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              borderRadius: borderRadius,
            ),
            child: Center(
              child: Icon(
                icon,
                size: style.iconSize,
                color:
                    disabled ? style.disabledForegroundColor : style.iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepperStyle {
  const _StepperStyle({
    required this.variant,
    required this.controlSize,
    required this.inputWidth,
    required this.iconSize,
    required this.spacing,
    required this.borderRadius,
    required this.borderWidth,
    required this.foregroundColor,
    required this.disabledForegroundColor,
    required this.iconColor,
    required this.backgroundColor,
    required this.disabledBackgroundColor,
    required this.borderColor,
    required this.textStyle,
    required this.disabledTextStyle,
  });

  final TStepperVariant variant;
  final double controlSize;
  final double inputWidth;
  final double iconSize;
  final double spacing;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color foregroundColor;
  final Color disabledForegroundColor;
  final Color iconColor;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color borderColor;
  final TextStyle textStyle;
  final TextStyle disabledTextStyle;

  static _StepperStyle resolve(BuildContext context, TStepper widget) {
    final materialTheme = Theme.of(context);
    final componentTheme = materialTheme.extension<TStepperThemeData>();
    final token = context.tTheme;
    final size = widget.size ?? componentTheme?.size ?? TStepperSize.medium;
    final variant =
        widget.variant ?? componentTheme?.variant ?? TStepperVariant.normal;
    final geometry = switch (size) {
      TStepperSize.small => const (
          controlSize: 20.0,
          inputWidth: 34.0,
          iconSize: 12.0,
          fontSize: 10.0,
        ),
      TStepperSize.medium => const (
          controlSize: 24.0,
          inputWidth: 38.0,
          iconSize: 16.0,
          fontSize: 12.0,
        ),
      TStepperSize.large => const (
          controlSize: 26.0,
          inputWidth: 45.0,
          iconSize: 20.0,
          fontSize: 16.0,
        ),
    };
    final defaultTextStyle = context.tExplicitDefaultTextStyle;
    final materialTextStyle =
        materialTheme.tExplicitTextTheme?.bodySmall ?? const TextStyle();
    final inheritedFontFamily =
        defaultTextStyle?.fontFamily ?? materialTextStyle.fontFamily;
    final foregroundColor = componentTheme?.foregroundColor ??
        defaultTextStyle?.color ??
        materialTextStyle.color ??
        token.textColorPrimary;
    final disabledForegroundColor =
        componentTheme?.disabledForegroundColor ?? token.textDisabledColor;
    final textStyle = materialTextStyle
        .merge(defaultTextStyle)
        .copyWith(
          fontSize: geometry.fontSize,
          color: foregroundColor,
          fontFamily: inheritedFontFamily,
          letterSpacing: 0,
          height: 1,
        )
        .merge(componentTheme?.textStyle);
    final inputTheme = materialTheme.inputDecorationTheme;
    final inputFillColor = inputTheme.fillColor;
    final borderColor = componentTheme?.borderColor ??
        inputTheme.enabledBorder?.borderSide.color ??
        token.componentBorderColor;

    return _StepperStyle(
      variant: variant,
      controlSize: componentTheme?.controlSize ?? geometry.controlSize,
      inputWidth: componentTheme?.inputWidth ?? geometry.inputWidth,
      iconSize: componentTheme?.iconSize ?? geometry.iconSize,
      spacing: componentTheme?.spacing ?? 4,
      borderRadius: componentTheme?.borderRadius ??
          BorderRadius.circular(token.radiusSmall),
      borderWidth: componentTheme?.borderWidth ?? 1,
      foregroundColor: foregroundColor,
      disabledForegroundColor: disabledForegroundColor,
      iconColor: componentTheme?.foregroundColor ??
          context.tExplicitIconTheme?.color ??
          foregroundColor,
      backgroundColor: componentTheme?.backgroundColor ??
          (inputFillColor == Colors.transparent ? null : inputFillColor) ??
          token.bgColorSecondaryContainer,
      disabledBackgroundColor: componentTheme?.disabledBackgroundColor ??
          token.bgColorComponentDisabled,
      borderColor: borderColor,
      textStyle: textStyle,
      disabledTextStyle: textStyle.copyWith(
        color: disabledForegroundColor,
      ),
    );
  }
}
