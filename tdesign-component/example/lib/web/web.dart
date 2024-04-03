// ignore: avoid_web_libraries_in_flutter
import 'dart:html' if(dart.library.io) 'web_replace.dart' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../base/api_widget.dart';
import '../base/example_base.dart';
import '../config.dart';
import '../home.dart';
import 'code_widget.dart';

class WebMainBody extends StatefulWidget {
  const WebMainBody({Key? key}) : super(key: key);


  @override
  State<WebMainBody> createState() => _WebMainBodyState();
}

class _WebMainBodyState extends State<WebMainBody> {
  static const menuWidth = 280.0;

  var screenSizeList = <Size>[
    const Size(520, 1080),
    const Size(480, 720),
  ];

  String version = 'unknown';
  String? apiPath = 'text';
  String? codePath = 'text';
  String? mobilePath;


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

  void setApiPath({required String? apiPath,required String? mobilePath,String? codePath}){
    Future.delayed(const Duration(milliseconds: 500,), (){
      setState(() {
        this.apiPath = apiPath;
        this.mobilePath = mobilePath;
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

              // 菜单放到最上方，防止被屏幕外内容遮挡
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: menuWidth,
                    color: TDTheme.of(context).brandColor1,
                    child: _buildMenu(),
                  ),
                  Expanded(child: Container(
                    color: TDTheme.of(context).whiteColor1,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 32,top: 32),
                    child: DetailLayout(apiPath: apiPath, codePath: codePath,),
                  )),

                  Container(
                    margin: const EdgeInsets.only(left:32, top: 32,right: 32),
                    child: MobileWidget(page: mobilePath ?? 'TDTextPage',),
                  )
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
    return Column(
      children: [
        Container(
          height: 75,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16),
          color: TDTheme.of(context).brandHoverColor,
          child: TDText('TDesign 组件', textColor: TDTheme.of(context).whiteColor1,font: TDTheme.of(context).fontHeadlineLarge,),
        ) ,
        Expanded(child: ListView.builder(
            itemCount: examplePageList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var model = examplePageList[index];
              return Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: TDTheme
                        .of(context)
                        .grayColor4, width: 0.5))),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                    onTap: () {
                      WebApiController.setApiPath(apiPath: model.name,mobilePath: model.name, codePath: model.codePath ?? model.name, );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TDText(model.text),
                        Icon(TDIcons.chevron_right, color: TDTheme
                            .of(context)
                            .brandHoverColor,)
                      ],
                    )),
              );
            }))

      ],
    );
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
      SingleChildScrollView(
        child: ApiWidget(apiName: widget.apiPath,visible: true,),
      )
      ,
      CodeWidget(codePath: widget.codePath,),
    ];
    return tabViews;
  }
}

class MobileWidget extends StatefulWidget {
  const MobileWidget({Key? key,required this.page}) : super(key: key);

  final String page;

  @override
  State<MobileWidget> createState() => _MobileWidgetState();
}

class _MobileWidgetState extends State<MobileWidget> {

  double screenWidth = 520;
  double screenHeight = 1080;
  String? lastPage;

  Widget? lastWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWebView();
  }

  Widget getWebView() {
    if(widget.page == lastPage && lastWidget != null){
      return lastWidget!;
    }
    lastPage = widget.page;
    var _iframeElement = html.IFrameElement();
    // ignore: unsafe_html
    _iframeElement.src = _getSrc();
    _iframeElement.style.border = 'none';
    var id = 'iframeElement$lastPage';
// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      id,
          (int viewId) => _iframeElement,
    );
    Widget _iframeWidget;
    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: id,
    );


    lastWidget =   SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: <Widget>[
          IgnorePointer(
            ignoring: true,
            child: Center(
              child: _iframeWidget,
            ),
          ),
        ],
      ),
    );
    return lastWidget!;
  }

  String? _getSrc() {
    var href = html.window.location.href;
    return href.replaceFirst('#/', '#$lastPage');
  }
}



class WebApiController {
  static _WebMainBodyState? _state;

  static void setApiPath({required String? apiPath,required String? mobilePath, String? codePath}){
    _state?.setApiPath(apiPath: apiPath, mobilePath:mobilePath, codePath: codePath);
  }
}