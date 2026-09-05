import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

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
      children: const [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础抽屉',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildBaseSimple,
            ),
            ExampleItem(
              desc: '带图标抽屉',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildIconSimple,
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '带标题样式',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildTitleSimple,
            ),
            ExampleItem(
              desc: '抽屉方向',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildPlacementSimple,
            ),
            ExampleItem(
              desc: '带底部插槽样式',
              padding: EdgeInsets.symmetric(horizontal: 16),
              builder: _buildBottomSimple,
            ),
          ],
        ),
      ],
    );
  }
}

@ExampleCode(group: 'drawer')
Widget _buildBaseSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        TDrawer(
          context,
          placement: TDrawerPlacement.left,
          items: _baseItems(),
          onItemClick: (_, __) {},
        ).show();
      },
      child: const TText('基础抽屉'),
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildIconSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        TDrawer(
          context,
          placement: TDrawerPlacement.left,
          items: List.generate(
            _menuLabels.length,
            (index) => TDrawerItem(
              title: _menuLabels[index],
              icon: const TIcon(TIcons.app),
            ),
          ),
        ).show();
      },
      child: const TText('带图标抽屉'),
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildTitleSimple(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: TButton(
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TDrawer(
              context,
              placement: TDrawerPlacement.left,
              title: TText('标题', font: context.tTheme.fontTitleLarge),
              items: _baseItems(),
            ).show();
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
            TDrawer(
              context,
              placement: TDrawerPlacement.left,
              title: TText('标题', font: context.tTheme.fontHeadlineMedium),
              items: _baseItems(),
            ).show();
          },
          child: const TText('大标题抽屉'),
        ),
      ),
    ],
  );
}

@ExampleCode(group: 'drawer')
Widget _buildPlacementSimple(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: TButton(
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TDrawer(
              context,
              placement: TDrawerPlacement.left,
              items: _baseItems(),
            ).show();
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
            TDrawer(
              context,
              placement: TDrawerPlacement.right,
              items: _baseItems(),
            ).show();
          },
          child: const TText('右侧抽屉'),
        ),
      ),
    ],
  );
}

@ExampleCode(group: 'drawer')
Widget _buildBottomSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        TDrawer(
          context,
          placement: TDrawerPlacement.left,
          title: const TText('标题'),
          items: _footerItems(),
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
        ).show();
      },
      child: const TText('带底部插槽'),
    ),
  );
}

const _menuLabels = ['菜单一', '菜单二', '菜单三', '菜单四', '菜单五', '菜单六', '菜单七', '菜单八'];

List<TDrawerItem> _baseItems() => [
  for (final label in _menuLabels) TDrawerItem(title: label),
];

List<TDrawerItem> _footerItems() => [
  ..._baseItems(),
  for (final label in _menuLabels.skip(3)) TDrawerItem(title: label),
];
