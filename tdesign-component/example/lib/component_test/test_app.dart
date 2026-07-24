import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'tabbar_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var jsonString = await rootBundle.loadString('assets/theme.json');
  print('jsonString:$jsonString');
  var themeData =
      TThemeData.fromJson('greenLight', jsonString) ?? TThemeData.defaultData();
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
              bottomNavigationBar: _buildTabBar(),
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
          child: const Text('按钮 '),
          onPressed: () {
            TLoadingController.show(context);
            TLoadingController.dismiss();
          },
        ),
        // 先显示再加载
        TText(
          '测试文案',
          textColor: context.tTheme.brandNormalColor,
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
        //     textColor: context.tTheme.brandNormalColor,
        //     fontFamilyUrl: 'https://xinyue.qq.com/m/flutter_web/assets/packages/flutter_component/fonts/FZLanTingHeiS-EB-GB.ttf',
        //     fontFamily: FontFamily(fontFamily: 'test1'),
        //   ),
        // ),
        const TInput(
          label: '标签文字',
          hintText: '请输入文字',
        ),
        const SizedBox(height: 16),
        const TTextarea(
          label: '标签文字',
          hintText: '请输入文字',
          maxLines: 4,
          minLines: 4,
          maxLength: 500,
          decoration: InputDecoration(border: OutlineInputBorder()),
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
      centerTitle: false,
      titleMargin: 0,
      titleWidget: Theme(
        data: Theme.of(context).mergeExtension(
          const TSearchBarThemeData(
            variant: TSearchBarVariant.round,
            padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
            autoHeight: true,
          ),
        ),
        child: TSearchBar(
          needCancel: false,
          hintText: '搜索预设文案',
          onChanged: (String text) {
            print('input：$text');
          },
        ),
      ),
      actions: [
        TNavBarItem(icon: TIcons.home, iconSize: 24),
        TNavBarItem(icon: TIcons.ellipsis, iconSize: 24)
      ]);
}

TTabBar _buildTabBar() {
  var iconSize = 39 * 60 / 98;
  var textSize = 8.0;
  return TTabBar(
    variant: TTabBarVariant.weakIconText,
    value: 0,
    onChanged: (_) {},
    useVerticalDivider: false,
    barHeight: 98 * 60 / 98,
    navigationTabs: [
      TTabBarItemConfig(
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
        ),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(0);
        },
      ),
      TTabBarItemConfig(
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
      TTabBarItemConfig(
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
        ),
        onTap: () {
          // context.read<CurrentIndexProvider>().changeIndex(2);
        },
      ),
    ],
  );
}
