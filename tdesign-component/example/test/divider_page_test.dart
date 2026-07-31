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

  testWidgets('带文字与虚线示例中的分割线共享父级宽度', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    for (final key in const [
      Key('divider-text-group'),
      Key('divider-dashed-group'),
    ]) {
      final group = find.byKey(key);
      final groupWidth = tester.getSize(group).width;
      final dividers = find.descendant(
        of: group,
        matching: find.byType(TDivider),
      );

      expect(dividers, findsWidgets);
      for (final divider in dividers.evaluate()) {
        expect(widthOf(tester, divider), groupWidth);
      }
    }
  });
}
