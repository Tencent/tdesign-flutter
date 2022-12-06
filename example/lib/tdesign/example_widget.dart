import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/util/platform_util.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'api_widget.dart';
import 'example_base.dart';

/// 示例页面控件，建议每个页面返回一个ExampleWidget即可，不用独自封装
class ExamplePage extends StatefulWidget {
  const ExamplePage({
    Key? key,
    required this.title,
    this.desc = '',
    required this.children,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  final String title;
  final String desc;
  final List<ExampleModule> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late List<ExampleModule> list;
  bool apiVisible = false;
  ExamplePageModel? model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var modelTheme = context
          .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
      model = modelTheme?.model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor,
        body: ScrollbarTheme(
            data: ScrollbarThemeData(
                trackVisibility: MaterialStateProperty.all(true)),
            child: Column(
              children: [
                TDNavBar(
                  title: widget.title,
                  rightBarItems: [
                    TDNavBarItem(
                        icon: TDIcons.info_circle,
                        action: () {
                          setState(() {
                            apiVisible = !apiVisible;
                          });
                        })
                  ],
                ),
                Expanded(child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: widget.children.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ApiWidget(
                              apiName: model?.apiPath,
                              visible: apiVisible,
                            ),
                            TDText(
                              widget.title,
                              font: TDTheme.of(context).fontHeadlineSmall,
                              textColor: TDTheme.of(context).fontGyColor1,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4,),
                              child: TDText(
                                widget.desc,
                                font: TDTheme.of(context).fontBodyMedium,
                                textColor: TDTheme.of(context).fontGyColor2,
                              ),
                            ),
                            // Expanded(child: ),
                          ],
                        ),
                      );
                    }
                    var data = widget.children[index - 1];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(margin: const EdgeInsets.only(left: 16,right: 16,top: 16),
                          child: TDText(
                          '${index < 10 ? "0$index" : index} ${data.title}',
                          font: TDTheme.of(context).fontTitleLarge,
                          textColor: TDTheme.of(context).fontGyColor1,
                        ),)
                        ,
                        for(var item in data.children)
                          Container(
                            margin: widget.padding,
                            child: item,
                          )
                      ],
                    );
                  },
                ))

              ],
            )));
  }
}

/// 示例模块
class ExampleModule {
  const ExampleModule({Key? key, required this.title, required this.children});

  final String title;

  final List<ExampleItem> children;
}

/// 示例样例，建议尽量使用该控件，写清晰说明内容
class ExampleItem extends StatelessWidget {
  const ExampleItem({Key? key, this.desc = '', required this.builder, this.center = true})
      : super(key: key);

  final String desc;

  final WidgetBuilder builder;

  final bool center;

  @override
  Widget build(BuildContext context) {
    var child = builder(context);
    if(center){
      child =  Center(child: builder(context),);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        desc.isEmpty ? Container() : Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: TDText(desc, font: TDTheme.of(context).fontBodyMedium, textColor: TDTheme.of(context).fontGyColor2,),
        ),
        child
      ],
    );
  }
}
