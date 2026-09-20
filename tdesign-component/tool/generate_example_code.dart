import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

const _annotationName = 'ExampleCode';
const _manifestAnnotationName = 'ExampleCodeManifest';
const _manifestFileName = 'manifest.json';
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
    final sourceFiles =
        sourceDirectory
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

    final manifestCollector = _ExampleManifestCollector(
      availableAssetKeys: collector.outputs.keys
          .map((fileName) => fileName.substring(0, fileName.length - 4))
          .toSet(),
    );
    for (final file in sourceFiles.where(
      (file) => _fileName(file.path).endsWith('_page.dart'),
    )) {
      manifestCollector.collect(file);
    }
    manifestCollector.throwIfInvalid();

    if (verbose) {
      stdout.writeln(
        'Collected ${collector.outputs.length} example code snippet(s).',
      );
    }

    final expected = <String, String>{
      ...collector.outputs,
      _manifestFileName: manifestCollector.encode(
        allGroups: collector.outputs.keys
            .map((fileName) => fileName.substring(0, fileName.indexOf('.')))
            .toSet(),
      ),
    };
    final existing = <String, File>{
      if (outputDirectory.existsSync())
        for (final entity in outputDirectory.listSync())
          if (entity is File &&
              (entity.path.endsWith('.txt') ||
                  _fileName(entity.path) == _manifestFileName))
            _fileName(entity.path): entity,
    };
    final changed = <String>[];

    for (final entry in expected.entries) {
      final file = existing.remove(entry.key);
      final isNew = file == null;
      final isChanged = file != null && file.readAsStringSync() != entry.value;
      if (isNew || isChanged) {
        changed.add(entry.key);
      }
      if (verbose) {
        final status = isNew ? 'new' : (isChanged ? 'changed' : 'up-to-date');
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
          'Applying ${changed.length} change(s) to ${outputDirectory.path}...',
        );
      }
      outputDirectory.createSync(recursive: true);
      for (final entry in expected.entries) {
        final file = File(
          '${outputDirectory.path}${Platform.pathSeparator}${entry.key}',
        );
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
  late CompilationUnit _unit;
  ClassDeclaration? _standaloneExampleClass;

  void collect(File file) {
    _file = file;
    _source = file.readAsStringSync();
    _unit = parseString(content: _source, path: file.path).unit;
    final annotatedClasses = _unit.declarations
        .whereType<ClassDeclaration>()
        .where(_hasExampleCodeAnnotation)
        .toList();
    final isStandaloneExampleFile =
        _fileName(file.path).endsWith('_example.dart') ||
        _fileName(file.path).endsWith('_demo.dart');
    _standaloneExampleClass =
        isStandaloneExampleFile && annotatedClasses.length == 1
        ? annotatedClasses.single
        : null;
    _unit.accept(this);
  }

  void throwIfInvalid() {
    if (_errors.isNotEmpty) {
      throw StateError(_errors.join('\n'));
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _collect(node, node.name.lexeme);
    super.visitClassDeclaration(node);
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
        '$_annotationName group containing only letters, digits, "_" or "-".',
      );
      return;
    }

    final fileName = '$group.$methodName.txt';
    var source = node == _standaloneExampleClass
        ? _standaloneFileSource(annotation)
        : _sourceWithoutMarker(node, annotation);
    if (node is ClassDeclaration) {
      if (node == _standaloneExampleClass) {
        if (outputs.containsKey(fileName)) {
          _errors.add('${_file.path}: duplicate generated snippet $fileName.');
          return;
        }
        outputs[fileName] = '$source\n';
        return;
      }
      final imports = _unit.directives.whereType<ImportDirective>().where((
        directive,
      ) {
        final uri = directive.uri.stringValue;
        return !(uri?.endsWith('example_code.dart') ?? false) &&
            !(uri?.endsWith('example_widget.dart') ?? false);
      });
      final states = _unit.declarations.whereType<ClassDeclaration>().where(
        (declaration) =>
            declaration.extendsClause?.superclass.toSource() ==
            'State<${node.name.lexeme}>',
      );
      source = [
        if (imports.isNotEmpty)
          imports.map((item) => item.toSource()).join('\n'),
        source,
        for (final state in states) _source.substring(state.offset, state.end),
      ].join('\n\n');
    }
    if (outputs.containsKey(fileName)) {
      _errors.add('${_file.path}: duplicate generated snippet $fileName.');
      return;
    }
    outputs[fileName] = '$source\n';
  }

  String _standaloneFileSource(Annotation marker) {
    final includeNames = _annotationIncludes(marker);
    final importSources = <String>{};
    final removals = <({int start, int end})>[
      (start: marker.offset, end: _lineEnd(marker.end)),
      for (final directive in _unit.directives.whereType<ImportDirective>())
        (start: directive.offset, end: directive.end),
    ]..sort((left, right) => right.start.compareTo(left.start));
    for (final directive in _unit.directives.whereType<ImportDirective>()) {
      final uri = directive.uri.stringValue;
      if (!_isExampleInfrastructureImport(directive) &&
          !includeNames.contains(uri)) {
        importSources.add(directive.toSource());
      }
    }
    var source = _source;
    for (final removal in removals) {
      source = source.replaceRange(removal.start, removal.end, '');
    }
    final includedBodies = <String>[];
    for (final includeName in includeNames) {
      final includeFile = File(
        '${_file.parent.path}${Platform.pathSeparator}$includeName',
      );
      if (!includeFile.existsSync()) {
        _errors.add(
          '${_file.path}: included example helper not found: $includeName',
        );
        continue;
      }
      var includedSource = includeFile.readAsStringSync();
      final includedUnit = parseString(
        content: includedSource,
        path: includeFile.path,
      ).unit;
      final includedRemovals = <({int start, int end})>[];
      for (final directive
          in includedUnit.directives.whereType<ImportDirective>()) {
        final uri = directive.uri.stringValue;
        if (!_isExampleInfrastructureImport(directive) &&
            !includeNames.contains(uri)) {
          importSources.add(directive.toSource());
        }
        includedRemovals.add((start: directive.offset, end: directive.end));
      }
      includedRemovals.sort((left, right) => right.start.compareTo(left.start));
      for (final removal in includedRemovals) {
        includedSource = includedSource.replaceRange(
          removal.start,
          removal.end,
          '',
        );
      }
      includedBodies.add(
        includedSource.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim(),
      );
    }
    final imports = importSources.toList()..sort();
    return [
      if (imports.isNotEmpty) imports.join('\n'),
      source.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim(),
      ...includedBodies,
    ].where((part) => part.isNotEmpty).join('\n\n');
  }

  Set<String> _annotationIncludes(Annotation marker) {
    final result = <String>{};
    for (final argument in marker.arguments?.arguments ?? const []) {
      if (argument is! NamedExpression ||
          argument.name.label.name != 'includes' ||
          argument.expression is! ListLiteral) {
        continue;
      }
      for (final element in (argument.expression as ListLiteral).elements) {
        if (element is! SimpleStringLiteral ||
            !RegExp(r'^[A-Za-z0-9_]+\.dart$').hasMatch(element.value)) {
          _errors.add(
            '${_file.path}: $_annotationName includes must contain only '
            'literal sibling Dart file names.',
          );
          continue;
        }
        result.add(element.value);
      }
    }
    return result;
  }

  int _lineEnd(int offset) {
    if (_source.startsWith('\r\n', offset)) {
      return offset + 2;
    }
    if (_source.startsWith('\n', offset)) {
      return offset + 1;
    }
    return offset;
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

bool _hasExampleCodeAnnotation(ClassDeclaration declaration) => declaration
    .metadata
    .any((annotation) => annotation.name.name == _annotationName);

bool _isExampleInfrastructureImport(ImportDirective directive) {
  final uri = directive.uri.stringValue;
  return uri?.endsWith('example_code.dart') == true ||
      uri?.endsWith('example_widget.dart') == true;
}

class _ExampleManifestCollector {
  _ExampleManifestCollector({required this.availableAssetKeys});

  final Set<String> availableAssetKeys;
  final Map<String, List<Map<String, Object>>> _groups = {};
  final List<String> _errors = [];

  void collect(File file) {
    final source = file.readAsStringSync();
    final unit = parseString(content: source, path: file.path).unit;
    final isStrictPage = unit.declarations.whereType<ClassDeclaration>().any(
      (declaration) => declaration.metadata.any(
        (annotation) => annotation.name.name == _manifestAnnotationName,
      ),
    );
    if (!isStrictPage) {
      return;
    }
    final visitor = _ExamplePageVisitor();
    unit.accept(visitor);
    if (visitor.pages.length != 1) {
      _errors.add(
        '${file.path}: @$_manifestAnnotationName requires exactly one '
        'literal ExamplePage.',
      );
      return;
    }
    for (final pageArguments in visitor.pages) {
      final group = _stringArgument(pageArguments, 'exampleCodeGroup');
      if (group == null || !_groupPattern.hasMatch(group)) {
        _errors.add(
          '${file.path}: @$_manifestAnnotationName requires a literal, valid '
          'exampleCodeGroup.',
        );
        continue;
      }
      final modules = _strictModules(pageArguments, group);
      if (modules == null) {
        _errors.add(
          '${file.path}: @$_manifestAnnotationName requires inline '
          'ExampleModule and ExampleItem lists; every non-ignored item must '
          'map methodName to the directly built Widget class.',
        );
        continue;
      }
      if (_groups.containsKey(group)) {
        _errors.add('${file.path}: duplicate strict example group $group.');
        continue;
      }
      _groups[group] = modules;
    }
  }

  List<Map<String, Object>>? _strictModules(
    ArgumentList pageArguments,
    String group,
  ) {
    final children = _listArgument(pageArguments, 'children');
    if (children == null || children.elements.isEmpty) {
      return null;
    }
    final modules = <Map<String, Object>>[];
    for (final element in children.elements) {
      if (element is IfElement && _isIgnoredConditionalModule(element)) {
        continue;
      }
      if (_invocationName(element) != 'ExampleModule') {
        return null;
      }
      final moduleArguments = _invocationArguments(element)!;
      final title = _stringArgument(moduleArguments, 'title');
      final items = _listArgument(moduleArguments, 'children');
      if (title == null || items == null || items.elements.isEmpty) {
        return null;
      }
      final manifestItems = <Map<String, Object>>[];
      for (final item in items.elements) {
        if (_invocationName(item) != 'ExampleItem') {
          return null;
        }
        final itemArguments = _invocationArguments(item)!;
        if (_boolArgument(itemArguments, 'ignoreCode') == true) {
          continue;
        }
        final methodName = _stringArgument(itemArguments, 'methodName');
        final builderClass = _builderClassName(itemArguments);
        if (methodName == null || builderClass != methodName) {
          return null;
        }
        final assetKey = '$group.$methodName';
        if (!availableAssetKeys.contains(assetKey)) {
          _errors.add(
            '$assetKey is registered by a strict ExampleItem but has no '
            'generated @ExampleCode asset.',
          );
          continue;
        }
        manifestItems.add({
          'description': _stringArgument(itemArguments, 'desc') ?? '',
          'assetKey': assetKey,
        });
      }
      if (manifestItems.isEmpty) {
        return null;
      }
      modules.add({'title': title, 'items': manifestItems});
    }
    return modules;
  }

  bool _isIgnoredConditionalModule(IfElement element) {
    if (element.elseElement != null ||
        _invocationName(element.thenElement) != 'ExampleModule') {
      return false;
    }
    final moduleArguments = _invocationArguments(element.thenElement)!;
    final items = _listArgument(moduleArguments, 'children');
    if (items == null || items.elements.isEmpty) {
      return false;
    }
    for (final item in items.elements) {
      if (_invocationName(item) != 'ExampleItem') {
        return false;
      }
      final arguments = _invocationArguments(item)!;
      if (_boolArgument(arguments, 'ignoreCode') != true) {
        return false;
      }
    }
    return true;
  }

  void throwIfInvalid() {
    if (_errors.isNotEmpty) {
      throw StateError(_errors.join('\n'));
    }
  }

  String encode({required Set<String> allGroups}) {
    final groups = Map<String, Object>.fromEntries(
      _groups.entries.toList()
        ..sort((left, right) => left.key.compareTo(right.key)),
    );
    final unregisteredGroups =
        allGroups.difference(_groups.keys.toSet()).toList()..sort();
    if (unregisteredGroups.isNotEmpty) {
      throw StateError(
        'Every @ExampleCode group must have an @ExampleCodeManifest page. '
        'Missing: ${unregisteredGroups.join(', ')}',
      );
    }
    return '${const JsonEncoder.withIndent('  ').convert({'version': 1, 'groups': groups, 'legacyGroups': <String>[]})}\n';
  }
}

class _ExamplePageVisitor extends RecursiveAstVisitor<void> {
  final List<ArgumentList> pages = [];

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.constructorName.type.toSource() == 'ExamplePage') {
      pages.add(node.argumentList);
    }
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.target == null && node.methodName.name == 'ExamplePage') {
      pages.add(node.argumentList);
    }
    super.visitMethodInvocation(node);
  }
}

