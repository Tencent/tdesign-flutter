import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDResultPage extends StatefulWidget {
  const TDResultPage({Key? key}) : super(key: key);

  @override
  State<TDResultPage> createState() => _TDResultPageState();
}

class _TDResultPageState extends State<TDResultPage> {
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
          ExampleItem(
              desc: '自定义结果', ignoreCode: true, builder: _buildCustomResult),
          ExampleItem(
              desc: '页面示例', ignoreCode: true, builder: _buildPageExample),
        ]),
      ],
    );
  }

  Widget _buildBasicResult(BuildContext context) {
    return Column(
      children: [
        CodeWrapper(
          builder: _buildBasicResultSuccess,
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: _buildBasicResultError,
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: _buildBasicResultWarning,
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: _buildBasicResultDefault,
        ),
      ],
    );
  }

  Widget _buildResultWithDescription(BuildContext context) {
    return Column(
      children: [
        CodeWrapper(
          builder: _buildResultWithDescriptionSuccess,
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: _buildResultWithDescriptionError,
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: _buildResultWithDescriptionWarning,
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: _buildResultWithDescriptionDefault,
        ),
      ],
    );
  }

  Widget _buildCustomResult(BuildContext context) {
    return CodeWrapper(
      builder: _buildCustomResultContent,
    );
  }

  Widget _buildPageExample(BuildContext context) {
    return TDButton(
      text: '页面示例',
      theme: TDButtonTheme.primary,
      size: TDButtonSize.large,
      type: TDButtonType.outline,
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
                children: [
                  const SizedBox(height: 48),
                  const TDResult(
                    title: '成功状态',
                    theme: TDResultTheme.success,
                    description: '描述文字',
                  ),
                  const SizedBox(height: 48),
                  TDButton(
                    text: '返回',
                    theme: TDButtonTheme.primary,
                    size: TDButtonSize.large,
                    type: TDButtonType.outline,
                    isBlock: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
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
  TDResult _buildBasicResultSuccess(BuildContext context) {
    return const TDResult(
      title: '成功状态',
      theme: TDResultTheme.success,
    );
  }

  @Demo(group: 'result')
  TDResult _buildBasicResultError(BuildContext context) {
    return const TDResult(
      title: '失败状态',
      theme: TDResultTheme.error,
    );
  }

  @Demo(group: 'result')
  TDResult _buildBasicResultWarning(BuildContext context) {
    return const TDResult(
      title: '警示状态',
      theme: TDResultTheme.warning,
    );
  }

  @Demo(group: 'result')
  TDResult _buildBasicResultDefault(BuildContext context) {
    return const TDResult(
      title: '默认状态',
      theme: TDResultTheme.defaultTheme,
    );
  }

  @Demo(group: 'result')
  TDResult _buildResultWithDescriptionSuccess(BuildContext context) {
    return const TDResult(
      title: '成功状态',
      theme: TDResultTheme.success,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TDResult _buildResultWithDescriptionError(BuildContext context) {
    return const TDResult(
      title: '失败状态',
      theme: TDResultTheme.error,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TDResult _buildResultWithDescriptionWarning(BuildContext context) {
    return const TDResult(
      title: '警示状态',
      theme: TDResultTheme.warning,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TDResult _buildResultWithDescriptionDefault(BuildContext context) {
    return const TDResult(
      title: '默认状态',
      theme: TDResultTheme.defaultTheme,
      description: '描述文字',
    );
  }

  @Demo(group: 'result')
  TDResult _buildCustomResultContent(BuildContext context) {
    return TDResult(
      title: '自定义结果',
      icon: Image.asset('assets/img/illustration.png'),
      description: '描述文字',
    );
  }
}
