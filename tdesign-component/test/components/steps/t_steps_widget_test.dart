import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/custom_text_slot_test_helpers.dart';
import '../../helpers/text_slot_regression.dart';

void main() {
  for (final direction in TStepsDirection.values) {
    registerNativeParagraphContractTests(
      'Steps custom title $direction',
      (child) => TSteps.progress(
        direction: direction,
        steps: [TStepsItemData(title: 'fallback', customTitle: child)],
        value: 0,
      ),
      reset: false,
    );
    registerNativeParagraphContractTests(
      'Steps custom description $direction',
      (child) => TSteps.progress(
        direction: direction,
        steps: [TStepsItemData(title: 'title', customContent: child)],
        value: 0,
      ),
      reset: false,
    );
  }
  _textSlotRegression();
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  final baseSteps = [
    const TStepsItemData(title: '步骤一', content: '描述一'),
    const TStepsItemData(title: '步骤二', content: '描述二'),
    const TStepsItemData(title: '步骤三', content: '描述三'),
  ];

  group('TSteps widget 级用例', () {
    testWidgets('横向 process 可构建', (tester) async {
      await tester.pumpWidget(
        wrap(TSteps.progress(steps: baseSteps, value: 1)),
      );
      expect(find.byType(TSteps), findsOneWidget);
      expect(find.text('步骤一'), findsOneWidget);
    });

    testWidgets('横向标题和说明使用各自的字体行高', (tester) async {
      await tester.pumpWidget(
        wrap(TSteps.progress(steps: baseSteps, value: 1)),
      );

      final title = tester.widget<Text>(find.text('步骤二'));
      final description = tester.widget<Text>(find.text('描述二'));
      expect(title.style?.fontSize, 14);
      expect(title.style?.height, closeTo(22 / 14, 0.0001));
      expect(description.style?.fontSize, 12);
      expect(description.style?.height, closeTo(20 / 12, 0.0001));
    });

    testWidgets('横向说明跟随自定义 bodySmall 行高 Token', (tester) async {
      final token = TThemeData.defaultData().copyWith(
        name: 'steps-custom-line-height',
        fontMetricMap: {'lineHeightBodySmall': 24},
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Scaffold(body: TSteps.progress(steps: baseSteps, value: 1)),
        ),
      );

      final description = tester.widget<Text>(find.text('描述二'));
      expect(description.style?.fontSize, 12);
      expect(description.style?.height, closeTo(24 / 12, 0.0001));
    });

    testWidgets('横向长标题和内容收口为单行省略', (tester) async {
      const longTitle = '这是一个非常非常非常长的步骤标题用于验证不会换行';
      const longContent = '这是一个非常非常非常长的步骤内容用于验证不会撑高布局';
      await tester.pumpWidget(
        wrap(
          const TSteps.progress(
            steps: [
              TStepsItemData(title: longTitle, content: longContent),
              TStepsItemData(title: '步骤二', content: '描述二'),
              TStepsItemData(title: '步骤三', content: '描述三'),
            ],
            value: 1,
          ),
        ),
      );

      final title = tester.widget<Text>(find.text(longTitle));
      final content = tester.widget<Text>(find.text(longContent));
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(content.maxLines, 1);
      expect(content.overflow, TextOverflow.ellipsis);
    });

    testWidgets('纵向 error dot 可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          TSteps.progress(
            steps: baseSteps,
            direction: TStepsDirection.vertical,
            status: TStepsStatus.error,
            indicator: TStepsIndicator.dot,
            value: 2,
          ),
        ),
      );
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('customTitle / customContent 可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TSteps.progress(
            steps: [
              TStepsItemData(customTitle: Text('自定义标题')),
              TStepsItemData(customContent: Text('自定义内容')),
            ],
            value: 0,
          ),
        ),
      );
      expect(find.text('自定义标题'), findsOneWidget);
      expect(find.text('自定义内容'), findsOneWidget);
    });

    testWidgets('value 越界被 clamp', (tester) async {
      await tester.pumpWidget(
        wrap(TSteps.progress(steps: baseSteps, value: 99)),
      );
      expect(find.byType(TSteps), findsOneWidget);
    });
  });
}

void _textSlotRegression() {
  for (final dark in [false, true]) {
    for (final direction in TStepsDirection.values) {
      for (final mode in ['process', 'error', 'display', 'selectable']) {
        if (mode == 'selectable' && direction == TStepsDirection.horizontal) {
          continue;
        }
        for (final wrapper in ['direct', 'row', 'padding', 'builder']) {
          testWidgets('slot steps $direction $mode $wrapper dark=$dark', (
            tester,
          ) async {
            Widget steps(String prefix, String? variant) {
              final items = List.generate(
                3,
                (i) => TStepsItemData(
                  title: '${prefix}title$i',
                  content: '${prefix}body$i',
                  customTitle: variant == null
                      ? null
                      : slotContent('${prefix}title$i', variant, wrapper),
                  customContent: variant == null
                      ? null
                      : slotContent('${prefix}body$i', variant, wrapper),
                ),
              );
              final child = switch (mode) {
                'display' => TSteps.display(steps: items, direction: direction),
                'selectable' => TSteps.selectable(
                  steps: items,
                  value: 1,
                  onChange: (_) {},
                ),
                _ => TSteps.progress(
                  steps: items,
                  direction: direction,
                  value: 1,
                  status: mode == 'error'
                      ? TStepsStatus.error
                      : TStepsStatus.process,
                ),
              };
              return SizedBox(width: 760, child: child);
            }

            await tester.pumpWidget(
              slotHost(
                Column(
                  children: [
                    steps('ref', null),
                    for (final variant in [
                      'default',
                      'native',
                      'nativeLocal',
                      'nativeExplicit',
                      'partial',
                      'explicit',
                      'local',
                      'paragraph',
                    ])
                      steps(variant, variant),
                  ],
                ),
                dark,
                1,
              ),
            );
            for (final variant in [
              'default',
              'native',
              'nativeLocal',
              'nativeExplicit',
              'partial',
              'explicit',
              'local',
              'paragraph',
            ]) {
              for (var i = 0; i < 3; i++) {
                expectSlotStyle(
                  tester,
                  '${variant}title$i',
                  'reftitle$i',
                  variant,
                );
                expectSlotStyle(
                  tester,
                  '${variant}body$i',
                  'refbody$i',
                  variant,
                );
              }
            }
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  }
  for (final direction in TStepsDirection.values) {
    testWidgets('slot steps shared theme and text scaling $direction', (
      tester,
    ) async {
      await tester.pumpWidget(
        slotHost(
          TSteps.progress(
            direction: direction,
            steps: const [
              TStepsItemData(
                customTitle: TText('subject'),
                customContent: TText('body'),
              ),
            ],
            value: 0,
          ),
          false,
          2,
          outerStyle: const TextStyle(fontSize: 23, color: Colors.teal),
        ),
      );
      final paragraph = slotParagraph(tester, 'subject');
      expect(paragraph.text.style!.fontSize, 23);
      expect(paragraph.text.style!.color, Colors.teal);
      expect(paragraph.textScaler.scale(23), 46);
      expect(tester.takeException(), isNull);
    });
  }
}
