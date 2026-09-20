import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithTagExample extends StatelessWidget {
  const TabsItemWithTagExample({super.key});

  Widget _buildItemWithTag(BuildContext context) {
    const tabs = [
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
    ];
    return const DefaultTabController(
      length: 4,
      child: TTabsBar(tabs: tabs, variant: TTabsBarVariant.tag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithTag(context);
  }
}
