import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'tab_bar_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(tabBarDemoPageTestSpec);

  test('tab_bar generated snippets expose reproducible public API usage', () {
    const snippetNames = [
      '_textTabBar',
      '_iconTextTabBar',
      '_iconTabBar',
      '_doubleLayerTabBar',
      '_weakTabBars',
      '_capsuleTabBar',
      '_customTabBar',
    ];

    for (final name in snippetNames) {
      final snippet = File('assets/code/tabBar.$name.txt').readAsStringSync();
      expect(snippet, contains('TTabBar('), reason: name);
      expect(snippet, isNot(contains('_DemoTabBar')), reason: name);
    }
  });
}
