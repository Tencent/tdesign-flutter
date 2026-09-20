import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputBannerExample extends StatelessWidget {
  const InputBannerExample({super.key});

  Widget _buildBanner(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: ClipRRect(
      // MiniProgram demo: border-radius: 18rpx.
      borderRadius: BorderRadius.circular(9),
      child: Theme(
        data: Theme.of(
          context,
        ).mergeExtension(const TFormThemeData(borderColor: Colors.transparent)),
        child: const TFormItem(
          label: '标签文字',
          child: TInput(borderless: true, hintText: '请输入文字'),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildBanner(context);
  }
}
