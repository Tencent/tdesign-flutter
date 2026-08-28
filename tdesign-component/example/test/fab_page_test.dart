import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_fab_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TFabPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('通栏按钮切换单个悬浮按钮场景', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    TextStyle renderedButtonTextStyle(String label) {
      final richText = tester
          .widgetList<RichText>(
            find.descendant(
              of: find.widgetWithText(TButton, label),
              matching: find.byType(RichText),
            ),
          )
          .firstWhere((widget) => widget.text.toPlainText() == label);
      return richText.text.style!;
    }

    final labels = ['纯图标悬浮按钮', '图标加文字悬浮按钮', '可移动悬浮按钮', '带自动收缩功能'];
    final firstStyle = renderedButtonTextStyle(labels.first);
    for (final label in labels.skip(1)) {
      final style = renderedButtonTextStyle(label);
      expect(style.fontSize, firstStyle.fontSize);
      expect(style.height, firstStyle.height);
      expect(style.fontWeight, firstStyle.fontWeight);
    }

    expect(find.byType(TFab), findsOneWidget);
    expect(tester.widget<TFab>(find.byType(TFab)).text, isEmpty);

    await tester.tap(find.widgetWithText(TButton, '图标加文字悬浮按钮'));
    await tester.pump();

    expect(find.byType(TFab), findsOneWidget);
    expect(tester.widget<TFab>(find.byType(TFab)).text, '分享给朋友');
    expect(tester.takeException(), isNull);
  });

  testWidgets('自动收缩在滚动结束后再展开且布局不溢出', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await tester.tap(find.widgetWithText(TButton, '带自动收缩功能'));
    await tester.pump();
    final fab = find.byType(TFab);
    final expandedIcon = find.descendant(
      of: fab,
      matching: find.byIcon(TIcons.add_circle),
    );
    final collapsedIcon = find.descendant(
      of: fab,
      matching: find.byIcon(TIcons.chevron_left),
    );
    expect(expandedIcon, findsOneWidget);
    expect(tester.takeException(), isNull);

    final scrollable = find.byType(CustomScrollView);
    final gesture = await tester.startGesture(tester.getCenter(scrollable));
    await gesture.moveBy(const Offset(0, -120));
    await tester.pump();

    expect(collapsedIcon, findsOneWidget);
    await tester.pump(const Duration(milliseconds: 200));
    expect(collapsedIcon, findsOneWidget);

    await gesture.up();
    await tester.pump(const Duration(milliseconds: 99));
    expect(collapsedIcon, findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    expect(expandedIcon, findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
