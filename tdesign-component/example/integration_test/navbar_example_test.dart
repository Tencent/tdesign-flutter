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

  testWidgets('Navbar real app navigation, actions, search and theme', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    unawaited(navigator.pushNamed('navbar'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('navbar-demo-base')), findsOneWidget);
    expect(
      find.byKey(const Key('navbar-demo-left-multi-action')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('navbar-demo-right-multi-action')),
      findsOneWidget,
    );
    await binding.takeScreenshot('navbar-types-light');

    final moreAction = find.descendant(
      of: find.byKey(const Key('navbar-demo-left-multi-action')),
      matching: find.byIcon(TIcons.ellipsis),
    );
    await tester.tap(moreAction);
    await tester.pump();
    expect(find.text('点击了更多'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));

    final searchBar = find.byKey(const Key('navbar-demo-search'));
    await tester.ensureVisible(searchBar);
    await tester.pumpAndSettle();
    final searchField = find.descendant(
      of: searchBar,
      matching: find.byType(EditableText),
    );
    await tester.enterText(searchField, 'Navbar');
    await tester.pump();
    expect(find.text('Navbar'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('navbar-search-light');

    final customHeight = find.byKey(const Key('navbar-demo-custom-height'));
    await tester.ensureVisible(customHeight);
    await tester.pumpAndSettle();
    expect(tester.getSize(customHeight).height, 80);
    await binding.takeScreenshot('navbar-styles-light');

    final provider = tester.element(customHeight).read<ThemeModeProvider>();
    final previousMode = provider.themeMode;
    provider.themeMode = ThemeMode.dark;
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('navbar-demo-custom-height')), findsOneWidget);
    await binding.takeScreenshot('navbar-styles-dark');
    provider.themeMode = previousMode;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
