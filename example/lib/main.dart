import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/src/util/platform_util.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'tdesign/example_base.dart';
import 'tdesign/example_route.dart';
import 'tdesign/page/td_avatar_page.dart';
import 'tdesign/page/td_badge_page.dart';
import 'tdesign/page/td_bottom_nav_bar_page.dart';
import 'tdesign/page/td_button_page.dart';
import 'tdesign/page/td_checkbox_page.dart';
import 'tdesign/page/td_date_picker_page.dart';
import 'tdesign/page/td_dialog_page.dart';
import 'tdesign/page/td_divider_page.dart';
import 'tdesign/page/td_empty_page.dart';
import 'tdesign/page/td_icon_page.dart';
import 'tdesign/page/td_image_page.dart';
import 'tdesign/page/td_input_page.dart';
import 'tdesign/page/td_loading_page.dart';
import 'tdesign/page/td_navbar_page.dart';
import 'tdesign/page/td_picker_page.dart';
import 'tdesign/page/td_popup_page.dart';
import 'tdesign/page/td_radio_page.dart';
import 'tdesign/page/td_refresh_page.dart';
import 'tdesign/page/td_search_bar_page.dart';
import 'tdesign/page/td_swiper_page.dart';
import 'tdesign/page/td_switch_page.dart';
import 'tdesign/page/td_tabbar_page.dart';
import 'tdesign/page/td_tag_page.dart';
import 'tdesign/page/td_text_page.dart';
import 'tdesign/page/td_theme_page.dart';
import 'tdesign/page/td_toast_page.dart';
import 'web.dart';

PageBuilder _wrapInheritedTheme(WidgetBuilder builder){
  return (context, model){
    return ExamplePageInheritedTheme(model: model, child: builder(context));
  };
}

