import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'result')
class ResultPageExample extends StatelessWidget {
  const ResultPageExample({super.key});

  Widget _buildResultPageExample(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
      child: SizedBox(
        width: double.infinity,
        child: TButton(
          key: const ValueKey('result-page-example'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
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
                              size: TButtonSize.large,
                              variant: TButtonVariant.outline,
                              colorScheme: TButtonColorScheme.primary,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildResultPageExample(context);
  }
}
