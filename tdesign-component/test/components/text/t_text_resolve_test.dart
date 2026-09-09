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
        themeAnimationDuration: Duration.zero,
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

  testWidgets('组合组件默认值低于显式主题且按字段回退', (tester) async {
    final context = await pumpContext(
      tester,
      theme: TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(
        const TTextThemeData(textStyle: TextStyle(fontSize: 21)),
      ),
    );
    final resolved = TTextResolve.resolve(
      context: context,
      defaults: const TextStyle(
        fontSize: 12,
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),
    );
    expect(resolved.fontSize, 21);
    expect(resolved.color, Colors.red);
    expect(resolved.fontWeight, FontWeight.w600);
    expect(
      TTextResolve.resolve(
        context: context,
        defaults: const TextStyle(fontSize: 12),
        style: const TextStyle(fontSize: 24),
      ).fontSize,
      24,
    );
  });

  testWidgets('部分 Material 主题只覆盖配置字段且不带入投影默认值', (tester) async {
    final token = TThemeData.defaultData();
    for (final base in [
      ThemeData(),
      TThemeBuilder.light(token),
      TThemeBuilder.dark(token),
    ]) {
      final context = await pumpContext(
        tester,
        theme: base.copyWith(
          textTheme: base.textTheme.apply(fontFamily: 'custom-family'),
        ),
      );
      final resolved = TTextResolve.resolve(
        context: context,
        defaults: const TextStyle(
          fontSize: 10,
          height: 1.6,
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      );
      expect(resolved.fontFamily, 'custom-family');
      expect(resolved.fontSize, 10);
      expect(resolved.height, 1.6);
      expect(resolved.color, Colors.red);
      expect(resolved.fontWeight, FontWeight.w600);
    }
    final base = TThemeBuilder.light(token);
    final context = await pumpContext(
      tester,
      theme: base.copyWith(
        textTheme: base.textTheme.copyWith(
          bodyLarge: base.textTheme.bodyLarge!.copyWith(fontSize: 21),
        ),
      ),
    );
    final resolved = TTextResolve.resolve(
      context: context,
      defaults: const TextStyle(fontSize: 10, color: Colors.red),
    );
    expect(resolved.fontSize, 21);
    expect(resolved.color, Colors.red);
  });

  testWidgets('DefaultTextStyle.merge 不把继承的默认色伪装成显式配置', (tester) async {
    final context = await pumpContext(
      tester,
      wrap: (child) => DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 21),
        child: child,
      ),
    );
    final resolved = TTextResolve.resolve(
      context: context,
      defaults: const TextStyle(fontSize: 10, color: Colors.red),
    );
    expect(resolved.fontSize, 21);
    expect(resolved.color, Colors.red);
  });

  testWidgets('组合组件保留完整显式排版字段和绘制配置', (tester) async {
    const typography = TextStyle(
      color: Colors.orange,
      backgroundColor: Colors.yellow,
      fontSize: 21,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.italic,
      letterSpacing: 2,
      wordSpacing: 3,
      textBaseline: TextBaseline.ideographic,
      height: 2,
      leadingDistribution: TextLeadingDistribution.proportional,
      locale: Locale('zh', 'CN'),
      decoration: TextDecoration.underline,
      decorationColor: Colors.green,
      decorationStyle: TextDecorationStyle.dashed,
      decorationThickness: 2,
      overflow: TextOverflow.ellipsis,
      fontFamilyFallback: ['custom-fallback'],
      shadows: [Shadow(color: Colors.blue, blurRadius: 2)],
      fontFeatures: [FontFeature.tabularFigures()],
      fontVariations: [FontVariation('wght', 800)],
    );
    for (final useMaterial3 in [false, true]) {
      final context = await pumpContext(
        tester,
        theme: ThemeData(
          useMaterial3: useMaterial3,
          textTheme: const TextTheme(bodyLarge: typography),
        ),
      );
      final resolved = TTextResolve.resolve(
        context: context,
        defaults: const TextStyle(fontSize: 10),
      );
      expect(resolved.fontSize, 21);
      expect(resolved.fontWeight, FontWeight.w800);
      expect(resolved.backgroundColor, Colors.yellow);
      expect(resolved.fontFamilyFallback, typography.fontFamilyFallback);
      expect(resolved.leadingDistribution, typography.leadingDistribution);
      expect(resolved.decoration, typography.decoration);
      expect(resolved.fontFeatures, typography.fontFeatures);
      expect(resolved.fontVariations, typography.fontVariations);
    }
    final foreground = Paint()..color = Colors.purple;
    final background = Paint()..color = Colors.yellow;
    final context = await pumpContext(
      tester,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(foreground: foreground, background: background),
        ),
      ),
    );
    final resolved = TTextResolve.resolve(
      context: context,
      defaults: const TextStyle(color: Colors.red),
    );
    expect(resolved.foreground, foreground);
    expect(resolved.background, background);
    expect(resolved.color, isNull);
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
