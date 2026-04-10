import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';

enum TStepperSize { small, medium, large }

enum TStepperTheme { normal, filled, outline }

enum TStepperIconType { remove, add }

enum TStepperOverlimitType { minus, plus }

enum TStepperEventType { cleanValue }

typedef TStepperOverlimitFunction = void Function(TStepperOverlimitType type);

/// Stepper控制器
class TStepperController {
  _TStepperState? _state;

  int _value = 0;

  int get value => _value;

  set value(int value) {
    _value = value;
    _state?.updateUI();
  }

  void _bindState(_TStepperState _tdStepperState) {
    _state = _tdStepperState;
  }
}

/// 步进器
class TStepper extends StatefulWidget {
  const TStepper({
    Key? key,
    this.disableInput = false,
    this.disabled = false,
    this.inputWidth,
    this.eventController,
    this.max = 100,
    this.min = 0,
    this.size = TStepperSize.medium,
    this.step = 1,
    this.theme = TStepperTheme.normal,
    this.value = 0,
    this.defaultValue = 0,
    this.onBlur,
    this.onChange,
    this.onOverlimit,
    this.controller,
  }) : super(key: key);

  /// 禁用输入框
  final bool disableInput;

  /// 禁用全部操作
  final bool disabled;

  /// 禁用全部操作
  final double? inputWidth;

  /// 最大值
  final int max;

  /// 最小值
  final int min;

  /// 组件尺寸
  final TStepperSize size;

  /// 步长
  final int step;

  /// 组件风格
  final TStepperTheme theme;

  /// 值
  final int? value;

  /// 默认值
  final int? defaultValue;

  /// 输入框失去焦点时触发
  final VoidCallback? onBlur;

  /// 数值发生变更时触发
  final ValueChanged<int>? onChange;

  /// 数值超出限制时触发
  final TStepperOverlimitFunction? onOverlimit;

  /// 事件控制器
  final StreamController<TStepperEventType>? eventController;

  /// Stepper控制器
  final TStepperController? controller;

  @override
  State<TStepper> createState() => _TStepperState();
}

class _TStepperState extends State<TStepper> {
  late TStepperController _controller;
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TStepperController()
        ..value = widget.value ?? widget.defaultValue ?? 0;
    }
    _controller._bindState(this);
    if (widget.eventController != null) {
      widget.eventController?.stream.listen((TStepperEventType event) {
        if (event == TStepperEventType.cleanValue) {
          cleanValue();
        }
      });
    }
    _textController =
        TextEditingController(text: _controller._value.toString());

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (widget.onBlur != null) {
          widget.onBlur!();
        }
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double _getWidth() {
    if (widget.inputWidth != null && widget.inputWidth! > 0) {
      return widget.inputWidth!;
    }

    switch (widget.size) {
      case TStepperSize.small:
        return 34;
      case TStepperSize.medium:
        return 38;
      case TStepperSize.large:
        return 45;
      default:
        return 38;
    }
  }

  double _getTextWidth() {
    var textLength = _controller._value.toString().length;
    return textLength < 4 ? 0 : (textLength - 4) * _getFontSize();
  }

  double _getHeight() {
    switch (widget.size) {
      case TStepperSize.small:
        return 20;
      case TStepperSize.medium:
        return 24;
      case TStepperSize.large:
        return 28;
      default:
        return 24;
    }
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (widget.theme) {
      case TStepperTheme.filled:
        return widget.disabled
            ? TTheme.of(context).bgColorComponentDisabled
            : TTheme.of(context).bgColorSecondaryContainer;
      case TStepperTheme.outline:
        return null;
      case TStepperTheme.normal:
      default:
        return null;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case TStepperSize.small:
        return 10;
      case TStepperSize.medium:
        return 12;
      case TStepperSize.large:
        return 16;
      default:
        return 12;
    }
  }

  void onAdd() {
    if (_controller._value >= widget.max) {
      return;
    }

    if (_controller._value + widget.step > widget.max) {
      setState(() {
        _controller._value = widget.max;
      });

      if (widget.onOverlimit != null) {
        widget.onOverlimit!(TStepperOverlimitType.plus);
      }

      renderNumber();
      return;
    }

    setState(() {
      _controller._value += widget.step;
    });

    renderNumber();
  }

  void onReduce() {
    if (_controller._value <= widget.min) {
      return;
    }

    if (_controller._value - widget.step < widget.min) {
      setState(() {
        _controller._value = widget.min;
      });

      if (widget.onOverlimit != null) {
        widget.onOverlimit!(TStepperOverlimitType.minus);
      }

      renderNumber();
      return;
    }

    setState(() {
      _controller._value -= widget.step;
    });
    renderNumber();
  }

  cleanValue() {
    _controller._value = 0;
    _textController.value = TextEditingValue(
        text: _controller._value.toString(),
        selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: _controller._value.toString().length,
        )));
    _focusNode.unfocus();
  }

  void renderNumber() {
    _textController.value = TextEditingValue(
        text: _controller._value.toString(),
        selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: _controller._value.toString().length,
        )));
    _focusNode.unfocus();

    if (widget.onChange != null) {
      widget.onChange!(_controller._value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TStepperIconButton(
          type: TStepperIconType.remove,
          disabled: widget.disabled || _controller._value <= widget.min,
          theme: widget.theme,
          size: widget.size,
          onTap: onReduce,
        ),
        Container(
          decoration: BoxDecoration(
              border: widget.theme == TStepperTheme.outline
                  ? Border(
                      top: BorderSide(
                        color: TTheme.of(context).componentBorderColor,
                      ),
                      bottom: BorderSide(
                        color: TTheme.of(context).componentBorderColor,
                      ))
                  : null),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.theme == TStepperTheme.normal ? 0 : 4),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: _getWidth(),
                    maxWidth: _getWidth() + _getTextWidth()),
                child: Container(
                  height: _getHeight(),
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: _getBackgroundColor(context)),
                  child: Container(
                    height: PlatformUtil.isWeb ? _getFontSize() : null,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: TextField(
                      controller: _textController,
                      enabled: !widget.disabled && !widget.disableInput,
                      focusNode: _focusNode,
                      style: TextStyle(
                          fontSize: _getFontSize(),
                          color: widget.disabled
                              ? TTheme.of(context).textDisabledColor
                              : TTheme.of(context).textColorPrimary),
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          try {
                            if (newValue.text == '') {
                              setState(() {
                                _controller._value = widget.min;
                              });

                              if (widget.onOverlimit != null) {
                                widget
                                    .onOverlimit!(TStepperOverlimitType.minus);
                              }

                              return newValue.copyWith(
                                  text: _controller._value.toString(),
                                  selection: TextSelection.collapsed(
                                      offset: _controller._value
                                          .toString()
                                          .length));
                            }

                            final newNum = int.parse(newValue.text);
                            if (newNum < widget.min) {
                              setState(() {
                                _controller._value = widget.min;
                              });
                              if (widget.onOverlimit != null) {
                                widget
                                    .onOverlimit!(TStepperOverlimitType.minus);
                              }
                            } else if (newNum > widget.max) {
                              setState(() {
                                _controller._value = widget.max;
                              });
                              if (widget.onOverlimit != null) {
                                widget
                                    .onOverlimit!(TStepperOverlimitType.plus);
                              }
                            } else {
                              setState(() {
                                _controller._value = newNum;
                              });
                            }

                            return newValue.copyWith(
                                text: _controller._value.toString(),
                                selection: TextSelection.collapsed(
                                    offset:
                                        _controller._value.toString().length));
                          } catch (e) {
                            return oldValue;
                          }
                        })
                      ],
                      onChanged: (newValue) {
                        final result = int.parse(newValue);
                        if (widget.onChange != null) {
                          widget.onChange!(result);
                        }
                      },
                    ),
                  ),
                ),
              )),
        ),
        TStepperIconButton(
          type: TStepperIconType.add,
          disabled: widget.disabled || _controller._value >= widget.max,
          theme: widget.theme,
          size: widget.size,
          onTap: onAdd,
        )
      ],
    );
  }

  void updateUI() {
    if (mounted) {
      _textController.value = TextEditingValue(
          text: _controller._value.toString(),
          selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: _controller._value.toString().length,
          )));
    }
  }
}

