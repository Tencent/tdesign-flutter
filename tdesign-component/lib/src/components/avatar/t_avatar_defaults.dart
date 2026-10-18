import 'package:flutter/material.dart';

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

  static double dimensionFor(TAvatarSize size) => switch (size) {
    TAvatarSize.large => 64,
    TAvatarSize.medium => mediumDimension,
    TAvatarSize.small => 40,
  };

  static double iconSizeFor(TAvatarSize size) => switch (size) {
    TAvatarSize.large => 32,
    TAvatarSize.medium => 24,
    TAvatarSize.small => 20,
  };

  static double fontSizeFor(TAvatarSize size) => switch (size) {
    TAvatarSize.large => 20,
    TAvatarSize.medium => 16,
    TAvatarSize.small => 14,
  };

  static TextStyle textStyleFor(TAvatarSize size) => TextStyle(
    fontSize: fontSizeFor(size),
    height: 1,
    fontWeight: FontWeight.w600,
  );
}
