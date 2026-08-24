import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/text/t_text_resolve.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Future<BuildContext> pumpContext(
    WidgetTester tester, {
    ThemeData? theme,
    Widget Function(Widget)? wrap,
  }) async {
    final child = Builder(builder: (_) => const SizedBox());
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(body: wrap?.call(child) ?? child),
      ),
    );
    return tester.element(find.byWidget(child));
  }

  testWidgets('解析优先级遵循 Flutter merge 链', (tester) async {
    final context = await pumpContext(
      tester,
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          TTextThemeData(
            font: Font(size: 18, lineHeight: 26),
            textStyle: const TextStyle(color: Colors.orange),
          ),
        ],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.indigo, fontSize: 17),
        ),
      ),
      wrap: (child) => DefaultTextStyle(
        style: const TextStyle(
          color: Colors.pink,
          fontSize: 19,
          decoration: TextDecoration.underline,
        ),
        child: child,
      ),
    );

    final resolved = TTextResolve.resolve(
      context: context,
      font: Font(size: 20, lineHeight: 28),
      textColor: Colors.green,
      style: const TextStyle(color: Colors.red, fontSize: 22),
    );
    expect(resolved.color, Colors.red);
    expect(resolved.fontSize, 22);
    expect(resolved.height, 28 / 20);
    expect(resolved.decoration, TextDecoration.underline);
    expect(resolved.inherit, isFalse);
  });

  testWidgets('inherit false 不继承 Theme 与 Token', (tester) async {
    final context = await pumpContext(tester);
    const style = TextStyle(inherit: false, fontSize: 13);
    final resolved = TTextResolve.resolve(context: context, style: style);
    expect(resolved, style);
  });

  testWidgets('foreground 与背景 Paint 不和颜色字段冲突', (tester) async {
    final context = await pumpContext(tester);
    final foreground = Paint()..color = Colors.purple;
    final background = Paint()..color = Colors.yellow;
    final resolved = TTextResolve.resolve(
      context: context,
      style: TextStyle(foreground: foreground, background: background),
    );
    expect(resolved.foreground, foreground);
    expect(resolved.color, isNull);
    expect(resolved.background, background);
    expect(resolved.backgroundColor, isNull);
  });

  testWidgets('Theme font 先于 textStyle，实例便利参数继续覆盖', (tester) async {
    final context = await pumpContext(
      tester,
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          TTextThemeData(
            font: Font(size: 18, lineHeight: 26),
            textStyle: const TextStyle(fontSize: 21, color: Colors.orange),
          ),
        ],
      ),
    );
    final themed = TTextResolve.resolve(context: context);
    expect(themed.fontSize, 21);
    expect(themed.height, 26 / 18);
    expect(themed.color, Colors.orange);

    final instance = TTextResolve.resolve(
      context: context,
      font: Font(size: 24, lineHeight: 32),
      textColor: Colors.blue,
    );
    expect(instance.fontSize, 24);
    expect(instance.height, 32 / 24);
    expect(instance.color, Colors.blue);
  });

  test('裸 TTextSpan 不生成样式并继承父 Span', () {
    expect(TTextResolve.resolveSpan(), isNull);
  });

  test('TTextSpan 只生成显式字段且 style 最高优先', () {
    final resolved = TTextResolve.resolveSpan(
      textColor: Colors.blue,
      isTextThrough: true,
      style: const TextStyle(color: Colors.red),
    );
    expect(resolved?.color, Colors.red);
    expect(resolved?.fontSize, isNull);
    expect(resolved?.decoration, TextDecoration.lineThrough);
  });

  test('FontFamily 同时透传字体族和 package', () {
    final resolved = TTextResolve.resolveSpan(
      fontFamily: FontFamily(
        fontFamily: 'TDesignTestFont',
        package: 'tdesign_test_package',
      ),
    );

    expect(
      resolved?.fontFamily,
      'packages/tdesign_test_package/TDesignTestFont',
    );
  });
}
