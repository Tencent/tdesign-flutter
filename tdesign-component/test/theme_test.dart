import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 主题架构 P0–P4 层级覆盖验证测试
///
/// 验证 CSS Token → 全局 Theme.of → 组件 Theme.of → 实例 style 的四层优先级链路。
///
/// 优先级（覆盖方向，强 → 弱）：
/// **P0 实例 > P1 组件 Theme > P2 Material > P3 ColorScheme > P4 Token**
void main() {
  group('全局 theme.of 基础设施', () {
    test('TThemeData.defaultData() 返回非空默认 Token', () {
      final token = TThemeData.defaultData();
      expect(token, isNotNull);
      expect(token.brandNormalColor, isA<Color>());
      expect(token.bgColorPage, isA<Color>());
      expect(token.radiusDefault, isA<double>());
    });

    test('TThemeBuilder.light/dark 返回完整 ThemeData', () {
      final token = TThemeData.defaultData();
      final lightTheme = TThemeBuilder.light(token);
      final darkTheme = TThemeBuilder.dark(token);

      // 验证 TThemeData 作为 Extension 注入
      expect(lightTheme.extension<TThemeData>(), isNotNull);
      expect(darkTheme.extension<TThemeData>(), isNotNull);

      // 验证 ColorScheme 映射
      expect(lightTheme.colorScheme.primary, token.brandNormalColor);
      expect(lightTheme.colorScheme.surface, token.bgColorContainer);
      expect(lightTheme.colorScheme.error, token.errorNormalColor);
      expect(
          lightTheme.textTheme.bodyLarge?.fontSize, token.fontBodyLarge?.size);
      expect(lightTheme.iconTheme.color, token.textColorPrimary);
      expect(lightTheme.inputDecorationTheme.filled, isFalse);
      expect(lightTheme.inputDecorationTheme.fillColor, Colors.transparent);
      expect(lightTheme.extension<TButtonThemeData>(), isNotNull);
      // 字体 Token 已映射到 Material TextTheme；组件扩展保持为空，
      // 避免覆盖局部 DefaultTextStyle。
      expect(lightTheme.extension<TTextThemeData>()?.font, isNull);
      expect(lightTheme.extension<TIconThemeData>()?.color, isNull);
      expect(lightTheme.filledButtonTheme.style?.backgroundColor?.resolve({}),
          token.brandNormalColor);

      expect(darkTheme.colorScheme.primary,
          (token.dark ?? token).brandNormalColor);
    });

    testWidgets('TThemeBuilder 不用全局主题污染输入和普通图标默认样式', (tester) async {
      final token = TThemeData.defaultData();
      dynamic capturedInputTheme;
      Color? capturedIconColor;

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Builder(
            builder: (context) {
              capturedInputTheme = Theme.of(context).inputDecorationTheme;
              capturedIconColor = IconTheme.of(context).color;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedInputTheme!.filled, isFalse);
      expect(capturedInputTheme!.fillColor, Colors.transparent);
      expect(capturedIconColor, token.textColorPrimary);
      expect(capturedIconColor, isNot(token.brandNormalColor));
    });

    test('ThemeData.mergeExtension 保留现有 Extension', () {
      final token = TThemeData.defaultData();
      final baseTheme = TThemeBuilder.light(token);
      const buttonTheme = TButtonThemeData(
        defaultVariant: TButtonVariant.outline,
      );

      final merged = baseTheme.mergeExtension(buttonTheme);

      // 验证 merge 后 TThemeData 仍在
      expect(merged.extension<TThemeData>(), isNotNull);
      // 验证 merge 后 TButtonThemeData 已注入
      expect(merged.extension<TButtonThemeData>(), isNotNull);
      expect(
        merged.extension<TButtonThemeData>()!.defaultVariant,
        TButtonVariant.outline,
      );
    });

    testWidgets('context.tTheme 从 Theme.of(context) 读取 TThemeData',
        (tester) async {
      TThemeData? capturedToken;
      final token = TThemeData.defaultData();

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Builder(
            builder: (context) {
              capturedToken = context.tTheme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedToken, isNotNull);
      expect(capturedToken!.brandNormalColor, token.brandNormalColor);
    });

    testWidgets('context.tTheme 无 Theme 时回退默认值', (tester) async {
      TThemeData? capturedToken;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedToken = context.tTheme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedToken, isNotNull);
      // 应回退到 TThemeData.defaultData()
      expect(capturedToken!.brandNormalColor,
          TThemeData.defaultData().brandNormalColor);
    });
  });

  group('P0–P4 层级覆盖', () {
    testWidgets('P4 Token: 全局 Token 颜色可读取', (tester) async {
      final token = TThemeData.defaultData();
      Color? capturedColor;

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Builder(
            builder: (context) {
              capturedColor = context.tTheme.brandNormalColor;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedColor, token.brandNormalColor);
    });

    testWidgets('P3 ColorScheme: TThemeBuilder 映射 Token → ColorScheme',
        (tester) async {
      final token = TThemeData.defaultData();
      ColorScheme? capturedScheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Builder(
            builder: (context) {
              capturedScheme = Theme.of(context).colorScheme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedScheme!.primary, token.brandNormalColor);
      expect(capturedScheme!.surface, token.bgColorContainer);
      expect(capturedScheme!.error, token.errorNormalColor);
    });

    testWidgets('P1 组件 Theme: 子树 mergeExtension 覆盖组件默认', (tester) async {
      final token = TThemeData.defaultData();
      // 子树 Theme 数据需在 pumpWidget 之前静态构造，不能在 pumpWidget 参数中调用
      // Theme.of(tester.element(...))（此时 Scaffold 尚未渲染）。
      final subtreeTheme = TThemeBuilder.light(token).mergeExtension(
        const TButtonThemeData(defaultVariant: TButtonVariant.outline),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Theme(
            data: subtreeTheme,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  final buttonTheme =
                      Theme.of(context).extension<TButtonThemeData>();
                  // P1 组件 Theme 覆盖了默认值
                  expect(buttonTheme, isNotNull);
                  expect(buttonTheme!.defaultVariant, TButtonVariant.outline);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('P0 实例: TButton 构造器 style 覆盖一切', (tester) async {
      final token = TThemeData.defaultData();

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Scaffold(
            body: TButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.purple),
              ),
              onPressed: () {},
              child: const Text('P0'),
            ),
          ),
        ),
      );

      // 验证 TButton 渲染成功（P0 style 覆盖）
      expect(find.byType(TButton), findsOneWidget);
      expect(find.text('P0'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), Colors.purple);
    });

    testWidgets('P1 > P4: 组件 Theme Extension 覆盖全局 Token', (tester) async {
      final token = TThemeData.defaultData();

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token).mergeExtension(
            const TButtonThemeData(defaultVariant: TButtonVariant.outline),
          ),
          home: Scaffold(
            body: TButton(
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {},
              child: const Text('P1'),
            ),
          ),
        ),
      );

      final element = tester.element(find.byType(TButton));
      final buttonTheme = Theme.of(element).extension<TButtonThemeData>();
      expect(buttonTheme, isNotNull);
      expect(buttonTheme!.defaultVariant, TButtonVariant.outline);
      expect(element.tTheme.brandNormalColor, token.brandNormalColor);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.side?.resolve({})?.color, token.brandNormalColor);
    });
  });

  group('TStyleResolver', () {
    testWidgets('提供 P0-P4 各层访问', (tester) async {
      final token = TThemeData.defaultData();

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final resolver = TStyleResolver.of(context);

                // P4: Token
                expect(resolver.token.brandNormalColor, token.brandNormalColor);

                // P3: ColorScheme
                expect(resolver.colorScheme.primary, token.brandNormalColor);

                // P2: Material ThemeData
                expect(resolver.materialTheme, isA<ThemeData>());

                // P1: TThemeBuilder 全局注入默认组件 Extension
                expect(
                    resolver.componentExtension<TButtonThemeData>(), isNotNull);
                expect(
                    resolver.componentExtension<TTextThemeData>(), isNotNull);

                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('TLoading 无构造器 themeData', () {
    testWidgets('TLoading 从 Theme Extension 读取样式', (tester) async {
      final token = TThemeData.defaultData();

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token).mergeExtension(
            const TLoadingThemeData(iconColor: Colors.red),
          ),
          home: const Scaffold(
            body: TLoading(
              size: TLoadingSize.large,
              icon: TLoadingIcon.circle,
            ),
          ),
        ),
      );

      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('子树 mergeExtension 覆盖 TLoading 样式', (tester) async {
      final token = TThemeData.defaultData();
      // 子树 Theme 数据需在 pumpWidget 之前静态构造，不能在 pumpWidget 参数中调用
      // Theme.of(tester.element(...))（此时 Scaffold 尚未渲染）。
      final subtreeTheme = TThemeBuilder.light(token).mergeExtension(
        const TLoadingThemeData(iconColor: Colors.blue),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Theme(
            data: subtreeTheme,
            child: const Scaffold(
              body: TLoading(
                size: TLoadingSize.medium,
                icon: TLoadingIcon.circle,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TLoading), findsOneWidget);
    });
  });
}
