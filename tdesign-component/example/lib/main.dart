import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: 'TDesign Flutter Example',
    theme: ThemeData(extensions: [
      TDThemeData.defaultData().copyWith(colorMap: {'brandNormalColor': Colors.blue})
    ]),
    home: Scaffold(
      body: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TDText(
                    '测试文本',
                    textColor: TDTheme.of(context).brandNormalColor,
                    font: TDTheme.of(context).fontBodyMedium,
                  ),
                  const TDButton(
                    text: '演示按钮',
                    theme: TDButtonTheme.primary,
                  ),
                  Icon(TDIcons.add,color: TDTheme.of(context).brandNormalColor,)
                ],
              );
            },
          ),
        ),
      ),
    ),
  ));
}
