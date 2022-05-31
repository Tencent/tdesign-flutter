import 'package:flutter/material.dart';
import 'package:tdesign_flutter_example/tdesign/example_base.dart';
import 'package:tdesign_flutter/td_export.dart';

class TdDividerPage extends StatelessWidget {
  const TdDividerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(title: "TDDivider",
        padding: EdgeInsets.only(top: 16, bottom: 16),
        children: [
      ExampleItem(desc: "直线拉通", builder: (_){
        return TDDivider();
      }),
      ExampleItem(desc: "虚线拉通", builder: (_){
        return TDDivider(isDashed: true,);
      }),
          ExampleItem(desc: "左右间距", builder: (_){
            return TDDivider(margin: EdgeInsets.only(left: 16, right: 16),);
          }),
          ExampleItem(desc: "左侧拉通", builder: (_){
            return TDDivider(margin: EdgeInsets.only(left: 16, ),);
          }),
          ExampleItem(desc: "自定义左侧间距", builder: (_){
            return TDDivider(margin: EdgeInsets.only(left: 76, ),);
          }),
          ExampleItem(desc: "左右间距(虚线)", builder: (_){
            return TDDivider(margin: EdgeInsets.only(left: 16, right: 16),isDashed: true,);
          }),
          ExampleItem(desc: "自定义左侧间距(虚线)", builder: (_){
            return TDDivider(margin: EdgeInsets.only(left: 76, ),isDashed: true,);
          }),
          ExampleItem(desc: "垂直分割", builder: (_){
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TDText("文字信息", textColor: TDTheme.of(context).fontGyColor3,),
                TDDivider(width: 0.5, height: 12, margin: EdgeInsets.only(left: 8, right: 8),),
                TDText("文字信息", textColor: TDTheme.of(context).fontGyColor3),
                TDDivider(width: 0.5, height: 12, margin: EdgeInsets.only(left: 8, right: 8),isDashed: true, direction: Axis.vertical,),
                TDText("文字信息", textColor: TDTheme.of(context).fontGyColor3),
              ],
            );
          }),
          ExampleItem(desc: "文字+直线", builder: (_){
            return TDDivider(margin: EdgeInsets.only(left: 16, right: 16), text: "文字信息",);
          }),
          ExampleItem(desc: "文字+虚线", builder: (_){
            return TDDivider(margin: EdgeInsets.only(left: 16, right: 16), text: "文字信息",isDashed: true,);
          }),
          ExampleItem(desc: "纯文字", builder: (_){
            return TDDivider(hideLine: true, text: "文字信息",);
          }),
    ]);
  }
}


