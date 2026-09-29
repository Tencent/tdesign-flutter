import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  const colorScheme = ColorScheme.light(
    primary: Colors.blue,
    onPrimary: Colors.white,
    surfaceContainerHighest: Colors.amber,
    onSurface: Colors.black,
  );

  Widget themedButton({
    TButtonThemeData componentTheme = const TButtonThemeData(),
    ButtonStyle? materialStyle,
    TButtonVariant variant = TButtonVariant.fill,
    TButtonColorScheme? instanceColorScheme,
    ButtonStyle? instanceStyle,
  }) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        extensions: [TThemeData.defaultData(), componentTheme],
        elevatedButtonTheme: ElevatedButtonThemeData(style: materialStyle),
      ),
      home: Scaffold(
        body: TButton(
          variant: variant,
          colorScheme: instanceColorScheme,
          style: instanceStyle,
          onPressed: () {},
          child: const Text('priority'),
        ),
      ),
    );
  }

  Color? background(
    WidgetTester tester, [
    Set<WidgetState> states = const <WidgetState>{},
  ]) {
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    return button.style?.backgroundColor?.resolve(states);
  }

  test('TThemeBuilder 不用组件默认色板遮蔽 Material Theme', () {
    final theme = TThemeBuilder.light(TThemeData.defaultData());
    final buttonTheme = theme.extension<TButtonThemeData>();

    expect(buttonTheme, isNotNull);
    expect(buttonTheme?.filledStyle, isNull);
    expect(buttonTheme?.outlinedStyle, isNull);
    expect(buttonTheme?.textButtonStyle, isNull);
    expect(buttonTheme?.ghostStyle, isNull);
  });

  test('默认中性填充色与设计 Token 保持一致', () {
    expect(TThemeData.defaultData().bgColorComponent, const Color(0xFFE8E8E8));
  });

  testWidgets('TThemeBuilder 自动投影不污染默认样式，显式 copyWith 仍生效', (tester) async {
    Future<Color?> resolve(ThemeData theme) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          themeAnimationDuration: Duration.zero,
          home: Scaffold(
            body: TButton(onPressed: () {}, child: const Text('projection')),
          ),
        ),
      );
      return background(tester);
    }

    final token = TThemeData.defaultData();
    final generatedTheme = TThemeBuilder.light(token);
    expect(await resolve(generatedTheme), token.bgColorComponent);

    final customizedTheme = generatedTheme.copyWith(
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
      ),
    );
    expect(await resolve(customizedTheme), Colors.red);
  });

  testWidgets('P3 ColorScheme 覆盖 Token 及交互状态', (tester) async {
    await tester.pumpWidget(themedButton());

    expect(background(tester), colorScheme.surfaceContainerHighest);
    expect(
      background(tester, {WidgetState.pressed}),
      Color.alphaBlend(
        colorScheme.onSurface.withValues(alpha: 0.12),
        colorScheme.surfaceContainerHighest,
      ),
    );
    expect(
      background(tester, {WidgetState.disabled}),
      colorScheme.onSurface.withValues(alpha: 0.12),
    );
  });

  testWidgets('P2 Material Theme 覆盖 ColorScheme', (tester) async {
    await tester.pumpWidget(
      themedButton(
        materialStyle: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        ),
      ),
    );

    expect(background(tester), Colors.red);
  });

  testWidgets('P1 组件 ThemeExtension 覆盖 Material Theme', (tester) async {
    await tester.pumpWidget(
      themedButton(
        materialStyle: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        ),
        componentTheme: const TButtonThemeData(
          filledStyle: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green),
          ),
        ),
      ),
    );

    expect(background(tester), Colors.green);
  });

  testWidgets('实例 colorScheme 只选择预设，组件 Theme 具体颜色优先', (tester) async {
    await tester.pumpWidget(
      themedButton(
        componentTheme: const TButtonThemeData(
          filledStyle: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green),
          ),
        ),
        instanceColorScheme: TButtonColorScheme.primary,
      ),
    );

    expect(background(tester), Colors.green);
  });

  testWidgets('outline 的 Theme 描边和文字不被显式 colorScheme 覆盖', (tester) async {
    await tester.pumpWidget(
      themedButton(
        variant: TButtonVariant.outline,
        instanceColorScheme: TButtonColorScheme.danger,
        componentTheme: const TButtonThemeData(
          outlinedStyle: ButtonStyle(
            side: WidgetStatePropertyAll(BorderSide(color: Colors.green)),
            foregroundColor: WidgetStatePropertyAll(Colors.purple),
          ),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    for (final states in [
      <WidgetState>{},
      <WidgetState>{WidgetState.pressed},
      <WidgetState>{WidgetState.disabled},
    ]) {
      expect(button.style?.side?.resolve(states)?.color, Colors.green);
      expect(button.style?.foregroundColor?.resolve(states), Colors.purple);
    }
  });

  testWidgets('P0 实例 style 覆盖所有层级', (tester) async {
    await tester.pumpWidget(
      themedButton(
        materialStyle: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        ),
        componentTheme: const TButtonThemeData(
          filledStyle: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green),
          ),
        ),
        instanceColorScheme: TButtonColorScheme.primary,
        instanceStyle: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.purple),
        ),
      ),
    );

    expect(background(tester), Colors.purple);
  });
}
