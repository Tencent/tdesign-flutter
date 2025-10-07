import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TDSideBarCustomPage演示
///
class TDSideBarCustomPage extends StatefulWidget {
  const TDSideBarCustomPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDSideBarCustomPageState();
  }
}

class TDSideBarCustomPageState extends State<TDSideBarCustomPage> {
  var currentValue = 1;
  final _pageController = PageController(initialPage: 1);
  final _sideBarController = TDSideBarController();

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
        title: 'SideBar 自定义样式',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildCustomSideBar,
        ));
  }

  @Demo(group: 'sideBar')
  Widget _buildCustomSideBar(BuildContext context) {
    // 自定义样式
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项 $i',
        value: i,
        textStyle: TextStyle(color: TDTheme.of(context).brandLightColor),
      ));
      pages.add(getPageDemo(i));
    }

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );
    list[1].textStyle = const TextStyle(color: Colors.green);

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
          child: TDSideBar(
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    textStyle: ele.textStyle,
                    icon: ele.icon))
                .toList(),
            selectedTextStyle: const TextStyle(color: Colors.red),
            onSelected: setCurrentValue,
            contentPadding:
                const EdgeInsets.only(left: 16, top: 16, bottom: 16),
            selectedBgColor: Colors.blue,
            unSelectedBgColor: Colors.yellow,
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
      decoration: const BoxDecoration(color: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: TDText('标题 $index', style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          displayImageList()
        ],
      ),
    );
  }

  Widget getAnchorDemo(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 16,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
          child: TDText('标题$index', style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(height: 16),
        displayImageList()
      ],
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
    return Expanded(
      child: Column(
        // spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TDImage(
            assetUrl: 'assets/img/empty.png',
            type: TDImageType.roundedSquare,
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 4),
          TDText('$title', style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
