import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDIconPage extends StatefulWidget {
  const TDIconPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDIconPageState();
}

class _TDIconPageState extends State<TDIconPage> {
  bool showBorder = false;

  var iconList = [];

  var isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        iconList.addAll(TDIcons.all.values);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: 'Icon 作为UI构成中重要的元素，一定程度上影响UI界面整体呈现出的风格。',
        exampleCodeGroup: 'icon',
        children: [
          ExampleModule(
              title: 'icon示例', children: [ExampleItem(desc: 'icon数量: ${iconList.length}', builder: _showAllIcons)])
        ]);
  }

  @Demo(group: 'icon')
  Widget _showAllIcons(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.topLeft,
            child: const Wrap(
              children: [
                TDText('筛选Icon请前往TDesign官网(长按网址可复制):'),
                SelectableText('https://tdesign.tencent.com/vue/components/icon')
              ],
            ),
          ),
          TDSearchBar(
            action: '搜索',
            onActionClick: (text) {
              setState(() {
                iconList.clear();
              });
              Future.delayed(const Duration(milliseconds: 30), () {
                TDIcons.all.forEach((key, value) {
                  if (value.name.contains(text)) {
                    iconList.add(value);
                  }
                });
                setState(() {});
              });
            },
            onClearClick: (_) {
              setState(() {
                iconList.addAll(TDIcons.all.values);
              });
            },
          ),
          Container(
            child: TDButton(
              text: showBorder ? '隐藏边框' : '显示边框',
              shape: TDButtonShape.filled,
              onTap: () {
                setState(() {
                  showBorder = !showBorder;
                });
              },
            ),
            margin: const EdgeInsets.only(bottom: 16),
          ),
          Builder(builder: (context) {
            if (iconList.isEmpty) {
              return Container(
                height: 300,
                alignment: Alignment.center,
                child: isLoading ? const TDLoading(size: TDLoadingSize.medium) : const TDText("暂无内容"),
              );
            }
            return Wrap(
              children: [
                for (var iconData in iconList)
                  SizedBox(
                    height: 100,
                    width: 175,
                    child: Column(
                      children: [
                        Container(
                          color: showBorder ? TDTheme.of(context).brandDisabledColor : Colors.transparent,
                          child: Icon(iconData),
                        ),
                        TDText(iconData.name)
                      ],
                    ),
                  )
              ],
            );
          })
        ],
      ),
    );
  }
}
