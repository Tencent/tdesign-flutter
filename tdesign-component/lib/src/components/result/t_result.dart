import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum TResultTheme { defaultTheme, success, warning, error }

class TResult extends StatelessWidget {
  const TResult({
    Key? key,
    this.description,
    this.icon,
    this.titleStyle,
    this.theme = TResultTheme.defaultTheme,
    this.title = '',
  }) : super(key: key);

  /// 描述文本，用于提供额外信息
  final String? description;

  /// 图标组件，用于在结果中显示一个图标
  final Widget? icon;

  /// 自定义字体样式，用于设置标题文本的样式
  final TextStyle? titleStyle;

  /// 主题样式，默认主题样式为defaultTheme
  final TResultTheme theme;

  /// 标题文本，显示结果的主要信息，默认标题为空字符串
  final String title;

  @override
  Widget build(BuildContext context) {
    // 根据主题获取默认的图标组件
    var displayIcon = icon ?? _getDefaultIconByTheme(context, theme);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: displayIcon,
        ),
        if (title.isNotEmpty)
          Padding(
              padding: const EdgeInsets.only(top: 17),
              child: TText(
                title,
                textColor: TTheme.of(context).textColorPrimary,
                font: TTheme.of(context).fontTitleExtraLarge,
                style: titleStyle,
              )),
        if (description != null && description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TText(
              description!,
              textColor: TTheme.of(context).textColorSecondary,
              font: TTheme.of(context).fontTitleSmall,
            ),
          ),
      ],
    );
  }

  // 根据主题返回对应的默认图标组件
  Widget _getDefaultIconByTheme(BuildContext context, TResultTheme theme) {
    switch (theme) {
      case TResultTheme.success:
        return Icon(
          TIcons.check_circle,
          color: TTheme.of(context).successNormalColor,
          size: 70,
        );
      case TResultTheme.warning:
        return Icon(
          TIcons.error_circle,
          color: TTheme.of(context).warningNormalColor,
          size: 70,
        );
      case TResultTheme.error:
        return Icon(
          TIcons.close_circle,
          color: TTheme.of(context).errorNormalColor,
          size: 70,
        );
      default:
        return Icon(
          TIcons.info_circle,
          color: TTheme.of(context).brandNormalColor,
          size: 70,
        );
    }
  }
}
