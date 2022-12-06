import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/util/platform_util.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'api_widget.dart';
import 'example_base.dart';

/// 示例页面控件，建议每个页面返回一个ExampleWidget即可，不用独自封装
class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key, required this.title, required this.children, this.padding, this.backgroundColor,}) : super(key: key);

  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {

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
      // appBar: AppBar(title: Text('${widget.title}示例页'),
      //   actions: PlatformUtil.isWeb ? null : [
      //     GestureDetector(
      //       child:  Container(
      //         alignment: Alignment.centerRight,
      //         padding: const EdgeInsets.only(right: 32),
      //         child: TDText('Api >>',textColor: TDTheme.of(context).whiteColor1,),
      //       ),
      //       onTap: (){
      //         setState(() {
      //           apiVisible = !apiVisible;
      //         });
      //       },
      //     )
      //   ],
      // ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ScrollbarTheme(
          data: ScrollbarThemeData(trackVisibility: MaterialStateProperty.all(true)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TDNavBar(title: widget.title,rightBarItems: [
                  TDNavBarItem(icon: TDIcons.info_circle, action: (){
                    setState(() {
                      apiVisible = !apiVisible;
                    });
                  })
                ],),
                ApiWidget(apiName: model?.apiPath,visible: apiVisible,),
                TDText(widget.title, font: TDTheme.of().fontXS,),
                ...list,
              ],
            ),),
        ),
      ),
    );
  }
}


/// 示例样例，建议尽量使用该控件，写清晰说明内容
class ExampleModule extends StatelessWidget{

  const ExampleModule({Key? key, required this.desc, required this.builder}) : super(key: key);

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