import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 't_sidebar_page_anchor.dart';

/// TSideBarIconPage 演示。
class TSideBarIconPage extends StatelessWidget {
  const TSideBarIconPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSideBarAnchorPage(title: 'SideBar 带图标侧边导航', withIcons: true);
  }
}
