import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    await (FontLoader('packages/tdesign_flutter_icons/TIcons')..addFont(
          rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'),
        ))
        .load();
  });

  for (final brightness in Brightness.values) {
    testWidgets('TIcon ${brightness.name} size and color matrix', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(240, 120);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final token = TThemeData.defaultData();
      final theme = brightness == Brightness.light
          ? TThemeBuilder.light(token)
          : TThemeBuilder.dark(token);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: const Key('icon-golden'),
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor,
                  child: SizedBox(
                    width: 208,
                    height: 88,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const TIcon(TIcons.home, size: 16),
                        const TIcon(TIcons.setting, size: 24),
                        TIcon(
                          TIcons.heart_filled,
                          size: 32,
                          color: theme
                              .extension<TThemeData>()
                              ?.errorNormalColor,
                        ),
                        Theme(
                          data: theme.mergeExtension(
                            const TIconThemeData(size: 24, color: Colors.blue),
                          ),
                          child: const TIcon(TIcons.star_filled),
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
        find.byKey(const Key('icon-golden')),
        matchesGoldenFile('goldens/t_icon_${brightness.name}.png'),
      );
    });
  }
}
