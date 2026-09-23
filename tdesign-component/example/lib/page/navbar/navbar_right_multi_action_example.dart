import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'navbar')
class NavbarRightMultiActionExample extends StatelessWidget {
  const NavbarRightMultiActionExample({super.key});

  Widget _rightMultiAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TNavBar(
        key: const Key('navbar-demo-right-multi-action'),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _rightMultiAction(context);
  }
}
