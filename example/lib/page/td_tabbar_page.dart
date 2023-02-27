import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDTabBarPage extends StatefulWidget {
  const TDTabBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDTabBarPageState();
}

class _TDTabBarPageState extends State<TDTabBarPage>
    with TickerProviderStateMixin {
  TabController? _tabController1;
  TabController? _tabController2;
  TabController? _tabController3;
  TabController? _tabController4;
  TabController? _tabController5;
  List<TDTab> tabs = [];
  List<Widget> tabViews = [];

  List<TDTab> _getTabs() {
    tabs = const [
      TDTab(
        text: '选项',
      ),
      TDTab(
        text: '选项',
      ),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
    ];
    return tabs;
  }

  List<Widget> _getTabViews() {
    tabViews = const [
      Center(child: TDText('内容区')),
      Center(child: TDText('内容区')),
      Center(child: TDText('内容区')),
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
    for (var i = 0; i < length; i++) {
      temp.add(tabs[i]);
    }
    switch (length) {
      case 3:
        temp[temp.length - 1] = const TDTab(text: '上限六个字');
        break;
      case 4:
        temp[temp.length - 1] = const TDTab(text: '上限四字');
        break;
      case 5:
        temp[temp.length - 1] = const TDTab(text: '上限三');
        break;
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
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: 'Tabs 选项卡',
        desc: '用于内容分类后的展示切换。',
        exampleCodeGroup: 'tabs',
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(desc: '均分选项卡', builder: _buildItemWithSplit1),
              ExampleItem(builder: _buildItemWithSplit2),
              ExampleItem(builder: _buildItemWithSplit3),
              ExampleItem(builder: _buildItemWithSplit4),
              ExampleItem(desc: '等距选项卡', builder: _buildItemWithSpace),
              ExampleItem(desc: '带图标选项卡', builder: _buildItemWithIcon),
              ExampleItem(desc: '带微标选项卡', builder: _buildItemWithLogo),
              ExampleItem(desc: '带内容区选项卡', builder: _buildItemWithContent),
            ],
          ),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '选项卡状态', builder: _buildItemWithStatus),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '选项卡尺寸', builder: _buildItemWithSizeSmall),
            ExampleItem(builder: _buildItemWithSizeBig),
            ExampleItem(desc: '选项卡样式', builder: _buildItemWithOutlineNormal),
            ExampleItem(builder: _buildItemWithOutlineCard),
          ]),
        ]);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit1(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      indicatorWidth: 16,
      indicatorHeight: 3,
      controller: _tabController1,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit2(BuildContext context) {
    return TDTabBar(
      tabs: subList(3),
      indicatorWidth: 16,
      indicatorHeight: 3,
      controller: _tabController2,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit3(BuildContext context) {
    return TDTabBar(
      tabs: subList(4),
      indicatorWidth: 16,
      indicatorHeight: 3,
      controller: _tabController3,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit4(BuildContext context) {
    return TDTabBar(
      tabs: subList(5),
      indicatorWidth: 16,
      indicatorHeight: 3,
      controller: _tabController4,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSpace(BuildContext context) {
    return TDTabBar(
      tabs: subList(6),
      indicatorWidth: 16,
      indicatorHeight: 3,
      controller: TabController(length: 6, vsync: this),
      backgroundColor: Colors.white,
      labelPadding: const EdgeInsets.all(10),
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithIcon(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '选项',
        icon: Icon(
          TDIcons.app,
          size: 14,
        ),
      ),
      const TDTab(
        text: '选项',
        icon: Icon(
          TDIcons.app,
          size: 14,
        ),
      ),
      const TDTab(
        text: '选项',
        icon: Icon(
          TDIcons.app,
          size: 14,
        ),
      ),
    ];
    return TDTabBar(
        tabs: tabs,
        indicatorWidth: 16,
        indicatorHeight: 3,
        controller: TabController(length: 3, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: true);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithLogo(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '选项',
        contentHeight: 48,
        textMargin: EdgeInsets.only(right: 8),
        badge: TDBadge(TDBadgeType.redPoint),
      ),
      const TDTab(
        text: '选项',
        contentHeight: 42,
        textMargin: EdgeInsets.only(right: 16, top: 2, bottom: 2),
        badge: TDBadge(
          TDBadgeType.message,
          message: '8',
        ),
      ),
      const TDTab(
        text: '选项',
        height: 48,
        icon: Icon(
          TDIcons.app,
          size: 14,
        ),
      ),
    ];
    return TDTabBar(
        tabs: tabs,
        indicatorWidth: 16,
        indicatorHeight: 3,
        controller: TabController(length: 3, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: true);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithContent(BuildContext context) {
    var tabController = TabController(length: 3, vsync: this);
    return SizedBox(
      height: 120 + 48,
      child: Column(
        children: [
          TDTabBar(
              tabs: subList(3),
              controller: tabController,
              showIndicator: true,
              backgroundColor: Colors.white,
              isScrollable: false,
              isVertical: false),
          Container(
            height: 120,
            color: Colors.white,
            child: TDTabBarView(
              children: _getTabViews(),
              controller: tabController,
            ),
          )
        ],
      ),
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithStatus(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '选中',
      ),
      const TDTab(
        text: '默认',
      ),
      const TDTab(
        text: '禁用',
        enable: false,
      ),
    ];
    return TDTabBar(
        tabs: tabs,
        indicatorWidth: 16,
        indicatorHeight: 3,
        controller: TabController(length: 3, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: true);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSizeSmall(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '小尺寸',
      ),
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
    ];
    return TDTabBar(
        tabs: tabs,
        indicatorWidth: 16,
        indicatorHeight: 3,
        controller: TabController(length: 4, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: true);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSizeBig(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '大尺寸',
        size: TDTabSize.large,
      ),
      const TDTab(
        text: '选项',
        size: TDTabSize.large,
      ),
      const TDTab(
        text: '选项',
        size: TDTabSize.large,
      ),
      const TDTab(
        text: '选项',
        size: TDTabSize.large,
      ),
    ];
    return TDTabBar(
        tabs: tabs,
        indicatorWidth: 16,
        indicatorHeight: 3,
        controller: TabController(length: 4, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: true);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithOutlineNormal(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
    ];
    return TDTabBar(
        tabs: tabs,
        indicatorWidth: 16,
        indicatorHeight: 3,
        outlineType: TDTabBarOutlineType.capsule,
        labelPadding: const EdgeInsets.all(10),
        controller: TabController(length: 4, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: false);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithOutlineCard(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
      const TDTab(
        text: '选项',
      ),
    ];
    return TDTabBar(
        tabs: tabs,
        indicatorWidth: 16,
        indicatorHeight: 3,
        outlineType: TDTabBarOutlineType.card,
        controller: TabController(length: 4, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: false);
  }
}
