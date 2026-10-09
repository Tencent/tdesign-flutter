import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;

import '../../tool/api_doc_contract.dart';

void main() {
  final themes = <String, ClassDeclaration>{};
  for (final file in Directory(
    'lib/src/components',
  ).listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart')) {
      continue;
    }
    for (final node in parseString(
      content: file.readAsStringSync(),
    ).unit.declarations.whereType<ClassDeclaration>()) {
      if (!node.name.lexeme.startsWith('_') &&
          node.extendsClause?.superclass.name2.lexeme == 'ThemeExtension') {
        themes[node.name.lexeme] = node;
      }
    }
  }
  final manifest =
      jsonDecode(File('tool/components.json').readAsStringSync())
          as Map<String, dynamic>;
  final components = (manifest['components'] as List)
      .cast<Map<String, dynamic>>();

  for (final component in components) {
    final slug = component['slug'] as String;
    test('$slug preserves the Popup API presentation contract', () {
      final source = File(
        'example/assets/api/${slug}_api.md',
      ).readAsStringSync();
      expect(
        RegExp(
          r'小程序|mini[- ]?program|weapp',
          caseSensitive: false,
        ).hasMatch(source),
        isFalse,
        reason:
            '$slug must describe Flutter APIs without platform migration references',
      );
      final nodes = md.Document(
        extensionSet: md.ExtensionSet.gitHubFlavored,
      ).parseLines(source.split('\n'));
      final headings = <String>[];
      var tables = 0;
      void inspect(md.Node node) {
        if (node is! md.Element) {
          return;
        }
        if (node.tag == 'h3') {
          headings.add(node.textContent);
        }
        if (node.tag == 'table') {
          tables++;
          final head = node.children!.whereType<md.Element>().first;
          final row = head.children!.whereType<md.Element>().single;
          expect(row.children!.map((cell) => cell.textContent).toList(), [
            '名称',
            '类型',
            '默认值',
            '说明',
            '必传',
          ], reason: '$slug contains a non-uniform table');
        }
        if (node.tag == 'tr') {
          expect(node.children, hasLength(5), reason: '$slug has a broken row');
          final cells = node.children!;
          if (cells.first.textContent == '返回值') {
            expect(cells[1].textContent, isNot('-'));
            expect(cells[3].textContent, isNot('-'));
            expect(cells[3].textContent.trim(), isNotEmpty);
          }
        }
        expect(
          node.tag,
          isNot('pre'),
          reason: '$slug repeats source/example code',
        );
        for (final child in node.children ?? <md.Node>[]) {
          inspect(child);
        }
      }

      for (final node in nodes) {
        inspect(node);
      }
      final api = component['api'] as Map<String, dynamic>;
      final names = [...api['names'] as List, ...?api['functions'] as List?];
      expect(headings, unorderedEquals(names));
      var seenTheme = false;
      for (final name in headings) {
        final theme = themes[name];
        if (theme == null) {
          expect(
            seenTheme,
            isFalse,
            reason: '$slug: functional API $name follows Theme',
          );
          continue;
        }
        seenTheme = true;
        expect(
          isComponentThemeDeclaration(theme),
          isTrue,
          reason: '$slug: source Theme category is missing',
        );
        final start = source.indexOf('### $name\n');
        final end = source.indexOf('\n### ', start + 1);
        final section = source.substring(start, end < 0 ? source.length : end);
        final introLines = theme.documentationComment!.tokens
            .map((token) => token.lexeme)
            .where(
              (line) => line.startsWith('/// ') && !line.contains('{@category'),
            )
            .toList();
        expect(
          introLines,
          isNotEmpty,
          reason: '$slug: Theme introduction was lost',
        );
        final intro = introLines.first
            .substring(4)
            .replaceAll(RegExp(r'[`\[\]]'), '');
        final renderedText =
            md.Document(extensionSet: md.ExtensionSet.gitHubFlavored)
                .parseLines(section.split('\n'))
                .map((node) => node.textContent)
                .join('\n');
        expect(
          renderedText,
          contains(intro),
          reason: '$slug: Theme introduction is missing from output',
        );
        expect(isComponentThemeConfiguration(theme, section), isTrue);
        expect(
          RegExp(r'^#### 配置项$', multiLine: true).allMatches(section),
          hasLength(1),
        );
        expect(section, isNot(contains('##### $name\n')));
        for (final method in theme.members.whereType<MethodDeclaration>()) {
          if (!method.isStatic &&
              const {
                'copyWith',
                'lerp',
                'merge',
              }.contains(method.name.lexeme)) {
            expect(
              section,
              isNot(contains('##### $name.${method.name.lexeme}\n')),
            );
          }
        }
      }
      expect(tables, greaterThan(0));
      expect(source, startsWith('## API\n'));
      expect(source, isNot(contains('#### 简介')));
      expect(source, isNot(contains('#### 声明')));
      expect(source, isNot(contains('#### 默认构造方法')));
    });
  }
}
