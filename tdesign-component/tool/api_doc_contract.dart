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

/// Independently check alias tables against the exported source AST.
/// Existing assets may instead carry the complete typedef declaration.
List<String> typedefDocumentationIssues(
  GenericTypeAlias alias,
  String section,
) {
  final signature = signatureTokens(alias, alias.end);
  if (containsSignature(section, signature)) {
    return [];
  }
  final issues = <String>[];
  bool matchesInline(String label, String expected) {
    final actual = RegExp(
      '^$label：`([^`]+)`',
      multiLine: true,
    ).firstMatch(section)?.group(1);
    return expected.isEmpty
        ? actual == null
        : actual != null && sameCode(actual, expected);
  }

  if (!matchesInline(
    '类型参数',
    alias.typeParameters?.typeParameters
            .map((parameter) => parameter.toSource())
            .join(', ') ??
        '',
  )) {
    issues.add('generics');
  }
  final type = alias.type;
  if (type is! GenericFunctionType) {
    final rows = parameterRows(section);
    if (rows.length != 1 ||
        rows.single['参数'] != alias.name.lexeme ||
        !sameCode(rows.single['类型'] ?? '', type.toSource()) ||
        rows.single['默认值'] != '-' ||
        rows.single['必填'] != '-') {
      issues.add('target');
    }
    return issues;
  }
  if (!section.contains('#### 回调参数\n')) {
    issues.add('parameters');
  }
  final parameters = type.parameters.parameters;
  String name(int index) => parameters[index].name?.lexeme ?? '参数 ${index + 1}';
  final positional = [
    for (var index = 0; index < parameters.length; index++)
      if (!parameters[index].isNamed) name(index),
  ].join(', ');
  if (!matchesInline('位置参数', positional)) {
    issues.add('order');
  }
  if (!matchesInline(
    '回调类型参数',
    type.typeParameters?.typeParameters
            .map((parameter) => parameter.toSource())
            .join(', ') ??
        '',
  )) {
    issues.add('callback-generics');
  }
  if (section.contains('可空：是。') != (type.question != null)) {
    issues.add('nullable');
  }
  final returnType = documentedReturnType(section);
  if (returnType == null ||
      !sameCode(returnType, type.returnType?.toSource() ?? 'dynamic')) {
    issues.add('return');
  }
  final rows = parameterRows(section);
  if (rows.length != parameters.length) {
    issues.add('count');
  }
  for (var index = 0; index < parameters.length; index++) {
    final found = rows.where((row) => row['参数'] == name(index)).toList();
    final parameter = parameters[index];
    if (index >= rows.length ||
        rows[index]['参数'] != name(index) ||
        found.length != 1 ||
        !sameCode(
          found.single['类型'] ?? '',
          parameterType(parameter, alias, {}),
        ) ||
        found.single['默认值'] != '-' ||
        found.single['必填'] != (parameter.isRequired ? '是' : '否')) {
      issues.add('parameter-${name(index)}');
    }
  }
  return issues;
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

/// Read the compact callable contract directly from its source AST.
({String shape, String typeParameters, String? returnType}) callableContract(
  AnnotatedNode node,
) {
  final FormalParameterList parameters;
  final TypeParameterList? typeParameters;
  final String? returnType;
  if (node is ConstructorDeclaration) {
    parameters = node.parameters;
    typeParameters = null;
    returnType = null;
  } else if (node is MethodDeclaration) {
    parameters = node.parameters!;
    typeParameters = node.typeParameters;
    returnType = node.returnType?.toSource() ?? 'dynamic';
  } else {
    final function = node as FunctionDeclaration;
    parameters = function.functionExpression.parameters!;
    typeParameters = function.functionExpression.typeParameters;
    returnType = function.returnType?.toSource() ?? 'dynamic';
  }
  final positional = parameters.parameters
      .where((parameter) => !parameter.isNamed)
      .map((parameter) => parameter.name!.lexeme)
      .join(', ');
  return (
    shape: positional,
    typeParameters:
        typeParameters?.typeParameters.map((p) => p.toSource()).join(', ') ??
        '',
    returnType: returnType,
  );
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

/// Read a return contract without borrowing a neighbouring API's table.
String? documentedReturnType(String section) {
  final headings = RegExp(
    r'^#{4,6} 返回值[ \t]*$',
    multiLine: true,
  ).allMatches(section).toList();
  if (headings.isEmpty) {
    return RegExp(
      r'^返回类型：`([^`]+)`',
      multiLine: true,
    ).firstMatch(section)?.group(1);
  }
  if (headings.length != 1) {
    return null;
  }
  final heading = headings.single;
  final depth = heading.group(0)!.split(' ').first.length;
  final tail = section.substring(heading.end);
  final boundary = RegExp('^#{1,$depth} ', multiLine: true).firstMatch(tail);
  final block = boundary == null ? tail : tail.substring(0, boundary.start);
  final lines = block.split('\n');
  final start = lines.indexWhere(
    (line) =>
        line.trim() == '| 类型 | 说明 |' ||
        line.trim() == '| 名称 | 类型 | 默认值 | 说明 | 必传 |',
  );
  if (start < 0) {
    return null;
  }
  final rows = <List<String>>[];
  for (final line in lines.skip(start + 1)) {
    if (!line.startsWith('|') || !line.endsWith('|')) {
      break;
    }
    final cells = tableCells(line);
    if (cells.every((cell) => RegExp(r'^:?-+:?$').hasMatch(cell))) {
      continue;
    }
    rows.add(cells);
  }
  if (rows.length != 1) {
    return null;
  }
  final compact = lines[start].trim() == '| 类型 | 说明 |';
  final row = rows.single;
  if (compact) {
    return row.length == 2 ? row.first : null;
  }
  return row.length == 5 && row.first == '返回值' && row[2] == '-' && row[4] == '-'
      ? row[1]
      : null;
}

/// Omit authored relationship tables when auditing API data contracts.
Iterable<String> apiContractLines(String section) sync* {
  var details = false;
  var inTable = false;
  for (final line in section.split('\n')) {
    if (line == '<!-- api-table: details -->') {
      details = true;
      continue;
    }
    if (line.startsWith('|')) {
      inTable = true;
      if (!details) {
        yield line;
      }
    } else {
      if (inTable) {
        details = false;
      }
      inTable = false;
      yield line;
    }
  }
}

/// Parameter rows within one callable's section.
List<Map<String, String>> parameterRows(String section) {
  var headers = <String>[];
  var inReturns = false;
  final rows = <Map<String, String>>[];
  for (final line in apiContractLines(section)) {
    if (RegExp(r'^#{4,6} 返回值[ \t]*$').hasMatch(line)) {
      inReturns = true;
    } else if (RegExp(r'^#{1,5} ').hasMatch(line)) {
      inReturns = false;
    }
    if (inReturns) {
      headers = <String>[];
      continue;
    }
    if (!line.startsWith('|') || !line.endsWith('|')) {
      headers = <String>[];
      continue;
    }
    final cells = tableCells(line);
    if (cells.first == '参数' || (cells.first == '名称' && cells.contains('必传'))) {
      // Normalize presentation labels to the contract keys used by the audit.
      headers = cells.map((column) {
        if (column == '名称') {
          return '参数';
        }
        if (column == '必传') {
          return '必填';
        }
        return column;
      }).toList();
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
