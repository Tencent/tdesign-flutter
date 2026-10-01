import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TSideBarThemeData? sideBarTheme}) => MaterialApp(
    theme: ThemeData(
      extensions: [
        TThemeData.defaultData(),
        if (sideBarTheme != null) sideBarTheme,
      ],
    ),
    home: Scaffold(body: child),
  );

  final items = [
    const TSideBarItem(value: 1, label: '选项一', icon: Icons.star),
    const TSideBarItem(value: 2, label: '选项二', disabled: true),
    const TSideBarItem(value: 3, label: '选项三'),
  ];

  group('TSideBar widget 级用例', () {
    testWidgets('基础可构建并渲染标签', (tester) async {
      await tester.pumpWidget(
        wrap(TSideBar(value: 1, children: items, onChanged: (_) {})),
      );
      expect(find.byType(TSideBar), findsOneWidget);
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项三'), findsOneWidget);
    });

    testWidgets('tag 样式 / 选中前景色 / contentPadding / height', (tester) async {
      await tester.pumpWidget(
        wrap(
          TSideBar(
            value: 1,
            variant: TSideBarVariant.tag,
            height: 300,
            children: items,
            onChanged: (_) {},
          ),
          sideBarTheme: const TSideBarThemeData(
            selectedTextStyle: TextStyle(color: Colors.red),
            textStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.all(8),
          ),
        ),
      );
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('未选中样式颜色不覆盖选中和禁用态', (tester) async {
      await tester.pumpWidget(
        wrap(
          TSideBar(
            value: 1,
            children: const [
              TSideBarItem(value: 1, label: '选中', icon: Icons.star),
              TSideBarItem(
                value: 2,
                label: '禁用',
                icon: Icons.lock,
                disabled: true,
              ),
              TSideBarItem(value: 3, label: '普通', icon: Icons.home),
            ],
            onChanged: (_) {},
          ),
          sideBarTheme: const TSideBarThemeData(
            textStyle: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
      );

      final theme = TThemeData.defaultData();
      expect(
        tester.widget<Text>(find.text('选中')).style?.color,
        theme.brandColor,
      );
      expect(
        tester.widget<Text>(find.text('禁用')).style?.color,
        theme.textColorDisabled,
      );
      expect(tester.widget<Text>(find.text('普通')).style?.color, Colors.grey);
      expect(tester.widget<Text>(find.text('选中')).style?.fontSize, 15);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.star)).color,
        theme.brandColor,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.lock)).color,
        theme.textColorDisabled,
      );
      expect(tester.widget<Icon>(find.byIcon(Icons.home)).color, Colors.grey);

      await tester.pumpWidget(
        wrap(
          TSideBar(
            value: 1,
            children: const [
              TSideBarItem(value: 1, label: '选中', icon: Icons.star),
              TSideBarItem(
                value: 2,
                label: '禁用',
                icon: Icons.lock,
                disabled: true,
              ),
            ],
            onChanged: (_) {},
          ),
          sideBarTheme: const TSideBarThemeData(
            textStyle: TextStyle(color: Colors.grey, fontSize: 15),
            selectedTextStyle: TextStyle(color: Colors.red),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.text('选中')).style?.color, Colors.red);
      expect(tester.widget<Text>(find.text('选中')).style?.fontSize, 15);
      expect(tester.widget<Icon>(find.byIcon(Icons.star)).color, Colors.red);
    });

    testWidgets('loading 态可构建', (tester) async {
      await tester.pumpWidget(
        wrap(TSideBar(value: 1, loading: true, children: items)),
      );
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('点击选项触发 onChanged', (tester) async {
      int? selected;
      await tester.pumpWidget(
        wrap(
          TSideBar(value: 1, children: items, onChanged: (v) => selected = v),
        ),
      );
      await tester.tap(find.text('选项三'));
      await tester.pumpAndSettle();
      expect(selected, 3);
    });
  });
}
