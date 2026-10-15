import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

// One-off evidence inventory; ignores external exports and inherited members.
void main(List<String> args) {
  final root = p.normalize(p.absolute(args.single));
  final units = <String, CompilationUnit>{};
  final localShadows = <Map<String, String>>[];
  final exportCollisions = <Map<String, String>>[];
  CompilationUnit unit(String file) => units.putIfAbsent(
    file,
    () => parseString(content: File(file).readAsStringSync(), path: file).unit,
  );
  Map<String, dynamic> library(String file, Set<String> visiting) {
    if (!visiting.add(file)) return {};
    final result = <String, dynamic>{};
    void collect(String source) {
      for (final node in unit(source).declarations) {
        if (node.metadata.any(
          (a) => {'internal', 'visibleForTesting'}.contains(a.name.name),
        ))
          continue;
        final names = node is TopLevelVariableDeclaration
            ? node.variables.variables.map((v) => v.name.lexeme)
            : node is ExtensionDeclaration
            ? [if (node.name != null) node.name!.lexeme]
            : node is NamedCompilationUnitMember
            ? [node.name.lexeme]
            : <String>[];
        for (final name in names.where((n) => !n.startsWith('_'))) {
          result[name] = {
            'path': p.relative(source, from: root),
            'line': unit(source).lineInfo.getLocation(node.offset).lineNumber,
            'kind': node.runtimeType.toString().replaceAll('Impl', ''),
          };
        }
      }
      for (final part in unit(source).directives.whereType<PartDirective>()) {
        collect(p.normalize(p.join(p.dirname(source), part.uri.stringValue!)));
      }
    }

    collect(file);
    final localNames = result.keys.toSet();
    for (final export in unit(file).directives.whereType<ExportDirective>()) {
      final uri = export.uri.stringValue!;
      if (uri.startsWith('package:') || uri.startsWith('dart:')) continue;
      final symbols = library(
        p.normalize(p.join(p.dirname(file), uri)),
        Set.of(visiting),
      );
      for (final c in export.combinators) {
        if (c is ShowCombinator) {
          final names = c.shownNames.map((n) => n.name).toSet();
          symbols.removeWhere((name, _) => !names.contains(name));
        } else if (c is HideCombinator) {
          final names = c.hiddenNames.map((n) => n.name).toSet();
          symbols.removeWhere((name, _) => names.contains(name));
        }
      }
      for (final entry in symbols.entries) {
        final existing = result[entry.key] as Map<String, dynamic>?;
        final incoming = entry.value as Map<String, dynamic>;
        if (existing != null && existing['path'] != incoming['path']) {
          (localNames.contains(entry.key) ? localShadows : exportCollisions)
              .add({
                'library': p.relative(file, from: root),
                'name': entry.key,
                'first': existing['path'] as String,
                'second': incoming['path'] as String,
              });
        }
        if (!localNames.contains(entry.key)) result[entry.key] = entry.value;
      }
    }
    return result;
  }

  final declarations = library(p.join(root, 'lib/tdesign_flutter.dart'), {});
  final files = units.keys.toList()..sort();
  stdout.writeln(
    const JsonEncoder.withIndent('  ').convert({
      'scope': 'Own exports only; no external exports or inherited members',
      'declarations': declarations,
      'localDeclarationsShadowingExports': localShadows,
      'exportCollisionsRequiringResolution': exportCollisions,
      'files': {
        for (final f in files)
          p.relative(f, from: root): sha256
              .convert(File(f).readAsBytesSync())
              .toString(),
      },
    }),
  );
}
