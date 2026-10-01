import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'fonts')
class FontTokenModuleExample extends StatelessWidget {
  const FontTokenModuleExample({super.key});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    context.tTheme.fontMap.forEach((key, value) {
      children.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.tTheme.componentBorder,
                width: 0.5,
              ),
            ),
          ),
          child: Theme(
            data: Theme.of(context).mergeExtension(
              TTextThemeData(
                textStyle: TextStyle(
                  decoration: key.contains('Link')
                      ? TextDecoration.underline
                      : null,
                  decorationColor: context.tTheme.textColorPrimary,
                ),
              ),
            ),
            child: TText('@$key:${value.size.toInt()}px', font: value),
          ),
        ),
      );
    });
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
