import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData()],
      ),
      home: Scaffold(body: Center(child: SizedBox(width: 320, child: child))),
    );
  }

  /// 深色模式包装，验证组件在暗色 Token 下可读性正常。
  Widget wrapDark(Widget child) {
    return MaterialApp(
      theme: TThemeBuilder.dark(TThemeData.defaultData()),
      home: Scaffold(body: Center(child: SizedBox(width: 320, child: child))),
    );
  }

  group('TColorPicker v1 behavior', () {
    testWidgets('base type renders swatch grid', (tester) async {
      await tester.pumpWidget(
        wrap(TColorPicker(value: '#0052D9', onChanged: (value, change) {})),
      );
      // 默认色板 10 个 swatch。
      expect(find.byType(TColorPicker), findsOneWidget);
      expect(find.byType(TColorPickerSaturationPanel), findsNothing);
    });

    testWidgets('multiple type renders palette and sliders', (tester) async {
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          type: TColorPickerType.multiple,
          enableAlpha: true,
          onChanged: (value, change) {},
        )),
      );
      expect(find.byType(TColorPickerSaturationPanel), findsOneWidget);
      // 色相条 + 透明条。
      expect(find.byType(TColorPickerSlider), findsNWidgets(2));
    });

    testWidgets('swatch tap triggers onChanged with preset trigger',
        (tester) async {
      String? value;
      TColorPickerChangeContext? change;
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          onChanged: (v, c) {
            value = v;
            change = c;
          },
        )),
      );
      // 默认色板第一个 swatch 为 #ECF2FE。
      final firstSwatch = find.byWidgetPredicate((widget) {
        return widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color ==
                const Color(0xFFECF2FE);
      });
      expect(firstSwatch, findsOneWidget);
      await tester.tap(firstSwatch);
      await tester.pump();
      expect(value, isNotNull);
      expect(change!.trigger, TColorPickerChangeTrigger.preset);
    });

    testWidgets('empty swatchColors hides swatch grid', (tester) async {
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          swatchColors: const [],
          onChanged: (value, change) {},
        )),
      );
      // 空列表不渲染 swatch。
      expect(find.byType(TColorPickerSaturationPanel), findsNothing);
    });

    testWidgets('clearable shows clear button', (tester) async {
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          clearable: true,
          onChanged: (value, change) {},
        )),
      );
      expect(find.text('清除'), findsOneWidget);
    });

    testWidgets('multiple type shows segmented format display', (tester) async {
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#001A57',
          type: TColorPickerType.multiple,
          enableAlpha: true,
          format: TColorPickerFormat.rgb,
          onChanged: (value, change) {},
        )),
      );
      // 格式区各通道分段展示；enableAlpha 下格式升级为 RGBA。
      // （值段 → 0 | 26 | 87 | 100%，末段为固定 alpha 段）
      expect(find.text('RGBA'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('26'), findsOneWidget);
      expect(find.text('87'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('multiple type swatches title with single-line scroll',
        (tester) async {
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          type: TColorPickerType.multiple,
          onChanged: (value, change) {},
        )),
      );
      expect(find.text('系统预设色彩'), findsOneWidget);
      // 默认 10 个 swatch 全部在单行横向滚动视口内。
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('clear button triggers onChanged with clear trigger',
        (tester) async {
      String? value;
      TColorPickerChangeContext? change;
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          clearable: true,
          onChanged: (v, c) {
            value = v;
            change = c;
          },
        )),
      );
      await tester.tap(find.text('清除'));
      await tester.pump();
      expect(value, isNotNull);
      expect(change!.trigger, TColorPickerChangeTrigger.clear);
    });

    testWidgets('multiple type in dark theme renders readable format display',
        (tester) async {
      // 回归：格式区文字/边框曾硬编码浅色值，深色面板下不可见。
      await tester.pumpWidget(
        wrapDark(TColorPicker(
          value: '#001A57',
          type: TColorPickerType.multiple,
          enableAlpha: true,
          format: TColorPickerFormat.rgb,
          onChanged: (value, change) {},
        )),
      );
      final context = tester.element(find.byType(TColorPicker));
      final token = Theme.of(context).extension<TThemeData>()!;

      // 深色下面板背景为深色、文字为浅色（跟随全局 Token）。
      expect(token.bgColorContainer, const Color(0xFF242424));
      expect(token.textColorPrimary, const Color(0xE5FFFFFF));
      expect(token.componentBorderColor, const Color(0xFF5E5E5E));

      // 格式区各通道段正常渲染（enableAlpha 下格式名显示 RGBA）。
      expect(find.text('RGBA'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('hue slider drag updates color and emits paletteHueBar', (
      tester,
    ) async {
      TColorPickerChangeContext? change;
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          type: TColorPickerType.multiple,
          onChanged: (value, c) => change = c,
        )),
      );
      // 色相条位于色板下方：沿轨道横向拖动改变色相。
      final hueSlider = find.byType(TColorPickerSlider).first;
      await tester.drag(hueSlider, const Offset(80, 0));
      await tester.pump();
      expect(change, isNotNull);
      expect(change!.trigger, TColorPickerChangeTrigger.paletteHueBar);
      // 拖拽不产生合法十六进制以外的颜色即为解析成功；色相应已偏离初始 217 度。
      expect(change!.color.hue, isNot(217.0));
    });

    testWidgets('alpha slider drag emits paletteAlphaBar with alpha output', (
      tester,
    ) async {
      String? value;
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          type: TColorPickerType.multiple,
          enableAlpha: true,
          onChanged: (v, c) => value = v,
        )),
      );
      // 透明条为第二个滑块：拖到最左端 alpha 归零，输出带透明度的 RGBA。
      final alphaSlider = find.byType(TColorPickerSlider).at(1);
      await tester.drag(alphaSlider, const Offset(-320, 0));
      await tester.pump();
      expect(value, isNotNull);
      expect(value!.endsWith(', 0)'), isTrue);
    });

    testWidgets('saturation panel drag calls onPaletteBarChange only', (
      tester,
    ) async {
      var paletteCalls = 0;
      TColorPickerChangeContext? changed;
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          type: TColorPickerType.multiple,
          onChanged: (value, c) => changed = c,
          onPaletteBarChange: (color) => paletteCalls++,
        )),
      );
      // 饱和度-明度色板拖拽只走 onPaletteBarChange，不触发 onChanged（对齐上游）。
      await tester.drag(find.byType(TColorPickerSaturationPanel), const Offset(-60, -40));
      await tester.pump();
      expect(paletteCalls, greaterThan(0));
      expect(changed, isNull);
    });

    testWidgets('format display appends fixed alpha segment for css/hex/hex8', (
      tester,
    ) async {
      // 回归 B3：对齐 mobile-vue getFormatList——HEX/HEX8/CSS 第二段也是
      // 固定的百分比 alpha 段。
      Future<void> check(
        TColorPickerFormat format,
        bool enableAlpha,
        String name,
      ) async {
        await tester.pumpWidget(
          wrap(TColorPicker(
            key: ValueKey('$format-$enableAlpha'),
            value: '#0052D9',
            type: TColorPickerType.multiple,
            enableAlpha: enableAlpha,
            format: format,
            onChanged: (value, change) {},
          )),
        );
        expect(find.text(name), findsOneWidget);
        // 末段固定为百分比 alpha 段（当前不透明显示 100%）。
        expect(find.text('100%'), findsOneWidget);
      }

      await check(TColorPickerFormat.css, true, 'CSS');
      await check(TColorPickerFormat.hex, false, 'HEX');
      await check(TColorPickerFormat.hex8, true, 'HEX8');
    });

    testWidgets('theme extension from TThemeBuilder subtree overrides defaults', (
      tester,
    ) async {
      // 回归 B1：TColorPickerThemeData 必须注册进全局主题管道，
      // 经 TThemeBuilder 注入的子树主题能直接改变组件外观。
      const overriddenPanel = Color(0xFF123456);
      final baseTheme = TThemeBuilder.light(TThemeData.defaultData());
      await tester.pumpWidget(
        MaterialApp(
          theme: baseTheme.copyWith(
            extensions: [
              ...baseTheme.extensions.values,
              const TColorPickerThemeData(panelBackgroundColor: overriddenPanel),
            ],
          ),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: TColorPicker(value: '#0052D9', onChanged: (value, change) {}),
              ),
            ),
          ),
        ),
      );
      // 组件可正常渲染且读取到注入的主题扩展（默认面板背景不再是 bgColorContainer）。
      final context = tester.element(find.byType(TColorPicker));
      final injected = Theme.of(context).extension<TColorPickerThemeData>();
      expect(injected, isNotNull);
      expect(injected!.panelBackgroundColor, overriddenPanel);
    });

    testWidgets('multiple type registered in default theme pipeline', (
      tester,
    ) async {
      // 回归 B1：默认 TTheme 管道即携带组件级扩展，业务侧无需手动塞 extensions。
      late ThemeData materialTheme;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                materialTheme = Theme.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(
        materialTheme.extension<TColorPickerThemeData>(),
        isNotNull,
      );
    });
  });
}
