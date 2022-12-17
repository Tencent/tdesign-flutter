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
        desc: '用于一组预设数据中的选择。',
        backgroundColor: TDTheme.of(context).grayColor2,
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                  desc: '基础搜索框',
                  builder: (_) => TDSearchBar(
                        placeHolder: '搜索预设文案',
                        onTextChanged: (String text) {
                          setState(() {
                            inputText = text;
                          });
                        },
                      )),
            ],
          ),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(
                desc: '搜索框形状',
                builder: (_) => TDSearchBar(
                      placeHolder: '搜索预设文案',
                      onTextChanged: (String text) {
                        setState(() {
                          inputText = text;
                        });
                      },
                    )),
            ExampleItem(
                builder: (_) => TDSearchBar(
                      style: TDSearchStyle.round,
                      placeHolder: '搜索预设文案',
                      onTextChanged: (String text) {
                        setState(() {
                          inputText = text;
                        });
                      },
                    )),
            ExampleItem(
                desc: '默认状态其他对齐方式',
                builder: (_) => TDSearchBar(
                      alignment: TDSearchAlignment.center,
                      placeHolder: '搜索预设文案',
                      onTextChanged: (String text) {
                        setState(() {
                          inputText = text;
                        });
                      },
                    )),
          ])
        ]);
  }
}