String? _invocationName(CollectionElement element) {
  if (element is InstanceCreationExpression) {
    return element.constructorName.type.toSource();
  }
  if (element is MethodInvocation && element.target == null) {
    return element.methodName.name;
  }
  return null;
}

ArgumentList? _invocationArguments(CollectionElement element) {
  if (element is InstanceCreationExpression) {
    return element.argumentList;
  }
  if (element is MethodInvocation && element.target == null) {
    return element.argumentList;
  }
  return null;
}

Expression? _namedArgument(ArgumentList arguments, String name) {
  for (final argument in arguments.arguments) {
    if (argument is NamedExpression && argument.name.label.name == name) {
      return argument.expression;
    }
  }
  return null;
}

String? _stringArgument(ArgumentList arguments, String name) {
  final expression = _namedArgument(arguments, name);
  return expression is StringLiteral ? expression.stringValue : null;
}

bool? _boolArgument(ArgumentList arguments, String name) {
  final expression = _namedArgument(arguments, name);
  return expression is BooleanLiteral ? expression.value : null;
}

ListLiteral? _listArgument(ArgumentList arguments, String name) {
  final expression = _namedArgument(arguments, name);
  return expression is ListLiteral ? expression : null;
}

String? _builderClassName(ArgumentList arguments) {
  final builder = _namedArgument(arguments, 'builder');
  if (builder is! FunctionExpression ||
      builder.body is! ExpressionFunctionBody) {
    return null;
  }
  final expression = (builder.body as ExpressionFunctionBody).expression;
  if (expression is InstanceCreationExpression) {
    return expression.constructorName.type.toSource();
  }
  if (expression is MethodInvocation && expression.target == null) {
    return expression.methodName.name;
  }
  return null;
}

