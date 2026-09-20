import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithSpaceExample extends StatelessWidget {
  const TabsItemWithSpaceExample({super.key});

  Widget _buildItemWithSpace(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: TTabsBar(tabs: List.generate(6, (_) => const TTab(text: '选项'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithSpace(context);
  }
}
