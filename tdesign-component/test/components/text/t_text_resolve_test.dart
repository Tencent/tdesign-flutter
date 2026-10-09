import 'package:flutter/foundation.dart';
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

  testWidgets(
    '实例样式优先于 TDesign Token，忽略 Material TextTheme 和 DefaultTextStyle',
    (tester) async {
      final context = await pumpContext(
        tester,
        theme: ThemeData(
          extensions: [TThemeData.defaultData()],
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
      expect(resolved.decoration, isNull);
      expect(resolved.inherit, isFalse);
    },
  );

  testWidgets('组件 Theme 默认值优先于 Token，实例 style 再覆盖', (tester) async {
    final context = await pumpContext(
      tester,
      theme: TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(
        const TTextThemeData(
          textStyle: TextStyle(
            fontSize: 22,
            height: 28 / 20,
            color: Colors.blue,
          ),
        ),
      ),
      wrap: (child) => DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 18, color: Colors.pink),
        child: child,
      ),
    );
    final defaultStyle = TTextResolve.resolve(context: context);
    expect(defaultStyle.fontSize, 22);
    expect(defaultStyle.height, 28 / 20);
    expect(defaultStyle.color, Colors.blue);
    final instanceStyle = TTextResolve.resolve(
      context: context,
      style: const TextStyle(fontSize: 24, color: Colors.red),
    );
    expect(instanceStyle.fontSize, 24);
    expect(instanceStyle.color, Colors.red);
  });

  testWidgets('非 Apple 平台解析默认字体栈而不改 Token', (tester) async {
    final token = TThemeData.defaultData();
    final context = await pumpContext(
      tester,
      theme: TThemeBuilder.light(token),
    );
    final resolved = TTextResolve.resolve(context: context);
    expect(resolved.fontFamily, 'Roboto');
    expect(resolved.fontFamilyFallback, [
      'Microsoft YaHei',
      'Arial Regular',
      'Roboto',
    ]);
    expect(token.fontFamily?.fallback, ['Microsoft YaHei', 'Arial Regular']);

    final custom = token.copyWith(
      name: 'custom-family',
      fontFamilyMap: {
        'fontFamily': FontFamily(
          fontFamily: 'PingFang SC',
          fallback: ['CustomFallback'],
        ),
      },
    );
    final customContext = await pumpContext(
      tester,
      theme: TThemeBuilder.light(custom),
    );
    expect(
      TTextResolve.resolve(context: customContext).fontFamily,
      'PingFang SC',
    );
  });

  testWidgets('组合组件显式字体族完整传递名称、回退与资源包', (tester) async {
    final context = await pumpContext(tester);
    final resolved = TTextResolve.resolve(
      context: context,
      fontFamily: FontFamily(
        fontFamily: 'CustomFont',
        fallback: ['FallbackFont'],
        package: 'custom_package',
      ),
    );
    expect(resolved.fontFamily, 'packages/custom_package/CustomFont');
    expect(resolved.fontFamilyFallback, [
      'packages/custom_package/FallbackFont',
    ]);
  });

  testWidgets('Apple 平台保留 PingFang 主字体', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      final token = TThemeData.defaultData();
      final context = await pumpContext(
        tester,
        theme: TThemeBuilder.light(token),
      );
      expect(TTextResolve.resolve(context: context).fontFamily, 'PingFang SC');
      expect(token.fontFamily?.fontFamily, 'PingFang SC');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('inherit false 不继承 Theme 与 Token', (tester) async {
    final context = await pumpContext(tester);
    const style = TextStyle(inherit: false, fontSize: 13);
    final resolved = TTextResolve.resolve(context: context, style: style);
    expect(resolved, style);
  });

  testWidgets('组合组件默认值优先于 Token，但不读取 Material TextTheme', (tester) async {
    final context = await pumpContext(
      tester,
      theme: TThemeBuilder.light(TThemeData.defaultData()).copyWith(
        textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 21)),
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
    expect(resolved.fontSize, 12);
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

  testWidgets('Material TextTheme 无论局部或整体配置都不进入 TDesign 文字链', (tester) async {
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
      expect(resolved.fontFamily, 'Roboto');
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
    expect(resolved.fontSize, 10);
    expect(resolved.color, Colors.red);
  });

  testWidgets('DefaultTextStyle.merge 不进入 TDesign 文字样式链', (tester) async {
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
    expect(resolved.fontSize, 10);
    expect(resolved.color, Colors.red);
  });

  testWidgets('组件 Theme 保留完整排版字段和绘制配置', (tester) async {
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
          extensions: const [TTextThemeData(textStyle: typography)],
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
        extensions: [
          TTextThemeData(
            textStyle: TextStyle(
              foreground: foreground,
              background: background,
            ),
          ),
        ],
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

  testWidgets('Material TextTheme 不覆盖 Token，实例字体仍可覆盖', (tester) async {
    final context = await pumpContext(
      tester,
      theme: ThemeData(
        extensions: [TThemeData.defaultData()],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 21,
            height: 26 / 18,
            color: Colors.orange,
          ),
        ),
      ),
    );
    final themed = TTextResolve.resolve(context: context);
    expect(themed.fontSize, 14);
    expect(themed.height, 22 / 14);
    expect(themed.color, TThemeData.defaultData().textColorPrimary);

    final instance = TTextResolve.resolve(
      context: context,
      font: Font(size: 24, lineHeight: 32),
      textColor: Colors.blue,
    );
    expect(instance.fontSize, 24);
    expect(instance.height, 32 / 24);
    expect(instance.color, Colors.blue);
  });
}
