import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Standalone shell for the full-screen SideBar auxiliary examples.
class SideBarExampleScaffold extends StatefulWidget {
  const SideBarExampleScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  State<SideBarExampleScaffold> createState() => _SideBarExampleScaffoldState();
}

class _SideBarExampleScaffoldState extends State<SideBarExampleScaffold> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme.light;
    final page = _buildPage(context);
    return switch (_themeMode) {
      ThemeMode.light => Theme(data: TThemeBuilder.light(token), child: page),
      ThemeMode.dark => Theme(data: TThemeBuilder.dark(token), child: page),
      ThemeMode.system => page,
    };
  }

  Widget _buildPage(BuildContext context) {
    final titleLineHeight = context.tTheme.fontBodyMedium?.height ?? 22 / 14;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: TNavBar(
              title: Text(
                widget.title,
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
                TNavBarItem(
                  icon: _themeMode == ThemeMode.light
                      ? TIcons.mode_light
                      : TIcons.mode_dark,
                  onTap: () {
                    setState(() {
                      _themeMode = _themeMode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    });
                  },
                ),
              ],
              useDefaultBack: false,
              useSafeArea: false,
            ),
          ),
          Expanded(child: SafeArea(top: false, child: widget.child)),
        ],
      ),
    );
  }
}
