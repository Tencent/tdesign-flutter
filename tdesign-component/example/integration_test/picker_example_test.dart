import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/main.dart' as app;
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Picker real app selection and code panels', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    unawaited(navigator.pushNamed('picker?showAction=1'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('picker-page');
    for (final id in ['city', 'time', 'area', 'title', 'without-title']) {
      final trigger = find.byKey(ValueKey('picker-$id-trigger'));
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      final panel = find.byType(TPicker);
      if (id == 'area') {
        await binding.takeScreenshot('picker-area');
      }
      final initial = List<Object?>.of(tester.widget<TPicker>(panel).value);
      final wheel = find.byType(ListWheelScrollView).first;
      expect(tester.getSize(wheel).height, 200);
      expect(tester.widget<ListWheelScrollView>(wheel).itemExtent, 40);
      await tester.fling(wheel, const Offset(0, 80), 600);
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(tester.widget<TPicker>(panel).value, initial);
      await tester.fling(wheel, const Offset(0, 80), 600);
      await tester.pumpAndSettle();
      final draft = List<Object?>.of(tester.widget<TPicker>(panel).value);
      expect(draft, isNot(initial));
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(tester.widget<TPicker>(panel).value, draft);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
    }
    // Exercise the actual navigation-bar code action and all four code entries.
    final codeIcon = find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == TIcons.code,
    );
    await tester.tap(codeIcon);
    await tester.pumpAndSettle();
    for (var index = 0; index < 4; index++) {
      final entry = find.text('code').at(index);
      await tester.ensureVisible(entry);
      await tester.tap(entry);
      await tester.pumpAndSettle();
      if (index == 0) {
        await binding.takeScreenshot('picker-code');
        await tester.drag(find.byType(Markdown), const Offset(0, -650));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(Markdown), const Offset(0, -650));
        await tester.pumpAndSettle();
        await binding.takeScreenshot('picker-code-composition');
      }
      final markdown = tester.widget<Markdown>(find.byType(Markdown));
      expect(markdown.data, contains('TPopup.show'));
      expect(markdown.data, contains('StatefulBuilder'));
      expect(markdown.data, contains('return TCell('));
      expect(markdown.data, contains('onConfirm(List<Object?>.of(draft))'));
      navigator.pop();
      await tester.pumpAndSettle();
    }
    await tester.tap(codeIcon);
    await tester.pumpAndSettle();
    final trigger = find.byKey(const ValueKey('picker-area-trigger'));
    final provider = tester.element(trigger).read<ThemeModeProvider>();
    final previousMode = provider.themeMode;
    provider.themeMode = ThemeMode.dark;
    await tester.pumpAndSettle();
    await tester.ensureVisible(trigger);
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('picker-area-dark');
    expect(tester.getSize(find.byType(ListWheelScrollView).first).height, 200);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    provider.themeMode = previousMode;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
