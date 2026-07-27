import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
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
  static const _pageTitles = [
    '精选推荐',
    '夏日饮品',
    '人气甜品',
    '轻食小食',
    '限时优惠',
    '新品尝鲜',
  ];
  static const _pageItems = [
    ['招牌套餐', '今日热销', '到店必点', '甄选礼盒', '下午茶', '早餐优选'],
    ['冰美式', '生椰拿铁', '青提气泡', '芒果冰沙', '乌龙奶茶', '冷萃咖啡'],
    ['巴斯克', '提拉米苏', '巧克力卷', '草莓慕斯', '焦糖布丁', '奶油泡芙'],
    ['鸡肉沙拉', '牛油果卷', '芝士薯条', '烤鸡翅', '金枪鱼饭', '蔬菜汤'],
    ['第二件半价', '会员专享', '满减优惠', '限量券包', '午市特惠', '积分兑换'],
    ['海盐可颂', '抹茶拿铁', '芝士贝果', '蓝莓酸奶', '桂花酿', '柚子茶'],
  ];

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
        title: 'SideBar 切页用法',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildPaginationSideBar,
        ));
  }

  @ExampleCode(group: 'sideBar')
  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <TSideBarItem>[];
    final pages = <Widget>[];

    for (var i = 0; i < _pageTitles.length; i++) {
      list.add(TSideBarItem(
        label: _pageTitles[i],
        value: i,
      ));
      pages.add(getPageDemo(context, i));
    }

    list[1] = TSideBarItem(
      label: list[1].label,
      value: list[1].value,
      icon: list[1].icon,
      textStyle: list[1].textStyle,
      badge: const TBadge(variant: TBadgeVariant.dot),
    );
    list[2] = TSideBarItem(
      label: list[2].label,
      value: list[2].value,
      icon: list[2].icon,
      textStyle: list[2].textStyle,
      badge: const TBadge(count: 8),
    );

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
          width: 106,
          child: TSideBar(
            style: TSideBarVariant.normal,
            value: currentValue,
            children: list
                .map((ele) => TSideBarItem(
                    label: ele.label,
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: setCurrentValue,
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
      decoration: BoxDecoration(color: context.tTheme.bgColorContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: TText(
              _pageTitles[index],
              font: context.tTheme.fontTitleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TText(
              '当前展示 ${_pageItems[index].length} 个${_pageTitles[index]}商品',
              textColor: context.tTheme.textColorSecondary,
            ),
          ),
          const SizedBox(height: 16),
          displayImageList(_pageItems[index]),
        ],
      ),
    );
  }

  Widget displayImageList(List<String> items) {
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
            children:
                items.map((item) => displayImageItem(item, itemWidth)).toList(),
          ),
        );
      },
    );
  }

  Widget displayImageItem(String title, double width) {
    final imageSize = min(72.0, width);
    return SizedBox(
      width: width,
      child: Column(
        children: [
          TImage(
            src: 'assets/img/empty.png',
            variant: TImageVariant.roundedSquare,
            width: imageSize,
            height: imageSize,
          ),
          const SizedBox(height: 8),
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
