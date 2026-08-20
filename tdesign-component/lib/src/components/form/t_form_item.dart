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

    /// 字段内容。
    required this.child,

    /// 标签文案。
    this.label,

    /// 标签区域前的内容，通常用于字段行图标。
    ///
    /// 该插槽属于表单项结构，不会传入输入组件的编辑内容区域。
    this.leading,

    /// 是否显示必填标记。
    ///
    /// 未传时继承最近 [TFormField] 的 required 状态。
    this.required,

    /// 辅助说明文案。
    this.help,

    /// 错误文案。
    ///
    /// 未传时自动使用最近 [TFormField] 的校验错误。
    this.errorText,

    /// 标签区域宽度；为空时读取 [TFormThemeData.labelWidth]，默认 80dp。
    this.labelWidth,

    /// 标签文本对齐方式；为空时读取 [TFormThemeData.labelAlign]。
    this.labelAlign,

    /// 标签末尾的额外内容。
    this.extra,

    /// 是否展示继承的校验错误。
    this.showErrorMessage = true,
  });

  /// 字段内容。
  final Widget child;

  /// 标签文案。
  final String? label;

  /// 标签区域前的内容，通常用于字段行图标。
  final Widget? leading;

  /// 是否显示必填标记。
  final bool? required;

  /// 辅助说明文案。
  final String? help;

  /// 错误文案。
  final String? errorText;

  /// 标签区域宽度。
  final double? labelWidth;

  /// 标签文本对齐方式。
  final TextAlign? labelAlign;

  /// 标签末尾的额外内容。
  final Widget? extra;

  /// 是否展示从 [TFormField] 继承的校验错误。
  final bool showErrorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TFormThemeData>();
    final materialTheme = Theme.of(context);
    final defaultTextStyle = context.tExplicitDefaultTextStyle;
    final textTheme = materialTheme.tExplicitTextTheme;
    final token = context.tTheme;
    final fieldScope = TFieldScope.maybeOf(context);
    final inheritedErrorText = showErrorMessage ? fieldScope?.errorText : null;
    final effectiveErrorText = errorText ?? inheritedErrorText;
    final effectiveRequired = required ?? fieldScope?.required ?? false;
    final layout = theme?.layout ?? TFormLayout.horizontal;
    final effectiveLabelWidth = labelWidth ?? theme?.labelWidth ?? 80;
    final effectiveLabelAlign =
        labelAlign ?? theme?.labelAlign ?? TextAlign.start;
    final effectiveLeadingGap = theme?.leadingGap ?? token.spacer8;
    final labelAlignment = switch ((
      effectiveLabelAlign,
      theme?.horizontalCrossAxisAlignment,
    )) {
      (TextAlign.start || TextAlign.left, CrossAxisAlignment.start) =>
        AlignmentDirectional.topStart,
      (TextAlign.center, CrossAxisAlignment.start) => Alignment.topCenter,
      (_, CrossAxisAlignment.start) => AlignmentDirectional.topEnd,
      (TextAlign.start || TextAlign.left, CrossAxisAlignment.end) =>
        AlignmentDirectional.bottomStart,
      (TextAlign.center, CrossAxisAlignment.end) => Alignment.bottomCenter,
      (_, CrossAxisAlignment.end) => AlignmentDirectional.bottomEnd,
      (TextAlign.start || TextAlign.left, _) =>
        AlignmentDirectional.centerStart,
      (TextAlign.center, _) => Alignment.center,
      _ => AlignmentDirectional.centerEnd,
    };
    final labelText = '${label ?? ''}${theme?.showColon == true ? ':' : ''}';
    final labelFont = token.fontBodyLarge;
    final labelStyle = const TextStyle()
        .merge(textTheme?.bodyMedium)
        .merge(defaultTextStyle)
        .merge(
          TextStyle(
            color: token.textColorPrimary,
            fontSize: labelFont?.size,
            height: labelFont?.height,
            fontWeight: labelFont?.fontWeight,
          ),
        )
        .merge(theme?.labelStyle);
    final helpFont = token.fontBodySmall;
    final helpStyle = const TextStyle()
        .merge(textTheme?.bodySmall)
        .merge(defaultTextStyle)
        .merge(
          TextStyle(
            color: token.textColorPlaceholder,
            fontSize: helpFont?.size,
            height: helpFont?.height,
            fontWeight: helpFont?.fontWeight,
          ),
        )
        .merge(theme?.helpStyle);
    final errorStyle = const TextStyle()
        .merge(textTheme?.bodySmall)
        .merge(materialTheme.inputDecorationTheme.errorStyle)
        .merge(defaultTextStyle)
        .merge(
          TextStyle(
            color: token.errorNormalColor,
            fontSize: helpFont?.size,
            height: helpFont?.height,
            fontWeight: helpFont?.fontWeight,
          ),
        )
        .merge(theme?.errorStyle);
    final labelWidget = label == null
        ? null
        : Text(labelText, textAlign: effectiveLabelAlign, style: labelStyle);
    final requiredMark = effectiveRequired
        ? Text(
            '*',
            style:
                theme?.requiredMarkStyle ??
                TextStyle(color: context.tTheme.errorNormalColor),
          )
        : null;
    final markedLabel = labelWidget == null
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if ((theme?.requiredMarkPosition ??
                      TFormRequiredMarkPosition.left) ==
                  TFormRequiredMarkPosition.left) ...[
                if (requiredMark != null) requiredMark,
                if (requiredMark != null) const SizedBox(width: 2),
              ],
              Flexible(child: labelWidget),
              if ((theme?.requiredMarkPosition ??
                      TFormRequiredMarkPosition.left) ==
                  TFormRequiredMarkPosition.right) ...[
                if (requiredMark != null) const SizedBox(width: 2),
                if (requiredMark != null) requiredMark,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TFormItemScope(
          child: TFieldScope(
            required: effectiveRequired,
            errorText: effectiveErrorText,
            showErrorInInput: false,
            child: child,
          ),
        ),
        if (effectiveErrorText != null) ...[
          SizedBox(height: theme?.messageGap ?? token.spacer4),
          Text(effectiveErrorText, style: errorStyle),
        ] else if (help != null) ...[
          SizedBox(height: theme?.messageGap ?? token.spacer4),
          Text(help!, style: helpStyle),
        ],
      ],
    );

    return Container(
      color: theme?.backgroundColor ?? token.bgColorContainer,
      foregroundDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme?.borderColor ?? token.componentStrokeColor,
          ),
        ),
      ),
      padding:
          theme?.itemPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.only(bottom: theme?.itemSpacing ?? 0),
      child: layout == TFormLayout.horizontal
          ? Row(
              crossAxisAlignment:
                  theme?.horizontalCrossAxisAlignment ??
                  (effectiveErrorText != null || help != null
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center),
              children: [
                if (leadingWidget != null) ...[
                  leadingWidget,
                  SizedBox(width: effectiveLeadingGap),
                ],
                if (markedLabel != null)
                  SizedBox(
                    width: effectiveLabelWidth,
                    child: Align(alignment: labelAlignment, child: markedLabel),
                  ),
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
