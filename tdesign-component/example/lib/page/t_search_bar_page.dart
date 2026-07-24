import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TSearchBarPage extends StatefulWidget {
  const TSearchBarPage({super.key});

  @override
  State<StatefulWidget> createState() => _TSearchBarPageState();
}

class _TSearchBarPageState extends State<TSearchBarPage> {
  String? inputText;
  String? searchText;
  final TextEditingController inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
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
        ExampleItem(desc: '外部按钮触发搜索', builder: _buildSearchBarWithAction),
        ExampleItem(desc: '自定义取消按钮文案', builder: _buildFocusSearchBarWithAction),
      ],
    );
  }

  @Demo(group: 'search')
  Widget _buildDefaultSearchBar(BuildContext context) {
    return TSearchBar(
      hintText: '搜索预设文案',
      onChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }

  @Demo(group: 'search')
  Widget _buildFocusSearchBar(BuildContext context) {
    return const TSearchBar(
      hintText: '搜索预设文案',
      needCancel: true,
      autoFocus: true,
    );
  }

  @Demo(group: 'search')
  Widget _buildSearchBarWithShape(BuildContext context) {
    return Column(
      children: [
        TSearchBar(
          hintText: '搜索预设文案',
          onChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ),
        const SizedBox(height: 16),
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSearchBarThemeData(variant: TSearchBarVariant.round),
          ),
          child: TSearchBar(
            hintText: '搜索预设文案',
            onChanged: (String text) {
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
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TSearchBarThemeData(textAlignment: TSearchBarAlignment.center),
      ),
      child: TSearchBar(
        hintText: '搜索预设文案',
        onChanged: (String text) {
          setState(() {
            inputText = text;
          });
        },
      ),
    );
  }

  @Demo(group: 'search')
  Widget _buildSearchBarWithAction(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TSearchBar(
                hintText: '搜索预设文案',
                controller: inputController,
                onChanged: (String text) {
                  setState(() {
                    inputText = text;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            TButton(
              child: const Text('搜索'),
              onPressed: () {
                setState(() {
                  searchText = inputController.text;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: TText('搜索框输入的内容：${searchText ?? ''}'),
        ),
      ],
    );
  }

  @Demo(group: 'search')
  Widget _buildFocusSearchBarWithAction(BuildContext context) {
    return TSearchBar(
      hintText: '搜索预设文案',
      needCancel: true,
      cancelText: '关闭',
      controller: inputController,
      onCancelPressed: () {
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
