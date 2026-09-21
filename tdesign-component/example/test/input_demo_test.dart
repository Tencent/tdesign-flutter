import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/input/input_page.dart';

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

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('input invalid phone ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final phoneInput = find.descendant(
        of: find.widgetWithText(TInput, '输入手机号码'),
        matching: find.byType(EditableText),
      );
      expect(phoneInput, findsOneWidget);
      await tester.enterText(phoneInput, '123');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(find.text('手机号输入不正确'), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('input-demo-page')),
        matchesGoldenFile('goldens/input_invalid_phone_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }

  testWidgets('状态与手机号示例保持设计稿初始状态', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    expect(find.text('只读模式'), findsNothing);
    expect(find.text('17600600600'), findsNothing);
    expect(find.text('输入手机号码'), findsOneWidget);
  }, tags: 'demo');

  testWidgets('图形验证码左侧保留分割线', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    final captcha = find.byKey(const ValueKey('input-captcha'));
    final suffixRow = find.ancestor(of: captcha, matching: find.byType(Row));
    final captchaBox = find.ancestor(
      of: captcha,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 72 && widget.height == 36,
      ),
    );
    final divider = find.descendant(
      of: suffixRow.first,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.maxWidth == 1 &&
            widget.constraints?.maxHeight == 24,
      ),
    );

    expect(captcha, findsOneWidget);
    expect(captchaBox, findsOneWidget);
    expect(find.text('DwrSe'), findsOneWidget);
    expect(divider, findsOneWidget);
    expect(
      tester.widget<Container>(divider).color,
      TThemeData.defaultData().componentStrokeColor,
    );
    expect(
      tester.getTopLeft(captchaBox).dx - tester.getTopRight(divider).dx,
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
