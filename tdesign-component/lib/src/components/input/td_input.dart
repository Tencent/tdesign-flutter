import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';
import '../dialog/td_dialog_widget.dart';

enum TDInputType { normal, twoLine, longText, special, normalMaxTwoLine, cardStyle }

enum TDInputSize { small, large }

// 提供三种默认样式，也可以自定义decoration和上下文字。
enum TDCardStyle { topText, topTextWithBlueBorder, errorStyle }

class TDInput extends StatelessWidget {
  TDInput({
    Key? key,
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
    this.leftInfoWidth,
    this.leftContentSpace,
    this.textInputBackgroundColor,
    this.contentPadding,
    this.type = TDInputType.normal,
    this.size = TDInputSize.large,
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
    this.cardStyleBottomText,
    this.onTapOutside,
  }) : spacer = spacer ?? TDInputSpacer.generateDefault();

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

  /// 输入框内容左侧间距
  final double? leftContentSpace;

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
  final ValueChanged<String>? onSubmitted;

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

  /// 左侧标签样式 设置该值是若出现像素溢出，请设置letterSpacing: 0
  final TextStyle? leftLabelStyle;

  /// 键盘动作类型
  final TextInputAction? inputAction;

  /// 组件各模块间间距
  final TDInputSpacer spacer;

  /// 左侧内容所占区域宽度
  double _leftLabelWidth = 0;

  /// 点击输入框外部区域回调
  final TapRegionCallback? onTapOutside;

  /// 获取输入框规格
  double getInputPadding() {
    switch (size) {
      case TDInputSize.small:
        return 12;
      case TDInputSize.large:
        return 16;
    }
  }

  /// 计算输入框左侧信息总宽度
  /// 图标间距：若存在左侧图标 取间距配置值（默认4）
  /// 图标宽度：24px图标尺寸 + 图标间距
  /// 标签宽度：通过文本测量函数获取精确文本渲染宽度
  /// 必填标识：当 required=true 时增加14px宽度（含4px间距）
  /// 安全边距：最终增加4px防止截断
  double _calculateLeftInfoWidth(BuildContext context) {
    final iconSpace = leftIcon != null ? (spacer.iconLabelSpace ?? 4) : 0;
    final iconWidth = leftIcon != null ? 24 + iconSpace : 0;
    final labelWidth = _measureTextWidth(leftLabel, leftLabelStyle, context);
    final requiredWidth = (required ?? false) ? 14 : 0;
    return iconWidth + labelWidth + requiredWidth + (leftContentSpace??4);
  }

