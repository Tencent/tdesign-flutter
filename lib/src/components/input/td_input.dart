import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../td_export.dart';

enum TDInputType {
  normal,
  twoLine,
  longText,
  special
}

enum TDInputSize {
  small,
  large
}

class TDInput extends StatelessWidget {
  const TDInput({
    Key? key,
    this.width,
    this.textStyle,
    this.backgroundColor,
    this.decoration,
    this.leftLabel,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.onEditingComplete,
    this.onSubmitted,
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
    this.onTapBtn,
    this.labelWidget,
    this.textInputBackgroundColor,
    this.contentPadding,
    this.type = TDInputType.normal,
    this.size = TDInputSize.small,
    this.inputWidth = 81,
    this.maxNum = 500,
    this.errorText = '',
    this.textAlign,
    this.rightWidget
  }) : super(key: key);

  /// 输入框宽度
  final double? width;

  /// 输入框背景色
  final Color? backgroundColor;

  /// 输入框样式
  final Decoration? decoration;

  /// 输入框左侧文案
  final String? leftLabel;

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
  final ValueChanged<String>? onSubmitted;

  /// 自定义输入框样式，默认圆角
  final InputDecoration? inputDecoration;

  /// 文本颜色
  final TextStyle? textStyle;

  /// 提示文本颜色，默认为文本颜色
  final TextStyle? hintTextStyle;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// 右侧按钮
  final Widget? rightBtn;

  /// 右侧按钮点击
  final GestureTapCallback? onTapBtn;

  /// textInput内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 输入框类型
  final TDInputType type;

  /// 输入框规格
  final TDInputSize size;

  /// 输入框宽度
  final double? inputWidth;

  /// 最大字数限制
  final int? maxNum;

  /// 错误提示信息
  final String? errorText;

  /// 文字对齐方向
  final TextAlign? textAlign;

  /// 右侧自定义组件 特殊类型时生效
  final Widget? rightWidget;


  /// 获取输入框规格
  double getInputPadding() {
    switch(size) {
      case TDInputSize.small:
        return 12;
      case TDInputSize.large:
        return 16;
    }
  }

  Widget buildInputView(BuildContext context) {
    switch(type) {
      case TDInputType.normal:
        return buildNormalInput(context);
      case TDInputType.twoLine:
        return buildTwoLineInput(context);
      case TDInputType.special:
        return buildSpecialInput(context);
      case TDInputType.longText:
        return buildLongTextInput(context);
    }
  }

