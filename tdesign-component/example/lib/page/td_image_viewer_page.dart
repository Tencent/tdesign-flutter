import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDImageViewerPage extends StatefulWidget {
  const TDImageViewerPage({Key? key}) : super(key: key);

  @override
  State<TDImageViewerPage> createState() => _TDImageViewerPageState();
}

class _TDImageViewerPageState extends State<TDImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: const Color(0xFFF0F2F5),
      title: tdTitle(),
      desc: '用于图片内容的缩略展示与查看。',
      exampleCodeGroup: 'image_viewer',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础图片预览',
                builder: _basicImageViewer)
          ]
        ),
      ],
    );
  }
}

@Demo(group: 'image_viewer')
Widget _basicImageViewer(BuildContext context) {
  var images = ['https://tdesign.gtimg.com/mobile/demos/swiper1.png',
    'https://tdesign.gtimg.com/mobile/demos/swiper2.png',];
  return TDButton(
    type: TDButtonType.ghost,
    theme: TDButtonTheme.primary,
    isBlock: true,
    size: TDButtonSize.large,
    text: '基础图片预览',
    onTap: () {
      TDImageViewer.showImageViewer(context: context, images: images);
    },
  );
}