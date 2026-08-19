import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
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

    /// 标签区域宽度；为空时读取 [TFormThemeData.labelWidth]。
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
    final effectiveLabelWidth = labelWidth ?? theme?.labelWidth ?? 96;
    final effectiveLabelAlign =
        labelAlign ?? theme?.labelAlign ?? TextAlign.start;
    final labelAlignment = switch (effectiveLabelAlign) {
      TextAlign.start || TextAlign.left => AlignmentDirectional.centerStart,
      TextAlign.center => AlignmentDirectional.center,
      _ => AlignmentDirectional.centerEnd,
    };
    final labelText = '${label ?? ''}${theme?.showColon == true ? ':' : ''}';
    final labelFont = token.fontBodyLarge;
    final labelStyle =
        TextStyle(
              color: token.textColorPrimary,
              fontSize: labelFont?.size,
              height: labelFont?.height,
              fontWeight: labelFont?.fontWeight,
            )
            .merge(textTheme?.bodyMedium)
            .merge(defaultTextStyle)
            .merge(theme?.labelStyle);
    final helpFont = token.fontBodySmall;
    final helpStyle =
        theme?.helpStyle ??
        TextStyle(
          color: token.textColorPlaceholder,
          fontSize: helpFont?.size,
          height: helpFont?.height,
          fontWeight: helpFont?.fontWeight,
        ).merge(textTheme?.bodySmall).merge(defaultTextStyle);
    final errorStyle =
        theme?.errorStyle ??
        TextStyle(
              color: token.errorNormalColor,
              fontSize: helpFont?.size,
              height: helpFont?.height,
              fontWeight: helpFont?.fontWeight,
            )
            .merge(textTheme?.bodySmall)
            .merge(materialTheme.inputDecorationTheme.errorStyle)
            .merge(defaultTextStyle);
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
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: theme?.messageGap ?? 4),
          Text(effectiveErrorText, style: errorStyle),
        ] else if (help != null) ...[
          SizedBox(height: theme?.messageGap ?? 4),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (markedLabel != null)
                  SizedBox(
                    width: effectiveLabelWidth,
                    child: Align(alignment: labelAlignment, child: markedLabel),
                  ),
                Expanded(child: content),
                if (extra != null) extra!,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (markedLabel != null) ...[
                  markedLabel,
                  SizedBox(height: theme?.labelGap ?? 8),
                ],
                content,
                if (extra != null) extra!,
              ],
            ),
    );
  }
}
