import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';

enum TDInputType {
  normal,
  twoLine,
  longText,
  special,
  normalMaxTwoLine,
  cardStyle
}

enum TDInputSize { small, large }

enum TDInputValidationTrigger { changed, submitted, outSide }

// 提供三种默认样式，也可以自定义decoration和上下文字。
enum TDCardStyle { topText, topTextWithBlueBorder, errorStyle }

class TDInput extends StatefulWidget {
  TDInput(
      {Key? key,
      this.width,
      this.textStyle,
      this.backgroundColor,
      this.decoration,
      this.leftIcon, // leftIcon is default designed 24 in size.
      this.leftLabel,
      this.leftLabelStyle,
      this.leftLabelSpace,
      this.required,
      this.readOnly = false,
      this.autofocus = false,
      this.obscureText = false,
      this.onEditingComplete,
      this.onSubmitted,
      this.onFieldSubmitted,
      this.onTapOutside,
      this.validationTrigger = TDInputValidationTrigger.changed,
      this.validator,
      this.hintText,
      this.inputType,
      this.onChanged,
      this.inputFormatters,
      this.inputDecoration,
      this.maxLines = 1,
      this.focusNode,
      this.controller,
      this.cursorColor,
      this.rightBtn,
      this.hintTextStyle,
      this.onBtnTap,
      this.labelWidget,
      this.textInputBackgroundColor,
      this.contentPadding,
      this.type = TDInputType.normal,
      this.size = TDInputSize.large,
      double? leftInfoWidth,
      this.maxLength = 500,
      this.additionInfo = '',
      this.additionInfoColor,
      this.textAlign,
      this.clearIconSize,
      this.onClearTap,
      this.needClear = true,
      this.clearBtnColor,
      this.contentAlignment = TextAlign.start,
      this.rightWidget,
      this.showBottomDivider = true,
      this.cardStyle,
      this.cardStyleTopText,
      this.inputAction,
      TDInputSpacer? spacer,
      this.cardStyleBottomText})
      :
        // assert(() {
        //   if (type == TDInputType.cardStyle) {
        //     // card style must be shorter than the screen width, so please set a
        //     // width to show.
        //     assert(width != null);
        //   }
        //   return true;
        // }()),
        // 生成默认间距
        // leftIcon与label 4
        // label与inputView 17.5
        // inputView与rightBtn 17.5
        // 最右侧间距16
        spacer = spacer ?? TDInputSpacer.generateDefault(),
        // 输入框左侧内容宽度（不包括最左侧的16dp padding）
        // leftLabel：左侧'标签文字'，一个字宽度16，最多一行展示5个字(5个字时，多一点荣誉)
        // leftIcon: 左侧icon，限制大小为24，再加上4dp的间距，即28
        // required: 是否必填的'*'标记，占位14（包括间距）
        leftInfoWidth = leftInfoWidth ??
            ((leftLabel == null && leftIcon == null && !(required ?? false))
                ? 0
                : ((leftLabel?.length == null ? 0 : leftLabel!.length) *
                            (leftLabelStyle != null
                                ? (leftLabelStyle.fontSize ?? 16)
                                : 16) +
                        1 +
                        (leftIcon != null ? 1 : 0) *
                            ((leftIcon is Icon) ? (leftIcon.size ?? 24) : 24)) +
                    (required == true ? 1 : 0) * 14),
        super(key: key);

  /// 输入框宽度(TDCardStyle时必须设置该参数)
  final double? width;

  /// 输入框背景色
  final Color? backgroundColor;

  /// 输入框样式
  final Decoration? decoration;

  /// 输入框左侧文案
  final String? leftLabel;

  /// 输入框左侧文案间距
  final double? leftLabelSpace;

  /// 是否必填标志（红色*）
  final bool? required;

  /// 带图标的输入框
  final Widget? leftIcon;

  /// leftLabel右侧组件，支持自定义
  final Widget? labelWidget;

  /// 是否只读
  final bool readOnly;

  /// 提示文案
  final String? hintText;

  /// 键盘类型，数字、字母
  final TextInputType? inputType;

  /// 输入文本变化时回调
  final ValueChanged<String>? onChanged;

  /// 显示输入内容，如限制长度(LengthLimitingTextInputFormatter(6))
  final List<TextInputFormatter>? inputFormatters;

