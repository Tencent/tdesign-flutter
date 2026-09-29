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
/// - TTagVariant 全部绘制形态
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
      expect(textWidget.style?.height, closeTo(20 / 12, 1e-9));
    });

    testWidgets('带图标的标签渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('图标标签', icon: Icons.star)),
      );
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
    testWidgets('Figma primary/light Tag 使用确定的默认色值和水平内边距', (tester) async {
      // Figma Copy / Tag，实例 26795:11055：primary + light + medium。
      // 仅锁定已核实且当前与全局 token 一致的值；高度、圆角另行裁定。
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag(
            'Tag',
            colorScheme: TTagColorScheme.primary,
            variant: TTagVariant.light,
            size: TTagSize.medium,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final text = tester.widget<Text>(find.text('Tag'));

      expect(decoration.color, const Color(0xFFF2F3FF));
      expect(text.style?.color, const Color(0xFF0052D9));
      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      );
    });

    testWidgets('defaultTheme 色彩渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('默认', colorScheme: TTagColorScheme.defaultTheme),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('默认'), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, TThemeData.defaultData().bgColorComponent);
    });

    testWidgets('defaultTheme dark and light fills use distinct tokens', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          const Row(
            children: [
              TTag('深色', variant: TTagVariant.dark),
              TTag('浅色', variant: TTagVariant.light),
            ],
          ),
        ),
      );

      Color fill(String label) {
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.widgetWithText(TTag, label),
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is Container && widget.decoration is BoxDecoration,
                ),
              )
              .first,
        );
        return (container.decoration! as BoxDecoration).color!;
      }

      expect(fill('深色'), token.bgColorComponent);
      expect(fill('浅色'), token.bgColorSecondaryContainer);
      expect(fill('深色'), isNot(fill('浅色')));
    });

    testWidgets('defaultTheme background follows an explicit ColorScheme', (
      tester,
    ) async {
      const surface = Color(0xFFABCDEF);
      final theme = TThemeBuilder.light(TThemeData.defaultData()).copyWith(
        colorScheme: const ColorScheme.light(surfaceContainerHighest: surface),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: TTag('显式主题')),
        ),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect((container.decoration! as BoxDecoration).color, surface);
    });

    testWidgets('semantic fills follow their global token sources', (
      tester,
    ) async {
      const primary = Color(0xFF123456);
      const primaryLight = Color(0xFFBBDDEE);
      const warning = Color(0xFF765432);
      const warningLight = Color(0xFFEEDDCC);
      const danger = Color(0xFF654321);
      const dangerLight = Color(0xFFEEDDBB);
      const success = Color(0xFF246813);
      const successLight = Color(0xFFBBEECC);
      final token = TThemeData.defaultData().copyWithTThemeData(
        'custom-tag-colors',
        colorMap: {
          'brandColor': primary,
          'brandColorLight': primaryLight,
          'warningColor': warning,
          'warningColor1': warningLight,
          'warningColorLight': const Color(0xFF111111),
          'errorColor': danger,
          'errorColor1': dangerLight,
          'errorColorLight': const Color(0xFF222222),
          'successColor': success,
          'successColor1': successLight,
          'successColorLight': const Color(0xFF333333),
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: const Scaffold(
            body: Column(
              children: [
                TTag('主要', colorScheme: TTagColorScheme.primary),
                TTag('警告', colorScheme: TTagColorScheme.warning),
                TTag('危险', colorScheme: TTagColorScheme.danger),
                TTag('成功', colorScheme: TTagColorScheme.success),
                TTag(
                  '浅色主要',
                  colorScheme: TTagColorScheme.primary,
                  variant: TTagVariant.light,
                ),
                TTag(
                  '浅色警告',
                  colorScheme: TTagColorScheme.warning,
                  variant: TTagVariant.light,
                ),
                TTag(
                  '浅色危险',
                  colorScheme: TTagColorScheme.danger,
                  variant: TTagVariant.light,
                ),
                TTag(
                  '浅色成功',
                  colorScheme: TTagColorScheme.success,
                  variant: TTagVariant.light,
                ),
              ],
            ),
          ),
        ),
      );

      Color fill(String label) {
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.widgetWithText(TTag, label),
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is Container && widget.decoration is BoxDecoration,
                ),
              )
              .first,
        );
        return (container.decoration! as BoxDecoration).color!;
      }

      expect(fill('主要'), primary);
      expect(fill('警告'), warning);
      expect(fill('危险'), danger);
      expect(fill('成功'), success);
      expect(fill('浅色主要'), primaryLight);
      expect(fill('浅色警告'), warningLight);
      expect(fill('浅色危险'), dangerLight);
      expect(fill('浅色成功'), successLight);
    });

    testWidgets('暗色浅填充也直接读取色阶 1，不读取 Light 别名', (tester) async {
      const warning = Color(0xFF102030);
      const danger = Color(0xFF203040);
      const success = Color(0xFF304050);
      final token = TThemeData.defaultData().dark!.copyWithTThemeData(
        'custom-dark-tag-colors',
        colorMap: {
          'warningColor1': warning,
          'warningColorLight': const Color(0xFF111111),
          'errorColor1': danger,
          'errorColorLight': const Color(0xFF222222),
          'successColor1': success,
          'successColorLight': const Color(0xFF333333),
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.dark(token),
          home: const Scaffold(
            body: Column(
              children: [
                TTag(
                  '警告',
                  colorScheme: TTagColorScheme.warning,
                  variant: TTagVariant.light,
                ),
                TTag(
                  '危险',
                  colorScheme: TTagColorScheme.danger,
                  variant: TTagVariant.light,
                ),
                TTag(
                  '成功',
                  colorScheme: TTagColorScheme.success,
                  variant: TTagVariant.light,
                ),
              ],
            ),
          ),
        ),
      );

      Color fill(String label) {
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.widgetWithText(TTag, label),
                matching: find.byType(Container),
              )
              .first,
        );
        return (container.decoration! as BoxDecoration).color!;
      }

      expect(fill('警告'), warning);
      expect(fill('危险'), danger);
      expect(fill('成功'), success);
    });

    testWidgets('primary 色彩渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('主要', colorScheme: TTagColorScheme.primary)),
      );
      expect(find.text('主要'), findsOneWidget);
    });

    testWidgets('warning 色彩渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('警告', colorScheme: TTagColorScheme.warning)),
      );
      expect(find.text('警告'), findsOneWidget);
    });

    testWidgets('danger 色彩渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('危险', colorScheme: TTagColorScheme.danger)),
      );
      expect(find.text('危险'), findsOneWidget);
    });

    testWidgets('success 色彩渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('成功', colorScheme: TTagColorScheme.success)),
      );
      expect(find.text('成功'), findsOneWidget);
    });
  });

  // ============================================================
  // TTagShape 形状
  // ============================================================
  group('TTag 形状（shape）', () {
    testWidgets('square 形状渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('方形'),
          tagTheme: const TTagThemeData(shape: TTagShape.square),
        ),
      );
      expect(find.text('方形'), findsOneWidget);
      expect(find.byType(TTag), findsOneWidget);
    });

    testWidgets('square 四档跟随全局 radiusSmall，组件 Theme 可覆盖', (tester) async {
      final token = TThemeData.defaultData().copyWithTThemeData(
        'tag-square-radius-test',
        radiusMap: {'radiusSmall': 14, 'radiusDefault': 7},
      );
      for (final size in TTagSize.values.where((s) => s != TTagSize.custom)) {
        await tester.pumpWidget(
          MaterialApp(
            theme: TThemeBuilder.light(token),
            home: Scaffold(body: TTag('方形', size: size)),
          ),
        );
        var container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(TTag),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          (container.decoration! as BoxDecoration).borderRadius,
          BorderRadius.circular(14),
          reason: '$size should follow radiusSmall, not other global radii',
        );

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          MaterialApp(
            theme: TThemeBuilder.light(
              token,
            ).mergeExtension(const TTagThemeData(squareBorderRadius: 5)),
            home: Scaffold(body: TTag('方形', size: size)),
          ),
        );
        container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(TTag),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          (container.decoration! as BoxDecoration).borderRadius,
          BorderRadius.circular(5),
          reason: '$size should allow a component Theme override',
        );
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });

    testWidgets('round 形状渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('圆角'),
          tagTheme: const TTagThemeData(shape: TTagShape.round),
        ),
      );
      expect(find.text('圆角'), findsOneWidget);
    });

    testWidgets('mark 形状渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('半圆'),
          tagTheme: const TTagThemeData(shape: TTagShape.mark),
        ),
      );
      expect(find.text('半圆'), findsOneWidget);
    });
  });

  // ============================================================
  // TTagSize 尺寸
  // ============================================================
  group('TTag 尺寸（size）', () {
    const sizeCases =
        <
          ({
            TTagSize size,
            double height,
            double fontSize,
            double iconSize,
            EdgeInsets padding,
          })
        >[
          (
            size: TTagSize.extraLarge,
            height: 40,
            fontSize: 14,
            iconSize: 16,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          ),
          (
            size: TTagSize.large,
            height: 28,
            fontSize: 14,
            iconSize: 16,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          ),
          (
            size: TTagSize.medium,
            height: 24,
            fontSize: 12,
            iconSize: 14,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          ),
          (
            size: TTagSize.small,
            height: 20,
            fontSize: 10,
            iconSize: 12,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          ),
        ];
    for (final sizeCase in sizeCases) {
      testWidgets('${sizeCase.size.name} 默认尺寸与小程序边框盒一致', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(TTag('尺寸', size: sizeCase.size, icon: Icons.star)),
        );
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(TTag),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(
          tester.getSize(find.byWidget(container)).height,
          sizeCase.height,
        );
        expect(container.padding, sizeCase.padding);
        expect(
          tester.widget<Text>(find.text('尺寸')).style?.fontSize,
          sizeCase.fontSize,
        );
        expect(
          tester.widget<Text>(find.text('尺寸')).style?.height,
          closeTo(
            (sizeCase.height - sizeCase.padding.vertical) / sizeCase.fontSize,
            1e-9,
          ),
        );
        expect(
          tester.widget<Icon>(find.byIcon(Icons.star)).size,
          sizeCase.iconSize,
        );
      });
    }

    testWidgets('自定义字体行高同时决定文本行盒和单行外盒', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('自定义行高'),
          tagTheme: TTagThemeData(font: Font(size: 12, lineHeight: 26)),
        ),
      );
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(tester.getSize(find.byWidget(container)).height, 30);
      expect(
        tester.widget<Text>(find.text('自定义行高')).style?.height,
        closeTo(26 / 12, 1e-9),
      );
    });

    testWidgets('extraLarge 尺寸渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('超大', size: TTagSize.extraLarge)),
      );
      expect(find.text('超大'), findsOneWidget);
    });

    testWidgets('large 尺寸渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('大', size: TTagSize.large)),
      );
      expect(find.text('大'), findsOneWidget);
    });

    testWidgets('small 尺寸渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('小', size: TTagSize.small)),
      );
      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('custom 尺寸渲染（padding 为 0）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('自定义', size: TTagSize.custom)),
      );
      expect(find.text('自定义'), findsOneWidget);
    });
  });

  // ============================================================
  // 描边 / 浅色 / 禁用
  // ============================================================
  group('TTag 样式变体', () {
    testWidgets('outline 描边样式渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('描边', variant: TTagVariant.outline)),
      );
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

    testWidgets('outline 背景与默认描边按变体读取对应 Token', (tester) async {
      const containerColor = Color(0xFFABCDEF);
      const componentColor = Color(0xFF123456);
      const unrelatedBorder = Color(0xFF654321);
      final token = TThemeData.defaultData().copyWithTThemeData(
        'tag-outline-token-test',
        colorMap: {
          'bgColorContainer': containerColor,
          'bgColorComponent': componentColor,
          'componentBorder': unrelatedBorder,
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: const Scaffold(
            body: Column(
              children: [
                TTag('默认描边', variant: TTagVariant.outline),
                TTag('默认浅色描边', variant: TTagVariant.lightOutline),
                TTag(
                  '主要描边',
                  colorScheme: TTagColorScheme.primary,
                  variant: TTagVariant.outline,
                ),
                TTag(
                  '浅色描边',
                  colorScheme: TTagColorScheme.primary,
                  variant: TTagVariant.lightOutline,
                ),
              ],
            ),
          ),
        ),
      );

      BoxDecoration decoration(String label) {
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.widgetWithText(TTag, label),
                matching: find.byType(Container),
              )
              .first,
        );
        return container.decoration! as BoxDecoration;
      }

      expect(decoration('默认描边').color, containerColor);
      expect(decoration('主要描边').color, containerColor);
      expect((decoration('默认描边').border! as Border).top.color, componentColor);
      expect(
        (decoration('默认浅色描边').border! as Border).top.color,
        unrelatedBorder,
      );
      expect(decoration('浅色描边').color, token.brandColorLight);
    });

    testWidgets('light 浅色样式渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag(
            '浅色',
            colorScheme: TTagColorScheme.primary,
            variant: TTagVariant.light,
          ),
        ),
      );
      expect(find.text('浅色'), findsOneWidget);
    });

    testWidgets('lightOutline 浅色描边渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag(
            '描边浅色',
            colorScheme: TTagColorScheme.danger,
            variant: TTagVariant.lightOutline,
          ),
        ),
      );
      expect(find.text('描边浅色'), findsOneWidget);
    });

    testWidgets('disable 禁用状态使用禁用色且不响应点击', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(TTag('禁用', enabled: false, onTap: () => tapped = true)),
      );

      final token = TThemeData.defaultData();
      final tagContainer = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      final decoration = tagContainer.decoration as BoxDecoration;
      final text = tester.widget<Text>(find.text('禁用'));

      expect(decoration.color, token.bgColorComponentDisabled);
      expect(text.style?.color, token.textColorDisabled);
      await tester.tap(find.byType(TTag), warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('disable + outline 禁用描边渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('禁用描边', enabled: false, variant: TTagVariant.outline),
        ),
      );
      expect(find.text('禁用描边'), findsOneWidget);
    });
  });

  // ============================================================
  // 关闭图标 + onCloseTap 回调
  // ============================================================
  group('TTag 关闭图标', () {
    testWidgets('needCloseIcon 显示关闭图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('可关闭', needCloseIcon: true)),
      );
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('关闭图标颜色读取 textColorPlaceholder，不跟随标签文字色', (tester) async {
      const placeholder = Color(0xFF987654);
      final token = TThemeData.defaultData().copyWithTThemeData(
        'tag-close-icon-color-test',
        colorMap: {
          'textColorPlaceholder': placeholder,
          'brandColor': const Color(0xFF123456),
        },
      );
      for (final enabled in [true, false]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: TThemeBuilder.light(token),
            home: Scaffold(
              body: TTag(
                '可关闭',
                enabled: enabled,
                needCloseIcon: true,
                colorScheme: TTagColorScheme.primary,
              ),
            ),
          ),
        );
        expect(
          tester.widget<Icon>(find.byIcon(TIcons.close)).color,
          placeholder,
        );
      }
    });

    testWidgets('onCloseTap 点击触发回调', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          TTag('可关闭', needCloseIcon: true, onCloseTap: () => closed = true),
        ),
      );

      await tester.tap(find.byIcon(TIcons.close));
      await tester.pump();
      expect(closed, isTrue);
    });

    testWidgets('onCloseTap 为 null 时点击不崩溃', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('无回调', needCloseIcon: true)),
      );

      await tester.tap(find.byIcon(TIcons.close), warnIfMissed: false);
      await tester.pump();
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('带图标 + 关闭图标同时显示', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('组合', icon: Icons.add, needCloseIcon: true)),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });
  });

  // ============================================================
  // 主题覆盖（ThemeExtension）
  // ============================================================
  group('TTag 主题覆盖', () {
    testWidgets('通过 TTagThemeData 设置 fixedWidth', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('固定宽'),
          tagTheme: const TTagThemeData(fixedWidth: 120),
        ),
      );
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(container.constraints?.maxWidth, 120);
    });

    testWidgets('通过 TTagThemeData 设置自定义 padding', (tester) async {
      const customPadding = EdgeInsets.all(20);
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('自定义间距'),
          tagTheme: const TTagThemeData(padding: customPadding),
        ),
      );
      final container = tester.widget<Container>(
        find
            .descendant(of: find.byType(TTag), matching: find.byType(Container))
            .first,
      );
      expect(container.padding, customPadding);
    });

    testWidgets('通过 TTagThemeData 设置自定义 iconWidget', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('自定义图标', icon: Icons.favorite)),
      );
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('通过 TTagThemeData 设置 overflow', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('溢出处理'),
          tagTheme: const TTagThemeData(overflow: TextOverflow.clip),
        ),
      );
      expect(find.text('溢出处理'), findsOneWidget);
    });

    testWidgets('fixedWidth long label with icons stays single-line ellipsis', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: TTag('这是一段非常非常长的标签文案', icon: Icons.add, needCloseIcon: true),
          ),
          tagTheme: const TTagThemeData(fixedWidth: 96),
        ),
      );

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

    testWidgets('theme maxLines allows multi-line fixed width tag', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: TTag('这是一段非常非常长的标签文案', icon: Icons.add, needCloseIcon: true),
          ),
          tagTheme: const TTagThemeData(fixedWidth: 96, maxLines: 2),
        ),
      );

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
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('自定义背景'),
          tagTheme: const TTagThemeData(backgroundColor: Colors.purple),
        ),
      );
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
        shape: TTagShape.square,
        squareBorderRadius: 3,
      );
      final merged = base.copyWith(
        shape: TTagShape.round,
        squareBorderRadius: 5,
      );
      expect(merged.shape, TTagShape.round);
      expect(merged.squareBorderRadius, 5);
    });

    test('TTagThemeData lerp 正确插值', () {
      const a = TTagThemeData(shape: TTagShape.square, squareBorderRadius: 3);
      const b = TTagThemeData(shape: TTagShape.round, squareBorderRadius: 5);
      final result = a.lerp(b, 0.3);
      // t < 0.5 取 a 的值
      expect(result.shape, TTagShape.square);
      expect(result.squareBorderRadius, closeTo(3.6, 1e-9));
    });

    test('方角继承全局 Token 时插值不把 null 当成 0dp', () {
      const inherited = TTagThemeData();
      const overridden = TTagThemeData(squareBorderRadius: 6);
      expect(inherited.lerp(overridden, 0.25).squareBorderRadius, isNull);
      expect(inherited.lerp(overridden, 0.75).squareBorderRadius, 6);
      expect(overridden.lerp(inherited, 0.25).squareBorderRadius, 6);
      expect(overridden.lerp(inherited, 0.75).squareBorderRadius, isNull);
      expect(inherited.lerp(inherited, 0.5).squareBorderRadius, isNull);
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
      await tester.pumpWidget(
        wrapWithTheme(const TTag('带图标', icon: Icons.star)),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('size extraLarge', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('大', size: TTagSize.extraLarge)),
      );
      expect(find.text('大'), findsOneWidget);
    });

    testWidgets('size large', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('中', size: TTagSize.large)),
      );
      expect(find.text('中'), findsOneWidget);
    });

    testWidgets('size small', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('小', size: TTagSize.small)),
      );
      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('shape round', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('圆角'),
          tagTheme: const TTagThemeData(shape: TTagShape.round),
        ),
      );
      expect(find.text('圆角'), findsOneWidget);
    });

    testWidgets('shape mark', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('半圆'),
          tagTheme: const TTagThemeData(shape: TTagShape.mark),
        ),
      );
      expect(find.text('半圆'), findsOneWidget);
    });

    testWidgets('needCloseIcon', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(TTag('可关闭', needCloseIcon: true, onCloseTap: () {})),
      );
      expect(find.text('可关闭'), findsOneWidget);
    });

    testWidgets('lightOutline', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('描边', variant: TTagVariant.lightOutline)),
      );
      expect(find.text('描边'), findsOneWidget);
    });

    testWidgets('disable', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTag('禁用', enabled: false)));
      expect(find.text('禁用'), findsOneWidget);
    });

    testWidgets('colorScheme danger', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('危险', colorScheme: TTagColorScheme.danger)),
      );
      expect(find.text('危险'), findsOneWidget);
    });

    testWidgets('iconWidget 自定义', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTag('自定义图标', icon: Icons.favorite)),
      );
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('primary + outline', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag(
            'primary',
            colorScheme: TTagColorScheme.primary,
            variant: TTagVariant.outline,
          ),
        ),
      );
      expect(find.text('primary'), findsOneWidget);
    });

    testWidgets('warning + outline', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag(
            'warning',
            colorScheme: TTagColorScheme.warning,
            variant: TTagVariant.outline,
          ),
        ),
      );
      expect(find.text('warning'), findsOneWidget);
    });

    testWidgets('medium size + icon', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag('med', icon: Icons.star, size: TTagSize.medium),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('all semantic colors resolve light variants', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Wrap(
            children: TTagColorScheme.values
                .map(
                  (scheme) => TTag(
                    '$scheme',
                    colorScheme: scheme,
                    variant: TTagVariant.light,
                  ),
                )
                .toList(),
          ),
        ),
      );
      expect(find.byType(TTag), findsNWidgets(TTagColorScheme.values.length));
    });

    testWidgets('success outline resolves semantic border', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTag(
            'success',
            colorScheme: TTagColorScheme.success,
            variant: TTagVariant.outline,
          ),
        ),
      );
      expect(find.text('success'), findsOneWidget);
    });

    testWidgets('组件专属颜色只覆盖 danger 和 success 预设', (tester) async {
      const danger = Color(0xFF9A231A);
      const success = Color(0xFF126B43);
      const successLight = Color(0xFFB1E7C3);
      await tester.pumpWidget(
        wrapWithTheme(
          const Column(
            children: [
              TTag('危险', colorScheme: TTagColorScheme.danger),
              TTag('成功', colorScheme: TTagColorScheme.success),
              TTag(
                '浅成功',
                colorScheme: TTagColorScheme.success,
                variant: TTagVariant.light,
              ),
              TTag('主要', colorScheme: TTagColorScheme.primary),
            ],
          ),
          tagTheme: const TTagThemeData(
            dangerColor: danger,
            successColor: success,
            successLightColor: successLight,
          ),
        ),
      );

      Color? background(String label) {
        final tag = find.widgetWithText(TTag, label);
        final container = tester.widget<Container>(
          find.descendant(of: tag, matching: find.byType(Container)).first,
        );
        return (container.decoration! as BoxDecoration).color;
      }

      expect(background('危险'), danger);
      expect(background('成功'), success);
      expect(background('浅成功'), successLight);
      expect(background('主要'), isNot(anyOf(danger, success, successLight)));
    });

    test('组件专属颜色 copyWith 与 lerp 保留动态 Token 回退', () {
      const base = TTagThemeData(dangerColor: Colors.red);
      const target = TTagThemeData(
        successColor: Colors.green,
        successLightColor: Colors.lightGreen,
      );
      expect(base.copyWith(successColor: Colors.blue).dangerColor, Colors.red);
      expect(base.lerp(target, 0.25).dangerColor, Colors.red);
      expect(base.lerp(target, 0.75).dangerColor, isNull);
      expect(base.lerp(target, 0.75).successColor, Colors.green);
    });

    testWidgets('all tag variants render', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Wrap(
            children: TTagVariant.values
                .map((variant) => TTag('$variant', variant: variant))
                .toList(),
          ),
        ),
      );
      expect(find.byType(TTag), findsNWidgets(TTagVariant.values.length));
    });
  });
}
