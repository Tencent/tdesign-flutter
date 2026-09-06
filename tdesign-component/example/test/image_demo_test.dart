import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_image_page.dart';

import 'demo_page_test_utils.dart';

const imageDemoSpec = DemoPageTestSpec(
  name: 'image',
  title: 'Image',
  page: TImagePage(),
  expectedTexts: [
    '裁切',
    '适应高',
    '拉伸',
    '方形',
    '圆角方形',
    '圆形',
    '加载默认提示',
    '加载自定义提示',
    '失败默认提示',
    '失败自定义提示',
  ],
  componentType: TImage,
  expectedComponentCount: 10,
  precacheAssetImages: ['assets/img/image.png'],
);

void main() {
  registerDemoStructureTests(imageDemoSpec);

  testWidgets('公开分组与十个实例符合设计稿', (tester) async {
    await pumpFullDemoPage(tester, imageDemoSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.map((module) => module.title),
        ['01 组件类型', '02 组件状态']);
    final images = tester.widgetList<TImage>(find.byType(TImage)).toList();
    expect(images.map((image) => image.fit).take(3),
        [BoxFit.cover, BoxFit.fitHeight, BoxFit.fill]);
    expect(images.map((image) => image.shape).skip(3).take(3), [
      TImageShape.square,
      TImageShape.roundedSquare,
      TImageShape.circle,
    ]);
    expect(images.skip(6).every((image) => image.shape == TImageShape.roundedSquare),
        isTrue);
  }, tags: 'demo');
}
