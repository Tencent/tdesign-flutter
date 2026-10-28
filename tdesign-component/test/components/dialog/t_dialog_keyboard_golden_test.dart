import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/component_golden_fonts.dart';

void main() {
  setUpAll(loadComponentGoldenFonts);

  for (final brightness in Brightness.values) {
    for (final landscape in [false, true]) {
      final direction = landscape ? 'landscape' : 'portrait';
      testWidgets('Dialog keyboard $direction ${brightness.name}', (
        tester,
      ) async {
        tester.view.physicalSize = landscape
            ? const Size(812, 375)
            : const Size(375, 812);
        tester.view.devicePixelRatio = 1;
        tester.view.padding = FakeViewPadding(top: landscape ? 46 : 24);
        final keyboardHeight = landscape ? 248.0 : 300.0;
        tester.view.viewInsets = FakeViewPadding(bottom: keyboardHeight);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPadding);
        addTearDown(tester.view.resetViewInsets);

        await tester.pumpWidget(
          RepaintBoundary(
            key: const ValueKey('keyboard-dialog'),
            child: MaterialApp(
              theme: componentGoldenTheme(brightness),
              builder: (context, child) => Stack(
                children: [
                  child!,
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: keyboardHeight,
                    child: Material(
                      color: brightness == Brightness.light
                          ? const Color(0xffdce1e9)
                          : const Color(0xff26282c),
                      child: const Center(child: Text('Keyboard')),
                    ),
                  ),
                ],
              ),
              home: Scaffold(
                body: Builder(
                  builder: (context) => TButton(
                    onPressed: () => TDialog.show<void>(
                      context,
                      dialog: const TDialog(
                        title: Text('Keyboard dialog'),
                        content: TInput(hintText: 'Input'),
                        actions: [
                          TDialogAction(child: Text('Cancel')),
                          TDialogAction(
                            child: Text('Confirm'),
                            role: TDialogActionRole.primary,
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Open'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        if (landscape) {
          await tester.ensureVisible(find.text('Confirm'));
          await tester.pumpAndSettle();
        }
        await expectLater(
          find.byKey(const ValueKey('keyboard-dialog')),
          matchesGoldenFile(
            'goldens/t_dialog_keyboard_${direction}_${brightness.name}.png',
          ),
        );
      });
    }
  }
}
