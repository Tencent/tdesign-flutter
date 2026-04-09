import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

const drawerItemLength = 30;

class TDrawerPage extends StatelessWidget {
  const TDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: TTheme.of(context).grayColor2,
        child: ExamplePage(
          title: tTitle(context),
          desc: '用作一组平行关系页面/内容的切换器，相较于Tab，同屏可展示更多的选项数量。',
          exampleCodeGroup: 'drawer',
          navBarKey: navBarkey,
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
            )
          ],
        ));
  }
}

@Demo(group: 'drawer')
Widget _buildBaseSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '基础抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
        onItemClick: (index, item) {
          print('drawer item被点击，index：$index，title：${item.title}');
        },
      );
    },
  );
}

@Demo(group: 'drawer')
Widget _buildIconSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(
            drawerItemLength,
            (index) => TDrawerItem(
                title: '菜单${index + 1}', icon: const Icon(TIcons.app))),
      );
    },
  );
}

@Demo(group: 'drawer')
Widget _buildTitleSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDrawerPlacement.left,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
      );
    },
  );
}

@Demo(group: 'drawer')
Widget _buildBottomSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TButton(
    text: '带底部插槽样式',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDrawerPlacement.left,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
        footer: const TButton(
          text: '操作',
          type: TButtonType.outline,
          width: double.infinity,
          size: TButtonSize.large,
        ),
      );
    },
  );
}

@Demo(group: 'drawer')
Widget _buildColorSimple(BuildContext context) {
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;

  var tCellStyle = TCellStyle(context: context);
  tCellStyle.backgroundColor = TTheme.of(context).brandNormalColor;

  return TButton(
    text: '自定义背景色',
    isBlock: true,
    type: TButtonType.outline,
    theme: TButtonTheme.primary,
    size: TButtonSize.large,
    onTap: () {
      TDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        backgroundColor: TTheme.of(context).bgColorSecondaryContainer,
        style: tCellStyle,
        placement: TDrawerPlacement.right,
        items: List.generate(
            drawerItemLength, (index) => TDrawerItem(title: '菜单${index + 1}')),
      );
    },
  );
}
