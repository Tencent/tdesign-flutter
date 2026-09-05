import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    final cjkFont = FontLoader('TDesign Golden CJK')
      ..addFont(
        File(
          'example/test/fonts/TDesignGoldenCJK-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([iconFont.load(), robotoFont.load(), cjkFont.load()]);
  });

  for (final brightness in Brightness.values) {
    testWidgets('navigation components ${brightness.name} visual matrix', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(460, 1180);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _NavigationComponentsScene(brightness: brightness),
      );
      await tester.pump();

      await expectLater(
        find.byKey(const Key('navigation-components-scene')),
        matchesGoldenFile(
          'goldens/navigation_components_${brightness.name}.png',
        ),
      );
    });
  }
}

class _NavigationComponentsScene extends StatelessWidget {
  const _NavigationComponentsScene({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontFamily: 'Roboto',
        fontFamilyFallback: const ['TDesign Golden CJK'],
      ),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(
        fontFamily: 'Roboto',
        fontFamilyFallback: const ['TDesign Golden CJK'],
      ),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('navigation-components-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: SizedBox(
                width: 420,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel('NavBar'),
                      TNavBar(
                        title: 'Page title',
                        useDefaultBack: true,
                        actions: [
                          TNavBarItem(icon: TIcons.home, onTap: _noop),
                          TNavBarItem(icon: TIcons.ellipsis, onTap: _noop),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('Tabs'),
                      const DefaultTabController(
                        length: 3,
                        child: TTabsBar(
                          tabs: [
                            TTab(text: 'Overview'),
                            TTab(text: 'Details'),
                            TTab(text: 'Settings'),
                          ],
                          variant: TTabsBarVariant.line,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('TabBar'),
                      TTabBar(
                        variant: TTabBarVariant.iconText,
                        value: 1,
                        useSafeArea: false,
                        placeholder: false,
                        onChanged: _ignoreIndex,
                        navigationTabs: [
                          _tab(TIcons.home, 'Home'),
                          _tab(TIcons.app, 'Apps'),
                          _tab(TIcons.user, 'Profile'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('Steps'),
                      TSteps(
                        value: 1,
                        steps: [
                          TStepsItemData(title: 'Done', content: 'Complete'),
                          TStepsItemData(title: 'Current', content: 'Running'),
                          TStepsItemData(title: 'Next', content: 'Waiting'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('BackTop'),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TBackTop(onPressed: _noop),
                              SizedBox(width: 12),
                              TBackTop(
                                colorScheme: TBackTopColorScheme.dark,
                                onPressed: _noop,
                              ),
                              SizedBox(width: 12),
                              TBackTop(showText: true, onPressed: _noop),
                              SizedBox(width: 12),
                              TBackTop(
                                showText: true,
                                colorScheme: TBackTopColorScheme.dark,
                                onPressed: _noop,
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              TBackTop(
                                shape: TBackTopShape.halfCircle,
                                onPressed: _noop,
                              ),
                              SizedBox(width: 12),
                              TBackTop(
                                shape: TBackTopShape.halfCircle,
                                colorScheme: TBackTopColorScheme.dark,
                                onPressed: _noop,
                              ),
                              SizedBox(width: 12),
                              TBackTop(
                                shape: TBackTopShape.halfCircle,
                                showText: true,
                                onPressed: _noop,
                              ),
                              SizedBox(width: 12),
                              TBackTop(
                                shape: TBackTopShape.halfCircle,
                                showText: true,
                                colorScheme: TBackTopColorScheme.dark,
                                onPressed: _noop,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('Drawer and SideBar'),
                      const SizedBox(
                        height: 190,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: TDrawerWidget(
                                width: 190,
                                title: Text('Menu'),
                                items: [
                                  TDrawerItem(title: 'Dashboard'),
                                  TDrawerItem(title: 'Messages'),
                                  TDrawerItem(title: 'Settings'),
                                ],
                                onItemClick: _ignoreDrawer,
                              ),
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              width: 150,
                              child: TSideBar(
                                value: 1,
                                onChanged: _ignoreIndex,
                                children: [
                                  TSideBarItem(label: 'Category A', value: 0),
                                  TSideBarItem(label: 'Category B', value: 1),
                                  TSideBarItem(
                                    label: 'Disabled',
                                    value: 2,
                                    disabled: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _SectionLabel('Indexes'),
                      const SizedBox(
                        height: 240,
                        child: TIndexes(
                          indexList: ['A', 'B', 'C'],
                          builderContent: _buildIndexContent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TTabBarItemConfig _tab(IconData icon, String label) {
  return TTabBarItemConfig(
    selectedIcon: TIcon(icon),
    unselectedIcon: TIcon(icon),
    tabText: label,
    onTap: _noop,
  );
}

Widget? _buildIndexContent(BuildContext context, String index) {
  return SizedBox(
    height: 52,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TText('Item $index'),
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

void _noop() {}

void _ignoreIndex(int _) {}

void _ignoreDrawer(int _, TDrawerItem __) {}
