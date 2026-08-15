import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TInput 示例页。
class TInputViewPage extends StatefulWidget {
  const TInputViewPage({super.key});

  @override
  State<TInputViewPage> createState() => _TInputViewPageState();
}

class _TInputViewPageState extends State<TInputViewPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'input',
      desc: '用于接收单行或多行文本。',
      children: [
        ExampleModule(
          title: '基础输入',
          children: [
            ExampleItem(desc: '基础', builder: _buildBasic),
            ExampleItem(desc: '标签与内容槽', builder: _buildSlots),
            ExampleItem(desc: '必填标签', builder: _buildRequired),
            ExampleItem(desc: '纵向标签', builder: _buildVerticalLabel),
            ExampleItem(desc: '密码', builder: _buildPassword),
          ],
        ),
        ExampleModule(
          title: '状态',
          children: [
            ExampleItem(desc: '禁用', builder: _buildDisabled),
            ExampleItem(desc: '只读', builder: _buildReadOnly),
            ExampleItem(desc: '限制输入', builder: _buildFormatter),
          ],
        ),
        ExampleModule(
          title: '主题与多行',
          children: [
            ExampleItem(desc: '隐藏清除按钮', builder: _buildTheme),
            ExampleItem(desc: '多行输入', builder: _buildMultiline),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'input')
  Widget _buildBasic(BuildContext context) => TInput(
        controller: controller,
        hintText: '请输入文字',
      );

  @ExampleCode(group: 'input')
  Widget _buildSlots(BuildContext context) => const TInput(
        label: '手机号',
        hintText: '请输入手机号',
        prefix: Icon(TIcons.mobile),
        suffix: Text('+86'),
        inputType: TextInputType.phone,
      );

  @ExampleCode(group: 'input')
  Widget _buildRequired(BuildContext context) => const TInput(
        label: '标签文字',
        required: true,
        hintText: '请输入文字',
      );

  @ExampleCode(group: 'input')
  Widget _buildVerticalLabel(BuildContext context) => const TInput(
        label: '标签文字',
        layout: TInputLayout.vertical,
        hintText: '请输入文字',
      );

  @ExampleCode(group: 'input')
  Widget _buildPassword(BuildContext context) => const TInput(
        label: '密码',
        hintText: '请输入密码',
        obscureText: true,
        inputType: TextInputType.visiblePassword,
      );

  @ExampleCode(group: 'input')
  Widget _buildDisabled(BuildContext context) => const TInput(
        initialValue: '不可编辑',
        enabled: false,
      );

  @ExampleCode(group: 'input')
  Widget _buildReadOnly(BuildContext context) => const TInput(
        initialValue: '可选择复制',
        readOnly: true,
      );

  @ExampleCode(group: 'input')
  Widget _buildFormatter(BuildContext context) => TInput(
        hintText: '最多 10 个字符',
        maxLength: 10,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
      );

  @ExampleCode(group: 'input')
  Widget _buildTheme(BuildContext context) => Theme(
        data: Theme.of(context).mergeExtension(
          const TInputThemeData(showClearButton: false),
        ),
        child: const TInput(initialValue: '无清除按钮'),
      );

  @ExampleCode(group: 'input')
  Widget _buildMultiline(BuildContext context) => const TInput.multiline(
        hintText: '请输入多行内容',
        maxLength: 200,
      );
}
