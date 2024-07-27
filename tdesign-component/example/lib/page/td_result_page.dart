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
      desc: '用于空状态时的占位提示。',
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

  @Demo(group: 'result')
  Widget _buildBasicResult(BuildContext context) {
    return Column(
      children: [
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '成功状态',
            theme: TDResultTheme.success,
          ),
          methodName: '_buildBasicResult',
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '失败状态',
            theme: TDResultTheme.error,
          ),
          methodName: '_buildBasicResult',
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '警示状态',
            theme: TDResultTheme.warning,
          ),
          methodName: '_buildBasicResult',
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '默认状态',
            theme: TDResultTheme.defaultTheme,
          ),
          methodName: '_buildBasicResult',
        ),
      ],
    );
  }

  @Demo(group: 'result')
  Widget _buildResultWithDescription(BuildContext context) {
    return Column(
      children: [
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '成功状态',
            theme: TDResultTheme.success,
            description: '描述文字',
          ),
          methodName: '_buildResultWithDescription',
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '失败状态',
            theme: TDResultTheme.error,
            description: '描述文字',
          ),
          methodName: '_buildResultWithDescription',
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '警示状态',
            theme: TDResultTheme.warning,
            description: '描述文字',
          ),
          methodName: '_buildResultWithDescription',
        ),
        const SizedBox(height: 48),
        CodeWrapper(
          builder: (_) => const TDResult(
            title: '默认状态',
            theme: TDResultTheme.defaultTheme,
            description: '描述文字',
          ),
          methodName: '_buildResultWithDescription',
        ),
      ],
    );
  }

  @Demo(group: 'result')
  Widget _buildCustomResult(BuildContext context) {
    return CodeWrapper(
      builder: (_) => TDResult(
        title: '自定义结果',
        icon: Image.asset('assets/img/illustration.png'),
        description: '描述文字',
      ),
      methodName: '_buildCustomResult',
    );
  }

  @Demo(group: 'result')
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
}
