import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TImagePage extends StatelessWidget {
  const TImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'image',
      desc: '用于展示效果，主要为上下左右居中裁切、拉伸、平铺等方式。',
      showTestModule: false,
      children: const [
        ExampleModule(
          title: '组件类型',
          children: [ExampleItem(ignoreCode: true, builder: _buildImageTypes)],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(ignoreCode: true, builder: _buildImageStates)],
        ),
      ],
    );
  }
}

Widget _demoItem(String label, Widget image) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [TText(label), const SizedBox(height: 16), image],
  );
}

Widget _demoRow(List<Widget> children) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const SizedBox(width: 24),
            children[index],
          ],
        ],
      ),
    ),
  );
}

@ExampleCode(group: 'image')
Widget _buildImageTypes(BuildContext context) {
  const source = 'assets/img/image.png';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _demoRow([
        _demoItem('裁切', const TImage(src: source, fit: BoxFit.cover)),
        _demoItem(
          '适应高',
          const TImage(
            src: source,
            width: 89,
            height: 72,
            fit: BoxFit.fitHeight,
          ),
        ),
        _demoItem('拉伸', const TImage(src: source, width: 134, height: 72)),
      ]),
      const SizedBox(height: 24),
      _demoRow([
        _demoItem('方形', const TImage(src: source, fit: BoxFit.cover)),
        _demoItem(
          '圆角方形',
          const TImage(
            src: source,
            fit: BoxFit.cover,
            shape: TImageShape.roundedSquare,
          ),
        ),
        _demoItem(
          '圆形',
          const TImage(
            src: source,
            fit: BoxFit.cover,
            shape: TImageShape.circle,
          ),
        ),
      ]),
    ],
  );
}

@ExampleCode(group: 'image')
Widget _buildImageStates(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _demoRow([
        _demoItem('加载默认提示', const TImage(shape: TImageShape.roundedSquare)),
        _demoItem(
          '加载自定义提示',
          const TImage(
            shape: TImageShape.roundedSquare,
            loadingWidget: TLoading(size: 20, icon: TLoadingIcon.circle),
          ),
        ),
      ]),
      const SizedBox(height: 24),
      _demoRow([
        _demoItem(
          '失败默认提示',
          const TImage(src: '', shape: TImageShape.roundedSquare),
        ),
        _demoItem(
          '失败自定义提示',
          TImage(
            src: '',
            shape: TImageShape.roundedSquare,
            errorWidget: TText('加载失败', font: context.tTheme.fontBodyExtraSmall),
          ),
        ),
      ]),
    ],
  );
}
