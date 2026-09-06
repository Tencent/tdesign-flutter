import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TResult Widget 测试
///
/// 覆盖 status 四档、title/description 渲染、自定义 icon、
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
      expect(icon.size, 80);
      expect(icon.color, token.brandNormalColor);
    });

    testWidgets('带 title 渲染', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(const TResult(title: '操作成功')));
      expect(find.text('操作成功'), findsOneWidget);
      final title = resultTextWidget(tester, '操作成功');
      expect(title.textColor, token.textColorPrimary);
      expect(title.font, token.fontTitleMedium);
    });

    testWidgets('带 description 渲染', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(const TResult(title: '标题', description: '副标题描述')),
      );
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('副标题描述'), findsOneWidget);
      final description = resultTextWidget(tester, '副标题描述');
      expect(description.textColor, token.textColorSecondary);
      expect(description.font, token.fontBodyMedium);
    });

    testWidgets('title 为空时不渲染标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult()));
      // 默认 title='' 不应渲染 Text（title.isEmpty 跳过）
      expect(find.byType(TText), findsNothing);
    });

    testWidgets('description 为 null 时不渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult(title: '仅有标题')));
      expect(find.text('仅有标题'), findsOneWidget);
      expect(find.byType(TText), findsOneWidget);
    });
  });

  group('TResult status 四档', () {
    testWidgets('status: success 显示 check_circle', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          const TResult(status: TResultStatus.success, title: '成功'),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(TIcons.check_circle));
      expect(icon.size, 80);
      expect(icon.color, token.successNormalColor);
      expect(find.text('成功'), findsOneWidget);
    });

    testWidgets('status: warning 显示 error_circle', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          const TResult(status: TResultStatus.warning, title: '警告'),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(TIcons.error_circle));
      expect(icon.size, 80);
      expect(icon.color, token.warningNormalColor);
    });

    testWidgets('status: error 显示 close_circle', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(const TResult(status: TResultStatus.error, title: '失败')),
      );
      final icon = tester.widget<Icon>(find.byIcon(TIcons.close_circle));
      expect(icon.size, 80);
      expect(icon.color, token.errorNormalColor);
    });

    testWidgets('status: info 显示 info_circle', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TResult(status: TResultStatus.info, title: '默认')),
      );
      expect(find.byIcon(TIcons.info_circle), findsOneWidget);
    });
  });

  group('TResult 自定义 icon', () {
    testWidgets('自定义 icon 覆盖默认图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TResult(icon: Icon(Icons.star, size: 70), title: '自定义'),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(tester.widget<Icon>(find.byIcon(Icons.star)).size, 70);
      // 不应显示默认图标
      expect(find.byIcon(TIcons.info_circle), findsNothing);
    });
  });

  group('TResult Theme', () {
    testWidgets('Theme.titleStyle 应用', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TResult(title: '主题样式'),
          resultTheme: const TResultThemeData(
            titleStyle: TextStyle(fontSize: 24, color: Colors.red),
          ),
        ),
      );
      final title = resultTextWidget(tester, '主题样式');
      expect(title.style?.fontSize, 24);
      expect(title.style?.color, Colors.red);
    });

    testWidgets('Theme 无 titleStyle 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult(title: '无主题样式')));
      expect(find.text('无主题样式'), findsOneWidget);
    });

    testWidgets('Theme.iconSize 与 descriptionStyle 应用', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TResult(description: '描述样式'),
          resultTheme: const TResultThemeData(
            iconSize: 64,
            descriptionStyle: TextStyle(fontSize: 13, color: Colors.purple),
          ),
        ),
      );

      expect(tester.widget<Icon>(find.byIcon(TIcons.info_circle)).size, 64);
      final description = resultTextWidget(tester, '描述样式');
      expect(description.style?.fontSize, 13);
      expect(description.style?.color, Colors.purple);
      expect(description.font, isNull);
    });

    testWidgets('内容间距跟随 spacer12 token', (tester) async {
      final token = TThemeData.defaultData();
      final originalSpacing = token.spacerMap['spacer12'];
      void restoreSpacing() {
        if (originalSpacing == null) {
          token.spacerMap.remove('spacer12');
        } else {
          token.spacerMap['spacer12'] = originalSpacing;
        }
      }

      addTearDown(restoreSpacing);
      token.spacerMap['spacer12'] = 20;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: const Scaffold(
            body: TResult(title: '标题', description: '描述'),
          ),
        ),
      );

      expect(
        tester
            .widget<SizedBox>(find.byKey(const ValueKey('result-spacing-1')))
            .height,
        20,
      );
      expect(
        tester
            .widget<SizedBox>(find.byKey(const ValueKey('result-spacing-2')))
            .height,
        20,
      );
      restoreSpacing();
    });
  });

  group('TResultThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TResultThemeData(
        iconSize: 80,
        titleStyle: TextStyle(fontSize: 16),
        descriptionStyle: TextStyle(fontSize: 12),
      );
      final copied = theme.copyWith(
        iconSize: 64,
        titleStyle: const TextStyle(fontSize: 24),
        descriptionStyle: const TextStyle(fontSize: 14),
      );
      expect(copied.iconSize, 64);
      expect(copied.titleStyle?.fontSize, 24);
      expect(copied.descriptionStyle?.fontSize, 14);
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
      const a = TResultThemeData(
        iconSize: 60,
        titleStyle: TextStyle(fontSize: 10),
        descriptionStyle: TextStyle(fontSize: 10),
      );
      const b = TResultThemeData(
        iconSize: 80,
        titleStyle: TextStyle(fontSize: 20),
        descriptionStyle: TextStyle(fontSize: 20),
      );
      final result = a.lerp(b, 0.5);
      expect(result.iconSize, 70);
      expect(result.titleStyle?.fontSize, closeTo(15, 0.01));
      expect(result.descriptionStyle?.fontSize, closeTo(15, 0.01));
    });
  });

  group('TResult 边界情况', () {
    testWidgets('description 为空字符串时不渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TResult(title: '标题', description: '')),
      );
      expect(find.text('标题'), findsOneWidget);
      // 空字符串 description 不应渲染额外的 TText
      expect(find.byType(TText), findsOneWidget);
    });

    testWidgets('所有参数默认值', (tester) async {
      const result = TResult();
      expect(result.status, TResultStatus.info);
      expect(result.title, '');
      expect(result.description, isNull);
      expect(result.icon, isNull);
    });

    testWidgets('状态写入无障碍语义且相邻内容间距为 12', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TResult(
            status: TResultStatus.success,
            title: '标题',
            description: '描述',
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'result-success',
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<SizedBox>(find.byKey(const ValueKey('result-spacing-1')))
            .height,
        12,
      );
      expect(
        tester
            .widget<SizedBox>(find.byKey(const ValueKey('result-spacing-2')))
            .height,
        12,
      );
    });

    testWidgets('构造器全部参数传入渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TResult(
            title: '标题',
            description: '副标题',
            status: TResultStatus.success,
            icon: Icon(Icons.check),
          ),
        ),
      );
      expect(find.byType(TResult), findsOneWidget);
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });
  });
}
