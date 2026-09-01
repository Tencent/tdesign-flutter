import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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
}
