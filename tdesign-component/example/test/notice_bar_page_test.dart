import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_notice_bar_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TNoticeBarPage(),
      ),
    );
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('官方类型与状态 Demo 均为公开入口', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    const labels = ['垂直滚动的公告栏', '自定义内容的公告栏', '普通通知', '成功通知', '警示通知', '错误通知'];
    for (final label in labels) {
      final finder = find.text(label);
      await tester.scrollUntilVisible(
        finder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(finder, findsOneWidget);
    }

    expect(find.text('卡片顶部'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('垂直滚动与自定义内容使用现有公开 API', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final verticalLabel = find.text('垂直滚动的公告栏');
    await tester.scrollUntilVisible(
      verticalLabel,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is TNoticeBar && widget.direction == Axis.vertical,
      ),
      findsOneWidget,
    );

    final customLabel = find.text('自定义内容的公告栏');
    await tester.scrollUntilVisible(
      customLabel,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final customNotice = tester.widget<TNoticeBar>(
      find.ancestor(of: find.text('文本'), matching: find.byType(TNoticeBar)),
    );
    expect(customNotice.left, isA<TButton>());
    expect(customNotice.suffixIcon, TIcons.chevron_right);
    expect(tester.takeException(), isNull);
  });
}
