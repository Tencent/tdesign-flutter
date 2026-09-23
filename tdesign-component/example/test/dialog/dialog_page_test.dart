import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/dialog/dialog_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import '../demo_page_test_utils.dart';
import 'dialog_demo_test_spec.dart';

void main() {
  tearDown(TToast.dismissAll);
  registerDemoStructureTests(dialogDemoPageTestSpec);

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TDialogPage(),
      ),
    );
  }

  Future<void> openScenario(WidgetTester tester, String label) async {
    final finder = find.widgetWithText(TButton, label);
    await tester.scrollUntilVisible(
      finder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    for (var attempt = 0; attempt < 5; attempt++) {
      final rect = tester.getRect(finder);
      if (rect.top >= 0 &&
          rect.bottom <= tester.view.physicalSize.height - 80) {
        break;
      }
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> closeCurrentDialog(WidgetTester tester) async {
    for (final label in ['取消', '知道了', '主要按钮']) {
      final action = find.widgetWithText(TButton, label);
      if (action.evaluate().isNotEmpty) {
        await tester.tap(action.last);
        await tester.pumpAndSettle();
        // 命令调用会展示结果提示；等待提示退场后再操作下一项。
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
        return;
      }
    }
    fail('当前 Dialog 没有可用于关闭的公开操作');
  }

  testWidgets('官方 Dialog Demo 矩阵公开展示全部场景', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    for (final label in dialogScenarioLabels) {
      final trigger = find.widgetWithText(TButton, label);
      await tester.scrollUntilVisible(
        trigger,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(trigger, findsOneWidget);
    }
    expect(
      find.text('用于显示重要提示或请求用户进行重要操作，一种打断当前操作的模态视图。', skipOffstage: false),
      findsOneWidget,
    );
    for (final label in ['文字按钮', '水平基础按钮', '垂直基础按钮', '多按钮', '带关闭按钮的对话框']) {
      expect(find.text(label), findsNWidgets(2), reason: label);
    }
    expect(find.text('单元测试'), findsNothing);
  });

  testWidgets('22 个公开入口均可通过真实操作打开并关闭', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    for (final label in dialogScenarioLabels) {
      await openScenario(tester, label);
      expect(find.byType(TDialog), findsOneWidget, reason: '$label 应打开');
      await closeCurrentDialog(tester);
      expect(find.byType(TDialog), findsNothing, reason: '$label 应关闭');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('命令调用点击面板四周蒙层关闭并提示来源', (tester) async {
    configureViewport(tester);
    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpWidget(buildPage());
    await tester.pump();
    for (final direction in ['left', 'right', 'top', 'bottom']) {
      await openScenario(tester, '命令行操作');
      final panel = tester.getRect(find.byType(TDialog));
      final point = switch (direction) {
        'left' => Offset(panel.left - 8, panel.center.dy),
        'right' => Offset(panel.right + 8, panel.center.dy),
        'top' => Offset(panel.center.dx, panel.top - 8),
        _ => Offset(panel.center.dx, panel.bottom + 8),
      };
      await tester.tapAt(point);
      await tester.pumpAndSettle();
      expect(find.byType(TDialog), findsNothing, reason: direction);
      expect(find.text('点击蒙层关闭'), findsOneWidget);
      TToast.dismissAll();
      await tester.pump();
    }
  });

  testWidgets('全部 22 个示例显式开启蒙层关闭，面板内点击不关闭', (tester) async {
    configureViewport(tester);
    tester.view.physicalSize = const Size(375, 812);
    for (final label in dialogScenarioLabels) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(buildPage());
      await tester.pump();
      for (final direction in ['left', 'right', 'top', 'bottom']) {
        await openScenario(tester, label);
        final panel = tester.getRect(find.byType(TDialog));
        await tester.tapAt(Offset(panel.center.dx, panel.top + 8));
        await tester.pumpAndSettle();
        expect(
          find.byType(TDialog),
          findsOneWidget,
          reason: '$label 面板内点击不应关闭',
        );
        final point = switch (direction) {
          'left' => Offset(panel.left - 8, panel.center.dy),
          'right' => Offset(panel.right + 8, panel.center.dy),
          'top' => Offset(panel.center.dx, panel.top - 8),
          _ => Offset(panel.center.dx, panel.bottom + 8),
        };
        await tester.tapAt(point);
        await tester.pumpAndSettle();
        expect(
          find.byType(TDialog),
          findsNothing,
          reason: '$label $direction 蒙层应关闭',
        );
        TToast.dismissAll();
        await tester.pumpAndSettle();
      }
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('命令调用用同一个结果通道区分确认取消关闭按钮和返回', (tester) async {
    configureViewport(tester);
    tester.view.physicalSize = const Size(375, 812);
    await tester.pumpWidget(buildPage());
    await tester.pump();
    for (final source in ['确定', '取消', '关闭按钮', '返回']) {
      await openScenario(tester, '命令行操作');
      if (source == '关闭按钮') {
        await tester.tap(find.byIcon(TIcons.close));
      } else if (source == '返回') {
        await tester.binding.handlePopRoute();
      } else {
        await tester.tap(find.widgetWithText(TButton, source));
      }
      await tester.pumpAndSettle();
      expect(find.byType(TDialog), findsNothing);
      expect(
        find.text(switch (source) {
          '确定' => '点击了确定',
          '取消' => '点击了取消',
          '关闭按钮' => '点击关闭按钮',
          _ => '返回或程序关闭',
        }),
        findsOneWidget,
      );
      TToast.dismissAll();
      await tester.pump();
    }
  });

  testWidgets('各类弹窗正文保持设计稿原文与标点', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    for (final label in [
      '反馈类-带标题',
      '确认类-带标题',
      '输入类-带描述',
      '图片置顶-带标题描述',
      '文字按钮',
    ]) {
      await openScenario(tester, label);
      expect(
        find.text('告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。'),
        findsOneWidget,
        reason: '$label 应使用设计稿正文，不自行润色或增删文字',
      );
      await closeCurrentDialog(tester);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('开放能力按钮通过现有 TDialogAction 组合', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await openScenario(tester, '开放能力按钮');

    expect(find.text('分享给朋友'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('六种图片场景保持全宽图片和 24dp 内容间距', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    for (final label in [
      '图片置顶-带标题描述',
      '图片置顶-无标题',
      '图片置顶-纯标题',
      '图片置顶-纯图片',
      '图片居中-带标题描述',
      '图片居中-纯标题',
    ]) {
      await openScenario(tester, label);
      final dialogFinder = find.byType(TDialog);
      final dialog = tester.widget<TDialog>(dialogFinder);
      expect(dialog.contentPadding, EdgeInsets.zero, reason: label);
      final dialogRect = tester.getRect(dialogFinder);
      final imageRect = tester.getRect(
        find.byKey(const ValueKey('dialog-image')),
      );
      expect(imageRect.left, dialogRect.left, reason: label);
      expect(imageRect.right, dialogRect.right, reason: label);
      expect(imageRect.width / imageRect.height, closeTo(16 / 9, 0.001));

      final buttons = find.descendant(
        of: dialogFinder,
        matching: find.byType(TButton),
      );
      final firstButtonRect = tester.getRect(buttons.first);
      if (label == '图片居中-纯标题') {
        final titleRect = tester.getRect(find.text('对话框标题'));
        expect(imageRect.top - titleRect.bottom, 24, reason: label);
      }
      if (label == '图片置顶-带标题描述' || label == '图片置顶-无标题') {
        final descriptionRect = tester.getRect(
          find.text('告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。'),
        );
        expect(firstButtonRect.top - descriptionRect.bottom, 24, reason: label);
      } else if (label == '图片置顶-纯标题') {
        final titleRect = tester.getRect(find.text('对话框标题'));
        expect(firstButtonRect.top - titleRect.bottom, 24, reason: label);
      } else {
        expect(firstButtonRect.top - imageRect.bottom, 24, reason: label);
      }
      await closeCurrentDialog(tester);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('输入类场景复用 TInput 并可连续输入', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await openScenario(tester, '输入类-带描述');

    expect(find.byType(TInput), findsOneWidget);
    expect(
      tester.getSize(find.byType(TInput)).height,
      greaterThanOrEqualTo(48),
    );
    final inputRect = tester.getRect(find.byType(TInput));
    final scrollRect = tester.getRect(find.byType(SingleChildScrollView).last);
    expect(inputRect.top, greaterThanOrEqualTo(scrollRect.top));
    expect(inputRect.bottom, lessThanOrEqualTo(scrollRect.bottom));
    final input = find.descendant(
      of: find.byType(TInput),
      matching: find.byType(TextField),
    );
    await tester.enterText(input, '连续输入内容');
    await tester.pump();
    expect(find.text('连续输入内容'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('文字按钮使用贴边文字变体', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await openScenario(tester, '文字按钮');
    final dialog = tester.widget<TDialog>(find.byType(TDialog));
    expect(
      dialog.actions.map((action) => action.variant),
      everyElement(TButtonVariant.text),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('标准场景的次要操作从组件取得浅色默认值', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();
    for (final label in [
      '确认类-带标题',
      '确认类-无标题',
      '确认类-纯标题',
      '水平基础按钮',
      '多按钮',
      '带关闭按钮的对话框',
    ]) {
      await openScenario(tester, label);
      final dialog = tester.widget<TDialog>(find.byType(TDialog));
      for (final action in dialog.actions.where(
        (action) => action.role == TDialogActionRole.normal,
      )) {
        expect(action.variant, isNull);
        expect(action.colorScheme, isNull);
      }
      final buttons = tester.widgetList<TButton>(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(TButton),
        ),
      );
      for (final button in buttons.where(
        (button) =>
            (button.child as Text).data != '确定' &&
            (button.child as Text).data != '警示操作' &&
            (button.child as Text).data != '主要按钮',
      )) {
        expect(button.variant, TButtonVariant.fill, reason: label);
        expect(button.colorScheme, TButtonColorScheme.light, reason: label);
      }
      await closeCurrentDialog(tester);
    }
  });

  testWidgets('确认类无标题和纯标题的右侧按钮使用品牌填充样式', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    for (final label in ['确认类-无标题', '确认类-纯标题']) {
      await openScenario(tester, label);
      final confirm = tester.widget<TButton>(
        find.widgetWithText(TButton, '确定'),
      );
      expect(confirm.variant, TButtonVariant.fill, reason: label);
      expect(confirm.colorScheme, TButtonColorScheme.primary, reason: label);
      await closeCurrentDialog(tester);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('输入类和组件用法使用贴边文字按钮', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    for (final label in ['输入类-无描述', '输入类-带描述', '命令行操作', '开放能力按钮']) {
      await openScenario(tester, label);
      final dialog = tester.widget<TDialog>(find.byType(TDialog));
      expect(
        dialog.actions.map((action) => action.variant),
        everyElement(TButtonVariant.text),
        reason: label,
      );
      await closeCurrentDialog(tester);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('长内容显示 4dp 滚动条且关闭图标距顶部和右侧均为 8dp', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await openScenario(tester, '反馈类-内容超长');
    final scrollbar = tester.widget<RawScrollbar>(
      find.descendant(
        of: find.byType(TDialog),
        matching: find.byType(RawScrollbar),
      ),
    );
    expect(scrollbar.thumbVisibility, isTrue);
    expect(scrollbar.thickness, 4);
    expect(scrollbar.radius, const Radius.circular(2));
    expect(scrollbar.crossAxisMargin, 16);
    final scrollView = tester.widget<SingleChildScrollView>(
      find.descendant(
        of: find.byType(TDialog),
        matching: find.byType(SingleChildScrollView),
      ),
    );
    expect(scrollView.controller!.position.maxScrollExtent, greaterThan(0));
    await closeCurrentDialog(tester);

    await openScenario(tester, '带关闭按钮的对话框');
    final dialogRect = tester.getRect(find.byType(TDialog));
    final closeIconRect = tester.getRect(find.byIcon(TIcons.close));
    expect(closeIconRect.top - dialogRect.top, 8);
    expect(dialogRect.right - closeIconRect.right, 8);
    expect(closeIconRect.size, const Size.square(24));
    expect(tester.takeException(), isNull);
  });

  testWidgets('垂直基础按钮通过 actionsWidget 对外可见', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await openScenario(tester, '垂直基础按钮');

    final confirm = tester.getCenter(find.text('确定'));
    final cancel = tester.getCenter(find.text('取消'));
    expect(confirm.dy, lessThan(cancel.dy));
    final cancelButton = tester.widget<TButton>(
      find.widgetWithText(TButton, '取消'),
    );
    expect(cancelButton.variant, TButtonVariant.fill);
    expect(cancelButton.colorScheme, TButtonColorScheme.light);
    expect(tester.takeException(), isNull);
  });
}
