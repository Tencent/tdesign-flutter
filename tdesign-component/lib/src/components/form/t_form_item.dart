import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
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
    this.required = false,

    /// 辅助说明文案。
    this.help,

    /// 错误文案。
    this.errorText,

    /// 标签区域宽度；为空时读取 [TFormThemeData.labelWidth]。
    this.labelWidth,

    /// 标签末尾的额外内容。
    this.extra,
  });

  /// 字段内容。
  final Widget child;

  /// 标签文案。
  final String? label;

  /// 是否显示必填标记。
  final bool required;

  /// 辅助说明文案。
  final String? help;

  /// 错误文案。
  final String? errorText;

  /// 标签区域宽度。
  final double? labelWidth;

  /// 标签末尾的额外内容。
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TFormThemeData>();
    final layout = theme?.layout ?? TFormLayout.horizontal;
    final effectiveLabelWidth = labelWidth ?? theme?.labelWidth ?? 96;
    final labelText = '${label ?? ''}${theme?.showColon == true ? ':' : ''}';
    final labelWidget = label == null
        ? null
        : Text(
            labelText,
            textAlign: theme?.labelAlign,
            style: theme?.labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
    final markedLabel = labelWidget == null
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: labelWidget),
              if (required)
                Text(
                  '*',
                  style: theme?.requiredMarkStyle ??
                      TextStyle(color: context.tTheme.errorNormalColor),
                ),
            ],
          );
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (errorText != null) ...[
          SizedBox(height: theme?.messageGap ?? 4),
          Text(
            errorText!,
            style: theme?.errorStyle ??
                TextStyle(color: context.tTheme.errorNormalColor),
          ),
        ] else if (help != null) ...[
          SizedBox(height: theme?.messageGap ?? 4),
          Text(
            help!,
            style: theme?.helpStyle ??
                TextStyle(color: context.tTheme.textColorSecondary),
          ),
        ],
      ],
    );

    return Container(
      color: theme?.backgroundColor,
      padding: theme?.itemPadding ?? const EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.only(bottom: theme?.itemSpacing ?? 0),
      child: layout == TFormLayout.horizontal
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (markedLabel != null)
                  SizedBox(width: effectiveLabelWidth, child: markedLabel),
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
