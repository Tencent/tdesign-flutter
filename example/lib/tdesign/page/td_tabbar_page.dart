import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_widget.dart';


class TDTabBarPage extends StatefulWidget {
  const TDTabBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDTabBarPageState();
}

class _TDTabBarPageState extends State<TDTabBarPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  TabController? _tabController1;
  TabController? _tabController2;
  TabController? _tabController3;
  TabController? _tabController4;
  TabController? _tabController5;
  List<TDTab> tabs = [];
  List<Widget> tabViews = [];

  List<TDTab> _getTabs() {
    tabs = const [
      TDTab(text: '标签页一'),
      TDTab(text: '标签页二'),
      TDTab(text: '标签页三'),
      TDTab(text: '标签页四'),
      TDTab(text: '标签页五'),
    ];
    return tabs;
  }

  List<Widget> _getTabViews() {
    tabViews = const [
      Center(child: TDText('内容一')),
      Center(child: TDText('内容二')),
      Center(child: TDText('内容三')),
      Center(child: TDText('内容四')),
    ];
    return tabViews;
  }

  @override
  void initState() {
    _initTabController();
    _getTabs();
    super.initState();
  }

  List<TDTab> subList(int length) {
    var temp = <TDTab>[];
    for(var i = 0; i < length; i++) {
      temp.add(tabs[i]);
    }
    return temp;
  }

  //初始化tab
  void _initTabController() {
    _tabController1 = TabController(length: 2, vsync: this);
    _tabController2 = TabController(length: 3, vsync: this);
    _tabController3 = TabController(length: 4, vsync: this);
    _tabController4 = TabController(length: 5, vsync: this);
    _tabController5 = TabController(length: 4, vsync: this);
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: '选项卡 Tabs TDTabBar',
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        ExampleModule(
          desc: '横向选项卡',
          builder: (BuildContext context) {
            return Column(
              children: [
                TDTabBar(
                  tabs: subList(2),
                  controller: _tabController1,
                  backgroundColor: Colors.white,
                  showIndicator: true,
                ),
                TDTabBar(
                  tabs: subList(3),
                  controller: _tabController2,
                  backgroundColor: Colors.white,
                  showIndicator: true,
                ),
                TDTabBar(
                  tabs: subList(4),
                  controller: _tabController3,
                  backgroundColor: Colors.white,
                  showIndicator: true,
                ),
                TDTabBar(
                  tabs: _getTabs(),
                  controller: _tabController4,
                  backgroundColor: Colors.white,
                  showIndicator: true,
                  isScrollable: true,
                ),
              ],
            );
          },
        ),
        ExampleModule(
          desc: '无下划线横向选项卡',
          builder: (BuildContext context) {
            return TDTabBar(
              tabs: _getTabs(),
              controller: _tabController,
              backgroundColor: Colors.white,
              isScrollable: true,
            );
          },
        ),
        ExampleModule(
          desc: '竖向选项卡',
          builder: (BuildContext context) {
            return LayoutBuilder(builder: (context, constraints){

              return SizedBox(
                width: constraints.maxWidth,
                height: 4 * 54,
                child: Row(
                  children: [
                    TDTabBar(
                        width: 104,
                        tabs: subList(4),
                        controller: _tabController5,
                        showIndicator: true,
                        backgroundColor: Colors.white,
                        isScrollable: false,
                        isVertical: true
                    ),
                    Container(
                      width: constraints.maxWidth - 104,
                      color: Colors.white,
                      child: TDTabBarVerticalView(
                        children: _getTabViews(),
                        controller: _tabController5,
                      ),
                    )
                  ],
                ),
              );
            });
          },
        ),
      ],
    );
  }
}
