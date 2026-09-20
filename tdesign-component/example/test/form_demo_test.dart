import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';
import 'package:tdesign_flutter_example/page/form/form_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  tearDown(TToast.dismissAll);

  const spec = DemoPageTestSpec(
    name: 'form',
    title: 'Form 表单',
    page: TFormPage(),
    expectedTexts: ['01 组件类型'],
    componentType: TFormItem,
    supplementalCjkFontFamily: 'TDesign Form Golden CJK',
    supplementalCjkFontPath: 'test/fonts/FormGoldenCJK-Regular.otf',
  );
  registerDemoPageTests(spec);

  testWidgets('查看代码入口映射到完整可运行示例', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    final wrapper = tester.widget<CodeWrapper>(find.byType(CodeWrapper));
    expect(wrapper.methodName, 'FormBasicDemo');
    final code = await rootBundle.loadString(
      'assets/code/form.FormBasicDemo.txt',
    );
    expect(code, contains('class FormBasicDemo extends StatefulWidget'));
    expect(code, contains('class _FormBasicDemoState'));
    expect(code, contains('Widget _buildForm(BuildContext context)'));

    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    await tester.tap(find.text('code'));
    await tester.pumpAndSettle();

    final panel = tester.widget<Markdown>(find.byType(Markdown));
    expect(panel.data, contains(code));
    Navigator.of(tester.element(find.byType(Markdown))).pop();
    await tester.pumpAndSettle();
    await disposeDemoPage(tester);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('form ${mode.name} vertical Demo golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      await tester.tap(find.byKey(const ValueKey('form-layout-vertical')));
      await tester.pump();
      await _expandCurrentDemoPage(tester);

      await expectLater(
        find.byKey(const ValueKey('form-demo-page')),
        matchesGoldenFile('goldens/form_page_vertical_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('form ${mode.name} disabled Demo golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      await tester.tap(find.byKey(const ValueKey('form-disabled-switch')));
      await tester.pump();
      _resetDemoScroll(tester);

      await expectLater(
        find.byKey(const ValueKey('form-demo-page')),
        matchesGoldenFile('goldens/form_page_disabled_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }

  testWidgets('默认值与设计稿正常态一致', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    expect(find.text('Abcdefgh'), findsOneWidget);
    expect(find.text('输入用户名'), findsNothing);
    expect(find.text('2022-08-10'), findsOneWidget);
    expect(find.text('广东省 深圳市'), findsOneWidget);
    expect(find.text(_resume), findsOneWidget);
    expect(find.text('竖向排布'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('form-resume-content'))).height,
      124,
    );
    expect(
      tester
          .widget<TRadioGroup<String>>(
            find.byKey(const ValueKey('form-gender-options')),
          )
          .value,
      'man',
    );
    expect(tester.widget<TRate>(find.byType(TRate)).value, 3.5);
  });

  testWidgets('提交成功通过 TForm onSubmit 给出反馈', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    final submit = find.byKey(const ValueKey('form-submit-button'));
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pump();

    expect(find.text('提交成功'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('提交成功'), findsNothing);
  });

  testWidgets('重置后恢复全部设计默认值并清除校验错误', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);
    final inputs = tester.widgetList<TInput>(find.byType(TInput)).toList();
    final name = inputs[0].controller!;
    final password = inputs[1].controller!;
    final resume = tester.widget<TTextarea>(find.byType(TTextarea)).controller!;

    name.text = 'Changed';
    password.text = 'short';
    resume.text = '';
    _field<String>(tester, 'name').onChanged?.call(name.text);
    _field<String>(tester, 'password').onChanged?.call(password.text);
    _field<String>(tester, 'resume').onChanged?.call(resume.text);
    _field<String>(tester, 'gender').onChanged?.call('women');
    _field<String>(tester, 'birth').onChanged?.call('2000-01-01');
    _field<String>(tester, 'place').onChanged?.call('北京市 海淀区');
    _field<num>(tester, 'age').onChanged?.call(8);
    _field<double>(tester, 'description').onChanged?.call(1);
    _field<List<TUploadFile>>(tester, 'photo').onChanged?.call(const []);
    await tester.pump();

    final submit = find.byKey(const ValueKey('form-submit-button'));
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pump();
    expect(find.text('只能输入8个字符英文'), findsOneWidget);
    expect(find.text('请上传照片'), findsOneWidget);

    final reset = find.byKey(const ValueKey('form-reset-button'));
    await tester.ensureVisible(reset);
    await tester.pumpAndSettle();
    await tester.tap(reset);
    await tester.pumpAndSettle();

    expect(name.text, 'Abcdefgh');
    expect(password.text, '12345678');
    expect(resume.text, _resume);
    expect(_field<String>(tester, 'gender').value, 'man');
    expect(_field<String>(tester, 'birth').value, '2022-08-10');
    expect(_field<String>(tester, 'place').value, '广东省 深圳市');
    expect(_field<num>(tester, 'age').value, 3);
    expect(_field<double>(tester, 'description').value, 3.5);
    expect(_field<List<TUploadFile>>(tester, 'photo').value, hasLength(2));
    expect(find.text('只能输入8个字符英文'), findsNothing);
    expect(find.text('请上传照片'), findsNothing);
  });

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

    await tester.tap(find.byKey(const ValueKey('form-disabled-switch')));
    await tester.pump();
    final formFields = find.byWidgetPredicate((widget) => widget is TFormField);
    expect(formFields, findsNWidgets(9));
    _expectFieldCallbacks(tester, isNull);
    expect(
      tester
          .widget<TButton>(find.byKey(const ValueKey('form-reset-button')))
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<TButton>(find.byKey(const ValueKey('form-submit-button')))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('form-disabled-switch')));
    await tester.pump();
    _expectFieldCallbacks(tester, isNotNull);
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

    final genderOptions = find.byKey(const ValueKey('form-gender-options'));
    final radios = tester.widgetList<TRadio<String>>(
      find.descendant(of: genderOptions, matching: find.byType(TRadio<String>)),
    );
    expect(radios, hasLength(3));
    expect(
      radios.map((radio) => radio.variant),
      everyElement(TRadioVariant.inline),
    );

    await tester.tap(find.descendant(of: genderItem, matching: find.text('女')));
    await tester.pump();
    expect(tester.widget<TRadioGroup<String>>(genderOptions).value, 'women');
  });

  testWidgets('竖向性别间距和底部按钮顺序符合设计', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);
    await tester.tap(find.byKey(const ValueKey('form-layout-vertical')));
    await tester.pump();

    final genderItem = find.byKey(const ValueKey('form-gender-item'));
    final label = find.descendant(of: genderItem, matching: find.text('性别'));
    final options = find.byKey(const ValueKey('form-gender-options'));
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

  testWidgets('日期和籍贯弹窗为 Picker 保留完整高度', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    await tester.tap(find.text('2022-08-10'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(TDateTimePicker)).height, 200);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('广东省 深圳市'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(TPicker)).height, 200);
  });

  testWidgets('日期和籍贯确认后再次打开保留当前值', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    await tester.tap(find.text('2022-08-10'));
    await tester.pumpAndSettle();
    const changedDate = TDateTimePickerValue(year: 2024, month: 5, day: 6);
    tester
        .widget<TDateTimePicker>(find.byType(TDateTimePicker))
        .onChanged
        ?.call(changedDate);
    await tester.pump();
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(find.text('2024-05-06'), findsOneWidget);

    await tester.tap(find.text('2024-05-06'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TDateTimePicker>(find.byType(TDateTimePicker)).value,
      changedDate,
    );
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('广东省 深圳市'));
    await tester.pumpAndSettle();
    final picker = tester.widget<TPicker>(find.byType(TPicker));
    picker.onChanged?.call(
      const TPickerValue(
        selectedOptions: [
          TPickerOption(label: '北京市', value: 'beijing'),
          TPickerOption(label: '海淀区', value: 'haidian'),
        ],
        indexes: [1, 2],
      ),
    );
    await tester.pump();
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(find.text('北京市 海淀区'), findsOneWidget);

    await tester.tap(find.text('北京市 海淀区'));
    await tester.pumpAndSettle();
    expect(tester.widget<TPicker>(find.byType(TPicker)).value, [
      'beijing',
      'haidian',
    ]);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    final reset = find.byKey(const ValueKey('form-reset-button'));
    await tester.ensureVisible(reset);
    await tester.pumpAndSettle();
    await tester.tap(reset);
    await tester.pumpAndSettle();
    final initialPlace = find.text('广东省 深圳市');
    await tester.ensureVisible(initialPlace);
    await tester.tap(initialPlace);
    await tester.pumpAndSettle();
    expect(tester.widget<TPicker>(find.byType(TPicker)).value, [
      'guangdong',
      'shenzhen',
    ]);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await disposeDemoPage(tester);
  });

  testWidgets('日期和籍贯取消后丢弃草稿值', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    await tester.tap(find.text('2022-08-10'));
    await tester.pumpAndSettle();
    tester
        .widget<TDateTimePicker>(find.byType(TDateTimePicker))
        .onChanged
        ?.call(const TDateTimePickerValue(year: 2025, month: 6, day: 7));
    await tester.pump();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('2022-08-10'), findsOneWidget);
    await tester.tap(find.text('2022-08-10'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TDateTimePicker>(find.byType(TDateTimePicker)).value,
      const TDateTimePickerValue(year: 2022, month: 8, day: 10),
    );
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('广东省 深圳市'));
    await tester.pumpAndSettle();
    tester
        .widget<TPicker>(find.byType(TPicker))
        .onChanged
        ?.call(
          const TPickerValue(
            selectedOptions: [
              TPickerOption(label: '北京市', value: 'beijing'),
              TPickerOption(label: '朝阳区', value: 'chaoyang'),
            ],
            indexes: [1, 3],
          ),
        );
    await tester.pump();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('广东省 深圳市'), findsOneWidget);
    await tester.tap(find.text('广东省 深圳市'));
    await tester.pumpAndSettle();
    expect(tester.widget<TPicker>(find.byType(TPicker)).value, [
      'guangdong',
      'shenzhen',
    ]);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await disposeDemoPage(tester);
  });
}

