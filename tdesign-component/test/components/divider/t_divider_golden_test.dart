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
    await (FontLoader(
      'Roboto',
    )..addFont(robotoFile.readAsBytes().then(ByteData.sublistView))).load();
  });

  for (final brightness in Brightness.values) {
    testWidgets('TDivider text alignment ${brightness.name} visual', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 180);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final token = TThemeData.defaultData();
      final baseTheme = brightness == Brightness.light
          ? TThemeBuilder.light(token)
          : TThemeBuilder.dark(token);
      final theme = baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
      );
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: const Key('divider-golden'),
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor,
                  child: const SizedBox(
                    width: 343,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TDivider(
                          align: TDividerAlign.left,
                          child: Text('Left'),
                        ),
                        SizedBox(height: 20),
                        TDivider(
                          align: TDividerAlign.center,
                          child: Text('Center'),
                        ),
                        SizedBox(height: 20),
                        TDivider(
                          align: TDividerAlign.right,
                          child: Text('Right'),
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

      await expectLater(
        find.byKey(const Key('divider-golden')),
        matchesGoldenFile('goldens/t_divider_${brightness.name}.png'),
      );
    });
  }
}
