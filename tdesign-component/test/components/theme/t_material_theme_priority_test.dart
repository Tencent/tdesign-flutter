import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';
import 'package:tdesign_flutter/src/components/switch/t_cupertino_switch.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  const customScheme = ColorScheme.light(
    primary: Colors.purple,
    onPrimary: Colors.yellow,
    onSurface: Colors.black,
    onSurfaceVariant: Colors.brown,
    outline: Colors.orange,
    surfaceContainerHighest: Colors.cyan,
  );

  Widget wrap(
    Widget child, {
    ColorScheme? colorScheme,
    SwitchThemeData? switchTheme,
    ThemeExtension<dynamic>? componentTheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        switchTheme: switchTheme,
        extensions: [
          TThemeData.defaultData(),
          if (componentTheme != null) componentTheme,
        ],
      ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  TextStyle effectiveTextStyle(WidgetTester tester, String text) {
    return DefaultTextStyle.of(tester.element(find.text(text))).style;
  }

  testWidgets('Flutter 隐式 M3 ColorScheme 不遮蔽 Token', (tester) async {
    late ThemeData material;
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            material = Theme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(material.tExplicitColorScheme, isNull);
  });

  testWidgets('Flutter 隐式 Material 字体图标和几何不遮蔽 Token', (tester) async {
    for (final useMaterial3 in [false, true]) {
      late ThemeData material;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: useMaterial3,
            extensions: [TThemeData.defaultData()],
          ),
          home: Builder(
            builder: (context) {
              material = Theme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(material.tExplicitTextTheme, isNull);
      expect(material.tExplicitIconTheme, isNull);
      expect(material.tExplicitDisabledColor, isNull);
      expect(material.tExplicitDividerColor, isNull);
      expect(material.tExplicitVisualDensity, isNull);
      expect(material.tExplicitMaterialTapTargetSize, isNull);
    }
  });

  testWidgets('调用方显式 Material 字段可以进入优先级链', (tester) async {
    late ThemeData material;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 19)),
          iconTheme: const IconThemeData(color: Colors.teal),
          disabledColor: Colors.grey,
          dividerColor: Colors.orange,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          extensions: [TThemeData.defaultData()],
        ),
        home: Builder(
          builder: (context) {
            material = Theme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(material.tExplicitTextTheme?.bodyLarge?.fontSize, 19);
    expect(material.tExplicitIconTheme?.color, Colors.teal);
    expect(material.tExplicitDisabledColor, Colors.grey);
    expect(material.tExplicitDividerColor, Colors.orange);
    expect(material.tExplicitVisualDensity, VisualDensity.compact);
    expect(
      material.tExplicitMaterialTapTargetSize,
      MaterialTapTargetSize.shrinkWrap,
    );
  });

  testWidgets('BuildContext 保留显式 ThemeData IconTheme', (tester) async {
    late IconThemeData? inheritedIconTheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          iconTheme: const IconThemeData(size: 28, color: Colors.teal),
          extensions: [TThemeData.defaultData()],
        ),
        home: Builder(
          builder: (context) {
            inheritedIconTheme = context.tExplicitIconTheme;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(inheritedIconTheme?.size, 28);
    expect(inheritedIconTheme?.color, Colors.teal);
  });

  testWidgets('BuildContext 保留局部显式 IconTheme', (tester) async {
    late IconThemeData? inheritedIconTheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: IconTheme(
          data: const IconThemeData(size: 30, color: Colors.green),
          child: Builder(
            builder: (context) {
              inheritedIconTheme = context.tExplicitIconTheme;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(inheritedIconTheme?.size, 30);
    expect(inheritedIconTheme?.color, Colors.green);
  });

  testWidgets('TThemeBuilder 的 Material 投影仍属于 Token 层', (tester) async {
    late ThemeData material;
    late IconThemeData? inheritedIconTheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Builder(
          builder: (context) {
            material = Theme.of(context);
            inheritedIconTheme = context.tExplicitIconTheme;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(material.tExplicitColorScheme, isNull);
    expect(material.tExplicitTextTheme, isNull);
    expect(material.tExplicitIconTheme, isNull);
    expect(inheritedIconTheme, isNull);
    expect(material.tExplicitDividerColor, isNull);
  });

  testWidgets('Input 清除图标忽略隐式 IconTheme 并回退到 Token', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(token),
        home: const Scaffold(
          body: TInput(
            initialValue: 'value',
            clearButtonMode: TInputClearButtonMode.always,
          ),
        ),
      ),
    );

    final clearIcon = tester.widget<Icon>(
      find.byIcon(TIcons.close_circle_filled),
    );
    expect(clearIcon.color, token.textColorPlaceholder);
  });

  testWidgets('Switch 保持几何且遵循 Component > Material > ColorScheme > Token', (
    tester,
  ) async {
    Future<(Color?, Size)> resolve(Widget widget) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      final native = tester.widget<TCupertinoSwitch>(
        find.byType(TCupertinoSwitch),
      );
      return (native.activeColor, tester.getSize(find.byType(TSwitch)));
    }

    final token = TThemeData.defaultData();
    final defaults = await resolve(
      wrap(const TSwitch(value: true, onChanged: _noop)),
    );
    expect(defaults.$1, token.brandNormalColor);

    final colorScheme = await resolve(
      wrap(
        const TSwitch(value: true, onChanged: _noop),
        colorScheme: customScheme,
      ),
    );
    expect(colorScheme.$1, customScheme.primary);
    expect(colorScheme.$2, defaults.$2);

    final material = await resolve(
      wrap(
        const TSwitch(value: true, onChanged: _noop),
        colorScheme: customScheme,
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.all(Colors.red),
        ),
      ),
    );
    expect(material.$1, Colors.red);
    expect(material.$2, defaults.$2);

    final component = await resolve(
      wrap(
        const TSwitch(value: true, onChanged: _noop),
        colorScheme: customScheme,
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.all(Colors.red),
        ),
        componentTheme: const TSwitchThemeData(trackOnColor: Colors.green),
      ),
    );
    expect(component.$1, Colors.green);
    expect(component.$2, defaults.$2);
  });

  testWidgets('Checkbox 遵循 Component > Material > ColorScheme > Token', (
    tester,
  ) async {
    Future<Color?> resolve(Widget widget) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      return tester.widget<Icon>(find.byType(Icon)).color;
    }

    expect(
      await resolve(
        wrap(const TCheckbox(value: true, onChanged: _checkboxNoop)),
      ),
      TThemeData.defaultData().brandNormalColor,
    );
    expect(
      await resolve(
        wrap(
          const TCheckbox(value: true, onChanged: _checkboxNoop),
          colorScheme: customScheme,
        ),
      ),
      customScheme.primary,
    );
    expect(
      await resolve(
        MaterialApp(
          theme: ThemeData(
            colorScheme: customScheme,
            checkboxTheme: CheckboxThemeData(
              fillColor: WidgetStateProperty.all(Colors.red),
            ),
            extensions: [TThemeData.defaultData()],
          ),
          home: const Scaffold(
            body: TCheckbox(value: true, onChanged: _checkboxNoop),
          ),
        ),
      ),
      Colors.red,
    );
    expect(
      await resolve(
        wrap(
          const TCheckbox(value: true, onChanged: _checkboxNoop),
          colorScheme: customScheme,
          componentTheme: const TCheckboxThemeData(selectColor: Colors.green),
        ),
      ),
      Colors.green,
    );
  });

  testWidgets('Loading Material/ColorScheme 只改变颜色、不改变尺寸', (tester) async {
    Future<(Color?, Size)> resolve(ThemeData theme) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          themeAnimationDuration: Duration.zero,
          home: const Scaffold(body: TLoading(size: TLoadingSize.medium)),
        ),
      );
      final indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      return (indicator.color, tester.getSize(find.byType(TCircleIndicator)));
    }

    final token = TThemeData.defaultData();
    final defaults = await resolve(ThemeData(extensions: [token]));
    expect(defaults.$1, token.brandNormalColor);

    final material = await resolve(
      ThemeData(
        colorScheme: customScheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.red,
        ),
        extensions: [token],
      ),
    );
    expect(material.$1, Colors.red);
    expect(material.$2, defaults.$2);

    final component = await resolve(
      ThemeData(
        colorScheme: customScheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.red,
        ),
        extensions: [
          token,
          const TLoadingThemeData(iconColor: Colors.green),
        ],
      ),
    );
    expect(component.$1, Colors.green);
    expect(component.$2, defaults.$2);
  });

  testWidgets(
    'Input 遵循 Instance > Component > Material > ColorScheme > Token',
    (tester) async {
      Future<TextField> resolve(ThemeData theme, TInput input) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            themeAnimationDuration: Duration.zero,
            home: Scaffold(body: input),
          ),
        );
        return tester.widget<TextField>(find.byType(TextField));
      }

      final token = TThemeData.defaultData();
      final defaults = await resolve(
        ThemeData(extensions: [token]),
        const TInput(),
      );
      expect(defaults.style?.color, token.textColorPrimary);
      expect(defaults.cursorColor, token.brandNormalColor);

      final colorScheme = await resolve(
        ThemeData(colorScheme: customScheme, extensions: [token]),
        const TInput(),
      );
      expect(colorScheme.style?.color, customScheme.onSurface);
      expect(colorScheme.cursorColor, customScheme.primary);

      final material = await resolve(
        ThemeData(
          colorScheme: customScheme,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.red, fontSize: 19),
          ),
          extensions: [token],
        ),
        const TInput(),
      );
      expect(material.style?.color, Colors.red);
      expect(material.style?.fontSize, 19);

      final component = await resolve(
        ThemeData(
          colorScheme: customScheme,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.red, fontSize: 19),
          ),
          extensions: [
            token,
            const TInputThemeData(
              textStyle: TextStyle(color: Colors.green, fontSize: 20),
              cursorColor: Colors.green,
            ),
          ],
        ),
        const TInput(),
      );
      expect(component.style?.color, Colors.green);
      expect(component.style?.fontSize, 20);
      expect(component.cursorColor, Colors.green);

      final instance = await resolve(
        ThemeData(
          extensions: [
            token,
            const TInputThemeData(
              textStyle: TextStyle(color: Colors.green),
              cursorColor: Colors.green,
            ),
          ],
        ),
        const TInput(
          style: TextStyle(color: Colors.purple, fontSize: 21),
          cursorColor: Colors.purple,
        ),
      );
      expect(instance.style?.color, Colors.purple);
      expect(instance.style?.fontSize, 21);
      expect(instance.cursorColor, Colors.purple);
    },
  );

  testWidgets('展示组件读取显式 ColorScheme 但不改变默认几何', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: customScheme,
          extensions: [TThemeData.defaultData()],
        ),
        home: Scaffold(
          body: Column(
            children: [
              TLink(child: const Text('link'), onPressed: () {}),
              const TTag('tag'),
              const TResult(title: 'result'),
              const TNavBar(title: 'navbar', useDefaultBack: false),
              const TCell(title: Text('cell')),
            ],
          ),
        ),
      ),
    );

    expect(effectiveTextStyle(tester, 'link').color, customScheme.onSurface);
    expect(
      tester.widget<Text>(find.text('tag')).style?.color,
      customScheme.onSurface,
    );
    expect(
      tester.widget<Icon>(find.byIcon(TIcons.info_circle)).color,
      customScheme.primary,
    );
    expect(
      tester.widget<Text>(find.text('navbar')).style?.color,
      customScheme.onSurface,
    );
    final cellTextStyle = tester
        .widgetList<DefaultTextStyle>(
          find.descendant(
            of: find.byType(TCell),
            matching: find.byType(DefaultTextStyle),
          ),
        )
        .first;
    expect(cellTextStyle.style.color, customScheme.onSurface);
  });

  testWidgets('success/warning 无唯一 Material 语义时使用 TDesign Token', (
    tester,
  ) async {
    final token = TThemeData.defaultData();
    late TNoticeBarThemeData noticeTheme;
    late TNoticeBarThemeData warningNoticeTheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: customScheme, extensions: [token]),
        home: Scaffold(
          body: Column(
            children: [
              TLink(
                colorScheme: TLinkColorScheme.success,
                onPressed: () {},
                child: const Text('success link'),
              ),
              const TTag(
                'success tag',
                colorScheme: TTagColorScheme.success,
                variant: TTagVariant.outline,
              ),
              const TResult(
                title: 'success result',
                variant: TResultVariant.success,
              ),
              TLink(
                colorScheme: TLinkColorScheme.warning,
                onPressed: () {},
                child: const Text('warning link'),
              ),
              const TTag(
                'warning tag',
                colorScheme: TTagColorScheme.warning,
                variant: TTagVariant.outline,
              ),
              const TResult(
                title: 'warning result',
                variant: TResultVariant.warning,
              ),
              Builder(
                builder: (context) {
                  noticeTheme = const TNoticeBarThemeData(
                    variant: TNoticeBarVariant.success,
                  ).resolve(context);
                  warningNoticeTheme = const TNoticeBarThemeData(
                    variant: TNoticeBarVariant.warning,
                  ).resolve(context);
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      effectiveTextStyle(tester, 'success link').color,
      token.successNormalColor,
    );
    expect(
      tester.widget<Text>(find.text('success tag')).style?.color,
      token.successNormalColor,
    );
    expect(
      tester.widget<Icon>(find.byIcon(TIcons.check_circle)).color,
      token.successNormalColor,
    );
    expect(noticeTheme.leftIconColor, token.successNormalColor);
    expect(noticeTheme.backgroundColor, token.successLightColor);
    expect(
      effectiveTextStyle(tester, 'warning link').color,
      token.warningNormalColor,
    );
    expect(
      tester.widget<Text>(find.text('warning tag')).style?.color,
      token.warningNormalColor,
    );
    expect(
      tester.widget<Icon>(find.byIcon(TIcons.error_circle)).color,
      token.warningNormalColor,
    );
    expect(warningNoticeTheme.leftIconColor, token.warningNormalColor);
    expect(warningNoticeTheme.backgroundColor, token.warningLightColor);
  });
}

void _noop(bool value) {}

void _checkboxNoop(bool? value) {}
