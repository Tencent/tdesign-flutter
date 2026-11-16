import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_list.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/component_golden_fonts.dart';

void main() {
  setUpAll(loadComponentGoldenFonts);

  for (final brightness in Brightness.values) {
    testWidgets('ActionSheet without cancel safe area ${brightness.name}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 250);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(bottom: 34);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('action-sheet-safe-area'),
          child: MaterialApp(
            theme: componentGoldenTheme(brightness),
            home: const Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: TActionSheetList(
                  showCancel: false,
                  items: [
                    TActionSheetItem(value: 1, label: 'First action'),
                    TActionSheetItem(value: 2, label: 'Second action'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const ValueKey('action-sheet-safe-area')),
        matchesGoldenFile(
          'goldens/t_action_sheet_safe_area_${brightness.name}.png',
        ),
      );
    });
  }
}
