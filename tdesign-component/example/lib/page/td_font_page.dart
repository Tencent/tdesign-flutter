import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

/// 字体示例页面
class TDFontPage extends StatelessWidget {
  const TDFontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        padding: const EdgeInsets.all(8),
        title: tdTitle(context),
        exampleCodeGroup: 'fonts',
        children: [
          ExampleModule(title: 'Token', children: [
            ExampleItem(
                ignoreCode: true,
                builder: (context) {
                  var children = <Widget>[];
                  TDTheme.of(context).fontMap.forEach((key, value) {
                    children.add(Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: TDTheme.of(context).componentBorderColor,
                              width: 0.5),
                        ),
                      ),
                      child: TDText(
                        '@$key:${value.size.toInt()}px',
                        font: value,

                        /// link类型的示例添加下划线
                        style: TextStyle(
                            decoration: key.contains('Link')
                                ? TextDecoration.underline
                                : null,
                            decorationColor:
                                TDTheme.of(context).textColorPrimary),
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
                  TDText(
                    '使用主题字体：fontBodySmall',
                    font: TDTheme.of(context).fontBodySmall,
                  ),
                  const SizedBox(height: 16),
                  TDText(
                    '使用主题字体：fontBodyLarge',
                    font: TDTheme.of(context).fontBodyLarge,
                  ),
                  const SizedBox(height: 16),
                  TDText(
                    '不使用数字字体：1234567890abcd',
                    font: TDTheme.defaultData().fontTitleSmall,
                    textColor: TDTheme.of(context).brandNormalColor,
                  ),
                  const SizedBox(height: 16),
                  TDText(
                    '使用数字字体：1234567890abcd',
                    font: TDTheme.defaultData().fontTitleSmall,
                    textColor: TDTheme.of(context).brandNormalColor,
                    fontFamily: TDTheme.defaultData().numberFontFamily,
                  )
                ],
              );
            },
          ),
          ExampleItem(
            desc: '字符测试 - 待修复',
            ignoreCode: true,
            builder: (context) {
              return Column(
                // spacing: 16,
                children: [
                  TDText(
                    '延14字号',
                    style: const TextStyle(fontSize: 14),
                    font: TDTheme.of(context).fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TDText(
                    '延15字号',
                    style: const TextStyle(fontSize: 15),
                    font: TDTheme.of(context).fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TDText(
                    '延16字号',
                    style: const TextStyle(fontSize: 16),
                    font: TDTheme.of(context).fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TDText(
                    '延17字号',
                    style: const TextStyle(fontSize: 17),
                    font: TDTheme.of(context).fontMarkLarge,
                  ),
                  const SizedBox(height: 16),
                  TDText(
                    '延18字号',
                    style: const TextStyle(fontSize: 18),
                    font: TDTheme.of(context).fontMarkLarge,
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
