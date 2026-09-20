import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputCustomExample extends StatelessWidget {
  const InputCustomExample({super.key});

  Widget _buildCustom(BuildContext context) => ColoredBox(
    color: const Color(0xff2c2c2c),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Theme(
        data: Theme.of(context)
            .mergeExtension(
              const TInputThemeData(
                backgroundColor: Color(0xff2c2c2c),
                borderColor: Color(0xff4b4b4b),
                textStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Color(0x59ffffff)),
              ),
            )
            .mergeExtension(
              const TFormThemeData(
                backgroundColor: Color(0xff2c2c2c),
                borderColor: Color(0xff4b4b4b),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
        child: const TFormItem(
          label: '标签文字',
          child: TInput(borderless: true, hintText: '请输入文字'),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildCustom(context);
  }
}
