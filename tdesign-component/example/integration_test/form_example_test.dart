import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Form design states on a real device', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    unawaited(navigator.pushNamed('form?showAction=1'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    final gender = find.byKey(const ValueKey('form-gender-options'));
    expect(tester.widget<TRadioGroup<String>>(gender).value, 'man');
    expect(find.text('Abcdefgh'), findsOneWidget);
    expect(find.text('2022-08-10'), findsOneWidget);
    expect(find.text('广东省 深圳市'), findsOneWidget);
    expect(tester.widget<TRate>(find.byType(TRate)).value, 3.5);

    await binding.takeScreenshot('form-horizontal-top');
    final submit = find.byKey(const ValueKey('form-submit-button'));
    final page = find.byType(CustomScrollView);
    await tester.dragUntilVisible(submit, page, const Offset(0, -400));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('form-horizontal-bottom');

    final vertical = find.byKey(const ValueKey('form-layout-vertical'));
    await tester.dragUntilVisible(vertical, page, const Offset(0, 400));
    await tester.pumpAndSettle();
    await tester.tap(vertical);
    await tester.pumpAndSettle();
    final scrollables = find.descendant(
      of: page,
      matching: find.byType(Scrollable),
    );
    final pageScrollable = tester
        .stateList<ScrollableState>(scrollables)
        .reduce(
          (current, next) =>
              current.position.maxScrollExtent > next.position.maxScrollExtent
              ? current
              : next,
        );
    pageScrollable.position.jumpTo(0);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('form-vertical-top');
    await tester.dragUntilVisible(submit, page, const Offset(0, -400));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('form-vertical-bottom');

    final disabled = find.byKey(const ValueKey('form-disabled-switch'));
    await tester.dragUntilVisible(disabled, page, const Offset(0, 400));
    await tester.pumpAndSettle();
    await tester.tap(disabled);
    await tester.pumpAndSettle();
    pageScrollable.position.jumpTo(0);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('form-vertical-disabled-top');
    expect(tester.takeException(), isNull);
  });
}
