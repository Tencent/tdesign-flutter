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
      children: const [
        ExampleModule(
          title: '01 组件类型',
          children: [
            ExampleItem(ignoreCode: true, builder: _buildImageTypes),
          ],
        ),
        ExampleModule(
          title: '02 组件状态',
          children: [
            ExampleItem(ignoreCode: true, builder: _buildImageStates),
          ],
        ),
      ],
    );
  }
}

Widget _demoItem(String label, Widget image) {
  return SizedBox(
    width: 88,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TText(label),
        const SizedBox(height: 16),
        image,
      ],
    ),
  );
}

Widget _demoRow(List<Widget> children) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

@ExampleCode(group: 'image')
Widget _buildImageTypes(BuildContext context) {
  const source = 'assets/img/image.png';
  return Column(
    children: [
      _demoRow(const [
        SizedBox(
          width: 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TText('裁切'),
              SizedBox(height: 16),
              TImage(src: source, fit: BoxFit.cover),
            ],
          ),
        ),
        SizedBox(
          width: 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TText('适应高'),
              SizedBox(height: 16),
              TImage(src: source, fit: BoxFit.fitHeight),
            ],
          ),
        ),
        SizedBox(
          width: 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TText('拉伸'),
              SizedBox(height: 16),
              TImage(src: source),
            ],
          ),
        ),
      ]),
      const SizedBox(height: 32),
      _demoRow(const [
        SizedBox(
          width: 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TText('方形'),
              SizedBox(height: 16),
              TImage(src: source, fit: BoxFit.cover),
            ],
          ),
        ),
        SizedBox(
          width: 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TText('圆角方形'),
              SizedBox(height: 16),
              TImage(
                src: source,
                fit: BoxFit.cover,
                shape: TImageShape.roundedSquare,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 88,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TText('圆形'),
              SizedBox(height: 16),
              TImage(
                src: source,
                fit: BoxFit.cover,
                shape: TImageShape.circle,
              ),
            ],
          ),
        ),
      ]),
    ],
  );
}

@ExampleCode(group: 'image')
Widget _buildImageStates(BuildContext context) {
  return Column(
    children: [
      _demoRow([
        _demoItem(
          '加载默认提示',
          const TImage(src: '', shape: TImageShape.roundedSquare),
        ),
        _demoItem(
          '加载自定义提示',
          const TImage(
            src: '',
            shape: TImageShape.roundedSquare,
            loadingWidget: TLoading(size: 20, icon: TLoadingIcon.circle),
          ),
        ),
        const SizedBox(width: 88),
      ]),
      const SizedBox(height: 32),
      _demoRow([
        _demoItem(
          '失败默认提示',
          const TImage(src: 'error', shape: TImageShape.roundedSquare),
        ),
        _demoItem(
          '失败自定义提示',
          TImage(
            src: 'error',
            shape: TImageShape.roundedSquare,
            errorWidget: TText(
              '加载失败',
              font: context.tTheme.fontBodyExtraSmall,
            ),
          ),
        ),
        const SizedBox(width: 88),
      ]),
    ],
  );
}
