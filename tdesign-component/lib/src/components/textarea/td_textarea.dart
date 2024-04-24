import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/basic.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../input/input_view.dart';
import '../input/td_input.dart';
import '../text/td_text.dart';

enum TDTextareaLayout { vertical, horizontal }

/// 用于多行文本信息输入
class TDTextarea extends StatelessWidget {
  const TDTextarea({
    Key? key,
    this.width,
    this.textStyle,
    this.backgroundColor = Colors.white,
    this.decoration,
    this.labelStyle,
    this.required,
    this.readOnly = false,
    this.autofocus = false,
    this.onEditingComplete,
    this.onSubmitted,
    this.hintText,
    this.inputType,
    this.onChanged,
    this.inputFormatters,
    this.inputDecoration,
    this.maxLines,
    this.minLines = 4,
    this.focusNode,
    this.controller,
    this.cursorColor,
    this.hintTextStyle,
    this.labelWidget,
    this.textInputBackgroundColor,
    this.contentPadding,
    this.size = TDInputSize.large,
    this.maxLength,
    this.additionInfo = '',
    this.additionInfoColor,
    this.textAlign,
    this.label,
    this.indicator = false,
    this.layout = TDTextareaLayout.horizontal,
    this.autosize,
    this.labelIcon,
    this.labelWidth,
    this.margin,
    this.textareaDecoration,
  }) : super(key: key);

  /// 输入框宽度
  final double? width;

  /// 输入框背景色
  final Color? backgroundColor;

  /// 输入框样式(包括标签)
  final Decoration? decoration;

  /// 输入框样式(不包括标签)
  final Decoration? textareaDecoration;

  /// 输入框标题
  final String? label;

  /// 输入框标题图标
  final Widget? labelIcon;

  /// 输入框标题宽度
  final double? labelWidth;

  /// label组件，支持自定义
  final Widget? labelWidget;

  /// 是否必填标志（红色*）
  final bool? required;

  /// 是否只读
  final bool? readOnly;

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

  /// 最小输入行数
  final int? minLines;

  /// 获取或者取消焦点使用
  final FocusNode? focusNode;

  /// 是否自动获取焦点
  final bool? autofocus;

  /// 点击键盘完成按钮时触发的回调
  final VoidCallback? onEditingComplete;

  /// 点击键盘完成按钮时触发的回调, 参数值为输入的内容
  final ValueChanged<String>? onSubmitted;

  /// 自定义输入框TextField组件样式
  final InputDecoration? inputDecoration;

  /// 文本颜色
  final TextStyle? textStyle;

  /// 提示文本颜色，默认为文本颜色
  final TextStyle? hintTextStyle;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// textInput内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 输入框规格
  final TDInputSize? size;

  /// 最大字数限制
  final int? maxLength;

  /// 错误提示信息
  final String? additionInfo;

  /// 错误提示颜色
  final Color? additionInfoColor;

  /// 文字对齐方向
  final TextAlign? textAlign;

  /// 左侧标签文本样式
  final TextStyle? labelStyle;

  /// 否显示文本计数器，如 0/140（必须设置maxLength）
  final bool? indicator;

  /// 标题输入框布局方式。可选项：vertical/horizontal
  final TDTextareaLayout? layout;

  /// 是否自动增高，值为 autosize 时，maxLines 不生效
  final bool? autosize;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    var isHorizontal = layout == TDTextareaLayout.horizontal;
    var padding = _getInputPadding(context);
    var labelView = (label == null || label == '') && labelIcon == null && labelWidget == null
        ? const SizedBox.shrink()
        : Container(
            width: labelWidth,
            padding: isHorizontal
                ? EdgeInsets.only(right: TDTheme.of(context).spacer8)
                : EdgeInsets.only(bottom: TDTheme.of(context).spacer8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                labelIcon ?? const SizedBox.shrink(),
                label != null && label != ''
                    ? Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: labelIcon != null ? TDTheme.of(context).spacer4 : 0),
                        child: TDText(
                          label,
                          maxLines: isHorizontal ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          font: TDTheme.of(context).fontBodyLarge,
                          style: labelStyle,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                labelWidget ?? const SizedBox.shrink(),
                required == true
                    ? Padding(
                        padding: EdgeInsets.only(left: TDTheme.of(context).spacer4),
                        child: TDText(
                          '*',
                          maxLines: 1,
                          style: TextStyle(color: TDTheme.of(context).errorColor6),
                          font: TDTheme.of(context).fontBodyLarge,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
    var inputView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: TDInputView(
            textStyle: textStyle ?? TextStyle(color: TDTheme.of(context).fontGyColor1),
            readOnly: readOnly ?? false,
            autofocus: autofocus ?? false,
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            hintText: hintText,
            inputType: inputType,
            textAlign: textAlign,
            onChanged: onChanged,
            inputFormatters:
                inputFormatters ?? (maxLength != null ? [LengthLimitingTextInputFormatter(maxLength)] : null),
            inputDecoration: inputDecoration,
            minLines: minLines,
            maxLines: autosize == true ? null : maxLines,
            focusNode: focusNode,
            isCollapsed: true,
            hintTextStyle: hintTextStyle ??
                TextStyle(
                    color: readOnly == true ? TDTheme.of(context).fontGyColor4 : TDTheme.of(context).fontGyColor3),
            cursorColor: cursorColor,
            textInputBackgroundColor: textInputBackgroundColor,
            controller: controller,
            contentPadding: contentPadding ?? EdgeInsets.all(TDTheme.of(context).spacer4),
          ),
        ),
        Visibility(
          child: Padding(
            padding: EdgeInsets.only(top: TDTheme.of(context).spacer8),
            child: TDText(
              additionInfo,
              font: TDTheme.of(context).fontBodySmall,
              textColor: additionInfoColor ?? TDTheme.of(context).fontGyColor3,
            ),
          ),
          visible: additionInfo != '' && additionInfo != null,
        ),
      ],
    );
    var indicatorView = Visibility(
      visible: indicator == true && maxLength != null,
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(top: TDTheme.of(context).spacer8),
        child: TDText(
          '${controller?.text.length ?? 0}/${maxLength}',
          font: TDTheme.of(context).fontBodySmall,
          textColor: TDTheme.of(context).fontGyColor3,
        ),
      ),
    );
    var textareaView = Container(
      decoration: textareaDecoration,
      padding: textareaDecoration == null ? null : EdgeInsets.all(padding),
      child: Column(
        children: [
          inputView,
          indicatorView,
        ],
      ),
    );
    return Container(
      width: width,
      color: decoration != null ? null : (backgroundColor ?? Colors.white),
      decoration: decoration,
      padding: EdgeInsets.all(padding),
      margin: margin,
      child: isHorizontal
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelView,
                Expanded(
                  child: textareaView,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelView,
                textareaView,
              ],
            ),
    );
  }

  /// 获取输入框规格
  double _getInputPadding(BuildContext context) {
    switch (size) {
      case TDInputSize.small:
        return TDTheme.of(context).spacer12;
      case TDInputSize.large:
        return TDTheme.of(context).spacer16;
      default:
        return TDTheme.of(context).spacer16;
    }
  }
}
