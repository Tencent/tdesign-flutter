import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory consumer;
  late File source;
  setUp(() async {
    consumer = await Directory.systemTemp.createTemp('legacy-theme-consumer-');
    final configFile = File('.dart_tool/package_config.json').absolute;
    final config = jsonDecode(configFile.readAsStringSync()) as Map;
    for (final package in config['packages'] as List) {
      package['rootUri'] = configFile.uri
          .resolve(package['rootUri'] as String)
          .toString();
    }
    final configDirectory = Directory(p.join(consumer.path, '.dart_tool'))
      ..createSync();
    File(
      p.join(configDirectory.path, 'package_config.json'),
    ).writeAsStringSync(jsonEncode(config));
    File(p.join(consumer.path, 'pubspec.yaml')).writeAsStringSync(
      'name: legacy_theme_consumer\nenvironment:\n  sdk: ">=3.8.0 <4.0.0"\n',
    );
    source = File(p.join(consumer.path, 'consumer.dart'));
  });
  tearDown(() => consumer.delete(recursive: true));
  Future<ProcessResult> analyze(String body) {
    source.writeAsStringSync(body);
    return Process.run(_dartExecutable(), [
      'analyze',
      '--format=machine',
      source.path,
    ], workingDirectory: consumer.path);
  }

  test(
    'v1.0.0 theme implements compile without extra internal members',
    () async {
      final result = await analyze(
        File(
          'test/fixtures/theme_implements/legacy_component_themes.dart',
        ).readAsStringSync(),
      );
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
      expect(result.stdout, isEmpty);
      expect(result.stderr, isEmpty);
    },
  );
  test(
    'internal resolution bridges are not exported by the public package',
    () async {
      final result = await analyze(
        "import 'package:tdesign_flutter/tdesign_flutter.dart';\n"
        'void use(TDrawerThemeData drawer, TTabBarThemeData tab) {\n'
        ' drawer.resolveTitlePadding(EdgeInsets.zero);\n'
        ' drawer.resolveItemPadding(EdgeInsets.zero);\n'
        ' drawer.resolveItemIconGap(8);\n'
        ' drawer.resolveItemIconSize(24);\n'
        ' tab.resolveBarHeight(56);\n}',
      );
      final diagnostics = '${result.stdout}${result.stderr}'
          .split('\n')
          .where((line) => line.startsWith('ERROR|'))
          .toList();
      expect(result.exitCode, 3);
      expect(diagnostics, hasLength(5));
      expect(
        diagnostics.every((line) => line.contains('UNDEFINED_METHOD')),
        isTrue,
      );
    },
  );
}

String _dartExecutable() {
  var folder = File(Platform.resolvedExecutable).parent;
  while (folder.parent.path != folder.path) {
    final candidate = File(
      p.join(
        folder.path,
        'dart-sdk/bin',
        Platform.isWindows ? 'dart.exe' : 'dart',
      ),
    );
    if (candidate.existsSync()) {
      return candidate.path;
    }
    folder = folder.parent;
  }
  return 'dart';
}
