import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_widget.dart';

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
    Widget current = ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _title('基础开关'),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              demoRow(context, '开关', on: true),
              _divider(),
              demoRow(context, '开关', on: false),
              _divider(),
              demoRow(context, '自定义颜色', on: true, onColor: Colors.green),
              _divider(),
              demoRow(context, '自定义颜色',
                  on: false, onColor: Colors.green, offColor: Colors.brown),
              _divider(),
              demoRow(context, '异步操作', on: true),
            ],
          ),
          padding: const EdgeInsets.only(left: 16, right: 16),
          color: Colors.white,
        ),
        _title('带描述状态开关'),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              demoRow(context, '开关', desc: '描述信息', on: true),
              _divider(),
              demoRow(context, '开关', desc: '描述信息', on: false),
              _divider(),
              demoRow(context, '自定义颜色',
                  desc: '描述信息', on: true, onColor: Colors.green),
            ],
          ),
          padding: const EdgeInsets.only(left: 16, right: 16),
          color: Colors.white,
        ),
        _title('状态'),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              demoRow(context, '开关开启禁用', on: true, enable: false),
              _divider(),
              demoRow(context, '开关开启禁用', on: false, enable: false),
              _divider(),
              demoRow(context, '开关开启禁用',
                  on: true, onColor: Colors.green, enable: false),
              _divider(),
              demoRow(context, '开关开启禁用',
                  desc: '描述信息', on: false, enable: false),
              _divider(),
              demoRow(context, '开关开启禁用', desc: '描述信息', on: true, enable: false),
            ],
          ),
          padding: const EdgeInsets.only(left: 16, right: 16),
          color: Colors.white,
        ),
      ],
    );

    current = Container(
      child: current,
      color: TDTheme.of(context).grayColor1,
    );


    current =  ExamplePage(
      title: '开关 Switch',
      children: [
        current
      ],
    );
    return current;
  }

  Widget _divider() {
    return Container(height: 0.5, color: const Color(0x33999999));
  }

  Widget _title(String title) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(title),
    );
  }

  Widget demoRow(
    BuildContext context,
    String? title, {
    String? desc,
    bool on = true,
    bool enable = true,
    Color? onColor,
    Color? offColor,
  }) {
    final theme = TDTheme.of(context);
    Widget current = Row(
      children: [
        Expanded(
            child: TDText(
          title,
          textColor: theme.fontGyColor1,
        )),
        TDText(
          desc ?? '',
          textColor: theme.grayColor6,
        ),
        TDSwitch(
          isOn: on,
          onColor: onColor,
          enable: enable,
          offColor: offColor,
        )
      ],
    );
    current = SizedBox(
      child: current,
      height: 44,
    );
    return current;
  }
}
