import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

/// 字体示例页面
class TFontPage extends StatelessWidget {
  const TFontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        padding: const EdgeInsets.all(8),
        title: tTitle(context),
        exampleCodeGroup: 'fonts',
        children: [
          ExampleModule(title: 'Token', children: [
            ExampleItem(
                ignoreCode: true,
                builder: (context) {
                  var children = <Widget>[];
                  context.tTheme.fontMap.forEach((key, value) {
                    children.add(Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: context.tTheme.componentBorderColor,
                              width: 0.5),
                        ),
                      ),
                      child: TText(
                        '@$key:${value.size.toInt()}px',
                        font: value,

                        /// link类型的示例添加下划线
                        style: TextStyle(
                            decoration: key.contains('Link')
                                ? TextDecoration.underline
                                : null,
                            decorationColor: context.tTheme.textColorPrimary),
                      ),
                    ));
                  });
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: children,
                  );
                })
          ]),
        ],
        test: [
          ExampleItem(
            desc: '字体测试',
            ignoreCode: true,
            builder: (context) {
              return Column(
                // spacing: 16,
                children: [
                  TText(
                    '使用主题字体：fontBodySmall',
                    font: context.tTheme.fontBodySmall,
                  ),
                  const SizedBox(height: 16),
                  TText(
                    '使用主题字体：fontBodyLarge',
                    font: context.tTheme.fontBodyLarge,
                  ),
                  const SizedBox(height: 16),
                  TText(
                    '不使用数字字体：1234567890abcd',
                    font: TThemeData.defaultData().fontTitleSmall,
                    textColor: context.tTheme.brandNormalColor,
                  ),
                  const SizedBox(height: 16),
                  TText(
                    '使用数字字体：1234567890abcd',
                    font: TThemeData.defaultData().fontTitleSmall,
                    textColor: context.tTheme.brandNormalColor,
                    fontFamily: TThemeData.defaultData().numberFontFamily,
                  )
                ],
              );
            },
          ),
          ExampleItem(
            desc: '字符测试（TODO #993）',
            ignoreCode: true,
            builder: (context) {
              return Column(
                // spacing: 16,
                children: [
                  TText(
                    '延14字号',
                    style: const TextStyle(fontSize: 14),
                    font: context.tTheme.fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TText(
                    '延15字号',
                    style: const TextStyle(fontSize: 15),
                    font: context.tTheme.fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TText(
                    '延16字号',
                    style: const TextStyle(fontSize: 16),
                    font: context.tTheme.fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TText(
                    '延17字号',
                    style: const TextStyle(fontSize: 17),
                    font: context.tTheme.fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TText(
                    '延18字号',
                    style: const TextStyle(fontSize: 18),
                    font: context.tTheme.fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  const Text('延-系统字体16字号', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text('延-系统字体18字号', style: TextStyle(fontSize: 18))
                ],
              );
            },
          ),
        ]);
  }
}
