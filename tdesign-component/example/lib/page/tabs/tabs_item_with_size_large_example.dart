import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithSizeLargeExample extends StatelessWidget {
  const TabsItemWithSizeLargeExample({super.key});

  Widget _buildItemWithSizeLarge(BuildContext context) {
    const tabs = [
      TTab(text: '大尺寸'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
    ];
    return const DefaultTabController(
      length: 4,
      child: TTabsBar(tabs: tabs, size: TTabsBarSize.large),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithSizeLarge(context);
  }
}
