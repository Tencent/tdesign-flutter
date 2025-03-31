import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDCascaderPage extends StatefulWidget {
  const TDCascaderPage({super.key});

  @override
  State<TDCascaderPage> createState() => _TDCascaderPageState();
}

class _TDCascaderPageState extends State<TDCascaderPage> {
  String? _initData;
  String _selected_1 = '';
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

  String? _initData_2;
  String _selected_2 = '';
  List<Map> _data_2 = [
    {
      "label": '北京市',
      "value": '110000',
      "segmentValue": 'B',
      "children": [
        {
          "value": '110100',
          "label": '北京市',
          "segmentValue": 'B',
          "children": [
            {
              "value": '110101',
              "label": '东城区',
              "segmentValue": 'D',
            },
            {"value": '1101022', "label": '东区', "segmentValue": 'D'},
            {"value": '110102', "label": '西城区', "segmentValue": 'X'},
            {"value": '110105', "label": '朝阳区', "segmentValue": 'C'},
            {"value": '110106', "label": '丰台区', "segmentValue": 'F'},
            {"value": '110107', "label": '石景山区', "segmentValue": 'S'},
            {"value": '110108', "label": '海淀区', "segmentValue": 'H'},
            {"value": '110109', "label": '门头沟区', "segmentValue": 'M'},
          ],
        },
      ],
    },
    {
      "label": '天津市',
      "value": '120000',
      "segmentValue": 'T',
      "children": [
        {
          "value": '120100',
          "label": '天津市',
          "segmentValue": 'T',
          "children": [
            {
              "value": '120101',
              "label": '和平区',
              "segmentValue": 'H',
            },
            {"value": '120102', "label": '河东区', "segmentValue": 'H'},
            {"value": '120103', "label": '河西区', "segmentValue": 'H'},
            {"value": '120104', "label": '南开区', "segmentValue": 'N'},
            {"value": '120105', "label": '河北区', "segmentValue": 'H'},
            {"value": '120106', "label": '红桥区', "segmentValue": 'H'},
            {"value": '120110', "label": '东丽区', "segmentValue": 'D'},
            {"value": '120111', "label": '西青区', "segmentValue": 'X'},
            {"value": '120112', "label": '津南区', "segmentValue": 'J'},
          ],
        },
      ],
    },
  ];

  String? _initData_3;
  String _selected_3 = '';
  final List<Map> _data_3 = [
    {
      "label": '技术部门',
      "value": '110000',
      "segmentValue": 'J',
      "children": [
        {
          "value": '110100',
          "label": '部门一',
          "segmentValue": 'B',
          "children": [
            {"value": '110101', "label": '洪磊', "segmentValue": 'H'},
            {"value": '110102', "label": '洪磊2', "segmentValue": 'H'},
            {"value": '1101022', "label": '洪磊3', "segmentValue": 'H'},
            {"value": '110105', "label": '洪磊4', "segmentValue": 'H'},
            {"value": '110106', "label": '郭天1', "segmentValue": 'G'},
            {"value": '110107', "label": '郭天2', "segmentValue": 'G'},
            {"value": '110109', "label": '冯笑1', "segmentValue": 'F'},
            {"value": '110108', "label": '郭天3', "segmentValue": 'G'},
          ],
        },
        {
          "value": '110200',
          "label": '部门二',
          "segmentValue": 'B',
          "children": [
            {"value": '110201', "label": '洪磊', "segmentValue": 'H'},
            {"value": '110205', "label": '洪磊4', "segmentValue": 'H'},
            {"value": '110206', "label": '郭天1', "segmentValue": 'G'},
            {"value": '110207', "label": '郭天2', "segmentValue": 'G'},
            {"value": '110208', "label": '郭天3', "segmentValue": 'G'},
            {"value": '110209', "label": '冯笑1', "segmentValue": 'F'},
            {"value": '110202', "label": '洪磊2', "segmentValue": 'H'},
            {"value": '1102022', "label": '洪磊3', "segmentValue": 'H'},
          ],
        },
      ],
    },
    {
      "label": '行政部门',
      "value": '120000',
      "segmentValue": 'X',
      "children": [
        {
          "value": '120100',
          "label": '部门一',
          "segmentValue": 'B',
          "children": [
            {"value": '120201', "label": '洪磊', "segmentValue": 'H'},
            {"value": '120205', "label": '洪磊4', "segmentValue": 'H'},
            {"value": '120206', "label": '郭天1', "segmentValue": 'G'},
            {"value": '120207', "label": '郭天2', "segmentValue": 'G'},
            {"value": '120208', "label": '郭天3', "segmentValue": 'G'},
            {"value": '120209', "label": '冯笑1', "segmentValue": 'F'},
            {"value": '120202', "label": '洪磊2', "segmentValue": 'H'},
            {"value": '1202022', "label": '洪磊3', "segmentValue": 'H'},
          ],
        },
      ],
    },
  ];

