import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class AllSizeTagsExample extends StatelessWidget {
  const AllSizeTagsExample({super.key});

  Widget _buildAllSizeTags(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            TTag('加大尺寸', size: TTagSize.extraLarge),
            TTag('大尺寸', size: TTagSize.large),
            TTag('中尺寸', size: TTagSize.medium),
            TTag('小尺寸', size: TTagSize.small),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            TTag('加大尺寸', size: TTagSize.extraLarge, needCloseIcon: true),
            TTag('大尺寸', size: TTagSize.large, needCloseIcon: true),
            TTag('中尺寸', size: TTagSize.medium, needCloseIcon: true),
            TTag('小尺寸', size: TTagSize.small, needCloseIcon: true),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 16),
      child: Builder(builder: _buildAllSizeTags),
    );
  }
}
