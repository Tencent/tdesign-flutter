import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

const _annotationName = 'ExampleCode';
final _groupPattern = RegExp(r'^[A-Za-z0-9_-]+$');

/// Generates source snippets for the example application's code viewer.
class ExampleCodeGenerator {
  ExampleCodeGenerator({
    required this.sourceDirectory,
    required this.outputDirectory,
  });

  final Directory sourceDirectory;
  final Directory outputDirectory;

  /// Synchronizes generated snippets, or reports drift when [check] is true.
  ///
  /// When [verbose] is true, prints detailed progress information to stdout,
  /// including the scanned source files, collected snippets, and per-file
  /// write/check results.
  GenerationResult run({bool check = false, bool verbose = false}) {
    final collector = _ExampleCodeCollector();
    final sourceFiles = sourceDirectory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    if (verbose) {
      stdout.writeln('Scanning source directory: ${sourceDirectory.path}');
      stdout.writeln('Found ${sourceFiles.length} Dart file(s):');
      for (final file in sourceFiles) {
        stdout.writeln('  - ${file.path}');
      }
    }

    for (final file in sourceFiles) {
      collector.collect(file);
    }
    collector.throwIfInvalid();

    if (verbose) {
      stdout.writeln(
          'Collected ${collector.outputs.length} example code snippet(s).');
    }

    final expected = collector.outputs;
    final existing = <String, File>{
      if (outputDirectory.existsSync())
        for (final entity in outputDirectory.listSync())
          if (entity is File && entity.path.endsWith('.txt'))
            _fileName(entity.path): entity,
    };
    final changed = <String>[];

    for (final entry in expected.entries) {
      final file = existing.remove(entry.key);
      final isNew = file == null;
      final isChanged =
          file != null && file.readAsStringSync() != entry.value;
      if (isNew || isChanged) {
        changed.add(entry.key);
      }
      if (verbose) {
        final status = isNew
            ? 'new'
            : (isChanged ? 'changed' : 'up-to-date');
        stdout.writeln('  [$status] ${entry.key}');
      }
    }
    for (final name in existing.keys) {
      changed.add('stale:$name');
      if (verbose) {
        stdout.writeln('  [stale] $name');
      }
    }
    changed.sort();

    if (!check && changed.isNotEmpty) {
      if (verbose) {
        stdout.writeln(
            'Applying ${changed.length} change(s) to ${outputDirectory.path}...');
      }
      outputDirectory.createSync(recursive: true);
      for (final entry in expected.entries) {
        final file = File(
            '${outputDirectory.path}${Platform.pathSeparator}${entry.key}');
        if (!file.existsSync() || file.readAsStringSync() != entry.value) {
          file.writeAsStringSync(entry.value);
          if (verbose) {
            stdout.writeln('  Wrote ${entry.key}');
          }
        }
      }
      for (final file in existing.values) {
        file.deleteSync();
        if (verbose) {
          stdout.writeln('  Deleted ${_fileName(file.path)}');
        }
      }
    } else if (verbose && changed.isEmpty) {
      stdout.writeln('All snippets are up to date.');
    }

    return GenerationResult(changed: changed);
  }
}

/// Result of a generation or consistency-check run.
class GenerationResult {
  const GenerationResult({required this.changed});

  final List<String> changed;

  bool get isUpToDate => changed.isEmpty;
}

class _ExampleCodeCollector extends RecursiveAstVisitor<void> {
  final Map<String, String> outputs = <String, String>{};
  final List<String> _errors = <String>[];

  late File _file;
  late String _source;

  void collect(File file) {
    _file = file;
    _source = file.readAsStringSync();
    parseString(content: _source, path: file.path).unit.accept(this);
  }

  void throwIfInvalid() {
    if (_errors.isNotEmpty) {
      throw StateError(_errors.join('\n'));
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _collect(node, node.name.lexeme);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    _collect(node, node.name.lexeme);
    super.visitMethodDeclaration(node);
  }

  void _collect(AnnotatedNode node, String methodName) {
    final annotation = node.metadata
        .where((item) => item.name.name == _annotationName)
        .cast<Annotation?>()
        .firstWhere((item) => item != null, orElse: () => null);
    if (annotation == null) {
      return;
    }

    String? group;
    for (final argument in annotation.arguments?.arguments ?? const []) {
      if (argument is NamedExpression &&
          argument.name.label.name == 'group' &&
          argument.expression is SimpleStringLiteral) {
        group = (argument.expression as SimpleStringLiteral).value;
      }
    }
    if (group == null || !_groupPattern.hasMatch(group)) {
      _errors.add(
          '${_file.path}: $methodName must declare a literal, non-empty '
          '$_annotationName group containing only letters, digits, "_" or "-".');
      return;
    }

    final fileName = '$group.$methodName.txt';
    final source = _sourceWithoutMarker(node, annotation);
    if (outputs.containsKey(fileName)) {
      _errors.add('${_file.path}: duplicate generated snippet $fileName.');
      return;
    }
    outputs[fileName] = '$source\n';
  }

  String _sourceWithoutMarker(AnnotatedNode node, Annotation marker) {
    final prefix = _source.substring(node.offset, marker.offset);
    var suffix = _source.substring(marker.end, node.end);
    if (prefix.trim().isEmpty) {
      suffix = suffix.trimLeft();
    } else {
      suffix = suffix.replaceFirst(RegExp(r'^[ \t]*(?:\r?\n)?'), '');
    }
    return '$prefix$suffix'.trimLeft();
  }
}

String _fileName(String path) => path.split(Platform.pathSeparator).last;

void main(List<String> args) {
  const supported = <String>{'--check', '--verbose'};
  if (args.any((argument) => argument == '--help' || argument == '-h')) {
    stdout.writeln(
        'Usage: dart run tool/generate_example_code.dart [--check] [--verbose]');
    stdout.writeln();
    stdout.writeln('Options:');
    stdout.writeln(
        '  --check     Check whether snippets are up to date without writing.');
    stdout.writeln(
        '  --verbose   Print detailed progress information during generation.');
    stdout.writeln('  --help, -h  Show this help message.');
    return;
  }
  final unsupported =
      args.where((argument) => !supported.contains(argument)).toList();
  if (unsupported.isNotEmpty) {
    stderr.writeln('Unsupported arguments: ${unsupported.join(', ')}');
    exitCode = 64;
    return;
  }

  final componentRoot = File.fromUri(Platform.script).parent.parent;
  final result = ExampleCodeGenerator(
    sourceDirectory: Directory(
        '${componentRoot.path}${Platform.pathSeparator}example${Platform.pathSeparator}lib'),
    outputDirectory: Directory(
        '${componentRoot.path}${Platform.pathSeparator}example${Platform.pathSeparator}assets${Platform.pathSeparator}code'),
  ).run(
    check: args.contains('--check'),
    verbose: args.contains('--verbose'),
  );

  if (!result.isUpToDate) {
    final mode = args.contains('--check') ? 'out of date' : 'updated';
    stdout.writeln('Example code snippets $mode: ${result.changed.join(', ')}');
    if (args.contains('--check')) {
      exitCode = 1;
    }
  }
}
