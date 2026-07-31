import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../base/example_widget.dart';

class TImageViewerPage extends StatefulWidget {
  const TImageViewerPage({Key? key}) : super(key: key);

  @override
  State<TImageViewerPage> createState() => _TImageViewerPageState();
}

class _TImageViewerPageState extends State<TImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'ImageViewer 图片预览',
      desc: '点击图片可全屏预览',
      exampleCodeGroup: 'image-viewer',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '预览单张图片', builder: _buildSingle),
          ExampleItem(desc: '预览多张图片', builder: _buildMultiple),
        ]),
      ],
    );
  }

  Widget _buildSingle(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TImageViewer.show(
          context: context,
          images: const [
            NetworkImage('https://tdesign.gtimg.com/site/avatar.jpg'),
          ],
        );
      },
      child: const TImage(
        src: 'https://tdesign.gtimg.com/site/avatar.jpg',
        variant: TImageVariant.roundedSquare,
      ),
    );
  }

  Widget _buildMultiple(BuildContext context) {
    const urls = [
      'https://tdesign.gtimg.com/site/avatar.jpg',
      'https://tdesign.gtimg.com/site/avatar.jpg',
    ];
    final images = urls.map(NetworkImage.new).toList();
    return Wrap(
      spacing: 8,
      children: images.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            TImageViewer.show(
              context: context,
              images: images,
              initialIndex: entry.key,
              showIndex: true,
            );
          },
          child: TImage(
            src: urls[entry.key],
            variant: TImageVariant.roundedSquare,
          ),
        );
      }).toList(),
    );
  }
}
