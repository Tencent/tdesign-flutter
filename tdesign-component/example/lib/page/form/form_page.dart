import 'package:flutter/material.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'form_basic_demo.dart';

/// TForm、TFormItem 与 TFormField 组合示例页面。
@ExampleCodeManifest()
class TFormPage extends StatelessWidget {
  const TFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用以收集、校验和提交数据，一般由输入框、单选框、复选框、选择器等控件组成。',
      exampleCodeGroup: 'form',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础表单',
              builder: (_) => const FormBasicDemo(),
              methodName: 'FormBasicDemo',
              center: false,
            ),
          ],
        ),
      ],
    );
  }
}
