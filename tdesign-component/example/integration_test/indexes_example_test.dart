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

  Finder indexSemantics(String label, {bool? selected}) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.label == label &&
          (selected == null || widget.properties.selected == selected),
    );
  }

  testWidgets('Indexes real app navigation and touch interaction', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    unawaited(navigator.pushNamed('indexes'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('indexes-page');

    final letterTrigger = find.byKey(const ValueKey('indexes-letter-trigger'));
    await tester.ensureVisible(letterTrigger);
    await tester.tap(letterTrigger);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('indexes-letter-panel')), findsOneWidget);
    expect(tester.widget<TIndexes>(find.byType(TIndexes)).initialIndex, 'B');
    expect(indexSemantics('B', selected: true), findsOneWidget);
    expect(find.text('北京'), findsOneWidget);
    await binding.takeScreenshot('indexes-letter-initial-b');

    await tester.tap(indexSemantics('G'));
    await tester.pumpAndSettle();
    expect(indexSemantics('G', selected: true), findsOneWidget);
    expect(find.text('广州'), findsOneWidget);
    await binding.takeScreenshot('indexes-letter-selected-g');

    navigator.pop();
    await tester.pumpAndSettle();
    final numberTrigger = find.byKey(const ValueKey('indexes-number-trigger'));
    await tester.ensureVisible(numberTrigger);
    await tester.tap(numberTrigger);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('indexes-number-panel')), findsOneWidget);
    expect(tester.widget<TIndexes>(find.byType(TIndexes)).capsuleTheme, isFalse);
    await tester.tap(indexSemantics('10'));
    await tester.pumpAndSettle();
    expect(indexSemantics('10', selected: true), findsOneWidget);
    await binding.takeScreenshot('indexes-number-selected-10');

    navigator.pop();
    await tester.pumpAndSettle();
    final capsuleTrigger = find.byKey(
      const ValueKey('indexes-capsule-trigger'),
    );
    await tester.ensureVisible(capsuleTrigger);
    await tester.tap(capsuleTrigger);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('indexes-capsule-panel')), findsOneWidget);
    expect(tester.widget<TIndexes>(find.byType(TIndexes)).capsuleTheme, isTrue);
    expect(indexSemantics('10'), findsOneWidget);
    await tester.tap(indexSemantics('10'));
    await tester.pumpAndSettle();
    expect(indexSemantics('10', selected: true), findsOneWidget);
    await binding.takeScreenshot('indexes-capsule-selected-10');

    navigator.pop();
    await tester.pumpAndSettle();
    final provider = tester.element(capsuleTrigger).read<ThemeModeProvider>();
    final previousMode = provider.themeMode;
    provider.themeMode = ThemeMode.dark;
    await tester.pumpAndSettle();
    await tester.tap(capsuleTrigger);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('indexes-capsule-dark');
    expect(tester.takeException(), isNull);
    navigator.pop();
    provider.themeMode = previousMode;
    await tester.pumpAndSettle();
  });
}
