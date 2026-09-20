import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'navbar')
class TitleCenterNavbarExample extends StatelessWidget {
  const TitleCenterNavbarExample({super.key});

  Widget _titleCenterNavbar(BuildContext context) {
    return TNavBar(
      title: const Text('标题文字'),
      useDefaultBack: true,
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _titleCenterNavbar(context);
  }
}
