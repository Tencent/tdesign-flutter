import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/badge/t_badge_resolved_style.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';
import 'package:tdesign_flutter/src/components/switch/t_cupertino_switch.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  const materialColor = Color(0xFF123ABC);
  const componentColor = Color(0xFFABC123);

  ThemeData hostTheme({List<ThemeExtension<dynamic>> extensions = const []}) {
    return ThemeData(
      colorScheme: const ColorScheme.light(primary: materialColor),
      iconTheme: const IconThemeData(color: materialColor, size: 28),
      dividerColor: materialColor,
      disabledColor: materialColor,
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.all(materialColor),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: materialColor,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: materialColor,
        inactiveTrackColor: materialColor,
      ),
      badgeTheme: const BadgeThemeData(backgroundColor: materialColor),
      extensions: [TThemeData.defaultData(), ...extensions],
    );
  }

  testWidgets('TDesign Token 单向投影到原生 Material 主题', (tester) async {
    final token = TThemeData.defaultData();
    late ThemeData material;
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(token),
        home: Builder(
          builder: (context) {
            material = Theme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(material.colorScheme.primary, token.brandColor);
    expect(material.iconTheme.color, token.textColorPrimary);
    expect(material.extension<TThemeData>(), isNotNull);
  });

  testWidgets('Tag 忽略 Material 色板，组件 Theme 仍控制本组件', (tester) async {
    Color? fillOf(String label) {
      final tag = find.ancestor(
        of: find.text(label),
        matching: find.byType(TTag),
      );
      final container = tester.widget<Container>(
        find
            .descendant(
              of: tag,
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      return (container.decoration! as BoxDecoration).color;
    }

    await tester.pumpWidget(
      MaterialApp(
        theme: hostTheme(),
        home: Scaffold(
          body: Column(
            children: [
              const TTag(
                'Token',
                colorPreset: TTagColorPreset.primary,
                variant: TTagVariant.light,
              ),
              Theme(
                data: hostTheme(
                  extensions: const [
                    TTagThemeData(backgroundColor: componentColor),
                  ],
                ),
                child: const TTag(
                  'Component',
                  colorPreset: TTagColorPreset.primary,
                  variant: TTagVariant.light,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(fillOf('Token'), TThemeData.defaultData().brandColorLight);
    expect(fillOf('Component'), componentColor);
  });

  testWidgets('Icon、Loading、Switch 不接收 Material 外观反向输入', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(
      MaterialApp(
        theme: hostTheme(),
        home: const Scaffold(
          body: Column(
            children: [
              TIcon(Icons.close),
              TLoading(),
              TSwitch(value: true, onChanged: _noop),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.widget<Icon>(find.byIcon(Icons.close)).color,
      token.textColorPrimary,
    );
    expect(
      tester.widget<TCircleIndicator>(find.byType(TCircleIndicator)).color,
      token.brandColor,
    );
    expect(
      tester
          .widget<TCupertinoSwitch>(find.byType(TCupertinoSwitch))
          .activeColor,
      token.brandColor,
    );
  });

  testWidgets('Slider 使用组件 Theme，忽略 Material SliderTheme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: hostTheme(
          extensions: const [
            TSliderThemeData(inactiveTrackColor: componentColor),
          ],
        ),
        home: const Scaffold(body: TSlider(value: 0.5, onChanged: _sliderNoop)),
      ),
    );

    final sliderTheme = SliderTheme.of(tester.element(find.byType(Slider)));
    expect(sliderTheme.activeTrackColor, TThemeData.defaultData().brandColor);
    expect(sliderTheme.inactiveTrackColor, componentColor);
  });

  testWidgets('Badge 使用组件 Theme，忽略 Material BadgeTheme', (tester) async {
    late TBadgeResolvedStyle style;
    await tester.pumpWidget(
      MaterialApp(
        theme: hostTheme(
          extensions: const [TBadgeThemeData(backgroundColor: componentColor)],
        ),
        home: Builder(
          builder: (context) {
            style = TBadgeResolvedStyle.resolve(context, large: false);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(style.backgroundColor, componentColor);
    expect(style.textColor, TThemeData.defaultData().textColorAnti);
  });
}

void _noop(bool value) {}

void _sliderNoop(double value) {}
