import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'navbar')
class SetBgColorNavbarExample extends StatelessWidget {
  const SetBgColorNavbarExample({super.key});

  Widget _setBgColorNavbar(BuildContext context) {
    return TNavBar(
      title: const Text('标题文字', style: TextStyle(fontWeight: FontWeight.w600)),
      titleColor: Colors.white,
      backgroundColor: context.tTheme.brandNormalColor,
      useDefaultBack: false,
      leading: [
        TNavBarItem(
          icon: TIcons.chevron_left,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => TToast.showText('点击了返回', context: context),
        ),
      ],
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _setBgColorNavbar(context);
  }
}
