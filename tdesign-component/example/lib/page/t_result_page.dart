import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TResultPage extends StatelessWidget {
  const TResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Result 结果',
      desc: '反馈结果状态。',
      exampleCodeGroup: 'result',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
              desc: '基础结果', ignoreCode: true, builder: _buildBasicResult),
          ExampleItem(
              desc: '带描述的结果',
              ignoreCode: true,
              builder: _buildResultWithDescription),
          ExampleItem(desc: '自定义结果', builder: _buildCustomResultContent),
          ExampleItem(
              desc: '页面示例', ignoreCode: true, builder: _buildPageExample),
        ]),
      ],
    );
  }

  Widget _buildBasicResult(BuildContext context) {
    return Column(
      // spacing: 32,
      children: [
        CodeWrapper(builder: _buildBasicResultSuccess),
        const SizedBox(height: 32),
        CodeWrapper(builder: _buildBasicResultError),
        const SizedBox(height: 32),
        CodeWrapper(builder: _buildBasicResultWarning),
        const SizedBox(height: 32),
        CodeWrapper(builder: _buildBasicResultDefault),
      ],
    );
  }

  Widget _buildResultWithDescription(BuildContext context) {
    return Column(
      // spacing: 32,
      children: [
        CodeWrapper(builder: _buildResultWithDescriptionSuccess),
        const SizedBox(height: 32),
        CodeWrapper(builder: _buildResultWithDescriptionError),
        const SizedBox(height: 32),
        CodeWrapper(builder: _buildResultWithDescriptionWarning),
        const SizedBox(height: 32),
        CodeWrapper(builder: _buildResultWithDescriptionDefault),
      ],
    );
  }

  Widget _buildPageExample(BuildContext context) {
    return TButton(
      text: '页面示例跳转',
      theme: TButtonTheme.primary,
      size: TButtonSize.large,
      isBlock: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Result 结果'),
              ),
              body: Column(
                // spacing: 48,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const TResult(
                    title: '成功状态',
                    theme: TResultTheme.success,
                    description: '描述文字',
                  ),
                  const SizedBox(height: 48),
                  TButton(
                    text: '返回',
                    theme: TButtonTheme.primary,
                    size: TButtonSize.large,
                    isBlock: true,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @Demo(group: 'result')
  TResult _buildBasicResultSuccess(BuildContext context) {
    return const TResult(
      title: '成功状态',
      theme: TResultTheme.success,
    );
  }

  @Demo(group: 'result')
  TResult _buildBasicResultError(BuildContext context) {
    return const TResult(
      title: '失败状态',
      theme: TResultTheme.error,
    );
  }

  @Demo(group: 'result')
  TResult _buildBasicResultWarning(BuildContext context) {
    return const TResult(
      title: '警示状态',
      theme: TResultTheme.warning,
    );
  }

  @Demo(group: 'result')
  TResult _buildBasicResultDefault(BuildContext context) {
    return const TResult(
      title: '默认状态',
      theme: TResultTheme.defaultTheme,
    );
  }

  @Demo(group: 'result')
  TResult _buildResultWithDescriptionSuccess(BuildContext context) {
    return const TResult(
      title: '成功状态',
      theme: TResultTheme.success,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TResult _buildResultWithDescriptionError(BuildContext context) {
    return const TResult(
      title: '失败状态',
      theme: TResultTheme.error,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TResult _buildResultWithDescriptionWarning(BuildContext context) {
    return const TResult(
      title: '警示状态',
      theme: TResultTheme.warning,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TResult _buildResultWithDescriptionDefault(BuildContext context) {
    return const TResult(
      title: '默认状态',
      theme: TResultTheme.defaultTheme,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TResult _buildCustomResultContent(BuildContext context) {
    return TResult(
      title: '自定义结果',
      icon: Image.asset('assets/img/illustration.png'),
      description: '描述文字',
    );
  }
}
