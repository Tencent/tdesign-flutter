import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/src/util/log.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/example_route.dart';
import 'config.dart';
import 'home.dart';

void main() {
  Log.setCustomLogPrinter((level, tag, msg) => print('[$level] $tag ==> $msg'));
  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  exampleMap.forEach((key, value) {
    value.forEach((model) {
      examplePageList.add(model);
    });
  });
  sideBarExamplePage.forEach(examplePageList.add);
}

/// TDesign Flutter 组件库示例
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
            colorScheme: ColorScheme.light(primary: TDTheme.of(context).brandNormalColor)),
        home: PlatformUtil.isWeb ? null : const MyHomePage(title: 'TDesign Flutter 组件库'),
        // : const TestPage(),
        onGenerateRoute: TDExampleRoute.onGenerateRoute,
        routes: _getRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _getRoutes() {
    if (PlatformUtil.isWeb) {
      return {for (var model in examplePageList) model.name: (context) => model.pageBuilder.call(context, model)}
        ..putIfAbsent('/', () => (context) => const MyHomePage(title: 'TDesgin Flutter 组件库'));
    } else {
      return const {};
    }
  }
}
