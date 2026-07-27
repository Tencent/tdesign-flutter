import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TForm、TFormItem 与 TFormField 组合示例。
class TFormPage extends StatefulWidget {
  const TFormPage({super.key});

  @override
  State<TFormPage> createState() => _TFormPageState();
}

class _TFormPageState extends State<TFormPage> {
  final _controller = TFormController();
  final _nameController = TextEditingController();
  bool _notifications = true;
  double _rating = 3;
  String _result = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '基于 Flutter Form 与 FormField 的组合式表单。',
      exampleCodeGroup: 'form',
      children: [
        ExampleModule(title: '表单', children: [
          ExampleItem(desc: '校验、提交与重置', builder: _buildForm),
          ExampleItem(desc: '垂直布局', builder: _buildVerticalForm),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'form')
  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TForm(
        controller: _controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSubmit: (values) => setState(() => _result = '$values'),
        child: Column(
          children: [
            TFormField<String>(
              name: 'name',
              value: _nameController.text,
              onChanged: (_) => setState(() {}),
              validator: (value) =>
                  (value?.trim().isEmpty ?? true) ? '请输入姓名' : null,
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '姓名',
                required: true,
                errorText: errorText,
                child: TInput(
                  controller: _nameController,
                  hintText: '请输入姓名',
                  onChanged: onChanged,
                ),
              ),
            ),
            TFormField<bool>(
              name: 'notifications',
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '消息通知',
                help: '接收服务状态通知',
                child: TSwitch(value: value, onChanged: onChanged),
              ),
            ),
            TFormField<double>(
              name: 'rating',
              value: _rating,
              onChanged: (value) => setState(() => _rating = value),
              validator: (value) => value == 0 ? '请选择评分' : null,
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '评分',
                required: true,
                errorText: errorText,
                child: TRate(value: value, onChanged: onChanged),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: _controller.submit,
                  child: const Text('提交'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _reset,
                  child: const Text('重置'),
                ),
              ],
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_result),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @ExampleCode(group: 'form')
  Widget _buildVerticalForm(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TFormThemeData(
          layout: TFormLayout.vertical,
          showColon: true,
          itemSpacing: 8,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: TFormItem(
          label: '备注',
          help: '最多 100 个字符',
          child: TInput.multiline(
            maxLength: 100,
            hintText: '请输入备注',
          ),
        ),
      ),
    );
  }

  void _reset() {
    _nameController.clear();
    setState(() {
      _notifications = true;
      _rating = 3;
      _result = '';
    });
    _controller.reset();
  }
}
