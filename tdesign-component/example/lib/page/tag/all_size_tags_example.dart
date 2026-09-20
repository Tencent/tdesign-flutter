import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class AllSizeTagsExample extends StatelessWidget {
  const AllSizeTagsExample({super.key});

  Widget _buildAllSizeTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      direction: Axis.vertical,
      children: [
        TTag('超大标签', size: TTagSize.extraLarge),
        TTag('大型标签', size: TTagSize.large),
        TTag('中等标签', size: TTagSize.medium),
        TTag('小型标签', size: TTagSize.small),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 16),
      child: Wrap(
        spacing: 8,
        direction: Axis.vertical,
        children: [Builder(builder: _buildAllSizeTags)],
      ),
    );
  }
}
