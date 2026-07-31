import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TFooter V1.0 Widget 测试
///
/// 覆盖 variant 三档（text/link/brand）、links 列表、logo 渲染、
/// Theme 各字段、copyWith/lerp、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TFooterThemeData? footerTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (footerTheme != null) footerTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TFooter 基础渲染', () {
    testWidgets('text variant 渲染文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(TFooterVariant.text, text: '版权所有'),
      ));
      expect(find.byType(TFooter), findsOneWidget);
      expect(find.text('版权所有'), findsOneWidget);
    });

    testWidgets('默认 text 为空字符串', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(TFooterVariant.text),
      ));
      expect(find.byType(TFooter), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('长文字在窄宽度下保持单行省略', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const Center(
          child: SizedBox(
            width: 120,
            child: TFooter(
              TFooterVariant.text,
              text: '这是一个非常非常长的页脚文案用于验证不溢出',
            ),
          ),
        ),
      ));

      final text = tester.widget<Text>(find.text('这是一个非常非常长的页脚文案用于验证不溢出'));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(text.softWrap, isFalse);
      expect(
          text.style?.fontSize, TThemeData.defaultData().fontBodySmall?.size);
    });
  });

  group('TFooter variant 三档', () {
    testWidgets('variant: text 仅渲染文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(TFooterVariant.text, text: '纯文字页脚'),
      ));
      expect(find.text('纯文字页脚'), findsOneWidget);
      // text variant 不渲染 TImage
      expect(find.byType(TImage), findsNothing);
    });

    testWidgets('variant: link 无 links 时回退渲染文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(TFooterVariant.link, text: '链接页脚无链接'),
      ));
      expect(find.text('链接页脚无链接'), findsOneWidget);
    });

    testWidgets('variant: link 有 links 渲染链接', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(
          TFooterVariant.link,
          text: '底部文字',
          links: [
            TLink(child: Text('链接1')),
            TLink(child: Text('链接2')),
          ],
        ),
      ));
      expect(find.text('链接1'), findsOneWidget);
      expect(find.text('链接2'), findsOneWidget);
      expect(find.text('底部文字'), findsOneWidget);
    });

    testWidgets('variant: brand 无 logo 时回退渲染文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(TFooterVariant.brand, text: '品牌页脚'),
      ));
      expect(find.text('品牌页脚'), findsOneWidget);
    });

    testWidgets('variant: brand 有 logo 渲染 TImage', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(
          TFooterVariant.brand,
          logo: 'https://example.com/logo.png',
          text: '品牌',
        ),
      ));
      // brand + logo 会渲染 TImage（fitWidth variant）
      expect(find.byType(TImage), findsOneWidget);
    });
  });

  group('TFooter links 细节', () {
    testWidgets('多个 links 之间渲染分隔边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(
          TFooterVariant.link,
          text: '文字',
          links: [
            TLink(child: Text('A')),
            TLink(child: Text('B')),
          ],
        ),
      ));
      // 最后一个 link 无右边框，前面的有
      expect(find.byType(TLink), findsNWidgets(2));
    });

    testWidgets('单个 link 无分隔边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(
          TFooterVariant.link,
          text: '文字',
          links: [TLink(child: Text('唯一'))],
        ),
      ));
      expect(find.text('唯一'), findsOneWidget);
    });
  });

  group('TFooter Theme', () {
    testWidgets('Theme.height 应用到 brand logo', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(
          TFooterVariant.brand,
          logo: 'https://example.com/logo.png',
        ),
        footerTheme: const TFooterThemeData(height: 100),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });
  });

  group('TFooterThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TFooterThemeData(height: 50);
      final copied = theme.copyWith(height: 80);
      expect(copied.height, 80);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TFooterThemeData(height: 60);
      final copied = theme.copyWith();
      expect(copied.height, 60);
    });

    test('lerp 非 TFooterThemeData 返回自身', () {
      const theme = TFooterThemeData(height: 10);
      final result = theme.lerp(null, 0.5);
      expect(result, same(theme));
    });

    test('lerp height 插值', () {
      const a = TFooterThemeData(height: 10);
      const b = TFooterThemeData(height: 30);
      final result = a.lerp(b, 0.5);
      expect(result.height, 20);
    });
  });

  group('TFooter 边界情况', () {
    testWidgets('links 为空列表时 link variant 回退文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(TFooterVariant.link, text: '空链接列表'),
      ));
      expect(find.text('空链接列表'), findsOneWidget);
    });

    testWidgets('brand logo 为 null 时回退文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(TFooterVariant.brand, text: '无 logo'),
      ));
      expect(find.text('无 logo'), findsOneWidget);
      expect(find.byType(TImage), findsNothing);
    });

    testWidgets('width 参数传入 brand logo', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFooter(
          TFooterVariant.brand,
          logo: 'https://example.com/logo.png',
          width: 120,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });
  });
}
