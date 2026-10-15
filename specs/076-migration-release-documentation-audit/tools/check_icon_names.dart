import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:crypto/crypto.dart';

void main(List<String> args) {
  Map<String, dynamic> fields(String path, String name) {
    final source = File(path).readAsStringSync();
    final declaration = parseString(content: source).unit.declarations
        .whereType<ClassDeclaration>()
        .singleWhere((c) => c.name.lexeme == name);
    return {
      'sha256': sha256.convert(utf8.encode(source)).toString(),
      'names':
          declaration.members
              .whereType<FieldDeclaration>()
              .where((field) => field.isStatic)
              .expand((field) => field.fields.variables)
              .map((variable) => variable.name.lexeme)
              .where((name) => !name.startsWith('_'))
              .toList()
            ..sort(),
    };
  }

  final old = fields(args[0], 'TDIcons');
  final current = fields(args[1], 'TIcons');
  final oldNames = (old['names'] as List<String>).where((n) => n != 'all');
  final currentNames = (current['names'] as List<String>).toSet();
  final missing = oldNames.where((n) => !currentNames.contains(n)).toList();
  stdout.writeln(
    const JsonEncoder.withIndent('  ').convert({
      'scope':
          'Static symbol names only; no glyph geometry/font raster equivalence',
      'oldSourceSha256': old['sha256'],
      'currentIconsVersion': '0.0.6',
      'currentSourceSha256': current['sha256'],
      'oldNames': oldNames.length,
      'missingNames': missing,
      'oldAggregateAll': (old['names'] as List<String>).contains('all'),
      'currentAggregateAllIconsMap': currentNames.contains('allIconsMap'),
      'disposition':
          'Missing names and aggregate key changes require explicit guide review; this report does not certify glyph replacement.',
    }),
  );
}
