import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('Feedback ThemeExtension merge/copyWith/lerp contracts', () {
    final themes = <ThemeExtension<dynamic>>[
      const TDialogThemeData(width: 100, elevation: 2),
      const TDropdownThemeData(barHeight: 48, iconSize: 20),
      const TLoadingThemeData(duration: 1000),
      const TMessageThemeData(backgroundColor: Colors.black),
      const TNoticeBarThemeData(height: 40),
      const TPopoverThemeData(),
      const TPopupThemeData(panelRadius: 8),
      const TSwipeCellThemeData(duration: Duration(milliseconds: 200)),
      const TToastThemeData(maxWidth: 300),
    ];

    for (final theme in themes) {
      expect(theme.copyWith(), isA<ThemeExtension<dynamic>>());
      expect(theme.lerp(theme, 0.5), isA<ThemeExtension<dynamic>>());
    }

    expect(
      const TDialogThemeData(
        width: 10,
      ).merge(const TDialogThemeData(elevation: 3)).width,
      10,
    );
    expect(
      const TDropdownThemeData(
        barHeight: 10,
      ).merge(const TDropdownThemeData(barHeight: 20)).barHeight,
      20,
    );
    expect(
      const TLoadingThemeData(
        duration: 10,
      ).merge(const TLoadingThemeData(axis: Axis.horizontal)).duration,
      10,
    );
    expect(
      const TMessageThemeData(
        backgroundColor: Colors.black,
      ).merge(const TMessageThemeData(elevation: 2)).elevation,
      2,
    );
    expect(
      const TNoticeBarThemeData(
        height: 10,
      ).merge(const TNoticeBarThemeData(height: 20)).height,
      20,
    );
    expect(
      const TPopoverThemeData()
          .merge(const TPopoverThemeData(minWidth: 200))
          .minWidth,
      200,
    );
    expect(
      const TPopupThemeData(
        panelRadius: 8,
      ).merge(const TPopupThemeData(panelRadius: 12)).panelRadius,
      12,
    );
    expect(
      const TSwipeCellThemeData()
          .merge(const TSwipeCellThemeData(duration: Duration(seconds: 1)))
          .duration,
      const Duration(seconds: 1),
    );
    expect(
      const TToastThemeData(
        maxWidth: 10,
      ).merge(const TToastThemeData(maxWidth: 20)).maxWidth,
      20,
    );
  });
}
