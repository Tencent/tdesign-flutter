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
      desc: '用作一组平行关系页面或内容的切换器，相较于 Tab，同屏可展示更多选项。',
      exampleCodeGroup: 'drawer',
      navBarKey: navBarkey,
      compactDemo: true,
      showTestModule: false,
      children: const [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础抽屉', builder: _buildBaseSimple),
            ExampleItem(desc: '带图标抽屉', builder: _buildIconSimple),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '右侧抽屉', builder: _buildRightSimple),
            ExampleItem(desc: '带标题抽屉', builder: _buildTitleSimple),
            ExampleItem(desc: '带底部操作抽屉', builder: _buildBottomSimple),
            ExampleItem(desc: '无遮罩抽屉', builder: _buildNoOverlaySimple),
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
          items: List.generate(
            8,
            (index) => TDrawerItem(title: '菜单${index + 1}'),
          ),
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
            8,
            (index) => TDrawerItem(
              title: '菜单${index + 1}',
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
Widget _buildRightSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        TDrawer(
          context,
          items: List.generate(
            8,
            (index) => TDrawerItem(title: '菜单${index + 1}'),
          ),
        ).show();
      },
      child: const TText('右侧抽屉'),
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildTitleSimple(BuildContext context) {
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
          items: List.generate(
            8,
            (index) => TDrawerItem(title: '菜单${index + 1}'),
          ),
        ).show();
      },
      child: const TText('带标题抽屉'),
    ),
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
          title: const TText('标题'),
          items: List.generate(
            8,
            (index) => TDrawerItem(title: '菜单${index + 1}'),
          ),
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
      child: const TText('带底部操作抽屉'),
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildNoOverlaySimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        late TDrawerHandle handle;
        handle = TDrawer(
          context,
          showOverlay: false,
          items: List.generate(
            8,
            (index) => TDrawerItem(title: '菜单${index + 1}'),
          ),
          onItemClick: (_, __) => handle.close(),
        ).show();
      },
      child: const TText('无遮罩抽屉'),
    ),
  );
}
