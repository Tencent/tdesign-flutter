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

  dynamic iconList = [];

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
                child: isLoading ? const TDText('加载中...') : const TDText('暂无内容'),
              );
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: ListView.builder(
                  itemCount: (iconList.length + 1) ~/ 2,
                  itemBuilder: (context,index){
                    var index1 = index ~/ 2;
                    var index2 = index1 + 1;
                    var iconData1 =  iconList.elementAt(index1);
                    var iconData2;
                    if(iconList.length > index2){
                      iconData2 =  iconList.elementAt(index2);
                    }
                    return Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 175,
                          child: Column(
                            children: [
                              Container(
                                color: showBorder ? TDTheme.of(context).brandDisabledColor : Colors.transparent,
                                child: Icon(iconData1),
                              ),
                              TDText(iconData1.name)
                            ],
                          ),
                        ),
                        if (iconData2 != null)
                          SizedBox(
                            height: 100,
                            width: 175,
                            child: Column(
                              children: [
                                Container(
                                  color: showBorder ? TDTheme.of(context).brandDisabledColor : Colors.transparent,
                                  child: Icon(iconData2),
                                ),
                                TDText(iconData2.name)
                              ],
                            ),
                          )
                      ],
                    );
                  }),
            );
          })
        ],
      ),
    );
  }
}
