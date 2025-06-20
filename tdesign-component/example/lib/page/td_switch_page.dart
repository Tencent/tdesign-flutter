import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TdSwitchPage演示
///
class TDSwitchPage extends StatefulWidget {
  const TDSwitchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDSwitchPageState();
  }
}

class TDSwitchPageState extends State<TDSwitchPage> {
  @override
  Widget build(BuildContext context) {
    var current = ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'switch',
      desc: '用于控制某个功能的开启和关闭。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础开关', builder: _buildSwitchWithBase),
            ExampleItem(desc: '带描述开关', builder: _buildSwitchWithText),
            ExampleItem(builder: _buildSwitchWithIcon),
            ExampleItem(desc: '自定义颜色开关', builder: _buildSwitchWithColor),
          ],
        ),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '加载状态', builder: _buildSwitchWithLoadingOff),
          ExampleItem(builder: _buildSwitchWithLoadingOn),
          ExampleItem(desc: '禁用状态', builder: _buildSwitchWithDisableOff),
          ExampleItem(builder: _buildSwitchWithDisableOn),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '开关尺寸', builder: _buildSwitchWithSizeLarge),
          ExampleItem(builder: _buildSwitchWithSizeMed),
          ExampleItem(builder: _buildSwitchWithSizeSmall),
        ]),
      ],
      test: [
        ExampleItem(desc: '自定义开关文案-通常只支持一个字符,超出部分无法展示', builder: _customText),
        ExampleItem(desc: '自定义带文字开关的字体大小', builder: _customTextFont),
      ],
    );
    return current;
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithBase(BuildContext context) {
    return const TDCell(
      title: '基础开关',
      noteWidget: TDSwitch(),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithText(BuildContext context) {
    return const TDCell(
      title: '带文字开关',
      noteWidget: TDSwitch(isOn: true, type: TDSwitchType.text),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithIcon(BuildContext context) {
    return const TDCell(
      title: '带图标开关',
      noteWidget: TDSwitch(isOn: true, type: TDSwitchType.icon),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithColor(BuildContext context) {
    return const TDCell(
      title: '自定义颜色开关',
      noteWidget: TDSwitch(isOn: true, trackOnColor: Colors.green),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithLoadingOff(BuildContext context) {
    return const TDCell(
      title: '加载状态',
      noteWidget: TDSwitch(isOn: false, type: TDSwitchType.loading),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithLoadingOn(BuildContext context) {
    return const TDCell(
      title: '加载状态',
      noteWidget: TDSwitch(isOn: true, type: TDSwitchType.loading),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithDisableOff(BuildContext context) {
    return const TDCell(
      title: '禁用状态',
      noteWidget: TDSwitch(
        enable: false,
        isOn: false,
      ),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithDisableOn(BuildContext context) {
    return const TDCell(
      title: '禁用状态',
      noteWidget: TDSwitch(
        enable: false,
        isOn: true,
      ),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithSizeLarge(BuildContext context) {
    return const TDCell(
      title: '大尺寸32',
      noteWidget: TDSwitch(
        size: TDSwitchSize.large,
        isOn: true,
      ),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithSizeMed(BuildContext context) {
    return const TDCell(
      title: '中尺寸28',
      noteWidget: TDSwitch(
        size: TDSwitchSize.medium,
        isOn: true,
      ),
    );
  }

  @Demo(group: 'switch')
  Widget _buildSwitchWithSizeSmall(BuildContext context) {
    return const TDCell(
      title: '小尺寸24',
      noteWidget: TDSwitch(
        size: TDSwitchSize.small,
        isOn: true,
      ),
    );
  }

  @Demo(group: 'switch')
  Widget _customText(BuildContext context) {
    return const TDCell(
      title: '基础开关',
      noteWidget: TDSwitch(
        type: TDSwitchType.text,
        openText: '1111',
        closeText: '—',
      ),
    );
  }

  @Demo(group: 'switch')
  Widget _customTextFont(BuildContext context) {
    return const TDCell(
      title: '基础开关',
      noteWidget: TDSwitch(
        type: TDSwitchType.text,
        openText: '开',
        closeText: '关',
        thumbContentOffColor: Colors.red,
        thumbContentOnColor: Colors.green,
        thumbContentOnFont: TextStyle(fontSize: 18),
        thumbContentOffFont: TextStyle(fontSize: 12),
      ),
    );
  }
}
