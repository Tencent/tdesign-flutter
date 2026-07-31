import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/main.dart';
import 'package:tdesign_flutter_example/page/t_calendar_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  testWidgets('example home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('TDesign Flutter 组件库'), findsOneWidget);
    expect(find.text('Button 按钮'), findsOneWidget);
  });

  testWidgets('示例页面和模块标题使用 headline 层级', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(token),
        home: ExamplePage(
          title: '页面标题',
          desc: '页面说明',
          exampleCodeGroup: 'test',
          children: const [
            ExampleModule(
              title: '模块标题',
              children: [
                ExampleItem(
                  ignoreCode: true,
                  builder: _emptyExample,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
    await tester.pump();

    final pageTitle = tester.widget<TText>(
      find.byWidgetPredicate(
        (widget) => widget is TText && widget.data == '页面标题',
      ),
    );
    final moduleTitle = tester.widget<TText>(
      find.byWidgetPredicate(
        (widget) => widget is TText && widget.data == '01 模块标题',
      ),
    );
    expect(pageTitle.style?.fontSize, token.fontHeadlineMedium?.size);
    expect(moduleTitle.style?.fontSize, token.fontHeadlineSmall?.size);
  });

  testWidgets('Calendar 页面提供底部 Popup 组合入口', (tester) async {
    setTResourceBuilder(
      (_) => null,
      needAlwaysBuild: false,
    );
    addTearDown(
      () => setTResourceBuilder((_) => null, needAlwaysBuild: false),
    );
    final model = ExamplePageModel(
      text: 'Calendar 日历',
      name: 'calendar',
      pageBuilder: (_, __) => const TCalendarPage(),
    );
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: ExamplePageInheritedTheme(
          model: model,
          child: const TCalendarPage(),
        ),
      ),
    ));
    await tester.pump();

    final pageScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.physics is BouncingScrollPhysics,
    );
    expect(pageScrollable, findsOneWidget);
    final pageScrollState = tester.state<ScrollableState>(pageScrollable);
    for (var offset = 0.0;
        offset <= pageScrollState.position.maxScrollExtent &&
            find.text('单选日期').evaluate().isEmpty;
        offset += 300) {
      pageScrollState.position.jumpTo(offset);
      await tester.pump();
    }
    expect(find.text('单选日期'), findsOneWidget);
    await tester.tap(find.text('单选日期'));
    await tester.pumpAndSettle();

    expect(find.text('选择日期'), findsOneWidget);
    expect(find.byType(TCalendar), findsWidgets);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
  });

  testWidgets('键盘收起后恢复输入框聚焦前的滚动位置', (tester) async {
    final controller = ScrollController();
    var inputBuildCount = 0;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(controller.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: ExamplePage(
          title: 'Keyboard test',
          exampleCodeGroup: 'test',
          scrollController: controller,
          children: [
            ExampleModule(
              title: 'Input',
              children: [
                ExampleItem(
                  ignoreCode: true,
                  center: false,
                  builder: (_) {
                    inputBuildCount++;
                    return const TInput(hintText: 'Input');
                  },
                ),
              ],
            ),
            ExampleModule(
              title: 'Content',
              children: List.generate(
                12,
                (index) => ExampleItem(
                  ignoreCode: true,
                  center: false,
                  builder: (_) => const SizedBox(height: 120),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final buildCountBeforeKeyboard = inputBuildCount;

    controller.jumpTo(120);
    await tester.pump();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    expect(inputBuildCount, buildCountBeforeKeyboard);

    controller.jumpTo(400);
    await tester.pump();
    tester.view.viewInsets = const FakeViewPadding(bottom: 150);
    expect(controller.offset, closeTo(260, 0.5));
    await tester.pump();
    expect(controller.offset, closeTo(260, 0.5));

    tester.view.resetViewInsets();
    expect(controller.offset, closeTo(120, 0.5));
    await tester.pump();

    expect(controller.offset, closeTo(120, 0.5));

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();
    controller.jumpTo(400);
    await tester.pump();
    tester.view.resetViewInsets();
    expect(controller.offset, closeTo(120, 0.5));
    await tester.pump();

    expect(controller.offset, closeTo(120, 0.5));
  });
}

Widget _emptyExample(BuildContext context) => const SizedBox(height: 1);
