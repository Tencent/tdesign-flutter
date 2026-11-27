import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

@ExampleCode(group: 'toast')
class TextToastExample extends StatelessWidget {
  const TextToastExample({super.key});

  Widget _buildTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorPreset: TButtonColorPreset.primary,
        onPressed: () {
          TToast.showText('轻提示文字内容', context: context);
        },
        child: const Text('纯文本'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextToast(context);
  }
}
