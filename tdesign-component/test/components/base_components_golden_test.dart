import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  for (final brightness in Brightness.values) {
    testWidgets('base components ${brightness.name} visual matrix',
        (tester) async {
      tester.view.physicalSize = const Size(440, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_BaseComponentsScene(brightness: brightness));

      await expectLater(
        find.byKey(const Key('base-components-scene')),
        matchesGoldenFile(
          'goldens/base_components_${brightness.name}.png',
        ),
      );
    });
  }
}

class _BaseComponentsScene extends StatelessWidget {
  const _BaseComponentsScene({required this.brightness});

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
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('base-components-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const SizedBox(
                width: 400,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel('Button'),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          TButton(
                            child: Text('Primary'),
                            onPressed: _noop,
                          ),
                          TButton(
                            variant: TButtonVariant.outline,
                            child: Text('Outline'),
                            onPressed: _noop,
                          ),
                          TButton(
                            child: Text('Disabled'),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _SectionLabel('Text and Icon'),
                      Row(
                        children: [
                          TText('Body text'),
                          SizedBox(width: 16),
                          TText(
                            'Brand text',
                            textColor: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                          Spacer(),
                          TIcon(TIcons.home),
                          SizedBox(width: 12),
                          TIcon(TIcons.search, size: 28),
                        ],
                      ),
                      SizedBox(height: 24),
                      _SectionLabel('Link'),
                      Row(
                        children: [
                          TLink(
                            child: Text('Basic link'),
                            onPressed: _noop,
                          ),
                          SizedBox(width: 24),
                          TLink(
                            underline: true,
                            child: Text('Underline'),
                            onPressed: _noop,
                          ),
                          SizedBox(width: 24),
                          TLink(child: Text('Disabled')),
                        ],
                      ),
                      SizedBox(height: 24),
                      _SectionLabel('Divider'),
                      TDivider(),
                      SizedBox(height: 12),
                      TDivider(
                        dashed: true,
                        child: Text('Divider label'),
                      ),
                      SizedBox(height: 24),
                      _SectionLabel('Fab'),
                      SizedBox(
                        height: 96,
                        child: Stack(
                          children: [
                            TFab(
                              right: 296,
                              bottom: 16,
                              icon: TIcon(TIcons.add),
                              onPressed: _noop,
                            ),
                            TFab(
                              right: 128,
                              bottom: 16,
                              text: 'Create',
                              icon: TIcon(TIcons.add),
                              onPressed: _noop,
                            ),
                            TFab(
                              right: 16,
                              bottom: 16,
                              icon: TIcon(TIcons.add),
                            ),
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
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

void _noop() {}
