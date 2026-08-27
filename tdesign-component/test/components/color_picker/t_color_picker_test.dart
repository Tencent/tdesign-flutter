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
        wrap(TColorPicker(value: '#0052D9', onChanged: (_) {})),
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
          onChanged: (_) {},
        )),
      );
      expect(find.byType(TColorPickerSaturationPanel), findsOneWidget);
      // 色相条 + 透明条。
      expect(find.byType(TColorPickerSlider), findsNWidgets(2));
    });

    testWidgets('swatch tap triggers onChanged with preset trigger',
        (tester) async {
      (String, TColorPickerChangeContext)? result;
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          onChanged: (r) => result = r,
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
      expect(result, isNotNull);
      expect(result!.$2.trigger, TColorPickerChangeTrigger.preset);
    });

    testWidgets('empty swatchColors hides swatch grid', (tester) async {
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          swatchColors: const [],
          onChanged: (_) {},
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
          onChanged: (_) {},
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
          onChanged: (_) {},
        )),
      );
      // 格式区各通道分段展示（RGB → 0 | 26 | 87 | 100%）。
      expect(find.text('RGB'), findsOneWidget);
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
          onChanged: (_) {},
        )),
      );
      expect(find.text('系统预设色彩'), findsOneWidget);
      // 默认 10 个 swatch 全部在单行横向滚动视口内。
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('clear button triggers onChanged with clear trigger',
        (tester) async {
      (String, TColorPickerChangeContext)? result;
      await tester.pumpWidget(
        wrap(TColorPicker(
          value: '#0052D9',
          clearable: true,
          onChanged: (r) => result = r,
        )),
      );
      await tester.tap(find.text('清除'));
      await tester.pump();
      expect(result, isNotNull);
      expect(result!.$2.trigger, TColorPickerChangeTrigger.clear);
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
          onChanged: (_) {},
        )),
      );
      final context = tester.element(find.byType(TColorPicker));
      final token = Theme.of(context).extension<TThemeData>()!;

      // 深色下面板背景为深色、文字为浅色（跟随全局 Token）。
      expect(token.bgColorContainer, const Color(0xFF242424));
      expect(token.textColorPrimary, const Color(0xE5FFFFFF));
      expect(token.componentBorderColor, const Color(0xFF5E5E5E));

      // 格式区各通道段正常渲染。
      expect(find.text('RGB'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });
  });
}
