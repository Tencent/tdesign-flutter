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
        title: tdTitle(context),
        desc: '用于在不同功能模块之间进行快速切换，位于页面底部。',
        backgroundColor: const Color(0xFFF0F2F5),
        exampleCodeGroup: 'bottomNavBar',
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                ignoreCode: true,
                  desc: '纯文本标签栏', builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _textTypeNavBar),);
              }),
              ExampleItem(
                ignoreCode: true,builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _textTypeNavBar3tabs),);
              }),
              ExampleItem(
                ignoreCode: true, builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _textTypeNavBar4tabs),);
              }),
              ExampleItem(
                ignoreCode: true, builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _textTypeNavBar5tabs),);
              }),
              ExampleItem(
                ignoreCode: true,
                  desc: '图标加文本标签栏', builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTextTypeNavBar),);
              }),
              ExampleItem(
                ignoreCode: true, builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTextTypeNavBar3tabs),);
              }),
              ExampleItem(
                ignoreCode: true, builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTextTypeNavBar4tabs),);
              }),
              ExampleItem(
                ignoreCode: true, builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTextTypeNavBar5tabs),);
              }),
              ExampleItem(
                ignoreCode: true,
                  desc: '纯图标标签栏',builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTypeNavBar),);
              }),
              ExampleItem(
                ignoreCode: true,builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTypeNavBar3tabs),);
              }),
              ExampleItem(
                ignoreCode: true,builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTypeNavBar4tabs),);
              }),
              ExampleItem(
                ignoreCode: true,builder: (context){
                    return Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CodeWrapper(builder: _iconTypeNavBar5tabs),);
              }),
              ExampleItem(
                desc: '双层级文本标签栏',
                builder: _expansionPannelTypeNavBar,
              ),
            ],
          ),
          ExampleModule(title: '组件样式', children: [

            ExampleItem(
                ignoreCode: true,
                desc: '弱选中标签栏',builder: (context){
              return Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: CodeWrapper(builder: _weakSelectTextNavBar),);
            }),
            ExampleItem(
                ignoreCode: true,builder: (context){
              return Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: CodeWrapper(builder: _weakSelectIconNavBar),);
            }),
            ExampleItem(
                ignoreCode: true,builder: (context){
              return Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: CodeWrapper(builder: _weakSelectIconTextNavBar),);
            }),
            ExampleItem(
              desc: '悬浮胶囊标签栏',
              builder: _capsuleNavBar,
            ),
          ]),
        ],
    test: [
      ExampleItem(
          desc: '自定义上边线样式',
          builder: _buildCustomTopStyle)
    ],
    );
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

  @Demo(group: 'bottomNavBar')
  Widget _buildCustomTopStyle(BuildContext context) {
    return TDBottomNavBar(
      TDBottomNavBarBasicType.iconText,
      topBorder: const BorderSide(color: Colors.red, width: 5),
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
}
