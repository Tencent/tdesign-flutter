import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/component_golden_fonts.dart';

void main() {
  setUpAll(loadComponentGoldenFonts);

  for (final brightness in Brightness.values) {
    testWidgets('BackTop 8-state matrix ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(420, 260);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final theme = componentGoldenTheme(brightness);
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
    (TBackTopColorPreset.light, false),
    (TBackTopColorPreset.dark, false),
    (TBackTopColorPreset.light, true),
    (TBackTopColorPreset.dark, true),
  ]) ...[
    TBackTop(
      shape: shape,
      colorPreset: state.$1,
      showText: state.$2,
      onPressed: _noop,
    ),
    if (state != const (TBackTopColorPreset.dark, true))
      const SizedBox(width: 16),
  ],
];

void _noop() {}
