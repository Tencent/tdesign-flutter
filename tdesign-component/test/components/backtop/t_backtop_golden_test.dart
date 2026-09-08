import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final cjkFont = FontLoader('TDesign Alignment CJK')
      ..addFont(
        File(
          'example/test/fonts/TDesignAlignmentCJK-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([iconFont.load(), cjkFont.load()]);
  });

  for (final brightness in Brightness.values) {
    testWidgets('BackTop 8-state matrix ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(420, 260);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final token = TThemeData.defaultData();
      final baseTheme = brightness == Brightness.light
          ? TThemeBuilder.light(token)
          : TThemeBuilder.dark(token);
      final theme = baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(
          fontFamilyFallback: const ['TDesign Alignment CJK'],
        ),
        primaryTextTheme: baseTheme.primaryTextTheme.apply(
          fontFamilyFallback: const ['TDesign Alignment CJK'],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: const Key('backtop-state-matrix'),
                child: ColoredBox(
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: _states(TBackTopShape.circle),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: _states(TBackTopShape.halfCircle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const Key('backtop-state-matrix')),
        matchesGoldenFile(
          'goldens/backtop_state_matrix_${brightness.name}.png',
        ),
      );
    }, tags: 'golden');
  }
}

List<Widget> _states(TBackTopShape shape) => [
  for (final state in const [
    (TBackTopColorScheme.light, false),
    (TBackTopColorScheme.dark, false),
    (TBackTopColorScheme.light, true),
    (TBackTopColorScheme.dark, true),
  ]) ...[
    TBackTop(
      shape: shape,
      colorScheme: state.$1,
      showText: state.$2,
      onPressed: _noop,
    ),
    if (state != const (TBackTopColorScheme.dark, true))
      const SizedBox(width: 16),
  ],
];

void _noop() {}
