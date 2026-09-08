import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/page/t_stepper_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'demo_page_test_utils.dart';
import 'stepper_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(stepperDemoPageTestSpec);

  testWidgets('Stepper Demo follows official scenario order', (tester) async {
    await pumpFullDemoPage(tester, stepperDemoPageTestSpec, ThemeMode.light);
    final keys = ['base', 'minimum', 'disabled', 'variants', 'sizes'];
    final tops = keys
        .map((id) => tester.getTopLeft(find.byKey(ValueKey('stepper-$id'))).dy)
        .toList();
    expect(tops, orderedEquals([...tops]..sort()));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('bounds and disabled state use the public contract', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, stepperDemoPageTestSpec, ThemeMode.light);
    final minimum = tester.widget<TStepper>(
      find.byKey(const ValueKey('stepper-minimum')),
    );
    final maximum = tester.widget<TStepper>(
      find.byKey(const ValueKey('stepper-maximum')),
    );
    final disabled = tester.widget<TStepper>(
      find.byKey(const ValueKey('stepper-disabled')),
    );
    expect(minimum.value, minimum.min);
    expect(maximum.value, maximum.max);
    expect(disabled.onChanged, isNull);
    expect(disabled.value, 0);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Stepper Demo values remain controlled', (tester) async {
    await pumpFullDemoPage(tester, stepperDemoPageTestSpec, ThemeMode.light);
    final stepper = find.byKey(const ValueKey('stepper-base'));
    expect(tester.widget<TStepper>(stepper).value, 3);
    await tester.tap(
      find.descendant(of: stepper, matching: find.bySemanticsLabel('增加')),
    );
    await tester.pump();
    expect(tester.widget<TStepper>(stepper).value, 4);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('all design instances, styles and container bounds match', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, stepperDemoPageTestSpec, ThemeMode.light);
    final steppers = tester
        .widgetList<TStepper>(find.byType(TStepper))
        .toList();
    expect(steppers.map((stepper) => stepper.value), [
      3,
      0,
      999,
      0,
      3,
      3,
      3,
      3,
      3,
      3,
    ]);
    expect(steppers.map((stepper) => stepper.variant), [
      TStepperVariant.filled,
      TStepperVariant.filled,
      TStepperVariant.filled,
      TStepperVariant.filled,
      TStepperVariant.filled,
      TStepperVariant.outline,
      TStepperVariant.normal,
      TStepperVariant.filled,
      TStepperVariant.filled,
      TStepperVariant.filled,
    ]);
    expect(
      steppers.skip(7).map((stepper) => stepper.size),
      TStepperSize.values.reversed,
    );
    for (final key in ['base', 'minimum', 'disabled', 'variants', 'sizes']) {
      final stepper = find.byKey(ValueKey('stepper-$key'));
      expect(tester.getTopLeft(stepper).dx, 16);
      final container = find
          .ancestor(of: stepper, matching: find.byType(ColoredBox))
          .first;
      expect(tester.getSize(container).width, 375);
      expect(
        tester.widget<ColoredBox>(container).color,
        Theme.of(
          tester.element(stepper),
        ).extension<TThemeData>()!.bgColorContainer,
      );
      expect(
        tester.getTopLeft(stepper).dy - tester.getTopLeft(container).dy,
        16,
      );
    }
    final minimum = find.byKey(const ValueKey('stepper-minimum'));
    final maximum = find.byKey(const ValueKey('stepper-maximum'));
    expect(tester.getTopLeft(maximum).dx - tester.getTopRight(minimum).dx, 32);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('theme rebuild preserves each example state', (tester) async {
    await pumpFullDemoPage(tester, stepperDemoPageTestSpec, ThemeMode.light);
    for (final key in ['base', 'minimum', 'variants', 'sizes']) {
      final stepper = find.byKey(ValueKey('stepper-$key'));
      await tester.tap(
        find.descendant(of: stepper, matching: find.bySemanticsLabel('增加')),
      );
      await tester.pump();
    }
    await pumpFullDemoPage(tester, stepperDemoPageTestSpec, ThemeMode.dark);
    for (final key in ['base', 'minimum', 'variants', 'sizes']) {
      expect(
        tester.widget<TStepper>(find.byKey(ValueKey('stepper-$key'))).value,
        key == 'minimum' ? 1 : 4,
      );
    }
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets(
    'all five real code panels load their complete generated example',
    (tester) async {
      tester.view.physicalSize = const Size(375, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final model = ExamplePageModel(
        text: 'Stepper 步进器',
        name: 'stepper',
        pageBuilder: (_, __) => const TStepperPage(),
      )..showAction = true;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeModeProvider(),
          child: MaterialApp(
            theme: TThemeBuilder.light(TThemeData.defaultData()),
            home: ExamplePageInheritedTheme(
              model: model,
              child: const TStepperPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final base = find.byKey(const ValueKey('stepper-base'));
      await tester.tap(
        find.descendant(of: base, matching: find.bySemanticsLabel('增加')),
      );
      await tester.pump();
      expect(tester.widget<TStepper>(base).value, 4);
      await tester.tap(find.byIcon(TIcons.code));
      await tester.pumpAndSettle();
      expect(find.text('code'), findsNWidgets(5));
      expect(tester.widget<TStepper>(base).value, 4);
      const names = [
        'StepperBaseExample',
        'StepperBoundsExample',
        'StepperDisabledExample',
        'StepperVariantsExample',
        'StepperSizesExample',
      ];
      for (var i = 0; i < names.length; i++) {
        await tester.tap(find.text('code').at(i));
        await tester.pumpAndSettle();
        final expected = await rootBundle.loadString(
          'assets/code/stepper.${names[i]}.txt',
        );
        final content = tester.widget<Markdown>(find.byType(Markdown)).data;
        expect(content, contains(expected));
        Navigator.of(tester.element(find.byType(Markdown))).pop();
        await tester.pumpAndSettle();
      }
      expect(tester.widget<TStepper>(base).value, 4);
      await disposeDemoPage(tester);
    },
    tags: 'demo',
  );
}
