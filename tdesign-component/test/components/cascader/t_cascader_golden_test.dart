import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  for (final brightness in Brightness.values) {
    testWidgets('TCascader ${brightness.name} visual', (tester) async {
      tester.view.physicalSize = const Size(375, 420);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final token = TThemeData.defaultData();
      final baseTheme = brightness == Brightness.light
          ? TThemeBuilder.light(token)
          : TThemeBuilder.dark(token);
      final theme = baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
        primaryTextTheme: baseTheme.primaryTextTheme.apply(
          fontFamily: 'Roboto',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: Key('cascader-golden'),
                child: SizedBox(
                  width: 343,
                  child: DefaultTextStyle(
                    style: TextStyle(fontFamily: 'Roboto'),
                    child: TCascader(
                      options: [
                        TCascaderOption(
                          label: 'Guangdong',
                          value: 'gd',
                          children: [
                            TCascaderOption(
                              label: 'Shenzhen',
                              value: 'sz',
                              children: [
                                TCascaderOption(label: 'Nanshan', value: 'ns'),
                                TCascaderOption(label: 'Futian', value: 'ft'),
                              ],
                            ),
                          ],
                        ),
                      ],
                      value: ['gd', 'sz', 'ns'],
                      onChanged: _ignore,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(const Key('cascader-golden')),
        matchesGoldenFile('goldens/t_cascader_${brightness.name}.png'),
      );
    });
  }
}

void _ignore(List<Object?> _) {}
