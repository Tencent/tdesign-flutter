import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'drawer_type.dart';
part 'drawer_style.dart';

class TDrawerPage extends StatelessWidget {
  const TDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用作一组平行关系页面/内容的切换器，相较于 Tab，同屏可展示更多的选项数量。',
      exampleCodeGroup: 'drawer',
      navBarKey: navBarkey,
      compactDemo: true,
      showTestModule: false,
      children: [_drawerTypeModule, _drawerStyleModule],
    );
  }
}

@ExampleCode(group: 'drawer')
Widget _buildBaseSimple(BuildContext context) {
  final items = [
    for (final label in const [
      '菜单一',
      '菜单二',
      '菜单三',
      '菜单四',
      '菜单五',
      '菜单六',
      '菜单七',
      '菜单八',
    ])
      TDrawerItem(title: label),
  ];
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showTDrawer(
          context,
          placement: TDrawerPlacement.left,
          drawer: TDrawer(items: items, onItemClick: (_, __) {}),
        );
      },
      child: const TText('基础抽屉'),
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildIconSimple(BuildContext context) {
  const menuLabels = ['菜单一', '菜单二', '菜单三', '菜单四', '菜单五', '菜单六', '菜单七', '菜单八'];
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showTDrawer(
          context,
          placement: TDrawerPlacement.left,
          drawer: TDrawer(
            items: List.generate(
              menuLabels.length,
              (index) => TDrawerItem(
                title: menuLabels[index],
                icon: const TIcon(TIcons.app),
              ),
            ),
          ),
        );
      },
      child: const TText('带图标抽屉'),
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildTitleSimple(BuildContext context) {
  final items = [
    for (final label in const [
      '菜单一',
      '菜单二',
      '菜单三',
      '菜单四',
      '菜单五',
      '菜单六',
      '菜单七',
      '菜单八',
    ])
      TDrawerItem(title: label),
  ];
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: TButton(
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            showTDrawer(
              context,
              placement: TDrawerPlacement.left,
              drawer: TDrawer(
                title: TText('标题', font: context.tTheme.fontTitleLarge),
                items: items,
              ),
            );
          },
          child: const TText('小标题抽屉'),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: TButton(
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            showTDrawer(
              context,
              placement: TDrawerPlacement.left,
              drawer: TDrawer(
                title: TText('标题', font: context.tTheme.fontHeadlineMedium),
                items: items,
              ),
            );
          },
          child: const TText('大标题抽屉'),
        ),
      ),
    ],
  );
}

@ExampleCode(group: 'drawer')
Widget _buildPlacementSimple(BuildContext context) {
  final items = [
    for (final label in const [
      '菜单一',
      '菜单二',
      '菜单三',
      '菜单四',
      '菜单五',
      '菜单六',
      '菜单七',
      '菜单八',
    ])
      TDrawerItem(title: label),
  ];
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: TButton(
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            showTDrawer(
              context,
              placement: TDrawerPlacement.left,
              drawer: TDrawer(items: items),
            );
          },
          child: const TText('左侧抽屉'),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: TButton(
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            showTDrawer(
              context,
              placement: TDrawerPlacement.right,
              drawer: TDrawer(items: items),
            );
          },
          child: const TText('右侧抽屉'),
        ),
      ),
    ],
  );
}

@ExampleCode(group: 'drawer')
Widget _buildBottomSimple(BuildContext context) {
  const menuLabels = ['菜单一', '菜单二', '菜单三', '菜单四', '菜单五', '菜单六', '菜单七', '菜单八'];
  final items = [
    for (final label in [...menuLabels, ...menuLabels.skip(3)])
      TDrawerItem(title: label),
  ];
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showTDrawer(
          context,
          placement: TDrawerPlacement.left,
          drawer: TDrawer(
            title: const TText('标题'),
            items: items,
            footer: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: TButton(
                  size: TButtonSize.large,
                  variant: TButtonVariant.outline,
                  onPressed: () {},
                  child: const TText('操作'),
                ),
              ),
            ),
          ),
        );
      },
      child: const TText('带底部插槽'),
    ),
  );
}
