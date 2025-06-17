import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDPickerPage extends StatefulWidget {
  const TDPickerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDPickerPageState();
}

class _TDPickerPageState extends State<TDPickerPage> {
  String selected_1 = '';
  List<String> data_1 = ['广州市', '韶关市', '深圳市', '珠海区', '汕头市'];
  String selected_2 = '';
  String selected_3 = '';
  List<List<String>> data_2 = [];
  String selected_4 = '';
  Map data_3 = {
    '广东省': {
      '深圳市': ['南山区南山区南山区南山区南山区', '宝安区', '罗湖区', '福田区'],
      '佛山市': [''],
      '广州市广州市广州市广州市广州市广州市广州市广州市广州市广州市广州市': ['花都区']
    },
    '重庆市': {
      '重庆市重庆市重庆市重庆市重庆市重庆市重庆市': ['九龙坡区', '江北区']
    },
    '浙江省浙江省浙江省浙江省浙江省浙江省浙江省浙江省': {
      '杭州市': ['西湖区', '余杭区', '萧山区'],
      '宁波市': ['江东区', '北仑区', '奉化市']
    },
    '香港': {
      '香港': ['九龙城区', '黄大仙区', '离岛区', '湾仔区']
    }
  };

  String selected_5 = '';

  @override
  void initState() {
    var list = <String>[];
    for (var i = 2022; i >= 2000; i--) {
      list.add('${i}年');
    }
    data_2.add(list);
    data_2.add(['春', '夏', '秋', '冬']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于一组预设数据中的选择。',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础选择器--地区', builder: buildArea),
            ExampleItem(desc: '基础选择器--时间', builder: buildTime),
            ExampleItem(desc: '基础选择器--地区--联动', builder: buildMultiArea),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '带标题选择器', builder: buildAreaWithTitle),
            ExampleItem(desc: '无标题选择器', builder: buildAreaWithoutTitle),
          ],
        )
      ],
      test: [
        ExampleItem(desc: '自定义left/right text', builder: buildCustomLeftRightText),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildArea(BuildContext context) {
    const title = '选择地区';
    return TDCell(
        title: title,
        note: selected_1,
        arrow: true,
        onClick: (click) {
          TDPicker.showMultiPicker(context, title: title, onConfirm: (selected) {
            setState(() {
              selected_1 = '${data_1[selected[0]]}';
            });
            Navigator.of(context).pop();
          }, data: [data_1]);
        });
  }

  @Demo(group: 'picker')
  Widget buildTime(BuildContext context) {
    const title = '选择时间';
    return TDCell(
        title: title,
        note: selected_2,
        arrow: true,
        onClick: (click) {
          TDPicker.showMultiPicker(context, title: title, onConfirm: (selected) {
            setState(() {
              selected_2 = '${data_2[0][selected[0]]} ${data_2[1][selected[1]]}';
            });
            Navigator.of(context).pop();
          }, data: data_2);
        });
  }

  @Demo(group: 'picker')
  Widget buildMultiArea(BuildContext context) {
    const title = '选择地区';
    return TDCell(
        title: title,
        note: selected_3,
        arrow: true,
        onClick: (click) {
          TDPicker.showMultiLinkedPicker(context, title: title, onConfirm: (selected) {
            setState(() {
              selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
            });
            Navigator.of(context).pop();
          }, data: data_3, columnNum: 3, initialData: ['浙江省', '杭州市', '西湖区']);
        });
  }

  @Demo(group: 'picker')
  Widget buildAreaWithTitle(BuildContext context) {
    const title = '选择地区';
    return TDCell(
        title: title,
        note: selected_4,
        arrow: true,
        onClick: (click) {
          TDPicker.showMultiPicker(context, title: '带标题选择器', onConfirm: (selected) {
            setState(() {
              selected_4 = '${data_1[selected[0]]}';
            });
            Navigator.of(context).pop();
          }, data: [data_1]);
        });
  }

  @Demo(group: 'picker')
  Widget buildAreaWithoutTitle(BuildContext context) {
    return TDCell(
        title: '选择地区',
        note: selected_5,
        arrow: true,
        onClick: (click) {
          TDPicker.showMultiPicker(context, title: '', onConfirm: (selected) {
            setState(() {
              selected_5 = '${data_1[selected[0]]}';
            });
            Navigator.of(context).pop();
          }, data: [data_1]);
        });
  }

  @Demo(group: 'picker')
  Widget buildCustomLeftRightText(BuildContext context) {
    return TDCellGroup(
      cells: [
        TDCell(
            title: '基础选择器',
            note: selected_5,
            arrow: true,
            onClick: (click) {
              TDPicker.showMultiPicker(context,
                  leftText: '自定义取消', rightText: '自定义确认', title: '基础选择器', onConfirm: (selected) {
                setState(() {
                  selected_5 = '${data_1[selected[0]]}';
                });
                Navigator.of(context).pop();
              }, data: [data_1]);
            }),
        TDCell(
            title: '联动选择器',
            note: selected_3,
            arrow: true,
            onClick: (click) {
              TDPicker.showMultiLinkedPicker(context,
                  leftText: '自定义取消', rightText: '自定义确认', title: '联动选择器', onConfirm: (selected) {
                setState(() {
                  selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
                });
                Navigator.of(context).pop();
              }, data: data_3, columnNum: 3, initialData: ['浙江省', '杭州市', '西湖区']);
            })
      ],
    );
  }
}
