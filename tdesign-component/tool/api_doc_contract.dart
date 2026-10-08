import 'dart:convert';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

/// Compare Dart tokens so formatting and dartdoc do not change the contract.
List<String> lexicalTokens(String source) {
  final unit = parseString(content: source, throwIfDiagnostics: false).unit;
  final result = <String>[];
  Token? token = unit.beginToken;
  while (token != null && !token.isEof) {
    if (!token.isSynthetic) {
      result.add(token.lexeme);
    }
    token = token.next;
  }
  return result;
}

/// Declaration prefix through the parameter list, excluding annotations.
List<String> signatureTokens(AnnotatedNode node, int end) {
  final result = <String>[];
  Token? token = node.firstTokenAfterCommentAndMetadata;
  while (token != null && token.offset < end && !token.isEof) {
    if (!token.isSynthetic) {
      result.add(token.lexeme);
    }
    token = token.next;
  }
  return result;
}

/// Compact constructor parameter order and grouping, derived from source AST.
/// Named-only and empty constructors are fully described by their tables.
String constructorParameterShape(String owner, ConstructorDeclaration node) {
  final parameters = node.parameters.parameters;
  if (parameters.every((parameter) => parameter.isNamed)) {
    return '';
  }
  final required = <String>[];
  final optional = <String>[];
  final named = <String>[];
  for (final parameter in parameters) {
    final target = parameter.isNamed
        ? named
        : parameter.isRequiredPositional
        ? required
        : optional;
    target.add(parameter.name!.lexeme);
  }
  final groups = [
    ...required,
    if (optional.isNotEmpty) '[${optional.join(', ')}]',
    if (named.isNotEmpty) '{${named.join(', ')}}',
  ];
  final name = node.name?.lexeme;
  return '$owner${name == null ? '' : '.$name'}(${groups.join(', ')})';
}

/// Find a complete signature in a Dart code block, never in descriptive prose.
bool containsSignature(String section, List<String> expected) =>
    RegExp(r'^```dart\n([\s\S]*?)^```', multiLine: true)
        .allMatches(section)
        .any(
          (match) =>
              jsonEncode(
                _withoutTrailingCommas(lexicalTokens(match.group(1)!)),
              ) ==
              jsonEncode(_withoutTrailingCommas(expected)),
        );

String _decodeCell(String text) => text
    .replaceAll('&#10;', '\n')
    .replaceAll('&#13;', '\r')
    .replaceAll('&#9;', '\t')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&amp;', '&')
    .replaceAll(r'\|', '|');

