import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/example_code.dart';
import '../base/example_widget.dart';

const drawerItemLength = 30;

class TDrawerPage extends StatelessWidget {
  const TDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: context.tTheme.grayColor2,
        child: ExamplePage(
          title: tTitle(context),
          desc: '用作一组平行关系页面/内容的切换器，相较于Tab，同屏可展示更多的选项数量。',
          exampleCodeGroup: 'drawer',
          navBarKey: navBarkey,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            ExampleModule(title: '组件类型', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '基础抽屉',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildBaseSimple);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带图标抽屉',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildIconSimple);
                },
              ),
            ]),
            ExampleModule(title: '组件样式', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '带标题抽屉',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildTitleSimple);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '带底部插槽样式',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildBottomSimple);
                },
              ),
            ]),
          ],
          test: [
            ExampleItem(
              ignoreCode: true,
              desc: '自定义背景色',
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildColorSimple);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '使用 child 自定义内容',
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildChildSimple);
              },
            ),
          ],
        ));
  }
}

@ExampleCode(group: 'drawer')
Widget _buildBaseSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      child: const TText('基础抽屉'),
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      size: TButtonSize.large,
      onPressed: () {
        TDrawer(
          context,
          items: List.generate(drawerItemLength,
              (index) => TDrawerItem(title: '菜单${index + 1}')),
          onItemClick: (index, item) {
            print('drawer item被点击，index：$index，title：${item.title}');
          },
        ).show();
      },
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildIconSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      child: const TText('带标题抽屉'),
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      size: TButtonSize.large,
      onPressed: () {
        TDrawer(
          context,
          items: List.generate(
              drawerItemLength,
              (index) => TDrawerItem(
                  title: '菜单${index + 1}', icon: const Icon(TIcons.app))),
        ).show();
      },
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildTitleSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      child: const TText('带图标抽屉'),
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      size: TButtonSize.large,
      onPressed: () {
        TDrawer(
          context,
          title: const TText('标题'),
          placement: TDrawerPlacement.left,
          items: List.generate(drawerItemLength,
              (index) => TDrawerItem(title: '菜单${index + 1}')),
        ).show();
      },
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildBottomSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      child: const TText('带底部插槽样式'),
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      size: TButtonSize.large,
      onPressed: () {
        TDrawer(
          context,
          title: const TText('标题'),
          placement: TDrawerPlacement.left,
          items: List.generate(drawerItemLength,
              (index) => TDrawerItem(title: '菜单${index + 1}')),
          footer: SizedBox(
            width: double.infinity,
            child: TButton(
              child: const TText('操作'),
              variant: TButtonVariant.outline,
              size: TButtonSize.large,
              onPressed: () {},
            ),
          ),
        ).show();
      },
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildColorSimple(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(
      TDrawerThemeData(
        backgroundColor: context.tTheme.bgColorSecondaryContainer,
        itemBackgroundColor: context.tTheme.brandNormalColor,
      ),
    ),
    child: Builder(
      builder: (drawerContext) => SizedBox(
        width: double.infinity,
        child: TButton(
          child: const TText('自定义背景色'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          size: TButtonSize.large,
          onPressed: () {
            TDrawer(
              drawerContext,
              title: const TText('标题'),
              placement: TDrawerPlacement.right,
              items: List.generate(drawerItemLength,
                  (index) => TDrawerItem(title: '菜单${index + 1}')),
            ).show();
          },
        ),
      ),
    ),
  );
}

@ExampleCode(group: 'drawer')
Widget _buildChildSimple(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: TButton(
      child: const TText('使用 child 自定义内容'),
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      size: TButtonSize.large,
      onPressed: () {
        TDrawer(
          context,
          title: const TText('标题'),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const TText('这是通过 child 传入的自定义内容'),
          ),
        ).show();
      },
    ),
  );
}
