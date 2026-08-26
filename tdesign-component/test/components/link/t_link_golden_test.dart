import 'dart:io';

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
    testWidgets('TLink official types ${brightness.name} visual', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 260);
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
                key: const Key('link-golden'),
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor,
                  child: SizedBox(
                    width: 343,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _row(theme, const [
                          TLink(
                            child: Text('Link'),
                            colorScheme: TLinkColorScheme.primary,
                            size: TLinkSize.small,
                            onPressed: _noop,
                          ),
                          TLink(
                            child: Text('Link'),
                            size: TLinkSize.small,
                            onPressed: _noop,
                          ),
                        ]),
                        const SizedBox(height: 8),
                        _row(theme, const [
                          TLink(
                            child: Text('Link'),
                            colorScheme: TLinkColorScheme.primary,
                            size: TLinkSize.small,
                            underline: true,
                            onPressed: _noop,
                          ),
                          TLink(
                            child: Text('Link'),
                            size: TLinkSize.small,
                            underline: true,
                            onPressed: _noop,
                          ),
                        ]),
                        const SizedBox(height: 8),
                        _row(theme, const [
                          TLink(
                            child: Text('Link'),
                            colorScheme: TLinkColorScheme.primary,
                            size: TLinkSize.small,
                            prefixIcon: Icon(TIcons.link),
                            onPressed: _noop,
                          ),
                          TLink(
                            child: Text('Link'),
                            size: TLinkSize.small,
                            suffixIcon: Icon(TIcons.jump),
                            onPressed: _noop,
                          ),
                        ]),
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
        find.byKey(const Key('link-golden')),
        matchesGoldenFile('goldens/t_link_${brightness.name}.png'),
      );
    });
  }
}

Widget _row(ThemeData theme, List<Widget> children) {
  return ColoredBox(
    color: theme.colorScheme.surface,
    child: SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    ),
  );
}

void _noop() {}
