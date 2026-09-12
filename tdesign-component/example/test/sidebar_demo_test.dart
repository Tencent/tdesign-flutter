import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';

import 'demo_page_test_utils.dart';
import 'sidebar_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(sidebarDemoPageTestSpec);
  registerDemoStructureTests(sidebarAnchorDemoTestSpec);
  registerDemoStructureTests(sidebarTagDemoTestSpec);

  testWidgets('主页面跳转按钮沿用紧凑 Demo 的水平边距', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      sidebarDemoPageTestSpec,
      ThemeMode.light,
    );

    for (final label in const ['锚点用法', '切页用法', '带图标侧边导航', '自定义样式']) {
      final button = find.widgetWithText(TButton, label);
      await tester.ensureVisible(button);
      final rect = tester.getRect(button);
      expect(rect.left, closeTo(16, 1), reason: label);
      expect(rect.right, closeTo(359, 1), reason: label);
    }
  });

  testWidgets('图标侧边导航的代码入口展示真实组件实现', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      sidebarDemoPageTestSpec,
      ThemeMode.light,
    );

    final trigger = find.widgetWithText(TButton, '带图标侧边导航');
    await tester.ensureVisible(trigger);
    final wrapper = find.ancestor(
      of: trigger,
      matching: find.byType(CodeWrapper),
    );
    expect(wrapper, findsOneWidget);

    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: wrapper, matching: find.text('code')));
    await tester.pumpAndSettle();

    final panel = find.byType(Markdown);
    expect(panel, findsOneWidget);
    expect(tester.widget<Markdown>(panel).data, contains('TIcons.app'));
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(panel)).pop();
    await tester.pumpAndSettle();
    await disposeDemoPage(tester);
  });

  testWidgets('代码资源缺失时弹出提示而不抛出异常', (tester) async {
    final model = ExamplePageModel(
      text: '代码资源测试',
      name: 'missing_code',
      pageBuilder: (_, __) => const SizedBox(),
    )..codePath = 'missing';
    model.apiVisible = true;

    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: ExamplePageInheritedTheme(
          model: model,
          child: const CodeWrapper(
            builder: _buildMissingCodeDemo,
            methodName: '_missingExampleCode',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('code'));
    await tester.pumpAndSettle();

    expect(find.text('暂无演示代码'), findsOneWidget);
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(find.text('暂无演示代码'))).pop();
    await tester.pumpAndSettle();
  });
}

Widget _buildMissingCodeDemo(BuildContext context) {
  return const SizedBox(width: 300, height: 200);
}
