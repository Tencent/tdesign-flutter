import 'package:flutter/material.dart';

import '../../theme/t_fonts.dart';
import '../../theme/t_sizes.dart';
import '../../theme/t_theme.dart';
import 't_avatar_types.dart';

abstract final class TAvatarDefaults {
  static const mediumDimension = 48.0;
  static const squareBorderRadius = 6.0;
  static const groupSpacing = 8.0;
  static const groupBorderWidth = 2.0;
  static const groupShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.15),
    offset: Offset(1, 0),
    blurRadius: 2,
  );

  static double groupBorderWidthFor(TAvatarSize size) => switch (size) {
    TAvatarSize.small => 1,
    TAvatarSize.medium => 2,
    TAvatarSize.large => 3,
  };

  static double dimensionFor(TAvatarSize size, {TThemeData? token}) =>
      switch (size) {
        TAvatarSize.large => token?.size15 ?? 64,
        TAvatarSize.medium => token?.size13 ?? mediumDimension,
        TAvatarSize.small => token?.size12 ?? 40,
      };

  static double iconSizeFor(TAvatarSize size, {TThemeData? token}) =>
      switch (size) {
        TAvatarSize.large => token?.size10 ?? 32,
        TAvatarSize.medium => token?.size8 ?? 24,
        TAvatarSize.small => 20,
      };

  static double fontSizeFor(TAvatarSize size, {TThemeData? token}) =>
      switch (size) {
        TAvatarSize.large => 20,
        TAvatarSize.medium => token?.fontTitleMedium?.size ?? 16,
        TAvatarSize.small => token?.fontTitleSmall?.size ?? 14,
      };

  static TextStyle textStyleFor(TAvatarSize size, {TThemeData? token}) {
    final weight = switch (size) {
      TAvatarSize.large => null,
      TAvatarSize.medium => token?.fontTitleMedium?.fontWeight,
      TAvatarSize.small => token?.fontTitleSmall?.fontWeight,
    };
    return TextStyle(
      fontSize: fontSizeFor(size, token: token),
      height: 1,
      fontWeight: weight ?? FontWeight.w600,
    );
  }
}
