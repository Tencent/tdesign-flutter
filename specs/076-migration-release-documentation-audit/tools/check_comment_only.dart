import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';

// Compare normalized AST source, retaining syntax and metadata but excluding
// comments/formatting. Changed ASTs still require actual source review.
void main(List<String> args) {
  String git(List<String> arguments) {
    final result = Process.runSync('git', arguments);
    if (result.exitCode != 0) throw StateError('${result.stderr}');
    return result.stdout as String;
  }

  String ast(String source) => parseString(content: source).unit.toSource();

  final reports = <Map<String, dynamic>>[];
  for (final sha in args) {
    final files = git([
      'diff',
      '$sha^1',
      sha,
      '--name-only',
      '--',
      'tdesign-component/lib',
    ]).trim().split('\n').where((f) => f.endsWith('.dart')).toList();
    final changed = <String>[];
    for (final file in files) {
      if (ast(git(['show', '$sha^1:$file'])) !=
          ast(git(['show', '$sha:$file']))) {
        changed.add(file);
      }
    }
    reports.add({'commit': sha, 'files': files.length, 'astChanges': changed});
  }
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(reports));
}
