import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_navbar_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const MediaQuery(
          data: MediaQueryData(
            size: Size(375, 812),
            padding: EdgeInsets.only(top: 24),
          ),
          child: TNavBarPage(),
        ),
      ),
    );
  }

  testWidgets('Navbar Demo 内嵌示例不重复占用顶部安全区', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const Key('navbar-demo-base'))).height,
      48,
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('navbar-demo-custom-height')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester.getSize(find.byKey(const Key('navbar-demo-custom-height'))).height,
      80,
    );
  });
}
