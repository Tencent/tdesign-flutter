import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/main.dart' as app;
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SideBar real app navigation, interaction and themes', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );

    unawaited(navigator.pushNamed('SideBarAnchor'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('sidebar-anchor-light');

    expect(tester.widget<TSideBar>(find.byType(TSideBar)).value, 1);
    await tester.tap(find.text('选项').at(2));
    await tester.pumpAndSettle();
    expect(tester.widget<TSideBar>(find.byType(TSideBar)).value, 2);

    final provider = tester
        .element(find.byType(TSideBar))
        .read<ThemeModeProvider>();
    provider.themeMode = ThemeMode.dark;
    await tester.pumpAndSettle();
    await binding.takeScreenshot('sidebar-anchor-dark');
    expect(tester.takeException(), isNull);

    navigator.pop();
    await tester.pumpAndSettle();
    unawaited(navigator.pushNamed('SideBarPagination'));
    await tester.pumpAndSettle();
    final beforeDisabledTap = tester
        .widget<TSideBar>(find.byType(TSideBar))
        .value;
    await tester.tap(find.text('选项').at(4));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TSideBar>(find.byType(TSideBar)).value,
      beforeDisabledTap,
    );

    navigator.pop();
    await tester.pumpAndSettle();
    unawaited(navigator.pushNamed('SideBarCustom'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TSideBar>(find.byType(TSideBar)).style,
      TSideBarVariant.tag,
    );
    await tester.tap(find.text('选项').at(3));
    await tester.pumpAndSettle();
    expect(tester.widget<TSideBar>(find.byType(TSideBar)).value, 3);
    expect(tester.takeException(), isNull);
  });
}
