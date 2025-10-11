import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

final List<TDActionSheetItem> actionSheetItems = [
  TDActionSheetItem(label: '保存图片', icon: const Icon(TDIcons.save)),
  TDActionSheetItem(label: '删除图片', icon: const Icon(TDIcons.delete)),
];

final List<String> images = [
  'https://tdesign.gtimg.com/mobile/demos/swiper1.png',
  'https://tdesign.gtimg.com/mobile/demos/swiper2.png',
];

class TDImageViewerPage extends StatefulWidget {
  const TDImageViewerPage({Key? key}) : super(key: key);

  @override
  State<TDImageViewerPage> createState() => _TDImageViewerPageState();
}

class _TDImageViewerPageState extends State<TDImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于图片内容的缩略展示与查看。',
      exampleCodeGroup: 'image_viewer',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '基础图片预览', builder: _basicImageViewer),
          ExampleItem(desc: '带操作图片预览', builder: _actionImageViewer)
        ]),
      ],
      test: [
        ExampleItem(desc: '长按图片', builder: _longPressImageViewer),
        ExampleItem(desc: '图片超宽情况', builder: _ultraWidthImageViewer),
        ExampleItem(desc: '图片超高情况', builder: _ultraHeightImageViewer),
        ExampleItem(desc: '带图片标题', builder: _descImageViewer),
      ],
    );
  }

  @Demo(group: 'image_viewer')
  Widget _basicImageViewer(BuildContext context) {
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

  @Demo(group: 'image_viewer')
  Widget _actionImageViewer(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '带操作图片预览',
      onTap: () {
        TDImageViewer.showImageViewer(
          context: context,
          images: images,
          showIndex: true,
          deleteBtn: true,
        );
      },
    );
  }

  @Demo(group: 'image_viewer')
  Widget _longPressImageViewer(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '长按图片',
      onTap: () {
        TDImageViewer.showImageViewer(
          context: context,
          images: images,
          deleteBtn: true,
          showIndex: true,
          onLongPress: (index) {
            TDActionSheet(
              context,
              visible: true,
              items: actionSheetItems,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'image_viewer')
  Widget _ultraWidthImageViewer(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '图片超宽情况',
      onTap: () {
        TDImageViewer.showImageViewer(
          context: context,
          images: images,
          showIndex: true,
          height: 140,
          onLongPress: (index) {
            TDActionSheet(
              context,
              visible: true,
              items: actionSheetItems,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'image_viewer')
  Widget _ultraHeightImageViewer(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '图片超高情况',
      onTap: () {
        TDImageViewer.showImageViewer(
          context: context,
          images: images,
          showIndex: true,
          width: 180,
          onLongPress: (index) {
            TDActionSheet(
              context,
              visible: true,
              items: actionSheetItems,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'image_viewer')
  Widget _descImageViewer(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '带图片标题',
      onTap: () {
        TDImageViewer.showImageViewer(
          context: context,
          images: images,
          labels: ['图片标题1', '图片标题2'],
        );
      },
    );
  }
}
