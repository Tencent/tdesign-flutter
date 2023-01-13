import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../../base/example_widget.dart';

class TDNavBarPage extends StatelessWidget {
  const TDNavBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: '导航栏 NavBar',
      desc: '用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。',
      children: [
      ExampleModule(title: '组件类型',
      children: [
        ExampleItem(
          desc: '基础H5导航栏',
          builder: (_) {
            return const TDNavBar(title: '标题');
          },
        ),
        ExampleItem(
          desc: '左侧双操作导航栏',
          builder: (_) {
            return TDNavBar(
              title: '标题',
              useDefaultBack: false,
              leftBarItems: [
                TDNavBarItem(icon: TDIcons.chevron_left),
                TDNavBarItem(icon: TDIcons.close),
              ],
              rightBarItems: [TDNavBarItem(icon: TDIcons.ellipsis)],
            );
          },
        ),
        ExampleItem(
          desc: '右侧双操作导航栏',
          builder: (_) {
            return TDNavBar(
              title: '标题',
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.notification),
                TDNavBarItem(icon: TDIcons.ellipsis),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '带搜索导航栏',
          builder: (_) {
            return TDNavBar(
              useDefaultBack: false,
              centerTitle: false,
              titleMargin: 0,
              titleWidget:  TDSearchBar(
                autoHeight: true,
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                placeHolder: '搜索预设文案',
                mediumStyle: true,
                style: TDSearchStyle.round,
                onTextChanged: (String text) {
                  print('input：$text');
                },
              ),
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.notification),
                TDNavBarItem(icon: TDIcons.ellipsis),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '带图片导航栏',
          builder: (_) {
            return TDNavBar(
              useDefaultBack: false,
              centerTitle: false,
              titleMargin: 0,
              titleWidget:  const TDImage(
                'https://img01.sogoucdn.com/app/a/200797/37a8fd5f-4e64-4639-975b-44da9e4f612c',
                width: 102,
                height: 24,
              ),
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.notification),
                TDNavBarItem(icon: TDIcons.ellipsis),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '基础小程序导航栏',
          builder: (_) {
            return TDNavBar(
              title: '标题',
              useDefaultBack: false,
              useBorderStyle: true,
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.ellipsis),
                TDNavBarItem(icon: TDIcons.add_circle),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '标题左对齐',
          builder: (_) {
            return TDNavBar(
              centerTitle: false,
              titleMargin: 0,
              title: '标题',
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.home),
                TDNavBarItem(icon: TDIcons.ellipsis),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '带返回导航栏',
          builder: (_) {
            return TDNavBar(
              title: '标题',
              useBorderStyle: true,
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.ellipsis),
                TDNavBarItem(icon: TDIcons.add_circle),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '带返回、主页按钮导航栏',
          builder: (_) {
            return TDNavBar(
              title: '标题',
              useDefaultBack: false,
              useBorderStyle: true,
              leftBarItems: [
                TDNavBarItem(icon: TDIcons.chevron_left),
                TDNavBarItem(icon: TDIcons.home),
              ],
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.ellipsis),
                TDNavBarItem(icon: TDIcons.add_circle),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '自定义品牌导航栏',
          builder: (_) {
            return TDNavBar(
              title: '品牌名称',
              useDefaultBack: false,
              useBorderStyle: true,
              centerTitle: false,
              titleFontWeight: FontWeight.w600,
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.ellipsis),
                TDNavBarItem(icon: TDIcons.add_circle),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '自定义图片导航栏',
          builder: (_) {
            return TDNavBar(
              titleWidget: Container(
                width: 200,
                color: Colors.red,
                height: 20,
              ),
              useDefaultBack: false,
              useBorderStyle: true,
              centerTitle: false,
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.ellipsis),
                TDNavBarItem(icon: TDIcons.add_circle),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '品牌超长文字导航栏',
          builder: (_) {
            return TDNavBar(
              title: '品牌名称最长最长最长最长最长最长最长最长最长最长最长',
              useDefaultBack: false,
              useBorderStyle: true,
              centerTitle: false,
              titleFontWeight: FontWeight.w600,
              rightBarItems: [
                TDNavBarItem(icon: TDIcons.ellipsis),
                TDNavBarItem(icon: TDIcons.add_circle),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '自定义背景色',
          builder: (_) {
            return TDNavBar(
              title: '标题',
              titleColor: Colors.white,
              backgroundColor: TDTheme.of(context).brandColor8,
              useDefaultBack: false,
            );
          },
        ),
      ],
    )]);
  }
}
