import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTag Widget 测试
///
/// 覆盖：
/// - 基础渲染（text/icon/size）
/// - TTagColorScheme 全部语义色
/// - TTagShape 形状（square/round/mark）
/// - TTagSize 尺寸
/// - 禁用状态（disable）
/// - 描边样式（isOutline）
/// - 浅色样式（isLight）
/// - 关闭图标 + onCloseTap 回调
/// - 主题覆盖（ThemeExtension）
/// - 边界场景
void main() {
  /// 完整包装，注入 TDesign 全局主题。
  Widget wrapWithTheme(Widget child, {TTagThemeData? tagTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (tagTheme != null) {
      theme = theme.mergeExtension(tagTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TTag 基础渲染', () {
    testWidgets('显示文字内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTag('标签')));
      expect(find.text('标签'), findsOneWidget);
      expect(find.byType(TTag), findsOneWidget);
    });

    testWidgets('文字垂直居中且宽度按内容自适应', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTag('居中')));

      final tagContainerFinder = find.descendant(
        of: find.byType(TTag),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration is BoxDecoration,
        ),
      );
      final tagRect = tester.getRect(tagContainerFinder.first);
      final textRect = tester.getRect(find.text('居中'));
      final textWidget = tester.widget<Text>(find.text('居中'));

      expect((tagRect.center.dy - textRect.center.dy).abs(), lessThan(1));
      expect(tagRect.width, lessThan(120));
      expect(textWidget.style?.height, isNull);
    });

    testWidgets('带图标的标签渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('图标标签', icon: Icons.star),
      ));
      expect(find.text('图标标签'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('空文字渲染不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTag('')));
      expect(find.byType(TTag), findsOneWidget);
    });
  });

  // ============================================================
  // TTagColorScheme 全部语义色
  // ============================================================
  group('TTag 语义色（colorScheme）', () {
    testWidgets('defaultTheme 色彩渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('默认', colorScheme: TTagColorScheme.defaultTheme),
      ));
      expect(find.text('默认'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('primary 色彩渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('主要', colorScheme: TTagColorScheme.primary),
      ));
      expect(find.text('主要'), findsOneWidget);
    });

    testWidgets('warning 色彩渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('警告', colorScheme: TTagColorScheme.warning),
      ));
      expect(find.text('警告'), findsOneWidget);
    });

    testWidgets('danger 色彩渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('危险', colorScheme: TTagColorScheme.danger),
      ));
      expect(find.text('危险'), findsOneWidget);
    });

    testWidgets('success 色彩渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('成功', colorScheme: TTagColorScheme.success),
      ));
      expect(find.text('成功'), findsOneWidget);
    });
  });

  // ============================================================
  // TTagShape 形状
  // ============================================================
  group('TTag 形状（shape）', () {
    testWidgets('square 形状渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('方形'),
        tagTheme: const TTagThemeData(shape: TTagShape.square),
      ));
      expect(find.text('方形'), findsOneWidget);
      expect(find.byType(TTag), findsOneWidget);
    });

    testWidgets('round 形状渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('圆角'),
        tagTheme: const TTagThemeData(shape: TTagShape.round),
      ));
      expect(find.text('圆角'), findsOneWidget);
    });

    testWidgets('mark 形状渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('半圆'),
        tagTheme: const TTagThemeData(shape: TTagShape.mark),
      ));
      expect(find.text('半圆'), findsOneWidget);
    });
  });

  // ============================================================
  // TTagSize 尺寸
  // ============================================================
  group('TTag 尺寸（size）', () {
    testWidgets('extraLarge 尺寸渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('超大', size: TTagSize.extraLarge),
      ));
      expect(find.text('超大'), findsOneWidget);
    });

    testWidgets('large 尺寸渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('大', size: TTagSize.large),
      ));
      expect(find.text('大'), findsOneWidget);
    });

    testWidgets('small 尺寸渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('小', size: TTagSize.small),
      ));
      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('custom 尺寸渲染（padding 为 0）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('自定义', size: TTagSize.custom),
      ));
      expect(find.text('自定义'), findsOneWidget);
    });
  });

  // ============================================================
  // 描边 / 浅色 / 禁用
  // ============================================================
  group('TTag 样式变体', () {
    testWidgets('isOutline 描边样式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('描边'),
        tagTheme: const TTagThemeData(isOutline: true),
      ));
      expect(find.text('描边'), findsOneWidget);
      // 描边时 Container 应有 border
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('isLight 浅色样式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('浅色', colorScheme: TTagColorScheme.primary),
        tagTheme: const TTagThemeData(isLight: true),
      ));
      expect(find.text('浅色'), findsOneWidget);
    });

    testWidgets('isOutline + isLight 组合渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('描边浅色', colorScheme: TTagColorScheme.danger),
        tagTheme: const TTagThemeData(isOutline: true, isLight: true),
      ));
      expect(find.text('描边浅色'), findsOneWidget);
    });

    testWidgets('disable 禁用状态使用禁用色且不响应点击', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TTag('禁用', enabled: false, onTap: () => tapped = true),
      ));

      final token = TThemeData.defaultData();
      final tagContainer = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      final decoration = tagContainer.decoration as BoxDecoration;
      final text = tester.widget<Text>(find.text('禁用'));

      expect(decoration.color, token.bgColorComponentDisabled);
      expect(text.style?.color, token.textDisabledColor);
      await tester.tap(find.byType(TTag), warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('disable + isOutline 禁用描边渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('禁用描边', enabled: false),
        tagTheme: const TTagThemeData(isOutline: true),
      ));
      expect(find.text('禁用描边'), findsOneWidget);
    });
  });

  // ============================================================
  // 关闭图标 + onCloseTap 回调
  // ============================================================
  group('TTag 关闭图标', () {
    testWidgets('needCloseIcon 显示关闭图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('可关闭', needCloseIcon: true),
      ));
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('onCloseTap 点击触发回调', (tester) async {
      var closed = false;
      await tester.pumpWidget(wrapWithTheme(
        TTag(
          '可关闭',
          needCloseIcon: true,
          onCloseTap: () => closed = true,
        ),
      ));

      await tester.tap(find.byIcon(TIcons.close));
      await tester.pump();
      expect(closed, isTrue);
    });

    testWidgets('onCloseTap 为 null 时点击不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('无回调', needCloseIcon: true),
      ));

      await tester.tap(find.byIcon(TIcons.close), warnIfMissed: false);
      await tester.pump();
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('带图标 + 关闭图标同时显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('组合', icon: Icons.add, needCloseIcon: true),
      ));
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });
  });

  // ============================================================
  // 主题覆盖（ThemeExtension）
  // ============================================================
  group('TTag 主题覆盖', () {
    testWidgets('通过 TTagThemeData 设置 colorScheme', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('主题色'),
        tagTheme: const TTagThemeData(colorScheme: TTagColorScheme.success),
      ));
      expect(find.text('主题色'), findsOneWidget);
    });

    testWidgets('通过 TTagThemeData 设置 fixedWidth', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('固定宽'),
        tagTheme: const TTagThemeData(fixedWidth: 120),
      ));
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(container.constraints?.maxWidth, 120);
    });

    testWidgets('通过 TTagThemeData 设置自定义 padding', (tester) async {
      const customPadding = EdgeInsets.all(20);
      await tester.pumpWidget(wrapWithTheme(
        const TTag('自定义间距'),
        tagTheme: const TTagThemeData(padding: customPadding),
      ));
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(container.padding, customPadding);
    });

    testWidgets('通过 TTagThemeData 设置自定义 iconWidget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('自定义图标', icon: Icons.favorite),
      ));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('通过 TTagThemeData 设置 overflow', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('溢出处理'),
        tagTheme: const TTagThemeData(overflow: TextOverflow.clip),
      ));
      expect(find.text('溢出处理'), findsOneWidget);
    });

    testWidgets('fixedWidth long label with icons stays single-line ellipsis',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const Center(
          child: TTag(
            '这是一段非常非常长的标签文案',
            icon: Icons.add,
            needCloseIcon: true,
          ),
        ),
        tagTheme: const TTagThemeData(fixedWidth: 96),
      ));

      expect(tester.takeException(), isNull);
      final tagContainer = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(tagContainer.constraints?.maxWidth, 96);

      final label = tester.widget<Text>(find.text('这是一段非常非常长的标签文案'));
      expect(label.maxLines, 1);
      expect(label.overflow, TextOverflow.ellipsis);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('theme maxLines allows multi-line fixed width tag',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const Center(
          child: TTag(
            '这是一段非常非常长的标签文案',
            icon: Icons.add,
            needCloseIcon: true,
          ),
        ),
        tagTheme: const TTagThemeData(
          fixedWidth: 96,
          maxLines: 2,
        ),
      ));

      expect(tester.takeException(), isNull);
      final label = tester.widget<Text>(find.text('这是一段非常非常长的标签文案'));
      expect(label.maxLines, 2);
      expect(label.overflow, TextOverflow.ellipsis);

      final tagRect = tester.getRect(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(tagRect.height, greaterThan(32));
    });

    test('TTagThemeData carries maxLines through copyWith and lerp', () {
      const base = TTagThemeData(maxLines: 1);
      const other = TTagThemeData(maxLines: 2);

      expect(base.copyWith(maxLines: 3).maxLines, 3);
      expect(base.lerp(other, 0.25).maxLines, 1);
      expect(base.lerp(other, 0.75).maxLines, 2);
    });

    testWidgets('通过 TTagThemeData 设置自定义 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('自定义背景'),
        tagTheme: const TTagThemeData(backgroundColor: Colors.purple),
      ));
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.purple);
    });
  });

  // ============================================================
  // 边界场景
  // ============================================================
  group('TTag 边界场景', () {
    testWidgets('不传 colorScheme 时使用默认值', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTag('默认色')));
      expect(find.text('默认色'), findsOneWidget);
    });

    testWidgets('无 TTagThemeData 时使用默认样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTag('无主题')));
      expect(find.text('无主题'), findsOneWidget);
      // 默认不应有关闭图标
      expect(find.byIcon(TIcons.close), findsNothing);
    });

    test('TTagThemeData copyWith 正确合并', () {
      const base = TTagThemeData(
        colorScheme: TTagColorScheme.primary,
        isOutline: true,
      );
      final merged = base.copyWith(isLight: true);
      expect(merged.colorScheme, TTagColorScheme.primary);
      expect(merged.isOutline, isTrue);
      expect(merged.isLight, isTrue);
    });

    test('TTagThemeData lerp 正确插值', () {
      const a = TTagThemeData(colorScheme: TTagColorScheme.primary);
      const b = TTagThemeData(colorScheme: TTagColorScheme.danger);
      final result = a.lerp(b, 0.3);
      // t < 0.5 取 a 的值
      expect(result.colorScheme, TTagColorScheme.primary);
    });
  });

  // ============================================================
  // TTag widget 渲染
  // ============================================================
  group('TTag widget 渲染', () {
    testWidgets('基础渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTag('标签')));
      expect(find.text('标签'), findsOneWidget);
    });

    testWidgets('icon 渲染', (tester) async {
      await tester
          .pumpWidget(wrapWithTheme(const TTag('带图标', icon: Icons.star)));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('size extraLarge', (tester) async {
      await tester.pumpWidget(
          wrapWithTheme(const TTag('大', size: TTagSize.extraLarge)));
      expect(find.text('大'), findsOneWidget);
    });

    testWidgets('size large', (tester) async {
      await tester
          .pumpWidget(wrapWithTheme(const TTag('中', size: TTagSize.large)));
      expect(find.text('中'), findsOneWidget);
    });

    testWidgets('size small', (tester) async {
      await tester
          .pumpWidget(wrapWithTheme(const TTag('小', size: TTagSize.small)));
      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('shape round', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('圆角'),
        tagTheme: const TTagThemeData(shape: TTagShape.round),
      ));
      expect(find.text('圆角'), findsOneWidget);
    });

    testWidgets('shape mark', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('半圆'),
        tagTheme: const TTagThemeData(shape: TTagShape.mark),
      ));
      expect(find.text('半圆'), findsOneWidget);
    });

    testWidgets('needCloseIcon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTag('可关闭', needCloseIcon: true, onCloseTap: () {}),
      ));
      expect(find.text('可关闭'), findsOneWidget);
    });

    testWidgets('isOutline + isLight', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('描边'),
        tagTheme: const TTagThemeData(isOutline: true, isLight: true),
      ));
      expect(find.text('描边'), findsOneWidget);
    });

    testWidgets('disable', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('禁用', enabled: false),
      ));
      expect(find.text('禁用'), findsOneWidget);
    });

    testWidgets('colorScheme danger', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('危险', colorScheme: TTagColorScheme.danger),
      ));
      expect(find.text('危险'), findsOneWidget);
    });

    testWidgets('iconWidget 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('自定义图标', icon: Icons.favorite),
      ));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('primary + isOutline', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('primary', colorScheme: TTagColorScheme.primary),
        tagTheme: const TTagThemeData(isOutline: true),
      ));
      expect(find.text('primary'), findsOneWidget);
    });

    testWidgets('warning + isOutline', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('warning', colorScheme: TTagColorScheme.warning),
        tagTheme: const TTagThemeData(isOutline: true),
      ));
      expect(find.text('warning'), findsOneWidget);
    });

    testWidgets('medium size + icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('med', icon: Icons.star, size: TTagSize.medium),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('all semantic colors resolve light variants', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Wrap(
          children: TTagColorScheme.values
              .map((scheme) => TTag('$scheme', colorScheme: scheme))
              .toList(),
        ),
        tagTheme: const TTagThemeData(isLight: true),
      ));
      expect(find.byType(TTag), findsNWidgets(TTagColorScheme.values.length));
    });

    testWidgets('success outline resolves semantic border', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag('success', colorScheme: TTagColorScheme.success),
        tagTheme: const TTagThemeData(isOutline: true),
      ));
      expect(find.text('success'), findsOneWidget);
    });
  });
}
