import 'package:flutter/material.dart';

import 'package:tdesign_flutter/tdesign_flutter.dart';

class TPickerPage extends StatefulWidget {
  const TPickerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TPickerPageState();
}

class _TPickerPageState extends State<TPickerPage> {
  String selected_1 = '';
  final data_1 = [
    [TPickerOption(label: '广州市', value: 'GZ'),
      TPickerOption(label: '韶关市', value: 'SG'),
      TPickerOption(label: '深圳市', value: 'SZ'),
      TPickerOption(label: '珠海区', value: 'ZH'),
      TPickerOption(label: '汕头市', value: 'ST'),
    ],
  ];
  
  String selected_2 = '';
  final data_2 = [
    [TPickerOption(label: '春', value: 'spring'), TPickerOption(label: '夏', value: 'summer')],
    [TPickerOption(label: '秋', value: 'autumn'), TPickerOption(label: '冬', value: 'winter')],
  ];

  // 联动数据
  final linkedData = {
    TPickerOption(label: '广东省', value: 'GD'): {
      TPickerOption(label: '深圳市', value: 'SZ'): [
        TPickerOption(label: '南山区', value: 'NS'),
        TPickerOption(label: '福田区', value: 'FT'),
        TPickerOption(label: '宝安区', value: 'BA'),
        TPickerOption(label: '罗湖区', value: 'LH'),
        TPickerOption(label: '龙岗区', value: 'LG'),
      ],
      TPickerOption(label: '广州市', value: 'GZ'): [
        TPickerOption(label: '天河区', value: 'TH'),
        TPickerOption(label: '越秀区', value: 'YX'),
        TPickerOption(label: '白云区', value: 'BY'),
        TPickerOption(label: '花都区', value: 'HD'),
      ],
      TPickerOption(label: '佛山市', value: 'FS'): [
        TPickerOption(label: '顺德区', value: 'SD'),
        TPickerOption(label: '南海区', 'value': 'NH'),
        TPickerOption(label: '禅城区', value: 'CC'),
      ],
    },
    TPickerOption(label: '浙江省', value: 'ZJ'): {
      TPickerOption(label: '杭州市', value: 'HZ'): [
        TPickerOption(label: '西湖区', value: 'XH'),
        TPickerOption(label: '余杭区', value: 'YH'),
        TPickerOption(label: '萧山区', value: 'XS'),
      ],
      TPickerOption(label: '宁波市', value: 'NB'): [
        TPickerOption(label: '江东区', value: 'JD'),
        TPickerOption(label: '北仑区', value: 'BL'),
      ],
    },
  };

