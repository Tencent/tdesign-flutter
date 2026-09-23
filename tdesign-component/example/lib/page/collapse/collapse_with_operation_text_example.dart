import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'collapse')
class CollapseWithOperationTextExample extends StatefulWidget {
  const CollapseWithOperationTextExample({super.key});

  @override
  State<CollapseWithOperationTextExample> createState() =>
      _CollapseWithOperationTextExampleState();
}

class _CollapseWithOperationTextExampleState
    extends State<CollapseWithOperationTextExample> {
  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_operationValue` 是由 State 持有的展开值列表，
  /// 初始包含唯一面板值；`onChanged` 通过 `setState` 写回完整列表，
  /// `trailingBuilder` 根据展开状态显示操作文案。`randomString` 是页面级常量，
  /// 仅作为面板正文示例。
  Widget _buildCollapseWithOperationText(BuildContext context) {
    return TCollapse<String>(
      value: _operationValue,
      onChanged: (value) => setState(() => _operationValue = value),
      children: [
        TCollapsePanel<String>(
          value: 'operation',
          headerBuilder: (context, isExpanded) => const Text('折叠面板标题'),
          trailingBuilder: (context, isExpanded) =>
              Text(isExpanded ? '收起' : '展开'),
          body: const Text(randomString),
        ),
      ],
    );
  }

  List<String> _operationValue = const ['operation'];

  @override
  Widget build(BuildContext context) {
    return _buildCollapseWithOperationText(context);
  }
}

const String randomString =
    '此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容';
