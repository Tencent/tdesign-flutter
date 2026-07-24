import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/example_base.dart';
import 'base/example_route.dart';
import 'base/web_md_tool.dart';
import 'config.dart';
import 'l10n/app_localizations.dart';

var _kShowTodoComponent = false;

/// 切换主题的回调
typedef OnThemeChange = Function(
  TThemeData themeData
);

/// 切换语言的回调
typedef OnLocaleChange = Function(Locale locale);

/// 示例首页
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    this.onThemeChange,
  }) : super(key: key);

  final String title;

  final OnThemeChange? onThemeChange;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool useConch = false;
  String searchText = '';
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    TExampleRoute.init();
    // TEMPORARY MIGRATION COMPATIBILITY:
    // Sidebar demo 暂未纳入本基础组件 PR，后续 Sidebar 迁移后恢复注册。
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TTheme.of(context).brandNormalColor,
        titleTextStyle: TextStyle(
          color: TTheme.of(context).whiteColor1,
          fontSize: TTheme.of(context).fontTitleLarge?.size,
        ),
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
                    child: Icon(TIcons.setting, color: TTheme.of(context).whiteColor1,),
                  ),
                  onTap: () {
                    focusNode.unfocus();
                    Navigator.pushNamed(context, TExampleRoute.aboutPath);
                  },
                )
              ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TTheme(
                        data: TThemeData.defaultData(),
                        child: TButton(
                          text: AppLocalizations.of(context)?.defaultTheme,
                          theme: TButtonTheme.primary,
                          onTap: () async {
                            widget.onThemeChange?.call(
                                TThemeData.defaultData());
                          },
                        ),
                      ),
                      TTheme(
                        data: TThemeData.fromJson('green', greenThemeConfig) ??
                            TThemeData.defaultData(),
                        child: TButton(
                          text: AppLocalizations.of(context)?.greenTheme,
                          theme: TButtonTheme.primary,
                          onTap: () async {
                            var jsonString = await rootBundle
                                .loadString('assets/theme.json');
                            var themeData = TThemeData.fromJson(
                                    'green', jsonString, darkName: 'greenDark') ??
                                TThemeData.defaultData();
                            widget.onThemeChange?.call(
                              themeData,
                            );
                          },
                        ),
                      ),
                      TTheme(
                        data: TThemeData.fromJson('red', greenThemeConfig) ??
                            TThemeData.defaultData(),
                        child: TButton(
                          text: AppLocalizations.of(context)?.redTheme,
                          theme: TButtonTheme.primary,
                          onTap: () async {
                            var jsonString = await rootBundle
                                .loadString('assets/theme.json');
                            var themeData =
                                TThemeData.fromJson('red', jsonString, darkName: 'redDark') ??
                                    TThemeData.defaultData();
                            widget.onThemeChange?.call(
                              themeData,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              // TEMPORARY MIGRATION COMPATIBILITY:
              // SearchBar 暂未纳入本基础组件 PR，先用 Flutter 原生输入框承载首页筛选。
              // 后续 SearchBar 组件迁移后恢复为 TSearchBar。
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: '请输入组件名称',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildChildren(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    var children = <Widget>[];

    // 添加切换主题的按钮
    exampleMap.forEach((key, value) {
      var subList = <Widget>[];
      value.forEach((model) {
        if (searchText.isNotEmpty &&
            !model.text.toLowerCase().contains(searchText.toLowerCase())) {
          // 如果有搜索文案,不再搜索中的组件不展示
          return;
        }
        model.spline = WebMdTool.getSpline(key);
        if (model.isTodo) {
          if (_kShowTodoComponent) {
            children.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              child: TButton(
                  size: TButtonSize.medium,
                  type: TButtonType.outline,
                  shape: TButtonShape.filled,
                  theme: TButtonTheme.defaultTheme,
                  textStyle: TextStyle(color: TTheme.of(context).fontGyColor4),
                  onTap: () {
                    Navigator.pushNamed(context, '${model.name}?showAction=1');
                  },
                  text: model.text),
            ));
          }
        } else {
          subList.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            child: TButton(
                size: TButtonSize.medium,
                type: TButtonType.outline,
                shape: TButtonShape.filled,
                theme: TButtonTheme.primary,
                onTap: () {
                  focusNode.unfocus();
                  Navigator.pushNamed(context, '${model.name}?showAction=1');
                },
                text: model.text),
          ));
        }
      });
      children.add(Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
            color: TTheme.of(context).brandHoverColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(TTheme.of(context).radiusLarge))),
        child: TText(
          '$key(${subList.length})',
          textColor: TTheme.of(context).whiteColor1,
        ),
      ));
      children.addAll(subList);
    });
    return children;
  }
}

String greenThemeConfig = '''
  {
    "green": {
        "color": {
            "brandColor1": "#e4f9e9",
            "brandColor2": "#c8f2d7",
            "brandColor3": "#94dab2",
            "brandColor4": "#45c58b",
            "brandColor5": "#33a371",
            "brandColor6": "#008857",
            "brandColor7": "#006c44",
            "brandColor8": "#005333",
            "brandColor9": "#003b23",
            "brandColor10": "#002515"
        }
    },
    "red": {
        "color": {
            "brandColor1": "#fff0f1",
            "brandColor2": "#ffd8dd",
            "brandColor3": "#ffb7c1",
            "brandColor4": "#ff8fa2",
            "brandColor5": "#ff5479",
            "brandColor6": "#db3d62",
            "brandColor7": "#b2294b",
            "brandColor8": "#8d1135",
            "brandColor9": "#690021",
            "brandColor10": "#480014"
        }
    }
}
  ''';
