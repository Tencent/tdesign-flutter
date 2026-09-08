import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';

import 'demo_page_test_utils.dart';
import 'steps_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(stepsDemoPageTestSpec);

  testWidgets('Steps 公开 Demo 的类型、状态与交互契约对齐', (tester) async {
    await pumpFullDemoPage(tester, stepsDemoPageTestSpec, ThemeMode.light);

    final steps = tester.widgetList<TSteps>(find.byType(TSteps)).toList();
    expect(steps, hasLength(12));
    expect(steps[0].direction, TStepsDirection.horizontal);
    expect(steps[2].variant, TStepsVariant.dot);
    expect(steps[4].steps.every((item) => item.icon != null), isTrue);
    expect(steps[6].steps[1].customContent, isNotNull);
    expect(
      steps.sublist(7, 10).every((item) => item.status == TStepsStatus.error),
      isTrue,
    );

    expect(steps[10].direction, TStepsDirection.vertical);
    expect(steps[10].variant, TStepsVariant.dot);
    expect(steps[10].onChange, isNotNull);
    expect(steps[10].value, 3);
    expect(steps[11].variant, TStepsVariant.display);
    expect(steps[11].onChange, isNull);

    final selectable = find.byType(TSteps).at(10);
    await tester.tap(
      find.descendant(of: selectable, matching: find.text('已完成步骤')).first,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<TSteps>(find.byType(TSteps).at(10)).value, 0);
    expect(find.text('选择了步骤 1'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  });

  testWidgets('Steps 所有代码入口展示对应的实际生成片段', (tester) async {
    await pumpFullDemoPage(tester, stepsDemoPageTestSpec, ThemeMode.light);
    const names = [
      '_buildHorizontalDefault',
      '_buildHorizontalIcon',
      '_buildHorizontalDot',
      '_buildVerticalDefault',
      '_buildVerticalIcon',
      '_buildVerticalDot',
      '_buildCustomContent',
      '_buildErrorStates',
      '_buildVerticalSelectable',
      '_buildDisplaySteps',
    ];
    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    expect(find.byType(CodeWrapper), findsNWidgets(names.length));
    for (var index = 0; index < names.length; index++) {
      final name = names[index];
      final source = await rootBundle.loadString('assets/code/steps.$name.txt');
      final wrapper = find.byType(CodeWrapper).at(index);
      await tester.tap(
        find.descendant(of: wrapper, matching: find.text('code')),
      );
      await tester.pumpAndSettle();
      final panel = find.byType(Markdown);
      expect(tester.widget<Markdown>(panel).data, contains(source));
      Navigator.of(tester.element(panel)).pop();
      await tester.pumpAndSettle();
    }

    await disposeDemoPage(tester);
  });
}
