import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'main.dart';
import 'tdesign/api_widget.dart';
import 'tdesign/code_widget.dart';
import 'tdesign/example_route.dart';

class WebMainBody extends StatefulWidget {
  const WebMainBody({Key? key}) : super(key: key);


  @override
  State<WebMainBody> createState() => _WebMainBodyState();
}

class _WebMainBodyState extends State<WebMainBody> {
  double screenWidth = 520;
  double screenHeight = 1080;
  static const menuWidth = 300.0;

  var screenSizeList = <Size>[
    const Size(520, 1080),
    const Size(480, 720),
  ];

  String version = 'unknown';
  String? apiPath;
  String? codePath;

  @override
  void initState() {
    super.initState();
    WebApiController._state = this;
    _getVersion();
  }

  Future<void> _getVersion() async {
    version = await rootBundle.loadString('assets/version');
    setState(() {});
  }

 @override
  void dispose() {
   WebApiController._state = null;
    super.dispose();
  }

  void setApiPath({required String? apiPath, codePath}){
    Future.delayed(const Duration(milliseconds: 500,), (){
      setState(() {
        this.apiPath = apiPath;
        this.codePath = codePath;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(
          color: TDTheme.of().grayColor2,
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: screenWidth + 200),
                margin: const EdgeInsets.only(left: menuWidth),
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    var screenTop = (constraint.maxHeight - screenHeight) / 2;
                    var screenLeft = (constraint.maxWidth - screenWidth) / 2;
                    return Stack(
                      children: [
                        Positioned(
                            top: screenTop,
                            left: screenLeft,
                            width: screenWidth,
                            height: screenHeight,
                            child: MaterialApp(
                              title: 'Flutter Demo',
                              theme: ThemeData(
                                  colorScheme: ColorScheme.light(
                                      primary: TDTheme.of(context)
                                          .brandNormalColor)),
                              home: const WebHome(),
                              onGenerateRoute: TDExampleRoute.onGenerateRoute,
                            )),

                        // 构建遮挡, 防止看到视图从屏幕外进入
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: screenTop + screenHeight,
                          right: 0,
                          child: Container(
                            color: TDTheme.of(context).grayColor2,
                          ),
                        ),
                        // 构建遮挡
                        Positioned(
                          top: screenTop + screenHeight,
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: Container(
                            color: TDTheme.of(context).grayColor2,
                          ),
                        ),
                        // 构建遮挡
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          right: screenLeft + screenWidth,
                          child: Container(
                            color: TDTheme.of(context).grayColor2,
                          ),
                        ),
                        // 构建遮挡
                        Positioned(
                          top: 0,
                          left: screenLeft + screenWidth,
                          bottom: 0,
                          right: 0,
                          child: Container(
                            color: TDTheme.of(context).grayColor2,
                          ),
                        ),

                        // 选择屏幕规格
                        Positioned(
                            top: 0,
                            left: 0,
                            child: SizedBox(
                                height:50,
                                child:  ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: screenSizeList.length + 1,
                                    itemBuilder: (context,index){
                                      if(index == 0){
                                        return Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const TDText('屏幕尺寸:'),
                                        );
                                      }
                                      index--;
                                      return Container(
                                        margin: const EdgeInsets.all(5),
                                        child: GestureDetector(
                                          child: TDButton(content: '${screenSizeList[index].width} * ${screenSizeList[index].height}',
                                            style: TDButtonStyle.warningWeakly(),
                                            size: TDButtonSize.small,),
                                          onTap: (){
                                            setState(() {
                                              screenWidth = screenSizeList[index].width;
                                              screenHeight = screenSizeList[index].height;
                                            });
                                          },
                                        ),
                                      );
                                    })
                            ))

                      ],
                    );
                  },
                ),
              ),

              // 菜单放到最上方，防止被屏幕外内容遮挡
              Row(
                children: [
                  Container(
                    width: menuWidth,
                    color: TDTheme.of(context).whiteColor1,
                    child: _buildMenu(),
                  ),
                  Container(
                    width:  screenWidth + 200,
                  ),
                  Expanded(child: Container(
                    color: TDTheme.of(context).whiteColor1,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 32,top: 32),
                    child: DetailLayout(apiPath: apiPath, codePath: codePath,),
                  )),
                ],
              ),

            ],
          ),
        )),

        // 通底
        Container(
          height: 50,
          color: TDTheme.of(context).brandColor2,
          alignment: Alignment.center,
          child: TDText('版本号：$version', textColor: TDTheme.of(context).fontGyColor1,),
        )
      ],
    );
  }

  Widget _buildMenu(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildChildren(context),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return <Widget>[
      for (var model in examplePageList)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TDButton(
              style: TDButtonStyle.weakly(),
              size: TDButtonSize.small,
              onTap: () {
                var navigator = WebHome.navigator ?? Navigator.of(context);
                navigator.pushNamed(model.path);
              },
              content: model.text),
        )
    ];
  }
}

class WebHome extends StatelessWidget {
  const WebHome({Key? key}) : super(key: key);

  static NavigatorState? navigator;

  @override
  Widget build(BuildContext context) {
    navigator = Navigator.of(context);
    return Container(
      color: TDTheme.of(context).whiteColor1,
      alignment: Alignment.center,
      child: const TDText('Hello World'),
    );
  }
}

class DetailLayout extends StatefulWidget {
  const DetailLayout({Key? key, required this.apiPath, this.codePath}) : super(key: key);

  final String? apiPath;
  final String? codePath;

  @override
  State<DetailLayout> createState() => _DetailLayoutState();
}

class _DetailLayoutState extends State<DetailLayout> with TickerProviderStateMixin {


  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TDTabBar(
          tabs: _getTabs(),
          controller: _tabController,
          backgroundColor: Colors.white,
          showIndicator: true,
          isScrollable: true,
        ),
        Expanded(child: TDTabBarView(
          children: _getTabViews(),
          controller: _tabController,
        ))
      ],
    );
  }

  List<TDTab> _getTabs() {
    var tabs = const [
      TDTab(text: 'Api'),
      TDTab(text: 'Code'),
    ];
    return tabs;
  }

  List<Widget> _getTabViews() {
    var tabViews = [
      ApiWidget(apiName: widget.apiPath,visible: true,),
      CodeWidget(codePath: widget.codePath,),
    ];
    return tabViews;
  }
}


class WebApiController {
  static _WebMainBodyState? _state;

  static setApiPath({required String? apiPath, String? codePath}){
    _state?.setApiPath(apiPath: apiPath, codePath: codePath);
  }
}