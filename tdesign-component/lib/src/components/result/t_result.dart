import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_result_theme_data.dart';

/// 结果状态。
enum TResultStatus {
  /// 默认信息状态。
  info,

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
    this.description,
    this.icon,
    this.status = TResultStatus.info,
    this.title = '',
  }) : super(key: key);

  /// 描述文本，用于提供额外信息；为空时不占布局空间。
  final String? description;

  /// 图标组件，用于在结果中显示一个图标
  final Widget? icon;

  /// 当前结果状态，决定默认图标、颜色和无障碍语义，默认为 [TResultStatus.info]。
  final TResultStatus status;

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
    final displayIcon = icon ?? _getDefaultIcon(context, status);
    final children = <Widget>[
      KeyedSubtree(key: const ValueKey('result-icon'), child: displayIcon),
      if (title.isNotEmpty)
        TText(
          title,
          key: const ValueKey('result-title'),
          textColor: material?.onSurface ?? context.tTheme.textColorPrimary,
          font: context.tTheme.fontTitleMedium,
          style: titleStyle,
          textAlign: TextAlign.center,
        ),
      if (description != null && description!.isNotEmpty)
        TText(
          description!,
          key: const ValueKey('result-description'),
          textColor:
              material?.onSurfaceVariant ?? context.tTheme.textColorSecondary,
          font: context.tTheme.fontBodyMedium,
          style: theme?.descriptionStyle,
          textAlign: TextAlign.center,
        ),
    ];
    return Semantics(
      container: true,
      label: _statusSemanticsLabel(status),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0)
              SizedBox(
                key: ValueKey('result-spacing-$index'),
                height: context.tTheme.spacer12,
              ),
            children[index],
          ],
        ],
      ),
    );
  }

  String _statusSemanticsLabel(TResultStatus status) {
    return switch (status) {
      TResultStatus.info => '默认结果',
      TResultStatus.success => '成功结果',
      TResultStatus.warning => '警告结果',
      TResultStatus.error => '错误结果',
    };
  }

  /// 根据形态返回对应的默认图标组件
  Widget _getDefaultIcon(BuildContext context, TResultStatus status) {
    final material = Theme.of(context).tExplicitColorScheme;
    final iconSize = _theme(context)?.iconSize ?? 80;
    switch (status) {
      case TResultStatus.success:
        return Icon(
          TIcons.check_circle,
          color: context.tTheme.successNormalColor,
          size: iconSize,
        );
      case TResultStatus.warning:
        return Icon(
          TIcons.error_circle,
          color: context.tTheme.warningNormalColor,
          size: iconSize,
        );
      case TResultStatus.error:
        return Icon(
          TIcons.close_circle,
          color: material?.error ?? context.tTheme.errorNormalColor,
          size: iconSize,
        );
      case TResultStatus.info:
        return Icon(
          TIcons.info_circle,
          color: material?.primary ?? context.tTheme.brandNormalColor,
          size: iconSize,
        );
    }
  }
}
