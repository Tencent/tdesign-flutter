import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/util/platform_util.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'api_widget.dart';


typedef PageBuilder = Widget Function(BuildContext context, ExamplePageModel model);

/// 示例页面数据
class ExamplePageModel{

  ExamplePageModel({required this.text,required this.path, this.apiPath, this.codePath,required this.pageBuilder,});

  final String text;
  final String path;
  final String? apiPath;
  final String? codePath;
  final PageBuilder pageBuilder;
}

/// 示例页面控件，建议每个页面返回一个ExampleWidget即可，不用独自封装
class ExampleWidget extends StatefulWidget {
  const ExampleWidget({Key? key, required this.title, required this.children, this.padding, this.backgroundColor,}) : super(key: key);

  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {

  late var list;
  bool apiVisible = false;
  ExamplePageModel? model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      var modelTheme = context.dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
      model = modelTheme?.model;

    });
    list = <Widget>[
      for(var item in widget.children)
        Container(
          padding: widget.padding ?? const EdgeInsets.all(16),
          child: item,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(title: Text('${widget.title}示例页'),
        actions: PlatformUtil.isWeb ? null : [
          GestureDetector(
            child:  Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 32),
              child: TDText('Api >>',textColor: TDTheme.of(context).whiteColor1,),
            ),
            onTap: (){
              setState(() {
                apiVisible = !apiVisible;
              });
            },
          )
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ScrollbarTheme(
          data: ScrollbarThemeData(trackVisibility: MaterialStateProperty.all(true)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ApiWidget(apiName: model?.apiPath,visible: apiVisible,), ...list,
              ],
            ),),
        ),
      ),
    );
  }
}


/// 示例样例，建议尽量使用该控件，写清晰说明内容
class ExampleItem extends StatelessWidget{

  const ExampleItem({Key? key, required this.desc, required this.builder}) : super(key: key);

  final String desc;

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('示例——$desc', style: const TextStyle(color: Colors.black45),),
        builder(context),
      ],
    );
  }
}

/// 存储主题数据的内部控件
class ExamplePageInheritedTheme extends InheritedWidget {
  final ExamplePageModel model;

  const ExamplePageInheritedTheme(
      {required this.model, Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant ExamplePageInheritedTheme oldWidget) {
    return model != oldWidget.model;
  }
}

