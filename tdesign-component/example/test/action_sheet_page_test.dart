import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_action_sheet_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'action_sheet_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(actionSheetDemoPageTestSpec);

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TActionSheetPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Finder pageScrollable() => find.descendant(
    of: find.byType(CustomScrollView),
    matching: find.byType(Scrollable),
  );

  Future<void> openBasicGrid(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '常规宫格型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  Future<void> openBasicList(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '常规列表型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  Future<void> openDescribedList(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '带描述列表型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  testWidgets('官方 Demo 矩阵公开展示全部场景', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    const labels = [
      '常规列表型',
      '带描述列表型',
      '带图标列表型',
      '带徽标列表型',
      '常规宫格型',
      '带描述宫格型',
      '带图标宫格型',
      '带徽标宫格型',
      '多行滚动宫格型',
      '带描述多行滚动宫格型',
      '列表型选项状态',
      '居中列表型',
      '左对齐列表型',
    ];
    final position = tester
        .state<ScrollableState>(pageScrollable().first)
        .position;
    final foundLabels = <String>{};
    for (var offset = 0.0; offset <= position.maxScrollExtent; offset += 200) {
      position.jumpTo(offset.clamp(0, position.maxScrollExtent));
      await tester.pump();
      for (final label in labels) {
        if (find.widgetWithText(TButton, label).evaluate().isNotEmpty) {
          foundLabels.add(label);
        }
      }
    }
    position.jumpTo(position.maxScrollExtent);
    await tester.pump();
    for (final label in labels) {
      if (find.widgetWithText(TButton, label).evaluate().isNotEmpty) {
        foundLabels.add(label);
      }
    }
    expect(foundLabels, containsAll(labels));
    expect(find.text('单元测试'), findsNothing);
  });

  testWidgets('触发按钮按 Figma 使用 16dp 边距和 8dp 间距连续排列', (tester) async {
    tester.view.physicalSize = const Size(375, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final triggers = [
      find.widgetWithText(TButton, '常规列表型'),
      find.widgetWithText(TButton, '带描述列表型'),
      find.widgetWithText(TButton, '带图标列表型'),
      find.widgetWithText(TButton, '带徽标列表型'),
    ];
    final rects = triggers.map(tester.getRect).toList();
    for (final rect in rects) {
      expect(rect.left, 16);
      expect(rect.right, 359);
      expect(rect.height, 48);
    }
    for (var index = 1; index < rects.length; index++) {
      expect(rects[index].top - rects[index - 1].bottom, 8);
    }
  });

  testWidgets('常规宫格型在手机视口完整展示且不溢出', (tester) async {
    configurePhone(tester);

    await openBasicGrid(tester);

    expect(find.byType(TActionSheetGrid), findsOneWidget);
    expect(find.text('微信'), findsOneWidget);
    expect(find.text('复制'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('常规列表型触发后展示内容', (tester) async {
    configurePhone(tester);

    await openBasicList(tester);

    expect(find.text('Move'), findsOneWidget);
    expect(find.text('cancel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('带描述列表型完整展示描述、四个选项和取消项', (tester) async {
    configurePhone(tester);

    await openDescribedList(tester);

    expect(find.text('Email Settings'), findsOneWidget);
    for (final label in [
      'Move',
      'Mark as important',
      'Unsubscribe',
      'Add to Tasks',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('cancel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
