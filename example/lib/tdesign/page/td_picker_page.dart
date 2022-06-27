import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class TdPickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdPickerPageState();
}

class _TdPickerPageState extends State<TdPickerPage> {
  String selected_1 = '渠道: ';
  List<String> data_1 = ['安卓 手Q', 'IOS 手Q', '安卓 微信', 'IOS 微信'];
  String selected_2 = '时间: ';
  String selected_3 = '组合: ';
  List<List<String>> data_3 = [
    ['A', 'B', 'C'],
    ['a', 'b', 'c'],
    ['1', '2', '3']
  ];
  String selected_4 = '组合: ';
  Map data_4 = {
    '广东省':{
      '深圳市':['南山区', '宝安区', '罗湖区', '福田区'],
      '佛山市':[''],
      '广州市':['花都区']},
    '重庆市':{
      '重庆市':['九龙坡区', '江北区']
    },
    '浙江省':{
      '杭州市':['西湖区', '余杭区', '萧山区'],
      '宁波市':['江东区', '北仑区', '奉化市']
    },
    '香港':{
      '香港':['九龙城区', '黄大仙区', '离岛区', '湾仔区']
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('picker组件'),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TDButton(
            width: 200,
            content: '单项选择测试',
            click: () => TDPicker.showMultiPicker(context, title: '选择渠道',
                onConfirm: (selected) {
              setState(() {
                selected_1 = '渠道: ${data_1[selected[0]]}';
              });
            }, data: [data_1], pickerHeight: 168, pickerItemCount: 4),
          ),
          TDText(
            selected_1,
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          TDButton(
            width: 200,
            content: '时间选择测试',
            click: () => TDPicker.showDatePicker(context, title: '选择时间',
                onConfirm: (selected) {
              setState(() {
                selected_2 = '时间: $selected';
              });
            }, dateStart: [2010, 12, 20], dateEnd: [2022, 2, 28],initialDate: [2012,1,1]),
          ),
          TDText(
            selected_2,
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          TDButton(
            width: 200,
            content: '多项选择测试',
            click: () => TDPicker.showMultiPicker(context, title: '选择组合',
                onConfirm: (selected) {
              setState(() {
                selected_3 =
                    '组合: ${data_3[0][selected[0]]} ${data_3[1][selected[1]]} ${data_3[2][selected[2]]}';
              });
            }, data: data_3, initialIndexes: [1, 2, 0]),
          ),
          TDText(
            selected_3,
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          TDButton(
            width: 200,
            content: '多项联动选择测试',
            click: () => TDPicker.showMultiLinkedPicker(context, title: '选择组合',
                onConfirm: (selected) {
              setState(() {
                selected_4 =
                    '组合: ${selected[0]} ${selected[1]} ${selected[2]}';
              });
            },
                pickerHeight: 168,
                data: data_4,
                pickerItemCount: 4, columnNum: 3, initialData: ['浙江省','杭州市','西湖区']),
          ),
          TDText(
            selected_4,
          ),
        ])));
  }
}
