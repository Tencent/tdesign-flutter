import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  final items = [
    const TSideBarItem(value: 1, label: '选项一', icon: Icons.star),
    const TSideBarItem(value: 2, label: '选项二', disabled: true),
    const TSideBarItem(value: 3, label: '选项三'),
  ];

  group('TSideBar widget 级用例', () {
    testWidgets('基础可构建并渲染标签', (tester) async {
      await tester.pumpWidget(wrap(TSideBar(
        value: 1,
        children: items,
        onChanged: (_) {},
      )));
      expect(find.byType(TSideBar), findsOneWidget);
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项三'), findsOneWidget);
    });

    testWidgets('outline 样式 / selectedColor / contentPadding / height',
        (tester) async {
      await tester.pumpWidget(wrap(TSideBar(
        value: 1,
        style: TSideBarVariant.outline,
        selectedColor: Colors.red,
        unSelectedColor: Colors.grey,
        contentPadding: const EdgeInsets.all(8),
        height: 300,
        children: items,
        onChanged: (_) {},
      )));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('loading 态可构建', (tester) async {
      await tester.pumpWidget(wrap(TSideBar(
        value: 1,
        loading: true,
        children: items,
      )));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('点击选项触发 onChanged', (tester) async {
      int? selected;
      await tester.pumpWidget(wrap(TSideBar(
        value: 1,
        children: items,
        onChanged: (v) => selected = v,
      )));
      await tester.tap(find.text('选项三'));
      await tester.pumpAndSettle();
      expect(selected, 3);
    });
  });
}
