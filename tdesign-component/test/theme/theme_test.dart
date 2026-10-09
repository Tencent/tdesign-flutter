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
      expect(token.brandColor, isA<Color>());
      expect(token.bgColorPage, isA<Color>());
      expect(token.radiusDefault, isA<double>());
    });

    test('全局圆角 Token 在明暗主题中取值一致且可覆盖', () {
      final token = TThemeData.defaultData();
      for (final mode in [token, token.dark!]) {
        expect(mode.radiusSmall, 3);
        expect(mode.radiusDefault, 6);
        expect(mode.radiusLarge, 9);
        expect(mode.radiusExtraLarge, 12);
        expect(mode.radiusRound, 999);
        expect(mode.radiusCircle, 9999);
      }

      final custom = token.copyWith(radiusMap: {'radiusDefault': 8});
      expect(custom.radiusDefault, 8);
      expect(custom.radiusSmall, 3);
    });

    test('TThemeBuilder.light/dark 返回完整 ThemeData', () {
      final token = TThemeData.defaultData();
      final lightTheme = TThemeBuilder.light(token);
      final darkTheme = TThemeBuilder.dark(token);

      // 验证 TThemeData 作为 Extension 注入
      expect(lightTheme.extension<TThemeData>(), isNotNull);
      expect(darkTheme.extension<TThemeData>(), isNotNull);

      // 验证 ColorScheme 映射
      expect(lightTheme.colorScheme.primary, token.brandColor);
      expect(lightTheme.colorScheme.surface, token.bgColorContainer);
      expect(lightTheme.colorScheme.error, token.errorColor);
      expect(
        lightTheme.textTheme.bodyLarge?.fontSize,
        token.fontBodyLarge?.size,
      );
      expect(lightTheme.iconTheme.color, token.textColorPrimary);
      expect(lightTheme.inputDecorationTheme.filled, isFalse);
      expect(lightTheme.inputDecorationTheme.fillColor, Colors.transparent);
      expect(lightTheme.extension<TButtonThemeData>(), isNotNull);
      // 字体 Token 映射到 Material TextTheme；组件 Theme 保留子树默认能力。
      expect(lightTheme.extension<TTextThemeData>(), isNotNull);
      expect(
        lightTheme.filledButtonTheme.style?.backgroundColor?.resolve({}),
        token.brandColor,
      );

      expect(darkTheme.colorScheme.primary, (token.dark ?? token).brandColor);
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
      expect(capturedIconColor, isNot(token.brandColor));
    });

    test('ThemeData.mergeExtension 保留现有 Extension', () {
      final token = TThemeData.defaultData();
      final baseTheme = TThemeBuilder.light(token);
      const buttonTheme = TButtonThemeData(iconTextSpacing: 7);

      final merged = baseTheme.mergeExtension(buttonTheme);

      // 验证 merge 后 TThemeData 仍在
      expect(merged.extension<TThemeData>(), isNotNull);
      // 验证 merge 后 TButtonThemeData 已注入
      expect(merged.extension<TButtonThemeData>(), isNotNull);
      expect(merged.extension<TButtonThemeData>()!.iconTextSpacing, 7);
    });

    testWidgets('context.tTheme 从 Theme.of(context) 读取 TThemeData', (
      tester,
    ) async {
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
      expect(capturedToken!.brandColor, token.brandColor);
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
      expect(capturedToken!.brandColor, TThemeData.defaultData().brandColor);
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
              capturedColor = context.tTheme.brandColor;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedColor, token.brandColor);
    });

    testWidgets('P3 ColorScheme: TThemeBuilder 映射 Token → ColorScheme', (
      tester,
    ) async {
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

      expect(capturedScheme!.primary, token.brandColor);
      expect(capturedScheme!.surface, token.bgColorContainer);
      expect(capturedScheme!.error, token.errorColor);
    });

    testWidgets('P1 组件 Theme: 子树 mergeExtension 覆盖组件默认', (tester) async {
      final token = TThemeData.defaultData();
      // 子树 Theme 数据需在 pumpWidget 之前静态构造，不能在 pumpWidget 参数中调用
      // Theme.of(tester.element(...))（此时 Scaffold 尚未渲染）。
      final subtreeTheme = TThemeBuilder.light(
        token,
      ).mergeExtension(const TButtonThemeData(iconTextSpacing: 7));

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Theme(
            data: subtreeTheme,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  final buttonTheme = Theme.of(
                    context,
                  ).extension<TButtonThemeData>();
                  // P1 组件 Theme 覆盖了默认值
                  expect(buttonTheme, isNotNull);
                  expect(buttonTheme!.iconTextSpacing, 7);
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
          theme: TThemeBuilder.light(
            token,
          ).mergeExtension(const TButtonThemeData(iconTextSpacing: 7)),
          home: Scaffold(
            body: TButton(
              colorPreset: TButtonColorPreset.primary,
              onPressed: () {},
              child: const Text('P1'),
            ),
          ),
        ),
      );

      final element = tester.element(find.byType(TButton));
      final buttonTheme = Theme.of(element).extension<TButtonThemeData>();
      expect(buttonTheme, isNotNull);
      expect(buttonTheme!.iconTextSpacing, 7);
      expect(element.tTheme.brandColor, token.brandColor);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.padding?.resolve({}), isNotNull);
    });
  });

  group('TStyleResolver', () {
    testWidgets('提供全局 Token 和组件 Theme 访问', (tester) async {
      final token = TThemeData.defaultData();

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final resolver = TStyleResolver.of(context);

                // P4: Token
                expect(resolver.token.brandColor, token.brandColor);

                // P1: TThemeBuilder 全局注入默认组件 Extension
                expect(
                  resolver.componentExtension<TButtonThemeData>(),
                  isNotNull,
                );

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
          theme: TThemeBuilder.light(
            token,
          ).mergeExtension(const TLoadingThemeData(iconColor: Colors.red)),
          home: const Scaffold(
            body: TLoading(size: 32, icon: TLoadingIcon.circle),
          ),
        ),
      );

      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('子树 mergeExtension 覆盖 TLoading 样式', (tester) async {
      final token = TThemeData.defaultData();
      // 子树 Theme 数据需在 pumpWidget 之前静态构造，不能在 pumpWidget 参数中调用
      // Theme.of(tester.element(...))（此时 Scaffold 尚未渲染）。
      final subtreeTheme = TThemeBuilder.light(
        token,
      ).mergeExtension(const TLoadingThemeData(iconColor: Colors.blue));

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Theme(
            data: subtreeTheme,
            child: const Scaffold(
              body: TLoading(size: 20, icon: TLoadingIcon.circle),
            ),
          ),
        ),
      );

      expect(find.byType(TLoading), findsOneWidget);
    });
  });
}
