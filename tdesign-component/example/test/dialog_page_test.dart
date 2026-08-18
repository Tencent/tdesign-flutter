import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dialog_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
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
    for (var attempt = 0; attempt < 5; attempt++) {
      final rect = tester.getRect(finder);
      if (rect.top >= 0 && rect.bottom <= tester.view.physicalSize.height - 80) {
        break;
      }
      await tester.drag(
        find.byType(Scrollable).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();
    }
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('官方 Dialog Demo 矩阵公开展示全部场景', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    const labels = [
      '反馈类-带标题',
      '反馈类-无标题',
      '反馈类-纯标题',
      '反馈类-内容超长',
      '确认类-带标题',
      '确认类-无标题',
      '确认类-纯标题',
      '文字按钮',
      '水平基础按钮',
      '垂直基础按钮',
      '多按钮',
      '带关闭按钮的对话框',
      '图片置顶-带标题描述',
      '图片置顶-无标题',
      '图片置顶-纯标题',
      '图片置顶-纯图片',
      '图片居中-带标题描述',
      '图片居中-纯标题',
      '输入类-无描述',
      '输入类-带描述',
      '命令行操作',
    ];
    for (final label in labels) {
      await tester.scrollUntilVisible(
        find.text(label),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.widgetWithText(TButton, label), findsOneWidget);
    }
  });

  testWidgets('图片置顶场景使用现有 content Widget 表达', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await openScenario(tester, '图片置顶-带标题描述');

    final dialog = tester.widget<TDialog>(find.byType(TDialog));
    expect(dialog.contentPadding, EdgeInsets.zero);
    expect(
      find.descendant(
        of: find.byType(TDialog),
        matching: find.byType(Image),
      ),
      findsOneWidget,
    );
    expect(find.text('对话框标题'), findsOneWidget);
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
    expect(tester.takeException(), isNull);
  });
}
