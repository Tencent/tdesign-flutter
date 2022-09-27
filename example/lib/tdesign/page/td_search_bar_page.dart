
import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_base.dart';

class TdSearchBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdSearchBarPageState();
}

class _TdSearchBarPageState extends State<TdSearchBarPage> {
  String? inputText;
  @override
  Widget build(BuildContext context) {
    return ExampleWidget(title: '搜索框', children: [
      TDSearchBar(placeHolder: '搜索内容', onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },),
      Row(children: [
        TDText('输入文案：', font: TDTheme.of(context).fontM, textColor: TDTheme.of(context).fontGyColor1,),
        TDText('${inputText ?? ''}', font: TDTheme.of(context).fontM, textColor: TDTheme.of(context).fontGyColor1,),
      ],)
    ],);
  }
}