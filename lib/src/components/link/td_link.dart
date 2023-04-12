import 'package:flutter/material.dart';

import '../../../td_export.dart';

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
    this.prefixIcon,
    this.suffixIcon,
    this.followLink,
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

  /// link label to display
  final String label;

  /// link type
  final TDLinkType type;

  /// link style
  final TDLinkStyle style;

  /// link state
  final TDLinkState state;

  /// link size
  final TDLinkSize size;

  /// prefix icon
  final Icon? prefixIcon;

  /// suffix icon
  final Icon? suffixIcon;

  /// link label color, calculated by state and style if not set
  final Color? color;

  /// link icon size, calculated by state and style if not set
  final double? iconSize;

  /// link font size, calculated by state and style if not set
  final double? fontSize;

  /// gap between icon and text, calculated by state and style if not set
  final double? leftGapWithIcon;

  /// gap between icon and text, calculated by state and style if not set
  final double? rightGapWithIcon;

  /// action when the link clicked
  final Function? followLink;

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
        }
        return TDTheme.of(context).fontGyColor1;

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
        }
        return TDTheme.of(context).brandClickColor;
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
        }
    }
    return TDTheme.of(context).fontGyColor4;
  }

  Icon _getDefaultIcon(BuildContext context) {
    return Icon(
      TDIcons.link,
      size: _getIconSize(context),
      color: getColor(context),
    );
  }

  _buildLink(BuildContext context) {
    return InkWell(
        onTap: () {
          if (state == TDLinkState.disabled || followLink == null) {
            return;
          }
          followLink!();
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: _getFontSize(context),
            color: getColor(context),
            decoration: type == TDLinkType.withUnderline
                ? TextDecoration.underline
                : null,
          ),
        ));
  }

  double _getIconSize(BuildContext context) {
    if (iconSize != null) {
      return iconSize!;
    }
    switch (size) {
      case TDLinkSize.large:
        return 11.99;
      case TDLinkSize.small:
        return 9.32;
    }
    return 10.66;
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
    }
    return 14;
  }

  _getLeftGapSize(BuildContext context) {
    if (leftGapWithIcon != null) {
      return leftGapWithIcon!;
    }
    switch (size) {
      case TDLinkSize.large:
        return 14.64;
      case TDLinkSize.small:
        return 6.05;
    }
    return 6.34;
  }

  _getRightGapSize(BuildContext context) {
    if (rightGapWithIcon != null) {
      return rightGapWithIcon!;
    }
    switch (size) {
      case TDLinkSize.large:
        return 15.37;
      case TDLinkSize.small:
        return 6.63;
    }
    return 7;
  }
}
