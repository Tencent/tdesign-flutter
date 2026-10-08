import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_field_scope.dart';
import 't_form.dart';
import 't_form_item_scope.dart';
import 't_form_theme_data.dart';

/// 表单项的标签和字段布局容器。
class TFormItem extends StatelessWidget {
  const TFormItem({
    super.key,
    required this.child,
    this.label,
    this.leading,
    this.required,
    this.help,
    this.errorText,
    this.extra,
    this.verticalAlignment,
    this.contentAlignment,
    this.showErrorMessage = true,
  });

  /// 字段内容。
  final Widget child;

  /// 标签文案。
  final String? label;

  /// 标签区域前的内容，通常用于字段行图标。
  ///
  /// 该插槽属于表单项结构，不会传入输入组件的编辑内容区域。
  final Widget? leading;

  /// 是否显示必填标记；仅覆盖展示效果，不会启用或关闭
  /// [TFormField.required] 的校验行为。
  ///
  /// 未传时继承最近 [TFormField] 的 required 状态。
  final bool? required;

  /// 辅助说明文案。
  final String? help;

  /// 错误文案。
  ///
  /// 未传时自动使用最近 [TFormField] 的校验错误。
  final String? errorText;

  /// 表单项尾部的额外内容。
  ///
  /// 该插槽不会被附加内边距、位移或固定尺寸。
  final Widget? extra;

  /// 水平布局下标签、字段内容和额外内容的纵向对齐方式。
  ///
  /// 未传时默认顶部对齐；这是单个表单项的结构布局选择。
  final TFormItemVerticalAlignment? verticalAlignment;

  /// 内容区域的水平方向对齐方式。
  ///
  /// 未传时默认起始侧对齐；影响
  /// 字段控件、help 和 error 的外部位置，不影响输入文本自身的对齐方式。
  final TFormItemContentAlignment? contentAlignment;

