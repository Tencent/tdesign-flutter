import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/button/button_page.dart';
import 'package:tdesign_flutter_example/page/button/disable_primary_fill_button_example.dart';
import 'package:tdesign_flutter_example/page/button/large_button_example.dart';
import 'package:tdesign_flutter_example/page/button/rectangle_shape_button_example.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'button',
      title: 'Button 按钮',
      page: TButtonPage(),
      expectedTexts: ['01 组件类型', '02 组件状态', '03 组件样式'],
      componentType: TButton,
      expectedComponentCount: 40,
    ),
  );

  testWidgets('button Demo keeps wrapped examples aligned to design grid', (
    tester,
  ) async {
    Future<void> pumpExample(Widget child) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(body: child),
        ),
      );
      await tester.pump();
    }

    await pumpExample(const DisablePrimaryFillButtonExample());
    var buttons = find.byType(TButton);
    expect(buttons, findsNWidgets(5));
    final runStarts = <double, double>{};
    for (var index = 0; index < 5; index++) {
      final topLeft = tester.getTopLeft(buttons.at(index));
      runStarts.update(
        topLeft.dy,
        (current) => topLeft.dx < current ? topLeft.dx : current,
        ifAbsent: () => topLeft.dx,
      );
    }
    expect(runStarts.length, 2);
    expect(runStarts.values, everyElement(16));

    await pumpExample(const LargeButtonExample());
    buttons = find.byType(TButton);
    expect(buttons, findsNWidgets(4));
    expect(tester.getTopLeft(buttons.first).dx, 16);
    expect(
      tester.getTopLeft(buttons.at(1)).dx -
          tester.getTopRight(buttons.at(0)).dx,
      12,
    );

    await pumpExample(const RectangleShapeButtonExample());
    buttons = find.byType(TButton);
    expect(buttons, findsNWidgets(5));
    expect(tester.getTopLeft(buttons.first).dx, 16);
    expect(tester.getSize(buttons.last).width, 375);
    final blockButton = tester.widget<ElevatedButton>(
      find.descendant(of: buttons.last, matching: find.byType(ElevatedButton)),
    );
    final blockShape = blockButton.style?.shape?.resolve({});
    expect(blockShape, isA<RoundedRectangleBorder>());
    expect(
      (blockShape! as RoundedRectangleBorder).borderRadius,
      BorderRadius.zero,
    );
    expect(find.text('矩形'), findsNothing);
    expect(find.text('填充按钮'), findsNWidgets(3));
  }, tags: 'demo');

  testWidgets('button 页面不再二次居中左对齐示例', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      const DemoPageTestSpec(
        name: 'button',
        title: 'Button 按钮',
        page: TButtonPage(),
        expectedTexts: ['01 组件类型', '02 组件状态', '03 组件样式'],
        componentType: TButton,
      ),
      ThemeMode.light,
    );

    final loading = find.byType(TLoading);
    expect(tester.widget<TLoading>(loading).size, 24);
    expect(
      tester.widget<TCircleIndicator>(find.byType(TCircleIndicator)).color,
      TThemeData.defaultData().whiteColor1,
    );

    final disabledButton = find.widgetWithText(TButton, '描边按钮').first;
    await tester.scrollUntilVisible(disabledButton, 300);
    expect(tester.getTopLeft(disabledButton).dx, 16);

    final sizeButton = find.widgetWithText(TButton, '按钮48');
    await tester.scrollUntilVisible(sizeButton, 300);
    expect(tester.getTopLeft(sizeButton).dx, 16);

    await disposeDemoPage(tester);
  }, tags: 'demo');
}
