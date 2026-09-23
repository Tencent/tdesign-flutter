import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithSplit2Example extends StatelessWidget {
  const TabsItemWithSplit2Example({super.key});

  Widget _buildItemWithSplit2(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: TTabsBar(
        tabs: [
          TTab(text: '选项'),
          TTab(text: '选项'),
          TTab(text: '上限六个文字'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithSplit2(context);
  }
}
