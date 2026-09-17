import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_toast_page.dart';

import '../demo_page_test_utils.dart';

class _ToastGoldenCase {
  const _ToastGoldenCase(
    this.id,
    this.triggerText,
    this.visibleText, {
    this.manual = false,
  });

  final String id;
  final String triggerText;
  final String visibleText;
  final bool manual;
}

void main() {
  const spec = DemoPageTestSpec(
    name: 'toast',
    title: 'Toast 轻提示',
    page: TToastPage(),
    expectedTexts: ['01 基础提示', '02 组件状态', '03 显示遮罩', '04 手动关闭'],
  );
  registerDemoPageTests(spec);

  const cases = [
    _ToastGoldenCase('text', '纯文本', '轻提示文字内容'),
    _ToastGoldenCase('multiple_text', '多行文字', '最多一行展示十个汉字宽度限制最多不超过三行文字'),
    _ToastGoldenCase('horizontal_icon', '带横向图标', '带横向图标'),
    _ToastGoldenCase('vertical_icon', '带竖向图标', '带竖向图标'),
    _ToastGoldenCase('loading', '加载状态', '加载中...'),
    _ToastGoldenCase('success', '成功提示', '成功文案'),
    _ToastGoldenCase('warning', '警告提示', '警告文案'),
    _ToastGoldenCase('fail', '错误提示', '错误文案'),
    _ToastGoldenCase('cover', '禁止滑动和点击', '禁止滑动和点击'),
    _ToastGoldenCase('manual', '显示提示', '轻提示文字内容', manual: true),
  ];

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final toastCase in cases) {
      testWidgets('toast ${toastCase.id} opened ${mode.name} golden', (
        tester,
      ) async {
        await pumpFullDemoPage(tester, spec, mode);
        final visibleText = find.text(toastCase.visibleText);
        final countBeforeOpen = visibleText.evaluate().length;
        await tester.tap(find.widgetWithText(TButton, toastCase.triggerText));
        await tester.pump();

        expect(visibleText, findsNWidgets(countBeforeOpen + 1));
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/toast_${toastCase.id}_opened_${mode.name}.png',
          ),
        );
        if (toastCase.manual) {
          await tester.tap(find.widgetWithText(TButton, '关闭提示'));
          await tester.pump();
        } else {
          await tester.pump(const Duration(seconds: 4));
        }
        expect(visibleText, findsNWidgets(countBeforeOpen));
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
