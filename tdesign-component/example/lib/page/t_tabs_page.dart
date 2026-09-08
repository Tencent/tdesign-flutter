import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TTabsPage extends StatelessWidget {
  const TTabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
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
            ExampleItem(desc: '带徽标选项卡', builder: _buildItemWithLogo),
            ExampleItem(desc: '带内容区选项卡', builder: _buildItemWithContent),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(desc: '选项卡状态', builder: _buildItemWithStatus)],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '选项卡样式', builder: _buildItemWithLine),
            ExampleItem(builder: _buildItemWithTag),
            ExampleItem(builder: _buildItemWithCard),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit1(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: TTabsBar(
        tabs: [
          TTab(text: '选项'),
          TTab(text: '选项'),
        ],
      ),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit2(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: TTabsBar(
        tabs: [
          TTab(text: '选项'),
          TTab(text: '选项'),
          TTab(text: '上限六个字'),
        ],
      ),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit3(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: TTabsBar(
        tabs: [
          TTab(text: '选项'),
          TTab(text: '选项'),
          TTab(text: '选项'),
          TTab(text: '上限四字'),
        ],
      ),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSplit4(BuildContext context) {
    return const DefaultTabController(
      length: 5,
      child: TTabsBar(
        tabs: [
          TTab(text: '选项'),
          TTab(text: '选项'),
          TTab(text: '选项'),
          TTab(text: '选项'),
          TTab(text: '上限三'),
        ],
      ),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithSpace(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: TTabsBar(
        isScrollable: true,
        tabs: List.generate(6, (_) => const TTab(text: '选项')),
      ),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithIcon(BuildContext context) {
    final tabs = List.generate(3, (index) {
      final text = '选项${index + 1}';
      return TTab(text: text, icon: const Icon(TIcons.app, size: 18));
    });
    return DefaultTabController(
      length: tabs.length,
      child: TTabsBar(tabs: tabs),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithLogo(BuildContext context) {
    const tabs = [
      TTab(
        child: TBadge(
          variant: TBadgeVariant.dot,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(TIcons.app, size: 18),
              SizedBox(width: 4),
              Text('选项1'),
            ],
          ),
        ),
      ),
      TTab(
        child: TBadge(
          label: '8',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(TIcons.app, size: 18),
              SizedBox(width: 4),
              Text('选项2'),
            ],
          ),
        ),
      ),
      TTab(text: '选项3', icon: Icon(TIcons.app, size: 18)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: const TTabsBar(tabs: tabs),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithContent(BuildContext context) {
    return const SizedBox(
      height: 168,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TTabsBar(
              tabs: [
                TTab(text: '选项'),
                TTab(text: '选项'),
                TTab(text: '上限六个字'),
              ],
            ),
            Expanded(
              child: TTabsBarView(
                children: [
                  Center(child: TText('内容区 1')),
                  Center(child: TText('内容区 2')),
                  Center(child: TText('内容区 3')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithStatus(BuildContext context) {
    const tabs = [
      TTab(text: '选中'),
      TTab(text: '默认'),
      TTab(text: '禁用', enabled: false),
    ];
    return const DefaultTabController(length: 3, child: TTabsBar(tabs: tabs));
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithLine(BuildContext context) {
    const tabs = [
      TTab(text: '选项1'),
      TTab(text: '选项2'),
      TTab(text: '选项3'),
      TTab(text: '选项4'),
    ];
    return const DefaultTabController(length: 4, child: TTabsBar(tabs: tabs));
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithTag(BuildContext context) {
    const tabs = [
      TTab(text: '选项1'),
      TTab(text: '选项2'),
      TTab(text: '选项3'),
      TTab(text: '选项4'),
    ];
    return const DefaultTabController(
      length: 4,
      child: TTabsBar(tabs: tabs, variant: TTabsBarVariant.tag),
    );
  }

  @ExampleCode(group: 'tabs')
  Widget _buildItemWithCard(BuildContext context) {
    const tabs = [
      TTab(text: '选项1'),
      TTab(text: '选项2'),
      TTab(text: '选项3'),
      TTab(text: '选项4'),
    ];
    return const DefaultTabController(
      length: 4,
      child: TTabsBar(tabs: tabs, variant: TTabsBarVariant.card),
    );
  }
}
