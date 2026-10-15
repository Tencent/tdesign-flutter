import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'support/migration_027_examples.dart';

Widget host(Widget child) => migratedApp(Scaffold(body: child));

void main() {
  testWidgets('M01 button: content, renamed callback and null disables', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(host(migratedButton(() => taps++)));
    await tester.tap(find.text('保存'));
    expect(taps, 1);
    await tester.pumpWidget(host(migratedButton(null)));
    await tester.tap(find.text('保存'));
    expect(taps, 1);
  });

  testWidgets('M02 text: local TD theme and explicit instance override', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => migratedTextTheme(
            context,
            const Column(
              children: [
                TText('默认'),
                TText('实例', style: TextStyle(fontSize: 23)),
              ],
            ),
          ),
        ),
      ),
    );
    final first = tester.widget<RichText>(
      find.descendant(
        of: find.widgetWithText(TText, '默认'),
        matching: find.byType(RichText),
      ),
    );
    final second = tester.widget<RichText>(
      find.descendant(
        of: find.widgetWithText(TText, '实例'),
        matching: find.byType(RichText),
      ),
    );
    expect(first.text.style?.fontSize, 18);
    expect(second.text.style?.fontSize, 23);
  });

  testWidgets('M03 checkbox: parent accepts controlled value', (tester) async {
    var value = false;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => migratedCheckbox(
            value,
            (next) => setState(() => value = next ?? false),
          ),
        ),
      ),
    );
    await tester.tap(find.text('同意条款'));
    await tester.pump();
    expect(value, isTrue);
    expect(tester.widget<TCheckbox>(find.byType(TCheckbox)).value, isTrue);
  });

  testWidgets('M04 radio: typed group owns selection', (tester) async {
    var value = 'a';
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) =>
              migratedRadio(value, (next) => setState(() => value = next)),
        ),
      ),
    );
    await tester.tap(find.text('方案 B'));
    await tester.pump();
    expect(value, 'b');
  });

  testWidgets('M05 form: required validation and accepted input', (
    tester,
  ) async {
    final form = TFormController();
    final text = TextEditingController();
    addTearDown(text.dispose);
    var value = '';
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => migratedForm(
            form: form,
            text: text,
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );
    expect(form.validate(), isFalse);
    await tester.pump();
    expect(find.text('请输入姓名'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'Ada');
    await tester.pump();
    expect(value, 'Ada');
    expect(form.validate(), isTrue);
  });

  testWidgets(
    'M06 picker: cancellation never commits draft; confirmation commits',
    (tester) async {
      String? committed;
      late BuildContext context;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (c) {
              context = c;
              return const Text('宿主');
            },
          ),
        ),
      );
      final handle = migratedPicker(
        context: context,
        initialValue: 'a',
        onConfirmed: (value) => committed = value,
      );
      await tester.pumpAndSettle();
      expect(handle.isShowing, isTrue);
      final picker = tester.widget<TPicker>(find.byType(TPicker));
      picker.onChanged!(
        const TPickerValue(
          selectedOptions: [TPickerOption(label: '选项 B', value: 'b')],
          indexes: [1],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(committed, isNull);
      migratedPicker(
        context: context,
        initialValue: 'a',
        onConfirmed: (value) => committed = value,
      );
      await tester.pumpAndSettle();
      tester.widget<TPicker>(find.byType(TPicker)).onChanged!(
        const TPickerValue(
          selectedOptions: [TPickerOption(label: '选项 B', value: 'b')],
          indexes: [1],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(committed, 'b');
      expect(find.byType(TPicker), findsNothing);
    },
  );

  testWidgets('M07 dialog: result completes after confirmed close', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );
    final result = migratedDialog(context);
    await tester.pumpAndSettle();
    await tester.tap(find.text('继续'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });

  testWidgets('M08 upload: custom picker produces accepted immutable list', (
    tester,
  ) async {
    var files = <TUploadFile>[];
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => migratedUpload(
            files: files,
            onChanged: (next) => setState(() => files = next),
            picker: () async => const [
              TUploadFile(id: 'file', name: 'report.pdf', size: 12),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('upload-add')));
    await tester.pumpAndSettle();
    expect(files.single.id, 'file');
    expect(() => files.clear(), throwsUnsupportedError);
  });

  testWidgets('M09 calendar and date picker use public controlled types', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(migratedCalendar([DateTime(2026, 10, 15)], (_) {})),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
      host(
        migratedDateTime(
          const TDateTimePickerValue(year: 2026, month: 10, day: 15),
          (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('M10 toast: zero duration stays until explicitly dismissed', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      host(
        Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );
    final id = migratedLoading(context);
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('处理中'), findsOneWidget);
    TToast.dismissToast(id);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('处理中'), findsNothing);
  });
}
