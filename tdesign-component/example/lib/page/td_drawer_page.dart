import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

const _nums = [
  '一',
  '二',
  '三',
  '四',
  '五',
  '六',
  '七',
  '八',
  '九',
  '十',
  '十一',
  '十二',
  '十三',
  '十四',
  '十五',
  '十六',
  '十七',
  '十八',
  '十九',
  '二十',
  '二一',
  '二二',
  '二三',
  '二四',
  '二五',
  '二六',
  '二七',
  '二八',
  '二九',
  '三十',
];

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
        drawerTop: renderBox?.size.height,
        items: List.generate(30, (index) => TDDrawerItem(title: '菜单${_nums[index]}')).toList(),
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
  return TDButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        items: List.generate(30, (index) => TDDrawerItem(title: '菜单${_nums[index]}', icon: const Icon(TDIcons.app))).toList(),
      );
    },
  );
}

@Demo(group: 'drawer')
Widget _buildTitleSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TDButton(
    text: '带图标抽屉',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDDrawerPlacement.left,
        items: List.generate(10, (index) => TDDrawerItem(title: '菜单${_nums[index]}')).toList(),
      );
    },
  );
}

@Demo(group: 'drawer')
Widget _buildBottomSimple(BuildContext context) {
  /// 获取navBar尺寸
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TDButton(
    text: '带底部插槽样式',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        placement: TDDrawerPlacement.left,
        items: List.generate(10, (index) => TDDrawerItem(title: '菜单${_nums[index]}')).toList(),
        footer: const TDButton(
          text: '操作',
          type: TDButtonType.outline,
          width: double.infinity,
          size: TDButtonSize.large,
        ),
      );
    },
  );
}

@Demo(group: 'drawer')
Widget _buildColorSimple(BuildContext context) {
  var renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  return TDButton(
    text: '自定义背景色',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDDrawer(
        context,
        visible: true,
        drawerTop: renderBox?.size.height,
        title: '标题',
        backgroundColor: TDTheme.of(context).grayColor1,
        placement: TDDrawerPlacement.right,
        items: List.generate(10, (index) => TDDrawerItem(title: '菜单${_nums[index]}')).toList(),
      );
    },
  );
}
