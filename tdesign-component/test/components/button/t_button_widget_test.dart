import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TButton widget 级用例', () {
    testWidgets('默认文字样式使用 TDesign 字体 Token', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              labelLarge: TextStyle(fontFamily: 'TestFont'),
            ),
            extensions: [TThemeData.defaultData()],
          ),
          home: const Scaffold(
            body: TButton(onPressed: _noop, child: Text('Button')),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Button'));
      final defaultStyle = DefaultTextStyle.of(
        tester.element(find.text('Button')),
      );
      expect(text.style, isNull);
      expect(defaultStyle.style.fontFamily, 'Roboto');
    });

    testWidgets('fill 主色可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TButton(
            variant: TButtonVariant.fill,
            colorPreset: TButtonColorPreset.primary,
            onPressed: _noop,
            child: Text('填充'),
          ),
        ),
      );
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('outline / text / ghost 变体可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              TButton(
                variant: TButtonVariant.outline,
                onPressed: _noop,
                child: Text('描边'),
              ),
              TButton(
                variant: TButtonVariant.text,
                onPressed: _noop,
                child: Text('文字'),
              ),
              TButton(
                variant: TButtonVariant.ghost,
                onPressed: _noop,
                child: Text('幽灵'),
              ),
            ],
          ),
        ),
      );
      expect(find.byType(TButton, skipOffstage: false), findsNWidgets(3));
    });

    testWidgets('尺寸 / 危险配色 / 图标左 / 图标右', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              TButton(
                size: TButtonSize.small,
                colorPreset: TButtonColorPreset.danger,
                onPressed: _noop,
                child: Text('小'),
              ),
              TButton(
                icon: Icon(Icons.add),
                iconPosition: TButtonIconPosition.left,
                onPressed: _noop,
                child: Text('左图标'),
              ),
              TButton(
                icon: Icon(Icons.add),
                iconPosition: TButtonIconPosition.right,
                onPressed: _noop,
                child: Text('右图标'),
              ),
            ],
          ),
        ),
      );
      expect(find.byType(TButton, skipOffstage: false), findsNWidgets(3));
    });

    testWidgets('禁用态（onPressed 为 null）可构建', (tester) async {
      await tester.pumpWidget(
        wrap(const TButton(onPressed: null, child: Text('禁用'))),
      );
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('onLongPress 与点击并存且长按只触发长按回调', (tester) async {
      var taps = 0;
      var longPresses = 0;
      await tester.pumpWidget(
        wrap(
          TButton(
            child: const Text('长按'),
            onPressed: () => taps++,
            onLongPress: () => longPresses++,
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onLongPress, isNotNull);

      await tester.longPress(find.byType(ElevatedButton));
      expect(taps, 0);
      expect(longPresses, 1);

      await tester.tap(find.byType(ElevatedButton));
      expect(taps, 1);
      expect(longPresses, 1);
    });

    testWidgets('onPressed 为空时 onLongPress 也保持禁用', (tester) async {
      var longPresses = 0;
      await tester.pumpWidget(
        wrap(
          TButton(child: const Text('禁用长按'), onLongPress: () => longPresses++),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNull);
      expect(elevatedButton.onLongPress, isNull);

      await tester.longPress(find.byType(ElevatedButton));
      expect(longPresses, 0);
    });

    testWidgets('渐变按钮也支持长按且不会触发点击', (tester) async {
      var taps = 0;
      var longPresses = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              TThemeData.defaultData(),
              const TButtonThemeData(
                gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
              ),
            ],
          ),
          home: Scaffold(
            body: TButton(
              child: const Text('渐变长按'),
              onPressed: () => taps++,
              onLongPress: () => longPresses++,
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(InkWell));
      expect(taps, 0);
      expect(longPresses, 1);
    });

    testWidgets('Theme 的 iconTextSpacing 控制图标与文本的实际间距', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              TThemeData.defaultData(),
              const TButtonThemeData(iconTextSpacing: 20),
            ],
          ),
          home: const Scaffold(
            body: TButton(
              icon: Icon(Icons.add),
              onPressed: _noop,
              child: Text('间距'),
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 20 && widget.height == null,
        ),
        findsOneWidget,
      );
    });

    testWidgets('图标与文本默认使用 spacer4 间距', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const Scaffold(
            body: TButton(
              icon: Icon(Icons.add),
              onPressed: _noop,
              child: Text('间距'),
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 4 && widget.height == null,
        ),
        findsOneWidget,
      );
    });

    testWidgets('style 覆盖可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          TButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.amber),
            ),
            onPressed: _noop,
            child: const Text('覆盖'),
          ),
        ),
      );
      expect(find.byType(TButton), findsOneWidget);
    });
  });
}

void _noop() {}
