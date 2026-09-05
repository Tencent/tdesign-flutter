import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 't_sidebar_page_anchor.dart';

/// TSideBarOutlinePage 演示。
class TSideBarOutlinePage extends StatelessWidget {
  const TSideBarOutlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSideBarAnchorPage(
      title: 'SideBar 非通栏选项样式',
      style: TSideBarVariant.tag,
    );
  }
}