typedef TTapFunction = void Function();

class TStepperIconButton extends StatelessWidget {
  const TStepperIconButton({
    Key? key,
    this.onTap,
    this.size = TStepperSize.medium,
    this.disabled = false,
    this.theme = TStepperTheme.normal,
    required this.type,
  }) : super(key: key);

  final TTapFunction? onTap;
  final TStepperSize size;
  final TStepperIconType type;
  final bool disabled;
  final TStepperTheme theme;

  double _getIconSize() {
    switch (size) {
      case TStepperSize.large:
        return 20;
      case TStepperSize.medium:
        return 16;
      case TStepperSize.small:
        return 12;
      default:
        return 16;
    }
  }

  Icon _getIcon(context) {
    var iconType = type == TStepperIconType.add ? Icons.add : Icons.remove;

    return Icon(iconType,
        size: _getIconSize(),
        color: disabled
            ? TTheme.of(context).textDisabledColor
            : TTheme.of(context).textColorPrimary);
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (theme) {
      case TStepperTheme.filled:
        return disabled
            ? TTheme.of(context).bgColorComponentDisabled
            : TTheme.of(context).bgColorSecondaryContainer;
      case TStepperTheme.outline:
        return disabled ? TTheme.of(context).bgColorComponentDisabled : null;
      case TStepperTheme.normal:
      default:
        return null;
    }
  }

  BorderRadiusGeometry? _getBorderRadius(BuildContext context) {
    if (theme == TStepperTheme.normal) {
      return null;
    }

    return type == TStepperIconType.remove
        ? const BorderRadius.only(
            topLeft: Radius.circular(3), bottomLeft: Radius.circular(3))
        : const BorderRadius.only(
            topRight: Radius.circular(3), bottomRight: Radius.circular(3));
  }

  BoxBorder? _getBoxBorder(BuildContext context) {
    if (theme == TStepperTheme.outline) {
      return Border.all(
        color: TTheme.of(context).componentBorderColor,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: _getBorderRadius(context),
            border: _getBoxBorder(context),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _getIcon(context),
          ),
        ));
  }
}
