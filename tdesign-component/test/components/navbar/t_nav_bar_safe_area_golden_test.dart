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
    testWidgets('Navbar ${brightness.name} 默认与显式安全区视觉快照', (tester) async {
      tester.view.physicalSize = const Size(375, 120);
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
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(375, 120),
              padding: EdgeInsets.only(top: 24),
            ),
            child: Scaffold(
              body: Builder(
                builder: (context) => RepaintBoundary(
                  key: const Key('navbar-safe-area-scene'),
                  child: Column(
                    children: [
                      TNavBar(
                        title: 'Embedded default',
                        backgroundColor: context.tTheme.bgColorContainer,
                      ),
                      TNavBar(
                        title: 'Top-level opt-in',
                        useSafeArea: true,
                        backgroundColor:
                            context.tTheme.bgColorSecondaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await expectLater(
        find.byKey(const Key('navbar-safe-area-scene')),
        matchesGoldenFile('goldens/t_nav_bar_safe_area_${brightness.name}.png'),
      );
    });
  }
}
