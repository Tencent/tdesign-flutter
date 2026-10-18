import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/component_golden_fonts.dart';

void main() {
  setUpAll(loadComponentGoldenFonts);

  for (final brightness in Brightness.values) {
    for (final selected in [false, true]) {
      final state = selected ? 'selected' : 'initial';
      testWidgets(
        'Tabs tag default padding ${brightness.name} $state golden',
        (tester) async {
          tester.view.physicalSize = const Size(375, 180);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final theme = componentGoldenTheme(brightness);
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: const Scaffold(
                body: Center(
                  child: RepaintBoundary(
                    key: Key('tabs-tag-default-padding'),
                    child: DefaultTabController(
                      length: 3,
                      // Natural widths expose inner padding, which is absorbed
                      // by equal-width tags in the existing Demo matrix.
                      child: TTabsBar(
                        variant: TTabsBarVariant.tag,
                        isScrollable: true,
                        tabs: [
                          TTab(text: 'Short'),
                          TTab(text: 'Long label'),
                          TTab(text: 'Disabled', enabled: false),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          if (selected) {
            await tester.tap(find.text('Long label'));
            await tester.pumpAndSettle();
          }
          await expectLater(
            find.byKey(const Key('tabs-tag-default-padding')),
            matchesGoldenFile(
              'goldens/tabs_tag_default_padding_${brightness.name}_$state.png',
            ),
          );
        },
        tags: 'golden',
      );
    }
  }
}
