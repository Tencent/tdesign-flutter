import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithStatusExample extends StatelessWidget {
  const TabsItemWithStatusExample({super.key});

  Widget _buildItemWithStatus(BuildContext context) {
    const tabs = [
      TTab(text: '选中'),
      TTab(text: '默认'),
      TTab(text: '禁用', enabled: false),
    ];
    return const DefaultTabController(length: 3, child: TTabsBar(tabs: tabs));
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithStatus(context);
  }
}
