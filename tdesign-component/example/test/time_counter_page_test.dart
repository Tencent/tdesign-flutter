import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'time_counter_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(timeCounterDemoPageTestSpec);

  testWidgets('公开 Demo 使用十一条目标场景和准确配置', (tester) async {
    await pumpFullDemoPage(
      tester,
      timeCounterDemoPageTestSpec,
      ThemeMode.light,
    );

    final counters = tester
        .widgetList<TTimeCounter>(find.byType(TTimeCounter))
        .toList();
    expect(counters, hasLength(21));
    expect(counters.every((counter) => counter.time == 96 * 60 * 1000), isTrue);
    expect(counters[1].format, 'HH:mm:ss:SSS');
    expect(counters[1].showMillisecond, isTrue);
    expect(counters[4].variant, TTimeCounterVariant.round);
    expect(counters[4].splitWithUnit, isTrue);
    expect(counters[5].content, isNotNull);

    for (var group = 0; group < 5; group++) {
      final offset = 6 + group * 3;
      expect(counters[offset].size, TTimeCounterSize.small);
      expect(counters[offset + 1].size, isNull);
      expect(counters[offset + 2].size, TTimeCounterSize.large);
    }
    expect(
      counters
          .sublist(12, 18)
          .every(
            (counter) =>
                counter.variant == TTimeCounterVariant.square ||
                counter.variant == TTimeCounterVariant.round,
          ),
      isTrue,
    );
    expect(
      counters
          .sublist(18)
          .every(
            (counter) =>
                counter.variant == TTimeCounterVariant.round &&
                counter.splitWithUnit == true,
          ),
      isTrue,
    );
  });

  testWidgets('公开倒计时真实跨秒更新且无底色单位保持自定义层级', (tester) async {
    await pumpFullDemoPage(
      tester,
      timeCounterDemoPageTestSpec,
      ThemeMode.light,
    );
    final first = find.byType(TTimeCounter).first;
    expect(
      find.descendant(of: first, matching: find.text('36')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('00')),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 1));
    expect(
      find.descendant(of: first, matching: find.text('35')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('59')),
      findsOneWidget,
    );

    final custom = find.byType(TTimeCounter).at(5);
    expect(
      find.descendant(of: custom, matching: find.text('时')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: custom, matching: find.text('分')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: custom, matching: find.text('秒')),
      findsOneWidget,
    );
  });

  testWidgets('十一条查看代码资产均来自当前实现且依赖完整', (tester) async {
    const files = [
      'timeCounter._buildSimple.txt',
      'timeCounter._buildMillisecondSimple.txt',
      'timeCounter._buildSquareSimple.txt',
      'timeCounter._buildRoundSimple.txt',
      'timeCounter._buildUnitSimple.txt',
      'timeCounter._buildCustomUnitSimple.txt',
      'timeCounter._buildDefaultSizes.txt',
      'timeCounter._buildMillisecondSizes.txt',
      'timeCounter._buildSquareSizes.txt',
      'timeCounter._buildRoundSizes.txt',
      'timeCounter._buildUnitSizes.txt',
    ];
    for (final file in files) {
      final source = await rootBundle.loadString('assets/code/$file');
      expect(source, contains('TTimeCounter'));
      expect(source, contains('96 * 60 * 1000'));
      expect(source, isNot(contains('_demoTime')));
      expect(source, isNot(contains('_sizeColumn')));
    }
  });
}
