import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithIconExample extends StatelessWidget {
  const TabsItemWithIconExample({super.key});

  Widget _buildItemWithIcon(BuildContext context) {
    final tabs = List.generate(
      3,
      (_) => const TTab(text: '选项', icon: Icon(TIcons.app, size: 18)),
    );
    return DefaultTabController(
      length: tabs.length,
      child: TTabsBar(tabs: tabs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithIcon(context);
  }
}
