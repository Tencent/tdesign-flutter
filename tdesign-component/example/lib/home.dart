import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/example_base.dart';
import 'base/example_route.dart';
import 'base/web_md_tool.dart';
import 'config.dart';
import 'web/web.dart' if (dart.library.io) 'web/web_replace.dart' as web;

var _kShowTodoComponent = false;

/// 切换主题的回调
typedef OnThemeChange = Function(TDThemeData themeData);

/// 示例首页
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, this.onThemeChange}) : super(key: key);

  final String title;

  final OnThemeChange? onThemeChange;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool useConch = false;

  late TDThemeData _themeData;

  @override
  void initState() {
    super.initState();
    TDExampleRoute.init();
    sideBarExamplePage.forEach(TDExampleRoute.add);
    _themeData = TDThemeData.defaultData();
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (ScreenUtil.isWebLargeScreen(context)) {
      return const web.WebMainBody();
    }
    return SafeArea(
        child: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChildren(context),
        ),
      ),
    ));
  }

  List<Widget> _buildChildren(BuildContext context) {
    var children = <Widget>[];

    // 添加切换主题的按钮
    children.add(Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TDTheme(
              data: TDThemeData.defaultData(),
              child: TDButton(
                text: '默认主题',
                theme: TDButtonTheme.primary,
                onTap: () {
                  widget.onThemeChange?.call(TDTheme.defaultData());
                  // setState(() {
                  //   _themeData = TDTheme.defaultData();
                  // });
                },
              )),
          TDTheme(
              data: TDThemeData.fromJson('green', greenThemeConfig) ?? TDThemeData.defaultData(),
              child: TDButton(
                  text: '绿色主题',
                  theme: TDButtonTheme.primary,
                  onTap: () async {
                    var jsonString = await rootBundle.loadString('assets/theme.json');
                    var newData = TDThemeData.fromJson('green', jsonString);
                    widget.onThemeChange?.call(newData ?? TDTheme.defaultData());
                    // setState(() {
                    //   _themeData = newData ?? TDTheme.defaultData();
                    // });
                  })),
          TDTheme(
              data: TDThemeData.fromJson('red', greenThemeConfig) ?? TDThemeData.defaultData(),
              child: TDButton(
                  text: '红色主题',
                  theme: TDButtonTheme.danger,
                  onTap: () async {
                    var jsonString = await rootBundle.loadString('assets/theme.json');
                    var newData = TDThemeData.fromJson('red', jsonString);
                    widget.onThemeChange?.call(newData ?? TDTheme.defaultData());
                  })),
        ],
      ),
    ));

    exampleMap.forEach((key, value) {
      children.add(Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
            color: TDTheme.of(context).brandHoverColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(TDTheme.of(context).radiusLarge))),
        child: TDText(
          key,
          textColor: TDTheme.of(context).whiteColor1,
        ),
      ));
      value.forEach((model) {
        model.spline = WebMdTool.getSpline(key);
        if (model.isTodo) {
          if (_kShowTodoComponent) {
            children.add(Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8),
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
          children.add(Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 8, bottom: 8),
            child: TDButton(
                size: TDButtonSize.medium,
                type: TDButtonType.outline,
                shape: TDButtonShape.filled,
                theme: TDButtonTheme.primary,
                onTap: () {
                  Navigator.pushNamed(context, '${model.name}?showAction=1');
                },
                text: model.text),
          ));
        }
      });
    });

    return children;
  }
}


String greenThemeConfig = '''
  {
    "green": {
        "color": {
            "brandNormalColor": "#45c58b"
        }
    },
    "red": {
        "color": {
            "brandNormalColor": "#ff0000"
        }
    }
}
  ''';
