import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../tool/convert_theme.dart';

const _customCss = '''
:root, :root[theme-mode="light"] {
 --td-brand-color: #123456;
 --td-font-size-body-medium: 14.25px;
}
:root.dark, :root[theme-mode="dark"] {
 --td-brand-color: #abcdef;
 --td-font-size-body-medium: 16.5px;
}
:root {
 --td-line-height-body-medium: 23.75px;
 --td-font-size-title-medium: 18.5px;
 --td-radius-default: 7.5px;
 --td-font-size-mark-medium: 17.25px;
 --td-line-height-mark-medium: 25.5px;
 --td-size-10: 41.5px;
 --td-size-8: 27.5px;
}
''';

void main() {
  test('CSS to JSON to public theme preserves long fractional metrics', () {
    const size = 14.1234567890123, height = 23.9876543210987;
    final css = _customCss
        .replaceAll('14.25px', '${size}px')
        .replaceAll('23.75px', '${height}px');
    final converted = convertGeneratorTheme(css);
    final theme = TThemeData.fromJson('custom', jsonEncode(converted))!;
    expect(theme.fontBodyMedium!.size, size);
    expect(theme.fontBodyMedium!.height, height / size);
    expect(theme.dark!.fontBodyMedium!.height, height / 16.5);
  });

  test(
    'converter rejects derived infinite typography instead of writing unloadable JSON',
    () async {
      final tiny = '0.${List.filled(323, '0').join()}5px';
      final css = _customCss.replaceAll('14.25px', tiny);
      expect(() => convertGeneratorTheme(css), throwsFormatException);
      final dir = await Directory.systemTemp.createTemp('tdesign-ratio-');
      addTearDown(() => dir.delete(recursive: true));
      final input = File('${dir.path}/theme.css'),
          target = File('${dir.path}/theme.json');
      await input.writeAsString(css);
      await target.writeAsString('keep original');
      final errors = StringBuffer();
      expect(
        await runConverter(
          [input.path, target.path],
          output: StringBuffer(),
          errors: errors,
        ),
        64,
      );
      expect(errors.toString(), contains('fontBodyMedium'));
      expect(await target.readAsString(), 'keep original');
    },
  );

  test(
    'line-height-only and absent fonts inherit the corresponding defaults',
    () {
      const css = '''
:root[theme-mode="light"] { --td-line-height-title-medium: 31.5px; }
:root.dark { --td-line-height-title-medium: 35.25px; }
''';
      final theme = TThemeData.fromJson(
        'custom',
        jsonEncode(convertGeneratorTheme(css)),
      )!;
      final defaults = TThemeData.defaultData();
      expect(theme.fontTitleMedium!.size, defaults.fontTitleMedium!.size);
      expect(
        theme.fontTitleMedium!.height,
        31.5 / defaults.fontTitleMedium!.size,
      );
      expect(
        theme.dark!.fontTitleMedium!.height,
        35.25 / defaults.dark!.fontTitleMedium!.size,
      );
      expect(theme.fontBodyMedium!.size, defaults.fontBodyMedium!.size);
      expect(
        theme.dark!.fontBodyMedium!.size,
        defaults.dark!.fontBodyMedium!.size,
      );
    },
  );

  test(
    'complete captured generator export loads without dropping or casting fonts',
    () async {
      // Existing controller capture contains real light/dark palettes and shared
      // generator declarations; concatenate exactly as the downloaded stylesheet.
      final fixture =
          jsonDecode(
                await File(
                  '../../packages/css2token/test/fixtures/controller-defaults.json',
                ).readAsString(),
              )
              as Map;
      final css = [
        'light',
        'dark',
        'extra',
      ].map((key) => fixture[key]).join('\n');
      final json = convertGeneratorTheme(css, name: 'ocean');
      final theme = TThemeData.fromJson('ocean', jsonEncode(json));
      expect(theme, isNotNull);
      expect(theme!.brandColor, const Color(0xff0052d9));
      expect(theme.dark, isNotNull);
      expect(theme.fontDisplayLarge!.size, 64);
      for (final part in json.values) {
        for (final font in ((part as Map)['font'] as Map).values) {
          expect(
            (font as Map).keys,
            containsAll(['size', 'lineHeight', 'fontWeight']),
          );
        }
      }
    },
  );

  test(
    'mode-specific metrics override shared declarations; missing fields inherit',
    () {
      final json = convertGeneratorTheme(
        _customCss,
        name: 'ocean',
        darkName: 'night',
      );
      final theme = TThemeData.fromJson(
        'ocean',
        jsonEncode(json),
        darkName: 'night',
      )!;
      final defaults = TThemeData.defaultData();
      expect(theme.fontBodyMedium!.size, 14.25);
      expect(theme.dark!.fontBodyMedium!.size, 16.5);
      expect(theme.fontBodyMedium!.height, 23.75 / 14.25);
      expect(theme.dark!.fontBodyMedium!.height, 23.75 / 16.5);
      expect(
        theme.fontTitleMedium!.height,
        defaults.fontTitleMedium!.size *
            defaults.fontTitleMedium!.height /
            18.5,
      );
      expect(
        theme.fontTitleMedium!.fontWeight,
        defaults.fontTitleMedium!.fontWeight,
      );
      expect(
        theme.dark!.fontTitleMedium!.fontWeight,
        defaults.dark!.fontTitleMedium!.fontWeight,
      );
      expect(theme.radiusDefault, 7.5);
      expect(theme.size8, 27.5);
      expect(theme.bgColorPage, defaults.bgColorPage);
      expect(theme.dark!.bgColorPage, defaults.dark!.bgColorPage);
    },
  );

  testWidgets(
    'converted public JSON drives typography, color, radius and size in both modes',
    (tester) async {
      final theme = TThemeData.fromJson(
        'custom',
        jsonEncode(convertGeneratorTheme(_customCss)),
      )!;
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        late TThemeData effective;
        await tester.pumpWidget(
          MaterialApp(
            theme: TThemeBuilder.light(theme),
            darkTheme: TThemeBuilder.dark(theme),
            themeMode: mode,
            themeAnimationDuration: Duration.zero,
            home: Builder(
              builder: (context) {
                effective = context.tTheme;
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TButton(
                        size: TButtonSize.small,
                        colorPreset: TButtonColorPreset.primary,
                        onPressed: () {},
                        child: const Text('Converted button'),
                      ),
                      TText(
                        'Generator',
                        font: effective.fontBodyMedium,
                        style: TextStyle(color: effective.brandColor),
                      ),
                      Container(
                        key: const Key('shape'),
                        width: effective.size8,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            effective.radiusDefault,
                          ),
                        ),
                      ),
                      TText(
                        'Explicit',
                        font: effective.fontBodyMedium,
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        final buttonStyle = tester
            .widget<ElevatedButton>(find.byType(ElevatedButton))
            .style!;
        expect(buttonStyle.backgroundColor!.resolve({}), effective.brandColor);
        expect(buttonStyle.minimumSize!.resolve({})!.height, 41.5);
        expect(buttonStyle.textStyle!.resolve({})!.fontSize, 17.25);
        expect(buttonStyle.textStyle!.resolve({})!.height, 25.5 / 17.25);
        expect(
          (buttonStyle.shape!.resolve({})! as RoundedRectangleBorder)
              .borderRadius,
          BorderRadius.circular(7.5),
        );
        final text = tester.widget<Text>(find.text('Generator'));
        expect(text.style!.fontSize, mode == ThemeMode.light ? 14.25 : 16.5);
        expect(text.style!.height, 23.75 / text.style!.fontSize!);
        expect(
          text.style!.color,
          mode == ThemeMode.light
              ? const Color(0xff123456)
              : const Color(0xffabcdef),
        );
        expect(tester.getSize(find.byKey(const Key('shape'))).width, 27.5);
        expect(
          (tester.widget<Container>(find.byKey(const Key('shape'))).decoration!
                  as BoxDecoration)
              .borderRadius,
          BorderRadius.circular(7.5),
        );
        expect(tester.widget<Text>(find.text('Explicit')).style!.fontSize, 20);
        expect(
          tester.widget<Text>(find.text('Explicit')).style!.color,
          Colors.red,
        );
      }
    },
  );

  test(
    'CLI writes loadable JSON; errors preserve existing output and source',
    () async {
      final dir = await Directory.systemTemp.createTemp('tdesign-generator-');
      addTearDown(() => dir.delete(recursive: true));
      final input = File('${dir.path}/theme.css');
      final target = File('${dir.path}/theme.json');
      await input.writeAsString(_customCss);
      final output = StringBuffer(), errors = StringBuffer();
      expect(
        await runConverter(
          [input.path, target.path, '--name', 'ocean', '--dark-name', 'night'],
          output: output,
          errors: errors,
        ),
        0,
      );
      final generated = await target.readAsString();
      expect(
        TThemeData.fromJson('ocean', generated, darkName: 'night'),
        isNotNull,
      );
      expect(errors.isEmpty, isTrue);
      expect(
        await runConverter(
          [input.path, input.path],
          output: output,
          errors: errors,
        ),
        64,
      );
      expect(await input.readAsString(), _customCss);
      await input.writeAsString(':root { invalid: export; }');
      expect(
        await runConverter(
          [input.path, target.path],
          output: output,
          errors: errors,
        ),
        64,
      );
      expect(await target.readAsString(), generated);
      expect(
        await runConverter(
          ['missing.css', target.path],
          output: output,
          errors: errors,
        ),
        74,
      );
    },
  );

  test('CLI validates arguments and names', () async {
    for (final args in <List<String>>[
      [],
      ['input'],
      ['a', 'b', '--name'],
      ['a', 'b', '--bad', 'x'],
      ['a', 'b', '--name', 'x', '--name', 'y'],
    ]) {
      expect(
        await runConverter(
          args,
          output: StringBuffer(),
          errors: StringBuffer(),
        ),
        64,
      );
    }
    final help = StringBuffer();
    expect(
      await runConverter(['--help'], output: help, errors: StringBuffer()),
      0,
    );
    expect(help.toString(), contains('Usage:'));
    for (final name in ['', ' ', 'customDark']) {
      expect(
        () => convertGeneratorTheme(
          _customCss,
          name: name,
          darkName: 'customDark',
        ),
        throwsFormatException,
      );
    }
  });
}
