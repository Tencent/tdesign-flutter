import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 限制Function类型，防止传递错误的Function，导致参数对不上
typedef LinkClick = Function(Uri? uri);

enum TDLinkType {
  basic,
  withUnderline,
  withPrefixIcon,
  withSuffixIcon,
}

enum TDLinkStyle {
  primary,
  defaultStyle,
  danger,
  warning,
  success,
}

enum TDLinkState {
  normal,
  active,
  disabled,
}

enum TDLinkSize {
  small,
  medium,
  large,
}

class TDLink extends StatelessWidget {
  const TDLink({
    Key? key,
    required this.label,
    this.uri,
    this.prefixIcon,
    this.suffixIcon,
    this.linkClick,
    this.type = TDLinkType.basic,
    this.style = TDLinkStyle.defaultStyle,
    this.state = TDLinkState.normal,
    this.size = TDLinkSize.medium,
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
  final TDLinkType type;

  /// link 风格
  final TDLinkStyle style;

  /// link 状态
  final TDLinkState state;

  /// link 大小
  final TDLinkSize size;

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
    if (type == TDLinkType.withPrefixIcon) {
      return Row(children: [
        prefixIcon == null ? _getDefaultIcon(context) : prefixIcon!,
        SizedBox(
          width: _getLeftGapSize(context),
        ),
        _buildLink(context),
      ]);
    } else if (type == TDLinkType.withSuffixIcon) {
      return Row(children: [
        _buildLink(context),
        SizedBox(
          width: _getRightGapSize(context),
        ),
        suffixIcon == null ? _getDefaultIcon(context) : suffixIcon!,
      ]);
    }

    return _buildLink(context);
  }

  /// 提取成方法，允许业务定义自己的TDLinkConfiguration
  TDLinkConfiguration? getConfiguration(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDLinkConfiguration>();
  }

  Color getColor(BuildContext context) {
    if (color != null) {
      return color!;
    }
    // to refactor: use map instead of multi level switch
    switch (state) {
      case TDLinkState.normal:
        switch (style) {
          case TDLinkStyle.primary:
            return TDTheme.of(context).brandNormalColor;
          case TDLinkStyle.danger:
            return TDTheme.of(context).errorColor6;
          case TDLinkStyle.warning:
            return TDTheme.of(context).warningColor5;
          case TDLinkStyle.success:
            return TDTheme.of(context).successColor5;
          case TDLinkStyle.defaultStyle:
            return TDTheme.of(context).fontGyColor1;
        }

      case TDLinkState.active:
        switch (style) {
          case TDLinkStyle.primary:
            return TDTheme.of(context).brandClickColor;
          case TDLinkStyle.danger:
            return TDTheme.of(context).errorColor7;
          case TDLinkStyle.warning:
            return TDTheme.of(context).warningColor6;
          case TDLinkStyle.success:
            return TDTheme.of(context).successColor6;
          case TDLinkStyle.defaultStyle:
            return TDTheme.of(context).brandClickColor;
        }
      case TDLinkState.disabled:
        switch (style) {
          case TDLinkStyle.primary:
            return TDTheme.of(context).brandDisabledColor;
          case TDLinkStyle.danger:
            return TDTheme.of(context).errorDisabledColor;
          case TDLinkStyle.warning:
            return TDTheme.of(context).warningDisabledColor;
          case TDLinkStyle.success:
            return TDTheme.of(context).successDisabledColor;
          case TDLinkStyle.defaultStyle:
            return TDTheme.of(context).fontGyColor4;
        }
    }
  }

  Widget _getDefaultIcon(BuildContext context) {
    return Icon(
      type == TDLinkType.withPrefixIcon ? TDIcons.link : TDIcons.jump,
      size: _getIconSize(context),
      color: getColor(context),
    );
  }

  Widget _buildLink(BuildContext context) {
    return InkWell(
        onTap: () {
          if (state == TDLinkState.disabled) {
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
        child: TDText(
          label,
          style: TextStyle(
            fontSize: _getFontSize(context),
            color: getColor(context),
            decoration: type == TDLinkType.withUnderline
                ? TextDecoration.underline
                : null,
          ),
          forceVerticalCenter: true,
        ));
  }

  double _getIconSize(BuildContext context) {
    if (iconSize != null) {
      return iconSize!;
    }
    switch (size) {
      case TDLinkSize.large:
        return 18;
      case TDLinkSize.small:
        return 14;
      case TDLinkSize.medium:
        return 16;
    }
  }

  double _getFontSize(BuildContext context) {
    if (fontSize != null) {
      return fontSize!;
    }
    switch (size) {
      case TDLinkSize.large:
        return 16;
      case TDLinkSize.small:
        return 12;
      case TDLinkSize.medium:
        return 14;
    }
  }

  double _getLeftGapSize(BuildContext context) {
    if (leftGapWithIcon != null) {
      return leftGapWithIcon!;
    }
    switch (size) {
      case TDLinkSize.large:
        return 14.64;
      case TDLinkSize.small:
        return 6.05;
      case TDLinkSize.medium:
        return 6.34;
    }
  }

  double _getRightGapSize(BuildContext context) {
    if (rightGapWithIcon != null) {
      return rightGapWithIcon!;
    }
    switch (size) {
      case TDLinkSize.large:
        return 15.37;
      case TDLinkSize.small:
        return 6.63;
      case TDLinkSize.medium:
        return 7;
    }
  }
}

/// 存储可以自定义TDLink跳转算法的控件
class TDLinkConfiguration extends InheritedWidget {
  /// 统一跳转的函数
  final LinkClick? linkClick;

  const TDLinkConfiguration({this.linkClick, Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant TDLinkConfiguration oldWidget) {
    return linkClick != oldWidget.linkClick;
  }
}
