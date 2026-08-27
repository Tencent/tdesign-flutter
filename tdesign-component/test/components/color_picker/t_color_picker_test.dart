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
  });
}
