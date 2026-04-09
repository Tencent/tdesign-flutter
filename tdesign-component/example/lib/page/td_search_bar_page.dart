import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TSearchBarPage extends StatefulWidget {
  const TSearchBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TSearchBarPageState();
}

class _TSearchBarPageState extends State<TSearchBarPage> {
  String? inputText;
  String? searchText;
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于一组预设数据中的选择。',
      exampleCodeGroup: 'search',
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
    return TSearchBar(
      placeHolder: '搜索预设文案',
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }

  @Demo(group: 'search')
  Widget _buildFocusSearchBar(BuildContext context) {
    return const TSearchBar(
      placeHolder: '搜索预设文案',
      needCancel: true,
      autoFocus: true,
    );
  }

  @Demo(group: 'search')
  Widget _buildSearchBarWithShape(BuildContext context) {
    return Column(
      // spacing: 16,
      children: [
        TSearchBar(
          placeHolder: '搜索预设文案',
          // 方形
          style: TSearchStyle.square,
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ),
        const SizedBox(height: 16),
        TSearchBar(
          placeHolder: '搜索预设文案',
          // 圆形
          style: TSearchStyle.round,
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ),
      ],
    );
  }

  @Demo(group: 'search')
  Widget _buildCenterSearchBar(BuildContext context) {
    return TSearchBar(
      placeHolder: '搜索预设文案',
      alignment: TSearchAlignment.center,
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
      // spacing: 16,
      children: [
        TSearchBar(
          placeHolder: '搜索预设文案',
          alignment: TSearchAlignment.left,
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
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: TText('搜索框输入的内容：${searchText ?? ''}'),
        )
      ],
    );
  }

  @Demo(group: 'search')
  Widget _buildFocusSearchBarWithAction(BuildContext context) {
    return TSearchBar(
      placeHolder: '搜索预设文案',
      action: '搜索',
      needCancel: true,
      controller: inputController,
      onActionClick: (value) {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
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
