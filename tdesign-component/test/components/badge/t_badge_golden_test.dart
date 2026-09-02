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
    testWidgets('TBadge ${brightness.name} visual matrix', (tester) async {
      tester.view.physicalSize = const Size(420, 620);
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
      // Golden 为固定字体而复制 BadgeTheme；复制后属于显式主题，因此同时锁定
      // TDesign Dot 的 8px 视觉。默认回退路径由 t_badge_test.dart 单独覆盖。
      badgeTheme: baseTheme.badgeTheme.copyWith(
        smallSize: 8,
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
            key: const Key('badge-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const SizedBox(
                width: 380,
                height: 540,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _VariantRow(
                        name: 'normal',
                        badge: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TBadge(label: '8'),
                            SizedBox(width: 12),
                            TBadge(label: '99+'),
                          ],
                        ),
                      ),
                      _VariantRow(
                        name: 'dot',
                        badge: TBadge(variant: TBadgeVariant.dot),
                      ),
                      _VariantRow(
                        name: 'square',
                        badge: TBadge(
                          label: '8',
                          variant: TBadgeVariant.square,
                        ),
                      ),
                      _VariantRow(
                        name: 'bubble',
                        badge: TBadge(
                          label: 'NEW',
                          variant: TBadgeVariant.bubble,
                        ),
                      ),
                      _VariantRow(
                        name: 'ribbonLeft',
                        badge: TBadge(
                          label: 'NEW',
                          variant: TBadgeVariant.ribbonLeft,
                          child: _BadgeTarget(label: 'A'),
                        ),
                      ),
                      _VariantRow(
                        name: 'ribbonRight',
                        badge: TBadge(
                          label: 'NEW',
                          variant: TBadgeVariant.ribbonRight,
                          child: _BadgeTarget(label: 'B'),
                        ),
                      ),
                      _VariantRow(
                        name: 'triangleLeft',
                        badge: TBadge(
                          label: 'NEW',
                          variant: TBadgeVariant.triangleLeft,
                          child: _BadgeTarget(label: 'C'),
                        ),
                      ),
                      _VariantRow(
                        name: 'triangleRight',
                        badge: TBadge(
                          label: 'NEW',
                          variant: TBadgeVariant.triangleRight,
                          child: _BadgeTarget(label: 'D'),
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

class _VariantRow extends StatelessWidget {
  const _VariantRow({required this.name, required this.badge});

  final String name;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(name, style: const TextStyle(fontFamily: 'Roboto')),
          ),
          Expanded(child: Center(child: badge)),
        ],
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
