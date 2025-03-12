import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDTabsPage extends StatefulWidget {
  const TDTabsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDTabsPageState();
}

class _TDTabsPageState extends State<TDTabsPage>
    with TickerProviderStateMixin {
  TabController? _tabController1;
  TabController? _tabController2;
  TabController? _tabController3;
  TabController? _tabController4;
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
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
      TDTab(text: '选项'),
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
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于内容分类后的展示切换。',
        exampleCodeGroup: 'tabs',
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(desc: '均分选项卡', builder: _buildItemWithSplit1),
              ExampleItem(builder: _buildItemWithSplit2, padding: const EdgeInsets.only(top: 16)),
              ExampleItem(builder: _buildItemWithSplit3, padding: const EdgeInsets.only(top: 16)),
              ExampleItem(builder: _buildItemWithSplit4, padding: const EdgeInsets.only(top: 16)),
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
            ExampleItem(builder: _buildItemWithSizeBig, padding: const EdgeInsets.only(top: 16)),
            ExampleItem(desc: '选项卡样式', builder: _buildItemWithOutlineNormal),
            ExampleItem(builder: _buildItemWithOutlineCard, padding: const EdgeInsets.only(top: 16)),
          ]),
        ],
    test: [
      ExampleItem(desc: '自定义下标属性', builder: _customIndicatorStyle),
      ExampleItem(desc: '自定义下划线样式', builder: _customDividerStyle),
      ExampleItem(desc: '不展示下划线-高度为0', builder: _hideBottomDivider),
      ExampleItem(desc: 'capsule类型可修改背景色', builder: _capsuleBackgroundColor),
    ],);
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit1(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      controller: _tabController1,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit2(BuildContext context) {
    return TDTabBar(
      tabs: subList(3),
      controller: _tabController2,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit3(BuildContext context) {
    return TDTabBar(
      tabs: subList(4),
      controller: _tabController3,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit4(BuildContext context) {
    return TDTabBar(
      tabs: subList(5),
      controller: _tabController4,
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSpace(BuildContext context) {
    return TDTabBar(
      tabs: subList(16),
      controller: TabController(length: 16, vsync: this),
      backgroundColor: Colors.white,
      labelPadding: const EdgeInsets.all(10),
      showIndicator: true,
      isScrollable: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithIcon(BuildContext context) {
    var tabs = [
      const TDTab(
        text: '选项',
        icon: Icon(
          TDIcons.app,
          size: 18,
        ),
      ),
      const TDTab(
        text: '选项',
        icon: Icon(
          TDIcons.app,
          size: 18,
        ),
      ),
      const TDTab(
        text: '选项',
        icon: Icon(
          TDIcons.app,
          size: 18,
        ),
      ),
    ];
    return TDTabBar(
        tabs: tabs,
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
          size: 18,
        ),
      ),
    ];
    return TDTabBar(
        tabs: tabs,
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
              isScrollable: false,),
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
        outlineType: TDTabBarOutlineType.capsule,
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
        outlineType: TDTabBarOutlineType.card,
        controller: TabController(length: 4, vsync: this),
        backgroundColor: Colors.white,
        showIndicator: false);
  }

  @Demo(group: 'tabs')
  Widget _customIndicatorStyle(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      controller: _tabController1,
      backgroundColor: Colors.white,
      showIndicator: true,
      indicatorColor: Colors.red,
      indicatorHeight: 20,
      indicatorWidth: 10,
      indicatorPadding: const EdgeInsets.only(left: 20),
    );
  }

  @Demo(group: 'tabs')
  Widget _customDividerStyle(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      controller: _tabController1,
      backgroundColor: Colors.white,
      showIndicator: true,
      dividerColor: Colors.red,
      dividerHeight: 5,
    );
  }

  @Demo(group: 'tabs')
  Widget _hideBottomDivider(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      controller: _tabController1,
      backgroundColor: Colors.white,
      showIndicator: true,
      dividerColor: Colors.red,
      dividerHeight: 0,
    );
  }

  @Demo(group: 'tabs')
  Widget _capsuleBackgroundColor(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      controller: _tabController1,
      backgroundColor: Colors.red,
      outlineType: TDTabBarOutlineType.capsule,
    );
  }
}
