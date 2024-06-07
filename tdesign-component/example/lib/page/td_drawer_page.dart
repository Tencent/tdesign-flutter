import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDDrawerPage extends StatelessWidget {
  const TDDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: TDTheme.of(context).grayColor2,
        child: ExamplePage(
          title: tdTitle(context),
          desc: '用作一组平行关系页面/内容的切换器，相较于Tab，同屏可展示更多的选项数量。',
          exampleCodeGroup: 'drawer',
          children: [
            ExampleModule(title: '组件类型', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '基础抽屉',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildBaseSimple);
                },
              ),
            ]),
          ],
          test: const [],
        ));
  }
}

@Demo(group: 'drawer')
Widget _buildBaseSimple(BuildContext context) {
  return TDButton(
    text: '基础抽屉',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        items: [
          TDDrawerItem(title: '菜单一', icon: const Icon(TDIcons.app)),
          TDDrawerItem(title: '菜单二', icon: const Icon(TDIcons.app)),
          TDDrawerItem(title: '菜单三', icon: const Icon(TDIcons.app)),
          TDDrawerItem(title: '菜单四', icon: const Icon(TDIcons.app)),
          TDDrawerItem(title: '菜单五', icon: const Icon(TDIcons.app)),
          TDDrawerItem(title: '菜单六', icon: const Icon(TDIcons.app)),
        ],
      );
    },
  );
}
