import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TResultPage extends StatelessWidget {
  const TResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Result 结果',
      desc: '用于反馈不同结果的展示。',
      exampleCodeGroup: 'result',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础结果', builder: _buildBasicResults),
            ExampleItem(desc: '带描述结果', builder: _buildDescriptionResults),
            ExampleItem(desc: '自定义结果', builder: _buildCustomResult),
            ExampleItem(desc: '页面示例', builder: _buildPageExample),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'result')
  Widget _buildBasicResults(BuildContext context) {
    return const Column(
      children: [
        TResult(status: TResultStatus.success, title: '成功状态'),
        SizedBox(height: 48),
        TResult(status: TResultStatus.error, title: '失败状态'),
        SizedBox(height: 48),
        TResult(status: TResultStatus.warning, title: '警示状态'),
        SizedBox(height: 48),
        TResult(title: '默认状态'),
      ],
    );
  }

  @ExampleCode(group: 'result')
  Widget _buildDescriptionResults(BuildContext context) {
    return const Column(
      children: [
        TResult(
          status: TResultStatus.success,
          title: '成功状态',
          description: '描述文字',
        ),
        SizedBox(height: 48),
        TResult(
          status: TResultStatus.error,
          title: '失败状态',
          description: '描述文字',
        ),
        SizedBox(height: 48),
        TResult(
          status: TResultStatus.warning,
          title: '警示状态',
          description: '描述文字',
        ),
        SizedBox(height: 48),
        TResult(title: '默认状态', description: '描述文字'),
      ],
    );
  }

  @ExampleCode(group: 'result')
  Widget _buildCustomResult(BuildContext context) {
    return TResult(
      icon: Image.asset('assets/img/illustration.png', width: 80, height: 80),
      title: '自定义结果',
      description: '描述文字',
    );
  }

  @ExampleCode(group: 'result')
  Widget _buildPageExample(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        key: const ValueKey('result-page-example'),
        variant: TButtonVariant.outline,
        child: const Text('页面示例'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      const TNavBar(title: TText('Result')),
                      const Expanded(
                        child: Center(
                          child: TResult(
                            status: TResultStatus.success,
                            title: '成功状态',
                            description: '描述文字',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: TButton(
                            key: const ValueKey('result-page-back'),
                            variant: TButtonVariant.outline,
                            child: const Text('返回'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