  // disabled 数据
  final disabledData = [
    [TPickerOption(label: '男', value: 'M'), TPickerOption(label: '女', value: 'F')],
    [TPickerOption(label: '<18岁', value: 0, disabled: true), TPickerOption(label: '18岁', value: 18),
    TPickerOption(label: '25岁', value: 25), TPickerOption(label: '30岁', value: 30)],
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '纯滚轮选择器组件，支持多列独立和联动两种模式',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '单列选择', builder: _buildSingleColumn),
          ExampleItem(desc: '多列独立选择', builder: _buildMultiColumn),
          ExampleItem(desc: '联动选择(省市区)', builder: _buildLinked),
          ExampleItem(desc: '带 disabled 选项', builder: _buildDisabled),
        ]),
        ExampleModule(title: '嵌入页面/弹窗', children: [
          ExampleItem(desc: '嵌入页面', builder: _buildEmbedded),
          ExampleItem(desc: '弹窗模式', builder: _buildPopup),
        ]),
      ],
    );
  }

  /// 标题栏
  Widget _buildHeader(BuildContext context, {required String title, VoidCallback? onConfirm, VoidCallback? onCancel}) {
    return Padding(
      padding: EdgeInsets.all(TTheme.of(context).spacer16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onCancel?.call(),
            child: Text('取消', style: TextStyle(color: TTheme.of(context).textColorSecondary)),
          ),
          Expanded(child: Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600))),
          GestureDetector(
            onTap: () => onConfirm?.call(),
            child: Text('确认', style: TextStyle(color: TTheme.of(context).brandNormalColor)),
          ),
        ],
      ),
    );
  }

  /// 弹窗展示
  void _showInPopup(BuildContext context, {required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: TTheme.of(context).bgColorContainer,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TTheme.of(context).radiusExtraLarge),
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }

  // ========== 基础用法示例 ==========
  
  @Demo(group: 'picker')
  Widget buildSingleColumn(BuildContext context) {
    return TCell(
      title: '单列选择',
      note: selected_1.isEmpty ? '请选择' : selected_1,
      arrow: true,
      onClick: (click) => _showInPopup(context, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(context, title: '选择城市', onConfirm: () => Navigator.pop(context)), 
          TPicker(items: data_1, onChange: (v) => setState(() => selected_1 = v.values.first.toString())),
        ],
      )),
    );
  }
  
  @Demo(group: 'picker')
  Widget buildMultiColumn(BuildContext context) {
    return TCell(
      title: '多列独立选择（性别 + 年龄）',
      note: selected_2.isEmpty ? '请选择' : selected_2,
      arrow: true,
      onClick: (click) => _showInPopup(context, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(context, title: '选择信息', onConfirm: () => Navigator.pop(context)), 
          TPicker(
            items: disabledData,
            initialValue: ['M', 25],
            onChange: (v) => setState(() => selected_2 = '${v.values.first} ${v.values.last}'),
          ),
        ],
      )),
    );
  }

  @Demo(group: 'picker')
  Widget buildLinked(BuildContext context) {
    return TCell(
      title: '联动选择（省市区）',
      note: '',
      arrow: true,
      onClick: (click) => _showInPopup(context, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(context, title: '请选择地区', onConfirm: () => Navigator.pop(context)), 
          TPicker(
            items: linkedData,
            initialValue: ['GD'],
            onChange: (v) => print('选中: ${v.values}'),
          ),
        ],
      )),
    );
  }

  @Demo(group: 'picker')
  Widget buildDisabled(BuildContext context) {
    return TCell(
      title: '带禁用项的选择器',
      note: '<18岁 显示但不可选',
      arrow: true,
      onClick: (click) => _showInPopup(context, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(context, title: '选择年龄', onConfirm: () => Navigator.pop(context)), 
          TPicker(
            items: disabledData,
            initialValue: ['M'],  // 默认选 "男"
            onChange: (v) => print('选中: ${v.values}'),
          ),
        ],
      )),
    );
  }

  // ========== 嵌入页面/弹窗示例 ==========
  
  @Demo(group: 'picker')
  Widget buildEmbedded(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('嵌入页面的选择器：', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: TTheme.of(context).bgColorContainer,
            borderRadius: BorderRadius.circular(TTheme.of(context).radiusMedium),
          ),
          child: TPicker(
            items: data_1,
            onChange: (v) => debugPrint('选中: $v'),
          ),
        ),
        SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: TTheme.of(context).bgColorContainer,
            borderRadius: BorderRadius.circular(TTheme.of(context).radiusMedium),
          ),
          child: TPicker(
            items: linkedData,
            initialValue: ['GD', 'SZ'],
            onChange: (v) => debugPrint('选中: ${v.values}'),
          ),
        ),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildPopup(BuildContext context) {
    return TCell(
      title: '弹窗模式',
      note: '点击弹出，确认后关闭',
      arrow: true,
      onClick: (click) => _showInPopup(context, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(context, title: '选择地区', onConfirm: () => Navigator.pop(context)), 
          TPicker(
            items: linkedData,
            initialValue: ['GD', 'SZ', 'NS'],
            onChange: (v) => print('选中: ${v.values}'),
          ),
        ],
      )),
    );
  }
}
