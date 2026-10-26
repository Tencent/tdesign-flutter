import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Future<void> loadComponentGoldenFonts() async {
  final flutterBin = File(
    Platform.resolvedExecutable,
  ).parent.parent.parent.parent.parent;
  await Future.wait([
    (FontLoader('Roboto')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load(),
    (FontLoader('packages/tdesign_flutter_icons/TIcons')..addFont(
          rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'),
        ))
        .load(),
    for (final name in ['TDesignGoldenCJK', 'TDesignAlignmentCJK'])
      (FontLoader(name)..addFont(
            File(
              'example/test/fonts/$name-Regular.otf',
            ).readAsBytes().then(ByteData.sublistView),
          ))
          .load(),
  ]);
}

ThemeData componentGoldenTheme(Brightness brightness) {
  final base = TThemeData.defaultData();
  final theme = brightness == Brightness.light
      ? TThemeBuilder.light(base)
      : TThemeBuilder.dark(base);
  const fallback = ['TDesignGoldenCJK', 'TDesignAlignmentCJK'];
  final token = theme.extension<TThemeData>()!;
  return theme
      .mergeExtension(
        token.copyWith(
          fontFamilyMap: {
            // TD-owned text resolves its font from tokens, not Material textTheme.
            'fontFamily': FontFamily(fontFamily: 'Roboto', fallback: fallback),
          },
        ),
      )
      .copyWith(
        textTheme: theme.textTheme.apply(
          fontFamily: 'Roboto',
          fontFamilyFallback: fallback,
        ),
        primaryTextTheme: theme.primaryTextTheme.apply(
          fontFamily: 'Roboto',
          fontFamilyFallback: fallback,
        ),
      );
}
