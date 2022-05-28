import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_base.dart';

// ignore: use_key_in_widget_constructors
class TdBadgePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdBadgePageState();
}

class _TdBadgePageState extends State<TdBadgePage> {
  @override
  Widget build(BuildContext context) {
    return ExampleWidget(
      title: 'Badge组件',
      children: [

        TDBadge(
          TDBadgeType.redPoint,
        ),
        TDBadge(
          TDBadgeType.remind,
        ),
        TDBadge(
          TDBadgeType.message,
          count: 2,
        ),
        TDBadge(TDBadgeType.message, count: 16),
        TDBadge(TDBadgeType.message, count: 162),
        TDBadge(
          TDBadgeType.message,
          isNew: true,
        ),
        TDBadge(
          TDBadgeType.message,
          isNew: true,
          border: TDBadgeBorder.small,
        ),
      ],
    );
  }
}
