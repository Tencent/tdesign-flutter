import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_form.dart';
import 't_form_theme_data.dart';

/// 表单项子树中的错误展示状态。
///
/// 基础输入组件使用它避免与 [TFormItem] 重复渲染同一条错误文案。
class TFormItemScope extends InheritedWidget {
  const TFormItemScope({
    super.key,
    required this.presentsError,
    required super.child,
  });

  /// 当前表单项是否负责展示错误文案。
  final bool presentsError;

  /// 读取最近的表单项状态。
  static TFormItemScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TFormItemScope>();
  }

  @override
  bool updateShouldNotify(TFormItemScope oldWidget) {
    return presentsError != oldWidget.presentsError;
  }
}

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

    /// 标签末尾的额外内容。
    this.extra,
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

  /// 标签末尾的额外内容。
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TFormThemeData>();
    final materialTheme = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context).style;
    final textTheme = materialTheme.textTheme;
    final fieldScope = TFormFieldScope.maybeOf(context);
    final inheritedErrorText = fieldScope?.errorText;
    final effectiveErrorText = errorText ?? inheritedErrorText;
    final effectiveRequired = required ?? fieldScope?.required ?? false;
    final layout = theme?.layout ?? TFormLayout.horizontal;
    final effectiveLabelWidth = labelWidth ?? theme?.labelWidth ?? 96;
    final labelText = '${label ?? ''}${theme?.showColon == true ? ':' : ''}';
    final labelStyle = (textTheme.bodyMedium ?? const TextStyle())
        .merge(defaultTextStyle)
        .merge(theme?.labelStyle);
    final helpStyle = theme?.helpStyle ??
        (textTheme.bodySmall ?? const TextStyle())
            .merge(defaultTextStyle)
            .merge(TextStyle(color: context.tTheme.textColorSecondary));
    final errorStyle = theme?.errorStyle ??
        defaultTextStyle
            .merge(materialTheme.inputDecorationTheme.errorStyle)
            .merge(TextStyle(color: context.tTheme.errorNormalColor));
    final labelWidget = label == null
        ? null
        : Text(
            labelText,
            textAlign: theme?.labelAlign,
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
    final markedLabel = labelWidget == null
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: labelWidget),
              if (effectiveRequired)
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
        TFormItemScope(
          presentsError: effectiveErrorText != null,
          child: child,
        ),
        if (effectiveErrorText != null) ...[
          SizedBox(height: theme?.messageGap ?? 4),
          Text(
            effectiveErrorText,
            style: errorStyle,
          ),
        ] else if (help != null) ...[
          SizedBox(height: theme?.messageGap ?? 4),
          Text(
            help!,
            style: helpStyle,
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
