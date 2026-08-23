import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_divider_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TDividerPage(),
      ),
    );
  }

  double widthOf(WidgetTester tester, Element element) {
    return tester.getSize(find.byWidget(element.widget)).width;
  }

  testWidgets('水平与虚线示例中的分割线共享页面内容宽度', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    final horizontalDividers = find.byWidgetPredicate(
      (widget) =>
          widget is TDivider && widget.layout != TDividerLayout.vertical,
    );
    expect(horizontalDividers, findsNWidgets(8));

    final widths = horizontalDividers
        .evaluate()
        .map((divider) => widthOf(tester, divider))
        .toSet();
    expect(widths, hasLength(1));
    expect(widths.single, greaterThan(0));
  });
}
