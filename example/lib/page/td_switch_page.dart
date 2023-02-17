import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

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
    var current =
        ExamplePage(title: 'Switch 开关', desc: '用于控制某个功能的开启和关闭。', children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(builder: (_) => _title('基础开关')),
          ExampleItem(
              builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [demoRow(context, '基础开关', on: true)],
                  )),
          ExampleItem(builder: (_) => _title('带描述开关')),
          ExampleItem(
              builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      demoRow(context, '带文字开关',
                          on: true, type: TDSwitchType.text),
                      demoRow(context, '带图标开关',
                          on: true, type: TDSwitchType.icon)
                    ],
                  )),
          ExampleItem(builder: (_) => _title('自定义颜色开关')),
          ExampleItem(
            builder: (_) =>
                demoRow(context, '自定义颜色开关', on: true, onColor: Colors.green),
          ),
        ],
      ),
      ExampleModule(title: '组件状态', children: [
        ExampleItem(builder: (_) => _title('加载状态')),
        ExampleItem(
            builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    demoRow(
                      context,
                      '加载状态',
                      on: true,
                      enable: false,
                      type: TDSwitchType.loading,
                    ),
                    demoRow(
                      context,
                      '加载状态',
                      on: false,
                      enable: false,
                      type: TDSwitchType.loading,
                    ),
                  ],
                )),
        ExampleItem(builder: (_) => _title('禁用状态')),
        ExampleItem(
            builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    demoRow(context, '禁用状态', on: false, enable: false),
                    demoRow(context, '禁用状态', on: true, enable: false),
                  ],
                )),
      ]),
      ExampleModule(title: '组件样式', children: [
        ExampleItem(builder: (_) => _title('开关尺寸')),
        ExampleItem(
            builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    demoRow(context, '大尺寸32',
                        on: true, size: TDSwitchSize.large),
                    demoRow(context, '中尺寸28',
                        on: true, size: TDSwitchSize.medium),
                    demoRow(context, '小尺寸24',
                        on: true, size: TDSwitchSize.small),
                  ],
                )),
      ]),
    ]);
    return current;
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
    TDSwitchSize? size,
    TDSwitchType? type,
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
        SizedBox(
          child: TDSwitch(
            isOn: on,
            onColor: onColor,
            enable: enable,
            offColor: offColor,
            size: size,
            type: type,
          ),
        )
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
    return current;
  }
}