  /// controller 用户获取或者赋值输入内容
  final TextEditingController? controller;

  /// 最大输入行数
  final int maxLines;

  /// 获取或者取消焦点使用
  final FocusNode? focusNode;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 是否隐藏输入的文字，一般用在密码输入框中
  final bool obscureText;

  /// 点击键盘完成按钮时触发的回调
  final VoidCallback? onEditingComplete;

  /// 点击键盘完成按钮时触发的回调, 参数值为输入的内容
  @deprecated
  final ValueChanged<String>? onSubmitted;

  /// 点击键盘完成按钮时触发的回调, 参数值为输入的内容
  final ValueChanged<String>? onFieldSubmitted;

  /// 点击输入框外部时触发的回调
  final TapRegionCallback? onTapOutside;

    /// 校验触发方式
  final TDInputValidationTrigger? validationTrigger;

  /// 输入验证，用法同TextFormField
  final String? Function(String?)? validator;

  /// 自定义输入框样式，默认圆角
  final InputDecoration? inputDecoration;

  /// 文本颜色
  final TextStyle? textStyle;

  /// 提示文本颜色，默认为文本颜色
  final TextStyle? hintTextStyle;

  /// 卡片模式上方文字
  final String? cardStyleTopText;

  /// 卡片模式下方文字
  final String? cardStyleBottomText;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// 清除按钮图标大小
  final double? clearIconSize;

  /// 右侧按钮
  final Widget? rightBtn;

  /// 右侧按钮点击
  final GestureTapCallback? onBtnTap;

  /// 右侧删除点击
  final GestureTapCallback? onClearTap;

  /// 是否需要右侧按钮变为删除
  final bool needClear;

  /// 右侧删除按钮颜色
  final Color? clearBtnColor;

  /// textInput内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 输入框类型
  final TDInputType type;

  /// 卡片默认样式
  final TDCardStyle? cardStyle;

  /// 输入框规格
  final TDInputSize size;

  /// 输入框左侧的宽度（输入框有16dp的左侧padding，因而左侧部分不用考虑这16dp）
  final double? leftInfoWidth;

  /// 最大字数限制
  final int? maxLength;

  /// 错误提示信息
  final String? additionInfo;

  /// 错误提示颜色
  final Color? additionInfoColor;

  /// 文字对齐方向
  final TextAlign? textAlign;

  /// 右侧自定义组件 特殊类型时生效
  final Widget? rightWidget;

  /// 是否展示底部分割线
  final bool showBottomDivider;

  /// 内容对齐方向
  final TextAlign contentAlignment;

  /// 左侧标签样式
  final TextStyle? leftLabelStyle;

  /// 键盘动作类型
  final TextInputAction? inputAction;

  /// 组件各模块间间距
  final TDInputSpacer spacer;

  /// 左侧内容所占区域宽度
  double _leftLabelWidth = 0;

  @override
  State<StatefulWidget> createState() => _TDInputState();
}

class _TDInputState extends State<TDInput> {
  String? additionInfo;

  @override
  void initState() {
    setState(() {
      additionInfo = widget.additionInfo;
    });
    super.initState();
  }

  /// 获取输入框规格
  double getInputPadding() {
    switch (widget.size) {
      case TDInputSize.small:
        return 12;
      case TDInputSize.large:
        return 16;
    }
  }

  /// 输入框校验
  void validator(String? value) {
    if (widget.validator != null) {
      setState(() {
        additionInfo = widget.validator!(value);
      });
    }
  }

  Widget buildInputView(BuildContext context) {
    widget._leftLabelWidth =
        widget.leftInfoWidth! + (widget.spacer.iconLabelSpace ?? 4);
    switch (widget.type) {
      case TDInputType.normal:
        return buildNormalInput(context);
      case TDInputType.twoLine:
        return buildTwoLineInput(context);
      case TDInputType.special:
        return buildSpecialInput(context);
      case TDInputType.longText:
        return buildLongTextInput(context);
      case TDInputType.normalMaxTwoLine:
        return buildNormalInput(context);
      case TDInputType.cardStyle:
        return buildCardStyleInput(context);
    }
  }

