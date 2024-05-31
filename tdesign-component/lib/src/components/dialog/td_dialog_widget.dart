/*
 * Created by haozhicao@tencent.com on 6/20/22.
 * td_dialog_widget.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// TDDialog手脚架
class TDDialogScaffold extends StatelessWidget {
  const TDDialogScaffold({
    Key? key,
    required this.body,
    this.showCloseButton,
    this.backgroundColor = Colors.white,
    this.radius = 12.0,
  }) : super(key: key);

  /// Dialog主体
  final Widget body;

  /// 显示右上角关闭按钮
  final bool? showCloseButton;

  /// 背景色
  final Color backgroundColor;

  /// 圆角
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 311,
        decoration: BoxDecoration(
          color: backgroundColor, // 底色
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: Stack(
          children: [
            body,
            showCloseButton ?? false
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: Center(
                          child: Icon(
                            TDIcons.close,
                            size: 22,
                            color: TDTheme.of(context).fontGyColor3,
                          ),
                        ),
                      ),
                    ))
                : Container(height: 0)
          ],
        ),
      ),
    );
  }
}

/// 弹窗标题
class TDDialogTitle extends StatelessWidget {
  const TDDialogTitle({
    Key? key,
    this.title,
    this.titleColor = Colors.black,
  }) : super(key: key);

  /// 标题颜色
  final Color titleColor;

  /// 标题文字
  final String? title;

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    return TDText(
      title,
      textColor: titleColor,
      fontWeight: FontWeight.w600,
      font: Font(size: 16, lineHeight: 24),
      textAlign: TextAlign.center,
    );
  }
}

/// 弹窗内容
class TDDialogContent extends StatelessWidget {
  const TDDialogContent({
    Key? key,
    this.content,
    this.contentColor = const Color(0x99000000),
  }) : super(key: key);

  /// 标题颜色
  final Color contentColor;

  /// 标题文字
  final String? content;

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    return TDText(
      content,
      textColor: contentColor,
      font: Font(size: 16, lineHeight: 24),
      textAlign: TextAlign.center,
    );
  }
}

/// 弹窗信息
class TDDialogInfoWidget extends StatelessWidget {
  const TDDialogInfoWidget({
    Key? key,
    this.title,
    this.titleColor = Colors.black,
    this.titleAlignment,
    this.contentWidget,
    this.content,
    this.contentColor,
    this.contentMaxHeight = 0,
    this.padding = const EdgeInsets.fromLTRB(24, 32, 24, 0),
  }) : super(key: key);

  /// 标题
  final String? title;

  /// 标题颜色
  final Color titleColor;

  /// 标题对齐模式
  final AlignmentGeometry? titleAlignment;

  /// 内容Widget
  final Widget? contentWidget;

  /// 内容
  final String? content;

  /// 内容颜色
  final Color? contentColor;

  /// 内容的最大高度，默认为0，也就是不限制高度
  final double contentMaxHeight;

  /// 内容的内边距
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    assert((title != null || content != null));
    return Container(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Align(
              alignment: titleAlignment ?? Alignment.center,
              child: TDText(
                title,
                textColor: titleColor,
                fontWeight: FontWeight.w600,
                font: Font(size: 18, lineHeight: 26),
                textAlign: TextAlign.center,
              ),
            ),
          if (contentWidget != null || content != null)
            Container(
              padding: EdgeInsets.fromLTRB(0, (title != null && content != null) ? 8.0 : 0, 0, 0),
              constraints: contentMaxHeight > 0
                  ? BoxConstraints(
                      maxHeight: contentMaxHeight,
                    )
                  : null,
              child: contentWidget ??
                  Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: TDDialogContent(
                        content: content!,
                        contentColor: contentColor ?? const Color(0x99000000),
                      ),
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}

/// 横向排列的两个按钮
class HorizontalNormalButtons extends StatelessWidget {
  const HorizontalNormalButtons({
    Key? key,
    required this.leftBtn,
    required this.rightBtn,
  }) : super(key: key);

  /// 左按钮
  final TDDialogButtonOptions leftBtn;

  /// 右按钮
  final TDDialogButtonOptions rightBtn;

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TDDialogButton(
              buttonText: leftBtn.title,
              buttonTextColor: leftBtn.titleColor ?? TDTheme.of(context).brandNormalColor,
              buttonStyle: leftBtn.style,
              buttonType: leftBtn.type,
              buttonTheme: leftBtn.theme,
              height: leftBtn.height,
              buttonTextFontWeight: leftBtn.fontWeight ?? FontWeight.w600,
              onPressed: () {
                if(leftBtn.action != null){
                  leftBtn.action!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const TDDivider(
            width: 12,
            color: Colors.transparent,
          ),
          Expanded(
            child: TDDialogButton(
              buttonText: rightBtn.title,
              buttonTextColor: rightBtn.titleColor ?? TDTheme.of(context).whiteColor1,
              buttonStyle: rightBtn.style,
              buttonType: rightBtn.type,
              buttonTheme: rightBtn.theme,
              height: rightBtn.height,
              buttonTextFontWeight: rightBtn.fontWeight ?? FontWeight.w600,
              onPressed: () {
                if(rightBtn.action != null) {
                  rightBtn.action!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 左右横向文字按钮，顶部和中间有分割线
class HorizontalTextButtons extends StatelessWidget {
  const HorizontalTextButtons({
    Key? key,
    required this.leftBtn,
    required this.rightBtn,
  }) : super(key: key);

  /// 左按钮
  final TDDialogButtonOptions leftBtn;

  /// 右按钮
  final TDDialogButtonOptions rightBtn;

  @override
  Widget build(BuildContext context) {
    // 标题和内容不能同时为空
    return Column(
      children: [
        const TDDivider(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TDDialogButton(
                buttonText: leftBtn.title,
                buttonTextColor: leftBtn.titleColor ?? TDTheme.of(context).fontGyColor1,
                buttonStyle: leftBtn.style,
                buttonType: leftBtn.type ?? TDButtonType.text,
                buttonTheme: leftBtn.theme,
                height: leftBtn.height,
                buttonTextFontWeight: leftBtn.fontWeight,
                onPressed: () {
                  if(leftBtn.action != null){
                    leftBtn.action!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const TDDivider(
              width: 1,
              height: 56,
            ),
            Expanded(
              child: TDDialogButton(
                buttonText: rightBtn.title,
                buttonTextColor: rightBtn.titleColor ?? TDTheme.of(context).brandNormalColor,
                buttonStyle: leftBtn.style,
                buttonType: leftBtn.type ?? TDButtonType.text,
                buttonTheme: leftBtn.theme ?? TDButtonTheme.primary,
                height: rightBtn.height,
                buttonTextFontWeight: rightBtn.fontWeight ?? FontWeight.w600,
                onPressed: () {
                  if(rightBtn.action != null){
                    rightBtn.action!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

/// 弹窗标题
class TDDialogButton extends StatelessWidget {
  const TDDialogButton({
    Key? key,
    this.buttonText,
    this.buttonTextColor,
    this.buttonTextFontWeight = FontWeight.w600,
    this.buttonStyle,
    this.buttonType,
    this.buttonTheme,
    required this.onPressed,
    this.height = 40.0,
    this.width,
    this.isBlock = true,
  }) : super(key: key);

  /// 按钮文字
  final String? buttonText;

  /// 按钮文字颜色
  final Color? buttonTextColor;

  /// 按钮文字粗细
  final FontWeight? buttonTextFontWeight;

  /// 按钮样式
  final TDButtonStyle? buttonStyle;

  /// 按钮类型
  final TDButtonType? buttonType;

  /// 按钮主题
  final TDButtonTheme? buttonTheme;

  /// 按钮宽度
  final double? width;

  /// 按钮高度
  final double? height;

  /// 按钮高度
  final bool isBlock;

  /// 点击
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TDButton(
      onTap: onPressed,
      style: buttonStyle,
      type: buttonType ?? TDButtonType.fill,
      theme: buttonTheme,
      text: buttonText,
      textStyle: TextStyle(fontWeight: buttonTextFontWeight, color: buttonTextColor),
      width: width,
      height: height,
      isBlock: isBlock,
      margin: EdgeInsets.zero,
    );
  }
}
