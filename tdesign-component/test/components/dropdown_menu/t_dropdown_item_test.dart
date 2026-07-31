import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TDropdownThemeData? dropdownTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (dropdownTheme != null) {
      theme = theme.mergeExtension(dropdownTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: Align(alignment: Alignment.topCenter, child: child)),
    );
  }

  const options = <TDropdownMenuOption<String>>[
    TDropdownMenuOption(value: 'a', label: '选项 A', group: '第二组'),
    TDropdownMenuOption(value: 'b', label: '选项 B', group: '第一组'),
    TDropdownMenuOption(value: 'c', label: '选项 C', disabled: true),
  ];

  test('option is an immutable generic value object', () {
    const option = TDropdownMenuOption<int>(
      value: 1,
      label: '一',
      disabled: true,
      group: '数字',
    );
    expect(option.value, 1);
    expect(option.label, '一');
    expect(option.disabled, isTrue);
    expect(option.group, '数字');
  });

  testWidgets('single select reports value and closes with selection reason',
      (tester) async {
    String? selected;
    TDropdownMenuCloseReason? reason;
    await tester.pumpWidget(
      wrap(
        TDropdownMenu(
          animationDuration: Duration.zero,
          onClosed: (_, value) => reason = value,
          items: [
            TDropdownMenuItem(
              label: '单选',
              panelBuilder: (context, controller) =>
                  TDropdownSingleSelectPanel<String>(
                controller: controller,
                options: options,
                value: 'a',
                onChanged: (value) => selected = value,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('单选'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('选项 B'));
    await tester.pumpAndSettle();
    expect(selected, 'b');
    expect(reason, TDropdownMenuCloseReason.selection);
    expect(find.text('选项 B'), findsNothing);
  });

  testWidgets('disabled single option does not submit', (tester) async {
    var changed = false;
    await tester.pumpWidget(
      wrap(
        TDropdownMenu(
          animationDuration: Duration.zero,
          items: [
            TDropdownMenuItem(
              label: '单选',
              panelBuilder: (context, controller) =>
                  TDropdownSingleSelectPanel<String>(
                controller: controller,
                options: options,
                value: null,
                maxHeight: 200,
                onChanged: (_) => changed = true,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('单选'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('选项 C'));
    await tester.pump();
    expect(changed, isFalse);
    expect(find.text('选项 A'), findsOneWidget);
  });

  testWidgets('multi select keeps draft until confirm', (tester) async {
    Set<String>? confirmed;
    var confirmCount = 0;
    await tester.pumpWidget(
      wrap(
        TDropdownMenu(
          animationDuration: Duration.zero,
          items: [
            TDropdownMenuItem(
              label: '多选',
              panelBuilder: (context, controller) =>
                  TDropdownMultiSelectPanel<String>(
                controller: controller,
                options: options,
                values: const {'a'},
                columns: 2,
                onConfirm: (values) {
                  confirmed = values;
                  confirmCount++;
                },
              ),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('多选'));
    await tester.pumpAndSettle();
    expect(find.text('第二组'), findsOneWidget);
    expect(find.text('第一组'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('第二组')).dy,
      lessThan(tester.getTopLeft(find.text('第一组')).dy),
    );

    await tester.tap(find.text('选项 B'));
    await tester.pump();
    await tester.tap(find.text('选项 A'));
    await tester.pump();
    await tester.tap(find.text('选项 A'));
    await tester.pump();
    expect(confirmed, isNull);
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(confirmed, {'a', 'b'});
    expect(confirmCount, 1);
    expect(() => confirmed!.add('x'), throwsUnsupportedError);
  });

  testWidgets('reset only changes draft and cancel discards it',
      (tester) async {
    Set<String>? confirmed;
    final controller = TDropdownMenuController();
    await tester.pumpWidget(
      wrap(
        TDropdownMenu(
          controller: controller,
          animationDuration: Duration.zero,
          items: [
            TDropdownMenuItem(
              label: '多选',
              panelBuilder: (context, panelController) =>
                  TDropdownMultiSelectPanel<String>(
                controller: panelController,
                options: options,
                values: const {'a', 'b'},
                onConfirm: (values) => confirmed = values,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('多选'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('重置'));
    await tester.pump();
    expect(confirmed, isNull);
    await controller.close();
    await tester.pumpAndSettle();
    expect(confirmed, isNull);

    await tester.tap(find.text('多选'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('重置'));
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(confirmed, isEmpty);
    controller.dispose();
  });

  testWidgets('external committed value synchronizes while draft is clean',
      (tester) async {
    var values = <String>{'a'};
    Set<String>? confirmed;
    late StateSetter rebuild;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return TDropdownMenu(
              animationDuration: Duration.zero,
              items: [
                TDropdownMenuItem(
                  label: '多选',
                  panelBuilder: (context, controller) =>
                      TDropdownMultiSelectPanel<String>(
                    controller: controller,
                    options: options,
                    values: values,
                    onConfirm: (value) => confirmed = value,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('多选'));
    await tester.pumpAndSettle();
    rebuild(() => values = {'b'});
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(confirmed, {'b'});
  });

  testWidgets('dirty multi-select draft is not overwritten externally',
      (tester) async {
    var values = <String>{'a'};
    Set<String>? confirmed;
    late StateSetter rebuild;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return TDropdownMenu(
              animationDuration: Duration.zero,
              items: [
                TDropdownMenuItem(
                  label: '多选',
                  panelBuilder: (context, controller) =>
                      TDropdownMultiSelectPanel<String>(
                    controller: controller,
                    options: options,
                    values: values,
                    onConfirm: (value) => confirmed = value,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('多选'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('选项 B'));
    rebuild(() => values = {'c'});
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(confirmed, {'a', 'b'});
  });

  testWidgets('multi panel resolves all visual theme fields', (tester) async {
    await tester.pumpWidget(
      wrap(
        TDropdownMenu(
          animationDuration: Duration.zero,
          items: [
            TDropdownMenuItem(
              label: '主题',
              panelBuilder: (context, controller) =>
                  TDropdownMultiSelectPanel<String>(
                controller: controller,
                options: const [
                  TDropdownMenuOption(
                    value: 'a',
                    label: '选项 A',
                    group: '同组',
                  ),
                  TDropdownMenuOption(
                    value: 'b',
                    label: '选项 B',
                    group: '同组',
                  ),
                  TDropdownMenuOption(
                    value: 'c',
                    label: '选项 C',
                    group: '同组',
                  ),
                ],
                values: const {'a'},
                columns: 2,
                onConfirm: (_) {},
              ),
            ),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(
          optionHeight: 64,
          optionPadding: EdgeInsets.all(10),
          optionTextStyle: TextStyle(color: Colors.black),
          selectedOptionTextStyle: TextStyle(color: Colors.red),
          disabledOptionTextStyle: TextStyle(color: Colors.grey),
          optionColor: Colors.white,
          selectedOptionColor: Colors.orange,
          disabledOptionColor: Colors.black12,
          optionBorderRadius: BorderRadius.all(Radius.circular(20)),
          actionAreaPadding: EdgeInsets.all(12),
          actionGap: 20,
        ),
      ),
    );
    await tester.tap(find.text('主题'));
    await tester.pumpAndSettle();
    expect(find.text('选项 A'), findsOneWidget);
    expect(find.text('确定'), findsOneWidget);
  });
}
