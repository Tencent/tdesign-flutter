import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TEmpty Widget 测试
/// 覆盖 variant、icon、emptyText、operationText、onPressed、customOperationWidget。
void main() {
  Widget wrapWithTheme(Widget child, {TEmptyThemeData? emptyTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (emptyTheme != null) {
      theme = theme.mergeExtension(emptyTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  TText emptyTextWidget(WidgetTester tester, String data) {
    return tester.widget<TText>(
      find.byWidgetPredicate(
        (widget) => widget is TText && widget.data == data,
      ),
    );
  }

  group('TEmpty variant', () {
    testWidgets('plain 变体正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(variant: TEmptyVariant.plain, emptyText: '暂无数据'),
      ));
      expect(find.text('暂无数据'), findsOneWidget);
    });

    testWidgets('operation 变体正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(
          variant: TEmptyVariant.operation,
          emptyText: '空空如也',
          operationText: '刷新',
        ),
      ));
      expect(find.text('空空如也'), findsOneWidget);
      expect(find.text('刷新'), findsOneWidget);
    });
  });

  group('TEmpty icon', () {
    testWidgets('默认 icon 正常渲染', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(emptyText: '默认图标'),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.info_circle_filled));
      expect(icon.size, 96);
      expect(icon.color, token.textColorPlaceholder);
    });

    testWidgets('自定义 icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(icon: Icons.search, emptyText: '搜索无结果'),
      ));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('TEmpty emptyText', () {
    testWidgets('emptyText 显示文案', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(emptyText: '自定义文案'),
      ));
      expect(find.text('自定义文案'), findsOneWidget);
      final text = emptyTextWidget(tester, '自定义文案');
      expect(text.textColor, token.textColorPlaceholder);
      expect(text.font, token.fontBodyMedium);
      expect(text.fontWeight, FontWeight.w400);
    });

    testWidgets('emptyText 为 null 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(),
      ));
      expect(find.byType(TEmpty), findsOneWidget);
    });
  });

  group('TEmpty operationText', () {
    testWidgets('operationText 显示操作文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(
          variant: TEmptyVariant.operation,
          emptyText: '无数据',
          operationText: '点击重试',
        ),
      ));
      expect(find.text('点击重试'), findsOneWidget);
    });
  });

  group('TEmpty onPressed', () {
    testWidgets('onPressed 回调触发', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TEmpty(
          variant: TEmptyVariant.operation,
          emptyText: '无数据',
          operationText: '重试',
          onPressed: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('重试'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('onPressed 为 null 时不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(
          variant: TEmptyVariant.operation,
          emptyText: '无数据',
          operationText: '重试',
        ),
      ));
      expect(find.byType(TEmpty), findsOneWidget);
    });
  });

  group('TEmpty customOperationWidget', () {
    testWidgets('自定义操作组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(
          variant: TEmptyVariant.operation,
          emptyText: '自定义',
          customOperationWidget: Text('自定义操作'),
        ),
      ));
      expect(find.text('自定义操作'), findsOneWidget);
    });

    testWidgets('自定义 image 组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(
          emptyText: '自定义图',
          image: Icon(Icons.image, size: 80),
        ),
      ));
      expect(find.byIcon(Icons.image), findsOneWidget);
    });
  });

  group('TEmpty 维度组合', () {
    testWidgets('plain + 自定义 icon + emptyText', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(
          variant: TEmptyVariant.plain,
          icon: Icons.warning,
          emptyText: '警告',
        ),
      ));
      expect(find.text('警告'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('operation + operationText + onPressed', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TEmpty(
          variant: TEmptyVariant.operation,
          emptyText: '失败',
          operationText: '重新加载',
          onPressed: () {},
        ),
      ));
      expect(find.text('失败'), findsOneWidget);
      expect(find.text('重新加载'), findsOneWidget);
    });
  });

  group('TEmpty Theme 覆盖', () {
    testWidgets('TEmptyThemeData 自定义文字颜色/字体/按钮主题', (tester) async {
      final font = Font(size: 14, lineHeight: 20);
      await tester.pumpWidget(wrapWithTheme(
        const TEmpty(
          variant: TEmptyVariant.operation,
          emptyText: '主题文案',
          operationText: '主题按钮',
        ),
        emptyTheme: TEmptyThemeData(
          emptyTextColor: Colors.red,
          emptyTextFont: font,
          operationTheme: TButtonColorScheme.danger,
        ),
      ));

      final text = emptyTextWidget(tester, '主题文案');
      final button = tester.widget<TButton>(find.byType(TButton));
      expect(text.textColor, Colors.red);
      expect(text.font, font);
      expect(button.size, TButtonSize.large);
      expect(button.colorScheme, TButtonColorScheme.danger);
    });

    test('TEmptyThemeData copyWith and lerp', () {
      final font = Font(size: 14, lineHeight: 20);
      final a = TEmptyThemeData(
        emptyTextColor: Colors.red,
        emptyTextFont: font,
        operationTheme: TButtonColorScheme.primary,
      );
      final b = TEmptyThemeData(
        emptyTextColor: Colors.blue,
        emptyTextFont: Font(size: 16, lineHeight: 24),
        operationTheme: TButtonColorScheme.danger,
      );

      expect(a.copyWith(emptyTextColor: Colors.green).emptyTextColor,
          Colors.green);
      expect(a.copyWith().emptyTextFont, same(font));
      expect(a.lerp(b, 0.25).operationTheme, TButtonColorScheme.primary);
      expect(a.lerp(b, 0.75).operationTheme, TButtonColorScheme.danger);
      expect(a.lerp(null, 0.5), same(a));
    });
  });
}
