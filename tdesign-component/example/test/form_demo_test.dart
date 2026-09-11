import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_form_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'form',
    title: 'Form 表单',
    page: TFormPage(),
    expectedTexts: ['01 组件类型'],
    componentType: TFormItem,
  );
  registerDemoPageTests(spec);

  testWidgets('排布按钮和禁用开关使用设计语义色', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);
    final token = TThemeData.defaultData();
    final vertical = tester.widget<TButton>(
      find.byKey(const ValueKey('form-layout-vertical')),
    );
    final verticalBackground = vertical.style?.backgroundColor?.resolve({});
    final switchContext = tester.element(
      find.byKey(const ValueKey('form-disabled-switch')),
    );

    expect(verticalBackground, token.bgColorSecondaryContainer);
    expect(
      Theme.of(switchContext).extension<TSwitchThemeData>()?.trackOffColor,
      token.componentBorderColor,
    );
  });

  testWidgets('水平字段内容左对齐且性别项垂直居中', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    for (final key in [
      'form-birth-item',
      'form-place-item',
      'form-age-item',
      'form-description-item',
    ]) {
      expect(
        tester.widget<TFormItem>(find.byKey(ValueKey(key))).contentAlignment,
        isNull,
      );
    }
    final genderItem = find.byKey(const ValueKey('form-gender-item'));
    final genderGroup = find.descendant(
      of: genderItem,
      matching: find.byType(TRadioGroup<String>),
    );
    final label = find.descendant(of: genderItem, matching: find.text('性别'));

    expect(
      tester.getCenter(label).dy,
      closeTo(tester.getCenter(genderGroup).dy, 0.01),
    );
  });

  testWidgets('竖向性别间距和底部按钮顺序符合设计', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);
    await tester.tap(find.byKey(const ValueKey('form-layout-vertical')));
    await tester.pump();

    final genderItem = find.byKey(const ValueKey('form-gender-item'));
    final label = find.descendant(of: genderItem, matching: find.text('性别'));
    final options = find.byKey(const ValueKey('form-vertical-gender-options'));
    final reset = find.byKey(const ValueKey('form-reset-button'));
    final submit = find.byKey(const ValueKey('form-submit-button'));

    expect(tester.getTopLeft(options).dy - tester.getBottomLeft(label).dy, 8);
    expect(
      tester.getBottomLeft(genderItem).dy - tester.getBottomLeft(options).dy,
      16,
    );
    expect(tester.getTopLeft(reset).dx, lessThan(tester.getTopLeft(submit).dx));
    expect(tester.widget<TButton>(reset).colorScheme, TButtonColorScheme.light);
    expect(
      tester.widget<TButton>(submit).colorScheme,
      TButtonColorScheme.primary,
    );
  });
}
