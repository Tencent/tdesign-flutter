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

  testWidgets('BackTop real app scroll, tap and theme interaction', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    unawaited(navigator.pushNamed('backtop'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('backtop-page-light');

    const floatingKey = Key('backtop-demo-floating');
    expect(find.byKey(floatingKey).hitTestable(), findsNothing);
    final scrollable = find.byType(Scrollable).first;
    await tester.drag(scrollable, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.byKey(floatingKey).hitTestable(), findsOneWidget);
    await binding.takeScreenshot('backtop-visible-after-scroll');

    await tester.tap(find.byKey(floatingKey));
    await tester.pumpAndSettle();
    final position = tester.state<ScrollableState>(scrollable).position;
    expect(position.pixels, lessThan(1));
    expect(find.byKey(floatingKey).hitTestable(), findsNothing);

    final provider = tester
        .element(find.byType(TBackTop).first)
        .read<ThemeModeProvider>();
    final previousMode = provider.themeMode;
    provider.themeMode = ThemeMode.dark;
    await tester.pumpAndSettle();
    await binding.takeScreenshot('backtop-page-dark');
    expect(tester.takeException(), isNull);
    provider.themeMode = previousMode;
    await tester.pumpAndSettle();
  });
}
