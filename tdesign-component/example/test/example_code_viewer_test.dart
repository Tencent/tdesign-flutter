import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_code_viewer.dart';
import 'package:tdesign_flutter_example/config.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Future<void> finishLoading(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
  }

  testWidgets('所有公开分组的代码资源均已打包且非空', (tester) async {
    await tester.runAsync(() async {
      final manifest =
          jsonDecode(await rootBundle.loadString('assets/code/manifest.json'))
              as Map<String, dynamic>;
      final groups = manifest['groups'] as Map<String, dynamic>;
      expect(groups.length, greaterThanOrEqualTo(60));
      var count = 0;
      for (final modules in groups.values) {
        for (final module in modules as List<dynamic>) {
          for (final item in module['items'] as List<dynamic>) {
            final key = item['assetKey'];
            final code = await rootBundle.loadString('assets/code/$key.txt');
            expect(code.trim(), isNotEmpty, reason: '$key');
            count++;
          }
        }
      }
      expect(count, greaterThanOrEqualTo(370));
    });
  });

  for (final page in [
    (
      name: 'fab',
      entries: <String, String>{
        '纯图标悬浮按钮': 'class FabIconOnlyExample',
        '图标加文字悬浮按钮': 'class FabIconTextExample',
        '可移动悬浮按钮': 'class FabDraggableExample',
        '带自动收缩功能': 'class FabCollapsibleExample',
      },
    ),
    (
      name: 'imageViewer',
      entries: <String, String>{
        '带操作图片预览': 'class ImageViewerWithActionsExample',
      },
    ),
  ]) {
    testWidgets('${page.name} 工具栏直接选择并展示示例代码', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final model = exampleMap.values
          .expand((items) => items)
          .singleWhere((model) => model.name == page.name);
      model.showAction = true;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeModeProvider(),
          child: MaterialApp(
            theme: TThemeBuilder.light(TThemeData.defaultData()),
            home: Builder(
              builder: (context) => model.pageBuilder(context, model),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final entry in page.entries.entries) {
        await tester.tap(find.byIcon(TIcons.code));
        await finishLoading(tester);
        expect(find.text('选择示例代码'), findsOneWidget);
        final option = find.descendant(
          of: find.byType(BottomSheet),
          matching: find.text(entry.key),
        );
        await tester.ensureVisible(option);
        await tester.tap(option);
        await finishLoading(tester);
        final panel = find.byType(Markdown);
        expect(panel, findsOneWidget);
        expect(tester.widget<Markdown>(panel).data, contains(entry.value));
        Navigator.of(tester.element(panel)).pop();
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('缺失分组与代码资源明确提示而不抛出异常', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Column(
              children: [
                TextButton(
                  onPressed: () =>
                      ExampleCodeViewer.showExamples(context, 'missing'),
                  child: const Text('group'),
                ),
                TextButton(
                  onPressed: () =>
                      ExampleCodeViewer.showAsset(context, 'missing.txt'),
                  child: const Text('asset'),
                ),
              ],
            );
          },
        ),
      ),
    );
    for (final label in ['group', 'asset']) {
      await tester.tap(find.text(label));
      await finishLoading(tester);
      final message = find.text('暂无演示代码');
      expect(message, findsOneWidget);
      Navigator.of(tester.element(message)).pop();
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });
}
