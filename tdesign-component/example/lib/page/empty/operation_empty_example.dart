import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'empty')
class OperationEmptyExample extends StatelessWidget {
  const OperationEmptyExample({super.key});

  Widget _operationEmpty(BuildContext context) {
    return TEmpty(
      emptyText: '描述文字',
      operation: TButton(
        size: TButtonSize.large,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {},
        child: const Text('操作按钮'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _operationEmpty(context);
  }
}
