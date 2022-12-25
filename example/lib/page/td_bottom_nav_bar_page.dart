import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../annotation/demo.dart';
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
        backgroundColor: const Color(0xFFF0F2F5),
        exampleCodeGroup: 'bottomNavBar',
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(desc: '纯文本标签栏', builder: _textTypeNavBar),
              ExampleItem(
                builder: _textTypeNavBar3tabs,
              ),
              ExampleItem(
                builder: _textTypeNavBar4tabs,
              ),
              ExampleItem(
                builder: _textTypeNavBar5tabs,
              ),
              ExampleItem(desc: '图标加文本标签栏', builder: _iconTextTypeNavBar),
              ExampleItem(
                builder: _iconTextTypeNavBar3tabs,
              ),
              ExampleItem(
                builder: _iconTextTypeNavBar4tabs,
              ),
              ExampleItem(
                builder: _iconTextTypeNavBar5tabs,
              ),
              ExampleItem(
                desc: '纯图标标签栏',
                builder: _iconTypeNavBar,
              ),
              ExampleItem(
                builder: _iconTypeNavBar3tabs,
              ),
              ExampleItem(
                builder: _iconTypeNavBar4tabs,
              ),
              ExampleItem(
                builder: _iconTypeNavBar5tabs,
              ),
              ExampleItem(
                desc: '双层级文本标签栏',
                builder: _expansionPannelTypeNavBar,
              ),
            ],
          ),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(
              desc: '弱选中标签栏',
              builder: _weakSelectTextNavBar,
            ),
            ExampleItem(
              builder: _weakSelectIconNavBar,
            ),
            ExampleItem(
              builder: _weakSelectIconTextNavBar,
            ),
            ExampleItem(
              desc: '悬浮胶囊标签栏',
              builder: _capsuleNavBar,
            ),
          ]),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _textTypeNavBar(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _textTypeNavBar3tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _textTypeNavBar4tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _textTypeNavBar5tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            tabText: '标签',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTextTypeNavBar(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
                IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
                IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTextTypeNavBar3tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTextTypeNavBar4tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTextTypeNavBar5tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.iconText,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TDBottomNavBarTabConfig(
            iconTextTypeConfig:
            IconTextTypeConfig(tabText: '标签', useDefaultIcon: true),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTypeNavBar(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              })
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTypeNavBar3tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTypeNavBar4tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _iconTypeNavBar5tabs(BuildContext context) {
    return TDBottomNavBar(TDBottomNavBarBasicType.icon,
        useVerticalDivider: true,
        navigationTabs: [
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签1');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
          TDBottomNavBarTabConfig(
              iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
              onTap: () {
                onTapTab(context, '标签2');
              }),
        ]);
  }

  @Demo(group: 'bottomNavBar')
  Widget _expansionPannelTypeNavBar(BuildContext context) {
    return TDBottomNavBar(
      TDBottomNavBarBasicType.expansionPanel,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomNavBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomNavBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomNavBarTabConfig(
            tabText: '展开项',
            onTap: () {
              onTapTab(context, '展开项');
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
                ]
                    .reversed
                    .map((e) => PopUpMenuItem(
                          value: e,
                          itemWidget: SizedBox(
                            //height: 30,
                            child: Text(
                              e,
                              style: TextStyle(
                                  color: TDTheme.of(context).fontGyColor1,
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
  }

  @Demo(group: 'bottomNavBar')
  Widget _weakSelectTextNavBar(BuildContext context) {
    return TDBottomNavBar(
      TDBottomNavBarBasicType.text,
      componentType: TDBottomNavBarComponentType.normal,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomNavBarTabConfig(
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomNavBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomNavBarTabConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  @Demo(group: 'bottomNavBar')
  Widget _weakSelectIconNavBar(BuildContext context) {
    return TDBottomNavBar(
      TDBottomNavBarBasicType.icon,
      componentType: TDBottomNavBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomNavBarTabConfig(
          iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomNavBarTabConfig(
          iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomNavBarTabConfig(
          iconTypeConfig: IconTypeConfig(useDefaultIcon: true),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  @Demo(group: 'bottomNavBar')
  Widget _weakSelectIconTextNavBar(BuildContext context) {
    return TDBottomNavBar(
      TDBottomNavBarBasicType.iconText,
      componentType: TDBottomNavBarComponentType.normal,
      useVerticalDivider: false,
      navigationTabs: [
        TDBottomNavBarTabConfig(
          iconTextTypeConfig:
              IconTextTypeConfig(useDefaultIcon: true, tabText: '标签'),
          badgeConfig: BadgeConfig(
            showBage: true,
            tdBadge: const TDBadge(TDBadgeType.redPoint),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomNavBarTabConfig(
          iconTextTypeConfig:
              IconTextTypeConfig(useDefaultIcon: true, tabText: '标签'),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomNavBarTabConfig(
          iconTextTypeConfig:
              IconTextTypeConfig(useDefaultIcon: true, tabText: '标签'),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  @Demo(group: 'bottomNavBar')
  Widget _capsuleNavBar(BuildContext context) {
    return TDBottomNavBar(
      TDBottomNavBarBasicType.iconText,
      componentType: TDBottomNavBarComponentType.label,
      outlineType: TDBottomNavBarOutlineType.capsule,
      useVerticalDivider: true,
      navigationTabs: [
        TDBottomNavBarTabConfig(
          iconTextTypeConfig:
              IconTextTypeConfig(useDefaultIcon: true, tabText: '标签'),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TDBottomNavBarTabConfig(
          iconTextTypeConfig:
              IconTextTypeConfig(useDefaultIcon: true, tabText: '标签'),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TDBottomNavBarTabConfig(
          iconTextTypeConfig:
              IconTextTypeConfig(useDefaultIcon: true, tabText: '标签'),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }
}
