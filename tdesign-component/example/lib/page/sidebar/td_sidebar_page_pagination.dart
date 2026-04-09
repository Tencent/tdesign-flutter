import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TSideBarPaginationPage演示
///
class TSideBarPaginationPage extends StatefulWidget {
  const TSideBarPaginationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarPaginationPageState();
  }
}

class TSideBarPaginationPageState extends State<TSideBarPaginationPage> {
  var currentValue = 1;
  final _pageController = PageController(initialPage: 1);
  final _sideBarController = TSideBarController();

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
        title: 'SideBar 切页用法',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildPaginationSideBar,
        ));
  }

  @Demo(group: 'sideBar')
  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项 ${i}',
        value: i,
      ));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const TBadge(TBadgeType.redPoint);
    list[2].badge = const TBadge(
      TBadgeType.message,
      count: '8',
    );

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        currentValue = value;
      }
    }

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TSideBar(
            style: TSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onSelected: setCurrentValue,
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: pages,
            physics: const NeverScrollableScrollPhysics(),
          ),
        )
      ],
    );
  }

  Widget getPageDemo(int index) {
    return Container(
      decoration: BoxDecoration(color: TTheme.of(context).bgColorContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: TText('标题 $index', style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          displayImageList()
        ],
      ),
    );
  }

  Widget displayImageList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(
          12,
          (index) => displayImageItem('${index}最多六个字'),
        ),
      ),
    );
  }

  Widget displayImageItem(String title) {
    return Column(
      // spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TImage(
          assetUrl: 'assets/img/empty.png',
          type: TImageType.roundedSquare,
          width: 48,
          height: 48,
        ),
        const SizedBox(height: 8),
        TText('$title', style: const TextStyle(fontSize: 12))
      ],
    );
  }
}
