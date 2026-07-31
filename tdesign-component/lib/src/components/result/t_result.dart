import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_result_theme_data.dart';

/// 结果形态
enum TResultVariant {
  /// 默认结果状态。
  defaultTheme,

  /// 成功结果状态。
  success,

  /// 警告结果状态。
  warning,

  /// 错误结果状态。
  error,
}

/// 用于展示成功、警告、失败或默认结果状态的内容块。
class TResult extends StatelessWidget {
  const TResult({
    Key? key,
    this.subtitle,
    this.icon,
    this.variant = TResultVariant.defaultTheme,
    this.title = '',
  }) : super(key: key);

  /// 描述文本，用于提供额外信息
  final String? subtitle;

  /// 图标组件，用于在结果中显示一个图标
  final Widget? icon;

  /// 结果形态
  final TResultVariant variant;

  /// 标题文本，显示结果的主要信息，默认标题为空字符串
  final String title;

  /// 从 Theme 子树读取 L4 默认值
  TResultThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TResultThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final material = Theme.of(context).tExplicitColorScheme;
    final titleStyle = theme?.titleStyle;
    var displayIcon = icon ?? _getDefaultIcon(context, variant);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(child: displayIcon),
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: TText(
              title,
              textColor: material?.onSurface ?? context.tTheme.textColorPrimary,
              font: context.tTheme.fontTitleExtraLarge,
              style: titleStyle,
            ),
          ),
        if (subtitle != null && subtitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TText(
              subtitle!,
              textColor:
                  material?.onSurfaceVariant ??
                  context.tTheme.textColorSecondary,
              font: context.tTheme.fontTitleSmall,
            ),
          ),
      ],
    );
  }

  /// 根据形态返回对应的默认图标组件
  Widget _getDefaultIcon(BuildContext context, TResultVariant variant) {
    final material = Theme.of(context).tExplicitColorScheme;
    switch (variant) {
      case TResultVariant.success:
        return Icon(
          TIcons.check_circle,
          color: context.tTheme.successNormalColor,
          size: 70,
        );
      case TResultVariant.warning:
        return Icon(
          TIcons.error_circle,
          color: context.tTheme.warningNormalColor,
          size: 70,
        );
      case TResultVariant.error:
        return Icon(
          TIcons.close_circle,
          color: material?.error ?? context.tTheme.errorNormalColor,
          size: 70,
        );
      default:
        return Icon(
          TIcons.info_circle,
          color: material?.primary ?? context.tTheme.brandNormalColor,
          size: 70,
        );
    }
  }
}
