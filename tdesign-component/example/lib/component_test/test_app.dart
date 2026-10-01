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
        'https://xinyue.qq.com/m/flutter_web/assets/packages/flutter_component/fonts/FZLanTingHeiS-EB-GB.ttf',
  );

  runApp(
    MaterialApp(
      home: Theme(
        data: ThemeData(
          textTheme: const TextTheme(bodyLarge: TextStyle(fontFamily: 'test1')),
          extensions: [themeData],
        ),
        child: Builder(
          builder: (context) {
            ScreenUtil.init(context);
            return Scaffold(
              appBar: _buildAppBar(context),
              // appBar: _buildAppBar(context),
              // body: StudyDetail(),
              body: body(context),
              bottomNavigationBar: _buildTabBar(context),
            );
          },
        ),
      ),
    ),
  );
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
        TText(
          '测试文案',
          style: TextStyle(color: context.tTheme.brandColor, fontFamily: 'test1'),
        ),
        const TFormItem(
          label: '标签文字',
          child: TInput(hintText: '请输入文字'),
        ),
        const SizedBox(height: 16),
        const TFormItem(
          label: '标签文字',
          child: TTextarea(
            hintText: '请输入文字',
            maxLines: 4,
            minLines: 4,
            maxLength: 500,
            bordered: true,
          ),
        ),
      ],
    ),
  );
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(48),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TNavBarThemeData(titleMargin: 0)),
      child: TNavBar(
        useDefaultBack: false,
        useSafeArea: true,
        // screenAdaptation: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.green]),
          ),
        ),
        // opacity: 0,
        centerTitle: false,
        title: TSearchBar(
          variant: TSearchBarVariant.round,
          hintText: '搜索预设文案',
          onChanged: (String text) {
            print('input：$text');
          },
        ),
        actions: [
          TNavBarItem(
            icon: TIcons.home,
            iconSize: 24,
            onTap: () => TToast.showText('点击了首页', context: context),
          ),
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => TToast.showText('点击了更多', context: context),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTabBar(BuildContext context) {
  var iconSize = 39 * 60 / 98;
  var textSize = 8.0;
  return Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TTabBarThemeData(barHeight: 60)),
    child: TTabBar(
      type: TTabBarType.iconText,
      itemStyle: TTabBarItemStyle.normal,
      value: 0,
      onChanged: (_) {},
      split: false,
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
          unselectTabTextStyle: TextStyle(fontSize: textSize),
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
          unselectTabTextStyle: TextStyle(
            fontSize: textSize,
            color: Colors.black,
          ),
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
          unselectTabTextStyle: TextStyle(fontSize: textSize),
          onTap: () {
            // context.read<CurrentIndexProvider>().changeIndex(2);
          },
        ),
      ],
    ),
  );
}
