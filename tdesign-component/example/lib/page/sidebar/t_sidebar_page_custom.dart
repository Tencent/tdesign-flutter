import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TSideBarCustomPage演示
///
class TSideBarCustomPage extends StatefulWidget {
  const TSideBarCustomPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarCustomPageState();
  }
}

class TSideBarCustomPageState extends State<TSideBarCustomPage> {
  static const _sections = ['今日精选', '新鲜烘焙', '午后茶点', '轻食简餐', '限定活动', '会员心选'];

  var currentValue = 0;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
    final list = <TSideBarItem>[];
    final pages = <Widget>[];

    for (var i = 0; i < _sections.length; i++) {
      list.add(TSideBarItem(
        label: _sections[i],
        value: i,
        textStyle: TextStyle(color: context.tTheme.textColorSecondary),
      ));
      pages.add(getPageDemo(context, i));
    }

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        setState(() {
          currentValue = value;
        });
      }
    }

    return Row(
      children: [
        SizedBox(
          width: 116,
          child: TSideBar(
            style: TSideBarVariant.normal,
            value: currentValue,
            children: list
                .map((ele) => TSideBarItem(
                    label: ele.label,
                    badge: ele.badge,
                    value: ele.value,
                    textStyle: ele.textStyle,
                    icon: ele.icon))
                .toList(),
            selectedTextStyle: TextStyle(
              color: context.tTheme.brandNormalColor,
              fontWeight: FontWeight.w600,
            ),
            onChanged: setCurrentValue,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            selectedBgColor: context.tTheme.brandLightColor,
            unSelectedBgColor: context.tTheme.bgColorContainer,
            unSelectedColor: context.tTheme.textColorSecondary,
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

  Widget getPageDemo(BuildContext context, int index) {
    return Container(
      color: context.tTheme.bgColorContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: TText(
              _sections[index],
              font: context.tTheme.fontTitleMedium,
            ),
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
          child: TText('标题$index', style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(height: 16),
        displayImageList()
      ],
    );
  }

  Widget displayImageList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 18.0;
        const spacing = 12.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final columnCount = max(1, ((contentWidth + spacing) / 84).floor());
        final itemWidth =
            (contentWidth - spacing * (columnCount - 1)) / columnCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Wrap(
            spacing: spacing,
            runSpacing: 16,
            children: List.generate(
              6,
              (index) => displayImageItem('${index}最多六个字', itemWidth),
            ),
          ),
        );
      },
    );
  }

  Widget displayImageItem(String title, double width) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          TImage(
            src: 'assets/img/empty.png',
            variant: TImageVariant.roundedSquare,
            width: min(72.0, width),
            height: min(72.0, width),
          ),
          const SizedBox(height: 4),
          TText(
            title,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