Future<void> _expandCurrentDemoPage(WidgetTester tester) async {
  for (var attempt = 0; attempt < 4; attempt++) {
    final scrollable = _demoScrollable(tester);
    final extent = scrollable.position.maxScrollExtent;
    if (extent <= 0.01) {
      break;
    }
    tester.view.physicalSize = Size(
      tester.view.physicalSize.width,
      tester.view.physicalSize.height + extent,
    );
    await tester.pump();
  }
  _resetDemoScroll(tester);
}

void _resetDemoScroll(WidgetTester tester) {
  final scrollable = _demoScrollable(tester);
  if (scrollable.position.hasPixels) {
    scrollable.position.jumpTo(0);
  }
}

ScrollableState _demoScrollable(WidgetTester tester) {
  return tester.state<ScrollableState>(
    find
        .descendant(
          of: find.byType(CustomScrollView).first,
          matching: find.byType(Scrollable),
        )
        .first,
  );
}

TFormField<T> _field<T>(WidgetTester tester, String name) {
  return tester.widget<TFormField<T>>(
    find.byWidgetPredicate(
      (widget) => widget is TFormField<T> && widget.name == name,
    ),
  );
}

void _expectFieldCallbacks(WidgetTester tester, Matcher matcher) {
  for (final name in [
    'name',
    'password',
    'gender',
    'birth',
    'place',
    'resume',
  ]) {
    expect(_field<String>(tester, name).onChanged, matcher, reason: name);
  }
  expect(_field<num>(tester, 'age').onChanged, matcher, reason: 'age');
  expect(
    _field<double>(tester, 'description').onChanged,
    matcher,
    reason: 'description',
  );
  expect(
    _field<List<TUploadFile>>(tester, 'photo').onChanged,
    matcher,
    reason: 'photo',
  );
}

const _resume = '本人性格开朗、稳重、细心、待人热情、真诚，工作认真负责，积极主动，勇于创新，具有很强的团队协作精神。';
