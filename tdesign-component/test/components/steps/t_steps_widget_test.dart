import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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

RenderParagraph _slotParagraph(WidgetTester tester, String label) =>
    tester.renderObject<RenderParagraph>(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText() == label,
      ),
    );

Widget _slotContent(String label, String variant, String wrapper) {
  Widget child = variant == 'native'
      ? Text(label)
      : TText(
          label,
          style: variant == 'partial'
              ? const TextStyle(color: Colors.orange)
              : variant == 'explicit'
              ? const TextStyle(
                  fontSize: 19,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: Colors.pink,
                  letterSpacing: 1,
                  wordSpacing: 0,
                )
              : null,
          maxLines: variant == 'paragraph' ? 2 : null,
          overflow: variant == 'paragraph' ? TextOverflow.fade : null,
          softWrap: variant == 'paragraph' ? false : null,
        );
  if (variant == 'nativeExplicit') {
    child = Text(
      label,
      style: const TextStyle(
        fontSize: 19,
        height: 1.4,
        fontWeight: FontWeight.w500,
        color: Colors.pink,
        letterSpacing: 1,
        wordSpacing: 0,
      ),
    );
  }
  if (variant == 'nativeLocal') {
    child = DefaultTextStyle.merge(
      style: const TextStyle(
        fontSize: 21,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: Colors.purple,
      ),
      child: Text(label),
    );
  }
  if (variant == 'local') {
    final labelWidget = child;
    child = Builder(
      builder: (context) => Theme(
        data: Theme.of(context).mergeExtension(
          const TTextThemeData(
            textStyle: TextStyle(
              fontSize: 21,
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            ),
          ),
        ),
        child: labelWidget,
      ),
    );
  }
  return switch (wrapper) {
    'row' => Row(
      mainAxisSize: MainAxisSize.min,
      children: [Flexible(child: child)],
    ),
    'padding' => Padding(padding: const EdgeInsets.all(2), child: child),
    'builder' => Builder(builder: (_) => child),
    _ => child,
  };
}

void _expectSlotStyle(
  WidgetTester tester,
  String subject,
  String reference,
  String variant,
) {
  final paragraph = _slotParagraph(tester, subject);
  final actual = paragraph.text.style!;
  final base = _slotParagraph(tester, reference).text.style!;
  final override = switch (variant) {
    'partial' => const TextStyle(color: Colors.orange),
    'explicit' || 'nativeExplicit' => const TextStyle(
      fontSize: 19,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: Colors.pink,
      letterSpacing: 1,
      wordSpacing: 0,
    ),
    'local' || 'nativeLocal' => const TextStyle(
      fontSize: 21,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: Colors.purple,
    ),
    _ => const TextStyle(),
  };
  expect(actual.fontSize, override.fontSize ?? base.fontSize, reason: subject);
  expect(actual.height, override.height ?? base.height, reason: subject);
  expect(
    actual.fontWeight,
    override.fontWeight ?? base.fontWeight,
    reason: subject,
  );
  expect(actual.color, override.color ?? base.color, reason: subject);
  expect(
    actual.letterSpacing,
    override.letterSpacing ?? base.letterSpacing,
    reason: subject,
  );
  if (variant == 'paragraph') {
    expect(paragraph.maxLines, 2);
    expect(paragraph.overflow, TextOverflow.fade);
    expect(paragraph.softWrap, isFalse);
  }
}

Widget _slotHost(
  Widget child,
  bool dark,
  double scale, {
  TextStyle? outerStyle,
}) {
  final token = TThemeData.defaultData();
  var theme = dark ? TThemeBuilder.dark(token) : TThemeBuilder.light(token);
  if (outerStyle != null) {
    theme = theme.mergeExtension(TTextThemeData(textStyle: outerStyle));
  }
  return MaterialApp(
    theme: theme,
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 32, color: Colors.red),
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
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
                      : _slotContent('${prefix}title$i', variant, wrapper),
                  customContent: variant == null
                      ? null
                      : _slotContent('${prefix}body$i', variant, wrapper),
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
              _slotHost(
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
                _expectSlotStyle(
                  tester,
                  '${variant}title$i',
                  'reftitle$i',
                  variant,
                );
                _expectSlotStyle(
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
        _slotHost(
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
      final paragraph = _slotParagraph(tester, 'subject');
      expect(paragraph.text.style!.fontSize, 23);
      expect(paragraph.text.style!.color, Colors.teal);
      expect(paragraph.textScaler.scale(23), 46);
      expect(tester.takeException(), isNull);
    });
  }
}
