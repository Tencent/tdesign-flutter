import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TLink widget 级用例', () {
    testWidgets('basic 变体可构建', (tester) async {
      await tester.pumpWidget(wrap(const TLink(
        child: Text('普通链接'),
        onPressed: null,
      )));
      expect(find.byType(TLink), findsOneWidget);
      expect(find.text('普通链接'), findsOneWidget);
    });

    testWidgets('underline 变体可构建', (tester) async {
      await tester.pumpWidget(wrap(const TLink(
        variant: TLinkVariant.underline,
        child: Text('下划线'),
        onPressed: _noop,
      )));
      expect(find.byType(TLink), findsOneWidget);
    });

    testWidgets('icon 变体（前后图标）可构建', (tester) async {
      await tester.pumpWidget(wrap(const TLink(
        variant: TLinkVariant.icon,
        prefixIcon: Icon(Icons.arrow_back),
        suffixIcon: Icon(Icons.arrow_forward),
        child: Text('图标链接'),
        onPressed: _noop,
      )));
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('colorScheme / size / disabled / tooltip 可构建', (tester) async {
      await tester.pumpWidget(wrap(const Column(
        children: [
          TLink(
            child: Text('主色'),
            colorScheme: TLinkColorScheme.primary,
            size: TLinkSize.large,
            onPressed: _noop,
          ),
          TLink(
            child: Text('禁用'),
            onPressed: null,
          ),
          TLink(
            child: Text('提示'),
            tooltip: '提示文案',
            onPressed: _noop,
          ),
        ],
      )));
      expect(find.byType(TLink, skipOffstage: false), findsNWidgets(3));
    });
  });
}

void _noop() {}
