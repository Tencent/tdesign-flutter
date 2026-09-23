import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_activity_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';

import '../demo_page_test_utils.dart';
import 'loading_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(loadingDemoPageTestSpec);

  testWidgets('loading 公开场景与契约双向一致', (tester) async {
    await pumpFullDemoPage(tester, loadingDemoPageTestSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    final actual = [
      for (final module in page.children)
        for (final item in module.children) '${module.title}/${item.desc}',
    ];
    final expected = loadingDemoScenarios
        .map((scenario) => '${scenario.group}/${scenario.label}')
        .toList();
    expect(actual, expected);
    expect(
      loadingDemoScenarios.map((scenario) => scenario.id).toSet(),
      hasLength(loadingDemoScenarios.length),
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('loading Demo renders custom image and updates speed label', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, loadingDemoPageTestSpec, ThemeMode.light);

    final customImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/img/loading-logo2.png',
    );
    expect(customImage, findsOneWidget);

    final activityIndicators = tester.widgetList<TCupertinoActivityIndicator>(
      find.byType(TCupertinoActivityIndicator),
    );
    expect(activityIndicators, hasLength(3));
    expect(
      activityIndicators.map((indicator) => indicator.activeColor),
      everyElement(TThemeData.defaultData().textColorPrimary),
    );

    final sliderFinder = find.byType(TSlider);
    expect(tester.widget<TSlider>(sliderFinder).value, 800);
    await tester.drag(find.byType(Slider), const Offset(80, 0));
    await tester.pump();

    final value = tester.widget<TSlider>(sliderFinder).value.round();
    expect(value, greaterThan(800));
    expect(find.text('$value'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