  Widget buildNormalInput(BuildContext context) {
    var cardStyleDecoration = _getCardStylePreDecoration(context);
    var hasLeftWidget = widget.leftLabel != null ||
        widget.leftIcon != null ||
        (widget.required ?? false);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: (cardStyleDecoration != null || widget.decoration != null)
              ? null
              : widget.backgroundColor,
          decoration: cardStyleDecoration ?? widget.decoration,
          child: Row(
            crossAxisAlignment: (additionInfo != null && additionInfo != '')
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: hasLeftWidget,
                child: SizedBox(
                  width: widget.leftLabelSpace ?? 16,
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: widget.leftIcon != null,
                    child: widget.leftIcon ?? const SizedBox.shrink(),
                  ),
                  Visibility(
                    visible: widget.leftLabel != null,
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: widget._leftLabelWidth),
                      padding: EdgeInsets.only(
                          left: widget.leftIcon != null
                              ? widget.spacer.iconLabelSpace!
                              : 0,
                          top: getInputPadding(),
                          bottom: getInputPadding()),
                      child: TDText(
                        widget.leftLabel,
                        maxLines: 2,
                        style: widget.leftLabelStyle,
                        font: TDTheme.of(context).fontBodyLarge,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.labelWidget != null,
                    child: widget.labelWidget ?? const SizedBox.shrink(),
                  ),
                  Visibility(
                      visible: widget.required ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TDText(
                          '*',
                          maxLines: 1,
                          style:
                              TextStyle(color: TDTheme.of(context).errorColor6),
                          font: TDTheme.of(context).fontBodyLarge,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                ],
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TDInputView(
                      textStyle: widget.textStyle ??
                          TextStyle(color: TDTheme.of(context).fontGyColor1),
                      readOnly: widget.readOnly,
                      autofocus: widget.autofocus,
                      obscureText: widget.obscureText,
                      onEditingComplete: widget.onEditingComplete,
                      onFieldSubmitted: onFieldSubmitted,
                      onTapOutside: widget.onTapOutside,
                      validator: (value) {
                        validator(value);
                        return null;
                      },
                      hintText: widget.hintText,
                      inputType: widget.inputType,
                      onChanged: onChanged,
                      inputFormatters: widget.inputFormatters,
                      inputDecoration: widget.inputDecoration,
                      maxLines: widget.maxLines,
                      maxLength: widget.maxLength,
                      focusNode: widget.focusNode,
                      isCollapsed: true,
                      textAlign: widget.contentAlignment,
                      hintTextStyle: widget.hintTextStyle ??
                          TextStyle(color: TDTheme.of(context).fontGyColor3),
                      cursorColor: widget.cursorColor,
                      textInputBackgroundColor: widget.textInputBackgroundColor,
                      controller: widget.controller,
                      contentPadding: widget.contentPadding ??
                          EdgeInsets.only(
                              left: widget.spacer.labelInputSpace!,
                              right: widget.spacer.inputRightSpace! / 2,
                              bottom:
                                  (additionInfo != null && additionInfo != '')
                                      ? 4
                                      : getInputPadding(),
                              top: getInputPadding()),
                      inputAction: widget.inputAction,
                    ),
                    Visibility(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: widget.spacer.additionInfoSpace!,
                            bottom: getInputPadding()),
                        child: TDText(
                          additionInfo,
                          font: TDTheme.of(context).fontBodySmall,
                          textColor: widget.additionInfoColor ??
                              TDTheme.of(context).fontGyColor3,
                        ),
                      ),
                      visible: additionInfo != '' && additionInfo != null,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: widget.rightWidget != null,
                child: Container(
                  margin: EdgeInsets.only(
                      top: getInputPadding(),
                      bottom: getInputPadding(),
                      right: 16),
                  child: widget.rightWidget,
                ),
              ),
              Visibility(
                visible: widget.controller != null &&
                    widget.controller!.text.isNotEmpty &&
                    widget.needClear &&
                    widget.rightWidget == null,
                child: GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: widget.spacer.inputRightSpace! / 2,
                          right: widget.spacer.rightSpace!,
                          top: (additionInfo != '' && additionInfo != null)
                              ? getInputPadding()
                              : 0),
                      child: Icon(
                        size: widget.clearIconSize,
                        TDIcons.close_circle_filled,
                        color: widget.clearBtnColor ??
                            TDTheme.of(context).fontGyColor3,
                      ),
                    ),
                    onTap: () {
                      widget.onClearTap ?? widget.onClearTap!();
                      widget.controller?.text = '';
                      validator('');
                    }),
                replacement: Visibility(
                  visible: widget.rightBtn != null,
                  child: GestureDetector(
                    onTap: widget.onBtnTap,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: widget.spacer.inputRightSpace! / 2,
                          right: widget.spacer.rightSpace!,
                          top: (additionInfo != '' && additionInfo != null)
                              ? getInputPadding()
                              : 0),
                      child: widget.rightBtn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.showBottomDivider)
          Visibility(
            visible: widget.type != TDInputType.cardStyle,
            child: const TDDivider(
              margin: EdgeInsets.only(
                left: 16,
              ),
            ),
          ),
      ],
    );
  }

  BoxDecoration? _getCardStylePreDecoration(BuildContext context) {
    var cardStyleDecoration;
    if (widget.type == TDInputType.cardStyle) {
      switch (widget.cardStyle) {
        case TDCardStyle.topText:
          cardStyleDecoration = BoxDecoration(
              color: Colors.white,
              border: Border.all(color: TDTheme.of(context).grayColor4),
              borderRadius: BorderRadius.circular(6));
          break;
        case TDCardStyle.topTextWithBlueBorder:
          cardStyleDecoration = BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: TDTheme.of(context).brandNormalColor, width: 1.5),
              borderRadius: BorderRadius.circular(6));
          break;
        case TDCardStyle.errorStyle:
          cardStyleDecoration = BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: TDTheme.of(context).errorColor6, width: 1.5),
              borderRadius: BorderRadius.circular(6));
          break;
        default:
          cardStyleDecoration = BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6));
          break;
      }
    }
    return cardStyleDecoration;
  }

  onChanged(String value) {
    if (widget.validationTrigger == TDInputValidationTrigger.changed) {
      validator(value);
    }
    widget.onChanged ?? widget.onChanged!(value);
  }

  onFieldSubmitted(String value) {
    if (widget.validationTrigger == TDInputValidationTrigger.submitted) {
      validator(value);
    }
    if (widget.onFieldSubmitted != null) {
      widget.onFieldSubmitted!(value);
    } else if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }
  }

  Widget buildTwoLineInput(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: widget.decoration != null ? null : widget.backgroundColor,
      decoration: widget.decoration,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: widget.leftLabel != null,
                  child: Row(
                    children: [
                      Visibility(
                        visible: widget.leftLabel != null,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: widget._leftLabelWidth +
                                  (widget.leftLabelSpace ?? 12)),
                          padding: EdgeInsets.only(
                              left: widget.leftLabelSpace ?? 12.0, top: 10.0),
                          child: Column(
                            children: [
                              TDText(
                                widget.leftLabel,
                                maxLines: 2,
                                style: widget.leftLabelStyle,
                                font: TDTheme.of(context).fontBodyLarge,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.labelWidget != null,
                        child: widget.labelWidget ?? const SizedBox.shrink(),
                      ),
                      Visibility(
                          visible: widget.required ?? false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1.0),
                            child: TDText(
                              '*',
                              maxLines: 1,
                              style: TextStyle(
                                  color: TDTheme.of(context).errorColor6),
                              font: TDTheme.of(context).fontBodyLarge,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ],
                  )),
              Container(
                padding: const EdgeInsets.only(bottom: 12, top: 7),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: widget.labelWidget != null,
                      child: widget.labelWidget ?? const SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 1,
                      child: TDInputView(
                        textStyle: widget.textStyle ??
                            TextStyle(color: TDTheme.of(context).fontGyColor1),
                        readOnly: widget.readOnly,
                        autofocus: widget.autofocus,
                        obscureText: widget.obscureText,
                        onEditingComplete: widget.onEditingComplete,
                        onFieldSubmitted: (value) {
                          if (widget.validationTrigger ==
                              TDInputValidationTrigger.submitted) {
                            validator(value);
                          }
                          if (widget.onFieldSubmitted != null) {
                            widget.onFieldSubmitted!(value);
                          } else if (widget.onSubmitted != null) {
                            widget.onSubmitted!(value);
                          }
                        },
                        onTapOutside: widget.onTapOutside,
                        validator: (value) {
                          validator(value);
                          return null;
                        },
                        hintText: widget.hintText,
                        inputType: widget.inputType,
                        onChanged: onChanged,
                        textAlign: widget.textAlign,
                        inputFormatters: widget.inputFormatters,
                        inputDecoration: widget.inputDecoration,
                        isCollapsed: true,
                        maxLines: widget.maxLines,
                        focusNode: widget.focusNode,
                        hintTextStyle: widget.hintTextStyle ??
                            TextStyle(color: TDTheme.of(context).fontGyColor3),
                        cursorColor: widget.cursorColor,
                        textInputBackgroundColor:
                            widget.textInputBackgroundColor,
                        controller: widget.controller,
                        contentPadding: widget.contentPadding ??
                            EdgeInsets.only(
                                left: widget.spacer.labelInputSpace!,
                                right: widget.spacer.inputRightSpace! / 2),
                        inputAction: widget.inputAction,
                      ),
                    ),
                    Visibility(
                      visible: widget.controller != null &&
                          widget.controller!.text.isNotEmpty &&
                          widget.needClear,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: widget.spacer.inputRightSpace! / 2,
                              right: widget.spacer.rightSpace!),
                          child: Icon(
                            size: widget.clearIconSize,
                            TDIcons.close_circle_filled,
                            color: widget.clearBtnColor ??
                                TDTheme.of(context).fontGyColor3,
                          ),
                        ),
                        onTap: () {
                          widget.onClearTap ?? widget.onClearTap!();
                          widget.controller?.text = '';
                          validator('');
                        },
                      ),
                      replacement: Visibility(
                        visible: widget.rightBtn != null,
                        child: GestureDetector(
                          onTap: widget.onBtnTap,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: widget.spacer.inputRightSpace! / 2,
                                right: widget.spacer.rightSpace!),
                            child: widget.rightBtn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.showBottomDivider)
            const TDDivider(
              margin: EdgeInsets.only(
                left: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildLongTextInput(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: widget.decoration != null ? null : widget.backgroundColor,
      decoration: widget.decoration,
      height: widget.leftLabel != null ? 197 : 148,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.leftLabel != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: 16,
                        top: getInputPadding(),
                        bottom: getInputPadding()),
                    child: TDText(
                      widget.leftLabel,
                      maxLines: 2,
                      fontWeight: FontWeight.w400,
                    )),
                if (widget.showBottomDivider)
                  const TDDivider(
                    margin: EdgeInsets.only(
                      left: 16,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TDInputView(
              textStyle: widget.textStyle ??
                  TextStyle(color: TDTheme.of(context).fontGyColor1),
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              obscureText: widget.obscureText,
              onEditingComplete: widget.onEditingComplete,
              onFieldSubmitted: onFieldSubmitted,
              onTapOutside: widget.onTapOutside,
              validator: (value) {
                validator(value);
                return null;
              },
              hintText: widget.hintText,
              inputType: widget.inputType,
              textAlign: widget.textAlign,
              onChanged: onChanged,
              inputFormatters: widget.inputFormatters ??
                  [LengthLimitingTextInputFormatter(widget.maxLength)],
              inputDecoration: widget.inputDecoration,
              maxLines: widget.maxLines,
              focusNode: widget.focusNode,
              hintTextStyle: widget.hintTextStyle ??
                  TextStyle(color: TDTheme.of(context).fontGyColor3),
              cursorColor: widget.cursorColor,
              textInputBackgroundColor: widget.textInputBackgroundColor,
              controller: widget.controller,
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.only(
                      left: 16, right: 16, top: 12, bottom: 12),
              inputAction: widget.inputAction,
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: TDText(
              '${widget.controller?.text.length}/${widget.maxLength}',
              font: TDTheme.of(context).fontBodySmall,
              textColor: TDTheme.of(context).fontGyColor3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSpecialInput(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: widget.decoration != null ? null : widget.backgroundColor,
          decoration: widget.decoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                visible: widget.leftLabel != null,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: widget.leftLabelSpace ?? 16,
                      top: getInputPadding(),
                      bottom: getInputPadding()),
                  child: widget.leftInfoWidth != null
                      ? SizedBox(
                          width: widget._leftLabelWidth,
                          child: TDText(
                            widget.leftLabel,
                            maxLines: 1,
                            font: TDTheme.of(context).fontBodyLarge,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : TDText(
                          widget.leftLabel,
                          maxLines: 1,
                          font: TDTheme.of(context).fontBodyLarge,
                          fontWeight: FontWeight.w400,
                        ),
                ),
              ),
              Visibility(
                visible: widget.labelWidget != null,
                child: widget.labelWidget ?? const SizedBox.shrink(),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: widget.spacer.labelInputSpace!),
                  child: TDInputView(
                    textStyle: widget.textStyle ??
                        TextStyle(color: TDTheme.of(context).fontGyColor1),
                    readOnly: widget.readOnly,
                    autofocus: widget.autofocus,
                    obscureText: widget.obscureText,
                    onEditingComplete: widget.onEditingComplete,
                    onFieldSubmitted: onFieldSubmitted,
                    onTapOutside: widget.onTapOutside,
                    validator: (value) {
                      if (widget.validator != null) {
                        setState(() {
                          additionInfo = widget.validator!(value);
                        });
                      }
                      return null;
                    },
                    hintText: widget.hintText,
                    inputType: widget.inputType,
                    onChanged: onChanged,
                    inputFormatters: widget.inputFormatters,
                    inputDecoration: widget.inputDecoration,
                    maxLines: widget.maxLines,
                    focusNode: widget.focusNode,
                    isCollapsed: true,
                    hintTextStyle: widget.hintTextStyle ??
                        TextStyle(color: TDTheme.of(context).fontGyColor3),
                    cursorColor: widget.cursorColor,
                    textInputBackgroundColor: widget.textInputBackgroundColor,
                    controller: widget.controller,
                    textAlign: widget.textAlign,
                    contentPadding: widget.contentPadding ??
                        EdgeInsets.only(
                            right: widget.spacer.inputRightSpace!,
                            bottom: getInputPadding(),
                            top: getInputPadding()),
                    inputAction: widget.inputAction,
                  ),
                ),
              ),
              Visibility(
                visible: widget.rightWidget != null,
                child: Container(
                  margin: EdgeInsets.only(
                      top: getInputPadding(),
                      bottom: getInputPadding(),
                      right: widget.spacer.rightSpace!),
                  child: widget.rightWidget,
                ),
              ),
            ],
          ),
        ),
        if (widget.showBottomDivider)
          const Visibility(
            child: TDDivider(
              margin: EdgeInsets.only(
                left: 16,
              ),
            ),
          ),
      ],
    );
  }

  Size getTextSize(String text, [TextStyle? style]) {
    var painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );
    painter.layout();
    return painter.size;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      child: buildInputView(context),
      width: widget.width ?? screenWidth,
    );
  }

  Widget buildCardStyleInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.cardStyleTopText != null,
          child: Column(
            children: [
              Text(
                widget.cardStyleTopText ?? '',
                style: TextStyle(
                    fontSize: TDTheme.of(context).fontBodyMedium!.size,
                    height: TDTheme.of(context).fontBodyMedium!.height),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        buildNormalInput(context),
        Visibility(
          visible: widget.cardStyleBottomText != null,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.cardStyleBottomText ?? '',
                style: TextStyle(
                    color: TDTheme.of(context).errorColor6,
                    fontSize: TDTheme.of(context).fontBodySmall!.size,
                    height: TDTheme.of(context).fontBodySmall!.height),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 中文算作两个字符类型的TextInputFormatter
class Chinese2Formatter extends TextInputFormatter {
  final int maxLength;

  Chinese2Formatter(this.maxLength);

  final _regExp = r'^[\u4E00-\u9FA5A-Za-z0-9_]+$';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newValueLength = newValue.text.length;
    var count = 0;
    if (newValueLength == 0) {
      return newValue;
    }
    if (maxLength > 0) {
      for (var i = 0; i < newValueLength; i++) {
        if (newValue.text.codeUnitAt(i) > 122) {
          ///中文字符按照2个计算
          count++;
        }
        if (i > 0 && count + i > maxLength - 1) {
          var text = newValue.text.substring(0, i);
          return newValue.copyWith(
              text: text,
              composing: TextRange.empty,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: i, affinity: TextAffinity.downstream)));
        }
      }
    }
    if (newValueLength > 0 &&
        RegExp(_regExp).firstMatch(newValue.text) != null) {
      if (newValueLength + count <= maxLength) {
        return newValue;
      }
    }
    return oldValue;
  }
}
