import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

const titleText = '标题文字';

class TDNavBarPage extends StatelessWidget {
  const TDNavBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      exampleCodeGroup: 'navbar',
      desc: '用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础H5导航栏',
              builder: _baseH5Navbar,
            ),
            ExampleItem(
              builder: _leftMultiAction
            ),
            ExampleItem(
              builder: _rightMultiAction,
            ),
            ExampleItem(
              desc: '带搜索导航栏',
              builder: _searchNavbar,
            ),
            ExampleItem(
              desc: '带图片导航栏',
              builder: _logoNavbar
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '标题对齐',
              builder: _titleCenterNavbar,
            ),
            ExampleItem(
              builder: _titleLeftNavbar,
            ),

            ExampleItem(
              desc: '标题尺寸',
              builder: _titleNormalNavbar,
            ),
            ExampleItem(
              builder: _titleBelowNavbar,
            ),
            ExampleItem(
              desc: '自定义颜色',
              builder: _setBgColorNavbar,
            ),
          ]
        )
      ],
      test: [
        ExampleItem(
          desc: '底部阴影',
          builder: _shadowNavbar,
        ),
      ],
    );
  }

  @Demo(group: 'navbar')
  Widget _baseH5Navbar(BuildContext context) {
    return const TDNavBar(
        height: 48,
        titleFontWeight: FontWeight.w600,
        title: titleText,
        screenAdaptation: false,
        useDefaultBack: true,
    );
  }

  @Demo(group: 'navbar')
  Widget _leftMultiAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TDNavBar(
          height: 48,
          title: titleText,
          titleFontWeight: FontWeight.w600,
          screenAdaptation: false,
          useDefaultBack: true,
          leftBarItems: [
            TDNavBarItem(icon: TDIcons.close, iconSize: 24),
          ],
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24)
          ]
      ),
    );
  }

  @Demo(group: 'navbar')
  Widget _rightMultiAction(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TDNavBar(
            height: 48,
            title: titleText,
            titleFontWeight: FontWeight.w600,
            screenAdaptation: false,
            useDefaultBack: true,
            rightBarItems: [
              TDNavBarItem(icon: TDIcons.home, iconSize: 24, ),
              TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24,)
            ]
        ),
    );
  }

  @Demo(group: 'navbar')
  Widget _searchNavbar(BuildContext context){
    return TDNavBar(
      useDefaultBack: false,
      screenAdaptation: false,
      centerTitle: false,
      titleMargin: 0,
      titleWidget:  TDSearchBar(
        needCancel: false,
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
        TDNavBarItem(icon: TDIcons.home,iconSize: 24),
        TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
      ]
    );
  }

  @Demo(group: 'navbar')
  Widget _logoNavbar(BuildContext context){
    return TDNavBar(
        useDefaultBack: false,
        screenAdaptation: false,
        centerTitle: false,
        titleMargin: 0,
        titleWidget:  const TDImage(
          assetUrl: 'assets/img/td_brand.png',
          width: 102,
          height: 24,
        ),
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home,iconSize: 24),
          TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
        ]
    );
  }

  @Demo(group: 'navbar')
  Widget _titleCenterNavbar(BuildContext context) {
    return TDNavBar(
        height: 48,
        title: titleText,
        titleFontWeight: FontWeight.w600,
        screenAdaptation: false,
        useDefaultBack: true,
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home,iconSize: 24),
          TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
        ]
    );
  }

  @Demo(group: 'navbar')
  Widget _titleLeftNavbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TDNavBar(
          height: 48,
          title: titleText,
          titleFontWeight: FontWeight.w600,
          centerTitle: false,
          titleMargin: 0,
          screenAdaptation: false,
          useDefaultBack: true,
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.home,iconSize: 24),
            TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
          ]
      ),
    );
  }

  @Demo(group: 'navbar')
  Widget _titleNormalNavbar(BuildContext context) {
    return TDNavBar(
        height: 48,
        title: titleText,
        titleFontWeight: FontWeight.w600,
        screenAdaptation: false,
        useDefaultBack: true,
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home,iconSize: 24),
          TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
        ]
    );
  }

  @Demo(group: 'navbar')
  Widget _titleBelowNavbar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TDNavBar(
          height: 104,
          title: '返回',
          titleColor: const Color.fromRGBO(0, 0, 0, 0.9),
          belowTitleWidget: SizedBox(
            height: 56,
            child: TDText(titleText, font: Font(size: 28, lineHeight: 52), fontWeight: FontWeight.w600,),
          ),
          titleFont: Font(size: 16, lineHeight: 24),
          centerTitle: false,
          titleMargin: 0,
          screenAdaptation: false,
          useDefaultBack: false,
          leftBarItems: [
            TDNavBarItem(icon: TDIcons.chevron_left,iconSize: 24),
          ],
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.home,iconSize: 24),
            TDNavBarItem(icon: TDIcons.ellipsis,iconSize: 24)
          ]
      ),
    );
  }

  @Demo(group: 'navbar')
  Widget _setBgColorNavbar(BuildContext context) {
    return TDNavBar(
        height: 48,
        title: titleText,
        titleColor: Colors.white,
        backgroundColor: TDTheme.of(context).brandNormalColor,
        titleFontWeight: FontWeight.w600,
        useDefaultBack: false,
        screenAdaptation: false,
        leftBarItems: [
          TDNavBarItem(icon: TDIcons.chevron_left, iconSize: 24, iconColor: Colors.white),
        ],
        rightBarItems: [
          TDNavBarItem(icon: TDIcons.home, iconSize: 24, iconColor: Colors.white),
          TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24, iconColor: Colors.white)
        ]
    );
  }

  @Demo(group: 'navbar')
  Widget _shadowNavbar(BuildContext context) {
    return TDNavBar(
      height: 48,
      titleFontWeight: FontWeight.w600,
      title: titleText,
      screenAdaptation: false,
      useDefaultBack: true,
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          offset: const Offset(0, 4),
          color: TDTheme.of(context).grayColor5,
        )
      ],
    );
  }
}