  String? _initData_4;
  String _selected_4 = '';
  final List<Map> _data_4 = [
    {
      "label": '技术部门',
      "value": '110000',
      "children": [
        {
          "value": '110100',
          "label": '部门一',
          "children": [
            {"value": '110201', "label": '后勤部门', "children":[
              {
                "value": '110301', "label": '后勤A组',"children":[
                  {
                  "value": '110401', "label": '一组',"children":[
                    {"value": '110501', "label": '洪磊',},
                    {"value": '110502', "label": '洪磊2'},
                    {"value": '110506', "label": '郭天1'},
                    {"value": '110507', "label": '郭天2'},
                    {"value": '110508', "label": '郭天3'},
                    {"value": '110509', "label": '冯笑1'},
                    {"value": '1105022', "label": '洪磊3'},
                    {"value": '110505', "label": '洪磊4'},
                   ]
                }
                ]
              }
            ]},
          ],
        },
        {
          "value": '120100',
          "label": '部门二',
          "children": [
            {"value": '120201', "label": '后勤部门', "children":[
              {
                "value": '120301', "label": '后勤A组',"children":[
                {
                  "value": '120401', "label": '一组',"children":[
                  {"value": '120501', "label": '张雷1'},
                  {"value": '120502', "label": '张雷2'},
                  {"value": '1205022', "label": '张雷3'},
                  {"value": '120505', "label": '张雷4'},
                  {"value": '120506', "label": '张雷5'},
                  {"value": '120507', "label": '张雷6'},
                  {"value": '120508', "label": '张雷7'},
                  {"value": '120509', "label": '张雷8'},
                ]
                }
              ]
              }
            ]},
          ],
        },
      ],
    },
  ];

  String? _initData_5;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      child: ExamplePage(
        title: tdTitle(),
        exampleCodeGroup: 'cascader',
        desc: '用于多层级数据的逐级选择',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '垂直级联选择器', builder: _buildVerticalCascader),
            ExampleItem(desc: '垂直级联选择器-带字母定位', builder: _buildVerticalLetterCascader),
            ExampleItem(desc: '水平级联选择器', builder: _buildHorizontalCascader),
            ExampleItem(desc: '水平级联选择器-带字母定位', builder: _buildHorizontalLetterCascader),
            ExampleItem(desc: '水平级联选择器-部门', builder: _buildHorizontalCompanyCascader),
            ExampleItem(desc: '垂直级联选择器-部门', builder: _buildVerticalCompanyCascader),
          ]),
        ],
        test: [
          ExampleItem(desc: '测试使用次标题', builder: _buildVerticalSubTitleCascader),
          ExampleItem(desc: '垂直级联选择器-部门', builder: _buildTestVerticalCompanyCascader),
        ],
      ),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildVerticalCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择地址', data: _data, initialData: _initData, theme: 'step',
            onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_1 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_1, '选择地区'),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildVerticalLetterCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择地址', data: _data_2, initialData: _initData_2, theme: 'step',
            onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_2 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_2 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_2, '选择地区'),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildHorizontalCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context,
            title: '选择地址',
            subTitles: ['请选择省份', '请选择城市', '请选择区/县'],
            data: _data,
            initialData: _initData,
            theme: 'tab', onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_1 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_1, '选择地区'),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildHorizontalLetterCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context,
            title: '选择地址',
            data: _data_2,
            initialData: _initData_2,
            isLetterSort: true,
            theme: 'tab', onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_2 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_2 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_2, '选择地区'),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildHorizontalCompanyCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择部门人员', data: _data_3,isLetterSort: true, initialData: _initData_3, theme: 'tab',
            onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_3 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_3 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_3, '选择部门人员'),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildVerticalCompanyCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context, title: '选择部门人员', data: _data_3,isLetterSort: true, initialData: _initData_3, theme: 'step',
            onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_3 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_3 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_3, '选择部门人员'),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildVerticalSubTitleCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context,
            title: '选择地址',
            subTitles: ['请选择省份', '请选择城市', '请选择区/县'],
            data: _data,
            initialData: _initData_4,
            theme: 'tab', onChange: (List<MultiCascaderListModel> selectData) {
          setState(() {
            List result = [];
            int len = selectData.length;
            _initData_4 = selectData[len - 1].value!;
            selectData.forEach((element) {
              result.add(element.label);
            });
            _selected_1 = result.join('/');
          });
        }, onClose: () {
          Navigator.of(context).pop();
        });
      },
      child: _buildSelectRow(context, _selected_1, '选择地区'),
    );
  }
  @Demo(group: 'cascader')
  Widget _buildTestVerticalCompanyCascader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TDCascader.showMultiCascader(context,
            title: '选择部门人员',
            data: _data_4,
            initialData: _initData_5,
            theme: 'step', onChange: (List<MultiCascaderListModel> selectData) {
              setState(() {
                List result = [];
                int len = selectData.length;
                _initData_5 = selectData[len - 1].value!;
                selectData.forEach((element) {
                  result.add(element.label);
                });
                _selected_4 = result.join('/');
              });
            }, onClose: () {
              Navigator.of(context).pop();
            });
      },
      child: _buildSelectRow(context, _selected_4, '选择部门人员'),
    );
  }
  Widget _buildSelectRow(BuildContext context, String output, String title) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: TDText(
                  title,
                  font: TDTheme.of(context).fontBodyLarge,
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TDText(
                      output,
                      font: TDTheme.of(context).fontBodyLarge,
                      textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        TDIcons.chevron_right,
                        color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
          const TDDivider(
            margin: EdgeInsets.only(
              left: 16,
            ),
          )
        ],
      ),
    );
  }
}
