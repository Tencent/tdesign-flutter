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
      desc: '用于多行文本信息输入。',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础多行文本框', builder: _buildBasic, center: false),
            ExampleItem(desc: '带标题多行文本框', builder: _buildLabel, center: false),
            ExampleItem(
              desc: '自动增高多行文本框',
              builder: _buildAutosize,
              center: false,
            ),
            ExampleItem(
              desc: '设置字符数限制',
              builder: _buildMaxLength,
              center: false,
            ),
            ExampleItem(desc: '', builder: _buildMaxCharacter, center: false),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '禁用状态', builder: _buildDisabled, center: false),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '卡片样式', builder: _buildCard, center: false),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [
            ExampleItem(desc: '标签外置输入框', builder: _buildCustom, center: false),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'textarea')
  Widget _buildBasic(BuildContext context) =>
      const TTextarea(hintText: '请输入文字');

  @ExampleCode(group: 'textarea')
  Widget _buildLabel(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TTextarea(hintText: '请输入文字'),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildAutosize(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TTextarea(hintText: '请输入文字', minLines: 1),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildMaxLength(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TTextarea(hintText: '设置最大字符个数', maxLength: 200, indicator: true),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildMaxCharacter(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TTextarea(
      hintText: '设置最大字符个数，一个汉字表示两个字符',
      maxCharacter: 200,
      indicator: true,
    ),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildDisabled(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TTextarea(hintText: '请输入文字', initialValue: '不可编辑文字', enabled: false),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildCard(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TInputThemeData(borderRadius: 12)),
      child: const TFormItem(
        label: '标签文字',
        child: TTextarea(
          hintText: '请输入文字',
          bordered: true,
          maxLength: 500,
          indicator: true,
        ),
      ),
    ),
  );

  @ExampleCode(group: 'textarea')
  Widget _buildCustom(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('标签文字'),
        SizedBox(height: 8),
        TTextarea(
          hintText: '请输入文字',
          bordered: true,
          maxLength: 100,
          indicator: true,
        ),
      ],
    ),
  );
}
