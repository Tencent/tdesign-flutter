import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDFormPage extends StatelessWidget {
  const TDFormPage({Key? key}) : super(key: key);

  final exampleTxt = '文本Text';

  @override
  Widget build(BuildContext context) {
    // debugPaintBaselinesEnabled = true;
    return ExamplePage(
      padding: const EdgeInsets.all(8),
      title: tdTitle(context),
      exampleCodeGroup: 'text',
      children: [
        ExampleModule(title: '使用示例', children: [
          ExampleItem(desc: '自定义内部padding:', builder: _buildUserNameItem),
        ]),
      ],
    );
  }
}


@Demo(group: 'form')
Widget _buildUserNameItem(BuildContext buildContext) {
  
  return TDFormItem();

}

// /// 自定义控件，内部的context可拿到外部TDTextConfiguration的配置信息
// class CustomPaddingText extends StatelessWidget {
//   const CustomPaddingText({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         TDText(
//           '中华人民共和国腾讯科技fgjpqy',
//           forceVerticalCenter: true,
//           backgroundColor: TDTheme.of(context).brandFocusColor,
//         ),
//         TDText(
//           'English',
//           font: TDTheme.of(context).fontHeadlineLarge,
//           forceVerticalCenter: true,
//           backgroundColor: TDTheme.of(context).brandFocusColor,
//         ),
//       ],
//     );
//   }
// }

// /// 重写内部padding方法
// class CustomTextPaddingConfig extends TDTextPaddingConfig {
//   @override
//   EdgeInsetsGeometry getPadding(String? data, double fontSize, double height) {
//     var supperPadding = super.getPadding(data, fontSize, height);
//     return EdgeInsets.only(left: 30, top: supperPadding.vertical.toDouble());
//   }
// }
