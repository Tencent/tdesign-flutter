import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDTabsPage extends StatefulWidget {
  const TDTabsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDTabsPageState();
}

class _TDTabsPageState extends State<TDTabsPage> with TickerProviderStateMixin {
  TabController? _tabController1;
  TabController? _tabController2;
  TabController? _tabController3;
  TabController? _tabController4;
  List<TDTab> tabs = [];
  List<Widget> tabViews = [];

  List<TDTab> _getTabs() {
    tabs = const [
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
      TDTab(text: '选项'),
      TDTab(text: '选项'),
    ];
    return tabs;
  }

  List<Widget> _getTabViews() {
    tabViews = const [
      Center(child: TDText('内容区 1')),
      Center(child: TDText('内容区 2')),
      Center(child: TDText('内容区 3')),
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

  // 初始化tab
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
      padding: const EdgeInsets.only(top: 16),
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
      ],
      test: [
        ExampleItem(desc: '自定义下标属性', builder: _customIndicatorStyle),
        ExampleItem(desc: '自定义下划线样式', builder: _customDividerStyle),
        ExampleItem(desc: '不展示下划线-高度为0', builder: _hideBottomDivider),
        ExampleItem(desc: 'capsule类型可修改背景色', builder: _capsuleBackgroundColor),
      ],
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit1(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      controller: _tabController1,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit2(BuildContext context) {
    return TDTabBar(
      tabs: subList(3),
      controller: _tabController2,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit3(BuildContext context) {
    return TDTabBar(
      tabs: subList(4),
      controller: _tabController3,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSplit4(BuildContext context) {
    return TDTabBar(
      tabs: subList(5),
      controller: _tabController4,
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSpace(BuildContext context) {
    return TDTabBar(
      tabs: subList(16),
      controller: TabController(length: 16, vsync: this),
      labelPadding: const EdgeInsets.all(10),
      showIndicator: true,
      isScrollable: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithIcon(BuildContext context) {
    var tabs = List.generate(3, (index) {
      final text = '选项${index + 1}';
      return TDTab(
        text: text,
        icon: const Icon(TDIcons.app, size: 18),
      );
    });
    return TDTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
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
        badge: TDBadge(TDBadgeType.message, message: '8'),
      ),
      const TDTab(
        text: '选项',
        height: 48,
        icon: Icon(TDIcons.app, size: 18),
      ),
    ];
    return TDTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
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
            isScrollable: false,
          ),
          Container(
            height: 120,
            color: TDTheme.of(context).bgColorContainer,
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
      const TDTab(text: '选中'),
      const TDTab(text: '默认'),
      const TDTab(text: '禁用', enable: false),
    ];
    return TDTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSizeSmall(BuildContext context) {
    var tabs = [
      const TDTab(text: '小尺寸'),
      const TDTab(text: '选项2'),
      const TDTab(text: '选项3'),
      const TDTab(text: '选项4'),
    ];
    return TDTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithSizeBig(BuildContext context) {
    var tabs = [
      const TDTab(text: '大尺寸', size: TDTabSize.large),
      const TDTab(text: '选项2', size: TDTabSize.large),
      const TDTab(text: '选项3', size: TDTabSize.large),
      const TDTab(text: '选项4', size: TDTabSize.large),
    ];
    return TDTabBar(
      tabs: tabs,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: true,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithOutlineNormal(BuildContext context) {
    var tabs = [
      const TDTab(text: '选项1'),
      const TDTab(text: '选项2'),
      const TDTab(text: '选项3'),
      const TDTab(text: '选项4'),
    ];
    return TDTabBar(
      tabs: tabs,
      outlineType: TDTabBarOutlineType.capsule,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: false,
    );
  }

  @Demo(group: 'tabs')
  Widget _buildItemWithOutlineCard(BuildContext context) {
    var tabs = [
      const TDTab(text: '选项1'),
      const TDTab(text: '选项2'),
      const TDTab(text: '选项3'),
      const TDTab(text: '选项4'),
    ];
    return TDTabBar(
      tabs: tabs,
      outlineType: TDTabBarOutlineType.card,
      controller: TabController(length: tabs.length, vsync: this),
      showIndicator: false,
    );
  }

  @Demo(group: 'tabs')
  Widget _customIndicatorStyle(BuildContext context) {
    return TDTabBar(
      tabs: subList(2),
      controller: _tabController1,
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
