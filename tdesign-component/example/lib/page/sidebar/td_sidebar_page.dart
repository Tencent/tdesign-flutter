import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TDSideBarPage演示
///
class TDSideBarPage extends StatefulWidget {
  const TDSideBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDSideBarPageState();
  }
}

class TDSideBarPageState extends State<TDSideBarPage> {
  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        exampleCodeGroup: 'sideBar',
        desc: '用于内容分类后的展示切换。',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: '侧边导航用法',
                ignoreCode: true,
                builder: _buildNavigatorSideBar),
            ExampleItem(
                desc: '图标侧边导航',
                builder: _buildIconSideBar,
                methodName: '_buildIconSideBar')
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(
                desc: '侧边导航样式', ignoreCode: true, builder: _buildStyleSideBar),
          ])
        ],
        test: [
          ExampleItem(
              desc: '延迟加载', ignoreCode: true, builder: _loadingSideBar),
          ExampleItem(
              desc: '自定义未选中颜色', ignoreCode: true, builder: _unSelectedColorSideBar),
        ],
    );
  }

  Widget _buildNavigatorSideBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CodeWrapper(
              builder: (_) => getCustomButton(context, '锚点用法', 'SideBarAnchor'),
              methodName: '_buildAnchorSideBar',
            ),
            const SizedBox(
              height: 16,
            ),
            CodeWrapper(
              builder: (_) =>
                  getCustomButton(context, '切页用法', 'SideBarPagination'),
              methodName: '_buildPaginationSideBar',
            ),
          ],
        ));
  }

  Widget _buildIconSideBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            getCustomButton(context, '带图标侧边导航', 'SideBarIcon'),
          ],
        ));
  }

  Widget _buildStyleSideBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CodeWrapper(
              builder: (_) =>
                  getCustomButton(context, '非通栏选项样式', 'SideBarOutline'),
              methodName: '_buildOutlineSideBar',
            ),
            const SizedBox(
              height: 16,
            ),
            CodeWrapper(
              builder: (_) =>
                  getCustomButton(context, '自定义样式', 'SideBarCustom'),
              methodName: '_buildCustomSideBar',
            ),
          ],
        ));
  }

  Widget _loadingSideBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CodeWrapper(
              builder: (_) =>
                  getCustomButton(context, '延迟加载', 'SideBarLoading'),
              methodName: '_buildLoadingSideBar',
            ),
          ],
        ));
  }

  Widget _unSelectedColorSideBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CodeWrapper(
              builder: (_) =>
                  getCustomButton(context, '未选中颜色自定义', 'SideBarUnselectedColor'),
              methodName: '_buildUnselectedColorSideBar',
            ),
          ],
        ));
  }

  TDButton getCustomButton(
      BuildContext context, String text, String routeName) {
    return TDButton(
      text: text,
      width: MediaQuery.of(context).size.width - 16 * 2,
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      onTap: () {
        Navigator.pushNamed(context, PlatformUtil.isWeb ? routeName : '$routeName');
      },
    );
  }
}
