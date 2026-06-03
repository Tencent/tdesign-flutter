import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

void main() async {
  kTextNeedGlobalFontFamily = true;
  WidgetsFlutterBinding.ensureInitialized();

  var jsonString = await rootBundle.loadString('assets/theme.json');
  print('jsonString:$jsonString');
  TTheme.needMultiTheme(true);
  var themeData =
      TThemeData.fromJson('greenLight', jsonString) ?? TTheme.defaultData();
  await TFontLoader.load(
      name: 'test1',
      fontFamilyUrl:
          'https://xinyue.qq.com/m/flutter_web/assets/packages/flutter_component/fonts/FZLanTingHeiS-EB-GB.ttf');

  runApp(MaterialApp(
    home: TTextConfiguration(
      globalFontFamily: FontFamily(
        fontFamily: 'test1',
      ),
      child: Theme(
        data: ThemeData(extensions: [themeData]),
        child: Builder(
          builder: (context) {
            ScreenUtil.init(context);
            return Scaffold(
              appBar: _buildAppBar(context),
              // appBar: _buildAppBar(context),
              // body: StudyDetail(),
              body: body(context),
              bottomNavigationBar: _buildBottomTabBar(),
            );
          },
        ),
      ),
    ),
  ));
}

Padding body(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TButton(
          text: '按钮 ',
          onTap: () {
            TLoadingController.show(context);
            TLoadingController.dismiss();
          },
        ),
        // 先显示再加载
        TText(
          '测试文案',
          textColor: TTheme.of(context).brandNormalColor,
          fontFamilyUrl:
              'https://xinyue.qq.com/m/flutter_web/assets/packages/flutter_component/fonts/FZLanTingHeiS-EB-GB.ttf',
          fontFamily: FontFamily(fontFamily: 'test'),
        ),
        //  // 先加载再显示
        // child: FutureBuilder(
        //     future:TFontLoader.load(name: 'test1', fontFamilyUrl: 'https://xinyue.qq.com/m/flutter_web/assets/packages/flutter_component/fonts/FZLanTingHeiS-EB-GB.ttf'),
        //   initialData: false,
        //   builder: (_,data)=>TText(
        //     (data.data ?? false) ? '测试文案' : '',
        //     textColor: TTheme.of(context).brandNormalColor,
        //     fontFamilyUrl: 'https://xinyue.qq.com/m/flutter_web/assets/packages/flutter_component/fonts/FZLanTingHeiS-EB-GB.ttf',
        //     fontFamily: FontFamily(fontFamily: 'test1'),
        //   ),
        // ),
        TInput(
          // leftLabel: '标签文字',
          // controller: controller[0],
          type: TInputType.cardStyle,
          backgroundColor: Colors.white,
          cardStyle: TCardStyle.topTextWithBlueBorder,
          hintText: '请输入文字',
          cardStyleTopText: '标签文字',
          // onChanged: (text) {
          //   setState(() {});
          // },
          // onClearTap: () {
          //   controller[0].clear();
          //   setState(() {});
          // },
        ),
        const SizedBox(height: 16),
        const TTextarea(
          label: '标签文字',
          hintText: '请输入文字',
          maxLines: 4,
          minLines: 4,
          maxLength: 500,
          padding: EdgeInsets.zero,
          indicator: true,
          // backgroundColor: Colors.white,
          // textInputBackgroundColor: Colors.white,
          layout: TTextareaLayout.vertical,
          bordered: true,
        )
      ],
    ),
  );
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return TNavBar(
      useDefaultBack: false,
      // screenAdaptation: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.green]),
        ),
      ),
      // opacity: 0,
      backgroundColor: Colors.red,
      centerTitle: false,
      titleMargin: 0,
      titleWidget: TSearchBar(
        needCancel: false,
        autoHeight: true,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        placeHolder: '搜索预设文案',
        mediumStyle: true,
        style: TSearchStyle.round,
        onTextChanged: (String text) {
          print('input：$text');
        },
      ),
      rightBarItems: [
        TNavBarItem(icon: TIcons.home, iconSize: 24),
        TNavBarItem(icon: TIcons.ellipsis, iconSize: 24)
      ]);
}

TBottomTabBar _buildBottomTabBar() {
  var iconSize = 39 * 60 / 98;
  var textSize = 8.0;
  return TBottomTabBar(
    TBottomTabBarBasicType.iconText,
    componentType: TBottomTabBarComponentType.normal,
    useVerticalDivider: false,
    barHeight: 98 * 60 / 98,
    navigationTabs: [
      TBottomTabBarTabConfig(
        selectedIcon: Icon(TIcons.home, size: iconSize, color: Colors.red),
        unselectedIcon: Icon(
          TIcons.home,
          size: iconSize,
          color: const Color(0xFF383838),
        ),
        tabText: '首页',
        selectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.red),
        unselectTabTextStyle: TextStyle(
          fontSize: textSize,
          color: Colors.black,
        ),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(0);
        },
      ),
      TBottomTabBarTabConfig(
        selectedIcon: Icon(TIcons.app, size: iconSize, color: Colors.red),
        unselectedIcon: Icon(
          TIcons.app,
          size: iconSize,
          color: const Color(0xFF383838),
        ),
        tabText: '办事',
        selectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.red),
        unselectTabTextStyle:
            TextStyle(fontSize: textSize, color: Colors.black),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(1);
        },
      ),
      TBottomTabBarTabConfig(
        selectedIcon: Icon(TIcons.user, size: iconSize, color: Colors.red),
        unselectedIcon: Icon(
          TIcons.user,
          size: iconSize,
          color: const Color(0xFF383838),
        ),
        tabText: '我的',
        selectTabTextStyle: TextStyle(fontSize: textSize, color: Colors.red),
        unselectTabTextStyle: TextStyle(
          fontSize: textSize,
          color: Colors.black,
        ),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(2);
        },
      ),
    ],
  );
}
