import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TDRadio演示
///
class TDRatePage extends StatefulWidget {
  const TDRatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDRatePageState();
  }
}

class TDRatePageState extends State<TDRatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于对某行为/事物进行打分。',
        exampleCodeGroup: 'rate',
        backgroundColor: TDTheme.of(context).grayColor2,
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '实心评分', builder: _buildFilledRate),
            ExampleItem(desc: '自定义评分', builder: _buildCusRate),
            ExampleItem(desc: '自定义评分数量', builder: _buildNumRate),
            ExampleItem(desc: '带描述评分', builder: _buildMsgRate),
            ExampleItem(desc: '评分弹框位置', builder: _buildDRate),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '只可选全星时', builder: _buildFullRate),
            ExampleItem(desc: '可选半星时', builder: _buildHalfRate),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '评分大小', builder: _buildSizeRate),
            ExampleItem(desc: '设置评分颜色', builder: _buildColorRate),
          ]),
        ]);
  }

  @Demo(group: 'rate')
  Widget _buildFilledRate(BuildContext context) {
    return const TDCell(title: '实心评分', noteWidget: TDRate(value: 3));
  }

  @Demo(group: 'rate')
  Widget _buildCusRate(BuildContext context) {
    return const TDCell(title: '自定义评分', noteWidget: TDRate(value: 3, icon: [TDIcons.thumb_up]));
  }

  @Demo(group: 'rate')
  Widget _buildNumRate(BuildContext context) {
    return const TDCell(title: '自定义评分数量', noteWidget: TDRate(value: 2, count: 3,));
  }

  @Demo(group: 'rate')
  Widget _buildMsgRate(BuildContext context) {
    return Column(children: const [
      TDCell(title: '带描述评分', noteWidget: TDRate(value: 3, showText: true, texts: ['很差', '差', '一般', '好评', '优秀'])),
      SizedBox(height: 16),
      TDCell(title: '带描述评分', noteWidget: TDRate(value: 3, showText: true))
    ]);
  }

  @Demo(group: 'rate')
  Widget _buildDRate(BuildContext context) {
    return Column(children: const [
      TDCell(title: '顶部显示', noteWidget: TDRate(placement: PlacementEnum.top)),
      SizedBox(height: 16),
      TDCell(title: '不显示', noteWidget: TDRate(placement: PlacementEnum.none)),
      SizedBox(height: 16),
      TDCell(title: '底部显示', noteWidget: TDRate(placement: PlacementEnum.bottom)),
    ]);
  }

  @Demo(group: 'rate')
  Widget _buildFullRate(BuildContext context) {
    return const TDCell(title: '点击活滑动', noteWidget: TDRate(value: 3));
  }

  @Demo(group: 'rate')
  Widget _buildHalfRate(BuildContext context) {
    return const TDCell(title: '点击活滑动', noteWidget: TDRate(value: 3, allowHalf: true));
  }

  @Demo(group: 'rate')
  Widget _buildSizeRate(BuildContext context) {
    return Column(children: const [
      TDCell(title: '默认尺寸24', noteWidget: TDRate(value: 3)),
      SizedBox(height: 16),
      TDCell(title: '小尺寸20', noteWidget: TDRate(value: 3, size: 20)),
    ]);
  }

  @Demo(group: 'rate')
  Widget _buildColorRate(BuildContext context) {
    return Column(children: const [
      TDCell(title: '填充评分', noteWidget: TDRate(value: 2.5, allowHalf: true, color: [Color(0xFFFFC51C), Color(0xFFE8E8E8)],)),
      SizedBox(height: 16),
      TDCell(title: '线描评分', noteWidget: TDRate(value: 2.5, allowHalf: true, color: [Color(0xFF00A870)])),
    ]);
  }
}
