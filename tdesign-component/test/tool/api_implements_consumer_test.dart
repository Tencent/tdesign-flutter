import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory consumer;
  late File source;

  setUp(() async {
    consumer = await Directory.systemTemp.createTemp('tdesign-implements-');
    final configFile = File('.dart_tool/package_config.json').absolute;
    final config = jsonDecode(configFile.readAsStringSync()) as Map;
    for (final package in config['packages'] as List) {
      package['rootUri'] = configFile.uri
          .resolve(package['rootUri'] as String)
          .toString();
    }
    final configDirectory = Directory(p.join(consumer.path, '.dart_tool'));
    configDirectory.createSync();
    File(
      p.join(configDirectory.path, 'package_config.json'),
    ).writeAsStringSync(jsonEncode(config));
    File(p.join(consumer.path, 'pubspec.yaml')).writeAsStringSync(
      'name: business_overlay_consumer\n'
      'environment:\n  sdk: ">=3.8.0 <4.0.0"\n',
    );
    source = File(p.join(consumer.path, 'overlay.dart'));
    source.writeAsStringSync(
      File(
        'test/fixtures/api_compatibility/consumer_overlay.dart',
      ).readAsStringSync(),
    );
  });

  tearDown(() => consumer.delete(recursive: true));

  Future<ProcessResult> analyze() => Process.run(_dartExecutable(), [
    'analyze',
    '--format=machine',
    source.path,
  ], workingDirectory: consumer.path);

  test(
    'external implements consumer must adapt the new onTap getter',
    () async {
      const forwardingGetter =
          '  @override\n  VoidCallback? get onTap => onClick;\n';
      final adapted = source.readAsStringSync();
      expect(adapted, contains(forwardingGetter));
      source.writeAsStringSync(adapted.replaceFirst(forwardingGetter, ''));
      final result = await analyze();
      final diagnostics = '${result.stdout}${result.stderr}'
          .split('\n')
          .where((line) => line.startsWith('ERROR|'))
          .toList();
      expect(result.exitCode, 3, reason: '${result.stdout}${result.stderr}');
      expect(diagnostics, hasLength(1));
      expect(
        diagnostics.single,
        contains('NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER'),
      );
      expect(diagnostics.single, contains('onTap'));
    },
  );

  test(
    'external implements consumer accepts explicit callback forwarding',
    () async {
      final result = await analyze();
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
      expect(result.stdout, isEmpty);
      expect(result.stderr, isEmpty);
    },
  );
}

String _dartExecutable() {
  final sdk = Platform.environment['DART_SDK'];
  final name = Platform.isWindows ? 'dart.exe' : 'dart';
  if (sdk != null) {
    return p.join(sdk, 'bin', name);
  }
  var folder = File(Platform.resolvedExecutable).parent;
  while (folder.parent.path != folder.path) {
    final candidate = File(p.join(folder.path, 'dart-sdk/bin', name));
    if (candidate.existsSync()) {
      return candidate.path;
    }
    folder = folder.parent;
  }
  return name;
}
