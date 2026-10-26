import 'dart:io';

const _codeDirectory = 'example/assets/code';
const _exampleDirectory = 'example';

Future<void> main() async {
  final codeDirectory = Directory(_codeDirectory);
  if (!codeDirectory.existsSync()) {
    stderr.writeln('Missing generated example code directory: $_codeDirectory');
    exitCode = 1;
    return;
  }

  final snippets =
      codeDirectory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.txt'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  if (snippets.isEmpty) {
    stderr.writeln('No generated example code snippets found.');
    exitCode = 1;
    return;
  }

  final errors = <String>[];
  final auditDirectory = Directory(
    '$_exampleDirectory/lib/.snippet_audit_tmp_${pid}',
  );
  if (auditDirectory.existsSync()) {
    stderr.writeln('Audit directory already exists: ${auditDirectory.path}');
    exitCode = 1;
    return;
  }

  auditDirectory.createSync(recursive: true);
  try {
    for (final snippet in snippets) {
      final name = snippet.uri.pathSegments.last.replaceFirst('.txt', '.dart');
      final source = snippet.readAsStringSync();
      for (final line in source.split('\n')) {
        final import = RegExp(r"^\s*import\s+'([^']+)'\s*;").firstMatch(line);
        final importPath = import?.group(1);
        if (importPath == null) {
          continue;
        }
        if (importPath.startsWith('package:tdesign_flutter_example/')) {
          errors.add('$name imports private Example App code: $importPath');
        }
      }
      if (source.trim().isEmpty) {
        errors.add('$name is empty');
      }
      File('${auditDirectory.path}/$name').writeAsStringSync(source);
    }

    if (errors.isNotEmpty) {
      stderr.writeln('Generated example snippet audit failed:');
      for (final error in errors) {
        stderr.writeln('- $error');
      }
      exitCode = 1;
      return;
    }

    final analyze = await Process.run(
      'flutter',
      ['analyze', '--no-pub', auditDirectory.path.substring('example/'.length)],
      workingDirectory: _exampleDirectory,
      runInShell: true,
    );
    stdout.write(analyze.stdout);
    stderr.write(analyze.stderr);
    if (analyze.exitCode != 0) {
      exitCode = analyze.exitCode;
      return;
    }
    stdout.writeln(
      'Generated example snippet audit passed: ${snippets.length} snippets.',
    );
  } finally {
    auditDirectory.deleteSync(recursive: true);
  }
}
