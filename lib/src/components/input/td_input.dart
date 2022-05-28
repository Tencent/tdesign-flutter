import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'input_view.dart';

class TDInput extends StatelessWidget {
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
  final String? hitText;

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
  final TextStyle textStyle;

  /// 提示文本颜色，默认为文本颜色
  final TextStyle? hitTextStyle;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// 右侧按钮
  final Widget? rightBtn;

  /// 右侧按钮点击
  final GestureTapCallback? onTapBtn;

  /// textInput内边距
  final EdgeInsetsGeometry contentPadding;

  const TDInput({
    Key? key,
    required this.textStyle,
    this.backgroundColor,
    this.decoration,
    this.leftLabel,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.onEditingComplete,
    this.onSubmitted,
    this.hitText,
    this.inputType,
    this.onChanged,
    this.inputFormatters,
    this.inputDecoration,
    this.maxLines = 1,
    this.focusNode,
    this.controller,
    this.cursorColor,
    this.rightBtn,
    this.hitTextStyle,
    this.onTapBtn,
    this.labelWidget,
    this.textInputBackgroundColor,
    this.contentPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: decoration != null ? null : backgroundColor,
      decoration: decoration,
      child: Row(
        children: <Widget>[
          Visibility(
            visible: leftLabel != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TDText(
                leftLabel,
                maxLines: 2,
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
            child: TDInputView(
              textStyle: textStyle,
              readOnly: readOnly,
              autofocus: autofocus,
              obscureText: obscureText,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
              hitText: hitText,
              inputType: inputType,
              onChanged: onChanged,
              inputFormatters: inputFormatters,
              inputDecoration: inputDecoration,
              maxLines: maxLines,
              focusNode: focusNode,
              hitTextStyle: hitTextStyle,
              cursorColor: cursorColor,
              textInputBackgroundColor: textInputBackgroundColor,
              controller: controller,
              contentPadding: contentPadding,
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
    );
  }
}
