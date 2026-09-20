import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'image')
class ImageStatesExample extends StatelessWidget {
  const ImageStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildImageStates(context);
  }
}

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

Widget _demoItem(String label, Widget image) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [TText(label), const SizedBox(height: 16), image],
  );
}
