import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'loading')
class TextIconHorizontalLoadingExample extends StatelessWidget {
  const TextIconHorizontalLoadingExample({super.key});

  /// 图标加文字横向
  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(icon: TLoadingIcon.circle, text: '加载中...'),
        ),
        const SizedBox(width: 64),
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(icon: TLoadingIcon.activity, text: '加载中...'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextIconHorizontalLoading(context);
  }
}
