import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../button/t_button.dart';
import '../button/t_button_types.dart';
import '../text/t_text.dart';
import 't_empty_theme_data.dart';

/// 空态形态
enum TEmptyVariant {
  /// 仅展示空态内容。
  plain,

  /// 展示空态内容和操作入口。
  operation,
}

/// 用于空数据、网络异常和操作引导的空状态组件。
class TEmpty extends StatelessWidget {
  const TEmpty({
    this.variant = TEmptyVariant.plain,
    this.icon = TIcons.info_circle_filled,
    this.image,
    this.emptyText,
    this.operationText,
    this.onPressed,
    this.customOperationWidget,
    Key? key,
  }) : super(key: key);

  /// 空态形态
  final TEmptyVariant variant;

  /// 图标
  final IconData? icon;

  /// 展示图片
  final Widget? image;

  /// 描述文字
  final String? emptyText;

  /// 操作按钮文案
  final String? operationText;

  /// 点击事件
  final VoidCallback? onPressed;

  /// 自定义操作按钮
  final Widget? customOperationWidget;

  /// 从 Theme 子树读取 L4 默认值
  TEmptyThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TEmptyThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final emptyTextColor = theme?.emptyTextColor;
    final emptyTextFont = theme?.emptyTextFont;
    final operationTheme = theme?.operationTheme ?? TButtonColorScheme.primary;

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
          (variant == TEmptyVariant.operation)
              ? customOperationWidget ??
                  Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: TButton(
                        child: Text(operationText ?? ''),
                        size: TButtonSize.large,
                        colorScheme: operationTheme,
                        onPressed: onPressed,
                      ))
              : Container()
        ],
      ),
    );
  }
}
