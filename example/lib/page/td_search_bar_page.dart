import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../../base/example_widget.dart';
import '../../annotation/demo.dart';

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
              ExampleItem(desc: '基础搜索框', builder: _buildDefaultSearchBar),
            ],
          ),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '搜索框形状', builder: _buildSquareSearchBar),
            ExampleItem(builder: _buildRoundSearchBar),
            ExampleItem(desc: '默认状态其他对齐方式', builder: _buildCenterSearchBar),
          ])
        ]);
  }

  @Demo(group: 'search')
  Widget _buildDefaultSearchBar(BuildContext context) {
    return TDSearchBar(
      placeHolder: '搜索预设文案',
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }

  @Demo(group: 'search')
  Widget _buildSquareSearchBar(BuildContext context) {
    return TDSearchBar(
      placeHolder: '搜索预设文案',
      style: TDSearchStyle.square,
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }

  @Demo(group: 'search')
  Widget _buildRoundSearchBar(BuildContext context) {
    return TDSearchBar(
      placeHolder: '搜索预设文案',
      style: TDSearchStyle.round,
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }

  @Demo(group: 'search')
  Widget _buildCenterSearchBar(BuildContext context) {
    return TDSearchBar(
      placeHolder: '搜索预设文案',
      alignment: TDSearchAlignment.center,
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }
  
}
