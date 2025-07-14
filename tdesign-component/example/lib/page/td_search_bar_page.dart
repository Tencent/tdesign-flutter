import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDSearchBarPage extends StatefulWidget {
  const TDSearchBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDSearchBarPageState();
}

class _TDSearchBarPageState extends State<TDSearchBarPage> {
  String? inputText;
  String? searchText;
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于一组预设数据中的选择。',
      exampleCodeGroup: 'search',
      backgroundColor: TDTheme.of(context).grayColor2,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础搜索框', builder: _buildDefaultSearchBar),
            ExampleItem(desc: '获取焦点后显示取消按钮', builder: _buildFocusSearchBar),
          ],
        ),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '搜索框形状', builder: _buildSearchBarWithShape),
          ExampleItem(desc: '默认状态其他对齐方式', builder: _buildCenterSearchBar),
        ]),
      ],
      test: [
        ExampleItem(desc: '获取焦点后显示自定义操作按钮', builder: _buildSearchBarWithAction),
        ExampleItem(
            desc: '自定义获取焦点后显示按钮', builder: _buildFocusSearchBarWithAction),
      ],
    );
  }

  @Demo(group: 'search')
  Widget _buildDefaultSearchBar(BuildContext context) {
    return _buildColumnWidgets(
        context,
        TDSearchBar(
          placeHolder: '搜索预设文案',
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ));
  }

  @Demo(group: 'search')
  Widget _buildColumnWidgets(BuildContext context, Widget widget) {
    return Column(
      children: [
        widget,
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  @Demo(group: 'search')
  Widget _buildFocusSearchBar(BuildContext context) {
    return const TDSearchBar(
      placeHolder: '搜索预设文案',
      needCancel: true,
      autoFocus: true,
    );
  }

  @Demo(group: 'search')
  Widget _buildSearchBarWithShape(BuildContext context) {
    return Column(
      children: [
        _buildColumnWidgets(
          context,
          TDSearchBar(
            placeHolder: '搜索预设文案',
            style: TDSearchStyle.square,
            onTextChanged: (String text) {
              setState(() {
                inputText = text;
              });
            },
          ),
        ),
        _buildColumnWidgets(
          context,
          TDSearchBar(
            placeHolder: '搜索预设文案',
            style: TDSearchStyle.round,
            onTextChanged: (String text) {
              setState(() {
                inputText = text;
              });
            },
          ),
        ),
      ],
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

  @Demo(group: 'search')
  Widget _buildSearchBarWithAction(BuildContext context) {
    return Column(
      children: [
        TDSearchBar(
          placeHolder: '搜索预设文案',
          alignment: TDSearchAlignment.left,
          action: '搜索',
          onActionClick: (String text) {
            setState(() {
              searchText = text;
            });
          },
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: TDText(
            '搜索框输入的内容：${searchText ?? ''}',
          ),
        )
      ],
    );
  }

  @Demo(group: 'search')
  Widget _buildFocusSearchBarWithAction(BuildContext context) {
    return TDSearchBar(
      placeHolder: '搜索预设文案',
      action: '搜索',
      needCancel: true,
      controller: inputController,
      onActionClick: (value) {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TDConfirmDialog(
              content: inputController.text.isNotEmpty
                  ? '搜索关键词：${inputController.text}'
                  : '搜索关键词为空',
            );
          },
        );
      },
    );
  }
}
