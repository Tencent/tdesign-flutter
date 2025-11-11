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
  TDThemeData themeData
);

/// 切换语言的回调
typedef OnLocaleChange = Function(Locale locale);

/// 示例首页
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    this.onThemeChange,
    this.locale,
    this.onLocaleChange,
  }) : super(key: key);

  final String title;

  final OnThemeChange? onThemeChange;

  final OnLocaleChange? onLocaleChange;

  final Locale? locale;

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
    TDExampleRoute.init();
    sideBarExamplePage.forEach(TDExampleRoute.add);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TDTheme.of(context).brandNormalColor,
        titleTextStyle: TextStyle(
          color: TDTheme.of(context).whiteColor1,
          fontSize: TDTheme.of(context).fontTitleLarge?.size,
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
                    child: TDText(
                      widget.locale?.languageCode == 'en' ? '中文' : 'English',
                      textColor: TDTheme.of(context).whiteColor1,
                    ),
                  ),
                  onTap: () {
                    if (widget.locale?.languageCode == 'en') {
                      widget.onLocaleChange?.call(const Locale('zh'));
                    } else {
                      widget.onLocaleChange?.call(const Locale('en'));
                    }
                  },
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),
                    child: TDText(
                      AppLocalizations.of(context)?.about,
                      textColor: TDTheme.of(context).whiteColor1,
                    ),
                  ),
                  onTap: () {
                    focusNode.unfocus();
                    Navigator.pushNamed(context, TDExampleRoute.aboutPath);
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
                      TDTheme(
                        data: TDThemeData.defaultData(),
                        child: TDButton(
                          text: AppLocalizations.of(context)?.defaultTheme,
                          theme: TDButtonTheme.primary,
                          onTap: () async {
                            widget.onThemeChange?.call(
                                TDThemeData.defaultData());
                          },
                        ),
                      ),
                      TDTheme(
                        data: TDThemeData.fromJson('green', greenThemeConfig) ??
                            TDThemeData.defaultData(),
                        child: TDButton(
                          text: AppLocalizations.of(context)?.greenTheme,
                          theme: TDButtonTheme.primary,
                          onTap: () async {
                            var jsonString = await rootBundle
                                .loadString('assets/theme.json');
                            var themeData = TDThemeData.fromJson(
                                    'green', jsonString, darkName: 'greenDark') ??
                                TDThemeData.defaultData();
                            widget.onThemeChange?.call(
                              themeData,
                            );
                          },
                        ),
                      ),
                      TDTheme(
                        data: TDThemeData.fromJson('red', greenThemeConfig) ??
                            TDThemeData.defaultData(),
                        child: TDButton(
                          text: AppLocalizations.of(context)?.redTheme,
                          theme: TDButtonTheme.primary,
                          onTap: () async {
                            var jsonString = await rootBundle
                                .loadString('assets/theme.json');
                            var themeData =
                                TDThemeData.fromJson('red', jsonString, darkName: 'redDark') ??
                                    TDThemeData.defaultData();
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
            TDSearchBar(
              placeHolder: '请输入组件名称',
              focusNode: focusNode,
              onTextChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
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
              child: TDButton(
                  size: TDButtonSize.medium,
                  type: TDButtonType.outline,
                  shape: TDButtonShape.filled,
                  theme: TDButtonTheme.defaultTheme,
                  textStyle: TextStyle(color: TDTheme.of(context).fontGyColor4),
                  onTap: () {
                    Navigator.pushNamed(context, '${model.name}?showAction=1');
                  },
                  text: model.text),
            ));
          }
        } else {
          subList.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            child: TDButton(
                size: TDButtonSize.medium,
                type: TDButtonType.outline,
                shape: TDButtonShape.filled,
                theme: TDButtonTheme.primary,
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
            color: TDTheme.of(context).brandHoverColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(TDTheme.of(context).radiusLarge))),
        child: TDText(
          '$key(${subList.length})',
          textColor: TDTheme.of(context).whiteColor1,
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
