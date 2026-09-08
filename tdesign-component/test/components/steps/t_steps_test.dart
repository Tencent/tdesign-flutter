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

  testWidgets('横纵文字继承显式主题，局部字号不改写状态颜色', (tester) async {
    final token = TThemeData.defaultData();
    for (final direction in TStepsDirection.values) {
      for (final materialTheme in [false, true]) {
        final theme = TThemeBuilder.light(token);
        await tester.pumpWidget(
          MaterialApp(
            theme: materialTheme
                ? theme.copyWith(
                    textTheme: const TextTheme(
                      bodyLarge: TextStyle(fontSize: 21),
                    ),
                  )
                : theme.mergeExtension(
                    const TTextThemeData(textStyle: TextStyle(fontSize: 21)),
                  ),
            home: Scaffold(
              body: TSteps(
                direction: direction,
                steps: buildSteps(3),
                value: 1,
                status: TStepsStatus.error,
              ),
            ),
          ),
        );
        expect(tester.widget<Text>(find.text('步骤1')).style?.fontSize, 21);
        expect(tester.widget<Text>(find.text('步骤2')).style?.fontSize, 21);
        expect(
          tester.widget<Text>(find.text('步骤1')).style?.color,
          token.textColorPrimary,
        );
        expect(
          tester.widget<Text>(find.text('步骤2')).style?.color,
          token.errorNormalColor,
        );
        expect(
          tester.widget<Text>(find.text('步骤3')).style?.color,
          token.textColorPlaceholder,
        );
        expect(tester.widget<Text>(find.text('内容1')).style?.fontSize, 21);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('显式文字颜色生效且 customTitle 保持实例优先', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(
          const TTextThemeData(textStyle: TextStyle(color: Colors.purple)),
        ),
        home: const Scaffold(
          body: TSteps(
            steps: [
              TStepsItemData(title: '普通标题'),
              TStepsItemData(
                customTitle: TText('自定义标题', textColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.widget<Text>(find.text('普通标题')).style?.color, Colors.purple);
    expect(tester.widget<Text>(find.text('自定义标题')).style?.color, Colors.orange);
  });

  testWidgets('垂直可选择步骤的自定义标题与纯内容项保留右箭头', (tester) async {
    int? selected;
    await tester.pumpWidget(
      wrap(
        TSteps(
          direction: TStepsDirection.vertical,
          steps: const [
            TStepsItemData(customTitle: Text('自定义标题')),
            TStepsItemData(content: '仅内容'),
          ],
          onChange: (value) => selected = value,
        ),
      ),
    );

    expect(find.byIcon(TIcons.chevron_right), findsNWidgets(2));
    await tester.tap(find.text('自定义标题'));
    expect(selected, 0);
  });

  testWidgets('display 横纵节点都为实心且不受 value/status 影响', (tester) async {
    for (final direction in TStepsDirection.values) {
      await tester.pumpWidget(
        wrap(
          TSteps(
            direction: direction,
            variant: TStepsVariant.display,
            status: TStepsStatus.error,
            value: 1,
            steps: buildSteps(3),
          ),
        ),
      );
      final dots = tester
          .widgetList<Container>(find.byType(Container))
          .where(
            (item) =>
                item.decoration is BoxDecoration &&
                (item.decoration! as BoxDecoration).shape == BoxShape.circle,
          )
          .toList();
      expect(dots, hasLength(3));
      for (final dot in dots) {
        final decoration = dot.decoration! as BoxDecoration;
        expect(decoration.color, TThemeData.defaultData().brandNormalColor);
        expect(decoration.border, isNull);
      }
    }
  });

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
        TStepsVariant.standard,
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
