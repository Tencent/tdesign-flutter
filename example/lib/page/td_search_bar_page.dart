import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../../base/example_widget.dart';

class TDSearchBarPage extends StatefulWidget {
  const TDSearchBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDSearchBarPageState();
}

class _TDSearchBarPageState extends State<TDSearchBarPage> {
  String? inputText;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: '搜索框 Search',
        backgroundColor: TDTheme.of(context).whiteColor1,
      children: [
      ExampleModule(title: '默认',
      children: [
        ExampleItem(builder: (_) => TDSearchBar(
          placeHolder: '搜索预设文案',
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        )),
        ExampleItem(builder: (_) => Row(
          children: [
            TDText(
              '输入文案：',
              font: TDTheme.of(context).fontBodyLarge,
              textColor: TDTheme.of(context).fontGyColor1,
            ),
            TDText(
              '${inputText ?? ''}',
              font: TDTheme.of(context).fontBodyLarge,
              textColor: TDTheme.of(context).fontGyColor1,
            ),
          ],
        ))
      ],
    )]);
  }
}
