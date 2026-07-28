import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_icons/fonts/t.ttf'));
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(
        robotoFile.readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  Widget scene({required Brightness brightness}) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    final theme = baseTheme.mergeExtension(
      const TStepperThemeData(
        textStyle: TextStyle(
          fontFamily: 'Roboto',
        ),
      ),
    );
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('stepper-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TStepper(
                          value: 2,
                          variant: TStepperVariant.normal,
                          onChanged: _noop,
                        ),
                        SizedBox(width: 12),
                        TStepper(
                          value: 3,
                          variant: TStepperVariant.filled,
                          onChanged: _noop,
                        ),
                        SizedBox(width: 12),
                        TStepper(
                          value: 4,
                          variant: TStepperVariant.outline,
                          onChanged: _noop,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TStepper(
                          value: 1,
                          size: TStepperSize.small,
                          variant: TStepperVariant.filled,
                          onChanged: _noop,
                        ),
                        SizedBox(width: 12),
                        TStepper(
                          value: 2,
                          size: TStepperSize.medium,
                          variant: TStepperVariant.filled,
                          onChanged: _noop,
                        ),
                        SizedBox(width: 12),
                        TStepper(
                          value: 3,
                          size: TStepperSize.large,
                          variant: TStepperVariant.filled,
                          onChanged: _noop,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TStepper(
                          value: 0,
                          min: 0,
                          variant: TStepperVariant.filled,
                          onChanged: _noop,
                        ),
                        SizedBox(width: 12),
                        TStepper(
                          value: 10,
                          max: 10,
                          variant: TStepperVariant.outline,
                          onChanged: _noop,
                        ),
                        SizedBox(width: 12),
                        TStepper(
                          value: 5,
                          variant: TStepperVariant.filled,
                        ),
                      ],
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

  for (final brightness in Brightness.values) {
    testWidgets('TStepper ${brightness.name} golden', (tester) async {
      await tester.pumpWidget(scene(brightness: brightness));
      await expectLater(
        find.byKey(const Key('stepper-scene')),
        matchesGoldenFile('goldens/t_stepper_${brightness.name}.png'),
      );
    });
  }
}

void _noop(num _) {}
