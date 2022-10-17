import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_base.dart';

class TDSearchBarPage extends StatefulWidget {
  const TDSearchBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDSearchBarPageState();
}

class _TDSearchBarPageState extends State<TDSearchBarPage> {
  String? inputText;

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(
      title: '搜索框 Search',
      apiPath: 'search',
      children: [
        TDSearchBar(
          placeHolder: '搜索预设文案',
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ),
        Row(
          children: [
            TDText(
              '输入文案：',
              font: TDTheme.of(context).fontM,
              textColor: TDTheme.of(context).fontGyColor1,
            ),
            TDText(
              '${inputText ?? ''}',
              font: TDTheme.of(context).fontM,
              textColor: TDTheme.of(context).fontGyColor1,
            ),
          ],
        )
      ],
      backgroundColor: TDTheme.of(context).whiteColor1,
    );
  }
}
