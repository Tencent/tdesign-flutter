import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter/src/util/platform_util.dart';

import 'tdesign/example_base.dart';
import 'tdesign/example_route.dart';
import 'tdesign/page/td_avatar_page.dart';
import 'tdesign/page/td_badge_page.dart';
import 'tdesign/page/td_bottom_navigation_bar_page.dart';
import 'tdesign/page/td_button_page.dart';
import 'tdesign/page/td_checkbox_page.dart';
import 'tdesign/page/td_date_picker_page.dart';
import 'tdesign/page/td_dialog_page.dart';
import 'tdesign/page/td_divider_page.dart';
import 'tdesign/page/td_empty_page.dart';
import 'tdesign/page/td_icon_page.dart';
import 'tdesign/page/td_image_page.dart';
import 'tdesign/page/td_input_view_pager.dart';
import 'tdesign/page/td_loading_page.dart';
import 'tdesign/page/td_navbar_page.dart';
import 'tdesign/page/td_picker_page.dart';
import 'tdesign/page/td_popup_page.dart';
import 'tdesign/page/td_pull_down_refresh_page.dart';
import 'tdesign/page/td_radio_page.dart';
import 'tdesign/page/td_search_bar_page.dart';
import 'tdesign/page/td_swich_page.dart';
import 'tdesign/page/td_swiper_page.dart';
import 'tdesign/page/td_tab_bar_page.dart';
import 'tdesign/page/td_tag_page.dart';
import 'tdesign/page/td_text_page.dart';
import 'tdesign/page/td_theme_page.dart';
import 'tdesign/page/td_toast_page.dart';

/// 新增的示例页面，在此增加模型即可,会自动注册增加按钮。示例页面编写参考TDTextPage()
List<ExamplePageModel> examplePageList = [
  ExamplePageModel(
      text: '文本控件--基础',
      path: 'TDTextPage',
      pageBuilder: (context) => const TDTextPage()),
  ExamplePageModel(
      text: '图标--基础',
      path: 'TDIconPage',
      pageBuilder: (context) => const TDIconPage()),
  ExamplePageModel(
      text: '主题--基础',
      path: 'TDThemePage',
      pageBuilder: (context) => const TDThemePage()),
  ExamplePageModel(
      text: '按钮 Button',
      path: 'TDButtonPage',
      pageBuilder: (context) => const TDButtonPage()),
  ExamplePageModel(
      text: '分割线 Divider',
      path: 'TDDividerPage',
      pageBuilder: (context) => const TDDividerPage()),
  ExamplePageModel(
      text: '头像 Avatar',
      path: 'TDAvatarPage',
      pageBuilder: (context) => const TDAvatarPage()),
  ExamplePageModel(
      text: '徽标 Badge',
      path: 'TDBadgePage',
      pageBuilder: (context) => const TDBadgePage()),
  ExamplePageModel(
      text: '空状态 Empty',
      path: 'TDEmptyPage',
      pageBuilder: (context) => const TDEmptyPage()),
  ExamplePageModel(
      text: '图片 Image',
      path: 'TDImagePage',
      pageBuilder: (context) => const TDImagePage()),
  ExamplePageModel(
      text: '轮播图 Swiper',
      path: 'TDSwiperPage',
      pageBuilder: (context) => const TDSwiperPage()),
  ExamplePageModel(
      text: '标签 Tag',
      path: 'TDTagPage',
      pageBuilder: (context) => const TDTagPage()),
  ExamplePageModel(
      text: '多选框 Checkbox',
      path: 'TDCheckboxPage',
      pageBuilder: (context) => const TDCheckboxPage()),
  ExamplePageModel(
      text: '时间选择器 DatePicker',
      path: 'TDDatePickerPage',
      pageBuilder: (context) => const TDDatePickerPage()),
  ExamplePageModel(
      text: '输入框 Input',
      path: 'TDInputViewPag',
      pageBuilder: (context) => const TDInputViewPage()),
  ExamplePageModel(
      text: '选择器 Picker',
      path: 'TDPickerPage',
      pageBuilder: (context) => const TDPickerPage()),
  ExamplePageModel(
      text: '单选框 Radio',
      path: 'TDRadioPage',
      pageBuilder: (context) => const TDRadioPage()),
  ExamplePageModel(
      text: '搜索框 Search',
      path: 'TDSearchBarPage',
      pageBuilder: (context) => const TDSearchBarPage()),
  ExamplePageModel(
      text: '开关 Switch',
      path: 'TDSwitchPage',
      pageBuilder: (context) => const TDSwitchPage()),
  ExamplePageModel(
      text: '导航栏 NavBar',
      path: 'TDNavBarPage',
      pageBuilder: (context) => const TDNavBarPage()),

  ExamplePageModel(text: '标签栏 TabBar',
      path: 'TDBottomNavBarPage',
      pageBuilder: (context) => const TDBottomNavBarPage()),
  ExamplePageModel(
      text: '选项卡 Tabs',
      path: 'TDTabBarPage',
      pageBuilder: (context) => const TDTabBarPage()),
  ExamplePageModel(
      text: '对话框 Dialog',
      path: 'TDDialogPage',
      pageBuilder: (context) => const TDDialogPage()),
  ExamplePageModel(
      text: '加载 Loading',
      path: 'TDLoadingPage',
      pageBuilder: (context) => const TDLoadingPage()),
  ExamplePageModel(
      text: '弹出层 PopUp',
      path: 'TDPopUpPage',
      pageBuilder: (context) => const TDPopupPage()),
  ExamplePageModel(
      text: '下拉刷新 PullDownRefresh',
      path: 'TdPullDownRefreshPage',
      pageBuilder: (context) => const TdPullDownRefreshPage()),
  ExamplePageModel(
      text: '轻提示 Toast',
      path: 'TDToastPage',
      pageBuilder: (context) => const TDToastPage()),
];

