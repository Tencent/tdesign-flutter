import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/component_golden_fonts.dart';

void main() {
  setUpAll(loadComponentGoldenFonts);

  for (final brightness in Brightness.values) {
    for (final selected in [false, true]) {
      final state = selected ? 'selected' : 'initial';
      testWidgets('Tabs tag default padding ${brightness.name} $state golden', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(375, 180);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final theme = componentGoldenTheme(brightness);
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: RepaintBoundary(
                key: const Key('tabs-tag-default-padding'),
                child: ColoredBox(
                  color: theme.colorScheme.surfaceContainerLow,
                  child: const DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Scrollable labels keep their natural widths so the
                        // snapshot also shows the padding inside each pill.
                        TTabsBar(
                          variant: TTabsBarVariant.tag,
                          isScrollable: true,
                          tabs: [
                            TTab(text: 'Short'),
                            TTab(text: 'Long label'),
                            TTab(text: 'Disabled', enabled: false),
                          ],
                        ),
                        Expanded(
                          child: TTabsBarView(
                            children: [
                              _TabContent(
                                title: 'Overview',
                                description: '3 recent items',
                              ),
                              _TabContent(
                                title: 'Activity',
                                description: '1 item updated today',
                              ),
                              _TabContent(title: 'Unavailable'),
                            ],
                          ),
                        ),
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
      }, tags: 'golden');
    }
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleMedium),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(description!, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
