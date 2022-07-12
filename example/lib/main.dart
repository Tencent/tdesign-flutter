import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'tdesign/example_base.dart';
import 'tdesign/example_route.dart';
import 'tdesign/page/td_avatar_page.dart';
import 'tdesign/page/td_badge_page.dart';
import 'tdesign/page/td_button_page.dart';
import 'tdesign/page/td_checkbox_page.dart';
import 'tdesign/page/td_dialog_page.dart';
import 'tdesign/page/td_divider_page.dart';
import 'tdesign/page/td_empty_page.dart';
import 'tdesign/page/td_icon_page.dart';
import 'tdesign/page/td_image_page.dart';
import 'tdesign/page/td_input_view_pager.dart';
import 'tdesign/page/td_loading_page.dart';
import 'tdesign/page/td_navbar_page.dart';
import 'tdesign/page/td_picker_page.dart';
import 'tdesign/page/td_radio_page.dart';
import 'tdesign/page/td_tab_bar_page.dart';
import 'tdesign/page/td_tag_page.dart';
import 'tdesign/page/td_text_page.dart';
import 'tdesign/page/td_theme_page.dart';
import 'tdesign/page/td_toast_page.dart';

/// 新增的示例页面，在此增加模型即可,会自动注册增加按钮。示例页面编写参考TdTextPage()
List<ExamplePageModel> examplePageList = [
  ExamplePageModel(
      text: '文本控件', path: 'TdTextPage', pageBuilder: (context) => const TdTextPage()),
  ExamplePageModel(
      text: '分割线',
      path: 'TdDividerPage',
      pageBuilder: (context) => const TdDividerPage()),
  ExamplePageModel(
      text: '圆形图片组件（头像）',
      path: 'TdAvatarPage',
      pageBuilder: (context) => TdAvatarPage()),
  ExamplePageModel(
      text: '红点', path: 'TdBadgePage', pageBuilder: (context) => TdBadgePage()),
  ExamplePageModel(
      text: '标签栏',
      path: 'TdTabBarPage',
      pageBuilder: (context) => TdTabBarPage()),
  ExamplePageModel(
      text: '轻提示',
      path: 'TdToastPage',
      pageBuilder: (context) => TdToastPage()),
  ExamplePageModel(
      text: '按钮',
      path: 'TdButtonPage',
      pageBuilder: (context) => TdButtonPage()),
  ExamplePageModel(
      text: '输入框',
      path: 'TdInputViewPag',
      pageBuilder: (context) => const TdInputViewPage()),
  ExamplePageModel(
      text: '标签', path: 'TdTagPage', pageBuilder: (context) => const TdTagPage()),
  ExamplePageModel(
      text: 'Picker',
      path: 'TdPickerPage',
      pageBuilder: (context) => TdPickerPage()),
  ExamplePageModel(
      text: '图标', path: 'TdIconPage', pageBuilder: (context) => TdIconPage()),
  ExamplePageModel(
      text: '空白页面',
      path: 'TdEmptyPage',
      pageBuilder: (context) => TdEmptyPage()),
  ExamplePageModel(
      text: '主题页面',
      path: 'TdThemePage',
      pageBuilder: (context) => TdThemePage()),
  ExamplePageModel(
      text: '图片组件',
      path: 'TdImagePage',
      pageBuilder: (context) => const TdImagePage()),
  ExamplePageModel(
      text: 'Checkbox复选框',
      path: 'TdCheckboxPage',
      pageBuilder: (context) => const TdCheckboxPage()),
  ExamplePageModel(
      text: 'Radio单框',
      path: 'TdRadioPage',
      pageBuilder: (context) => const TdRadioPage()),
  ExamplePageModel(
      text: 'Dialog弹窗',
      path: 'TdDialogPage',
      pageBuilder: (context) => TdDialogPage()),
  ExamplePageModel(
      text: 'Loading加载中',
      path: 'TdLoadingPage',
      pageBuilder: (context) => const TdLoadingPage()),
  ExamplePageModel(text: '导航栏组件', path: 'TdNavBarPage', pageBuilder: (context)=> const TdNavBarPage()),
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

  const MyApp({Key? key}):super(key: key);

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
          // This is the theme of your application.
          //
          // Try running your application with 'flutter run'. You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // 'hot reload' (press 'r' in the console where you ran 'flutter run',
          // or simply save your changes to 'hot reload' in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          accentColor: Colors.red,
        ),
        home: const MyHomePage(title: 'flutter原子组件库demo'),
        onGenerateRoute: TdExampleRoute.onGenerateRoute,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked 'final'.

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool useConch = false;

  @override
  void initState() {
    super.initState();
    TdExampleRoute.init();
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
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildChildren(context),
            ),
          ),
        ));
  }

  List<Widget> _buildChildren(BuildContext context) {
    return <Widget>[
      for (var model in examplePageList)
        OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, model.path);
            },
            child: Text(
              model.text,
            ))
    ];
  }
}
