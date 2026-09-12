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
  supplementalCjkFontFamily: 'TDesign Image Golden CJK',
  supplementalCjkFontPath: 'test/fonts/ImageGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/image.png'],
);

void main() {
  registerDemoStructureTests(imageDemoSpec);

  testWidgets('公开分组与十个实例符合设计稿', (tester) async {
    await pumpFullDemoPage(tester, imageDemoSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.map((module) => module.title), ['组件类型', '组件状态']);
    final images = tester.widgetList<TImage>(find.byType(TImage)).toList();
    expect(images.map((image) => image.fit).take(3), [
      BoxFit.cover,
      BoxFit.fitHeight,
      BoxFit.fill,
    ]);
    expect(
      [
        tester.getSize(find.byType(TImage).at(0)),
        tester.getSize(find.byType(TImage).at(1)),
        tester.getSize(find.byType(TImage).at(2)),
      ],
      const [Size(72, 72), Size(89, 72), Size(134, 72)],
    );
    expect(
      [
        tester.getTopLeft(find.byType(TImage).at(0)).dx,
        tester.getTopLeft(find.byType(TImage).at(1)).dx,
        tester.getTopLeft(find.byType(TImage).at(2)).dx,
      ],
      [16, 112, 225],
    );
    expect(
      [
        tester.getTopLeft(find.byType(TImage).at(3)).dx,
        tester.getTopLeft(find.byType(TImage).at(4)).dx,
        tester.getTopLeft(find.byType(TImage).at(5)).dx,
      ],
      [16, 112, 208],
    );
    expect(tester.getTopLeft(find.byType(TImage).at(6)).dx, 16);
    expect(images.map((image) => image.shape).skip(3).take(3), [
      TImageShape.square,
      TImageShape.roundedSquare,
      TImageShape.circle,
    ]);
    expect(
      images.skip(6).every((image) => image.shape == TImageShape.roundedSquare),
      isTrue,
    );
    expect(images[6].src, isNull);
    expect(images[7].src, isNull);
    expect(images[8].src, isEmpty);
    expect(images[9].src, isEmpty);
    expect(find.textContaining('单元测试'), findsNothing);
  }, tags: 'demo');
}
