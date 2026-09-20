import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'input_action_example.dart';
import 'input_align_example.dart';
import 'input_banner_example.dart';
import 'input_basic_example.dart';
import 'input_bordered_example.dart';
import 'input_custom_example.dart';
import 'input_formatter_example.dart';
import 'input_label_example.dart';
import 'input_layout_example.dart';
import 'input_password_example.dart';
import 'input_slots_example.dart';
import 'input_status_example.dart';

@ExampleCodeManifest()
/// TInput 示例页。
class TInputViewPage extends StatefulWidget {
  const TInputViewPage({super.key});

  @override
  State<TInputViewPage> createState() => _TInputViewPageState();
}

class _TInputViewPageState extends State<TInputViewPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TFormThemeData(
          requiredMarkPosition: TFormRequiredMarkPosition.right,
        ),
      ),
      child: ExamplePage(
        title: tTitle(),
        exampleCodeGroup: 'input',
        desc: '用于单行文本信息输入。',
        compactDemo: true,
        showTestModule: false,
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                desc: '基础输入框',
                center: false,
                methodName: 'InputBasicExample',
                builder: (_) => const InputBasicExample(),
              ),
              ExampleItem(
                desc: '带字数限制输入框',
                center: false,
                methodName: 'InputFormatterExample',
                builder: (_) => const InputFormatterExample(),
              ),
              ExampleItem(
                desc: '带操作输入框',
                center: false,
                methodName: 'InputActionExample',
                builder: (_) => const InputActionExample(),
              ),
              ExampleItem(
                desc: '带图标输入框',
                center: false,
                methodName: 'InputSlotsExample',
                builder: (_) => const InputSlotsExample(),
              ),
              ExampleItem(
                desc: '特定类型输入框',
                center: false,
                methodName: 'InputPasswordExample',
                builder: (_) => const InputPasswordExample(),
              ),
            ],
          ),
          ExampleModule(
            title: '组件状态',
            children: [
              ExampleItem(
                desc: '输入框状态',
                center: false,
                methodName: 'InputStatusExample',
                builder: (_) => const InputStatusExample(),
              ),
              ExampleItem(
                desc: '信息超长状态',
                center: false,
                methodName: 'InputLabelExample',
                builder: (_) => const InputLabelExample(),
              ),
            ],
          ),
          ExampleModule(
            title: '组件样式',
            children: [
              ExampleItem(
                desc: '内容位置',
                center: false,
                methodName: 'InputAlignExample',
                builder: (_) => const InputAlignExample(),
              ),
              ExampleItem(
                desc: '竖排样式',
                center: false,
                methodName: 'InputLayoutExample',
                builder: (_) => const InputLayoutExample(),
              ),
              ExampleItem(
                desc: '非通栏样式',
                center: false,
                methodName: 'InputBannerExample',
                builder: (_) => const InputBannerExample(),
              ),
              ExampleItem(
                desc: '标签外置样式',
                center: false,
                methodName: 'InputBorderedExample',
                builder: (_) => const InputBorderedExample(),
              ),
              ExampleItem(
                desc: '自定义样式输入框',
                center: false,
                methodName: 'InputCustomExample',
                builder: (_) => const InputCustomExample(),
              ),
            ],
          ),
        ],
        test: const [],
      ),
    );
  }
}
