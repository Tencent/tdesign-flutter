import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class TextThemeExample extends StatelessWidget {
  const TextThemeExample({super.key});

  Widget _buildTextThemeExample(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        TTextThemeData(
          textStyle: TextStyle(
            fontSize: context.tTheme.fontTitleLarge?.size,
            height: context.tTheme.fontTitleLarge?.height,
            fontWeight: context.tTheme.fontTitleLarge?.fontWeight,
            color: context.tTheme.brandColor,
          ),
        ),
      ),
      child: const TText('继承组件主题样式'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextThemeExample(context);
  }
}
