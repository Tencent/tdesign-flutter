import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TTextarea 示例页。
class TTextareaPage extends StatelessWidget {
  const TTextareaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'textarea',
      desc: 'TInput.multiline 的语义别名。',
      children: [
        ExampleModule(
          title: '多行输入',
          children: [
            ExampleItem(desc: '基础', builder: _buildBasic),
            ExampleItem(desc: '标签与计数', builder: _buildLabel),
            ExampleItem(desc: '只读', builder: _buildReadOnly),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'textarea')
  Widget _buildBasic(BuildContext context) => const TTextarea(
        hintText: '请输入内容',
      );

  @ExampleCode(group: 'textarea')
  Widget _buildLabel(BuildContext context) => const TTextarea(
        label: '备注',
        hintText: '请输入备注',
        maxLength: 200,
        minLines: 3,
        maxLines: 6,
      );

  @ExampleCode(group: 'textarea')
  Widget _buildReadOnly(BuildContext context) => const TTextarea(
        initialValue: '只读内容',
        readOnly: true,
      );
}
