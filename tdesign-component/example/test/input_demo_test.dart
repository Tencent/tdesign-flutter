import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_input_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'input',
    title: 'Input 输入框',
    page: TInputViewPage(),
    expectedTexts: ['01 组件类型', '02 组件状态', '03 组件样式'],
    componentType: TInput,
  );
  registerDemoPageTests(spec);

  testWidgets('图形验证码左侧保留分割线', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    final captchaImage = find.byWidgetPredicate(
      (widget) => widget is Image && widget.width == 72 && widget.height == 36,
    );
    final suffixRow = find.ancestor(of: captchaImage, matching: find.byType(Row));
    final divider = find.descendant(
      of: suffixRow.first,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.maxWidth == 1 &&
            widget.constraints?.maxHeight == 24,
      ),
    );

    expect(captchaImage, findsOneWidget);
    expect(divider, findsOneWidget);
    expect(
      tester.widget<Container>(divider).color,
      TThemeData.defaultData().componentStrokeColor,
    );
    expect(
      tester.getTopLeft(captchaImage).dx - tester.getTopRight(divider).dx,
      16,
    );
  }, tags: 'demo');

  testWidgets('发送验证码操作区保留左侧分割线', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    final actionText = find.text('发送验证码');
    final suffixRow = find.ancestor(of: actionText, matching: find.byType(Row));
    final divider = find.descendant(
      of: suffixRow.first,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.maxWidth == 1 &&
            widget.constraints?.maxHeight == 24,
      ),
    );

    expect(divider, findsOneWidget);
    expect(
      tester.widget<Container>(divider).color,
      TThemeData.defaultData().componentStrokeColor,
    );
    expect(
      tester.getTopLeft(divider).dx,
      lessThan(tester.getTopLeft(actionText).dx),
    );
    expect(
      tester.getTopLeft(actionText).dx - tester.getTopRight(divider).dx,
      16,
    );
  }, tags: 'demo');
}
