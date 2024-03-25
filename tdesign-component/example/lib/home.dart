import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/example_base.dart';
import 'base/example_route.dart';
import 'base/web_md_tool.dart';
import 'config.dart';
import 'web/web.dart' if (dart.library.io) 'web/web_replace.dart' as web;

var _kShowTodoComponent = false;

/// 示例首页
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
    sideBarExamplePage.forEach(TDExampleRoute.add);
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

// 测试页面
class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TDText(
              '测试文本',
              textColor: TDTheme.of(context).brandNormalColor,
              font: TDTheme.of(context).fontBodyMedium,
            ),
            const TDButton(
              text: '演示按钮',
              theme: TDButtonTheme.primary,
            )
          ],
        ),
      ),
    );
  }
}

String testThemeConfig = '''
  {
    "test": {
        "color": {
            "brandNormalColor": "#F6685D"
        },
        "font": {
            "fontBodyMedium": {
                "size": 40,
                "lineHeight": 55
            }
        }
    }
}
  ''';
