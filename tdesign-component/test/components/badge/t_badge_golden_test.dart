import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await robotoFont.load();
  });

  for (final brightness in Brightness.values) {
    testWidgets('TBadge ${brightness.name} visual matrix', (tester) async {
      tester.view.physicalSize = const Size(360, 220);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_BadgeScene(brightness: brightness));

      await expectLater(
        find.byKey(const Key('badge-scene')),
        matchesGoldenFile('goldens/t_badge_${brightness.name}.png'),
      );
    });
  }
}

class _BadgeScene extends StatelessWidget {
  const _BadgeScene({required this.brightness});

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
        textStyle:
            baseTheme.badgeTheme.textStyle?.copyWith(fontFamily: 'Roboto'),
      ),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('badge-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const SizedBox(
                width: 320,
                height: 180,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TBadge(label: '8'),
                          SizedBox(width: 24),
                          TBadge(label: '99+'),
                          SizedBox(width: 24),
                          TBadge(label: '8', variant: TBadgeVariant.small),
                          SizedBox(width: 24),
                          TBadge(variant: TBadgeVariant.dot),
                          SizedBox(width: 24),
                          TBadge(label: '8', border: true),
                        ],
                      ),
                      SizedBox(height: 32),
                      Row(
                        children: [
                          TBadge(
                            label: '8',
                            child: _BadgeTarget(label: 'A'),
                          ),
                          SizedBox(width: 32),
                          TBadge(
                            variant: TBadgeVariant.dot,
                            child: _BadgeTarget(label: 'B'),
                          ),
                          SizedBox(width: 32),
                          TBadge(
                            label: '0',
                            showZero: false,
                            child: _BadgeTarget(label: 'C'),
                          ),
                          SizedBox(width: 32),
                          BadgeTheme(
                            data: BadgeThemeData(
                              alignment: AlignmentDirectional.bottomStart,
                              offset: Offset(2, 2),
                            ),
                            child: TBadge(
                              label: '8',
                              child: _BadgeTarget(label: 'D'),
                            ),
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
      ),
    );
  }
}

class _BadgeTarget extends StatelessWidget {
  const _BadgeTarget({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.tTheme.bgColorComponent,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
      child: Text(label),
    );
  }
}
