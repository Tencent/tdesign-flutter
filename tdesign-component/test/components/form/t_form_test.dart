import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    testWidgets('valid submit returns registered controlled values', (
      tester,
    ) async {
      final controller = TFormController();
      Map<String, Object?>? submitted;
      String? saved;
      await tester.pumpWidget(
        wrap(
          TForm(
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
          ),
        ),
      );

      expect(controller.values, {'name': 'TDesign'});
      expect(controller.validate(), isTrue);
      expect(controller.submit(), isTrue);
      expect(submitted, {'name': 'TDesign'});
      expect(saved, 'TDesign');
    });

    testWidgets('field change updates validation and submitted data', (
      tester,
    ) async {
      final controller = TFormController();
      var value = '';
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
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
          ),
        ),
      );

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

    testWidgets('form onChanged observes the current controlled value', (
      tester,
    ) async {
      final controller = TFormController();
      var value = 'before';
      Map<String, Object?>? valuesDuringChange;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => TForm(
              controller: controller,
              onChanged: () => valuesDuringChange = controller.values,
              child: TFormField<String>(
                name: 'name',
                value: value,
                onChanged: (next) => setState(() => value = next),
                builder: (context, current, onChanged, errorText) => TextButton(
                  onPressed: () => onChanged!('after'),
                  child: Text(current),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('before'));

      expect(valuesDuringChange, {'name': 'after'});
      expect(controller.values, {'name': 'after'});
    });

    testWidgets('field onChanged validates and submits the current value', (
      tester,
    ) async {
      final controller = TFormController();
      var value = '';
      Map<String, Object?>? valuesDuringChange;
      Map<String, Object?>? submitted;
      bool? validityDuringChange;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => TForm(
              controller: controller,
              onSubmit: (values) => submitted = values,
              child: TFormField<String>(
                name: 'name',
                value: value,
                onChanged: (next) {
                  valuesDuringChange = controller.values;
                  validityDuringChange = controller.submit();
                  setState(() => value = next);
                },
                validator: (current) => current == 'after' ? null : 'required',
                builder: (context, current, onChanged, errorText) => TextButton(
                  onPressed: () => onChanged!('after'),
                  child: Text(current.isEmpty ? 'change' : current),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('change'));

      expect(valuesDuringChange, {'name': 'after'});
      expect(validityDuringChange, isTrue);
      expect(submitted, {'name': 'after'});
      expect(controller.values, {'name': 'after'});
    });

    testWidgets('external controlled updates do not report user interaction', (
      tester,
    ) async {
      final controller = TFormController();
      var value = 'valid';
      var changeCount = 0;
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TForm(
                controller: controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () => changeCount += 1,
                child: TFormField<String>(
                  name: 'name',
                  value: value,
                  onChanged: (_) {},
                  validator: (current) => current!.isEmpty ? 'required' : null,
                  builder: (context, current, onChanged, errorText) =>
                      Text(errorText ?? current),
                ),
              );
            },
          ),
        ),
      );

      value = '';
      update(() {});
      await tester.pump();
      await tester.pump();

      expect(controller.values, {'name': ''});
      expect(changeCount, 0);
      expect(find.text('required'), findsNothing);
    });

    testWidgets('disabled field exposes no change callback', (tester) async {
      ValueChanged<bool>? callback;
      await tester.pumpWidget(
        wrap(
          TForm(
            child: TFormField<bool>(
              name: 'enabled',
              value: false,
              builder: (context, value, onChanged, errorText) {
                callback = onChanged;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(callback, isNull);
    });

    testWidgets('showErrorMessage hides field error from builder', (
      tester,
    ) async {
      final key = GlobalKey<TFormState>();
      await tester.pumpWidget(
        wrap(
          TForm(
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
          ),
        ),
      );

      expect(key.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('hidden'), findsOneWidget);
      expect(find.text('hidden error'), findsNothing);
      key.currentState!.reset();
    });

    testWidgets('form item displays its field error without manual wiring', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: '',
              onChanged: (_) {},
              validator: (value) => value!.isEmpty ? 'required' : null,
              builder: (context, value, onChanged, errorText) =>
                  const TFormItem(
                    label: 'Name',
                    help: 'Help',
                    child: Text('Field'),
                  ),
            ),
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);
      expect(find.text('Help'), findsNothing);
    });

    testWidgets('explicit form item error overrides field error', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: '',
              onChanged: (_) {},
              validator: (value) => value!.isEmpty ? 'field error' : null,
              builder: (context, value, onChanged, errorText) =>
                  const TFormItem(
                    errorText: 'explicit error',
                    child: Text('Field'),
                  ),
            ),
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('explicit error'), findsOneWidget);
      expect(find.text('field error'), findsNothing);
    });

    testWidgets('required field validates and marks its form item', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: '   ',
              required: true,
              requiredMessage: '请输入姓名',
              onChanged: (_) {},
              builder: (context, value, onChanged, errorText) =>
                  const TFormItem(label: 'Name', child: Text('Field')),
            ),
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('*'), findsOneWidget);
      expect(find.text('请输入姓名'), findsOneWidget);
    });

    testWidgets('required uses the default error message', (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: '',
              required: true,
              onChanged: (_) {},
              builder: (context, value, onChanged, errorText) =>
                  Text(errorText ?? 'valid'),
            ),
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('此项不能为空'), findsOneWidget);
    });

    testWidgets('required accepts false and zero values', (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
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
          ),
        ),
      );

      expect(controller.submit(), isTrue);
    });

    testWidgets('validator runs after required validation', (tester) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: 'value',
              onChanged: (_) {},
              validator: (value) => 'validator error',
              builder: (context, value, onChanged, errorText) =>
                  Text(errorText ?? 'valid'),
            ),
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('validator error'), findsOneWidget);
    });

    testWidgets(
      'required handles empty collections and short-circuits validator',
      (tester) async {
        final controller = TFormController();
        var validatorCalls = 0;
        await tester.pumpWidget(
          wrap(
            TForm(
              controller: controller,
              child: Column(
                children: [
                  TFormField<List<String>>(
                    name: 'list',
                    value: const [],
                    required: true,
                    requiredMessage: 'list required',
                    onChanged: (_) {},
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
            ),
          ),
        );

        expect(controller.submit(), isFalse);
        await tester.pump();
        expect(find.text('list required'), findsOneWidget);
        expect(find.text('map required'), findsOneWidget);
        expect(validatorCalls, 0);
      },
    );

    testWidgets('upload follows form-level validation timing', (tester) async {
      const photo = TUploadFile(
        id: 'photo',
        name: 'photo.png',
        status: TUploadFileStatus.success,
      );
      final controller = TFormController();
      var files = const [photo];
      ValueChanged<List<TUploadFile>>? changeFiles;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => TForm(
              controller: controller,
              child: TFormField<List<TUploadFile>>(
                name: 'photo',
                value: files,
                required: true,
                requiredMessage: '请上传照片',
                onChanged: (value) => setState(() => files = value),
                builder: (context, value, onChanged, errorText) {
                  changeFiles = onChanged;
                  return TFormItem(
                    label: '上传照片',
                    child: TUpload(files: value, onChanged: onChanged),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('upload-remove-photo')));
      await tester.pump();

      expect(files, isEmpty);
      expect(find.text('请上传照片'), findsNothing);

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('请上传照片'), findsOneWidget);

      changeFiles!(const [photo]);
      await tester.pump();
      expect(find.text('请上传照片'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('upload-remove-photo')));
      await tester.pump();
      expect(find.text('请上传照片'), findsOneWidget);
    });

    testWidgets('validator runs after passing required validation', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: 'value',
              onChanged: (_) {},
              validator: (value) => 'validator error',
              builder: (context, value, onChanged, errorText) =>
                  Text(errorText ?? 'valid'),
            ),
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('validator error'), findsOneWidget);
    });

    testWidgets(
      'every form demo input supports required validation and validator',
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
          return TFormItem(
            label: label,
            child: Offstage(child: child),
          );
        }

        await tester.pumpWidget(
          wrap(
            StatefulBuilder(
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
                          validator: (value) => phase == 1
                              ? 'input validator'
                              : phase == 2
                              ? 'input validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item('Input', TInput(initialValue: value ?? '')),
                        ),
                        TFormField<String?>(
                          name: 'textarea',
                          value: stringValue,
                          required: true,
                          requiredMessage: 'textarea required',
                          validator: (value) => phase == 1
                              ? 'textarea validator'
                              : phase == 2
                              ? 'textarea validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item(
                                'Textarea',
                                TTextarea(initialValue: value ?? ''),
                              ),
                        ),
                        TFormField<String?>(
                          name: 'radio',
                          value: stringValue,
                          required: true,
                          requiredMessage: 'radio required',
                          validator: (value) => phase == 1
                              ? 'radio validator'
                              : phase == 2
                              ? 'radio validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item(
                                'Radio',
                                TRadioGroup<String>.options(
                                  value: value,
                                  options: const [
                                    TRadioOption(
                                      value: 'value',
                                      label: 'Value',
                                    ),
                                  ],
                                ),
                              ),
                        ),
                        TFormField<List<String>?>(
                          name: 'checkbox',
                          value: listValue,
                          required: true,
                          requiredMessage: 'checkbox required',
                          validator: (value) => phase == 1
                              ? 'checkbox validator'
                              : phase == 2
                              ? 'checkbox validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item(
                                'Checkbox',
                                TCheckboxGroup<String>(
                                  value: value ?? const [],
                                  options: const [
                                    TCheckboxOption(
                                      value: 'value',
                                      label: 'Value',
                                    ),
                                  ],
                                ),
                              ),
                        ),
                        TFormField<bool?>(
                          name: 'switch',
                          value: boolValue,
                          required: true,
                          requiredMessage: 'switch required',
                          validator: (value) => phase == 1
                              ? 'switch validator'
                              : phase == 2
                              ? 'switch validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item('Switch', TSwitch(value: value ?? false)),
                        ),
                        TFormField<num?>(
                          name: 'stepper',
                          value: numValue,
                          required: true,
                          requiredMessage: 'stepper required',
                          validator: (value) => phase == 1
                              ? 'stepper validator'
                              : phase == 2
                              ? 'stepper validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item('Stepper', TStepper(value: value ?? 0)),
                        ),
                        TFormField<double?>(
                          name: 'slider',
                          value: doubleValue,
                          required: true,
                          requiredMessage: 'slider required',
                          validator: (value) => phase == 1
                              ? 'slider validator'
                              : phase == 2
                              ? 'slider validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item('Slider', TSlider(value: value ?? 0)),
                        ),
                        TFormField<double?>(
                          name: 'rate',
                          value: doubleValue,
                          required: true,
                          requiredMessage: 'rate required',
                          validator: (value) => phase == 1
                              ? 'rate validator'
                              : phase == 2
                              ? 'rate validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item('Rate', TRate(value: value ?? 0)),
                        ),
                        TFormField<List<Object?>?>(
                          name: 'picker',
                          value: objectListValue,
                          required: true,
                          requiredMessage: 'picker required',
                          validator: (value) => phase == 1
                              ? 'picker validator'
                              : phase == 2
                              ? 'picker validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item(
                                'Picker',
                                TPicker(
                                  items: pickerItems,
                                  value: value ?? const [],
                                ),
                              ),
                        ),
                        TFormField<TDateTimePickerValue?>(
                          name: 'dateTimePicker',
                          value: dateValue,
                          required: true,
                          requiredMessage: 'dateTimePicker required',
                          validator: (value) => phase == 1
                              ? 'dateTimePicker validator'
                              : phase == 2
                              ? 'dateTimePicker validator'
                              : null,
                          onChanged: (_) {},
                          builder: (context, value, onChanged, errorText) =>
                              item(
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
            ),
          ),
        );

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
          expect(find.text('$name validator'), findsOneWidget);
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
      },
    );

    testWidgets('form item can explicitly override inherited required marker', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TForm(
            child: TFormField<String>(
              name: 'name',
              value: '',
              required: true,
              onChanged: (_) {},
              builder: (context, value, onChanged, errorText) =>
                  const TFormItem(
                    label: 'Name',
                    required: false,
                    child: Text('Field'),
                  ),
            ),
          ),
        ),
      );

      expect(find.text('*'), findsNothing);
    });

    testWidgets('form item updates when inherited required changes', (
      tester,
    ) async {
      var required = false;
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TFormField<String>(
                name: 'name',
                value: '',
                required: required,
                onChanged: (_) {},
                builder: (context, value, onChanged, errorText) =>
                    const TFormItem(label: 'Name', child: Text('Field')),
              );
            },
          ),
        ),
      );

      expect(find.text('*'), findsNothing);
      required = true;
      update(() {});
      await tester.pump();
      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('default validation updates after a failed submission', (
      tester,
    ) async {
      final controller = TFormController();
      var value = '';
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TForm(
                controller: controller,
                child: TFormField<String>(
                  name: 'name',
                  value: value,
                  onChanged: (next) => setState(() => value = next),
                  validator: (next) => next!.isEmpty ? 'required' : null,
                  builder: (context, current, onChanged, errorText) =>
                      TFormItem(
                        child: TextButton(
                          onPressed: () => onChanged!('valid'),
                          child: const Text('change'),
                        ),
                      ),
                ),
              );
            },
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(value, 'valid');
      expect(find.text('required'), findsNothing);
      update(() {});
    });

    testWidgets('validate does not enable automatic validation', (
      tester,
    ) async {
      final controller = TFormController();
      var value = '';
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => TForm(
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
            ),
          ),
        ),
      );

      expect(controller.validate(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(value, 'valid');
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('successful submit does not enable automatic validation', (
      tester,
    ) async {
      final controller = TFormController();
      var value = 'valid';
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => TForm(
              controller: controller,
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
            ),
          ),
        ),
      );

      expect(controller.submit(), isTrue);
      await tester.tap(find.text('clear'));
      await tester.pump();
      expect(value, isEmpty);
      expect(find.text('required'), findsNothing);
    });

    testWidgets('rejected controlled values restore the registered value', (
      tester,
    ) async {
      final controller = TFormController();
      var changeCount = 0;
      Map<String, Object?>? valuesDuringChange;
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            onChanged: () {
              changeCount += 1;
              valuesDuringChange = controller.values;
            },
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
          ),
        ),
      );

      await tester.tap(find.text('change'));
      await tester.pump();
      await tester.pump();
      expect(changeCount, 1);
      expect(valuesDuringChange, {'name': 'rejected'});
      expect(controller.values, {'name': 'accepted'});
      expect(controller.submit(), isTrue);
    });

    testWidgets('explicit disabled validation is not replaced after submit', (
      tester,
    ) async {
      final controller = TFormController();
      var value = '';
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return TForm(
                controller: controller,
                autovalidateMode: AutovalidateMode.disabled,
                child: TFormField<String>(
                  name: 'name',
                  value: value,
                  onChanged: (next) => setState(() => value = next),
                  validator: (next) => next!.isEmpty ? 'required' : null,
                  builder: (context, current, onChanged, errorText) =>
                      TFormItem(
                        child: TextButton(
                          onPressed: () => onChanged!('valid'),
                          child: const Text('change'),
                        ),
                      ),
                ),
              );
            },
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      expect(find.text('required'), findsOneWidget);

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(value, 'valid');
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('explicit onUserInteraction validates before submission', (
      tester,
    ) async {
      var value = 'valid';
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return TForm(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TFormField<String>(
                  name: 'name',
                  value: value,
                  onChanged: (next) => setState(() => value = next),
                  validator: (next) => next!.isEmpty ? 'required' : null,
                  builder: (context, current, onChanged, errorText) =>
                      TFormItem(
                        child: TextButton(
                          onPressed: () => onChanged!(''),
                          child: const Text('clear'),
                        ),
                      ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('required'), findsNothing);
      await tester.tap(find.text('clear'));
      await tester.pump();
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('explicit always validation runs before user interaction', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TForm(
            autovalidateMode: AutovalidateMode.always,
            child: TFormField<String>(
              name: 'name',
              value: '',
              onChanged: (_) {},
              validator: (value) => value!.isEmpty ? 'required' : null,
              builder: (context, value, onChanged, errorText) =>
                  const TFormItem(child: Text('Field')),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('explicit onUnfocus validates when focus leaves the field', (
      tester,
    ) async {
      final focusNode = FocusNode();
      final textController = TextEditingController(text: 'valid');
      var value = 'valid';
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                TForm(
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  child: TFormField<String>(
                    name: 'name',
                    value: value,
                    onChanged: (next) => setState(() => value = next),
                    validator: (next) => next!.isEmpty ? 'required' : null,
                    builder: (context, current, onChanged, errorText) =>
                        TFormItem(
                          child: TextField(
                            controller: textController,
                            focusNode: focusNode,
                            onChanged: onChanged,
                          ),
                        ),
                  ),
                ),
                const TextButton(onPressed: null, child: Text('outside')),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      expect(find.text('required'), findsNothing);

      focusNode.unfocus();
      await tester.pump();
      expect(find.text('required'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      focusNode.dispose();
      textController.dispose();
    });

    testWidgets('reset restores the default validation interaction mode', (
      tester,
    ) async {
      final controller = TFormController();
      var value = '';
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return TForm(
                controller: controller,
                child: TFormField<String>(
                  name: 'name',
                  value: value,
                  onChanged: (next) => setState(() => value = next),
                  validator: (next) => next!.isEmpty ? 'required' : null,
                  builder: (context, current, onChanged, errorText) =>
                      TFormItem(
                        child: TextButton(
                          onPressed: () => onChanged!(''),
                          child: const Text('change'),
                        ),
                      ),
                ),
              );
            },
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      controller.reset();
      await tester.pump();
      expect(find.text('required'), findsNothing);

      await tester.tap(find.text('change'));
      await tester.pump();
      expect(find.text('required'), findsNothing);
    });

    testWidgets(
      'reset delegates to native FormField and preserves controlled fields',
      (tester) async {
        final controller = TFormController();
        var controlledValue = 'initial';
        late ValueChanged<String> changeControlledValue;
        await tester.pumpWidget(
          wrap(
            StatefulBuilder(
              builder: (context, setState) {
                return TForm(
                  controller: controller,
                  child: Column(
                    children: [
                      TextFormField(initialValue: 'native'),
                      TFormField<String>(
                        name: 'controlled',
                        value: controlledValue,
                        onChanged: (next) {
                          setState(() => controlledValue = next);
                        },
                        builder: (context, value, onChanged, errorText) {
                          changeControlledValue = onChanged!;
                          return Text(value);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'changed');
        changeControlledValue('latest');
        await tester.pump();

        controller.reset();
        await tester.pump();

        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          'native',
        );
        expect(find.text('latest'), findsOneWidget);
      },
    );

    testWidgets('standalone input displays ambient field error once', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: '',
              onChanged: (_) {},
              validator: (value) => value!.isEmpty ? 'required' : null,
              builder: (context, value, onChanged, errorText) =>
                  TInput(initialValue: value, onChanged: onChanged),
            ),
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      final input = tester.widget<TextField>(find.byType(TextField));
      expect(input.decoration!.errorText, isNull);
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('form item owns the error instead of duplicating input text', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
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
          ),
        ),
      );

      expect(controller.submit(), isFalse);
      await tester.pump();
      final input = tester.widget<TextField>(find.byType(TextField));
      expect(input.decoration!.errorText, isNull);
      expect(find.text('required'), findsOneWidget);
    });

    testWidgets('field rename, external update and removal update registry', (
      tester,
    ) async {
      final controller = TFormController();
      var name = 'old';
      var value = 1;
      var visible = true;
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
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
          ),
        ),
      );
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

    testWidgets('controller detaches and reattaches when replaced', (
      tester,
    ) async {
      final first = TFormController();
      final second = TFormController();
      var controller = first;
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TForm(controller: controller, child: const SizedBox());
            },
          ),
        ),
      );
      expect(first.validate(), isTrue);

      controller = second;
      update(() {});
      await tester.pump();
      expect(first.validate(), isFalse);
      expect(second.validate(), isTrue);

      await tester.pumpWidget(const SizedBox());
      expect(second.validate(), isFalse);
    });

    testWidgets('controller rejects multiple simultaneous forms', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              TForm(controller: controller, child: const SizedBox()),
              TForm(controller: controller, child: const SizedBox()),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isAssertionError);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });

    testWidgets('works as a standalone FormField without TForm scope', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TFormField<int>(
            name: 'count',
            value: 1,
            onChanged: (_) {},
            builder: (context, value, onChanged, errorText) => Text('$value'),
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
    });

    test('unattached controller has safe empty behavior', () {
      final controller = TFormController();
      expect(controller.values, isEmpty);
      expect(controller.validate(), isFalse);
      expect(controller.submit(), isFalse);
      controller.reset();
    });

    testWidgets('supports scoped validation and external field errors', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: Column(
              children: [
                TFormField<String>(
                  name: 'first',
                  value: 'valid',
                  onChanged: (_) {},
                  validator: (_) => null,
                  builder: (context, value, onChanged, errorText) =>
                      TFormItem(label: 'First', child: Text(value)),
                ),
                TFormField<String>(
                  name: 'second',
                  value: '',
                  onChanged: (_) {},
                  validator: (_) => 'required',
                  builder: (context, value, onChanged, errorText) =>
                      TFormItem(label: 'Second', child: Text(value)),
                ),
              ],
            ),
          ),
        ),
      );

      expect(controller.validate(fields: ['first']), isTrue);
      expect(controller.validate(fields: ['second']), isFalse);

      controller.setValidateMessage({'first': 'server error'});
      await tester.pump();
      expect(find.text('server error'), findsOneWidget);
      expect(controller.validate(fields: ['first']), isFalse);

      controller.clearValidate(fields: ['first']);
      await tester.pump();
      expect(find.text('server error'), findsNothing);
    });

    testWidgets('scoped validation fails for unregistered fields', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'registered',
              value: 'value',
              onChanged: (_) {},
              builder: (context, value, onChanged, errorText) => Text(value),
            ),
          ),
        ),
      );

      expect(controller.validate(fields: ['missing']), isFalse);
      expect(controller.validate(fields: ['registered', 'missing']), isFalse);
    });

    testWidgets('clearing validation preserves the latest controlled value', (
      tester,
    ) async {
      final controller = TFormController();
      var value = 'initial';
      late ValueChanged<String> changeValue;
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TForm(
                controller: controller,
                child: TFormField<String>(
                  name: 'name',
                  value: value,
                  onChanged: (next) {
                    value = next;
                    update(() {});
                  },
                  validator: (current) =>
                      current == 'latest' ? null : 'stale value',
                  builder: (context, fieldValue, onChanged, errorText) {
                    changeValue = onChanged!;
                    return Text(errorText ?? fieldValue);
                  },
                ),
              );
            },
          ),
        ),
      );

      changeValue('latest');
      await tester.pump();
      controller.setValidateMessage({'name': 'server error'});
      await tester.pump();

      controller.clearValidate(fields: ['name']);
      await tester.pump();

      expect(find.text('latest'), findsOneWidget);
      expect(controller.validate(fields: ['name']), isTrue);
    });

    testWidgets('clearing validation does not report a field value change', (
      tester,
    ) async {
      final controller = TFormController();
      var changeCount = 0;
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            onChanged: () => changeCount += 1,
            child: TFormField<String>(
              name: 'name',
              value: '',
              onChanged: (_) {},
              validator: (_) => 'required',
              builder: (context, value, onChanged, errorText) =>
                  Text(errorText ?? 'valid'),
            ),
          ),
        ),
      );

      expect(controller.validate(), isFalse);
      await tester.pump();
      controller.clearValidate();
      await tester.pump();

      expect(changeCount, 0);
      expect(find.text('required'), findsNothing);
    });

    testWidgets('clearing validation preserves the field subtree and focus', (
      tester,
    ) async {
      final controller = TFormController();
      await tester.pumpWidget(
        wrap(
          TForm(
            controller: controller,
            child: TFormField<String>(
              name: 'name',
              value: '',
              onChanged: (_) {},
              validator: (_) => 'required',
              builder: (context, value, onChanged, errorText) =>
                  TInput(hintText: 'input', onChanged: onChanged),
            ),
          ),
        ),
      );
      final inputState = tester.state(find.byType(TInput));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
      expect(controller.validate(), isFalse);

      controller.clearValidate();
      await tester.pump();

      expect(tester.state(find.byType(TInput)), same(inputState));
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
    });
  });

  group('TFormItem layout', () {
    testWidgets('horizontal label keeps the design gap before content', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TFormItem(label: 'Name', child: Text('Field')),
          formTheme: const TFormThemeData(labelWidth: 80),
        ),
      );

      expect(tester.getTopLeft(find.text('Field')).dx, 112);
    });

    testWidgets('horizontal item without label does not add a label gap', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TFormItem(child: Text('Field'))));

      expect(tester.getTopLeft(find.text('Field')).dx, 16);
    });

    testWidgets('horizontal layout renders label, mark, child and help', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
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
        ),
      );
      expect(find.text('Name:'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
      expect(find.text('Field'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
      final token = TThemeData.defaultData();
      final labelStyle = tester.widget<Text>(find.text('Name:')).style;
      final helpStyle = tester.widget<Text>(find.text('Help')).style;
      expect(labelStyle?.fontSize, token.fontBodyLarge?.size);
      expect(labelStyle?.color, token.textColorPrimary);
      expect(helpStyle?.fontSize, token.fontBodySmall?.size);
      expect(helpStyle?.color, token.textColorPlaceholder);
    });

    testWidgets('vertical layout prefers error over help and applies theme', (
      tester,
    ) async {
      const errorStyle = TextStyle(color: Colors.red);
      await tester.pumpWidget(
        wrap(
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
        ),
      );
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Help'), findsNothing);
      final resolvedErrorStyle = tester.widget<Text>(find.text('Error')).style;
      final token = TThemeData.defaultData();
      expect(resolvedErrorStyle?.color, errorStyle.color);
      expect(resolvedErrorStyle?.fontSize, token.fontBodySmall?.size);
      expect(resolvedErrorStyle?.height, token.fontBodySmall?.height);
      final labelStyle = tester.widget<Text>(find.text('Name')).style;
      expect(labelStyle?.fontSize, token.fontBodyMedium?.size);
      expect(labelStyle?.height, token.fontBodyMedium?.height);
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, Colors.yellow);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('message styles use complete tokens in light and dark themes', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        final baseToken = TThemeData.defaultData();
        final materialTheme = brightness == Brightness.light
            ? TThemeBuilder.light(baseToken)
            : TThemeBuilder.dark(baseToken);
        await tester.pumpWidget(
          MaterialApp(
            theme: materialTheme.mergeExtension(
              const TFormThemeData(
                labelStyle: TextStyle(decoration: TextDecoration.underline),
                helpStyle: TextStyle(fontStyle: FontStyle.italic),
                errorStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            home: const Scaffold(
              body: Column(
                children: [
                  TFormItem(label: 'Label', help: 'Help', child: Text('Field')),
                  TFormItem(errorText: 'Error', child: Text('Invalid')),
                ],
              ),
            ),
          ),
        );

        final token = tester.element(find.text('Help')).tTheme;
        final labelStyle = tester.widget<Text>(find.text('Label')).style;
        final helpStyle = tester.widget<Text>(find.text('Help')).style;
        final errorStyle = tester.widget<Text>(find.text('Error')).style;
        expect(labelStyle?.color, token.textColorPrimary);
        expect(labelStyle?.fontSize, token.fontBodyLarge?.size);
        expect(labelStyle?.height, token.fontBodyLarge?.height);
        expect(labelStyle?.decoration, TextDecoration.underline);
        expect(helpStyle?.color, token.textColorPlaceholder);
        expect(helpStyle?.fontSize, token.fontBodySmall?.size);
        expect(helpStyle?.height, token.fontBodySmall?.height);
        expect(helpStyle?.fontStyle, FontStyle.italic);
        expect(errorStyle?.color, token.errorNormalColor);
        expect(errorStyle?.fontSize, token.fontBodySmall?.size);
        expect(errorStyle?.height, token.fontBodySmall?.height);
        expect(errorStyle?.fontWeight, FontWeight.bold);
      }
    });

    testWidgets('message semantic colors override the generic text color', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token).copyWith(
            textTheme: const TextTheme(
              bodySmall: TextStyle(color: Colors.black),
            ),
          ),
          home: const Scaffold(
            body: Column(
              children: [
                TFormItem(help: 'Help', child: Text('Field')),
                TFormItem(errorText: 'Error', child: Text('Invalid')),
              ],
            ),
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Help')).style?.color,
        token.textColorPlaceholder,
      );
      expect(
        tester.widget<Text>(find.text('Error')).style?.color,
        token.errorNormalColor,
      );
    });

    testWidgets('explicit Material label typography overrides token defaults', (
      tester,
    ) async {
      const materialLabel = TextStyle(
        color: Colors.deepPurple,
        fontSize: 19,
        fontWeight: FontWeight.w600,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(
            TThemeData.defaultData(),
          ).copyWith(textTheme: const TextTheme(bodyMedium: materialLabel)),
          home: const Scaffold(
            body: TFormItem(label: 'Material label', child: Text('Field')),
          ),
        ),
      );

      final style = tester.widget<Text>(find.text('Material label')).style;
      expect(style?.color, materialLabel.color);
      expect(style?.fontSize, materialLabel.fontSize);
      expect(style?.fontWeight, materialLabel.fontWeight);
    });

    testWidgets('font fallback does not override default label geometry', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      final theme = TThemeBuilder.light(token);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme.copyWith(
            textTheme: theme.textTheme.apply(
              fontFamilyFallback: ['TDesign Test Fallback'],
            ),
          ),
          home: const Scaffold(
            body: TFormItem(label: 'Default label', child: Text('Field')),
          ),
        ),
      );

      final style = tester.widget<Text>(find.text('Default label')).style;
      expect(style?.fontSize, token.fontBodyLarge?.size);
      expect(style?.height, token.fontBodyLarge?.height);
      expect(style?.fontWeight, token.fontBodyLarge?.fontWeight);
      expect(style?.fontFamilyFallback, contains('TDesign Test Fallback'));
    });

    testWidgets('required mark theme merges with the semantic error color', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TFormItem(label: 'Name', required: true, child: Text('Field')),
          formTheme: const TFormThemeData(
            requiredMarkStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

      final style = tester.widget<Text>(find.text('*')).style;
      expect(style?.color, TThemeData.defaultData().errorNormalColor);
      expect(style?.fontWeight, FontWeight.bold);
    });

    testWidgets('long labels and message rows align to the top', (
      tester,
    ) async {
      const fieldKey = Key('centered-field');
      const messageFieldKey = Key('message-field');
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              TFormItem(
                label: '标签超长时最多十个字',
                child: SizedBox(key: fieldKey, height: 24),
              ),
              TFormItem(
                label: '标签文字',
                help: '最大输入10个字符',
                child: SizedBox(key: messageFieldKey, height: 24),
              ),
            ],
          ),
        ),
      );

      final longLabelRect = tester.getRect(find.text('标签超长时最多十个字'));
      final fieldRect = tester.getRect(find.byKey(fieldKey));
      final messageLabelRect = tester.getRect(find.text('标签文字'));
      final messageFieldRect = tester.getRect(find.byKey(messageFieldKey));
      expect(longLabelRect.top, closeTo(fieldRect.top, 0.01));
      expect(messageLabelRect.top, closeTo(messageFieldRect.top, 0.01));
    });

    testWidgets('tall horizontal fields align labels to the top', (
      tester,
    ) async {
      const fieldKey = Key('top-aligned-field');
      await tester.pumpWidget(
        wrap(
          const TFormItem(
            label: '个人简介',
            child: SizedBox(key: fieldKey, height: 100),
          ),
        ),
      );
      await tester.pump();

      final labelRect = tester.getRect(find.text('个人简介'));
      final fieldRect = tester.getRect(find.byKey(fieldKey));
      expect(labelRect.top, closeTo(fieldRect.top, 0.01));
    });

    testWidgets('leading is part of the form item structure', (tester) async {
      const leadingKey = Key('leading');
      await tester.pumpWidget(
        wrap(
          const TFormItem(
            leading: Icon(Icons.search, key: leadingKey),
            label: 'Name',
            child: Text('Field'),
          ),
          formTheme: const TFormThemeData(leadingGap: 20),
        ),
      );

      final leadingFinder = find.byKey(leadingKey);
      final leadingRect = tester.getRect(leadingFinder);
      final labelRect = tester.getRect(find.text('Name'));
      final fieldRect = tester.getRect(find.text('Field'));
      final iconTheme = IconTheme.of(tester.element(leadingFinder));

      expect(labelRect.left - leadingRect.right, 20);
      expect(leadingRect.left, lessThan(labelRect.left));
      expect(labelRect.left, lessThan(fieldRect.left));
      expect(iconTheme.size, 24);
      expect(iconTheme.color, TThemeData.defaultData().textColorPrimary);
    });

    testWidgets('vertical leading shares the label header', (tester) async {
      const leadingKey = Key('vertical-leading');
      await tester.pumpWidget(
        wrap(
          const TFormItem(
            leading: Icon(Icons.search, key: leadingKey),
            label: 'Name',
            child: Text('Field'),
          ),
          formTheme: const TFormThemeData(layout: TFormLayout.vertical),
        ),
      );

      final leadingRect = tester.getRect(find.byKey(leadingKey));
      final labelRect = tester.getRect(find.text('Name'));
      final fieldRect = tester.getRect(find.text('Field'));
      expect(leadingRect.left, lessThan(labelRect.left));
      expect(labelRect.top, lessThan(fieldRect.top));
    });

    testWidgets('vertical extra stays at the trailing edge beside controls', (
      tester,
    ) async {
      const fieldKey = Key('vertical-field');
      const extraKey = Key('vertical-extra');
      await tester.pumpWidget(
        wrap(
          const Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TFormItem(
                  label: '生日',
                  extra: SizedBox(key: extraKey, width: 24, height: 24),
                  child: SizedBox(key: fieldKey, height: 24),
                ),
              ],
            ),
          ),
          formTheme: const TFormThemeData(layout: TFormLayout.vertical),
        ),
      );

      final fieldRect = tester.getRect(find.byKey(fieldKey));
      final extraRect = tester.getRect(find.byKey(extraKey));
      expect(extraRect.left, fieldRect.right);
      expect(extraRect.center.dy, closeTo(fieldRect.center.dy - 15, 0.01));
      expect(extraRect.right, 384);
    });

    testWidgets('horizontal vertical alignment supports theme and override', (
      tester,
    ) async {
      const fieldKey = Key('aligned-field');
      const extraKey = Key('aligned-extra');

      Future<void> pump({TFormItemVerticalAlignment? alignment}) =>
          tester.pumpWidget(
            wrap(
              TFormItem(
                label: 'Label',
                help: 'Help',
                verticalAlignment: alignment,
                child: const SizedBox(key: fieldKey, height: 40),
                extra: TButton(
                  key: extraKey,
                  size: TButtonSize.extraSmall,
                  onPressed: () {},
                  child: const Text('Action'),
                ),
              ),
              formTheme: const TFormThemeData(
                verticalAlignment: TFormItemVerticalAlignment.center,
              ),
            ),
          );

      await pump();
      var fieldRect = tester.getRect(find.byKey(fieldKey));
      var extraRect = tester.getRect(find.byKey(extraKey));
      var helpRect = tester.getRect(find.text('Help'));
      expect(extraRect.height, 28);
      expect(
        extraRect.center.dy,
        closeTo((fieldRect.top + helpRect.bottom) / 2, 0.01),
      );

      await pump(alignment: TFormItemVerticalAlignment.start);
      fieldRect = tester.getRect(find.byKey(fieldKey));
      extraRect = tester.getRect(find.byKey(extraKey));
      expect(extraRect.top, closeTo(fieldRect.top, 0.01));
    });

    testWidgets('content alignment applies to fields and messages', (
      tester,
    ) async {
      const fieldKey = Key('aligned-content-field');
      await tester.pumpWidget(
        wrap(
          const TFormItem(
            label: 'Label',
            help: 'Help',
            contentAlignment: TFormItemContentAlignment.end,
            child: SizedBox(key: fieldKey, width: 40, height: 24),
          ),
          formTheme: const TFormThemeData(
            contentAlignment: TFormItemContentAlignment.start,
          ),
        ),
      );

      final fieldRect = tester.getRect(find.byKey(fieldKey));
      final helpRect = tester.getRect(find.text('Help'));
      expect(fieldRect.right, 384);
      expect(helpRect.right, 384);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        wrap(
          const TFormItem(
            label: 'Label',
            help: 'Help',
            child: SizedBox(key: fieldKey, width: 40, height: 24),
          ),
          formTheme: const TFormThemeData(
            contentAlignment: TFormItemContentAlignment.end,
          ),
        ),
      );
      expect(tester.getRect(find.byKey(fieldKey)).right, 384);
    });

    testWidgets('physical and directional label alignments differ in RTL', (
      tester,
    ) async {
      const leftKey = Key('left-label-item');
      const rightKey = Key('right-label-item');
      const startKey = Key('start-label-item');
      await tester.pumpWidget(
        wrap(
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                TFormItem(
                  key: leftKey,
                  label: '标签',
                  labelAlign: TextAlign.left,
                  child: SizedBox(),
                ),
                TFormItem(
                  key: rightKey,
                  label: '标签',
                  labelAlign: TextAlign.right,
                  child: SizedBox(),
                ),
                TFormItem(
                  key: startKey,
                  label: '标签',
                  labelAlign: TextAlign.start,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      Rect labelRect(Key itemKey) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.descendant(of: find.byKey(itemKey), matching: find.text('标签')),
        );
        final glyphs = paragraph
            .getBoxesForSelection(
              const TextSelection(baseOffset: 0, extentOffset: 2),
            )
            .map((box) => box.toRect())
            .reduce((bounds, box) => bounds.expandToInclude(box));
        return glyphs.shift(paragraph.localToGlobal(Offset.zero));
      }

      final left = labelRect(leftKey);
      final right = labelRect(rightKey);
      final start = labelRect(startKey);
      expect(left.left, lessThan(right.left));
      expect(start.left, closeTo(right.left, 0.01));
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
      requiredMarkPosition: TFormRequiredMarkPosition.left,
      labelStyle: TextStyle(fontSize: 12),
      requiredMarkStyle: TextStyle(color: Colors.red),
      helpStyle: TextStyle(color: Colors.grey),
      errorStyle: TextStyle(color: Colors.red),
      backgroundColor: Colors.white,
      itemPadding: EdgeInsets.all(4),
      itemSpacing: 4,
      labelGap: 6,
      leadingGap: 8,
      messageGap: 2,
      verticalAlignment: TFormItemVerticalAlignment.start,
      contentAlignment: TFormItemContentAlignment.start,
    );
    const other = TFormThemeData(
      showColon: false,
      labelWidth: 120,
      layout: TFormLayout.vertical,
      labelAlign: TextAlign.right,
      requiredMarkPosition: TFormRequiredMarkPosition.right,
      labelStyle: TextStyle(fontSize: 16),
      requiredMarkStyle: TextStyle(color: Colors.blue),
      helpStyle: TextStyle(color: Colors.black),
      errorStyle: TextStyle(color: Colors.orange),
      backgroundColor: Colors.black,
      itemPadding: EdgeInsets.all(8),
      itemSpacing: 8,
      labelGap: 10,
      leadingGap: 12,
      messageGap: 6,
      verticalAlignment: TFormItemVerticalAlignment.center,
      contentAlignment: TFormItemContentAlignment.end,
    );

    expect(base.copyWith().labelWidth, 80);
    expect(
      base
          .copyWith(
            showColon: false,
            labelWidth: 100,
            layout: TFormLayout.vertical,
            labelAlign: TextAlign.center,
            requiredMarkPosition: TFormRequiredMarkPosition.right,
            labelStyle: const TextStyle(fontSize: 14),
            requiredMarkStyle: const TextStyle(color: Colors.green),
            helpStyle: const TextStyle(color: Colors.blueGrey),
            errorStyle: const TextStyle(color: Colors.purple),
            backgroundColor: Colors.grey,
            itemPadding: const EdgeInsets.all(6),
            itemSpacing: 6,
            labelGap: 8,
            leadingGap: 10,
            messageGap: 4,
            verticalAlignment: TFormItemVerticalAlignment.center,
            contentAlignment: TFormItemContentAlignment.end,
          )
          .layout,
      TFormLayout.vertical,
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.25).showColon, isTrue);
    expect(base.lerp(other, 0.75).layout, TFormLayout.vertical);
    expect(
      base.lerp(other, 0.25).requiredMarkPosition,
      TFormRequiredMarkPosition.left,
    );
    expect(
      base.lerp(other, 0.75).requiredMarkPosition,
      TFormRequiredMarkPosition.right,
    );
    expect(base.lerp(other, 0.5).labelWidth, 100);
    expect(base.lerp(other, 0.5).itemSpacing, 6);
    expect(base.lerp(other, 0.5).leadingGap, 10);
    expect(
      base.lerp(other, 0.75).verticalAlignment,
      TFormItemVerticalAlignment.center,
    );
    expect(
      base.lerp(other, 0.75).contentAlignment,
      TFormItemContentAlignment.end,
    );

    const defaults = TFormThemeData();
    const customized = TFormThemeData(
      labelWidth: 120,
      itemPadding: EdgeInsets.all(24),
      itemSpacing: 8,
      labelGap: 16,
      backgroundColor: Colors.black,
    );
    final fromDefaults = defaults.lerp(customized, 0.25);
    expect(fromDefaults.labelWidth, 90);
    expect(fromDefaults.itemPadding, const EdgeInsets.all(18));
    expect(fromDefaults.itemSpacing, 2);
    expect(fromDefaults.labelGap, 10);
    expect(fromDefaults.backgroundColor, isNull);
    expect(defaults.lerp(defaults, 0.5).labelWidth, isNull);
  });

  testWidgets('default horizontal item height does not depend on extra', (
    tester,
  ) async {
    const plainKey = Key('plain-form-item');
    const extraKey = Key('extra-form-item');
    await tester.pumpWidget(
      wrap(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TFormItem(key: plainKey, label: '标签', child: SizedBox(height: 24)),
            TFormItem(
              key: extraKey,
              label: '标签',
              extra: SizedBox(width: 24, height: 28),
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );

    expect(tester.getSize(find.byKey(plainKey)).height, 56);
    expect(tester.getSize(find.byKey(extraKey)).height, 56);
  });
}
