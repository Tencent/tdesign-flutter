import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'navbar')
class LogoNavbarExample extends StatelessWidget {
  const LogoNavbarExample({super.key});

  Widget _logoNavbar(BuildContext context) {
    return TNavBar(
      key: const Key('navbar-demo-image'),
      centerTitle: false,
      titleMargin: 0,
      title: const TImage(
        src: 'assets/img/t_brand.png',
        width: 87,
        height: 24,
        fit: BoxFit.contain,
      ),
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
    return _logoNavbar(context);
  }
}
