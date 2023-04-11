import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

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
    required this.uri,
    this.prefixIcon,
    this.suffixIcon,
    this.type = TDLinkType.basic,
    this.style = TDLinkStyle.defaultStyle,
    this.state = TDLinkState.normal,
    this.size = TDLinkSize.medium,
  }) : super(key: key);

  final String label;
  final Uri uri;
  final TDLinkType type;
  final TDLinkStyle style;
  final TDLinkState state;
  final TDLinkSize size;
  final Icon? prefixIcon;
  final Icon? suffixIcon;

  @override
  Widget build(BuildContext context) {
    if (type == TDLinkType.withPrefixIcon) {
      return Row(children: [
        prefixIcon == null ? _getDefaultIcon(context) : prefixIcon!,
        _buildLink(context),
      ]);
    } else if (type == TDLinkType.withSuffixIcon) {
      return Row(children: [
        _buildLink(context),
        suffixIcon == null ? _getDefaultIcon(context) : suffixIcon!,
      ]);
    }

    return _buildLink(context);
  }

  Color getColor(BuildContext context) {
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
  }

  Icon _getDefaultIcon(BuildContext context) {
    return Icon(
      TDIcons.link,
      size: _getSize(context),
      color: getColor(context),
    );
  }

  Text _buildLink(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: _getFontSize(context),
        color: getColor(context),
        decoration:
            type == TDLinkType.withUnderline ? TextDecoration.underline : null,
      ),
    );
  }

  double _getSize(BuildContext context) {
    switch (size) {
      case TDLinkSize.large:
        return 11.99;
      case TDLinkSize.small:
        return 9.32;
    }
    return 10.66;
  }

  double _getFontSize(BuildContext context) {
    switch (size) {
      case TDLinkSize.large:
        return 16;
      case TDLinkSize.small:
        return 12;
    }
    return 14;
  }
}
