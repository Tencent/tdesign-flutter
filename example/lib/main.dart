import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'base/example_base.dart';
import 'base/example_route.dart';
import 'page/td_avatar_page.dart';
import 'page/td_badge_page.dart';
import 'page/td_bottom_nav_bar_page.dart';
import 'page/td_button_page.dart';
import 'page/td_checkbox_page.dart';
import 'page/td_date_picker_page.dart';
import 'page/td_dialog_page.dart';
import 'page/td_divider_page.dart';
import 'page/td_empty_page.dart';
import 'page/td_icon_page.dart';
import 'page/td_image_page.dart';
import 'page/td_input_page.dart';
import 'page/td_loading_page.dart';
import 'page/td_navbar_page.dart';
import 'page/td_picker_page.dart';
import 'page/td_popup_page.dart';
import 'page/td_radio_page.dart';
import 'page/td_radius_page.dart';
import 'page/td_refresh_page.dart';
import 'page/td_search_bar_page.dart';
import 'page/td_swiper_page.dart';
import 'page/td_switch_page.dart';
import 'page/td_tabbar_page.dart';
import 'page/td_tag_page.dart';
import 'page/td_text_page.dart';
import 'page/td_theme_page.dart';
import 'page/td_toast_page.dart';
import 'page/todo_page.dart';
import 'web/web.dart' if (dart.library.io) 'web/web_replace.dart' as web;

PageBuilder _wrapInheritedTheme(WidgetBuilder builder) {
  return (context, model) {
    return ExamplePageInheritedTheme(model: model, child: builder(context));
  };
}

/// 新增的示例页面，在此增加模型即可,会自动注册增加按钮。示例页面编写参考TDTextPage()
List<ExamplePageModel> examplePageList = [];

/// 是否显示TODO组件
var _kShowTodoComponent = false;

