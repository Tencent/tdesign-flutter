import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TTabsPage extends StatefulWidget {
  const TTabsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TTabsPageState();
}

class _TTabsPageState extends State<TTabsPage> with TickerProviderStateMixin {
  TabController? _tabController1;
  TabController? _tabController2;
  TabController? _tabController3;
  TabController? _tabController4;
  final Map<String, TabController> _demoControllers = {};
  List<TTab> tabs = [];
  List<Widget> tabViews = [];

  List<TTab> _getTabs() {
    tabs = const [
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
      TTab(text: '选项'),
    ];
    return tabs;
  }

  List<Widget> _getTabViews() {
    tabViews = const [
      Center(child: TText('内容区 1')),
      Center(child: TText('内容区 2')),
      Center(child: TText('内容区 3')),
    ];
    return tabViews;
  }

  @override
  void initState() {
    super.initState();
    _initTabController();
    _getTabs();
  }

  @override
  void dispose() {
    _tabController1?.dispose();
    _tabController2?.dispose();
    _tabController3?.dispose();
    _tabController4?.dispose();
    for (final controller in _demoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TabController _demoController(String key, int length) {
    return _demoControllers.putIfAbsent(
      key,
      () => TabController(length: length, vsync: this),
    );
  }

  TTabsBarIndicator _indicator(BuildContext context) =>
      TTabsBarIndicator(indicatorColor: context.tTheme.brandNormalColor);

  List<TTab> subList(int length) {
    var temp = <TTab>[];
    for (var i = 0; i < length; i++) {
      temp.add(tabs[i]);
    }
    switch (length) {
      case 3:
        temp[temp.length - 1] = const TTab(text: '上限六个字');
        break;
      case 4:
        temp[temp.length - 1] = const TTab(text: '上限四字');
        break;
      case 5:
        temp[temp.length - 1] = const TTab(text: '上限三');
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
      title: tTitle(),
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
          ExampleItem(desc: '选项卡样式', builder: _buildItemWithOutlineNormal),
          ExampleItem(builder: _buildItemWithOutlineCard),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit1(BuildContext context) {
    return TTabsBar(
      tabs: subList(2),
      controller: _tabController1,
      indicator: _indicator(context),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit2(BuildContext context) {
    return TTabsBar(
      tabs: subList(3),
      controller: _tabController2,
      indicator: _indicator(context),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit3(BuildContext context) {
    return TTabsBar(
      tabs: subList(4),
      controller: _tabController3,
      indicator: _indicator(context),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit4(BuildContext context) {
    return TTabsBar(
      tabs: subList(5),
      controller: _tabController4,
      indicator: _indicator(context),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSpace(BuildContext context) {
    return TTabsBar(
      tabs: subList(16),
      controller: _demoController('space', 16),
      indicator: _indicator(context),
      isScrollable: true,
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithIcon(BuildContext context) {
    var tabs = List.generate(3, (index) {
      final text = '选项${index + 1}';
      return TTab(
        text: text,
        icon: const Icon(TIcons.app, size: 18),
      );
    });
    return TTabsBar(
      tabs: tabs,
      controller: _demoController('icon', tabs.length),
      indicator: _indicator(context),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithLogo(BuildContext context) {
    var tabs = [
      const TTab(
        text: '选项1',
        icon: Icon(TIcons.app, size: 18),
        badge: TBadge(variant: TBadgeVariant.dot),
      ),
      const TTab(
        text: '选项2',
        icon: Icon(TIcons.app, size: 18),
        badge: TBadge(count: 8),
      ),
      const TTab(
        text: '选项3',
        icon: Icon(TIcons.app, size: 18),
        badge: TBadge(variant: TBadgeVariant.dot),
      ),
    ];
    return TTabsBar(
      tabs: tabs,
      controller: _demoController('logo', tabs.length),
      indicator: _indicator(context),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithContent(BuildContext context) {
    final tabController = _demoController('content', 3);
    return SizedBox(
      height: 120 + 48,
      child: Column(
        children: [
          TTabsBar(
            tabs: subList(3),
            controller: tabController,
            isScrollable: false,
            indicator: _indicator(context),
          ),
          Expanded(
            child: Container(
              color: context.tTheme.bgColorContainer,
              child: TTabsBarView(
                children: _getTabViews(),
                controller: tabController,
              ),
            ),
          )
        ],
      ),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithStatus(BuildContext context) {
    var tabs = [
      const TTab(text: '选中'),
      const TTab(text: '默认'),
      const TTab(text: '禁用', enabled: false),
    ];
    return TTabsBar(
      tabs: tabs,
      controller: _demoController('status', tabs.length),
      indicator: _indicator(context),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithOutlineNormal(BuildContext context) {
    var tabs = [
      const TTab(text: '选项1'),
      const TTab(text: '选项2'),
      const TTab(text: '选项3'),
      const TTab(text: '选项4'),
    ];
    return TTabsBar(
      tabs: tabs,
      variant: TTabsBarVariant.capsule,
      controller: _demoController('outlineNormal', tabs.length),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithOutlineCard(BuildContext context) {
    var tabs = [
      const TTab(text: '选项1'),
      const TTab(text: '选项2'),
      const TTab(text: '选项3'),
      const TTab(text: '选项4'),
    ];
    return TTabsBar(
      tabs: tabs,
      variant: TTabsBarVariant.card,
      controller: _demoController('outlineCard', tabs.length),
    );
  }
}
