import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDPreviewPage extends StatefulWidget {
  const TDPreviewPage({Key? key}) : super(key: key);

  @override
  State<TDPreviewPage> createState() => _TDPreviewPageState();
}

class _TDPreviewPageState extends State<TDPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: const Color(0xFFF0F2F5),
      title: tdTitle(),
      desc: '用于图片内容的缩略展示与查看。',
      exampleCodeGroup: 'image_viewer',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '基础图片预览', builder: _basicPreview),
          ExampleItem(desc: '带操作图片预览', builder: _actionPreview)
        ]),
      ],
      test: [
        ExampleItem(desc: '长按图片', builder: _longPressPreview),
        ExampleItem(desc: '图片超宽情况', builder: _ultraWidthPreview),
        ExampleItem(desc: '图片超高情况', builder: _ultraHeightPreview),
      ],
    );
  }

  var images = [
    'https://tdesign.gtimg.com/mobile/demos/swiper1.png',
    'https://tdesign.gtimg.com/mobile/demos/swiper2.png',
  ];

  @Demo(group: 'preview')
  Widget _basicPreview(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '基础图片预览',
      onTap: () {
        TDPreview.showPreview(context: context, images: images);
      },
    );
  }

  @Demo(group: 'preview')
  Widget _actionPreview(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '带操作图片预览',
      onTap: () {
        TDPreview.showPreview(
          context: context,
          images: images,
          showIndex: true,
          deleteBtn: true,
        );
      },
    );
  }

  @Demo(group: 'preview')
  Widget _longPressPreview(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '长按图片',
      onTap: () {
        TDPreview.showPreview(
          context: context,
          images: images,
          deleteBtn: true,
          showIndex: true,
          onLongPress: (index) {
            Navigator.of(context).push(TDSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: _getSheetItem,
            ));
          },
        );
      },
    );
  }

  @Demo(group: 'preview')
  Widget _ultraWidthPreview(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '图片超宽情况',
      onTap: () {
        TDPreview.showPreview(
          context: context,
          images: images,
          showIndex: true,
          height: 140,
          onLongPress: (index) {
            Navigator.of(context).push(TDSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: _getSheetItem,
            ));
          },
        );
      },
    );
  }

  @Demo(group: 'preview')
  Widget _ultraHeightPreview(BuildContext context) {
    return TDButton(
      type: TDButtonType.ghost,
      theme: TDButtonTheme.primary,
      isBlock: true,
      size: TDButtonSize.large,
      text: '图片超高情况',
      onTap: () {
        TDPreview.showPreview(
          context: context,
          images: images,
          showIndex: true,
          width: 180,
          onLongPress: (index) {
            Navigator.of(context).push(TDSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: _getSheetItem,
            ));
          },
        );
      },
    );
  }

  Widget _getSheetItem(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            '保存图片',
            style: TextStyle(
              color: TDTheme.of(context).fontGyColor1,
              decoration: TextDecoration.none,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const TDDivider(margin: EdgeInsets.symmetric(vertical: 10),),
          Text(
            '删除图片',
            style: TextStyle(
              color: TDTheme.of(context).fontGyColor1,
              decoration: TextDecoration.none,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
