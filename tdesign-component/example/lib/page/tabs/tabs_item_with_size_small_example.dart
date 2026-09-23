import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithSizeSmallExample extends StatelessWidget {
  const TabsItemWithSizeSmallExample({super.key});

  Widget _buildItemWithSizeSmall(BuildContext context) {
    const tabs = [
      TTab(text: '小尺寸'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
    ];
    return const DefaultTabController(length: 4, child: TTabsBar(tabs: tabs));
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithSizeSmall(context);
  }
}
