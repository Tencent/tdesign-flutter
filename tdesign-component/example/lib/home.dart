import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/example_base.dart';
import 'base/example_route.dart';
import 'config.dart';
import 'l10n/app_localizations.dart';

var _kShowTodoComponent = false;

/// 切换主题的回调
typedef OnThemeChange = Function(TThemeData themeData);

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
    sideBarExamplePage.forEach(TExampleRoute.add);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.tTheme.brandNormalColor,
        titleTextStyle: TextStyle(
          color: context.tTheme.whiteColor1,
          fontSize: context.tTheme.fontTitleLarge?.size,
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
                    child: Icon(
                      TIcons.setting,
                      color: context.tTheme.whiteColor1,
                    ),
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
                      Theme(
                        // mergeExtension 仅覆盖 TThemeData，保留 ColorScheme 等其他主题属性
                        data: Theme.of(context)
                            .mergeExtension(TThemeData.defaultData()),
                        child: TButton(
                          child: Text(
                              AppLocalizations.of(context)?.defaultTheme ?? ''),
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () async {
                            widget.onThemeChange
                                ?.call(TThemeData.defaultData());
                          },
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).mergeExtension(
                          TThemeData.fromJson('green', greenThemeConfig) ??
                              TThemeData.defaultData(),
                        ),
                        child: TButton(
                          child: Text(
                              AppLocalizations.of(context)?.greenTheme ?? ''),
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () async {
                            var jsonString = await rootBundle
                                .loadString('assets/theme.json');
                            var themeData = TThemeData.fromJson(
                                    'green', jsonString,
                                    darkName: 'greenDark') ??
                                TThemeData.defaultData();
                            widget.onThemeChange?.call(
                              themeData,
                            );
                          },
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).mergeExtension(
                          TThemeData.fromJson('red', greenThemeConfig) ??
                              TThemeData.defaultData(),
                        ),
                        child: TButton(
                          child: Text(
                              AppLocalizations.of(context)?.redTheme ?? ''),
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () async {
                            var jsonString = await rootBundle
                                .loadString('assets/theme.json');
                            var themeData = TThemeData.fromJson(
                                    'red', jsonString,
                                    darkName: 'redDark') ??
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
            TSearchBar(
              hintText: '请输入组件名称',
              focusNode: focusNode,
              onChanged: (value) {
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
      var cells = <TCell>[];
      value.forEach((model) {
        if (searchText.isNotEmpty &&
            !model.text.toLowerCase().contains(searchText.toLowerCase())) {
          // 如果有搜索文案,不再搜索中的组件不展示
          return;
        }
        if (model.isTodo) {
          if (_kShowTodoComponent) {
            cells.add(TCell(
              title: Text(model.displayText),
              arrow: true,
              onTap: () {
                Navigator.pushNamed(context, '${model.name}?showAction=1');
              },
            ));
          }
        } else {
          cells.add(TCell(
            title: Text(model.displayText),
            arrow: true,
            onTap: () {
              focusNode.unfocus();
              Navigator.pushNamed(context, '${model.name}?showAction=1');
            },
          ));
        }
      });
      if (cells.isNotEmpty) {
        children.add(
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: TCellGroup(
              title: Text('$key(${cells.length})'),
              variant: TCellGroupVariant.card,
              cells: cells,
            ),
          ),
        );
      }
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
