import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

@ExampleCode(group: 'toast')
class MultipleTextToastExample extends StatelessWidget {
  const MultipleTextToastExample({super.key});

  Widget _buildMultipleTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorPreset: TButtonColorPreset.primary,
        onPressed: () {
          TToast.showText('最多一行展示十个汉字宽度限制最多不超过三行文字', context: context);
        },
        child: const Text('多行文字'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultipleTextToast(context);
  }
}