Map<String, List<ExamplePageModel>> exampleMap = {
  '基础': [
    ExamplePageModel(
        text: 'Button 按钮',
        name: 'button',
        pageBuilder: _wrapInheritedTheme((context) => const TDButtonPage())),
    ExamplePageModel(
        text: 'Divider 分割线',
        name: 'divider',
        pageBuilder: _wrapInheritedTheme((context) => const TDDividerPage())),
    ExamplePageModel(
        text: 'Fab 悬浮按钮',
        name: 'fab',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Icon 图标',
        name: 'icon',
        pageBuilder: _wrapInheritedTheme((context) => const TDIconPage())),
    ExamplePageModel(
        text: 'Link 链接',
        name: 'link',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Text 文本',
        name: 'text',
        pageBuilder: _wrapInheritedTheme((context) => const TDTextPage())),
  ],
  '导航': [
    ExamplePageModel(
        text: 'BackTop 返回顶部',
        name: 'back_top',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Drawer 抽屉',
        name: 'drawer',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Indexes 索引',
        name: 'indexes',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'NavBar 导航栏',
        name: 'navbar',
        pageBuilder: _wrapInheritedTheme((context) => const TDNavBarPage())),
    ExamplePageModel(
        text: 'Sidebar 侧边栏',
        name: 'sidebar',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Steps 步骤条',
        name: 'steps',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'TabBar 标签栏',
        name: 'tabbar',
        pageBuilder:
            _wrapInheritedTheme((context) => const TDBottomNavBarPage())),
    ExamplePageModel(
        text: 'Tabs 选项卡',
        name: 'tabs',
        pageBuilder: _wrapInheritedTheme((context) => const TDTabBarPage())),
  ],
  '输入': [
    ExamplePageModel(
        text: 'Calendar 日历',
        name: 'calendar',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Cascader 级联选择器',
        name: 'cascader',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Checkbox 多选框',
        name: 'checkbox',
        pageBuilder: _wrapInheritedTheme((context) => const TDCheckboxPage())),
    ExamplePageModel(
        text: 'DatePicker 时间选择器',
        name: 'date_picker',
        pageBuilder:
            _wrapInheritedTheme((context) => const TDDatePickerPage())),
    ExamplePageModel(
        text: 'Input 输入框',
        name: 'input',
        pageBuilder: _wrapInheritedTheme((context) => const TDInputViewPage())),
    ExamplePageModel(
        text: 'Picker 选择器',
        name: 'picker',
        pageBuilder: _wrapInheritedTheme((context) => const TDPickerPage())),
    ExamplePageModel(
        text: 'Radio 单选框',
        name: 'radio',
        pageBuilder: _wrapInheritedTheme((context) => const TDRadioPage())),
    ExamplePageModel(
        text: 'Rate 评分',
        name: 'rate',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Search 搜索框',
        name: 'search',
        pageBuilder: _wrapInheritedTheme((context) => const TDSearchBarPage())),
    ExamplePageModel(
        text: 'Slider 滑动选择器',
        name: 'slider',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Stepper 步进器',
        name: 'stepper',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Switch 开关',
        name: 'switch',
        pageBuilder: _wrapInheritedTheme((context) => const TDSwitchPage())),
    ExamplePageModel(
        text: 'Textarea 多行文本框',
        name: 'textarea',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'TreeSelect 树形选择器',
        name: 'tree_select',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Upload 上传',
        name: 'upload',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
  ],
  '数据展示': [
    ExamplePageModel(
        text: 'Avatar 头像',
        name: 'avatar',
        pageBuilder: _wrapInheritedTheme((context) => const TDAvatarPage())),
    ExamplePageModel(
        text: 'Badge 徽标',
        name: 'badge',
        pageBuilder: _wrapInheritedTheme((context) => const TDBadgePage())),
    ExamplePageModel(
        text: 'Cell 单元格',
        name: 'cell',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'CountDown 倒计时',
        name: 'countDown',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Collapse 折叠面板',
        name: 'collapse',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Empty 空状态',
        name: 'empty',
        pageBuilder: _wrapInheritedTheme((context) => const TDEmptyPage())),
    ExamplePageModel(
        text: 'Footer 页脚',
        name: 'footer',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Grid 宫格',
        name: 'grid',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Image 图片',
        name: 'image',
        pageBuilder: _wrapInheritedTheme((context) => const TDImagePage())),
    ExamplePageModel(
        text: 'ImageViewer 图片预览',
        name: 'imageViewer',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Progress 进度条',
        name: 'progress',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Result 结果',
        name: 'result',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Skeleton 骨架屏',
        name: 'skeleton',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Sticky 吸顶',
        name: 'sticky',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Swiper 轮播图',
        name: 'swiper',
        pageBuilder: _wrapInheritedTheme((context) => const TDSwiperPage())),
    ExamplePageModel(
        text: 'Tag 标签',
        name: 'tag',
        pageBuilder: _wrapInheritedTheme((context) => const TDTagPage())),
  ],
  '反馈': [
    ExamplePageModel(
        text: 'ActionSheet 动作面板',
        name: 'action_sheet',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Dialog 对话框',
        name: 'dialog',
        pageBuilder: _wrapInheritedTheme((context) => const TDDialogPage())),
    ExamplePageModel(
        text: 'DropdownMenu 下拉菜单',
        name: 'dropdown_menu',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Loading 加载',
        name: 'loading',
        pageBuilder: _wrapInheritedTheme((context) => const TDLoadingPage())),
    ExamplePageModel(
        text: 'Message 消息通知',
        name: 'message',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'NoticeBar 公告栏',
        name: 'noticeBar',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Overlay 遮罩层',
        name: 'overlay',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Popup 弹出层',
        name: 'popup',
        pageBuilder: _wrapInheritedTheme((context) => const TDPopupPage())),
    ExamplePageModel(
        text: 'PullDownRefresh 下拉刷新',
        name: 'refresh',
        pageBuilder:
            _wrapInheritedTheme((context) => const TdPullDownRefreshPage())),
    ExamplePageModel(
        text: 'Swipecell 滑动操作',
        name: 'swipecell',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Toast 轻提示',
        name: 'toast',
        pageBuilder: _wrapInheritedTheme((context) => const TDToastPage())),
  ],
  '其他': [
    ExamplePageModel(
        text: '主题--基础',
        name: 'theme',
        pageBuilder: _wrapInheritedTheme((context) => const TDThemePage())),
    ExamplePageModel(
        text: '圆角--基础',
        name: 'radius',
        pageBuilder: _wrapInheritedTheme((context) => const TDRadiusPage())),
  ],
};

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
        title: 'TDesign Flutter Example',
        theme: ThemeData(
            // extensions: [TDThemeData.defaultData().copyWith(colorMap: {'brandNormalColor':Colors.yellow})],
            colorScheme: ColorScheme.light(
                primary: TDTheme.of(context).brandNormalColor)),
        home: const MyHomePage(title: 'TDesgin Flutter 组件库'),
        onGenerateRoute: TDExampleRoute.onGenerateRoute,
        // // TODO:所有路径指向首页，需区分
        // routes: {
        //   for (var model in examplePageList)
        //     model.name: (context) => model.pageBuilder.call(context, model)
        // },
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
          actions: ScreenUtil.isWebLargeScreen(context)
              ? null
              : [
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
    if (ScreenUtil.isWebLargeScreen(context)) {
      return const web.WebMainBody();
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
    var children = <Widget>[];
    exampleMap.forEach((key, value) {
      children.add(Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
            color: TDTheme.of(context).brandHoverColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(TDTheme.of(context).radiusLarge))),
        child: TDText(
          key,
          textColor: TDTheme.of(context).whiteColor1,
        ),
      ));
      value.forEach((model) {
        if (model.isTodo) {
          if (_kShowTodoComponent) {
            children.add(Padding(
              padding:
                  const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8),
              child: TDButton(
                  size: TDButtonSize.medium,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.filled,
                  theme: TDButtonTheme.defaultTheme,
                  textStyle: TextStyle(color: TDTheme.of(context).fontGyColor4),
                  onTap: () {
                    Navigator.pushNamed(context, '${model.name}?showAction=1');
                  },
                  content: model.text),
            ));
          }
        } else {
          children.add(Padding(
            padding:
                const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8),
            child: TDButton(
                size: TDButtonSize.medium,
                type: TDButtonType.outline,
                shape: TDButtonShape.filled,
                theme: TDButtonTheme.primary,
                onTap: () {
                  Navigator.pushNamed(context, '${model.name}?showAction=1');
                },
                content: model.text),
          ));
        }
      });
    });
    return children;
  }
}
