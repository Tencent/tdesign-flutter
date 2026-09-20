import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class TextThemeExample extends StatelessWidget {
  const TextThemeExample({super.key});

  Widget _buildTextThemeExample(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ...Theme.of(context).extensions.values,
          TTextThemeData(
            font: context.tTheme.fontTitleLarge,
            textStyle: TextStyle(color: context.tTheme.brandNormalColor),
          ),
        ],
      ),
      child: const TText('继承 TTextThemeData 的默认样式'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextThemeExample(context);
  }
}