void main() {
  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
        // 在此处导入默认主题
        TDTheme(
      data: TDThemeData.defaultData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.light(primary: TDTheme.of(context).brandNormalColor)
        ),
        home: const MyHomePage(title: 'TDesgin Flutter 组件库'),
        onGenerateRoute: TDExampleRoute.onGenerateRoute,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool useConch = false;

  @override
  void initState() {
    super.initState();
    TDExampleRoute.init();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: [
            GestureDetector(
              child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16,),
                  child: TDText('关于', textColor: TDTheme
                      .of(context)
                      .whiteColor1,),
              ),
              onTap: () {
                Navigator.pushNamed(context, TDExampleRoute.aboutPath);
              },
            )
          ],
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    Widget menu = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildChildren(context),
      ),
    );
    if(PlatformUtil.isWeb){
      return Container(
        color: TDTheme.of().grayColor2,
        child: Row(
          children: [
            Container(
              width: 300,
              color: TDTheme.of().whiteColor1,
              child: menu,
            ),
            Expanded(child: GridView.builder(
              padding: const EdgeInsets.all(32),
              itemCount: examplePageList.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 520,
                  crossAxisSpacing:74,
                  mainAxisSpacing: 50,
                  mainAxisExtent: 640
              ),
              itemBuilder: (context,index){
                return examplePageList[index].pageBuilder(context);
              },
            )),

          ],
        ),
      );
    }
    return Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: menu,
      );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return <Widget>[
      for (var model in examplePageList)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TDButton(
              style: TDButtonStyle.weakly(),
              size: TDButtonSize.small,
              onTap: () {
                Navigator.pushNamed(context, model.path);
              },
              content: model.text),
        )
    ];
  }

  List<Widget> _buildPageChildren(BuildContext context) {
    return <Widget>[
      for (var model in examplePageList)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: model.pageBuilder(context),
        )
    ];
  }
}
