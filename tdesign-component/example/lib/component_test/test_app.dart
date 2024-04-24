import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var jsonString = await rootBundle.loadString('assets/theme1.json');
  print('jsonString:$jsonString');
  TDTheme.needMultiTheme(true);
  TDTheme.defaultData();
  var themeData = TDThemeData.fromJson('theme', jsonString);
  runApp(MaterialApp(
    home: Theme(
        data: ThemeData(extensions: [themeData!]),
        child: Builder(
          builder: (context) {
            return Scaffold(
              // appBar: TDNavBar(),
              appBar: _buildAppBar(context),
              body:  Center(
                child: TDText('测试文案', textColor: TDTheme.of(context)
                    .brandNormalColor,),
              ),
              bottomNavigationBar: _buildBottomTabBar(),
            );
          },
        )),
  ));
}

PreferredSize _buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height + MediaQuery.of(context).padding.top),
    child: Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.red,
      child: TDNavBar(
          useDefaultBack: false,
          // screenAdaptation: false,
          opacity: 0,
          centerTitle: false,
          titleMargin: 0,
          titleWidget: TDSearchBar(
            needCancel: false,
            autoHeight: true,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
            placeHolder: '搜索预设文案',
            mediumStyle: true,
            style: TDSearchStyle.round,
            onTextChanged: (String text) {
              print('input：$text');
            },
          ),
          rightBarItems: [
            TDNavBarItem(icon: TDIcons.home, iconSize: 24),
            TDNavBarItem(icon: TDIcons.ellipsis, iconSize: 24)
          ]),
    ),
  );
}

TDBottomTabBar _buildBottomTabBar() {
  var iconSize = 39 * 60 / 98;
  var textSize = 8.0;
  return TDBottomTabBar(
    TDBottomTabBarBasicType.iconText,
    componentType: TDBottomTabBarComponentType.normal,
    useVerticalDivider: false,
    barHeight: 98 * 60 / 98,
    navigationTabs: [
      TDBottomTabBarTabConfig(
        selectedIcon: Icon(TDIcons.home, size: iconSize, color: Colors.red),
        unselectedIcon: Icon(TDIcons.home, size: iconSize, color: const Color(0xFF383838)),
        tabText: '首页',
        selectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.red),
        unselectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.black),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(0);
        },
      ),
      TDBottomTabBarTabConfig(
        selectedIcon: Icon(TDIcons.app, size: iconSize, color: Colors.red),
        unselectedIcon: Icon(TDIcons.app, size: iconSize, color: const Color(0xFF383838)),
        tabText: '办事',
        selectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.red),
        unselectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.black),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(1);
        },
      ),
      TDBottomTabBarTabConfig(
        selectedIcon: Icon(TDIcons.user, size: iconSize, color: Colors.red),
        unselectedIcon: Icon(TDIcons.user, size: iconSize, color: Color(0xFF383838)),
        tabText: '我的',
        selectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.red),
        unselectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.black),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(2);
        },
      ),
    ],
  );
}
