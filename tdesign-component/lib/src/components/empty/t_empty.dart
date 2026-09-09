import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_empty_theme_data.dart';

/// 用于空数据、网络异常和操作引导的空状态组件。
class TEmpty extends StatelessWidget {
  const TEmpty({
    this.icon = TIcons.info_circle_filled,
    this.image,
    this.emptyText,
    this.operation,
    Key? key,
  }) : super(key: key);

  /// 默认图标；[image] 非空时不显示。
  final IconData? icon;

  /// 自定义图片或插画；优先于 [icon]。
  final Widget? image;

  /// 描述文字。
  final String? emptyText;

  /// 描述下方的操作内容，通常为按钮。
  final Widget? operation;

  /// 从 Theme 子树读取 L4 默认值
  TEmptyThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TEmptyThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final emptyTextColor = theme?.emptyTextColor;
    final emptyTextFont = theme?.emptyTextFont;
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image ??
              Icon(
                icon ?? TIcons.info_circle_filled,
                size: 96,
                color: context.tTheme.textColorPlaceholder,
              ),
          Padding(padding: EdgeInsets.only(top: image == null ? 22 : 16)),
          TText(
            emptyText ?? '',
            fontWeight: FontWeight.w400,
            font: emptyTextFont ?? context.tTheme.fontBodyMedium,
            textColor: emptyTextColor ?? context.tTheme.textColorPlaceholder,
          ),
          if (operation != null)
            Padding(padding: const EdgeInsets.only(top: 32), child: operation),
        ],
      ),
    );
  }
}