/// Exclude standard framework hooks only when the declaration's owner has
/// the relevant framework ancestry. Custom overrides remain auditable APIs.
bool isFrameworkApiHook(
  MethodDeclaration method,
  Declaration owner,
  Map<String, Declaration> declarations,
) {
  final name = method.name.lexeme;
  final hasDocs = method.documentationComment != null;
  if (!hasDocs && const {'hashCode', '==', 'toString'}.contains(name)) {
    return true;
  }
  final unit = owner.parent;
  final local = <String, Declaration>{
    ...declarations,
    if (unit is CompilationUnit)
      for (final declaration in unit.declarations.whereType<ClassDeclaration>())
        declaration.name.lexeme: declaration,
  };
  final roots = <String>{};
  final visited = <String>{};
  void ancestors(ClassDeclaration type) {
    final parents = [
      if (type.extendsClause != null) type.extendsClause!.superclass,
      ...?type.implementsClause?.interfaces,
      ...?type.withClause?.mixinTypes,
    ];
    for (final parent in parents) {
      final name = parent.name2.lexeme;
      if (!visited.add(name)) {
        continue;
      }
      final declaration = local[name];
      if (declaration is ClassDeclaration) {
        ancestors(declaration);
      } else {
        roots.add(name);
      }
    }
  }

  if (owner is ClassDeclaration) {
    ancestors(owner);
  }
  if (roots.intersection({
        'Widget',
        'StatefulWidget',
        'StatelessWidget',
        'State',
        'Tab',
        'RenderObjectWidget',
        'SingleChildRenderObjectWidget',
        'MultiChildRenderObjectWidget',
        'LeafRenderObjectWidget',
      }).isNotEmpty &&
      const {
        'build',
        'createState',
        'createElement',
        'debugFillProperties',
      }.contains(name)) {
    return true;
  }
  if (hasDocs) {
    return false;
  }
  const standard = {
    'PreferredSizeWidget': {'preferredSize'},
    'Tab': {'preferredSize'},
    'RenderObjectWidget': {
      'createRenderObject',
      'updateRenderObject',
      'didUnmountRenderObject',
    },
    'Element': {
      'widget',
      'renderObject',
      'slot',
      'visitChildren',
      'forgetChild',
      'mount',
      'update',
      'unmount',
      'activate',
      'deactivate',
      'insertRenderObjectChild',
      'moveRenderObjectChild',
      'removeRenderObjectChild',
      'attachRenderObject',
      'detachRenderObject',
      'performRebuild',
      'debugFillProperties',
    },
    'Decoration': {
      'createBoxPainter',
      'hitTest',
      'isComplex',
      'debugFillProperties',
    },
    'State': {
      'initState',
      'dispose',
      'setState',
      'didChangeDependencies',
      'didUpdateWidget',
      'deactivate',
      'activate',
      'reassemble',
    },
    'ChangeNotifier': {
      'addListener',
      'removeListener',
      'notifyListeners',
      'dispose',
      'hasListeners',
    },
    'LocalizationsDelegate': {'isSupported', 'load', 'shouldReload'},
    'ThemeExtension': {'type'},
    'Map': {
      '[]=',
      'keys',
      'values',
      'length',
      'isEmpty',
      'isNotEmpty',
      'containsKey',
      'containsValue',
      'clear',
      'remove',
      'addAll',
      'addEntries',
      'cast',
      'forEach',
      'map',
      'putIfAbsent',
      'removeWhere',
      'update',
      'updateAll',
    },
    'Iterable': {
      'iterator',
      'length',
      'isEmpty',
      'isNotEmpty',
      'first',
      'last',
      'single',
      'cast',
      'contains',
      'elementAt',
      'toList',
      'toSet',
      'map',
      'where',
      'expand',
      'fold',
      'reduce',
      'forEach',
      'any',
      'every',
      'join',
      'skip',
      'take',
      'skipWhile',
      'takeWhile',
      'firstWhere',
      'lastWhere',
      'singleWhere',
      'followedBy',
      'whereType',
    },
  };
  String frameworkBase(String root) {
    if (const {
      'SingleChildRenderObjectWidget',
      'MultiChildRenderObjectWidget',
      'LeafRenderObjectWidget',
    }.contains(root)) {
      return 'RenderObjectWidget';
    }
    if (const {
      'ComponentElement',
      'RenderObjectElement',
      'SingleChildRenderObjectElement',
      'MultiChildRenderObjectElement',
    }.contains(root)) {
      return 'Element';
    }
    if (root == 'MapBase' || root == 'DelegatingMap') {
      return 'Map';
    }
    if (root == 'IterableBase') {
      return 'Iterable';
    }
    return root;
  }

  return roots.any(
    (root) => (standard[frameworkBase(root)] ?? {}).contains(name),
  );
}

/// Compare types/defaults while retaining significant string literal content.
bool sameCode(String a, String b) =>
    jsonEncode(lexicalTokens(_decodeCell(a))) == jsonEncode(lexicalTokens(b));

/// Split only unescaped table separators, preserving Dart operators and prose.
List<String> tableCells(String line) {
  final cells = <String>[];
  final cell = StringBuffer();
  var slashes = 0;
  for (var i = 1; i < line.length - 1; i++) {
    final char = line[i];
    if (char == '|' && slashes.isEven) {
      cells.add(cell.toString().trim());
      cell.clear();
    } else {
      cell.write(char);
    }
    slashes = char == r'\' ? slashes + 1 : 0;
  }
  cells.add(cell.toString().trim());
  return cells;
}

