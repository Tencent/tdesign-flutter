import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TResult V1.0 Widget 测试
///
/// 覆盖 variant 四档、title/subtitle 渲染、自定义 icon、
/// Theme 各字段、copyWith/lerp、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TResultThemeData? resultTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (resultTheme != null) {
      theme = theme.mergeExtension(resultTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  TText resultTextWidget(WidgetTester tester, String data) {
    return tester.widget<TText>(
      find.byWidgetPredicate(
        (widget) => widget is TText && widget.data == data,
      ),
    );
  }

  group('TResult 基础渲染', () {
    testWidgets('默认 variant 渲染 - info 图标', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(const TResult()));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.info_circle));
      expect(icon.size, 70);
      expect(icon.color, token.brandNormalColor);
    });

    testWidgets('带 title 渲染', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(const TResult(title: '操作成功')));
      expect(find.text('操作成功'), findsOneWidget);
      final title = resultTextWidget(tester, '操作成功');
      expect(title.textColor, token.textColorPrimary);
      expect(title.font, token.fontTitleExtraLarge);
    });

    testWidgets('带 subtitle 渲染', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '标题', subtitle: '副标题描述'),
      ));
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('副标题描述'), findsOneWidget);
      final subtitle = resultTextWidget(tester, '副标题描述');
      expect(subtitle.textColor, token.textColorSecondary);
      expect(subtitle.font, token.fontTitleSmall);
    });

    testWidgets('title 为空时不渲染标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult()));
      // 默认 title='' 不应渲染 Text（title.isEmpty 跳过）
      expect(find.byType(TText), findsNothing);
    });

    testWidgets('subtitle 为 null 时不渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult(title: '仅有标题')));
      expect(find.text('仅有标题'), findsOneWidget);
      expect(find.byType(TText), findsOneWidget);
    });
  });

  group('TResult variant 四档', () {
    testWidgets('variant: success 显示 check_circle', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.success, title: '成功'),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.check_circle));
      expect(icon.size, 70);
      expect(icon.color, token.successNormalColor);
      expect(find.text('成功'), findsOneWidget);
    });

    testWidgets('variant: warning 显示 error_circle', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.warning, title: '警告'),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.error_circle));
      expect(icon.size, 70);
      expect(icon.color, token.warningNormalColor);
    });

    testWidgets('variant: error 显示 close_circle', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.error, title: '失败'),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.close_circle));
      expect(icon.size, 70);
      expect(icon.color, token.errorNormalColor);
    });

    testWidgets('variant: defaultTheme 显示 info_circle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.defaultTheme, title: '默认'),
      ));
      expect(find.byIcon(TIcons.info_circle), findsOneWidget);
    });
  });

  group('TResult 自定义 icon', () {
    testWidgets('自定义 icon 覆盖默认图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(
          icon: Icon(Icons.star, size: 70),
          title: '自定义',
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
      // 不应显示默认图标
      expect(find.byIcon(TIcons.info_circle), findsNothing);
    });
  });

  group('TResult Theme', () {
    testWidgets('Theme.titleStyle 应用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '主题样式'),
        resultTheme: const TResultThemeData(
          titleStyle: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ));
      final title = resultTextWidget(tester, '主题样式');
      expect(title.style?.fontSize, 24);
      expect(title.style?.color, Colors.red);
    });

    testWidgets('Theme 无 titleStyle 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '无主题样式'),
      ));
      expect(find.text('无主题样式'), findsOneWidget);
    });
  });

  group('TResultThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TResultThemeData(titleStyle: TextStyle(fontSize: 16));
      final copied = theme.copyWith(
        titleStyle: const TextStyle(fontSize: 24),
      );
      expect(copied.titleStyle?.fontSize, 24);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TResultThemeData(titleStyle: TextStyle(color: Colors.blue));
      final copied = theme.copyWith();
      expect(copied.titleStyle?.color, Colors.blue);
    });

    test('lerp 非 TResultThemeData 返回自身', () {
      const theme = TResultThemeData(titleStyle: TextStyle(fontSize: 10));
      final result = theme.lerp(null, 0.5);
      expect(result, same(theme));
    });

    test('lerp titleStyle 插值', () {
      const a = TResultThemeData(titleStyle: TextStyle(fontSize: 10));
      const b = TResultThemeData(titleStyle: TextStyle(fontSize: 20));
      final result = a.lerp(b, 0.5);
      expect(result.titleStyle?.fontSize, closeTo(15, 0.01));
    });
  });

  group('TResult 边界情况', () {
    testWidgets('subtitle 为空字符串时不渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '标题', subtitle: ''),
      ));
      expect(find.text('标题'), findsOneWidget);
      // 空字符串 subtitle 不应渲染额外的 TText
      expect(find.byType(TText), findsOneWidget);
    });

    testWidgets('所有参数默认值', (tester) async {
      const result = TResult();
      expect(result.variant, TResultVariant.defaultTheme);
      expect(result.title, '');
      expect(result.subtitle, isNull);
      expect(result.icon, isNull);
    });

    testWidgets('构造器全部参数传入渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(
          title: '标题',
          subtitle: '副标题',
          variant: TResultVariant.success,
          icon: Icon(Icons.check),
        ),
      ));
      expect(find.byType(TResult), findsOneWidget);
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });
  });
}