  Widget buildNormalInput(BuildContext context){
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: decoration != null ? null : backgroundColor,
          decoration: decoration,
          child: Row(
            crossAxisAlignment: errorText != '' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: leftLabel != null,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, top: getInputPadding(), bottom: getInputPadding()),
                  child: inputWidth != null ? SizedBox(
                    width: inputWidth,
                    child: TDText(
                      leftLabel,
                      maxLines: 1,
                      font: TDTheme.of(context).fontM,
                      fontWeight: FontWeight.w400,
                    ),
                  ) : TDText(
                    leftLabel,
                    maxLines: 1,
                    font: TDTheme.of(context).fontM,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Visibility(
                visible: labelWidget != null,
                child: labelWidget ?? const SizedBox.shrink(),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TDInputView(
                      textStyle: textStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor1),
                      readOnly: readOnly,
                      autofocus: autofocus,
                      obscureText: obscureText,
                      onEditingComplete: onEditingComplete,
                      onSubmitted: onSubmitted,
                      hintText: hintText,
                      inputType: inputType,
                      onChanged: onChanged,
                      inputFormatters: inputFormatters,
                      inputDecoration: inputDecoration,
                      maxLines: maxLines,
                      focusNode: focusNode,
                      isCollapsed: true,
                      textAlign: textAlign,
                      hintTextStyle: hintTextStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor3),
                      cursorColor: cursorColor,
                      textInputBackgroundColor: textInputBackgroundColor,
                      controller: controller,
                      contentPadding: contentPadding ?? EdgeInsets.only(left: 16, right: 16, bottom: errorText != '' ? 4 : getInputPadding(), top: getInputPadding()),
                    ),
                    Visibility(child: Padding(
                      padding: EdgeInsets.only(left: 16, bottom: getInputPadding()),
                      child: TDText(errorText, font: TDTheme.of(context).fontXS, textColor: TDTheme.of(context).fontGyColor3,),
                    ), visible: errorText != '',)
                  ],
                ),
              ),
              Visibility(
                visible: rightBtn != null,
                child: GestureDetector(
                  onTap: onTapBtn,
                  child: Container(
                    margin: const EdgeInsets.only(left: 17.5, right: 17.5),
                    child: rightBtn,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Visibility(child: TDDivider(margin: EdgeInsets.only(left: 16, ),),),
      ],
    );
  }

  Widget buildTwoLineInput(BuildContext context){
    return Container(
      alignment: Alignment.centerLeft,
      color: decoration != null ? null : backgroundColor,
      decoration: decoration,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: leftLabel != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12),
                  child: inputWidth != null ? SizedBox(
                    width: inputWidth,
                    child: TDText(
                      leftLabel,
                      maxLines: 1,
                      font: TDTheme.of(context).fontS,
                      fontWeight: FontWeight.w400,
                    ),
                  ) : TDText(
                    leftLabel,
                    maxLines: 1,
                    font: TDTheme.of(context).fontS,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 12, top: 7),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: labelWidget != null,
                      child: labelWidget ?? const SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 1,
                      child: TDInputView(
                        textStyle: textStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor1),
                        readOnly: readOnly,
                        autofocus: autofocus,
                        obscureText: obscureText,
                        onEditingComplete: onEditingComplete,
                        onSubmitted: onSubmitted,
                        hintText: hintText,
                        inputType: inputType,
                        onChanged: onChanged,
                        textAlign: textAlign,
                        inputFormatters: inputFormatters,
                        inputDecoration: inputDecoration,
                        isCollapsed: true,
                        maxLines: maxLines,
                        focusNode: focusNode,
                        hintTextStyle: hintTextStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor3),
                        cursorColor: cursorColor,
                        textInputBackgroundColor: textInputBackgroundColor,
                        controller: controller,
                        contentPadding: contentPadding ?? const EdgeInsets.only(left: 16, right: 16),
                      ),
                    ),
                    Visibility(
                      visible: rightBtn != null,
                      child: GestureDetector(
                        onTap: onTapBtn,
                        child: Container(
                          margin: const EdgeInsets.only(left: 17.5, right: 13.5),
                          child: rightBtn,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const Visibility(child: TDDivider(margin: EdgeInsets.only(left: 16, ),),),
        ],
      ),
    );
  }

  Widget buildLongTextInput(BuildContext context){
    return Container(
      alignment: Alignment.centerLeft,
      color: decoration != null ? null : backgroundColor,
      decoration: decoration,
      height: leftLabel != null ? 197 : 148,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: leftLabel != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, top: getInputPadding(), bottom: getInputPadding()),
                  child: TDText(
                    leftLabel,
                    maxLines: 2,
                    fontWeight: FontWeight.w400,
                  )
                ),
                const TDDivider(margin: EdgeInsets.only(left: 16, ),),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TDInputView(
              textStyle: textStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor1),
              readOnly: readOnly,
              autofocus: autofocus,
              obscureText: obscureText,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
              hintText: hintText,
              inputType: inputType,
              textAlign: textAlign,
              onChanged: onChanged,
              inputFormatters: inputFormatters ?? [LengthLimitingTextInputFormatter(maxNum)],
              inputDecoration: inputDecoration,
              maxLines: maxLines,
              focusNode: focusNode,
              hintTextStyle: hintTextStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor3),
              cursorColor: cursorColor,
              textInputBackgroundColor: textInputBackgroundColor,
              controller: controller,
              contentPadding: contentPadding ?? const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: TDText(
              '${controller?.text.length}/${maxNum}',
              font: TDTheme.of(context).fontXS,
              textColor: TDTheme.of(context).fontGyColor3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSpecialInput(BuildContext context){
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: decoration != null ? null : backgroundColor,
          decoration: decoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                visible: leftLabel != null,
                child: Padding(
                    padding: EdgeInsets.only(left: 16, top: getInputPadding(), bottom: getInputPadding()),
                    child: inputWidth != null ? SizedBox(
                      width: inputWidth,
                      child: TDText(
                        leftLabel,
                        maxLines: 1,
                        font: TDTheme.of(context).fontM,
                        fontWeight: FontWeight.w400,
                      ),
                    ) : TDText(
                      leftLabel,
                      maxLines: 1,
                      font: TDTheme.of(context).fontM,
                      fontWeight: FontWeight.w400,
                    ),
                ),
              ),
              Visibility(
                visible: labelWidget != null,
                child: labelWidget ?? const SizedBox.shrink(),
              ),
              Row(
                children: [
                  SizedBox(
                    width: getTextSize(
                      hintText ?? '',
                      textStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor1, fontSize: 16),
                    ).width + 12,
                    child: TDInputView(
                      textStyle: textStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor1),
                      readOnly: readOnly,
                      autofocus: autofocus,
                      obscureText: obscureText,
                      onEditingComplete: onEditingComplete,
                      onSubmitted: onSubmitted,
                      hintText: hintText,
                      inputType: inputType,
                      onChanged: onChanged,
                      inputFormatters: inputFormatters,
                      inputDecoration: inputDecoration,
                      maxLines: maxLines,
                      focusNode: focusNode,
                      isCollapsed: true,
                      hintTextStyle: hintTextStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor3),
                      cursorColor: cursorColor,
                      textInputBackgroundColor: textInputBackgroundColor,
                      controller: controller,
                      textAlign: textAlign,
                      contentPadding: contentPadding ?? EdgeInsets.only(right: 12, bottom: getInputPadding(), top: getInputPadding()),
                    ),
                  ),
                  Visibility(
                    visible: rightWidget != null,
                    child: Container(
                      margin: EdgeInsets.only(top: getInputPadding(), bottom: getInputPadding(), right: 12),
                      child: rightWidget,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Visibility(child: TDDivider(margin: EdgeInsets.only(left: 16, ),),),
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
    return SizedBox(child: buildInputView(context), width: width ?? screenWidth, );
  }
}