  /// 是否展示继承的校验错误。
  final bool showErrorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TFormThemeData>();
    final token = context.tTheme;
    final fieldScope = TFieldScope.maybeOf(context);
    final inheritedErrorText = showErrorMessage ? fieldScope?.errorText : null;
    final effectiveErrorText = errorText ?? inheritedErrorText;
    final effectiveRequired = required ?? fieldScope?.required ?? false;
    final layout = theme?.layout ?? TFormLayout.horizontal;
    final effectiveLabelWidth = theme?.labelWidth ?? 80;
    final effectiveLabelAlign = theme?.labelAlign ?? TextAlign.start;
    final effectiveLeadingGap = theme?.leadingGap ?? token.spacer;
    final effectiveVerticalAlignment =
        verticalAlignment ?? TFormItemVerticalAlignment.start;
    final effectiveContentAlignment =
        contentAlignment ?? TFormItemContentAlignment.start;
    final horizontalCrossAxisAlignment = switch (effectiveVerticalAlignment) {
      TFormItemVerticalAlignment.start => CrossAxisAlignment.start,
      TFormItemVerticalAlignment.center => CrossAxisAlignment.center,
    };
    final labelAlignment = switch (effectiveLabelAlign) {
      TextAlign.start || TextAlign.justify => AlignmentDirectional.topStart,
      TextAlign.left => Alignment.topLeft,
      TextAlign.center => Alignment.topCenter,
      TextAlign.right => Alignment.topRight,
      TextAlign.end => AlignmentDirectional.topEnd,
    };
    final contentAreaAlignment = switch (effectiveContentAlignment) {
      TFormItemContentAlignment.start => AlignmentDirectional.centerStart,
      TFormItemContentAlignment.end => AlignmentDirectional.centerEnd,
    };
    final contentTextAlign = switch (effectiveContentAlignment) {
      TFormItemContentAlignment.start => TextAlign.start,
      TFormItemContentAlignment.end => TextAlign.end,
    };
    final labelText = '${label ?? ''}${theme?.showColon == true ? ':' : ''}';
    final labelFont = layout == TFormLayout.vertical
        ? token.fontBodyMedium
        : token.fontBodyLarge;
    final labelBaseStyle = TextStyle(
      color: token.textColorPrimary,
      fontSize: labelFont?.size,
      height: labelFont?.height,
      fontWeight: labelFont?.fontWeight,
      letterSpacing: 0,
    );
    final labelStyle = labelBaseStyle.merge(theme?.labelStyle);
    final helpFont = token.fontBodySmall;
    final messageTextStyle = TextStyle(
      fontSize: helpFont?.size,
      height: helpFont?.height,
      fontWeight: helpFont?.fontWeight,
    );
    final helpStyle = messageTextStyle
        .copyWith(color: token.textColorPlaceholder)
        .merge(theme?.helpStyle);
    final errorStyle = messageTextStyle
        .copyWith(color: token.errorColor)
        .merge(theme?.errorStyle);
    final labelWidget = label == null
        ? null
        : Text(labelText, textAlign: effectiveLabelAlign, style: labelStyle);
    final requiredMark = effectiveRequired
        ? Text(
            '*',
            style: TextStyle(
              color: context.tTheme.errorColor,
            ).merge(theme?.requiredMarkStyle),
          )
        : null;
    final markedLabel = labelWidget == null
        ? null
        : requiredMark == null
        ? labelWidget
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if ((theme?.requiredMarkPosition ??
                      TFormRequiredMarkPosition.left) ==
                  TFormRequiredMarkPosition.left) ...[
                requiredMark,
                const SizedBox(width: 2),
              ],
              Flexible(child: labelWidget),
              if ((theme?.requiredMarkPosition ??
                      TFormRequiredMarkPosition.left) ==
                  TFormRequiredMarkPosition.right) ...[
                const SizedBox(width: 2),
                requiredMark,
              ],
            ],
          );
    final leadingWidget = leading == null
        ? null
        : IconTheme.merge(
            data: IconThemeData(color: token.textColorPrimary, size: 24),
            child: leading!,
          );
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TFormItemScope(
          child: TFieldScope(
            required: effectiveRequired,
            errorText: effectiveErrorText,
            showErrorInInput: false,
            child: effectiveContentAlignment == TFormItemContentAlignment.end
                ? Align(alignment: contentAreaAlignment, child: child)
                : child,
          ),
        ),
        if (effectiveErrorText != null) ...[
          SizedBox(height: theme?.messageGap ?? 4.0),
          effectiveContentAlignment == TFormItemContentAlignment.end
              ? Align(
                  alignment: contentAreaAlignment,
                  child: Text(
                    effectiveErrorText,
                    textAlign: contentTextAlign,
                    style: errorStyle,
                  ),
                )
              : Text(effectiveErrorText, style: errorStyle),
        ] else if (help != null) ...[
          SizedBox(height: theme?.messageGap ?? 4.0),
          effectiveContentAlignment == TFormItemContentAlignment.end
              ? Align(
                  alignment: contentAreaAlignment,
                  child: Text(
                    help!,
                    textAlign: contentTextAlign,
                    style: helpStyle,
                  ),
                )
              : Text(help!, style: helpStyle),
        ],
      ],
    );

    return Container(
      color: theme?.backgroundColor ?? token.bgColorContainer,
      constraints:
          theme?.itemPadding == null && layout == TFormLayout.horizontal
          ? const BoxConstraints(minHeight: 56)
          : null,
      foregroundDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme?.borderColor ?? token.componentStroke,
          ),
        ),
      ),
      padding:
          theme?.itemPadding ??
          EdgeInsets.symmetric(
            horizontal: 16,
            vertical: layout == TFormLayout.horizontal ? 14 : 16,
          ),
      margin: EdgeInsets.only(bottom: theme?.itemSpacing ?? 0),
      child: layout == TFormLayout.horizontal
          ? Row(
              crossAxisAlignment: horizontalCrossAxisAlignment,
              children: [
                if (leadingWidget != null) ...[
                  leadingWidget,
                  SizedBox(width: effectiveLeadingGap),
                ],
                if (markedLabel != null) ...[
                  SizedBox(
                    width: effectiveLabelWidth,
                    child: Align(alignment: labelAlignment, child: markedLabel),
                  ),
                  SizedBox(width: token.spacer2),
                ],
                Expanded(child: content),
                if (extra != null) extra!,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (leadingWidget != null || markedLabel != null) ...[
                        if (leadingWidget != null)
                          Row(
                            children: [
                              leadingWidget,
                              if (markedLabel != null) ...[
                                SizedBox(width: effectiveLeadingGap),
                                Expanded(child: markedLabel),
                              ],
                            ],
                          )
                        else
                          markedLabel!,
                        SizedBox(height: theme?.labelGap ?? 8),
                      ],
                      content,
                    ],
                  ),
                ),
                if (extra != null) extra!,
              ],
            ),
    );
  }
}
