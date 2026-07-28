import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TFormThemeData? formTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (formTheme != null) formTheme,
        ],
      ),
      home: Scaffold(body: SizedBox(width: 400, child: child)),
    );
  }

  group('TForm and TFormField', () {
    testWidgets('valid submit returns registered controlled values',
        (tester) async {
      final controller = TFormController();
      Map<String, Object?>? submitted;
      String? saved;
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        onSubmit: (values) => submitted = values,
        child: TFormField<String>(
          name: 'name',
          value: 'TDesign',
          onChanged: (_) {},
          onSaved: (value) => saved = value,
          validator: (value) => value!.isEmpty ? 'required' : null,
          builder: (context, value, onChanged, errorText) => Text(value),
        ),
      )));

      expect(controller.values, {'name': 'TDesign'});
      expect(controller.validate(), isTrue);
      expect(controller.submit(), isTrue);
      expect(submitted, {'name': 'TDesign'});
      expect(saved, 'TDesign');
    });

    testWidgets('field change updates validation and submitted data',
        (tester) async {
      final controller = TFormController();
      var value = '';
      late StateSetter update;
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: value,
              onChanged: (next) => value = next,
              validator: (next) => next!.isEmpty ? 'required' : null,
              builder: (context, current, onChanged, errorText) => Column(
                children: [
                  Text(current),
                  Text(errorText ?? 'valid'),
                  TextButton(
                    onPressed: () => onChanged!('next'),
                    child: const Text('change'),
                  ),
                ],
              ),
            ),
          );
        },
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);

      await tester.tap(find.text('change'));
      expect(value, 'next');
      expect(controller.values, {'name': 'next'});
      update(() {});
      await tester.pump();
      expect(find.text('next'), findsOneWidget);
      expect(controller.submit(), isTrue);
    });

    testWidgets('disabled field exposes no change callback', (tester) async {
      ValueChanged<bool>? callback;
      await tester.pumpWidget(wrap(TForm(
        child: TFormField<bool>(
          name: 'enabled',
          value: false,
          builder: (context, value, onChanged, errorText) {
            callback = onChanged;
            return const SizedBox();
          },
        ),
      )));
      expect(callback, isNull);
    });

    testWidgets('showErrorMessage hides field error from builder',
        (tester) async {
      final key = GlobalKey<TFormState>();
      await tester.pumpWidget(wrap(TForm(
        key: key,
        showErrorMessage: false,
        child: TFormField<String>(
          name: 'name',
          value: '',
          onChanged: (_) {},
          validator: (_) => 'hidden error',
          builder: (context, value, onChanged, errorText) =>
              Text(errorText ?? 'hidden'),
        ),
      )));

      expect(key.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('hidden'), findsOneWidget);
      expect(find.text('hidden error'), findsNothing);
      key.currentState!.reset();
    });

    testWidgets('form item displays its field error without manual wiring',
        (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: '',
          onChanged: (_) {},
          validator: (value) => value!.isEmpty ? 'required' : null,
          builder: (context, value, onChanged, errorText) => const TFormItem(
            label: 'Name',
            help: 'Help',
            child: Text('Field'),
          ),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);
      expect(find.text('Help'), findsNothing);
    });

    testWidgets('explicit form item error overrides field error',
        (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: '',
          onChanged: (_) {},
          validator: (value) => value!.isEmpty ? 'field error' : null,
          builder: (context, value, onChanged, errorText) => const TFormItem(
            errorText: 'explicit error',
            child: Text('Field'),
          ),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('explicit error'), findsOneWidget);
      expect(find.text('field error'), findsNothing);
    });

    testWidgets('required field validates and marks its form item',
        (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: '   ',
          required: true,
          requiredMessage: '请输入姓名',
          onChanged: (_) {},
          builder: (context, value, onChanged, errorText) => const TFormItem(
            label: 'Name',
            child: Text('Field'),
          ),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('*'), findsOneWidget);
      expect(find.text('请输入姓名'), findsOneWidget);
    });

    testWidgets('required uses the default error message', (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: '',
          required: true,
          onChanged: (_) {},
          builder: (context, value, onChanged, errorText) =>
              Text(errorText ?? 'valid'),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('此项不能为空'), findsOneWidget);
    });

    testWidgets('required accepts false and zero values', (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: Column(
          children: [
            TFormField<bool>(
              name: 'enabled',
              value: false,
              required: true,
              onChanged: (_) {},
              builder: (context, value, onChanged, errorText) =>
                  const SizedBox(),
            ),
            TFormField<num>(
              name: 'count',
              value: 0,
              required: true,
              onChanged: (_) {},
              builder: (context, value, onChanged, errorText) =>
                  const SizedBox(),
            ),
          ],
        ),
      )));

      expect(controller.submit(), isTrue);
    });

    testWidgets('rules run before the original validator', (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: 'value',
          onChanged: (_) {},
          rules: [(value) => 'rule error'],
          validator: (value) => 'validator error',
          builder: (context, value, onChanged, errorText) =>
              Text(errorText ?? 'valid'),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('rule error'), findsOneWidget);
      expect(find.text('validator error'), findsNothing);
    });

    testWidgets('required handles empty collections and short-circuits rules',
        (tester) async {
      final controller = TFormController();
      var ruleCalls = 0;
      var validatorCalls = 0;
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: Column(
          children: [
            TFormField<List<String>>(
              name: 'list',
              value: const [],
              required: true,
              requiredMessage: 'list required',
              onChanged: (_) {},
              rules: [
                (value) {
                  ruleCalls += 1;
                  return 'rule error';
                },
              ],
              validator: (value) {
                validatorCalls += 1;
                return 'validator error';
              },
              builder: (context, value, onChanged, errorText) =>
                  Text(errorText ?? 'valid'),
            ),
            TFormField<Map<String, String>>(
              name: 'map',
              value: const {},
              required: true,
              requiredMessage: 'map required',
              onChanged: (_) {},
              builder: (context, value, onChanged, errorText) =>
                  Text(errorText ?? 'valid'),
            ),
          ],
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('list required'), findsOneWidget);
      expect(find.text('map required'), findsOneWidget);
      expect(ruleCalls, 0);
      expect(validatorCalls, 0);
    });

    testWidgets('original validator runs after passing rules', (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: 'value',
          onChanged: (_) {},
          rules: [(value) => null],
          validator: (value) => 'validator error',
          builder: (context, value, onChanged, errorText) =>
              Text(errorText ?? 'valid'),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('validator error'), findsOneWidget);
    });

    testWidgets('every form demo input supports required rules and validator',
        (tester) async {
      const names = [
        'input',
        'textarea',
        'radio',
        'checkbox',
        'switch',
        'stepper',
        'slider',
        'rate',
        'picker',
        'dateTimePicker',
      ];
      const pickerItems = TPickerColumns([
        [TPickerOption(label: 'Option', value: 'option')],
      ]);
      final controller = TFormController();
      var phase = 0;
      late StateSetter update;

      Widget item(String label, Widget child) {
        return TFormItem(label: label, child: Offstage(child: child));
      }

      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          final stringValue = phase == 0 ? null : 'value';
          final listValue = phase == 0 ? null : <String>['value'];
          final objectListValue = phase == 0 ? null : <Object?>['option'];
          final boolValue = phase == 0 ? null : true;
          final numValue = phase == 0 ? null : 1;
          final doubleValue = phase == 0 ? null : 1.0;
          final dateValue = phase == 0
              ? null
              : const TDateTimePickerValue(year: 2026, month: 1, day: 1);

          return TForm(
            controller: controller,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TFormField<String?>(
                    name: 'input',
                    value: stringValue,
                    required: true,
                    requiredMessage: 'input required',
                    rules: [(value) => phase == 1 ? 'input rule' : null],
                    validator: (value) => phase == 2 ? 'input validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Input',
                      TInput(initialValue: value ?? ''),
                    ),
                  ),
                  TFormField<String?>(
                    name: 'textarea',
                    value: stringValue,
                    required: true,
                    requiredMessage: 'textarea required',
                    rules: [(value) => phase == 1 ? 'textarea rule' : null],
                    validator: (value) =>
                        phase == 2 ? 'textarea validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Textarea',
                      TTextarea(initialValue: value ?? ''),
                    ),
                  ),
                  TFormField<String?>(
                    name: 'radio',
                    value: stringValue,
                    required: true,
                    requiredMessage: 'radio required',
                    rules: [(value) => phase == 1 ? 'radio rule' : null],
                    validator: (value) => phase == 2 ? 'radio validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Radio',
                      TRadioGroup<String>(
                        value: value,
                        options: const [
                          TRadioOption(value: 'value', label: 'Value'),
                        ],
                      ),
                    ),
                  ),
                  TFormField<List<String>?>(
                    name: 'checkbox',
                    value: listValue,
                    required: true,
                    requiredMessage: 'checkbox required',
                    rules: [(value) => phase == 1 ? 'checkbox rule' : null],
                    validator: (value) =>
                        phase == 2 ? 'checkbox validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Checkbox',
                      TCheckboxGroup<String>(
                        value: value ?? const [],
                        options: const [
                          TCheckboxOption(value: 'value', label: 'Value'),
                        ],
                      ),
                    ),
                  ),
                  TFormField<bool?>(
                    name: 'switch',
                    value: boolValue,
                    required: true,
                    requiredMessage: 'switch required',
                    rules: [(value) => phase == 1 ? 'switch rule' : null],
                    validator: (value) =>
                        phase == 2 ? 'switch validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Switch',
                      TSwitch(value: value ?? false),
                    ),
                  ),
                  TFormField<num?>(
                    name: 'stepper',
                    value: numValue,
                    required: true,
                    requiredMessage: 'stepper required',
                    rules: [(value) => phase == 1 ? 'stepper rule' : null],
                    validator: (value) =>
                        phase == 2 ? 'stepper validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Stepper',
                      TStepper(value: value ?? 0),
                    ),
                  ),
                  TFormField<double?>(
                    name: 'slider',
                    value: doubleValue,
                    required: true,
                    requiredMessage: 'slider required',
                    rules: [(value) => phase == 1 ? 'slider rule' : null],
                    validator: (value) =>
                        phase == 2 ? 'slider validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Slider',
                      TSlider(value: value ?? 0),
                    ),
                  ),
                  TFormField<double?>(
                    name: 'rate',
                    value: doubleValue,
                    required: true,
                    requiredMessage: 'rate required',
                    rules: [(value) => phase == 1 ? 'rate rule' : null],
                    validator: (value) => phase == 2 ? 'rate validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Rate',
                      TRate(value: value ?? 0),
                    ),
                  ),
                  TFormField<List<Object?>?>(
                    name: 'picker',
                    value: objectListValue,
                    required: true,
                    requiredMessage: 'picker required',
                    rules: [(value) => phase == 1 ? 'picker rule' : null],
                    validator: (value) =>
                        phase == 2 ? 'picker validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'Picker',
                      TPicker(items: pickerItems, value: value ?? const []),
                    ),
                  ),
                  TFormField<TDateTimePickerValue?>(
                    name: 'dateTimePicker',
                    value: dateValue,
                    required: true,
                    requiredMessage: 'dateTimePicker required',
                    rules: [
                      (value) => phase == 1 ? 'dateTimePicker rule' : null,
                    ],
                    validator: (value) =>
                        phase == 2 ? 'dateTimePicker validator' : null,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) => item(
                      'DateTimePicker',
                      TDateTimePicker(
                        value: value ?? const TDateTimePickerValue(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )));

      for (final name in names) {
        expect(find.text('$name required'), findsNothing);
      }
      expect(controller.validate(), isFalse);
      await tester.pump();
      for (final name in names) {
        expect(find.text('$name required'), findsOneWidget);
      }

      phase = 1;
      update(() {});
      await tester.pump();
      await tester.pump();
      expect(controller.validate(), isFalse);
      await tester.pump();
      for (final name in names) {
        expect(find.text('$name rule'), findsOneWidget);
      }

      phase = 2;
      update(() {});
      await tester.pump();
      await tester.pump();
      expect(controller.validate(), isFalse);
      await tester.pump();
      for (final name in names) {
        expect(find.text('$name validator'), findsOneWidget);
      }

      phase = 3;
      update(() {});
      await tester.pump();
      await tester.pump();
      expect(controller.validate(), isTrue);
    });

    testWidgets('form item can explicitly override inherited required marker',
        (tester) async {
      await tester.pumpWidget(wrap(TForm(
        child: TFormField<String>(
          name: 'name',
          value: '',
          required: true,
          onChanged: (_) {},
          builder: (context, value, onChanged, errorText) => const TFormItem(
            label: 'Name',
            required: false,
            child: Text('Field'),
          ),
        ),
      )));

      expect(find.text('*'), findsNothing);
    });

    testWidgets('form item updates when inherited required changes',
        (tester) async {
      var required = false;
      late StateSetter update;
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TFormField<String>(
            name: 'name',
            value: '',
            required: required,
            onChanged: (_) {},
            builder: (context, value, onChanged, errorText) => const TFormItem(
              label: 'Name',
              child: Text('Field'),
            ),
          );
        },
      )));

      expect(find.text('*'), findsNothing);
      required = true;
      update(() {});
      await tester.pump();
      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('default validation updates after a failed submission',
        (tester) async {
      final controller = TFormController();
      var value = '';
      late StateSetter update;
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: value,
              onChanged: (next) => setState(() => value = next),
              validator: (next) => next!.isEmpty ? 'required' : null,
              builder: (context, current, onChanged, errorText) => TFormItem(
                child: TextButton(
                  onPressed: () => onChanged!('valid'),
                  child: const Text('change'),
                ),
              ),
            ),
          );
        },
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(value, 'valid');
      expect(find.text('required'), findsNothing);
      update(() {});
    });

    testWidgets('rejected controlled values restore the registered value',
        (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: 'accepted',
          onChanged: (_) {},
          validator: (value) => value == 'accepted' ? null : 'unexpected',
          builder: (context, value, onChanged, errorText) => TextButton(
            onPressed: () => onChanged!('rejected'),
            child: const Text('change'),
          ),
        ),
      )));

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(controller.values, {'name': 'accepted'});
      expect(controller.submit(), isTrue);
    });

    testWidgets('explicit disabled validation is not replaced after submit',
        (tester) async {
      final controller = TFormController();
      var value = '';
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          return TForm(
            controller: controller,
            autovalidateMode: AutovalidateMode.disabled,
            child: TFormField<String>(
              name: 'name',
              value: value,
              onChanged: (next) => setState(() => value = next),
              validator: (next) => next!.isEmpty ? 'required' : null,
              builder: (context, current, onChanged, errorText) => TFormItem(
                child: TextButton(
                  onPressed: () => onChanged!('valid'),
                  child: const Text('change'),
                ),
              ),
            ),
          );
        },
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(value, 'valid');
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('explicit onUserInteraction validates before submission',
        (tester) async {
      var value = 'valid';
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          return TForm(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TFormField<String>(
              name: 'name',
              value: value,
              onChanged: (next) => setState(() => value = next),
              validator: (next) => next!.isEmpty ? 'required' : null,
              builder: (context, current, onChanged, errorText) => TFormItem(
                child: TextButton(
                  onPressed: () => onChanged!(''),
                  child: const Text('clear'),
                ),
              ),
            ),
          );
        },
      )));

      expect(find.text('required'), findsNothing);
      await tester.tap(find.text('clear'));
      await tester.pump();
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('explicit always validation runs before user interaction',
        (tester) async {
      await tester.pumpWidget(wrap(TForm(
        autovalidateMode: AutovalidateMode.always,
        child: TFormField<String>(
          name: 'name',
          value: '',
          onChanged: (_) {},
          validator: (value) => value!.isEmpty ? 'required' : null,
          builder: (context, value, onChanged, errorText) => const TFormItem(
            child: Text('Field'),
          ),
        ),
      )));

      await tester.pump();
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('reset restores the default validation interaction mode',
        (tester) async {
      final controller = TFormController();
      var value = '';
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          return TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: value,
              onChanged: (next) => setState(() => value = next),
              validator: (next) => next!.isEmpty ? 'required' : null,
              builder: (context, current, onChanged, errorText) => TFormItem(
                child: TextButton(
                  onPressed: () => onChanged!(''),
                  child: const Text('change'),
                ),
              ),
            ),
          );
        },
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      controller.reset();
      await tester.pump();
      expect(find.text('required'), findsNothing);

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(find.text('required'), findsNothing);
    });

    testWidgets('standalone input displays ambient field error once',
        (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: '',
          onChanged: (_) {},
          validator: (value) => value!.isEmpty ? 'required' : null,
          builder: (context, value, onChanged, errorText) => TInput(
            initialValue: value,
            onChanged: onChanged,
          ),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      final input = tester.widget<TextField>(find.byType(TextField));
      expect(input.decoration!.errorText, 'required');
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('form item owns the error instead of duplicating input text',
        (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(wrap(TForm(
        controller: controller,
        child: TFormField<String>(
          name: 'name',
          value: '',
          onChanged: (_) {},
          validator: (value) => value!.isEmpty ? 'required' : null,
          builder: (context, value, onChanged, errorText) => TFormItem(
            child: TInput(initialValue: value, onChanged: onChanged),
          ),
        ),
      )));

      expect(controller.submit(), isFalse);
      await tester.pump();
      final input = tester.widget<TextField>(find.byType(TextField));
      expect(input.decoration!.errorText, isNull);
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('field rename, external update and removal update registry',
        (tester) async {
      final controller = TFormController();
      var name = 'old';
      var value = 1;
      var visible = true;
      late StateSetter update;
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TForm(
            controller: controller,
            child: visible
                ? TFormField<int>(
                    name: name,
                    value: value,
                    onChanged: (_) {},
                    builder: (context, value, onChanged, errorText) =>
                        Text('$value'),
                  )
                : const SizedBox(),
          );
        },
      )));
      expect(controller.values, {'old': 1});

      name = 'new';
      value = 2;
      update(() {});
      await tester.pump();
      expect(controller.values, {'new': 2});

      visible = false;
      update(() {});
      await tester.pump();
      expect(controller.values, isEmpty);
    });

    testWidgets('controller detaches and reattaches when replaced',
        (tester) async {
      final first = TFormController();
      final second = TFormController();
      var controller = first;
      late StateSetter update;
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TForm(controller: controller, child: const SizedBox());
        },
      )));
      expect(first.validate(), isTrue);

      controller = second;
      update(() {});
      await tester.pump();
      expect(first.validate(), isFalse);
      expect(second.validate(), isTrue);

      await tester.pumpWidget(const SizedBox());
      expect(second.validate(), isFalse);
    });

    testWidgets('works as a standalone FormField without TForm scope',
        (tester) async {
      await tester.pumpWidget(wrap(TFormField<int>(
        name: 'count',
        value: 1,
        onChanged: (_) {},
        builder: (context, value, onChanged, errorText) => Text('$value'),
      )));
      expect(find.text('1'), findsOneWidget);
    });

    test('unattached controller has safe empty behavior', () {
      final controller = TFormController();
      expect(controller.values, isEmpty);
      expect(controller.validate(), isFalse);
      expect(controller.submit(), isFalse);
      controller.reset();
    });
  });

  group('TFormItem layout', () {
    testWidgets('horizontal layout renders label, mark, child and help',
        (tester) async {
      await tester.pumpWidget(wrap(
        const TFormItem(
          label: 'Name',
          required: true,
          help: 'Help',
          extra: Icon(Icons.info),
          child: Text('Field'),
        ),
        formTheme: const TFormThemeData(
          showColon: true,
          labelWidth: 80,
          labelAlign: TextAlign.right,
        ),
      ));
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
      expect(find.text('Field'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('vertical layout prefers error over help and applies theme',
        (tester) async {
      const errorStyle = TextStyle(color: Colors.red);
      await tester.pumpWidget(wrap(
        const TFormItem(
          label: 'Name',
          labelWidth: 120,
          help: 'Help',
          errorText: 'Error',
          child: Text('Field'),
        ),
        formTheme: const TFormThemeData(
          layout: TFormLayout.vertical,
          backgroundColor: Colors.yellow,
          itemPadding: EdgeInsets.all(12),
          itemSpacing: 6,
          labelGap: 10,
          messageGap: 5,
          errorStyle: errorStyle,
        ),
      ));
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Help'), findsNothing);
      expect(tester.widget<Text>(find.text('Error')).style, errorStyle);
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, Colors.yellow);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('label and messages are optional', (tester) async {
      await tester.pumpWidget(wrap(const TFormItem(child: Text('Field'))));
      expect(find.text('Field'), findsOneWidget);
      expect(find.text('*'), findsNothing);
    });
  });

  test('TFormThemeData copyWith and lerp', () {
    const base = TFormThemeData(
      showColon: true,
      labelWidth: 80,
      layout: TFormLayout.horizontal,
      labelAlign: TextAlign.left,
      labelStyle: TextStyle(fontSize: 12),
      requiredMarkStyle: TextStyle(color: Colors.red),
      helpStyle: TextStyle(color: Colors.grey),
      errorStyle: TextStyle(color: Colors.red),
      backgroundColor: Colors.white,
      itemPadding: EdgeInsets.all(4),
      itemSpacing: 4,
      labelGap: 6,
      messageGap: 2,
    );
    const other = TFormThemeData(
      showColon: false,
      labelWidth: 120,
      layout: TFormLayout.vertical,
      labelAlign: TextAlign.right,
      labelStyle: TextStyle(fontSize: 16),
      requiredMarkStyle: TextStyle(color: Colors.blue),
      helpStyle: TextStyle(color: Colors.black),
      errorStyle: TextStyle(color: Colors.orange),
      backgroundColor: Colors.black,
      itemPadding: EdgeInsets.all(8),
      itemSpacing: 8,
      labelGap: 10,
      messageGap: 6,
    );

    expect(base.copyWith().labelWidth, 80);
    expect(
      base
          .copyWith(
            showColon: false,
            labelWidth: 100,
            layout: TFormLayout.vertical,
            labelAlign: TextAlign.center,
            labelStyle: const TextStyle(fontSize: 14),
            requiredMarkStyle: const TextStyle(color: Colors.green),
            helpStyle: const TextStyle(color: Colors.blueGrey),
            errorStyle: const TextStyle(color: Colors.purple),
            backgroundColor: Colors.grey,
            itemPadding: const EdgeInsets.all(6),
            itemSpacing: 6,
            labelGap: 8,
            messageGap: 4,
          )
          .layout,
      TFormLayout.vertical,
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.25).showColon, isTrue);
    expect(base.lerp(other, 0.75).layout, TFormLayout.vertical);
    expect(base.lerp(other, 0.5).labelWidth, 100);
    expect(base.lerp(other, 0.5).itemSpacing, 6);
  });
}
