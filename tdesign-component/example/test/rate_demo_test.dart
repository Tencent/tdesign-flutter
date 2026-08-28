import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'rate_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(rateDemoPageTestSpec);

  testWidgets('Rate Demo exposes the complete instance contract', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, rateDemoPageTestSpec, ThemeMode.light);

    var rates = tester.widgetList<TRate>(find.byType(TRate)).toList();
    expect(rates, hasLength(13));
    expect(rates.map((rate) => rate.value), [
      3,
      3,
      2,
      3,
      3,
      0,
      3,
      3,
      3,
      3,
      3,
      3,
      4,
    ]);
    expect(rates.map((rate) => rate.count), [
      5,
      5,
      3,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
    ]);
    expect(rates.map((rate) => rate.allowHalf), [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true,
      false,
      false,
      true,
      false,
      false,
    ]);
    expect(rates[1].icon, isNotNull);
    expect(rates[11].icon, isNotNull);
    expect(rates[3].texts, ['1分', '2分', '3分', '4分', '5分']);
    expect(rates[4].texts, ['极差', '失望', '一般', '满意', '惊喜']);
    expect(rates[5].texts, isEmpty);

    final firstRate = find.byType(TRate).first;
    final rect = tester.getRect(firstRate);
    await tester.tapAt(Offset(rect.right - 2, rect.center.dy));
    await tester.pump();
    rates = tester.widgetList<TRate>(find.byType(TRate)).toList();
    expect(rates.first.value, 5);

    await disposeDemoPage(tester);
  }, tags: 'demo');
}
