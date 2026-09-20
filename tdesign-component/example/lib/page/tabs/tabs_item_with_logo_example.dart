import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tabs')
class TabsItemWithLogoExample extends StatelessWidget {
  const TabsItemWithLogoExample({super.key});

  Widget _buildItemWithLogo(BuildContext context) {
    const tabs = [
      TTab(
        child: TBadge(
          variant: TBadgeVariant.dot,
          offset: Offset(-4, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(TIcons.app, size: 18),
              SizedBox(width: 4),
              Text('选项'),
            ],
          ),
        ),
      ),
      TTab(
        child: TBadge(
          label: '8',
          offset: Offset(-1, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(TIcons.app, size: 18),
              SizedBox(width: 4),
              Text('选项'),
            ],
          ),
        ),
      ),
      TTab(text: '选项', icon: Icon(TIcons.app, size: 18)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: const TTabsBar(tabs: tabs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItemWithLogo(context);
  }
}
