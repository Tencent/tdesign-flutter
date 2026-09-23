import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class AccessibleTextExample extends StatelessWidget {
  const AccessibleTextExample({super.key});

  Widget _buildAccessibleText(BuildContext context) {
    return SelectionArea(
      child: TText(
        '长按或拖拽选择这段文本',
        semanticsLabel: '可选择的示例文本',
        semanticsIdentifier: 't-text-selection-example',
        selectionColor: context.tTheme.brandFocusColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAccessibleText(context);
  }
}
