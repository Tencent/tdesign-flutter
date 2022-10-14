import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_base.dart';


class TDBadgePage extends StatefulWidget {
  const TDBadgePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDBadgePageState();
}

class _TDBadgePageState extends State<TDBadgePage> {
  @override
  Widget build(BuildContext context) {
    return ExampleWidget(
      title: '徽标 Badge',
      children: [
        ExampleItem(
            desc: '红点徽标',
            builder: (_) {
              return const TDBadge(
                TDBadgeType.redPoint,
              );
            }),
        ExampleItem(
            desc: '提醒徽标',
            builder: (_) {
              return const TDBadge(
                TDBadgeType.remind,
              );
            }),
        ExampleItem(
            desc: '消息徽标-个位数',
            builder: (_) {
              return const TDBadge(
                TDBadgeType.message,
                count: '2',
              );
            }),
        ExampleItem(
            desc: '消息徽标-两位数',
            builder: (_) {
              return const TDBadge(TDBadgeType.message, count: '16');
            }),
        ExampleItem(
            desc: '消息徽标-三位数',
            builder: (_) {
              return const TDBadge(TDBadgeType.message, count: '128');
            }),
        ExampleItem(
            desc: '消息徽标-自定义内容',
            builder: (_) {
              return const TDBadge(
                TDBadgeType.message,
                message: '新消息提醒',
              );
            }),
        ExampleItem(
            desc: '消息徽标-自定义内容-方形',
            builder: (_) {
              return const TDBadge(
                TDBadgeType.message,
                message: 'New',
                border: TDBadgeBorder.small,
              );
            }),
        ExampleItem(
            desc: '消息徽标-自定义内容-角标',
            builder: (_) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    child: TDText(
                      '单行标题',
                      textColor: TDTheme.of(context).fontGyColor1,
                      font: TDTheme.of(context).fontM,
                    ),
                    color: Colors.white,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const TDBadge(
                    TDBadgeType.subscript,
                    message: 'NEW',
                  ),
                ],
              );
            }),
      ],
    );
  }
}
