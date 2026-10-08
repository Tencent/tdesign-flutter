import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart' as md;

void main() {
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
      expect(tables, greaterThan(0));
      expect(source, startsWith('## API\n'));
      expect(source, isNot(contains('#### 简介')));
      expect(source, isNot(contains('#### 声明')));
      expect(source, isNot(contains('#### 默认构造方法')));
    });
  }
}
