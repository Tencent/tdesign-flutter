import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum TDResultTheme { defaultTheme, success, warning, error }

class TDResult extends StatelessWidget {
// 描述文本，用于提供额外信息
  final String? description;
// 图标组件，用于在结果中显示一个图标
  final Widget? icon;
// 主题样式，定义了结果组件的视觉风格
  final TDResultTheme theme;
// 标题文本，显示结果的主要信息
  final String title;

  // 构造函数，用于初始化Result组件
  const TDResult({
    Key? key,
    this.description,
    this.icon,
    this.theme = TDResultTheme.defaultTheme, // 默认主题样式为defaultTheme
    this.title = '', // 默认标题为空字符串
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 根据主题获取默认的图标组件
    Widget displayIcon = _getDefaultIconByTheme(context, theme);
    // 如果提供了自定义图标，则使用自定义图标
    if (icon != null) {
      displayIcon = icon!;
    }
    // 构建组件布局
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: displayIcon,
        ),
        // 如果标题不为空，则显示标题
        if (title.isNotEmpty)
          Padding(
              padding: const EdgeInsets.only(top: 17),
              child: TDText(
                title,
                textColor: TDTheme.of(context).fontGyColor1,
                font: TDTheme.of(context).fontTitleExtraLarge,
              )),
        // 如果描述不为空，则显示描述
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TDText(description!,
                textColor: TDTheme.of(context).fontGyColor2,
                font: TDTheme.of(context).fontTitleSmall),
          ),
      ],
    );
  }

  // 根据主题返回对应的默认图标组件
  Widget _getDefaultIconByTheme(BuildContext context, TDResultTheme theme) {
    switch (theme) {
      case TDResultTheme.success:
        return Icon(TDIcons.check_circle,
            color: TDTheme.of(context).successNormalColor, size: 70);
      case TDResultTheme.warning:
        return Icon(TDIcons.error_circle,
            color: TDTheme.of(context).warningNormalColor, size: 70);
      case TDResultTheme.error:
        return Icon(TDIcons.close_circle,
            color: TDTheme.of(context).errorNormalColor, size: 70);
      default:
        return Icon(TDIcons.info_circle,
            color: TDTheme.of(context).brandNormalColor, size: 70);
    }
  }
}
