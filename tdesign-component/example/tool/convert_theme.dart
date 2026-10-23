import 'dart:convert';
import 'dart:io';

import 'package:css2token/css2token.dart';
import 'package:tdesign_flutter/src/theme/t_default_theme.dart';

const _usage =
    'Usage: dart run tool/convert_theme.dart <theme.css> <theme.json> '
    '[--name ocean] [--dark-name oceanDark]';

/// Converts a complete generator export to the public named-theme JSON format.
///
/// Only missing composite font fields are completed, using the component's own
/// pure-Dart default configuration. Other token groups stay sparse so the
/// application inherits defaults from its installed component version.
Map<String, Object?> convertGeneratorTheme(
  String css, {
  String name = 'custom',
  String? darkName,
}) {
  final resolvedDarkName = darkName ?? '${name}Dark';
  if (name.trim().isEmpty ||
      resolvedDarkName.trim().isEmpty ||
      name == resolvedDarkName) {
    throw const FormatException('Theme names must be nonempty and distinct');
  }
  final parts = splitGeneratorCss(css);
  final overrides = cssToFlutterTokens(
    lightCss: parts.light,
    darkCss: parts.dark,
  );
  final defaults = jsonDecode(TDefaultTheme.defaultThemeConfig) as Map;
  Map<String, Object> complete(FlutterThemeTokens tokens, String mode) {
    final result = tokens.toJson();
    final fonts = <String, Object>{};
    final defaultFonts = (defaults[mode] as Map)['font'] as Map;
    for (final entry in tokens.font.entries) {
      final base = defaultFonts[entry.key] as Map?;
      if (base == null) {
        throw FormatException('Unknown composite font: ${entry.key}');
      }
      final completed = <String, Object?>{
        ...base.cast<String, Object?>(),
        'fontWeight': 4,
        if (base['fontWeight'] != null) 'fontWeight': base['fontWeight'],
        ...(entry.value as Map).cast<String, Object?>(),
      };
      final size = (completed['size'] as num).toDouble();
      final lineHeight = (completed['lineHeight'] as num).toDouble();
      if (!size.isFinite ||
          size <= 0 ||
          !lineHeight.isFinite ||
          lineHeight < 0 ||
          !(lineHeight / size).isFinite) {
        throw FormatException('Invalid composite font metrics: ${entry.key}');
      }
      fonts[entry.key] = completed;
    }
    result['font'] = fonts;
    return result;
  }

  return {
    name: complete(overrides.light, 'default'),
    resolvedDarkName: complete(overrides.dark, 'defaultDark'),
  };
}

/// Runs the offline file converter; returns a shell exit status.
Future<int> runConverter(
  List<String> args, {
  required StringSink output,
  required StringSink errors,
}) async {
  if (args.length == 1 && args.single == '--help') {
    output.writeln(_usage);
    return 0;
  }
  try {
    if (args.length < 2 || (args.length - 2).isOdd) {
      throw const FormatException(_usage);
    }
    var name = 'custom';
    String? darkName;
    final seen = <String>{};
    for (var i = 2; i < args.length; i += 2) {
      if (!seen.add(args[i])) {
        throw FormatException('Duplicate option: ${args[i]}');
      }
      switch (args[i]) {
        case '--name':
          name = args[i + 1];
        case '--dark-name':
          darkName = args[i + 1];
        default:
          throw FormatException('Unknown option: ${args[i]}\n$_usage');
      }
    }
    final input = File(args[0]);
    final target = File(args[1]);
    if (input.absolute.path == target.absolute.path ||
        (target.existsSync() &&
            await FileSystemEntity.identical(input.path, target.path))) {
      throw const FormatException('Input and output must be different files');
    }
    final json = convertGeneratorTheme(
      await input.readAsString(),
      name: name,
      darkName: darkName,
    );
    await target.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(json)}\n',
    );
    output.writeln(
      'Wrote ${target.path} ($name / ${darkName ?? '${name}Dark'})',
    );
    return 0;
  } on FormatException catch (error) {
    errors.writeln(error.message);
    return 64;
  } on FileSystemException catch (error) {
    errors.writeln(error.message);
    return 74;
  }
}

Future<void> main(List<String> args) async {
  exitCode = await runConverter(args, output: stdout, errors: stderr);
}
