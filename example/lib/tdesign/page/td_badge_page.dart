import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class BadgePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Badge组件'),
        ),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
          ),
        ));
  }
}