  /// 计算文本渲染宽度
  /// text: 待测量文本（null/空字符串返回0）
  /// style: 文本样式（继承主题字体尺寸）
  /// 排版控制：letterSpacing=0消除字间距，height=1.0避免行高影响
  /// 默认最大行数排版为1行
  double _measureTextWidth(String? text, TextStyle? style, BuildContext context) {
    if (text == null || text.isEmpty) return 0;
    final effectiveStyle = (style ?? TextStyle()).copyWith(
      fontSize: TDTheme.of(context).fontBodyLarge?.size,
      letterSpacing: 0,
      height: 1.0,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: effectiveStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return textPainter.width + 2;
  }

  Widget buildInputView(BuildContext context) {
    _leftLabelWidth = _calculateLeftInfoWidth(context);
    switch (type) {
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

  double _getBottomDividerMarginLeft() {
    switch (type) {
      case TDInputType.normal:
      case TDInputType.twoLine:
      case TDInputType.normalMaxTwoLine:
      case TDInputType.cardStyle:
        if (contentPadding != null && contentPadding is EdgeInsets) {
          return (contentPadding as EdgeInsets).left;
        }
        return spacer.labelInputSpace ?? 16;
      case TDInputType.special:
      case TDInputType.longText:
        if (contentPadding != null && contentPadding is EdgeInsets) {
          return (contentPadding as EdgeInsets).left;
        }
        return 16;
    }
  }

  Widget buildNormalInput(BuildContext context) {
    var cardStyleDecoration = _getCardStylePreDecoration(context);
    var hasLeftWidget = leftLabel != null || leftIcon != null || (required ?? false);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: (cardStyleDecoration != null || decoration != null) ? null : backgroundColor,
          decoration: cardStyleDecoration ?? decoration,
          child: Row(
            crossAxisAlignment: additionInfo != '' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: hasLeftWidget,
                child: SizedBox(
                  width: leftLabelSpace ?? 16,
                ),
              ),
              SizedBox(
                width: _leftLabelWidth,
                child: GestureDetector(
                  child: Row(
                    children: [
                      Visibility(
                        visible: leftIcon != null,
                        child: SizedBox(
                          width: 24,
                          child: leftIcon ?? const SizedBox.shrink(),
                        ),
                      ),
                      Visibility(
                        visible: leftLabel != null,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: _leftLabelWidth),
                          padding: EdgeInsets.only(
                              left: leftIcon != null ? (spacer.iconLabelSpace ?? 4) : 0,
                              top: getInputPadding(),
                              bottom: getInputPadding()),
                          child: TDText(
                            leftLabel,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: leftLabelStyle ?? const TextStyle(letterSpacing: 0),
                            font: TDTheme.of(context).fontBodyLarge,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: labelWidget != null,
                        child: labelWidget ?? const SizedBox.shrink(),
                      ),
                      Visibility(
                          visible: required ?? false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TDText(
                              '*',
                              maxLines: 1,
                              style: TextStyle(color: TDTheme.of(context).errorColor6),
                              font: TDTheme.of(context).fontBodyLarge,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ],
                  ),
                ),
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
                      onTapOutside: onTapOutside,
                      inputFormatters: inputFormatters,
                      inputDecoration: inputDecoration,
                      maxLines: maxLines,
                      maxLength: maxLength,
                      focusNode: focusNode,
                      isCollapsed: true,
                      textAlign: contentAlignment,
                      hintTextStyle: hintTextStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor3),
                      cursorColor: cursorColor,
                      textInputBackgroundColor: textInputBackgroundColor,
                      controller: controller,
                      contentPadding: contentPadding ??
                          EdgeInsets.only(
                              left: spacer.labelInputSpace ?? 16,
                              right: spacer.inputRightSpace != null ? spacer.inputRightSpace! / 2 : 16,
                              bottom: additionInfo != '' ? 4 : getInputPadding(),
                              top: getInputPadding()),
                      inputAction: inputAction,
                    ),
                    Visibility(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            left: spacer.additionInfoSpace ?? 16,
                            right: TextAlign.end == contentAlignment ? 8 : 0,
                            bottom: getInputPadding()),
                        child: TDText(
                          additionInfo,
                          font: TDTheme.of(context).fontBodySmall,
                          textAlign: contentAlignment != TextAlign.center ? contentAlignment : TextAlign.start,
                          textColor: additionInfoColor ?? TDTheme.of(context).fontGyColor3,
                        ),
                      ),
                      visible: additionInfo != '',
                    )
                  ],
                ),
              ),
              Visibility(
                visible: rightWidget != null,
                child: Container(
                  margin: EdgeInsets.only(top: getInputPadding(), bottom: getInputPadding(), right: 16),
                  child: rightWidget,
                ),
              ),
              Visibility(
                visible: controller != null && controller!.text.isNotEmpty && needClear && rightWidget == null,
                child: GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: spacer.inputRightSpace != null ? spacer.inputRightSpace! / 2 : 8,
                          right: spacer.rightSpace ?? 16,
                          top: additionInfo != '' ? getInputPadding() : 0),
                      child: Icon(
                        size: clearIconSize,
                        TDIcons.close_circle_filled,
                        color: clearBtnColor ?? TDTheme.of(context).fontGyColor3,
                      ),
                    ),
                    onTap: onClearTap ??
                        () {
                          controller?.text = '';
                        }),
                replacement: Visibility(
                  visible: rightBtn != null,
                  child: GestureDetector(
                    onTap: onBtnTap,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: spacer.inputRightSpace != null ? spacer.inputRightSpace! / 2 : 8,
                          right: spacer.rightSpace ?? 16,
                          top: additionInfo != '' ? getInputPadding() : 0),
                      child: rightBtn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showBottomDivider)
          Visibility(
            visible: type != TDInputType.cardStyle,
            child: TDDivider(
              margin: EdgeInsets.only(
                left: _getBottomDividerMarginLeft(),
              ),
            ),
          ),
      ],
    );
  }

  BoxDecoration? _getCardStylePreDecoration(BuildContext context) {
    var cardStyleDecoration;
    if (type == TDInputType.cardStyle) {
      switch (cardStyle) {
        case TDCardStyle.topText:
          cardStyleDecoration = BoxDecoration(
              color: Colors.white,
              border: Border.all(color: TDTheme.of(context).grayColor4),
              borderRadius: BorderRadius.circular(6));
          break;
        case TDCardStyle.topTextWithBlueBorder:
          cardStyleDecoration = BoxDecoration(
              color: Colors.white,
              border: Border.all(color: TDTheme.of(context).brandNormalColor, width: 1.5),
              borderRadius: BorderRadius.circular(6));
          break;
        case TDCardStyle.errorStyle:
          cardStyleDecoration = BoxDecoration(
              color: Colors.white,
              border: Border.all(color: TDTheme.of(context).errorColor6, width: 1.5),
              borderRadius: BorderRadius.circular(6));
          break;
        default:
          cardStyleDecoration = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6));
          break;
      }
    }
    return cardStyleDecoration;
  }

  Widget buildTwoLineInput(BuildContext context) {
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
                  child: Row(
                    children: [
                      Visibility(
                        visible: leftLabel != null,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: _leftLabelWidth + (leftLabelSpace ?? 12)),
                          padding: EdgeInsets.only(left: leftLabelSpace ?? 12.0, top: 10.0),
                          child: Column(
                            children: [
                              TDText(
                                leftLabel,
                                maxLines: 2,
                                style: leftLabelStyle ?? const TextStyle(letterSpacing: 0),
                                font: TDTheme.of(context).fontBodyLarge,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: labelWidget != null,
                        child: labelWidget ?? const SizedBox.shrink(),
                      ),
                      Visibility(
                          visible: required ?? false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1.0),
                            child: TDText(
                              '*',
                              maxLines: 1,
                              style: TextStyle(color: TDTheme.of(context).errorColor6),
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
                        contentPadding: contentPadding ??
                            EdgeInsets.only(
                              left: spacer.labelInputSpace ?? 16,
                              right: spacer.inputRightSpace != null ? spacer.inputRightSpace! / 2 : 8,
                            ),
                        inputAction: inputAction,
                      ),
                    ),
                    Visibility(
                      visible: controller != null && controller!.text.isNotEmpty && needClear,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: spacer.inputRightSpace != null ? spacer.inputRightSpace! / 2 : 8,
                            right: spacer.rightSpace ?? 16,
                          ),
                          child: Icon(
                            size: clearIconSize,
                            TDIcons.close_circle_filled,
                            color: clearBtnColor ?? TDTheme.of(context).fontGyColor3,
                          ),
                        ),
                        onTap: onClearTap,
                      ),
                      replacement: Visibility(
                        visible: rightBtn != null,
                        child: GestureDetector(
                          onTap: onBtnTap,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: spacer.inputRightSpace != null ? spacer.inputRightSpace! / 2 : 8,
                              right: spacer.rightSpace ?? 16,
                            ),
                            child: rightBtn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showBottomDivider)
            TDDivider(
              margin: EdgeInsets.only(
                left: _getBottomDividerMarginLeft(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildLongTextInput(BuildContext context) {
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
                    )),
                if (showBottomDivider)
                  TDDivider(
                    margin: EdgeInsets.only(
                      left: _getBottomDividerMarginLeft(),
                    ),
                  ),
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
              inputFormatters: inputFormatters ?? [LengthLimitingTextInputFormatter(maxLength)],
              inputDecoration: inputDecoration,
              maxLines: maxLines,
              focusNode: focusNode,
              hintTextStyle: hintTextStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor3),
              cursorColor: cursorColor,
              textInputBackgroundColor: textInputBackgroundColor,
              controller: controller,
              contentPadding: contentPadding ?? const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
              inputAction: inputAction,
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: TDText(
              '${controller?.text.length}/${maxLength}',
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
          color: decoration != null ? null : backgroundColor,
          decoration: decoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                visible: leftLabel != null,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: leftLabelSpace ?? 16, top: getInputPadding(), bottom: getInputPadding()),
                  child: leftInfoWidth != null
                      ? SizedBox(
                          width: _leftLabelWidth,
                          child: TDText(
                            leftLabel,
                            maxLines: 1,
                            font: TDTheme.of(context).fontBodyLarge,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : TDText(
                          leftLabel,
                          maxLines: 1,
                          font: TDTheme.of(context).fontBodyLarge,
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
                child: Padding(
                  padding: EdgeInsets.only(left: spacer.labelInputSpace!),
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
                    contentPadding: contentPadding ??
                        EdgeInsets.only(
                            right: spacer.inputRightSpace!, bottom: getInputPadding(), top: getInputPadding()),
                    inputAction: inputAction,
                  ),
                ),
              ),
              Visibility(
                visible: rightWidget != null,
                child: Container(
                  margin: EdgeInsets.only(top: getInputPadding(), bottom: getInputPadding(), right: spacer.rightSpace!),
                  child: rightWidget,
                ),
              ),
            ],
          ),
        ),
        if (showBottomDivider)
          Visibility(
            child: TDDivider(
              margin: EdgeInsets.only(
                left: _getBottomDividerMarginLeft(),
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
      width: width ?? screenWidth,
    );
  }

  Widget buildCardStyleInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: cardStyleTopText != null,
          child: Column(
            children: [
              Text(
                cardStyleTopText ?? '',
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
          visible: cardStyleBottomText != null,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                cardStyleBottomText ?? '',
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
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
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
              selection: TextSelection.fromPosition(TextPosition(offset: i, affinity: TextAffinity.downstream)));
        }
      }
    }
    if (newValueLength > 0 && RegExp(_regExp).firstMatch(newValue.text) != null) {
      if (newValueLength + count <= maxLength) {
        return newValue;
      }
    }
    return oldValue;
  }
}
