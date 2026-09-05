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

  testWidgets('Steps real app navigation, interaction and themes', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle();
    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );

    unawaited(navigator.pushNamed('steps'));
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('steps-light');

    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.byType(TSteps), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Vertical Customize Steps 垂直自定义步骤条'),
      600,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();

    var steps = tester.widgetList<TSteps>(find.byType(TSteps)).toList();
    final selectable = steps.firstWhere((item) => item.onChange != null);
    expect(selectable.value, 3);
    await tester.tap(find.text('已完成步骤').first);
    await tester.pumpAndSettle();
    steps = tester.widgetList<TSteps>(find.byType(TSteps)).toList();
    expect(steps.firstWhere((item) => item.onChange != null).value, 0);
    expect(
      steps
          .firstWhere((item) => item.variant == TStepsVariant.display)
          .onChange,
      isNull,
    );

    final provider = tester
        .element(find.byType(TSteps).first)
        .read<ThemeModeProvider>();
    provider.themeMode = ThemeMode.dark;
    await tester.pumpAndSettle();
    await binding.takeScreenshot('steps-dark');
    expect(tester.takeException(), isNull);
  });
}