/// Parameter rows within one callable's section.
List<Map<String, String>> parameterRows(String section) {
  var headers = <String>[];
  final rows = <Map<String, String>>[];
  for (final line in section.split('\n')) {
    if (!line.startsWith('|') || !line.endsWith('|')) {
      continue;
    }
    final cells = tableCells(line);
    if (cells.first == '参数') {
      headers = cells;
      continue;
    }
    if (headers.isEmpty || cells.first.replaceAll('-', '').isEmpty) {
      continue;
    }
    if (cells.length != headers.length) {
      rows.add({'参数': '!malformed'});
      continue;
    }
    rows.add({for (var i = 0; i < headers.length; i++) headers[i]: cells[i]});
  }
  return rows;
}

ClassDeclaration? _parentClass(
  Declaration owner,
  Map<String, Declaration> nodes,
) {
  if (owner is! ClassDeclaration) {
    return null;
  }
  final parent = nodes[owner.extendsClause?.superclass.name2.lexeme];
  return parent is ClassDeclaration ? parent : null;
}

String _fieldType(
  String name,
  Declaration owner,
  Map<String, Declaration> nodes,
) {
  if (owner is ClassDeclaration) {
    for (final field in owner.members.whereType<FieldDeclaration>()) {
      if (field.fields.variables.any(
        (variable) => variable.name.lexeme == name,
      )) {
        return field.fields.type?.toSource() ?? 'dynamic';
      }
    }
    final parent = _parentClass(owner, nodes);
    if (parent != null) {
      return _fieldType(name, parent, nodes);
    }
  }
  return name == 'key' ? 'Key?' : 'dynamic';
}

/// Parameter-declared types win over nullable backing fields.
String parameterType(
  FormalParameter parameter,
  Declaration owner,
  Map<String, Declaration> nodes,
) {
  final param = parameter is DefaultFormalParameter
      ? parameter.parameter
      : parameter;
  if (param is SimpleFormalParameter) {
    return param.type?.toSource() ?? 'dynamic';
  }
  if (param is FieldFormalParameter) {
    return param.type?.toSource() ??
        _fieldType(param.name.lexeme, owner, nodes);
  }
  if (param is SuperFormalParameter) {
    return param.type?.toSource() ??
        _fieldType(
          param.name.lexeme,
          _parentClass(owner, nodes) ?? owner,
          nodes,
        );
  }
  if (param is FunctionTypedFormalParameter) {
    return '${param.returnType?.toSource() ?? 'dynamic'} Function${param.typeParameters?.toSource() ?? ''}${param.parameters.toSource()}${param.question == null ? '' : '?'}';
  }
  return 'dynamic';
}

/// Super formals inherit defaults; ordinary parameters do not.
String parameterDefault(
  FormalParameter parameter,
  Declaration owner,
  Map<String, Declaration> nodes,
) {
  if (parameter is DefaultFormalParameter && parameter.defaultValue != null) {
    return parameter.defaultValue!.toSource();
  }
  final normal = parameter is DefaultFormalParameter
      ? parameter.parameter
      : parameter;
  if (normal is SuperFormalParameter) {
    final parent = _parentClass(owner, nodes);
    if (parent != null) {
      for (final constructor
          in parent.members.whereType<ConstructorDeclaration>()) {
        if (constructor.name != null) {
          continue;
        }
        for (final parameter in constructor.parameters.parameters) {
          if (parameter.name?.lexeme == normal.name.lexeme) {
            return parameterDefault(parameter, parent, nodes);
          }
        }
      }
    }
  }
  return '-';
}

List<String> _withoutTrailingCommas(List<String> tokens) => [
  for (var i = 0; i < tokens.length; i++)
    if (tokens[i] != ',' ||
        i + 1 == tokens.length ||
        !const {')', ']', '}'}.contains(tokens[i + 1]))
      tokens[i],
];
