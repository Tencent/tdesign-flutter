import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputBorderedExample extends StatelessWidget {
  const InputBorderedExample({super.key});

  Widget _buildBordered(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .mergeExtension(
            const TFormThemeData(
              layout: TFormLayout.vertical,
              borderColor: Colors.transparent,
              itemPadding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              labelGap: 8,
            ),
          )
          .mergeExtension(
            const TInputThemeData(
              borderRadius: 6,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
      child: const TFormItem(
        label: '标签文字',
        child: TInput(
          hintText: '请输入文字',
          suffix: Icon(TIcons.info_circle_filled),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBordered(context);
  }
}
