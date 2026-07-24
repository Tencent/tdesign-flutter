import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/checkbox/t_selection_card.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Scaffold(body: child),
    );
  }

  const options = [
    TCheckboxOption(value: 'a', label: '选项 A'),
    TCheckboxOption(value: 'b', label: '选项 B', subTitle: '说明 B'),
    TCheckboxOption(value: 'c', label: '选项 C', disabled: true),
  ];

  group('TCheckboxGroup v1 受控行为', () {
    testWidgets('按 value 渲染选中项并按 options 顺序回调', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(wrap(TCheckboxGroup<String>(
        value: const ['b'],
        options: options,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.text('选项 A'));
      await tester.pump();

      expect(changed, ['a', 'b']);
      expect(find.text('说明 B'), findsOneWidget);
    });

    testWidgets('点击已选项会移除该项', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(wrap(TCheckboxGroup<String>(
        value: const ['a', 'b'],
        options: options,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.text('选项 A'));
      await tester.pump();

      expect(changed, ['b']);
    });

    testWidgets('onChanged 为 null 时整组禁用', (tester) async {
      await tester.pumpWidget(wrap(const TCheckboxGroup<String>(
        value: ['a'],
        options: options,
      )));

      await tester.tap(find.text('选项 A'));
      await tester.pump();
      expect(find.text('选项 A'), findsOneWidget);
    });

    testWidgets('禁用 option 不触发回调', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(wrap(TCheckboxGroup<String>(
        value: const [],
        options: options,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.text('选项 C'));
      await tester.pump();

      expect(changed, isNull);
    });

    testWidgets('maxSelected 超限时触发 onMaxSelected 并保持原值', (tester) async {
      var overloaded = false;
      List<String>? changed;
      await tester.pumpWidget(wrap(TCheckboxGroup<String>(
        value: const ['a'],
        options: options,
        maxSelected: 1,
        onMaxSelected: () => overloaded = true,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.text('选项 B'));
      await tester.pump();

      expect(overloaded, isTrue);
      expect(changed, isNull);
    });
  });

  group('TCheckboxGroup v1 布局与自定义项', () {
    testWidgets('横向多列布局可构建', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 240,
        child: TCheckboxGroup<String>(
          value: ['a'],
          options: options,
          direction: Axis.horizontal,
          columns: 2,
        ),
      )));

      expect(find.byType(TCheckboxGroup<String>), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('cardMode 使用卡片组布局', (tester) async {
      await tester.pumpWidget(wrap(const TCheckboxGroup<String>(
        value: ['a'],
        options: options,
        cardMode: true,
      )));

      expect(find.text('选项 A'), findsOneWidget);
      expect(find.text('选项 B'), findsOneWidget);
    });

    testWidgets('itemBuilder 由 Group 接管点击和语义', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(wrap(TCheckboxGroup<String>(
        value: const [],
        options: options,
        onChanged: (value) => changed = value,
        itemBuilder: (context, option, selected, disabled) {
          return Text('${option.label} $selected $disabled');
        },
      )));

      await tester.tap(find.text('选项 A false false'));
      await tester.pump();

      expect(changed, ['a']);
    });

    test('columns 必须大于 0', () {
      expect(
        () => TCheckboxGroup<String>(
          value: const [],
          options: options,
          columns: 0,
        ),
        throwsAssertionError,
      );
    });
  });

  group('TSelectionCard 内部布局', () {
    testWidgets('选中/禁用/未选卡片路径可构建', (tester) async {
      await tester.pumpWidget(wrap(const Column(
        children: [
          TSelectionCard(
            selected: true,
            disabled: false,
            selectedColor: Colors.blue,
            disabledColor: Colors.grey,
            backgroundColor: Colors.white,
            borderRadius: 6,
            minHeight: 56,
            child: Text('selected'),
          ),
          TSelectionCard(
            selected: true,
            disabled: true,
            selectedColor: Colors.blue,
            disabledColor: Colors.grey,
            backgroundColor: Colors.white,
            borderRadius: 6,
            minHeight: 56,
            child: Text('disabled'),
          ),
          TSelectionCard(
            selected: false,
            disabled: false,
            selectedColor: Colors.blue,
            disabledColor: Colors.grey,
            backgroundColor: Colors.white,
            borderRadius: 6,
            minHeight: 56,
            child: Text('plain'),
          ),
        ],
      )));

      expect(find.text('selected'), findsOneWidget);
      expect(find.text('disabled'), findsOneWidget);
      expect(find.text('plain'), findsOneWidget);
      expect(find.byIcon(TIcons.check), findsNWidgets(2));
    });

    testWidgets('选择卡片角标使用反色文本 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(const TSelectionCard(
        selected: true,
        disabled: false,
        selectedColor: Colors.blue,
        disabledColor: Colors.grey,
        backgroundColor: Colors.white,
        borderRadius: 4,
        minHeight: 56,
        child: Text('selected'),
      )));

      final icon = tester.widget<Icon>(find.byIcon(TIcons.check));
      expect(icon.color, token.textColorAnti);
    });

    testWidgets('垂直布局按副标题高度和间距构建', (tester) async {
      await tester.pumpWidget(wrap(TSelectionCardGroupLayout(
        direction: Axis.vertical,
        columns: 1,
        itemHasSubtitles: const [false, true],
        children: const [
          Text('a'),
          Text('b'),
        ],
      )));

      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('水平布局覆盖有/无副标题与有限宽约束', (tester) async {
      await tester.pumpWidget(wrap(SizedBox(
        width: 240,
        child: Column(
          children: [
            TSelectionCardGroupLayout(
              direction: Axis.horizontal,
              columns: 2,
              itemHasSubtitles: const [false, false],
              children: const [Text('a'), Text('b')],
            ),
            TSelectionCardGroupLayout(
              direction: Axis.horizontal,
              columns: 2,
              itemHasSubtitles: const [false, true],
              children: const [Text('c'), Text('d')],
            ),
          ],
        ),
      )));

      expect(find.text('a'), findsOneWidget);
      expect(find.text('d'), findsOneWidget);
      expect(find.byType(Wrap), findsNWidgets(2));
    });

    test('children 与 itemHasSubtitles 长度必须一致', () {
      expect(
        () => TSelectionCardGroupLayout(
          direction: Axis.vertical,
          columns: 1,
          itemHasSubtitles: const [false],
          children: const [Text('a'), Text('b')],
        ),
        throwsAssertionError,
      );
    });

    test('列数必须大于 0', () {
      expect(
        () => TSelectionCardGroupLayout(
          direction: Axis.horizontal,
          columns: 0,
          itemHasSubtitles: const [false],
          children: const [Text('a')],
        ),
        throwsAssertionError,
      );
    });
  });
}
