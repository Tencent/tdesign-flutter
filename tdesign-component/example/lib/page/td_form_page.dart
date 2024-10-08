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

  /// 设置按钮是否可点击状态
  /// true 表示处于 active 状态
  bool horizontalButton = false;
  bool verticalButton = true;

  Color activeButtonColor = Color(0xFFF0F1FD);
  Color defaultButtonColor = Color(0xFFE5E5E5);

  Color verticalTextColor = Color(0xFF1A1A1A);
  Color horizontalTextColor = Color(0xFF0A58D9);
  Color verticalButtonColor = Color(0xFFE5E5E5);
  Color horizontalButtonColor = Color(0xFFF0F1FD);

  Map<String, String> _radios = {"0": "男", "1": "女", "2": "保密"};

  static const List<Map> _data = [
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
        desc: '基础表单',
        backgroundColor: const Color(0xfff6f6f6),
        children: [
          ExampleModule(title: '基础类型', children: [
            ExampleItem(desc: '基础表单', builder: _buildArrangementSwitch),
            ExampleItem(desc: '', builder: _buildSwitchWithBase),
            ExampleItem(builder: (BuildContext context) {
              return CodeWrapper(builder: _buildForm);
            })
          ]),
        ]);
  }

  @Demo(group: 'form')
  Widget _buildForm(BuildContext context) {
    return TDForm(items: [
      TDFormItem(
        label: '用户名',
        name: 'name',
        help: '请输入用户名',
        additionInfo: '输入用户名',
        inputPadding: 15.0,
        controller: controller[0],
      ),
      TDFormItem(
        label: '密码',
        name: 'password',
        help: '请输入密码',
        inputPadding: 35.0,
        controller: controller[1],
      ),
      TDFormItem(
        label: '性别',
        name: 'radios',

        /// 扩展一下数量和选项内容
        radios: _radios,
      ),
      TDFormItem(
        label: '生日',
        name: 'date',

        /// 引入需要的日期数据
        select: selected_1,
      ),
      TDFormItem(
        label: '籍贯',
        name: 'local',

        /// 引入需要的地点数据
        localData: _data,
      ),
      TDFormItem(
        label: '年限',
        name: 'age',

        /// 为 TDStepper 预留其他设置
      ),
      TDFormItem(
        label: '个人简介',
        name: 'textarea',
        help: '请输入个人简介',
        controller: controller[2],

        /// 为 TDTextarea 长文本其他参数做预留 API
        maxLength: 500,
        indicator: true,
      )
    ], disabled: false);
  }

  /// 横 竖 排版模式切换
  @Demo(group: 'form')
  Widget _buildArrangementSwitch(BuildContext buildContext) {
    final theme = TDTheme.of(context);
    return Container(
        decoration: BoxDecoration(
          color: theme.whiteColor1,
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TDButton(
                    text: '水平排布',
                    shape: TDButtonShape.round,
                    style:
                        TDButtonStyle(backgroundColor: horizontalButtonColor),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: horizontalTextColor,
                    ),
                    onTap: () {
                      setState(() {
                        if (horizontalButton) {
                          /// 置换按钮状态
                          horizontalButton = false;
                          verticalButton = true;

                          /// 置换按钮颜色
                          final currentVerticalColor = verticalButtonColor;
                          verticalButtonColor = horizontalButtonColor;
                          horizontalButtonColor = currentVerticalColor;

                          /// 置换文字颜色
                          final currentTextColor = verticalTextColor;
                          verticalTextColor = horizontalTextColor;
                          horizontalTextColor = currentTextColor;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TDButton(
                    text: '竖直排布',
                    shape: TDButtonShape.round,
                    style: TDButtonStyle(backgroundColor: verticalButtonColor),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: verticalTextColor,
                    ),
                    onTap: () {
                      setState(() {
                        if (verticalButton) {
                          /// 置换按钮状态
                          horizontalButton = true;
                          verticalButton = false;

                          /// 置换按钮颜色
                          final currentVerticalColor = verticalButtonColor;
                          verticalButtonColor = horizontalButtonColor;
                          horizontalButtonColor = currentVerticalColor;

                          /// 置换文字颜色
                          final currentTextColor = verticalTextColor;
                          verticalTextColor = horizontalTextColor;
                          horizontalTextColor = currentTextColor;
                        }
                      });
                    },
                  ),
                ),
              ],
            )));
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
      padding: const EdgeInsets.symmetric(vertical: 1),
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
