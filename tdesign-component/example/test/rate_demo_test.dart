import 'package:flutter/cupertino.dart' show CupertinoIcons;
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
    expect(rates, hasLength(14));
    expect(rates.map((rate) => rate.value), [
      3,
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
      false,
      true,
      false,
      false,
      true,
      false,
      false,
    ]);
    expect(rates[1].icon, isNotNull);
    expect((rates[2].icon!(true) as Icon).icon, CupertinoIcons.heart_fill);
    expect((rates[2].icon!(false) as Icon).icon, CupertinoIcons.heart);
    expect(rates[12].icon, isNotNull);
    expect(rates[4].texts, ['1分', '2分', '3分', '4分', '5分']);
    expect(rates[5].texts, ['极差', '失望', '一般', '满意', '惊喜']);
    expect(rates[6].texts, ['极差', '失望', '一般', '满意', '惊喜']);
    expect(find.text('3分'), findsOneWidget);
    expect(find.text('一般'), findsOneWidget);
    expect(find.text('未评分'), findsOneWidget);
    expect(find.text('评分风格'), findsOneWidget);
    expect(find.text('设置评分颜色'), findsNothing);
    expect(find.text('服务很棒'), findsOneWidget);
    expect(find.text('可以前往'), findsNothing);

    final largeSizeCell = find.ancestor(
      of: find.text('大尺寸 24'),
      matching: find.byType(TCell),
    );
    final smallSizeCell = find.ancestor(
      of: find.text('小尺寸 20'),
      matching: find.byType(TCell),
    );
    expect(
      tester.getTopLeft(smallSizeCell).dy -
          tester.getBottomLeft(largeSizeCell).dy,
      16,
    );

    final filledStyleCell = find.ancestor(
      of: find.text('填充评分'),
      matching: find.byType(TCell),
    );
    final outlinedStyleCell = find.ancestor(
      of: find.text('线描评分'),
      matching: find.byType(TCell),
    );
    expect(
      tester.getTopLeft(outlinedStyleCell).dy -
          tester.getBottomLeft(filledStyleCell).dy,
      16,
    );
    final outlinedRate = find.descendant(
      of: outlinedStyleCell,
      matching: find.byType(TRate),
    );
    final outlinedContext = tester.element(outlinedRate);
    final outlinedIcons = tester.widgetList<Icon>(
      find.descendant(
        of: outlinedStyleCell,
        matching: find.byIcon(TIcons.star_filled),
      ),
    );
    expect(outlinedIcons, isNotEmpty);
    expect(
      outlinedIcons.every(
        (icon) => icon.color == outlinedContext.tTheme.warningColor5,
      ),
      isTrue,
    );

    final verticalContainer = tester.widget<Container>(
      find.byKey(const ValueKey('rate-vertical-container')),
    );
    final verticalContext = tester.element(
      find.byKey(const ValueKey('rate-vertical-container')),
    );
    expect(verticalContainer.color, verticalContext.tTheme.bgColorContainer);
    expect(
      tester.widget<Text>(find.text('未评分')).style?.color,
      verticalContext.tTheme.textDisabledColor,
    );
    final describedTitles = find.text('带描述评分');
    expect(describedTitles, findsNWidgets(4));
    final describedTitleTops = [
      for (var index = 1; index < 4; index++)
        tester.getTopLeft(describedTitles.at(index)).dy,
    ];
    expect(describedTitleTops[1] - describedTitleTops[0], 64);
    expect(describedTitleTops[2] - describedTitleTops[1], 64);

    final firstRate = find.byType(TRate).first;
    final rect = tester.getRect(firstRate);
    await tester.tapAt(Offset(rect.right - 2, rect.center.dy));
    await tester.pump();
    rates = tester.widgetList<TRate>(find.byType(TRate)).toList();
    expect(rates.first.value, 5);

    final describedRate = find.byType(TRate).at(5);
    final describedRect = tester.getRect(describedRate);
    final gesture = await tester.startGesture(describedRect.center);
    await gesture.moveBy(const Offset(-20, 0));
    await tester.pump();
    await gesture.moveTo(
      Offset(describedRect.left - 48, describedRect.center.dy),
    );
    await gesture.up();
    await tester.pump();
    rates = tester.widgetList<TRate>(find.byType(TRate)).toList();
    expect(rates[5].value, 0);
    expect(find.text('未评分'), findsNWidgets(2));

    await disposeDemoPage(tester);
  }, tags: 'demo');
}
