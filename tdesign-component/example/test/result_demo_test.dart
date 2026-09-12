import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'result_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(resultDemoPageTestSpec);

  testWidgets('公开 Demo 展示完整状态、描述与自定义结果', (tester) async {
    await pumpFullDemoPage(tester, resultDemoPageTestSpec, ThemeMode.light);

    expect(find.text('02 单元测试'), findsNothing);
    expect(find.textContaining('未在示例稿中体现'), findsNothing);

    final results = tester.widgetList<TResult>(find.byType(TResult)).toList();
    expect(results, hasLength(9));
    expect(results.take(4).map((result) => result.status), [
      TResultStatus.success,
      TResultStatus.error,
      TResultStatus.warning,
      TResultStatus.info,
    ]);
    expect(
      results.take(4).every((result) => result.description == null),
      isTrue,
    );
    expect(
      results.skip(4).take(4).every((result) => result.description == '描述文字'),
      isTrue,
    );
    expect(results.last.icon, isA<Image>());
    expect(results.last.title, '自定义结果');
    final image = results.last.icon! as Image;
    expect(image.height, 80);
    expect(image.width, isNull);
  });

  testWidgets('页面示例可进入并通过返回按钮退出', (tester) async {
    await pumpFullDemoPage(tester, resultDemoPageTestSpec, ThemeMode.light);

    final entry = find.byKey(const Key('result-page-example'));
    await tester.ensureVisible(entry);
    final entryButton = tester.widget<TButton>(entry);
    expect(entryButton.size, TButtonSize.large);
    expect(entryButton.variant, TButtonVariant.outline);
    expect(entryButton.colorScheme, TButtonColorScheme.primary);
    final entryRect = tester.getRect(entry);
    expect(entryRect.left, 16);
    expect(entryRect.right, tester.view.physicalSize.width - 16);
    expect(entryRect.height, 48);
    await tester.tap(entry);
    await tester.pumpAndSettle();

    expect(find.byType(TNavBar), findsOneWidget);
    final back = find.byKey(const Key('result-page-back'));
    expect(back, findsOneWidget);
    final backButton = tester.widget<TButton>(back);
    expect(backButton.size, TButtonSize.large);
    expect(backButton.variant, TButtonVariant.outline);
    expect(backButton.colorScheme, TButtonColorScheme.primary);
    final result = tester.widget<TResult>(find.byType(TResult));
    expect(result.status, TResultStatus.success);
    expect(result.title, '成功状态');
    expect(result.description, '描述文字');

    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.byKey(const Key('result-page-example')), findsOneWidget);
  });
}
