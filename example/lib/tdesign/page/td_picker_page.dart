import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_base.dart';

// ignore: use_key_in_widget_constructors
class TdPickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdPickerPageState();
}

class _TdPickerPageState extends State<TdPickerPage> {
  String selected_1 = '';
  List<String> data_1 = ['广州市', '韶关市', '深圳市', '珠海区', '汕头市'];
  String selected_2 = '';
  String selected_3 = '';
  List<List<String>> data_3 = [];
  String selected_4 = '组合: ';
  Map data_4 = {
    '广东省': {
      '深圳市': ['南山区', '宝安区', '罗湖区', '福田区'],
      '佛山市': [''],
      '广州市': ['花都区']
    },
    '重庆市': {
      '重庆市': ['九龙坡区', '江北区']
    },
    '浙江省': {
      '杭州市': ['西湖区', '余杭区', '萧山区'],
      '宁波市': ['江东区', '北仑区', '奉化市']
    },
    '香港': {
      '香港': ['九龙城区', '黄大仙区', '离岛区', '湾仔区']
    }
  };

  String selected_5 = '';
  String selected_6 = '';
  String selected_7 = '';
  String selected_8 = '';

  @override
  void initState() {
    var list = <String>[];
    for(var i = 2022; i >= 2000; i--) {
      list.add('${i}年');
    }
    data_3.add(list);
    data_3.add(['春', '夏', '秋', '冬']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(
      title: 'picker组件',
      children: [
        ExampleItem(
            desc: '基础选择器--城市',
            builder: (_) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TDButton(
                      width: 200,
                      content: '选择城市',
                      click: () => TDPicker.showMultiPicker(context, title: '',
                          onConfirm: (selected) {
                        setState(() {
                          selected_1 = '城市: ${data_1[selected[0]]}';
                        });
                      }, data: [data_1], pickerHeight: 168, pickerItemCount: 4),
                    ),
                    TDText(
                      selected_1,
                    ),
                  ]);
            }),
        ExampleItem(desc: '基础选择器--年份和季节', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择年份和季节',
                  click: () => TDPicker.showMultiPicker(context, title: '',
                      onConfirm: (selected) {
                        setState(() {
                          selected_3 =
                          '年份和季节: ${data_3[0][selected[0]]} ${data_3[1][selected[1]]}';
                        });
                      }, data: data_3, initialIndexes: [1, 2]),
                ),
                TDText(
                  selected_3,
                ),
              ]);
        }),
        ExampleItem(desc: '基础选择器--日期', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择日期',
                  click: () => TDPicker.showDatePicker(context, title: '',
                      onConfirm: (selected) {
                        setState(() {
                          selected_2 = '日期: $selected';
                        });
                      },
                      dateStart: [2010, 12, 20],
                      dateEnd: [2022, 2, 28],
                      initialDate: [2012, 1, 1]),
                ),
                TDText(
                  selected_2,
                ),
              ]);
        }),
        ExampleItem(desc: '基础选择器--地区--联动', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '选择地区',
                  click: () => TDPicker.showMultiLinkedPicker(context, title: '',
                      onConfirm: (selected) {
                        setState(() {
                          selected_4 = '组合: ${selected[0]} ${selected[1]} ${selected[2]}';
                        });
                      },
                      pickerHeight: 168,
                      data: data_4,
                      pickerItemCount: 4,
                      columnNum: 3,
                      initialData: ['浙江省', '杭州市', '西湖区']),
                ),
                TDText(
                  selected_4,
                ),
              ]);
        }),
        ExampleItem(
            desc: '带标题--城市',
            builder: (_) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TDButton(
                      width: 200,
                      content: '带标题-选择城市',
                      click: () => TDPicker.showMultiPicker(context, title: '选择城市',
                          onConfirm: (selected) {
                            setState(() {
                              selected_5 = '城市: ${data_1[selected[0]]}';
                            });
                          }, data: [data_1], pickerHeight: 168, pickerItemCount: 4),
                    ),
                    TDText(
                      selected_5,
                    ),
                  ]);
            }),
        ExampleItem(desc: '带标题--年份和四季', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '带标题-年份和季节',
                  click: () => TDPicker.showMultiPicker(context, title: '选择年份和季节',
                      onConfirm: (selected) {
                        setState(() {
                          selected_6 =
                          '年份和季节: ${data_3[0][selected[0]]} ${data_3[1][selected[1]]}';
                        });
                      }, data: data_3, initialIndexes: [1, 2]),
                ),
                TDText(
                  selected_6,
                ),
              ]);
        }),
        ExampleItem(desc: '带标题--日期', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '带标题-选择日期',
                  click: () => TDPicker.showDatePicker(context, title: '选择日期',
                      onConfirm: (selected) {
                        setState(() {
                          selected_7 = '日期: $selected';
                        });
                      },
                      dateStart: [2010, 12, 20],
                      dateEnd: [2022, 2, 28],
                      initialDate: [2012, 1, 1]),
                ),
                TDText(
                  selected_7,
                ),
              ]);
        }),
        ExampleItem(desc: '基础选择器--地区--联动', builder: (_) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDButton(
                  width: 200,
                  content: '带标题-选择地区',
                  click: () => TDPicker.showMultiLinkedPicker(context, title: '选择地区',
                      onConfirm: (selected) {
                        setState(() {
                          selected_8 = '组合: ${selected[0]} ${selected[1]} ${selected[2]}';
                        });
                      },
                      pickerHeight: 168,
                      data: data_4,
                      pickerItemCount: 4,
                      columnNum: 3,
                      initialData: ['浙江省', '杭州市', '西湖区']),
                ),
                TDText(
                  selected_8,
                ),
              ]);
        }),
      ],
    );
  }
}
