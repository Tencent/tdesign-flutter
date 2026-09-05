import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

/// SideBar 切页示例。
class TSideBarPaginationPage extends StatefulWidget {
  const TSideBarPaginationPage({super.key});

  @override
  State<TSideBarPaginationPage> createState() => TSideBarPaginationPageState();
}

class TSideBarPaginationPageState extends State<TSideBarPaginationPage> {
  var currentValue = 1;
  final _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'SideBar 切页用法',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      showTestModule: false,
      singleChild: CodeWrapper(
        isCenter: false,
        builder: _buildPaginationSideBar,
      ),
    );
  }

  @ExampleCode(group: 'sideBar')
  Widget _buildPaginationSideBar(BuildContext context) {
    final labels = List.filled(10, '选项');
    final titles = List.filled(10, '标题');
    final itemCounts = List.filled(10, 8);
    final items = List.generate(
      labels.length,
      (index) => TSideBarItem(
        label: labels[index],
        value: index,
        disabled: index == 4,
        badge: switch (index) {
          1 => const TBadge(variant: TBadgeVariant.dot),
          2 => const TBadge(label: '8'),
          _ => null,
        },
      ),
    );

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        setState(() => currentValue = value);
      }
    }

    return Row(
      children: [
        TSideBar(
          value: currentValue,
          children: items,
          onChanged: setCurrentValue,
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: titles.length,
            itemBuilder: (_, pageIndex) => Container(
              color: context.tTheme.bgColorContainer,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: itemCounts[pageIndex],
                itemBuilder: (_, index) => Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: context.tTheme.grayColor2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const TImage(
                        src: 'assets/img/empty.png',
                        variant: TImageVariant.circle,
                        width: 48,
                        height: 48,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TText(
                          titles[pageIndex],
                          font: context.tTheme.fontBodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
