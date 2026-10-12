import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_demo_structure.dart';

void main() {
  const guides = {'theme-guide': 'theme.ThemeGuideExample'};
  const config = """
    ExamplePageModel(
      name: 'theme-guide',
      pageBuilder: _wrapInheritedTheme(
        (context) => const ThemeGuideExample(),
      ),
    ),
""";
  test('guide route registers the corresponding generated asset', () {
    final assets = <String>{'theme.ThemeBaseExample'};
    expect(registerGuideAssets(guides, config, assets), isEmpty);
    expect(assets, contains('theme.ThemeGuideExample'));
  });
  test('missing or duplicate routes fail registration', () {
    expect(registerGuideAssets(guides, '', {}), isNotEmpty);
    expect(registerGuideAssets(guides, '$config$config', {}), isNotEmpty);
  });
  test('route constructing a different Widget fails registration', () {
    expect(
      registerGuideAssets(
        guides,
        config.replaceAll('ThemeGuideExample()', 'OtherExample()'),
        {},
      ),
      isNotEmpty,
    );
  });
  test('a guide cannot also be registered as a component ExampleItem', () {
    expect(
      registerGuideAssets(guides, config, {'theme.ThemeGuideExample'}),
      isNotEmpty,
    );
  });
  test('malformed route and asset keys are rejected', () {
    expect(
      registerGuideAssets({'../guide': 'theme.ThemeGuideExample'}, config, {}),
      isNotEmpty,
    );
    expect(
      registerGuideAssets({'theme-guide': 'invalid'}, config, {}),
      isNotEmpty,
    );
  });
  test('actual config matches both generated guide registrations', () {
    final source = File('example/lib/config.dart').readAsStringSync();
    expect(
      registerGuideAssets(
        {
          'custom-theme': 'theme.CustomThemeExample',
          'dark-mode': 'theme.ThemeDarkModeExample',
        },
        source,
        {},
      ),
      isEmpty,
    );
  });
}
