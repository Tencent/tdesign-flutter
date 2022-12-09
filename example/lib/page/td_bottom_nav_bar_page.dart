import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';

class TDBottomNavBarPage extends StatelessWidget {
  const TDBottomNavBarPage({Key? key}) : super(key: key);

  void onTapTab(BuildContext context, String tabName) {
    TDToast.showText('点击了 $tabName', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: '标签栏 TDBottomNavBar',
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
      ExampleModule(title: '默认',
      children: [
        ExampleItem(
          desc: '单层级纯文本标签栏',
          builder: (BuildContext context) {
            return TDBottomNavBar(
              TDBottomNavBarType.text,
              useVerticalDivider: true,
              navigationTabs: [
                TDBottomNavBarTabConfig(
                    selectedText: Text(
                      '标签栏一',
                      style: TextStyle(
                          color: TDTheme.of(context).brandColor8, fontSize: 16),
                    ),
                    unselectedText: const Text(
                      '标签栏一',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    onTap: () {
                      onTapTab(context, '标签栏一');
                    }),
                TDBottomNavBarTabConfig(
                  selectedText: Text(
                    '标签栏二',
                    style: TextStyle(
                        color: TDTheme.of(context).brandColor8, fontSize: 16),
                  ),
                  unselectedText: const Text(
                    '标签栏二',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  onTap: () {
                    onTapTab(context, '标签栏二');
                  },
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '单层级纯文本标签栏',
          builder: (BuildContext context) {
            return TDBottomNavBar(
              TDBottomNavBarType.text,
              useVerticalDivider: true,
              navigationTabs: [
                TDBottomNavBarTabConfig(
                    selectedText: Text(
                      '标签栏一',
                      style: TextStyle(
                          color: TDTheme.of(context).brandColor8, fontSize: 16),
                    ),
                    unselectedText: const Text(
                      '标签栏一',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    onTap: () {
                      onTapTab(context, '标签栏一');
                    }),
                TDBottomNavBarTabConfig(
                  selectedText: Text(
                    '标签栏二',
                    style: TextStyle(
                        color: TDTheme.of(context).brandColor8, fontSize: 16),
                  ),
                  unselectedText: const Text(
                    '标签栏二',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  onTap: () {
                    onTapTab(context, '标签栏二');
                  },
                ),
                TDBottomNavBarTabConfig(
                  selectedText: Text(
                    '标签栏三',
                    style: TextStyle(
                        color: TDTheme.of(context).brandColor8, fontSize: 16),
                  ),
                  unselectedText: const Text(
                    '标签栏三',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  onTap: () {
                    onTapTab(context, '标签栏三');
                  },
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '文本加图标标签栏',
          builder: (BuildContext context) {
            return TDBottomNavBar(
              TDBottomNavBarType.iconText,
              useVerticalDivider: true,
              navigationTabs: [
                TDBottomNavBarTabConfig(
                  selectedText: Text(
                    '标签栏一',
                    style: TextStyle(
                        color: TDTheme.of(context).brandColor8, fontSize: 16),
                  ),
                  unselectedText: const Text(
                    '标签栏一',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    color: TDTheme.of(context).brandColor8,
                    size: 20,
                  ),
                  unselectedIcon: const Icon(
                    Icons.home,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onTap: () {
                    onTapTab(context, '标签栏一');
                  },
                ),
                TDBottomNavBarTabConfig(
                    selectedText: Text(
                      '标签栏二',
                      style: TextStyle(
                          color: TDTheme.of(context).brandColor8, fontSize: 16),
                    ),
                    unselectedText: const Text(
                      '标签栏二',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 20,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () {
                      onTapTab(context, '标签栏二');
                    }),
                TDBottomNavBarTabConfig(
                    selectedText: Text(
                      '标签栏三',
                      style: TextStyle(
                          color: TDTheme.of(context).brandColor8, fontSize: 16),
                    ),
                    unselectedText: const Text(
                      '标签栏三',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 20,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () {
                      onTapTab(context, '标签栏三');
                    }),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '文本加图标标签栏',
          builder: (BuildContext context) {
            return TDBottomNavBar(
              TDBottomNavBarType.iconText,
              useVerticalDivider: true,
              navigationTabs: [
                TDBottomNavBarTabConfig(
                  selectedText: Text(
                    '标签栏一',
                    style: TextStyle(
                        color: TDTheme.of(context).brandColor8, fontSize: 16),
                  ),
                  unselectedText: const Text(
                    '标签栏一',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    color: TDTheme.of(context).brandColor8,
                    size: 20,
                  ),
                  unselectedIcon: const Icon(
                    Icons.home,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onTap: () {
                    onTapTab(context, '标签栏一');
                  },
                ),
                TDBottomNavBarTabConfig(
                    selectedText: Text(
                      '标签栏二',
                      style: TextStyle(
                          color: TDTheme.of(context).brandColor8, fontSize: 16),
                    ),
                    unselectedText: const Text(
                      '标签栏二',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 20,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () {
                      onTapTab(context, '标签栏二');
                    }),
                TDBottomNavBarTabConfig(
                    selectedText: Text(
                      '标签栏三',
                      style: TextStyle(
                          color: TDTheme.of(context).brandColor8, fontSize: 16),
                    ),
                    unselectedText: const Text(
                      '标签栏三',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 20,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () {
                      onTapTab(context, '标签栏三');
                    }),
                TDBottomNavBarTabConfig(
                    selectedText: Text(
                      '标签栏四',
                      style: TextStyle(
                          color: TDTheme.of(context).brandColor8, fontSize: 16),
                    ),
                    unselectedText: const Text(
                      '标签栏四',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 20,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () {
                      onTapTab(context, '标签栏四');
                    }),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '纯图标标签栏',
          builder: (BuildContext context) {
            return TDBottomNavBar(
              TDBottomNavBarType.icon,
              useVerticalDivider: true,
              navigationTabs: [
                TDBottomNavBarTabConfig(
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 30,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onTap: () {
                      onTapTab(context, '第一个图标');
                    }),
                TDBottomNavBarTabConfig(
                  selectedIcon: Icon(
                    Icons.home,
                    color: TDTheme.of(context).brandColor8,
                    size: 30,
                  ),
                  unselectedIcon: const Icon(
                    Icons.home,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onTap: () {
                    onTapTab(context, '第二个图标');
                  },
                ),
                TDBottomNavBarTabConfig(
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 30,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onTap: () {
                      onTapTab(context, '第三个图标');
                    }),
                TDBottomNavBarTabConfig(
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 30,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onTap: () {
                      onTapTab(context, '第四个图标');
                    }),
                TDBottomNavBarTabConfig(
                    selectedIcon: Icon(
                      Icons.home,
                      color: TDTheme.of(context).brandColor8,
                      size: 30,
                    ),
                    unselectedIcon: const Icon(
                      Icons.home,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onTap: () {
                      onTapTab(context, '第五个图标');
                    }),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '底部导航栏自定义布局',
          builder: (BuildContext context) {
            return TDBottomNavBar(
              TDBottomNavBarType.customLayout,
              useVerticalDivider: true,
              navigationTabs: [
                TDBottomNavBarTabConfig(
                  showBadge: true,
                  tdBadge: const TDBadge(
                    TDBadgeType.remind,
                  ),
                  badgeTopOffset: -2,
                  badgeRightOffset: -20,
                  selectWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        color: TDTheme.of(context).brandColor8,
                        size: 20,
                      ),
                      Text(
                        '首页',
                        style: TextStyle(
                            color: TDTheme.of(context).brandColor8,
                            fontSize: 16),
                      )
                    ],
                  ),
                  unSelectWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.home,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        '首页',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () {
                    onTapTab(context, '首页');
                  },
                ),
                TDBottomNavBarTabConfig(
                  showBadge: true,
                  tdBadge: const TDBadge(
                    TDBadgeType.message,
                    message: 'New',
                  ),
                  badgeTopOffset: -2,
                  badgeRightOffset: -20,
                  selectWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.category,
                        color: TDTheme.of(context).brandColor8,
                        size: 20,
                      ),
                      Text(
                        '分类',
                        style: TextStyle(
                            color: TDTheme.of(context).brandColor8,
                            fontSize: 16),
                      )
                    ],
                  ),
                  unSelectWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.category,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        '分类',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () {
                    onTapTab(context, '分类');
                  },
                ),
                TDBottomNavBarTabConfig(
                  showBadge: true,
                  tdBadge: const TDBadge(TDBadgeType.message, count: '16'),
                  badgeTopOffset: -2,
                  badgeRightOffset: -10,
                  selectWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: TDTheme.of(context).brandColor8,
                        size: 20,
                      ),
                      Text(
                        '购物车',
                        style: TextStyle(
                            color: TDTheme.of(context).brandColor8,
                            fontSize: 16),
                      )
                    ],
                  ),
                  unSelectWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        '购物车',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () {
                    onTapTab(context, '购物车');
                  },
                ),
                TDBottomNavBarTabConfig(
                    showBadge: true,
                    tdBadge: const TDBadge(TDBadgeType.redPoint),
                    badgeTopOffset: -2,
                    badgeRightOffset: -10,
                    selectWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.settings,
                          color: TDTheme.of(context).brandColor8,
                          size: 20,
                        ),
                        Text(
                          '展开',
                          style: TextStyle(
                              color: TDTheme.of(context).brandColor8,
                              fontSize: 16),
                        )
                      ],
                    ),
                    unSelectWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.settings,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          '展开',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        )
                      ],
                    ),
                    onTap: () {
                      onTapTab(context, '展开');
                    },
                    popUpButtonConfig: TDBottomNavBarPopUpBtnConfig(
                        popUpDialogConfig: TDBottomNavBarPopUpShapeConfig(
                          radius: 10,
                          arrowWidth: 16,
                          arrowHeight: 8,
                        ),
                        items: [
                          '展开项一',
                          '展开项二',
                          '展开项三',
                          '展开项四',
                          '展开项五',
                          '展开项六',
                          '展开项七',
                          '展开项八',
                        ]
                            .map((e) => PopUpMenuItem(
                                  value: e,
                                  itemWidget: SizedBox(
                                    //height: 30,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          color: TDTheme.of(context).grayColor7,
                                          fontSize: 16),
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          TDToast.showText('点击了 $v', context: context);
                        })),
              ],
            );
          },
        ),
      ],
    )]);
  }
}
