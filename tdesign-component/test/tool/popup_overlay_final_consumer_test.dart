import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory consumer;
  late File source;

  setUp(() async {
    consumer = await Directory.systemTemp.createTemp('popup-final-consumer-');
    final configFile = File('.dart_tool/package_config.json').absolute;
    final config = jsonDecode(configFile.readAsStringSync()) as Map;
    for (final package in config['packages'] as List) {
      package['rootUri'] = configFile.uri
          .resolve(package['rootUri'] as String)
          .toString();
    }
    final dir = Directory(p.join(consumer.path, '.dart_tool'))..createSync();
    File(
      p.join(dir.path, 'package_config.json'),
    ).writeAsStringSync(jsonEncode(config));
    File(p.join(consumer.path, 'pubspec.yaml')).writeAsStringSync(
      'name: popup_consumer\nenvironment:\n  sdk: ">=3.8.0 <4.0.0"\n',
    );
    source = File(p.join(consumer.path, 'consumer.dart'));
  });

  tearDown(() => consumer.delete(recursive: true));

  Future<ProcessResult> analyze(String body) {
    source.writeAsStringSync(
      "import 'package:tdesign_flutter/tdesign_flutter.dart';\n$body",
    );
    return Process.run(_dartExecutable(), [
      'analyze',
      '--format=machine',
      source.path,
    ], workingDirectory: consumer.path);
  }

  test('Drawer lifecycle bridge is not a public package API', () async {
    final result = await analyze(
      'void use(BuildContext context) { showDrawerPopupInternal(context, options: TPopupOptions.center(child: const SizedBox())); }',
    );
    expect(result.exitCode, isNot(0));
    expect('${result.stdout}${result.stderr}', contains('UNDEFINED_FUNCTION'));
  });

  for (final relation in ['extends', 'implements']) {
    test('1.0.1 external $relation is explicitly rejected', () async {
      final result = await analyze(
        'abstract class BusinessOverlay $relation TPopupOverlayConfig {}',
      );
      final diagnostics = '${result.stdout}${result.stderr}';
      expect(result.exitCode, isNot(0), reason: diagnostics);
      expect(diagnostics, contains('INVALID_USE_OF_TYPE_OUTSIDE_LIBRARY'));
      expect(diagnostics, contains('final'));
    });
  }

  for (final usage in [
    'final config = TPopupOverlayConfig(onClick: () {});',
    'const config = TPopupOverlayConfig();\nfinal callback = config.onClick;',
  ]) {
    test('legacy onClick is accepted with deprecation: $usage', () async {
      final result = await analyze(usage);
      final diagnostics = '${result.stdout}${result.stderr}';
      expect(diagnostics, contains('DEPRECATED_MEMBER_USE'));
      expect(diagnostics, isNot(contains('ERROR|')));
      expect(diagnostics, isNot(contains('UNDEFINED_')));
    });
  }

  test(
    '1.0.1 const construction and composition compile without diagnostics',
    () async {
      final result = await analyze('''
const defaults = TPopupOverlayConfig();
TPopupOverlayConfig createOverlay(bool visible, VoidCallback? callback) =>
    TPopupOverlayConfig(showOverlay: visible, onTap: callback);
void use() {
  createOverlay(defaults.showOverlay, defaults.onTap);
}
''');
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
      expect(result.stdout, isEmpty);
      expect(result.stderr, isEmpty);
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
