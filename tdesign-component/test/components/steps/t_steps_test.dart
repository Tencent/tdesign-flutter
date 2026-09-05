import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_horizontal_item.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_vertical_item.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  List<TStepsItemData> buildSteps(int count) {
    return List.generate(
      count,
      (index) =>
          TStepsItemData(title: '步骤${index + 1}', content: '内容${index + 1}'),
    );
  }

  group('TStepsItemData', () {
    test('文本、图标与自定义内容构造', () {
      const customTitle = Text('自定义标题');
      const customContent = Text('自定义内容');
      const data = TStepsItemData(
        title: '标题',
        content: '内容',
        icon: Icons.shopping_cart,
        errorIcon: Icons.close,
        customTitle: customTitle,
        customContent: customContent,
      );

      expect(data.title, '标题');
      expect(data.content, '内容');
      expect(data.icon, Icons.shopping_cart);
      expect(data.errorIcon, Icons.close);
      expect(data.customTitle, customTitle);
      expect(data.customContent, customContent);
    });

    test('至少需要一个非空值', () {
      expect(TStepsItemData.new, throwsA(isA<AssertionError>()));
    });
  });

  group('公开枚举', () {
    test('方向、形态和状态语义固定', () {
      expect(TStepsDirection.values, [
        TStepsDirection.horizontal,
        TStepsDirection.vertical,
      ]);
      expect(TStepsVariant.values, [
        TStepsVariant.defaultTheme,
        TStepsVariant.dot,
        TStepsVariant.display,
      ]);
      expect(TStepsStatus.values, [TStepsStatus.process, TStepsStatus.error]);
    });
  });

  group('TSteps 渲染与状态', () {
    testWidgets('水平与垂直方向渲染', (tester) async {
      await tester.pumpWidget(wrap(TSteps(steps: buildSteps(3))));
      expect(find.byType(TStepsHorizontalItem), findsNWidgets(3));

      await tester.pumpWidget(
        wrap(TSteps(steps: buildSteps(3), direction: TStepsDirection.vertical)),
      );
      expect(find.byType(TStepsVerticalItem), findsNWidgets(3));
    });

    testWidgets('value 更新同步当前步骤并收敛越界值', (tester) async {
      await tester.pumpWidget(wrap(TSteps(steps: buildSteps(3), value: -1)));
      expect(
        tester
            .widget<TStepsHorizontalItem>(
              find.byType(TStepsHorizontalItem).first,
            )
            .activeIndex,
        0,
      );

      await tester.pumpWidget(wrap(TSteps(steps: buildSteps(3), value: 9)));
      expect(
        tester
            .widget<TStepsHorizontalItem>(
              find.byType(TStepsHorizontalItem).first,
            )
            .activeIndex,
        2,
      );
    });

    testWidgets('空数据安全渲染', (tester) async {
      await tester.pumpWidget(wrap(const TSteps(steps: [])));
      expect(find.byType(TSteps), findsOneWidget);
      expect(find.byType(TStepsHorizontalItem), findsNothing);
    });

    testWidgets('process、error、dot 与 display 透传给 item', (tester) async {
      await tester.pumpWidget(
        wrap(
          TSteps(
            steps: buildSteps(2),
            status: TStepsStatus.error,
            variant: TStepsVariant.dot,
          ),
        ),
      );
      var item = tester.widget<TStepsHorizontalItem>(
        find.byType(TStepsHorizontalItem).first,
      );
      expect(item.status, TStepsStatus.error);
      expect(item.variant, TStepsVariant.dot);

      await tester.pumpWidget(
        wrap(
          TSteps(
            steps: buildSteps(2),
            direction: TStepsDirection.vertical,
            variant: TStepsVariant.display,
          ),
        ),
      );
      final verticalItem = tester.widget<TStepsVerticalItem>(
        find.byType(TStepsVerticalItem).first,
      );
      expect(verticalItem.status, TStepsStatus.process);
      expect(verticalItem.variant, TStepsVariant.display);
    });

    testWidgets('图标、错误图标和自定义区域可渲染', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TSteps(
            steps: [
              TStepsItemData(icon: Icons.shopping_cart, title: '图标'),
              TStepsItemData(
                errorIcon: Icons.cancel,
                customTitle: Text('自定义标题'),
                customContent: Text('自定义内容'),
              ),
            ],
            value: 1,
            status: TStepsStatus.error,
            direction: TStepsDirection.vertical,
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.text('自定义标题'), findsOneWidget);
      expect(find.text('自定义内容'), findsOneWidget);
    });
  });

  group('受控交互', () {
    testWidgets('水平点击只通知父级且不自行改变 value', (tester) async {
      int? selected;
      await tester.pumpWidget(
        wrap(
          TSteps(steps: buildSteps(3), onChange: (value) => selected = value),
        ),
      );

      await tester.tap(find.text('步骤2'));
      expect(selected, 1);
      expect(
        tester
            .widget<TStepsHorizontalItem>(
              find.byType(TStepsHorizontalItem).first,
            )
            .activeIndex,
        0,
      );
    });

    testWidgets('无 onChange 时步骤不可点击', (tester) async {
      await tester.pumpWidget(wrap(TSteps(steps: buildSteps(2))));
      expect(
        tester
            .widget<TStepsHorizontalItem>(
              find.byType(TStepsHorizontalItem).first,
            )
            .onTap,
        isNull,
      );
    });

    testWidgets('垂直 onChange 同时提供选择与箭头语义', (tester) async {
      int? selected;
      await tester.pumpWidget(
        wrap(
          TSteps(
            steps: buildSteps(3),
            direction: TStepsDirection.vertical,
            variant: TStepsVariant.dot,
            onChange: (value) => selected = value,
          ),
        ),
      );

      final firstItem = tester.widget<TStepsVerticalItem>(
        find.byType(TStepsVerticalItem).first,
      );
      expect(firstItem.selectable, isTrue);
      await tester.tap(find.text('步骤3'));
      expect(selected, 2);
    });
  });
}
