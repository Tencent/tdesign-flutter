import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;

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

  const frameworkMethods = {'build', 'createState', 'debugFillProperties'};
  for (final entry in exports.entries) {
    final name = entry.key;
    final path = entry.value;
    final node = nodes[name]!;
    final segments = p.split(path);
    final owner = segments.contains('components')
        ? owners[segments[segments.indexOf('components') + 1]]
        : 'theme';
    final members = <String>[];
    final constructors = <String>[];
    declarations[name] = {
      'owner': owner,
      'path': p.relative(path, from: root),
      'kind': node is FunctionDeclaration ? 'function' : 'type',
      'members': members,
      'constructors': constructors,
      'parameters': <Map<String, dynamic>>[],
    };
    void captureParameters(String callable, FormalParameterList? parameters) {
      if (parameters == null) {
        return;
      }
      for (final parameter in parameters.parameters) {
        (declarations[name]!['parameters'] as List).add({
          'callable': callable,
          'name': parameter.name?.lexeme,
          'offset': parameter.offset,
          'source': parameter.toSource(),
        });
      }
    }

    if (node is FunctionDeclaration) {
      captureParameters(name, node.functionExpression.parameters);
    }
    if (node.documentationComment == null) {
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
          captureParameters(member.name?.lexeme ?? '', member.parameters);
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
              frameworkMethods.contains(memberName)) {
            continue;
          }
          if (member.metadata.any((a) => a.name.name == 'override') &&
              member.documentationComment == null) {
            continue;
          }
          captureParameters(memberName, member.parameters);
          members.add(memberName);
          if (member.documentationComment == null &&
              !member.metadata.any((a) => a.name.name == 'override')) {
            issue('comment', '$name.$memberName', path, member.offset);
          }
        }
      }
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
    var headers = <String>[];
    var outputOwner = component['slug'] as String;
    for (final line in doc.split('\n')) {
      if (line.startsWith('### ')) {
        outputOwner = line.substring(4);
      }
      if (!line.startsWith('|')) {
        continue;
      }
      final cells = line
          .substring(1, line.length - 1)
          .split('|')
          .map((cell) => cell.trim())
          .toList();
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
      final section = doc.substring(start, next < 0 ? doc.length : next);
      for (final member in declaration['members'] as List<String>) {
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
            ? section.contains('#### 默认构造方法')
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
  for (final name in exports.keys.where((name) => !configured.contains(name))) {
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
    if (issues.isNotEmpty) {
      exitCode = 1;
    }
  }
}