/// 新增的示例页面，在此增加模型即可,会自动注册增加按钮。示例页面编写参考TDTextPage()
List<ExamplePageModel> examplePageList = [
  ExamplePageModel(
      text: '文本控件--基础',
      path: 'TDTextPage',
      apiPath: 'text',
      pageBuilder: _wrapInheritedTheme((context) => const TDTextPage())),
  ExamplePageModel(
      text: '图标--基础',
      path: 'TDIconPage',
      apiPath: 'icon',
      pageBuilder: _wrapInheritedTheme((context) => const TDIconPage())),
  ExamplePageModel(
      text: '主题--基础',
      path: 'TDThemePage',
      apiPath: 'theme',
      pageBuilder: _wrapInheritedTheme((context) => const TDThemePage())),
  ExamplePageModel(
      text: '按钮 Button',
      path: 'TDButtonPage',
      apiPath: 'button',
      pageBuilder: _wrapInheritedTheme((context) => const TDButtonPage())),
  ExamplePageModel(
      text: '分割线 Divider',
      path: 'TDDividerPage',
      apiPath: 'divider',
      pageBuilder: _wrapInheritedTheme((context) => const TDDividerPage())),
  ExamplePageModel(
      text: '头像 Avatar',
      path: 'TDAvatarPage',
      apiPath: 'avatar',
      pageBuilder: _wrapInheritedTheme((context) => const TDAvatarPage())),
  ExamplePageModel(
      text: '徽标 Badge',
      path: 'TDBadgePage',
      apiPath: 'badge',
      pageBuilder: _wrapInheritedTheme((context) => const TDBadgePage())),
  ExamplePageModel(
      text: '空状态 Empty',
      path: 'TDEmptyPage',
      apiPath: 'empty',
      pageBuilder: _wrapInheritedTheme((context) => const TDEmptyPage())),
  ExamplePageModel(
      text: '图片 Image',
      path: 'TDImagePage',
      apiPath: 'image',
      pageBuilder: _wrapInheritedTheme((context) => const TDImagePage())),
  ExamplePageModel(
      text: '轮播图 Swiper',
      path: 'TDSwiperPage',
      apiPath: 'swiper',
      pageBuilder: _wrapInheritedTheme((context) => const TDSwiperPage())),
  ExamplePageModel(
      text: '标签 Tag',
      path: 'TDTagPage',
      apiPath: 'tag',
      pageBuilder: _wrapInheritedTheme((context) => const TDTagPage())),
  ExamplePageModel(
      text: '多选框 Checkbox',
      path: 'TDCheckboxPage',
      apiPath: 'checkbox',
      pageBuilder: _wrapInheritedTheme((context) => const TDCheckboxPage())),
  ExamplePageModel(
      text: '时间选择器 DatePicker',
      path: 'TDDatePickerPage',
      apiPath: 'date_picker',
      pageBuilder: _wrapInheritedTheme((context) => const TDDatePickerPage())),
  ExamplePageModel(
      text: '输入框 Input',
      path: 'TDInputViewPag',
      apiPath: 'input',
      pageBuilder: _wrapInheritedTheme((context) => const TDInputViewPage())),
  ExamplePageModel(
      text: '选择器 Picker',
      path: 'TDPickerPage',
      apiPath: 'picker',
      pageBuilder: _wrapInheritedTheme((context) => const TDPickerPage())),
  ExamplePageModel(
      text: '单选框 Radio',
      path: 'TDRadioPage',
      apiPath: 'radio',
      pageBuilder: _wrapInheritedTheme((context) => const TDRadioPage())),
  ExamplePageModel(
      text: '搜索框 Search',
      path: 'TDSearchBarPage',
      apiPath: 'search',
      codePath: 'search_bar',
      pageBuilder: _wrapInheritedTheme((context) => const TDSearchBarPage())),
  ExamplePageModel(
      text: '开关 Switch',
      path: 'TDSwitchPage',
      apiPath: 'switch',
      pageBuilder: _wrapInheritedTheme((context) => const TDSwitchPage())),
  ExamplePageModel(
      text: '导航栏 NavBar',
      path: 'TDNavBarPage',
      apiPath: 'navbar',
      pageBuilder: _wrapInheritedTheme((context) => const TDNavBarPage())),
  ExamplePageModel(
      text: '标签栏 TabBar',
      path: 'TDBottomNavBarPage',
      apiPath: 'bottom_nav_bar',
      pageBuilder: _wrapInheritedTheme((context) => const TDBottomNavBarPage())),
  ExamplePageModel(
      text: '选项卡 Tabs',
      path: 'TDTabBarPage',
      apiPath: 'tabbar',
      pageBuilder: _wrapInheritedTheme((context) => const TDTabBarPage())),
  ExamplePageModel(
      text: '对话框 Dialog',
      path: 'TDDialogPage',
      apiPath: 'dialog',
      pageBuilder: _wrapInheritedTheme((context) => const TDDialogPage())),
  ExamplePageModel(
      text: '加载 Loading',
      path: 'TDLoadingPage',
      apiPath: 'loading',
      pageBuilder: _wrapInheritedTheme((context) => const TDLoadingPage())),
  ExamplePageModel(
      text: '弹出层 PopUp',
      path: 'TDPopUpPage',
      apiPath: 'popup',
      pageBuilder: _wrapInheritedTheme((context) => const TDPopupPage())),
  ExamplePageModel(
      text: '下拉刷新 PullDownRefresh',
      path: 'TdPullDownRefreshPage',
      apiPath: 'refresh',
      pageBuilder: _wrapInheritedTheme((context) => const TdPullDownRefreshPage())),
  ExamplePageModel(
      text: '轻提示 Toast',
      path: 'TDToastPage',
      apiPath: 'toast',
      pageBuilder: _wrapInheritedTheme((context) => const TDToastPage())),
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
            colorScheme: ColorScheme.light(
                primary: TDTheme.of(context).brandNormalColor)),
        home: const MyHomePage(title: 'TDesgin Flutter 组件库'),
        onGenerateRoute: TDExampleRoute.onGenerateRoute,
        // TODO:所有路径指向首页，需区分
        routes: {
          for(var model in examplePageList)
            model.path: (context)=>model.pageBuilder.call(context, model)
        },
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
          actions: PlatformUtil.isWeb ? null : [
            GestureDetector(
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(
                  right: 16,
                ),
                child: TDText(
                  '关于',
                  textColor: TDTheme.of(context).whiteColor1,
                ),
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
    if (PlatformUtil.isWeb) {
      return const WebMainBody();
    }
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChildren(context),
        ),
      ),
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
                var navigator = WebHome.navigator ?? Navigator.of(context);
                navigator.pushNamed(model.path);
              },
              content: model.text),
        )
    ];
  }
}
