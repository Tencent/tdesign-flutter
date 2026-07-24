import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/collapse/t_collapse_salted_key.dart';
import 'package:tdesign_flutter/src/components/collapse/t_nonanimated_expand_icon.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 t_collapse_salted_key.dart 的 toString 和 t_nonanimated_expand_icon.dart 的深色主题分支
void main() {
  group('TCollapseSaltedKey', () {
    test('toString 两个 String 泛型参数加引号', () {
      const key = TCollapseSaltedKey<String, String>('salt', 'value');
      final str = key.toString();
      expect(str, contains('salt'));
      expect(str, contains('value'));
    });

    test('toString 非 String 泛型参数不加引号', () {
      const key = TCollapseSaltedKey<int, int>(1, 2);
      final str = key.toString();
      expect(str, contains('1'));
      expect(str, contains('2'));
    });

    test('toString 混合泛型 String+int', () {
      const key = TCollapseSaltedKey<String, int>('hello', 42);
      final str = key.toString();
      expect(str, contains('hello'));
      expect(str, contains('42'));
    });

    test('toString 混合泛型 int+String', () {
      const key = TCollapseSaltedKey<int, String>(10, 'world');
      final str = key.toString();
      expect(str, contains('10'));
      expect(str, contains('world'));
    });

    test('== 相同参数返回 true', () {
      const k1 = TCollapseSaltedKey<String, int>('a', 1);
      const k2 = TCollapseSaltedKey<String, int>('a', 1);
      expect(k1 == k2, isTrue);
    });

    test('== 不同参数返回 false', () {
      const k1 = TCollapseSaltedKey<String, int>('a', 1);
      const k2 = TCollapseSaltedKey<String, int>('b', 2);
      expect(k1 == k2, isFalse);
    });
  });

  group('TNonAnimatedExpandIcon', () {
    testWidgets('深色主题下使用 secondary text token', (tester) async {
      final token = TThemeData.defaultData().dark!;
      await tester.pumpWidget(MaterialApp(
        theme: TThemeBuilder.dark(TThemeData.defaultData()),
        home: const Scaffold(
          body: TNonAnimatedExpandIcon(
              isExpanded: false, padding: EdgeInsets.zero),
        ),
      ));
      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.color, token.textColorSecondary);
    });

    testWidgets('浅色主题下使用 secondary text token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(MaterialApp(
        theme: TThemeBuilder.light(token),
        home: const Scaffold(
          body: TNonAnimatedExpandIcon(
              isExpanded: true, padding: EdgeInsets.zero),
        ),
      ));
      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.color, token.textColorSecondary);
    });
  });
}
