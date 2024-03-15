import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TDInputView extends StatelessWidget {
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
  final int? maxLines;

  /// 最大输入长度
  final int? maxLength;

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
  final TextStyle? hintTextStyle;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// textInput内边距
  final EdgeInsetsGeometry contentPadding;

  final bool isCollapsed;

  /// 文本对齐方向
  final TextAlign? textAlign;

  const TDInputView(
      {Key? key,
      required this.textStyle,
      this.readOnly = false,
      this.autofocus = false,
      this.obscureText = false,
      this.onEditingComplete,
      this.onSubmitted,
      this.hintText = '',
      this.inputType,
      this.onChanged,
      this.inputFormatters,
      this.inputDecoration,
      this.maxLines,
      this.maxLength,
      this.focusNode,
      this.hintTextStyle,
      this.cursorColor,
      this.textInputBackgroundColor,
      this.contentPadding = EdgeInsets.zero,
      this.isCollapsed = false,
      this.textAlign,
      this.controller})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      keyboardType: inputType,
      autofocus: autofocus,
      obscureText: obscureText,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      cursorColor: cursorColor,
      maxLines: maxLines,
      maxLength: maxLength,
      style: textStyle,
      textAlign: textAlign ?? TextAlign.start,
      buildCounter: _buildCounter,
      decoration: inputDecoration ??
          InputDecoration(
            hintText: hintText,
            hintStyle: hintTextStyle ?? textStyle,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: textInputBackgroundColor != null,
            fillColor: textInputBackgroundColor,
            contentPadding: contentPadding,
            isCollapsed: isCollapsed,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
    );
  }

  Widget? _buildCounter(BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) {
    return null;
  }
}
