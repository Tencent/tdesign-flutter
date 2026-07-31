import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: Center(child: child)),
    );
  }

  List<TTab> tabs() => const [
        TTab(text: '标签一'),
        TTab(text: '标签二'),
        TTab(text: '标签三'),
      ];

  testWidgets('TTabsBar current API smoke rendering for visual baseline',
      (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      DefaultTabController(
        length: 3,
        child: TTabsBar(
          tabs: tabs(),
          variant: TTabsBarVariant.card,
          indicator: const TTabsBarIndicator(indicatorColor: Colors.blue),
        ),
      ),
    ));

    expect(find.byType(TTabsBar), findsOneWidget);
    expect(find.text('标签一'), findsOneWidget);
  });
}
