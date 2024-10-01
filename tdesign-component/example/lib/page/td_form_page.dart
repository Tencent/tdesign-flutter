import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDFormPage extends StatefulWidget {
  const TDFormPage({Key? key}) : super(key: key);

  @override
  _TDFormPageState createState() => _TDFormPageState();
}

class _TDFormPageState extends State<TDFormPage> {

  var controller = [];
  String selected_1 = '';
  List<Map> _data = [
    {
      "label": '北京市',
      "value": '110000',
      "children": [
        {
          "value": '110100',
          "label": '北京市',
          "children": [
            {"value": '110101', "label": '东城区'},
            {"value": '1101022', "label": '东区'},
            {"value": '110102', "label": '西城区'},
            {"value": '110105', "label": '朝阳区'},
            {"value": '110106', "label": '丰台区'},
            {"value": '110107', "label": '石景山区'},
            {"value": '110108', "label": '海淀区'},
            {"value": '110109', "label": '门头沟区'},
          ],
        },
      ],
    },
    {
      "label": '天津市',
      "value": '120000',
      "children": [
        {
          "value": '120100',
          "label": '天津市',
          "children": [
            {
              "value": '120101',
              "label": '和平区',
            },
            {
              "value": '120102',
              "label": '河东区',
            },
            {
              "value": '120103',
              "label": '河西区',
            },
            {
              "value": '120104',
              "label": '南开区',
            },
            {
              "value": '120105',
              "label": '河北区',
            },
            {
              "value": '120106',
              "label": '红桥区',
            },
            {
              "value": '120110',
              "label": '东丽区',
            },
            {
              "value": '120111',
              "label": '西青区',
            },
            {
              "value": '120112',
              "label": '津南区',
            },
          ],
        },
      ],
    },
  ];

  @override
  void initState() {
    for (var i = 0; i < 28; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'form',
      backgroundColor: const Color(0xfff6f6f6),
      children: [
        ExampleModule(title: '禁用态开关', children: [
          ExampleItem(desc: '基础开关', builder: _buildSwitchWithBase),
        ]),
        ExampleModule(title: 'Form', children: [
          ExampleItem(desc: '', builder: _buildUserNameItem),
          ExampleItem(desc: '', builder: _buildPassWordItem),
          ExampleItem(desc: '', builder: _buildhorizontalRadiosItem),
          ExampleItem(desc: '', builder: _buildDateItem),
          ExampleItem(desc: '', builder: _buildCascaderItem),
          ExampleItem(desc: '', builder: _buildStepperItem),
        ]),
      ],
    );
  }

  @Demo(group: 'form')
  Widget _buildUserNameItem(BuildContext buildContext) {
    return TDFormItem(
      label: '用户名',
      name: 'name',
      help: '请输入用户名',
      controller: controller[0],
    );
  }

  @Demo(group: 'form')
  Widget _buildPassWordItem(BuildContext buildContext) {
    return TDFormItem(
      label: '密码',
      name: 'password',
      help: '请输入密码',
      controller: controller[1],
    );
  }

  @Demo(group: 'form')
  Widget _buildhorizontalRadiosItem(BuildContext buildContext) {
    return TDFormItem(
      label: '性别',
      name: 'gender',
      /// 扩展一下数量和选项内容
    );
  }

  @Demo(group: 'form')
  Widget _buildDateItem(BuildContext buildContext){
    return TDFormItem(
      label: '生日',
      name: 'date',
      /// 引入需要的日期数据
      select: selected_1,
    );
  }

  @Demo(group: 'form')
  Widget _buildCascaderItem(BuildContext buildContext){
    return TDFormItem(
      label: '籍贯',
      name: 'local',
      /// 引入需要的地点数据
      localData: _data,
    );
  }

  @Demo(group: 'form')
  Widget _buildStepperItem(BuildContext buildContext){
    return TDFormItem(
      label: '年限',
      name: 'age',
      /// 为 TDStepper 预留其他设置
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithBase(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(),
      title: '禁用态',
    );
  }

  /// 每一项的封装
  @Demo(group: 'switch')
  Widget _buildItem(BuildContext context, Widget switchItem,
      {String? title, String? desc}) {
    final theme = TDTheme.of(context);
    Widget current = Row(
      children: [
        Expanded(
            child: TDText(
              title ?? '',
              textColor: theme.fontGyColor1,
            )),
        TDText(
          desc ?? '',
          textColor: theme.grayColor6,
        ),
        SizedBox(child: switchItem)
      ],
    );
    current = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: current,
          ),
          color: Colors.white,
        ),
        height: 56,
      ),
    );
    return Column(mainAxisSize: MainAxisSize.min, children: [current]);
  }
}


