import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/component_golden_fonts.dart';

void main() {
  setUpAll(loadComponentGoldenFonts);

  for (final brightness in Brightness.values) {
    testWidgets('Cell card default radius ${brightness.name} golden', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final theme = componentGoldenTheme(brightness);
      final token = theme.extension<TThemeData>()!;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: const Key('cell-card-default-radius'),
                child: ColoredBox(
                  color: token.bgColorSecondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TCellGroup(
                          variant: TCellGroupVariant.card,
                          cells: [TCell(title: Text('Default card'))],
                        ),
                        const SizedBox(height: 16),
                        // The supported border exposes the default corner geometry;
                        // cardBorderRadius and cardPadding remain unspecified.
                        Theme(
                          data: theme.mergeExtension(
                            const TCellThemeData(groupBordered: true),
                          ),
                          child: const TCellGroup(
                            variant: TCellGroupVariant.card,
                            cells: [TCell(title: Text('Bordered card'))],
                          ),
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
        find.byKey(const Key('cell-card-default-radius')),
        matchesGoldenFile(
          'goldens/cell_card_default_radius_${brightness.name}.png',
        ),
      );
    }, tags: 'golden');
  }
}
