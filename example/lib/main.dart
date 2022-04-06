import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_route.dart';



void main() {
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
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
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
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
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool useConch = false;

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
              children: <Widget>[
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'AvatarPage');
                    },
                    child: const Text(
                      '圆形图片组件（头像）',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'BadgePage');
                    },
                    child: const Text(
                      '红点',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'TabBarPage');
                    },
                    child: const Text(
                      '标签栏',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'ToastPage');
                    },
                    child: const Text(
                      '轻提示',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'ButtonPage');
                    },
                    child: const Text(
                      '按钮',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'InputViewPage');
                    },
                    child: const Text(
                      '输入框',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'TagPage');
                    },
                    child: const Text(
                      '标签',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'PickerPage');
                    },
                    child: const Text(
                      'Picker',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'IconPage');
                    },
                    child: const Text(
                      '图标',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'EmptyPage');
                    },
                    child: const Text(
                      '空白页面',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'ThemePage');
                    },
                    child: const Text(
                      '主题页面',
                    )),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'ImagePage');
                    },
                    child: const Text(
                      '图片组件',
                    )),
              ],
            ),
          ),
        ));
  }
}
