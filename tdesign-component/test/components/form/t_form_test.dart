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
