import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_empty_page.dart';

import 'demo_page_test_utils.dart';

const emptyDemoSpec = DemoPageTestSpec(
  name: 'empty',
  title: 'Empty',
  page: TEmptyPage(),
  expectedTexts: ['图标空状态', '自定义图片空状态', '带操作空状态', '描述文字', '操作按钮'],
  componentType: TEmpty,
  expectedComponentCount: 3,
  precacheAssetImages: ['assets/img/empty.png'],
);

void main() {
  registerDemoStructureTests(emptyDemoSpec);

  testWidgets('公开实例顺序与内容组合符合设计稿', (tester) async {
    await pumpFullDemoPage(tester, emptyDemoSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.single.title, '01 类型');
    expect(page.children.single.children.map((item) => item.desc),
        ['图标空状态', '自定义图片空状态', '带操作空状态']);
    final empties = tester.widgetList<TEmpty>(find.byType(TEmpty)).toList();
    expect(empties[0].image, isNull);
    expect(empties[1].image, isNotNull);
    expect(empties[1].emptyText, '描述文字');
    expect(empties[2].operation, isA<TButton>());
  }, tags: 'demo');
}
