import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';

enum TDStepperSize { small, medium, large }

enum TDStepperTheme { normal, filled, outline }

enum TDStepperIconType { remove, add }

enum TDStepperOverlimitType { minus, plus }

enum TDStepperEventType { cleanValue }

typedef TDStepperOverlimitFunction = void Function(TDStepperOverlimitType type);

/// Stepper控制器
class TDStepperController {
  _TDStepperState? _state;

  int _value = 0;
  int get value => _value;

  set value(int value) {
    _value = value;
    _state?.updateUI();
  }


  void _bindState(_TDStepperState _tdStepperState) {
    _state = _tdStepperState;
  }

}

/// 步进器
class TDStepper extends StatefulWidget {
  const TDStepper({
    Key? key,
    this.disableInput = false,
    this.disabled = false,
    this.inputWidth,
    this.eventController,
    this.max = 100,
    this.min = 0,
    this.size = TDStepperSize.medium,
    this.step = 1,
    this.theme = TDStepperTheme.normal,
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
  final TDStepperSize size;

  /// 步长
  final int step;

  /// 组件风格
  final TDStepperTheme theme;

  /// 值
  @Deprecated('与defaultValue 功能重复,请使用defaultValue或者valueController')
  final int? value;

  /// 默认值
  final int? defaultValue;

  /// 输入框失去焦点时触发
  final VoidCallback? onBlur;

  /// 数值发生变更时触发
  final ValueChanged<int>? onChange;

  /// 数值超出限制时触发
  final TDStepperOverlimitFunction? onOverlimit;

  /// 事件控制器
  final StreamController<TDStepperEventType>? eventController;

  /// Stepper控制器
  final TDStepperController? controller;
  @override
  State<TDStepper> createState() => _TDStepperState();
}

class _TDStepperState extends State<TDStepper> {
  late TDStepperController _controller;
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TDStepperController()
        ..value = widget.value ?? widget.defaultValue ?? 0;
    }
    _controller._bindState(this);
    if(widget.eventController!=null){
      widget.eventController?.stream.listen((TDStepperEventType event){
          if(event == TDStepperEventType.cleanValue){
            cleanValue();
          }
      });
    }
    _textController = TextEditingController(text: _controller._value.toString());

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
      case TDStepperSize.small:
        return 34;
      case TDStepperSize.medium:
        return 38;
      case TDStepperSize.large:
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
      case TDStepperSize.small:
        return 20;
      case TDStepperSize.medium:
        return 24;
      case TDStepperSize.large:
        return 28;
      default:
        return 24;
    }
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (widget.theme) {
      case TDStepperTheme.filled:
        return widget.disabled
            ? TDTheme.of(context).grayColor2
            : TDTheme.of(context).grayColor1;
      case TDStepperTheme.outline:
        return TDTheme.of(context).whiteColor1;
      case TDStepperTheme.normal:
      default:
        return null;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case TDStepperSize.small:
        return 10;
      case TDStepperSize.medium:
        return 12;
      case TDStepperSize.large:
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
        widget.onOverlimit!(TDStepperOverlimitType.plus);
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
        widget.onOverlimit!(TDStepperOverlimitType.minus);
      }

      renderNumber();
      return;
    }

    setState(() {
      _controller._value -= widget.step;
    });
    renderNumber();
  }
  cleanValue(){
    _controller._value=0;
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
        TDStepperIconButton(
          type: TDStepperIconType.remove,
          disabled: widget.disabled || _controller._value <= widget.min,
          theme: widget.theme,
          size: widget.size,
          onTap: onReduce,
        ),
        Container(
          decoration: BoxDecoration(
              border: widget.theme == TDStepperTheme.outline
                  ? Border(
                      top: BorderSide(
                        color: TDTheme.of(context).grayColor4,
                      ),
                      bottom: BorderSide(
                        color: TDTheme.of(context).grayColor4,
                      ))
                  : null),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.theme == TDStepperTheme.normal ? 0 : 4),
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
                              ? TDTheme.of(context).fontGyColor4
                              : TDTheme.of(context).fontGyColor1),
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
                                    .onOverlimit!(TDStepperOverlimitType.minus);
                              }

                              return newValue.copyWith(
                                  text: _controller._value.toString(),
                                  selection: TextSelection.collapsed(
                                      offset: _controller._value.toString().length));
                            }

                            final newNum = int.parse(newValue.text);
                            if (newNum < widget.min) {
                              setState(() {
                                _controller._value = widget.min;
                              });
                              if (widget.onOverlimit != null) {
                                widget
                                    .onOverlimit!(TDStepperOverlimitType.minus);
                              }
                            } else if (newNum > widget.max) {
                              setState(() {
                                _controller._value = widget.max;
                              });
                              if (widget.onOverlimit != null) {
                                widget
                                    .onOverlimit!(TDStepperOverlimitType.plus);
                              }
                            } else {
                              setState(() {
                                _controller._value = newNum;
                              });
                            }

                            return newValue.copyWith(
                                text: _controller._value.toString(),
                                selection: TextSelection.collapsed(
                                    offset: _controller._value.toString().length));
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
        TDStepperIconButton(
          type: TDStepperIconType.add,
          disabled: widget.disabled || _controller._value >= widget.max,
          theme: widget.theme,
          size: widget.size,
          onTap: onAdd,
        )
      ],
    );
  }

  void updateUI() {
   if(mounted){
     _textController.value = TextEditingValue(
         text: _controller._value.toString(),
         selection: TextSelection.fromPosition(TextPosition(
           affinity: TextAffinity.downstream,
           offset: _controller._value.toString().length,
         )));
   }
  }
}

typedef TDTapFunction = void Function();

class TDStepperIconButton extends StatelessWidget {
  const TDStepperIconButton(
      {Key? key,
      this.onTap,
      this.size = TDStepperSize.medium,
      this.disabled = false,
      this.theme = TDStepperTheme.normal,
      required this.type})
      : super(key: key);

  final TDTapFunction? onTap;
  final TDStepperSize size;
  final TDStepperIconType type;
  final bool disabled;
  final TDStepperTheme theme;

  double _getIconSize() {
    switch (size) {
      case TDStepperSize.large:
        return 20;
      case TDStepperSize.medium:
        return 16;
      case TDStepperSize.small:
        return 12;
      default:
        return 16;
    }
  }

  Icon _getIcon(context) {
    var iconType = type == TDStepperIconType.add ? Icons.add : Icons.remove;

    return Icon(iconType,
        size: _getIconSize(),
        color: disabled
            ? TDTheme.of(context).fontGyColor4
            : TDTheme.of(context).fontGyColor1);
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (theme) {
      case TDStepperTheme.filled:
        return disabled
            ? TDTheme.of(context).grayColor2
            : TDTheme.of(context).grayColor1;
      case TDStepperTheme.outline:
        return disabled ? TDTheme.of(context).grayColor2 : null;
      case TDStepperTheme.normal:
      default:
        return null;
    }
  }

  BorderRadiusGeometry? _getBorderRadius(BuildContext context) {
    if (theme == TDStepperTheme.normal) {
      return null;
    }

    return type == TDStepperIconType.remove
        ? const BorderRadius.only(
            topLeft: Radius.circular(3), bottomLeft: Radius.circular(3))
        : const BorderRadius.only(
            topRight: Radius.circular(3), bottomRight: Radius.circular(3));
  }

  BoxBorder? _getBoxBorder(BuildContext context) {
    if (theme == TDStepperTheme.outline) {
      return Border.all(
        color: TDTheme.of(context).grayColor4,
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

