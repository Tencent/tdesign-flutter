import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/text/t_text_resolve.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TTextResolve.resolve] 与 [TTextResolve.resolveSpan] 的主路径。
///
/// 说明：iOS PingFang SC 回退分支（PlatformUtil.isIOS）属平台相关，
/// 在非 iOS 测试环境不可达，标记为已知例外。
void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(body: child),
      );

  Widget wrapWithTextTheme(Widget child, TTextThemeData textTheme) {
    final theme =
        TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(textTheme);
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  Future<BuildContext> _ctx(WidgetTester tester) async {
    await tester.pumpWidget(wrap(const SizedBox()));
    return tester.element(find.byType(SizedBox));
  }

  Future<BuildContext> _ctxWithTextTheme(
      WidgetTester tester, TTextThemeData textTheme) async {
    await tester.pumpWidget(wrapWithTextTheme(const SizedBox(), textTheme));
    return tester.element(find.byType(SizedBox));
  }

  Future<BuildContext> _ctxWithTextThemeAndConfiguration(
    WidgetTester tester,
    TTextThemeData textTheme,
    TTextConfiguration configuration,
  ) async {
    await tester.pumpWidget(wrapWithTextTheme(configuration, textTheme));
    return tester.element(find.byWidget(configuration.child));
  }

  group('TTextResolve', () {
    testWidgets('resolve 完整覆盖链（style/糖/Theme/Token）', (tester) async {
      final context = await _ctx(tester);
      final style = TTextResolve.resolve(
        context: context,
        style: const TextStyle(fontSize: 20, color: Colors.red),
        font: Font(size: 18, lineHeight: 26),
        fontWeight: FontWeight.w600,
        textColor: Colors.blue,
        isTextThrough: true,
        lineThroughColor: Colors.green,
        package: 'pkg',
      );
      expect(style.fontSize, 20);
      expect(style.color, Colors.red);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.decoration, TextDecoration.lineThrough);
    });

    testWidgets('resolve 仅传 context 走默认值分支', (tester) async {
      final context = await _ctx(tester);
      final style = TTextResolve.resolve(context: context);
      expect(style, isA<TextStyle>());
      expect(style.fontSize, isNotNull);
    });

    testWidgets('resolve 完整主题默认值来自 token', (tester) async {
      final token = TThemeData.defaultData();
      final context = await _ctx(tester);
      final style = TTextResolve.resolve(context: context);
      expect(style.color, token.textColorPrimary);
      expect(style.fontSize, token.fontBodyLarge?.size);
      expect(style.height, token.fontBodyLarge?.height);
    });

    testWidgets('resolve 读取 Theme 默认字体族', (tester) async {
      final context = await _ctxWithTextTheme(
        tester,
        TTextThemeData(
          defaultFontFamily: FontFamily(fontFamily: 'ThemeFont'),
        ),
      );
      final style = TTextResolve.resolve(context: context);
      expect(style.fontFamily, 'ThemeFont');
    });

    testWidgets('resolve 中 globalFontFamily 优先于 Theme 默认字体族', (tester) async {
      final child = Builder(builder: (_) => const SizedBox());
      final context = await _ctxWithTextThemeAndConfiguration(
        tester,
        TTextThemeData(
          defaultFontFamily: FontFamily(fontFamily: 'ThemeFont'),
        ),
        TTextConfiguration(
          globalFontFamily: FontFamily(fontFamily: 'GlobalFont'),
          child: child,
        ),
      );
      final style = TTextResolve.resolve(context: context);
      expect(style.fontFamily, 'GlobalFont');
    });

    testWidgets('resolveSpan（含 Theme 与 decoration 分支）', (tester) async {
      final context = await _ctx(tester);
      final style = TTextResolve.resolveSpan(
        context: context,
        style: const TextStyle(fontSize: 22),
        font: Font(size: 16, lineHeight: 24),
        textColor: Colors.purple,
        isTextThrough: true,
        package: 'pkg2',
      );
      expect(style.fontSize, 22);
      expect(style.color, Colors.purple);
      expect(style.decoration, TextDecoration.lineThrough);
    });

    testWidgets('resolveSpan 读取 Theme 默认字重和删除线', (tester) async {
      final context = await _ctxWithTextTheme(
        tester,
        const TTextThemeData(
          defaultFontWeight: FontWeight.w700,
          isTextThrough: true,
        ),
      );
      final style = TTextResolve.resolveSpan(context: context);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.decoration, TextDecoration.lineThrough);
    });

    testWidgets('resolveSpan context 为 null 走硬编码回退', (tester) async {
      final style = TTextResolve.resolveSpan(
        font: Font(size: 14, lineHeight: 20),
        textColor: Colors.orange,
      );
      expect(style, isA<TextStyle>());
      expect(style.fontSize, 14);
    });
  });
}
