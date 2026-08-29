import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_popover_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TPopoverPage(showInternalExamples: true),
      ),
    );
  }

  void configurePhone(WidgetTester tester, {Size size = const Size(375, 812)}) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
  }

  Future<void> showPage(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('事件回调和自定义内容展示真实状态变化', (tester) async {
    configurePhone(tester);
    await showPage(tester);

    final eventTrigger = find.byKey(const Key('popover-event-trigger'));
    await reveal(tester, eventTrigger);
    await tester.tap(eventTrigger);
    await tester.pumpAndSettle();
    await tester.tap(find.text('点击或长按我'));
    await tester.pump();
    expect(find.text('onTap：点击或长按我'), findsOneWidget);

    await tester.longPress(find.text('点击或长按我'));
    await tester.pump();
    expect(find.text('onLongTap：点击或长按我'), findsOneWidget);

    await tester.tapAt(const Offset(8, 80));
    await tester.pumpAndSettle();
    final menuTrigger = find.byKey(const Key('popover-interactive-trigger'));
    await reveal(tester, menuTrigger);
    await tester.tap(menuTrigger);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('popover-menu-复制')));
    await tester.pump();
    expect(find.text('已选择复制'), findsOneWidget);
  });

  testWidgets('主题背景与尺寸约束在 Demo 中可观察', (tester) async {
    configurePhone(tester);
    await showPage(tester);

    final trigger = find.byKey(const Key('popover-theme-short-trigger'));
    await reveal(tester, trigger);
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    final containerFinder = find
        .descendant(
          of: find.byType(TPopoverWidget),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container && widget.decoration is BoxDecoration,
          ),
        )
        .first;
    final container = tester.widget<Container>(containerFinder);
    expect(
      (container.decoration! as BoxDecoration).color,
      const Color(0xFF5E3BB7),
    );
    final size = tester.getSize(containerFinder);
    expect(size.width, greaterThanOrEqualTo(120));
    expect(size.width, lessThanOrEqualTo(180));
    expect(size.height, lessThan(120));
  });

  testWidgets('窄屏右下角和键盘场景保持在可用视口内', (tester) async {
    configurePhone(tester, size: const Size(320, 640));
    await showPage(tester);

    final boundaryTrigger = find.byKey(const Key('popover-boundary-右下'));
    await reveal(tester, boundaryTrigger);
    await tester.tap(boundaryTrigger);
    await tester.pumpAndSettle();
    var rect = tester.getRect(find.text('右下边界内容'));
    expect(rect.left, greaterThanOrEqualTo(0));
    expect(rect.right, lessThanOrEqualTo(320));
    expect(rect.bottom, lessThanOrEqualTo(640));

    await tester.tapAt(const Offset(8, 80));
    await tester.pumpAndSettle();
    final input = find.byKey(const Key('popover-keyboard-input'));
    await reveal(tester, input);
    await tester.tap(input);
    tester.view.viewInsets = const FakeViewPadding(bottom: 240);
    tester.binding.handleMetricsChanged();
    await tester.pumpAndSettle();

    final keyboardTrigger = find.byKey(const Key('popover-keyboard-trigger'));
    await reveal(tester, keyboardTrigger);
    await tester.tap(keyboardTrigger);
    await tester.pumpAndSettle();
    rect = tester.getRect(find.text('键盘弹出时保持在可用区域'));
    expect(rect.bottom, lessThanOrEqualTo(400));
  });

  testWidgets('移除 Demo 锚点后展示 Future 完成状态', (tester) async {
    configurePhone(tester);
    await showPage(tester);

    final anchor = find.byKey(const Key('popover-lifecycle-anchor'));
    await reveal(tester, anchor);
    await tester.tap(anchor);
    await tester.pump();
    expect(find.text('移除锚点后自动关闭'), findsOneWidget);

    await tester.tap(find.byKey(const Key('popover-lifecycle-toggle')));
    await tester.pump();
    await tester.pump();

    expect(find.text('移除锚点后自动关闭'), findsNothing);
    expect(find.text('Future 已完成，Overlay 已清理'), findsOneWidget);
  });
}
