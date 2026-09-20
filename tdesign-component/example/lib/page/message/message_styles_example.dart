import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'message')
class MessageStylesExample extends StatelessWidget {
  const MessageStylesExample({super.key});

  Widget _buildMessageStyles(BuildContext context) {
    return Column(
      children: [
        _buildInfoMessage(context),
        const SizedBox(height: 16),
        _buildSuccessMessage(context),
        const SizedBox(height: 16),
        _buildWarningMessage(context),
        const SizedBox(height: 16),
        _buildErrorMessage(context),
      ],
    );
  }

  Widget _buildInfoMessage(BuildContext context) {
    return _fullWidthButton(
      text: '普通通知',
      onPressed: () => TMessage.show(context: context, content: '这是一条普通通知信息'),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return _fullWidthButton(
      text: '成功通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条成功的提示消息',
        status: TMessageStatus.success,
      ),
    );
  }

  Widget _buildWarningMessage(BuildContext context) {
    return _fullWidthButton(
      text: '警示通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条需要用户关注到的警示通知',
        status: TMessageStatus.warning,
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return _fullWidthButton(
      text: '错误通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条错误提示通知',
        status: TMessageStatus.error,
      ),
    );
  }

  Widget _fullWidthButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: Text(text),
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessageStyles(context);
  }
}
