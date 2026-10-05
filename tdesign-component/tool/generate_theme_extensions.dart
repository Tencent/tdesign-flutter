import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// Appends public extension contracts to the generated Theme API document.
/// Uses the root exports as the public boundary, including show/hide filters.
String themeExtensionDocs(
  String source, {
  Set<String>? shown,
  Set<String> hidden = const {},
}) {
  final unit = parseString(content: source).unit;
  final output = StringBuffer();
  for (final declaration
      in unit.declarations.whereType<ExtensionDeclaration>()) {
    final name = declaration.name?.lexeme;
    if (name == null ||
        name.startsWith('_') ||
        hidden.contains(name) ||
        (shown != null && !shown.contains(name))) {
      continue;
    }
    output.writeln('\n## $name\n');
    final comment = declaration.documentationComment?.tokens
        .map((token) => token.lexeme)
        .join('\n');
    if (comment != null) {
      output.writeln(_commentText(comment));
    }
    output.writeln(
      '\n`extension $name on ${declaration.onClause!.extendedType.toSource()}`\n',
    );
    for (final member in declaration.members) {
      if (member is MethodDeclaration && !member.name.lexeme.startsWith('_')) {
        output.writeln('### ${member.name.lexeme}\n');
        final doc = member.documentationComment?.tokens
            .map((token) => token.lexeme)
            .join('\n');
        if (doc != null) {
          output.writeln(_commentText(doc));
        }
        final signature = source.substring(
          member.firstTokenAfterCommentAndMetadata.offset,
          member.body.offset,
        );
        output.writeln('\n```dart\n${signature.trim()}\n```\n');
      } else if (member is FieldDeclaration) {
        for (final field in member.fields.variables) {
          if (field.name.lexeme.startsWith('_')) {
            continue;
          }
          output.writeln('### ${field.name.lexeme}\n');
          final doc = member.documentationComment?.tokens
              .map((token) => token.lexeme)
              .join('\n');
          if (doc != null) {
            output.writeln(_commentText(doc));
          }
          output.writeln(
            '\n```dart\n${member.fields.type?.toSource() ?? 'dynamic'} ${field.name.lexeme}\n```\n',
          );
        }
      }
    }
  }
  return output.toString();
}

String _commentText(String text) => text
    .split('\n')
    .map((line) => line.replaceFirst(RegExp(r'^\s*/// ?'), ''))
    .join('\n');

void main() {
  final root = File('lib/tdesign_flutter.dart');
  final exports = parseString(
    content: root.readAsStringSync(),
  ).unit.directives.whereType<ExportDirective>();
  final output = StringBuffer();
  for (final directive in exports) {
    final uri = directive.uri.stringValue;
    if (uri == null || !uri.startsWith('src/theme/')) {
      continue;
    }
    Set<String>? shown;
    final hidden = <String>{};
    for (final combinator in directive.combinators) {
      if (combinator is ShowCombinator) {
        final names = combinator.shownNames.map((name) => name.name).toSet();
        shown = shown == null ? names : shown.intersection(names);
      } else if (combinator is HideCombinator) {
        hidden.addAll(combinator.hiddenNames.map((name) => name.name));
      }
    }
    output.write(
      themeExtensionDocs(
        File('lib/$uri').readAsStringSync(),
        shown: shown,
        hidden: hidden,
      ),
    );
  }
  final target = File('example/assets/api/theme_api.md');
  target.writeAsStringSync(
    '${'${target.readAsStringSync()}$output'.trimRight()}\n',
  );
}
