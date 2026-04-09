import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 限制Function类型，防止传递错误的Function，导致参数对不上
typedef LinkClick = Function(Uri? uri);

enum TLinkType {
  basic,
  withUnderline,
  withPrefixIcon,
  withSuffixIcon,
}

enum TLinkStyle {
  primary,
  defaultStyle,
  danger,
  warning,
  success,
}

enum TLinkState {
  normal,
  active,
  disabled,
}

enum TLinkSize {
  small,
  medium,
  large,
}

class TLink extends StatelessWidget {
  const TLink({
    Key? key,
    required this.label,
    this.uri,
    this.prefixIcon,
    this.suffixIcon,
    this.linkClick,
    this.type = TLinkType.basic,
    this.style = TLinkStyle.defaultStyle,
    this.state = TLinkState.normal,
    this.size = TLinkSize.medium,
    this.color,
    this.iconSize,
    this.fontSize,
    this.leftGapWithIcon,
    this.rightGapWithIcon,
  }) : super(key: key);

  /// link 展示的文本
  final String label;

  /// link 跳转的uri
  final Uri? uri;

  /// link 类型
  final TLinkType type;

  /// link 风格
  final TLinkStyle style;

  /// link 状态
  final TLinkState state;

  /// link 大小
  final TLinkSize size;

  /// 前置 icon
  final Icon? prefixIcon;

  /// 后置 icon
  final Icon? suffixIcon;

  /// link 文本的颜色，如果不设置则根据状态和风格进行计算
  final Color? color;

  /// link icon 大小，如果不设置则根据状态和风格进行计算
  final double? iconSize;

  /// link 文本的字体大小，如果不设置则根据状态和风格进行计算
  final double? fontSize;

  /// 前置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算
  final double? leftGapWithIcon;

  /// 后置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算
  final double? rightGapWithIcon;

  /// link 被点击之后所采取的动作，会将uri当做参数传入到该方法当中
  final LinkClick? linkClick;

  @override
  Widget build(BuildContext context) {
    if (type == TLinkType.withPrefixIcon) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixIcon == null ? _getDefaultIcon(context) : prefixIcon!,
          SizedBox(
            width: _getLeftGapSize(context),
          ),
          _buildLink(context),
        ],
      );
    } else if (type == TLinkType.withSuffixIcon) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLink(context),
          SizedBox(
            width: _getRightGapSize(context),
          ),
          suffixIcon == null ? _getDefaultIcon(context) : suffixIcon!,
        ],
      );
    }

    return _buildLink(context);
  }

  /// 提取成方法，允许业务定义自己的 TLinkConfiguration
  TLinkConfiguration? getConfiguration(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TLinkConfiguration>();
  }

  Color getColor(BuildContext context) {
    if (color != null) {
      return color!;
    }

    final theme = TTheme.of(context);
    final colorMap = <TLinkState, Map<TLinkStyle, Color>>{
      TLinkState.normal: {
        TLinkStyle.primary: theme.brandNormalColor,
        TLinkStyle.danger: theme.errorNormalColor,
        TLinkStyle.warning: theme.warningNormalColor,
        TLinkStyle.success: theme.successNormalColor,
        TLinkStyle.defaultStyle: theme.textColorPrimary,
      },
      TLinkState.active: {
        TLinkStyle.primary: theme.brandClickColor,
        TLinkStyle.danger: theme.errorClickColor,
        TLinkStyle.warning: theme.warningClickColor,
        TLinkStyle.success: theme.successClickColor,
        TLinkStyle.defaultStyle: theme.brandClickColor,
      },
      TLinkState.disabled: {
        TLinkStyle.primary: theme.brandDisabledColor,
        TLinkStyle.danger: theme.errorDisabledColor,
        TLinkStyle.warning: theme.warningDisabledColor,
        TLinkStyle.success: theme.successDisabledColor,
        TLinkStyle.defaultStyle: theme.textDisabledColor,
      },
    };

    return colorMap[state]?[style] ?? theme.textColorPrimary;
  }

  Widget _getDefaultIcon(BuildContext context) {
    return Icon(
      type == TLinkType.withPrefixIcon ? TIcons.link : TIcons.jump,
      size: _getIconSize(context),
      color: getColor(context),
    );
  }

  Widget _buildLink(BuildContext context) {
    return InkWell(
        onTap: () {
          if (state == TLinkState.disabled) {
            return;
          }
          if (linkClick != null) {
            linkClick!(uri);
          } else {
            var tdLinkConfig = getConfiguration(context);

            if (tdLinkConfig != null && tdLinkConfig.linkClick != null) {
              tdLinkConfig.linkClick!(uri);
            }
          }
        },
        child: TText(
          label,
          style: TextStyle(
            fontSize: _getFontSize(context),
            color: getColor(context),
            decoration: type == TLinkType.withUnderline
                ? TextDecoration.underline
                : null,
            decorationColor: getColor(context),
          ),
          forceVerticalCenter: true,
        ));
  }

  double _getIconSize(BuildContext context) {
    if (iconSize != null) {
      return iconSize!;
    }
    switch (size) {
      case TLinkSize.large:
        return 18;
      case TLinkSize.small:
        return 14;
      case TLinkSize.medium:
        return 16;
    }
  }

  double _getFontSize(BuildContext context) {
    if (fontSize != null) {
      return fontSize!;
    }
    switch (size) {
      case TLinkSize.large:
        return 16;
      case TLinkSize.small:
        return 12;
      case TLinkSize.medium:
        return 14;
    }
  }

  double _getLeftGapSize(BuildContext context) {
    if (leftGapWithIcon != null) {
      return leftGapWithIcon!;
    }
    switch (size) {
      case TLinkSize.large:
        return 8;
      case TLinkSize.small:
        return 6.05;
      case TLinkSize.medium:
        return 6.34;
    }
  }

  double _getRightGapSize(BuildContext context) {
    if (rightGapWithIcon != null) {
      return rightGapWithIcon!;
    }
    switch (size) {
      case TLinkSize.large:
        return 8;
      case TLinkSize.small:
        return 6.63;
      case TLinkSize.medium:
        return 7;
    }
  }
}

/// 存储可以自定义TDLink跳转算法的控件
class TLinkConfiguration extends InheritedWidget {
  /// 统一跳转的函数
  final LinkClick? linkClick;

  const TLinkConfiguration({this.linkClick, Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant TLinkConfiguration oldWidget) {
    return linkClick != oldWidget.linkClick;
  }
}
