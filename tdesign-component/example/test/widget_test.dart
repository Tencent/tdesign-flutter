import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/main.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  testWidgets('example home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('TDesign Flutter 组件库'), findsOneWidget);
    expect(find.text('Button 按钮'), findsOneWidget);
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