String _fileName(String path) => path.split(Platform.pathSeparator).last;

void main(List<String> args) {
  const supported = <String>{'--check', '--verbose'};
  if (args.any((argument) => argument == '--help' || argument == '-h')) {
    stdout.writeln(
      'Usage: dart run tool/generate_example_code.dart [--check] [--verbose]',
    );
    stdout.writeln();
    stdout.writeln('Options:');
    stdout.writeln(
      '  --check     Check whether snippets are up to date without writing.',
    );
    stdout.writeln(
      '  --verbose   Print detailed progress information during generation.',
    );
    stdout.writeln('  --help, -h  Show this help message.');
    return;
  }
  final unsupported = args
      .where((argument) => !supported.contains(argument))
      .toList();
  if (unsupported.isNotEmpty) {
    stderr.writeln('Unsupported arguments: ${unsupported.join(', ')}');
    exitCode = 64;
    return;
  }

  final componentRoot = File.fromUri(Platform.script).parent.parent;
  final result = ExampleCodeGenerator(
    sourceDirectory: Directory(
      '${componentRoot.path}${Platform.pathSeparator}example${Platform.pathSeparator}lib',
    ),
    outputDirectory: Directory(
      '${componentRoot.path}${Platform.pathSeparator}example${Platform.pathSeparator}assets${Platform.pathSeparator}code',
    ),
  ).run(check: args.contains('--check'), verbose: args.contains('--verbose'));

  if (!result.isUpToDate) {
    final mode = args.contains('--check') ? 'out of date' : 'updated';
    stdout.writeln('Example code snippets $mode: ${result.changed.join(', ')}');
    if (args.contains('--check')) {
      exitCode = 1;
    }
  }
}
