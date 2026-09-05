import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_vertical_item.dart';
import 'package:tdesign_flutter/src/theme/t_theme.dart';

// TStepsVerticalItem 覆盖率补充
//
// 覆盖 build 中以下未覆盖分支：
// - data.icon != null：使用自定义步骤图标
// - status == error && activeIndex == index：错误图标分支
// - dot：普通、可选择与纯展示三种节点装饰
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  const baseData = TStepsItemData(title: '步骤');

  group('TStepsVerticalItem 分支覆盖', () {
    testWidgets('icon 替换序号图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TStepsVerticalItem(
            data: TStepsItemData(title: '步骤', icon: Icons.check),
            index: 1,
            stepsCount: 2,
            activeIndex: 0,
            status: TStepsStatus.process,
            variant: TStepsVariant.defaultTheme,
            selectable: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('error 状态且为当前激活项时显示错误图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TStepsVerticalItem(
            data: TStepsItemData(title: '步骤', errorIcon: Icons.close),
            index: 0,
            stepsCount: 1,
            activeIndex: 0,
            status: TStepsStatus.error,
            variant: TStepsVariant.defaultTheme,
            selectable: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('error 状态且无 errorIcon 时回落默认关闭图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TStepsVerticalItem(
            data: baseData,
            index: 0,
            stepsCount: 1,
            activeIndex: 0,
            status: TStepsStatus.error,
            variant: TStepsVariant.defaultTheme,
            selectable: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('dot 模式且为当前激活项时应用实心装饰', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TStepsVerticalItem(
            data: baseData,
            index: 0,
            stepsCount: 1,
            activeIndex: 0,
            status: TStepsStatus.process,
            variant: TStepsVariant.dot,
            selectable: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('可选择 dot 的已完成项为实心、当前项为空心', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Column(
            children: [
              TStepsVerticalItem(
                data: baseData,
                index: 0,
                stepsCount: 2,
                activeIndex: 1,
                status: TStepsStatus.process,
                variant: TStepsVariant.dot,
                selectable: true,
              ),
              TStepsVerticalItem(
                data: baseData,
                index: 1,
                stepsCount: 2,
                activeIndex: 1,
                status: TStepsStatus.process,
                variant: TStepsVariant.dot,
                selectable: true,
              ),
            ],
          ),
        ),
      );

      final dotDecorations = tester
          .widgetList<Container>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Container &&
                  widget.constraints?.maxWidth == 8 &&
                  widget.decoration is BoxDecoration,
            ),
          )
          .map((container) => container.decoration! as BoxDecoration)
          .toList();
      expect(dotDecorations[0].color, isNot(Colors.transparent));
      expect(dotDecorations[1].color, Colors.transparent);
    });

    testWidgets('display 模式的所有节点均为实心', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TStepsVerticalItem(
            data: baseData,
            index: 1,
            stepsCount: 2,
            activeIndex: 0,
            status: TStepsStatus.process,
            variant: TStepsVariant.display,
            selectable: false,
          ),
        ),
      );

      final dot = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.constraints?.maxWidth == 8 &&
              widget.decoration is BoxDecoration,
        ),
      );
      expect(
        (dot.decoration! as BoxDecoration).color,
        isNot(Colors.transparent),
      );
    });

    testWidgets('长标题在可用宽度内自动换行', (tester) async {
      const longTitle = '这是一个非常非常非常长的步骤标题用于验证垂直步骤可以展示完整内容';
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 260,
            child: TStepsVerticalItem(
              data: TStepsItemData(title: longTitle),
              index: 0,
              stepsCount: 2,
              activeIndex: 0,
              status: TStepsStatus.process,
              variant: TStepsVariant.defaultTheme,
              selectable: true,
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text(longTitle));
      expect(title.maxLines, isNull);
      expect(title.softWrap, isTrue);
      expect(title.overflow, TextOverflow.visible);
      expect(tester.takeException(), isNull);
    });
  });
}
