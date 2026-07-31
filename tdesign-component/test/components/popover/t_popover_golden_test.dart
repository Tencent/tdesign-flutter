import 'dart:async';
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
    testWidgets('TPopover ${brightness.name} overlay visual', (tester) async {
      tester.view.physicalSize = const Size(375, 240);
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
      late BuildContext anchorContext;
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  anchorContext = context;
                  return Container(
                    width: 96,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: anchorContext,
          content: 'Popover content',
          colorScheme: TPopoverColorScheme.info,
          placement: TPopoverPlacement.top,
        ),
      );
      await tester.pump();

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/t_popover_${brightness.name}.png'),
      );
    });
  }
}
