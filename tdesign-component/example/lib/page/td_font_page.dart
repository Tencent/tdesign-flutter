import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

/// 字体示例页面
class TDFontPage extends StatelessWidget {
  const TDFontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPaintBaselinesEnabled = true;
    return ExamplePage(padding: const EdgeInsets.all(8), title: tdTitle(context), exampleCodeGroup: 'fonts', children: [
      ExampleModule(title: 'Token', children: [
        ExampleItem(
            ignoreCode: true,
            builder: (context) {
              var children = <Widget>[];
              TDTheme.of(context).fontMap.forEach((key, value) {
                children.add(Container(
                  child: TDText(
                    '@$key:${value.size.toInt()}px',
                    font: value,

                    /// link类型的示例添加下划线
                    style: TextStyle(
                        decoration: key.contains('Link') ? TextDecoration.underline : null,
                        decorationColor: TDTheme.of(context).fontGyColor1),
                  ),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: TDTheme.of(context).grayColor4, width: 0.5))),
                ));
              });
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: children,
              );
            })
      ]),
    ], test: [
      ExampleItem(
          ignoreCode: true,
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TDText('使用主题字体:fontBodySmall', font: TDTheme.of(context).fontBodySmall),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TDText('使用主题字体:fontBodyLarge', font: TDTheme.of(context).fontBodyLarge),
                ),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: TDText(
                      '不使用数字字体:1234567890abcd',
                      font: TDTheme.defaultData().fontTitleSmall,
                      textColor: TDTheme.of(context).brandColor6,
                    )),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: TDText(
                      '使用数字字体:1234567890abcd',
                      font: TDTheme.defaultData().fontTitleSmall,
                      textColor: TDTheme.of(context).brandColor6,
                      fontFamily: TDTheme.defaultData().numberFontFamily,
                    )),
              ],
            );
          })
    ]);
  }
}
