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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late TDThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _themeData = TDThemeData.defaultData();
  }

  @override
  Widget build(BuildContext context) {
    // 使用多套主题
    TDTheme.needMultiTheme();

    return MaterialApp(
      title: 'TDesign Flutter Example',
      theme: ThemeData(
          extensions: [_themeData],
          colorScheme: ColorScheme.light(primary: _themeData.brandNormalColor)),
      home: PlatformUtil.isWeb ? null :  MyHomePage(title: 'TDesign Flutter 组件库', onThemeChange: (themeData){
        setState(() {
          _themeData = themeData;
        });
      },),
      onGenerateRoute: TDExampleRoute.onGenerateRoute,
      routes: _getRoutes(),
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
