import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  final baseSteps = [
    TStepsItemData(title: '步骤一', content: '描述一'),
    TStepsItemData(title: '步骤二', content: '描述二'),
    TStepsItemData(title: '步骤三', content: '描述三'),
  ];

  group('TSteps widget 级用例', () {
    testWidgets('横向 success 可构建', (tester) async {
      await tester.pumpWidget(wrap(TSteps(
        steps: baseSteps,
        value: 1,
      )));
      expect(find.byType(TSteps), findsOneWidget);
      expect(find.text('步骤一'), findsOneWidget);
    });

    testWidgets('横向长标题和内容收口为单行省略', (tester) async {
      const longTitle = '这是一个非常非常非常长的步骤标题用于验证不会换行';
      const longContent = '这是一个非常非常非常长的步骤内容用于验证不会撑高布局';
      await tester.pumpWidget(wrap(TSteps(
        steps: [
          TStepsItemData(title: longTitle, content: longContent),
          TStepsItemData(title: '步骤二', content: '描述二'),
          TStepsItemData(title: '步骤三', content: '描述三'),
        ],
        value: 1,
      )));

      final title = tester.widget<Text>(find.text(longTitle));
      final content = tester.widget<Text>(find.text(longContent));
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(content.maxLines, 1);
      expect(content.overflow, TextOverflow.ellipsis);
    });

    testWidgets('纵向 / error / simple / readOnly / verticalSelect',
        (tester) async {
      await tester.pumpWidget(wrap(TSteps(
        steps: baseSteps,
        direction: TStepsDirection.vertical,
        status: TStepsStatus.error,
        simple: true,
        readOnly: true,
        verticalSelect: true,
        value: 2,
      )));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('customTitle / customContent 可构建', (tester) async {
      await tester.pumpWidget(wrap(TSteps(
        steps: [
          TStepsItemData(customTitle: const Text('自定义标题')),
          TStepsItemData(customContent: const Text('自定义内容')),
        ],
        value: 0,
      )));
      expect(find.text('自定义标题'), findsOneWidget);
      expect(find.text('自定义内容'), findsOneWidget);
    });

    testWidgets('value 越界被 clamp', (tester) async {
      await tester.pumpWidget(wrap(TSteps(
        steps: baseSteps,
        value: 99,
      )));
      expect(find.byType(TSteps), findsOneWidget);
    });
  });
}
