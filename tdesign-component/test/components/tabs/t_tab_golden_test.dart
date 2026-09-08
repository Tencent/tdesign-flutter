import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await robotoFont.load();
  });

  for (final brightness in Brightness.values) {
    testWidgets('TTabsBar visual variants ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(420, 260);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_TabsScene(brightness: brightness));

      await expectLater(
        find.byKey(const Key('tabs-scene')),
        matchesGoldenFile('goldens/t_tabs_variants_${brightness.name}.png'),
      );
    });
  }
}

class _TabsScene extends StatelessWidget {
  const _TabsScene({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: 'Roboto'),
      badgeTheme: baseTheme.badgeTheme.copyWith(
        textStyle: baseTheme.badgeTheme.textStyle?.copyWith(
          fontFamily: 'Roboto',
        ),
      ),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('tabs-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultTabController(
                      length: 3,
                      child: TTabsBar(
                        tabs: [
                          TTab(text: 'News'),
                          TTab(
                            child: TBadge(label: '8', child: Text('Inbox')),
                          ),
                          TTab(
                            text: 'Disabled',
                            icon: Icon(Icons.block),
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    DefaultTabController(
                      length: 3,
                      child: TTabsBar(
                        variant: TTabsBarVariant.tag,
                        tabs: [
                          TTab(text: 'First'),
                          TTab(text: 'Second'),
                          TTab(text: 'Third'),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    DefaultTabController(
                      length: 3,
                      child: TTabsBar(
                        variant: TTabsBarVariant.card,
                        tabs: [
                          TTab(text: 'First'),
                          TTab(text: 'Second'),
                          TTab(text: 'Third'),
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
  }
}
