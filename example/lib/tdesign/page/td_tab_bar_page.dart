import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class TdTabBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdTabBarPageState();
}

class _TdTabBarPageState extends State<TdTabBarPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<TDTab> tabs = [];

  List<TDTab> _getTabs() {
    tabs = const [
      TDTab(text: '标签页一'),
      TDTab(text: '标签页二'),
      TDTab(text: '标签页三'),
      TDTab(text: '标签页四'),
    ];
    return tabs;
  }

  List<Widget> _getTabViews() {
    return [
      ListView.builder(
        itemBuilder: (context, index) => const Text('123'),
        itemCount: 50,
      ),
      ListView.builder(
        itemBuilder: (context, index) => const Text('123'),
        itemCount: 50,
      ),
      ListView.builder(
        itemBuilder: (context, index) => const Text('123'),
        itemCount: 50,
      ),
      ListView.builder(
        itemBuilder: (context, index) => const Text('123'),
        itemCount: 50,
      ),
    ];
  }

  //初始化tab
  void _initTabController(BuildContext context) {
    var tabNum = _getTabs().length;
    _tabController = TabController(length: tabNum, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      _initTabController(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabbar组件'),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
                child: TDTabBar(
              tabs: _getTabs(),
              controller: _tabController,
              backgroundColor: Colors.white,
              showIndicator: true,
            )),
          ];
        },
        body: TDTabBarView(
          isSlideSwitch: true,
          controller: _tabController,
          children: _getTabViews(),
        ),
      ),
    );
  }
}
