import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/footer/footer_page.dart';

import '../demo_page_test_utils.dart';

const footerDemoSpec = DemoPageTestSpec(
  name: 'footer',
  title: 'Footer 页脚',
  page: TFooterPage(),
  expectedTexts: [
    '基础页脚',
    '基础加链接页脚',
    '品牌页脚',
    'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    '底部链接',
  ],
  componentType: TFooter,
  expectedComponentCount: 5,
  precacheAssetImages: ['assets/img/t_brand.png'],
  supplementalCjkFontFamily: 'TDesign Demo Review Golden CJK',
  supplementalCjkFontPath: 'test/fonts/DemoReviewGoldenCJK-Regular.otf',
);

void main() {
  registerDemoStructureTests(footerDemoSpec);

  testWidgets('公开实例顺序与组合数量符合设计稿', (tester) async {
    await pumpFullDemoPage(tester, footerDemoSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.single.title, '组件类型');
    expect(page.children.single.children.map((item) => item.desc), [
      '基础页脚',
      '基础加链接页脚',
      '品牌页脚',
    ]);
    final footers = tester.widgetList<TFooter>(find.byType(TFooter)).toList();
    expect(footers.where((footer) => footer.links.isNotEmpty), hasLength(2));
    final brandFooters = footers.where((footer) => footer.logo != null);
    expect(brandFooters, hasLength(2));
    expect(
      brandFooters.every(
        (footer) => (footer.logo! as TImage).shape == TImageShape.square,
      ),
      isTrue,
    );
  }, tags: 'demo');

  testWidgets('三个公开链接都可点击且不会重复通知', (tester) async {
    await pumpFullDemoPage(tester, footerDemoSpec, ThemeMode.light);
    final links = find.widgetWithText(TLink, '底部链接');
    expect(links, findsNWidgets(3));
    for (final link in links.evaluate()) {
      expect((link.widget as TLink).onPressed, isNotNull);
    }
  }, tags: 'demo');
}
