import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TButton widget 级用例', () {
    testWidgets('默认文字样式继承 ThemeData labelLarge 字体族', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            labelLarge: TextStyle(fontFamily: 'TestFont'),
          ),
          extensions: [TThemeData.defaultData()],
        ),
        home: const Scaffold(
          body: TButton(child: Text('Button'), onPressed: _noop),
        ),
      ));

      final text = tester.widget<Text>(find.text('Button'));
      final defaultStyle =
          DefaultTextStyle.of(tester.element(find.text('Button')));
      expect(text.style, isNull);
      expect(defaultStyle.style.fontFamily, 'TestFont');
    });

    testWidgets('fill 主色可构建', (tester) async {
      await tester.pumpWidget(wrap(const TButton(
        child: Text('填充'),
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: _noop,
      )));
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('outline / text / ghost 变体可构建', (tester) async {
      await tester.pumpWidget(wrap(const Column(
        children: [
          TButton(
              child: Text('描边'),
              variant: TButtonVariant.outline,
              onPressed: _noop),
          TButton(
              child: Text('文字'),
              variant: TButtonVariant.text,
              onPressed: _noop),
          TButton(
              child: Text('幽灵'),
              variant: TButtonVariant.ghost,
              onPressed: _noop),
        ],
      )));
      expect(find.byType(TButton, skipOffstage: false), findsNWidgets(3));
    });

    testWidgets('尺寸 / 危险配色 / 图标左 / 图标右', (tester) async {
      await tester.pumpWidget(wrap(const Column(
        children: [
          TButton(
            child: Text('小'),
            size: TButtonSize.small,
            colorScheme: TButtonColorScheme.danger,
            onPressed: _noop,
          ),
          TButton(
            icon: Icon(Icons.add),
            child: Text('左图标'),
            iconPosition: TButtonIconPosition.left,
            onPressed: _noop,
          ),
          TButton(
            icon: Icon(Icons.add),
            child: Text('右图标'),
            iconPosition: TButtonIconPosition.right,
            onPressed: _noop,
          ),
        ],
      )));
      expect(find.byType(TButton, skipOffstage: false), findsNWidgets(3));
    });

    testWidgets('禁用态（onPressed 为 null）可构建', (tester) async {
      await tester.pumpWidget(wrap(const TButton(
        child: Text('禁用'),
        onPressed: null,
      )));
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('style 覆盖可构建', (tester) async {
      await tester.pumpWidget(wrap(TButton(
        child: const Text('覆盖'),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.amber),
        ),
        onPressed: _noop,
      )));
      expect(find.byType(TButton), findsOneWidget);
    });
  });
}

void _noop() {}
