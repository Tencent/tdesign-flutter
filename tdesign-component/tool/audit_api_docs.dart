import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;

import 'api_doc_contract.dart';

/// Checks the API manifest against this package's public exports and dartdoc.
/// Run with --json for a source-location inventory, or --sync to update scope.
void main(List<String> args) {
  final root = File.fromUri(Platform.script).parent.parent.path;
  final declarations = <String, Map<String, dynamic>>{};
  final nodes = <String, Declaration>{};
  final units = <String, CompilationUnit>{};
  CompilationUnit unit(String path) => units.putIfAbsent(
    path,
    () => parseString(content: File(path).readAsStringSync(), path: path).unit,
  );
  Map<String, String> library(String path, Set<String> visiting) {
    if (!visiting.add(path)) {
      return <String, String>{};
    }
    final result = <String, String>{};
    void collect(String source) {
      final parsed = unit(source);
      for (final node in parsed.declarations) {
        if (node.metadata.any(
          (annotation) => const {
            'internal',
            'visibleForTesting',
          }.contains(annotation.name.name),
        )) {
          continue;
        }
        if (node is TopLevelVariableDeclaration) {
          for (final variable in node.variables.variables) {
            final name = variable.name.lexeme;
            if (name.startsWith('_')) {
              continue;
            }
            result[name] = source;
            nodes[name] = node;
          }
          continue;
        }
        String? name;
        if (node is NamedCompilationUnitMember) {
          name = node.name.lexeme;
        }
        if (node is ExtensionDeclaration) {
          name = node.name?.lexeme;
        }
        if (name == null || name.startsWith('_')) {
          continue;
        }
        result[name] = source;
        nodes[name] = node;
      }
      for (final part in parsed.directives.whereType<PartDirective>()) {
        collect(p.normalize(p.join(p.dirname(source), part.uri.stringValue!)));
      }
    }

    collect(path);
    for (final export in unit(path).directives.whereType<ExportDirective>()) {
      final uri = export.uri.stringValue!;
      if (uri.startsWith('package:') || uri.startsWith('dart:')) {
        continue;
      }
      final symbols = library(
        p.normalize(p.join(p.dirname(path), uri)),
        Set<String>.of(visiting),
      );
      for (final combinator in export.combinators) {
        if (combinator is ShowCombinator) {
          final names = combinator.shownNames.map((n) => n.name).toSet();
          symbols.removeWhere((name, _) => !names.contains(name));
        }
        if (combinator is HideCombinator) {
          final names = combinator.hiddenNames.map((n) => n.name).toSet();
          symbols.removeWhere((name, _) => names.contains(name));
        }
      }
      result.addAll(symbols);
    }
    return result;
  }

  final exports = library(p.join(root, 'lib/tdesign_flutter.dart'), <String>{});
  final manifestFile = File(p.join(root, 'tool/components.json'));
  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
  final components = (manifest['components'] as List)
      .cast<Map<String, dynamic>>();
  final selectedComponents = args
      .where((arg) => arg.startsWith('--components='))
      .expand((arg) => arg.substring('--components='.length).split(','))
      .toSet();
  if (selectedComponents.isNotEmpty && args.contains('--sync')) {
    throw ArgumentError('Scoped auditing cannot synchronize the manifest.');
  }
  final knownComponents = components.map((item) => item['slug']).toSet();
  if (!knownComponents.containsAll(selectedComponents)) {
    throw ArgumentError('Unknown audit component: $selectedComponents');
  }
  final owners = <String, String>{};
  for (final component in components) {
    final path = component['source']['path'] as String;
    final segments = p.split(path);
    if (segments.contains('components')) {
      owners[segments[segments.indexOf('components') + 1]] =
          component['slug'] as String;
    }
  }
  final issues = <Map<String, dynamic>>[];
  void issue(String category, String name, String path, int offset) {
    final line = File(
      path,
    ).readAsStringSync().substring(0, offset).split('\n').length;
    issues.add({
      'category': category,
      'name': name,
      'path': p.relative(path, from: root),
      'line': line,
    });
  }

  for (final entry in exports.entries) {
    final name = entry.key;
    final path = entry.value;
    final node = nodes[name]!;
    final segments = p.split(path);
    final owner = segments.contains('components')
        ? owners[segments[segments.indexOf('components') + 1]]
        : 'theme';
    if (selectedComponents.isNotEmpty && !selectedComponents.contains(owner)) {
      continue;
    }
    final members = <String>[];
    final constructors = <String>[];
    declarations[name] = {
      'owner': owner,
      'path': p.relative(path, from: root),
      'kind': node is FunctionDeclaration ? 'function' : 'type',
      'members': members,
      'constructors': constructors,
      'parameters': <Map<String, dynamic>>[],
      'callables': <String, Map<String, dynamic>>{},
      'declaration': node is ClassDeclaration
          ? signatureTokens(node, node.leftBracket.offset)
          : node is ExtensionDeclaration
          ? signatureTokens(node, node.leftBracket.offset)
          : null,
      'typeParameters': node is ClassDeclaration
          ? node.typeParameters?.typeParameters
                .map((p) => p.toSource())
                .join(', ')
          : node is ExtensionDeclaration
          ? node.typeParameters?.typeParameters
                .map((p) => p.toSource())
                .join(', ')
          : null,
      'onType': node is ExtensionDeclaration
          ? node.onClause?.extendedType.toSource()
          : null,
    };
    void captureParameters(
      String callable,
      FormalParameterList? parameters, {
      AnnotatedNode? declaration,
    }) {
      if (parameters == null) {
        return;
      }
      final captured = <Map<String, dynamic>>[];
      final contract = declaration == null
          ? null
          : callableContract(declaration);
      (declarations[name]!['callables'] as Map)[callable] = {
        'parameters': captured,
        'signature': declaration == null
            ? null
            : signatureTokens(declaration, parameters.end),
        'parameterShape': contract?.shape,
        'typeParameters': contract?.typeParameters,
        'returnType': contract?.returnType,
        if (declaration is ConstructorDeclaration)
          'constructorShape': contract!.shape,
      };
      for (final parameter in parameters.parameters) {
        final row = <String, dynamic>{
          'callable': callable,
          'name': parameter.name?.lexeme,
          'offset': parameter.offset,
          'source': parameter.toSource(),
          'type': parameterType(parameter, node, nodes),
          'default': parameterDefault(parameter, node, nodes),
          'required': parameter.isRequired,
          'named': parameter.isNamed,
        };
        captured.add(row);
        (declarations[name]!['parameters'] as List).add(row);
      }
    }

    if (node is FunctionDeclaration) {
      captureParameters(
        name,
        node.functionExpression.parameters,
        declaration: node,
      );
    }
    // 类入口可以直接展示参数表；字段和可调用契约仍逐项检查。
    if (node is! ClassDeclaration && node.documentationComment == null) {
      issue('comment', name, path, node.offset);
    }
    final membersToCheck = node is ClassDeclaration
        ? node.members
        : node is ExtensionDeclaration
        ? node.members
        : <ClassMember>[];
    if (membersToCheck.isNotEmpty) {
      for (final member in membersToCheck) {
        if (member.metadata.any(
          (a) =>
              a.name.name == 'internal' || a.name.name == 'visibleForTesting',
        )) {
          continue;
        }
        if (member is ConstructorDeclaration) {
          if (member.name?.lexeme.startsWith('_') ?? false) {
            continue;
          }
          captureParameters(
            member.name?.lexeme ?? '',
            member.parameters,
            declaration: member,
          );
          if (member.name == null) {
            constructors.add('');
          }
          if (member.name != null && !member.name!.lexeme.startsWith('_')) {
            constructors.add(member.name!.lexeme);
          }
        }
        if (member is FieldDeclaration) {
          for (final variable in member.fields.variables) {
            final memberName = variable.name.lexeme;
            if (memberName.startsWith('_')) {
              continue;
            }
            members.add(memberName);
            if (member.documentationComment == null) {
              issue('comment', '$name.$memberName', path, member.offset);
            }
          }
        }
        if (member is MethodDeclaration) {
          final memberName = member.name.lexeme;
          if (memberName.startsWith('_') ||
              isFrameworkApiHook(member, node, nodes)) {
            continue;
          }
          if (!member.isGetter && !member.isSetter) {
            captureParameters(
              memberName,
              member.parameters,
              declaration: member,
            );
          }
          members.add(memberName);
          if (member.documentationComment == null) {
            issue('comment', '$name.$memberName', path, member.offset);
          }
        }
      }
    }
    if (node is ClassDeclaration &&
        node.abstractKeyword == null &&
        !node.members.any((m) => m is ConstructorDeclaration)) {
      constructors.add('');
      (declarations[name]!['callables'] as Map)[''] = {
        'parameters': <Map<String, dynamic>>[],
        'signature': lexicalTokens('$name()'),
        'constructorShape': '',
        'parameterShape': '',
        'typeParameters': '',
      };
    }
    if (node is EnumDeclaration) {
      for (final constant in node.constants) {
        members.add(constant.name.lexeme);
        if (constant.documentationComment == null) {
          issue(
            'comment',
            '$name.${constant.name.lexeme}',
            path,
            constant.offset,
          );
        }
      }
    }
  }
  if (args.contains('--sync')) {
    for (final component in components) {
      final slug = component['slug'];
      final owned = declarations.entries
          .where((e) => e.value['owner'] == slug)
          .toList();
      final oldNames = (component['api']['names'] as List).cast<String>();
      final names =
          owned
              .where((e) => e.value['kind'] == 'type')
              .map((e) => e.key)
              .toList()
            ..sort((a, b) {
              final ai = oldNames.indexOf(a);
              final bi = oldNames.indexOf(b);
              return (ai < 0 ? oldNames.length : ai).compareTo(
                bi < 0 ? oldNames.length : bi,
              );
            });
      component['api']['names'] = names;
      final functions = owned
          .where((e) => e.value['kind'] == 'function')
          .map((e) => e.key)
          .toList();
      component['api'].remove('functions');
      if (functions.isNotEmpty) {
        component['api']['functions'] = functions;
      }
      component['api']['getComments'] = true;
      final source = component['source'];
      source['path'] = slug == 'theme'
          ? 'lib/src'
          : p.dirname(owned.first.value['path'] as String);
      source['type'] = 'folder';
    }
    manifestFile.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
    );
  }
  final configured = <String>{};
  for (final component in components) {
    if (selectedComponents.isNotEmpty &&
        !selectedComponents.contains(component['slug'])) {
      continue;
    }
    for (final name in [
      ...component['api']['names'],
      ...?component['api']['functions'],
    ]) {
      if (!configured.add(name as String)) {
        issue(
          'duplicate-scope',
          name,
          p.join(root, 'lib/tdesign_flutter.dart'),
          0,
        );
      }
      if (!declarations.containsKey(name)) {
        issue('stale-scope', name, p.join(root, 'lib/tdesign_flutter.dart'), 0);
      } else if (declarations[name]!['owner'] != component['slug']) {
        issue('wrong-owner', name, exports[name]!, nodes[name]!.offset);
      }
    }
    final docFile = File(
      p.join(root, 'example/assets/api/${component['slug']}_api.md'),
    );
    final doc = docFile.existsSync() ? docFile.readAsStringSync() : '';
    var seenComponentTheme = false;
    for (final heading in RegExp(
      r'^### (.+)$',
      multiLine: true,
    ).allMatches(doc)) {
      final name = heading.group(1)!;
      final node = nodes[name];
      if (isComponentThemeDeclaration(node)) {
        seenComponentTheme = true;
      } else if (seenComponentTheme && node != null) {
        issue('output-theme-order', name, exports[name]!, node.offset);
      }
    }
    var headers = <String>[];
    var outputOwner = component['slug'] as String;
    for (final line in apiContractLines(doc)) {
      if (line.startsWith('### ')) {
        outputOwner = line.substring(4);
      }
      if (!line.startsWith('|')) {
        headers = <String>[];
        continue;
      }
      final cells = tableCells(line);
      if (cells.isNotEmpty && const {'参数', '名称', '属性'}.contains(cells.first)) {
        headers = cells;
        continue;
      }
      if (cells.length != headers.length ||
          cells.isEmpty ||
          cells.first.replaceAll('-', '').isEmpty) {
        continue;
      }
      for (final column in const ['说明', '类型']) {
        final index = headers.indexOf(column);
        if (index >= 0 && (cells[index].isEmpty || cells[index] == '-')) {
          issue(
            'output-empty-$column',
            '$outputOwner.${cells.first}',
            exports[outputOwner] ?? p.join(root, 'lib/tdesign_flutter.dart'),
            nodes[outputOwner]?.offset ?? 0,
          );
        }
      }
    }
    for (final name in [
      ...component['api']['names'],
      ...?component['api']['functions'],
    ]) {
      if (!doc.contains('### $name\n')) {
        issue(
          'output-type',
          name as String,
          p.join(root, 'lib/tdesign_flutter.dart'),
          0,
        );
      }
      final declaration = declarations[name];
      if (declaration == null) {
        continue;
      }
      final start = doc.indexOf('### $name\n');
      if (start < 0) {
        continue;
      }
      final next = doc.indexOf('\n### ', start + 1);
      var section = doc.substring(start, next < 0 ? doc.length : next);
      final sourceNode = nodes[name];
      final themeConfiguration = isComponentThemeConfiguration(
        sourceNode,
        section,
      );
      if (isComponentThemeDeclaration(sourceNode) && !themeConfiguration) {
        issue(
          'output-theme-configuration',
          name,
          exports[name]!,
          sourceNode!.offset,
        );
      }
      if (themeConfiguration) {
        if (RegExp(r'^#### 配置项$', multiLine: true).allMatches(section).length !=
                1 ||
            '<!-- api-theme: fields -->'.allMatches(section).length != 1) {
          issue(
            'output-theme-configuration',
            name,
            exports[name]!,
            sourceNode!.offset,
          );
        }
        for (final method
            in (sourceNode as ClassDeclaration).members
                .whereType<MethodDeclaration>()) {
          if (!method.isStatic &&
              const {
                'copyWith',
                'lerp',
                'merge',
              }.contains(method.name.lexeme) &&
              section.contains('##### $name.${method.name.lexeme}\n')) {
            issue(
              'output-theme-shared-method',
              name,
              exports[name]!,
              sourceNode.offset,
            );
          }
        }
      }
      if (section.contains('<!-- api-theme: fields -->')) {
        if (!themeConfiguration) {
          issue(
            'output-theme-classification',
            name,
            exports[name]!,
            sourceNode!.offset,
          );
          continue;
        }
        section = section.replaceFirst(
          '#### 配置项\n',
          '#### 构造方法\n\n##### $name\n',
        );
      }
      if (sourceNode is GenericTypeAlias) {
        for (final failure in typedefDocumentationIssues(sourceNode, section)) {
          issue(
            'output-typedef-$failure',
            name,
            exports[name]!,
            sourceNode.offset,
          );
        }
        continue;
      }
      final declarationTokens = declaration['declaration'] as List<String>?;
      // Legacy assets contain full declarations. Compact API pages retain only
      // type parameters and extension receivers. Compact callable contracts
      // and legacy signatures are independently compared with the source.
      if (section.contains('#### 声明\n') &&
          declarationTokens != null &&
          !containsSignature(section, declarationTokens)) {
        issue('output-signature', name, exports[name]!, nodes[name]!.offset);
      }
      if (!section.contains('#### 声明\n')) {
        for (final entry in {
          'typeParameters': '类型参数',
          'onType': '适用类型',
        }.entries) {
          final expected = declaration[entry.key] as String?;
          if (expected == null || expected.isEmpty) {
            continue;
          }
          final actual = RegExp(
            '^${entry.value}：`([^`]+)`',
            multiLine: true,
          ).firstMatch(section)?.group(1);
          if (actual == null || !sameCode(actual, expected)) {
            issue(
              'output-signature',
              name,
              exports[name]!,
              nodes[name]!.offset,
            );
          }
        }
      }
      for (final entry in (declaration['callables'] as Map).entries) {
        final callable = entry.key as String;
        if (themeConfiguration &&
            const {'copyWith', 'lerp', 'merge'}.contains(callable) &&
            (sourceNode as ClassDeclaration).members
                .whereType<MethodDeclaration>()
                .any(
                  (method) =>
                      !method.isStatic && method.name.lexeme == callable,
                )) {
          continue;
        }
        String callableSection;
        if (declaration['kind'] == 'function') {
          callableSection = section;
        } else {
          final groupedDefault =
              callable.isEmpty && section.contains('##### $name\n');
          final heading = callable.isEmpty
              ? groupedDefault
                    ? '##### $name'
                    : '#### 默认构造方法'
              : '##### $name.$callable';
          final pos = section.indexOf('$heading\n');
          if (pos < 0) {
            issue(
              'output-callable',
              '$name.$callable',
              exports[name]!,
              nodes[name]!.offset,
            );
            continue;
          }
          final tail = section.substring(pos + heading.length + 1);
          final boundary = RegExp(
            callable.isEmpty && !groupedDefault
                ? r'^#### (?!参数$)'
                : r'^####(?:#)? (?!参数$)',
            multiLine: true,
          ).firstMatch(tail);
          callableSection = boundary == null
              ? tail
              : tail.substring(0, boundary.start);
        }
        final expected = entry.value['parameters'] as List;
        final expectedSignature = entry.value['signature'] as List<String>?;
        final hasSignature = RegExp(
          r'^```dart\n',
          multiLine: true,
        ).hasMatch(callableSection);
        bool matchesInline(String label, String? expected) {
          if (expected == null) {
            return true;
          }
          final actual = RegExp(
            '^$label：`([^`]+)`',
            multiLine: true,
          ).firstMatch(callableSection)?.group(1);
          return expected.isEmpty
              ? actual == null
              : actual != null && sameCode(actual, expected);
        }

        final expectedReturnType = entry.value['returnType'] as String?;
        final actualReturnType = documentedReturnType(callableSection);
        final hasReturnContract = RegExp(
          r'^#{4,6} 返回值[ \t]*$|^返回类型：`',
          multiLine: true,
        ).hasMatch(callableSection);
        final validReturn =
            expectedReturnType == null ||
            (expectedReturnType == 'void' && !hasReturnContract) ||
            (actualReturnType != null &&
                sameCode(actualReturnType, expectedReturnType));
        final validContract = hasSignature
            ? expectedSignature == null ||
                  containsSignature(callableSection, expectedSignature)
            : matchesInline('位置参数', entry.value['parameterShape'] as String?) &&
                  matchesInline(
                    '类型参数',
                    entry.value['typeParameters'] as String?,
                  ) &&
                  validReturn;
        if (!validContract) {
          issue(
            'output-signature',
            '$name.$callable',
            exports[name]!,
            nodes[name]!.offset,
          );
        }
        final rows = parameterRows(callableSection);
        for (final parameter in expected.cast<Map<String, dynamic>>()) {
          final paramName = parameter['name'];
          final found = rows.where((r) => r['参数'] == paramName).toList();
          final label = '$name.$callable.$paramName';
          if (found.length != 1) {
            issue(
              'output-parameter-count',
              label,
              exports[name]!,
              parameter['offset'] as int,
            );
            continue;
          }
          for (final column in const ['类型', '默认值', '必填']) {
            final value = column == '类型'
                ? parameter['type'] as String
                : column == '默认值'
                ? parameter['default'] as String
                : parameter['required'] == true
                ? '是'
                : '否';
            if (!sameCode(found.single[column] ?? '', value)) {
              issue(
                'output-parameter-$column',
                label,
                exports[name]!,
                parameter['offset'] as int,
              );
            }
          }
        }
        final expectedNames = expected.map((p) => p['name']).toSet();
        for (final row in rows) {
          if (!expectedNames.contains(row['参数'])) {
            issue(
              'output-extra-parameter',
              '$name.$callable.${row['参数']}',
              exports[name]!,
              nodes[name]!.offset,
            );
          }
        }
      }
      for (final member in declaration['members'] as List<String>) {
        if (themeConfiguration &&
            const {'copyWith', 'lerp', 'merge'}.contains(member) &&
            (sourceNode as ClassDeclaration).members
                .whereType<MethodDeclaration>()
                .any(
                  (method) => !method.isStatic && method.name.lexeme == member,
                )) {
          continue;
        }
        if (!section.contains('| $member |') &&
            !section.contains('##### $name.$member\n')) {
          issue(
            'output-member',
            '$name.$member',
            exports[name]!,
            nodes[name]!.offset,
          );
        }
      }
      for (final constructor in declaration['constructors'] as List<String>) {
        if (!(constructor.isEmpty
            ? section.contains('##### $name\n') ||
                  section.contains('#### 默认构造方法')
            : section.contains('##### $name.$constructor\n'))) {
          issue(
            'output-constructor',
            constructor.isEmpty ? '$name()' : '$name.$constructor',
            exports[name]!,
            nodes[name]!.offset,
          );
        }
      }
    }
  }
  for (final name in exports.keys.where(
    (name) =>
        !configured.contains(name) &&
        (selectedComponents.isEmpty || declarations.containsKey(name)),
  )) {
    issue('scope', name, exports[name]!, nodes[name]!.offset);
  }
  if (args.contains('--json')) {
    stdout.writeln(
      const JsonEncoder.withIndent(
        '  ',
      ).convert({'declarations': declarations, 'issues': issues}),
    );
  } else {
    for (final item in issues) {
      stdout.writeln(
        '${item['path']}:${item['line']} ${item['category']}: ${item['name']}',
      );
    }
    stdout.writeln(
      '${components.length} components; ${exports.length} public declarations; ${issues.length} issues',
    );
  }
  if (issues.isNotEmpty) {
    exitCode = 1;
  }
}
