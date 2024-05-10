import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/basic.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_font_family.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_radius.dart';
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
    this.bordered,
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

  /// 是否显示外边框
  final bool? bordered;

  @override
  Widget build(BuildContext context) {
    var padding = _getInputPadding(context);
    var textareaView = _getTextareaView(context, _getInputView(context), _getIndicatorView(context));
    var container = _getContainer(context, _getLabelView(context), textareaView);
    return bordered == true || decoration != null
        ? container
        : Stack(
            children: [
              container,
              Positioned(
                bottom: 0,
                left: padding,
                right: 0,
                child: Container(
                  height: 0.5,
                  color: TDTheme.of(context).grayColor3,
                ),
              ),
            ],
          );
  }

  Widget _getLabelView(BuildContext context) {
    var padding = _getInputPadding(context);
    var isHorizontal = layout == TDTextareaLayout.horizontal;
    var fontSize = isHorizontal ? TDTheme.of(context).fontBodyLarge?.size : TDTheme.of(context).fontBodyMedium?.size;
    return (label == null || label == '') && labelIcon == null && labelWidget == null
        ? const SizedBox.shrink()
        : Container(
            width: labelWidth,
            padding:
                isHorizontal ? EdgeInsets.only(right: padding) : EdgeInsets.only(bottom: TDTheme.of(context).spacer8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                labelIcon ?? const SizedBox.shrink(),
                label != null && label != ''
                    ? Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: labelIcon != null ? TDTheme.of(context).spacer4 : 0),
                          child: Text(
                            label!,
                            maxLines: isHorizontal ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: labelStyle ?? TextStyle(fontSize: fontSize),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                labelWidget ?? const SizedBox.shrink(),
                required == true
                    ? Padding(
                        padding: EdgeInsets.only(left: TDTheme.of(context).spacer4),
                        child: Text(
                          '*',
                          style: TextStyle(color: TDTheme.of(context).errorColor6, fontSize: fontSize),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
  }

  Widget _getInputView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 24), // 设置最小高度为24
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
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        Visibility(
          child: Padding(
            padding: EdgeInsets.only(top: TDTheme.of(context).spacer8),
            child: Text(
              additionInfo!,
              style: TextStyle(
                fontSize: TDTheme.of(context).fontBodySmall?.size,
                color: additionInfoColor ?? TDTheme.of(context).fontGyColor3,
              ),
            ),
          ),
          visible: additionInfo != '' && additionInfo != null,
        ),
      ],
    );
  }

  Widget _getIndicatorView(BuildContext context) {
    return Visibility(
      visible: indicator == true && maxLength != null,
      child: Text(
        '${controller?.text.length ?? 0}/${maxLength}',
        style: TextStyle(
            fontSize: TDTheme.of(context).fontBodySmall?.size,
            color: TDTheme.of(context).fontGyColor3),
      ),
    );
  }

  Widget _getTextareaView(BuildContext context, Widget inputView, Widget indicatorView) {
    var padding = _getInputPadding(context);
    return Container(
      decoration: textareaDecoration ??
          (bordered == true
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(TDTheme.of(context).radiusDefault),
                  border: Border.all(color: TDTheme.of(context).grayColor4),
                )
              : null),
      padding: bordered == true ? EdgeInsets.all(padding) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          inputView,
          indicatorView,
        ],
      ),
    );
  }

  Widget _getContainer(BuildContext context, Widget labelView, Widget textareaView) {
    var padding = _getInputPadding(context);
    var isHorizontal = layout == TDTextareaLayout.horizontal;
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
