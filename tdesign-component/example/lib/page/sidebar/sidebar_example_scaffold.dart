import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Standalone shell for the full-screen SideBar auxiliary examples.
class SideBarExampleScaffold extends StatelessWidget {
  const SideBarExampleScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final titleLineHeight = context.tTheme.fontBodyMedium?.height ?? 22 / 14;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: TNavBar(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  height: titleLineHeight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: [
                TNavBarItem(
                  icon: TIcons.chevron_left,
                  iconSize: 28,
                  onTap: () => Navigator.maybePop(context),
                ),
                TNavBarItem(icon: TIcons.mode_dark, onTap: () {}),
              ],
              useDefaultBack: false,
              useSafeArea: false,
            ),
          ),
          Expanded(child: SafeArea(top: false, child: child)),
        ],
      ),
    );
  }
}
