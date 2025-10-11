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

  Iterable iconList = [];

  var isLoading = false;

  @override
  void initState() {
    super.initState();

    iconList = TDIcons.all.values;
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: 'Icon 作为UI构成中重要的元素，一定程度上影响UI界面整体呈现出的风格。',
        exampleCodeGroup: 'icon',
        children: [
          ExampleModule(
            title: 'icon示例',
            children: [
              ExampleItem(
                desc: 'icon数量: ${iconList.length}',
                builder: _showAllIcons,
              )
            ],
          )
        ]);
  }

  @Demo(group: 'icon')
  Widget _showAllIcons(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: const Wrap(
              children: [
                TDText('筛选Icon请前往TDesign官网(长按网址可复制):'),
                SelectableText(
                    'https://tdesign.tencent.com/vue/components/icon')
              ],
            ),
          ),
          TDSearchBar(
            action: '搜索',
            onActionClick: (text) {
              setState(() {
                iconList = [];
                isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 30), () {
                var list = [];
                TDIcons.all.forEach((key, value) {
                  if (value.name.contains(text)) {
                    list.add(value);
                  }
                });
                setState(() {
                  iconList = list;
                  isLoading = false;
                });
              });
            },
            onClearClick: (_) {
              setState(() {
                iconList = TDIcons.all.values;
              });
            },
          ),
          TDCell(
            title: '显示边框',
            noteWidget: TDSwitch(
              isOn: showBorder,
              onChanged: (value) {
                setState(() {
                  showBorder = value;
                });
                return value;
              },
            ),
          ),
          Builder(builder: (context) {
            if (iconList.isEmpty) {
              return Container(
                height: 300,
                alignment: Alignment.center,
                child:
                    isLoading ? const TDText('加载中...') : const TDText('暂无内容'),
              );
            }

            var width = MediaQuery.of(context).size.width * 0.4;

            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Wrap(
                      spacing: 16,
                      runSpacing: 18,
                      children: iconList.map((item) {
                        return SizedBox(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: showBorder
                                      ? TDTheme.of(context).brandDisabledColor
                                      : Colors.transparent,
                                ),
                                child: Icon(item, size: 32),
                              ),
                              TDText(item.name)
                            ],
                          ),
                        );
                      }).toList()),
                ));
          })
        ],
      ),
    );
  }
}
