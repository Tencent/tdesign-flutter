import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

Widget? _selectedIcon;

Widget? _unSelectedIcon;

class _ExampleTabBar extends StatefulWidget {
  const _ExampleTabBar({
    required this.variant,
    required this.navigationTabs,
    this.value,
    this.onChanged,
    this.barHeight,
    this.useVerticalDivider,
    this.topBorder,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.backgroundColor,
    this.needInkWell = false,
    this.indicatorAnimation = TTabBarIndicatorAnimation.none,
  });

  final TTabBarVariant variant;
  final List<TTabBarItemConfig> navigationTabs;
  final int? value;
  final ValueChanged<int>? onChanged;
  final double? barHeight;
  final bool? useVerticalDivider;
  final BorderSide? topBorder;
  final Color? selectedBgColor;
  final Color? unselectedBgColor;
  final Color? backgroundColor;
  final bool needInkWell;
  final TTabBarIndicatorAnimation indicatorAnimation;

  @override
  State<_ExampleTabBar> createState() => _ExampleTabBarState();
}

class _ExampleTabBarState extends State<_ExampleTabBar> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? 0;
  }

  @override
  void didUpdateWidget(covariant _ExampleTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _value = widget.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TTabBar(
      variant: widget.variant,
      navigationTabs: widget.navigationTabs,
      value: widget.value ?? _value,
      onChanged: (value) {
        widget.onChanged?.call(value);
        if (widget.value == null) {
          setState(() => _value = value);
        }
      },
      barHeight: widget.barHeight,
      useVerticalDivider: widget.useVerticalDivider,
      topBorder: widget.topBorder,
      selectedBgColor: widget.selectedBgColor,
      unselectedBgColor: widget.unselectedBgColor,
      backgroundColor: widget.backgroundColor,
      needInkWell: widget.needInkWell,
      indicatorAnimation: widget.indicatorAnimation,
    );
  }
}

class TTabBarPage extends StatefulWidget {
  const TTabBarPage({Key? key}) : super(key: key);

  @override
  State<TTabBarPage> createState() => _TTabBarPageState();
}

class _TTabBarPageState extends State<TTabBarPage> {
  void onTapTab(
    BuildContext context,
    String tabName,
  ) {
    TToast.showText('点击了 $tabName', context: context);
  }

  @override
  Widget build(BuildContext context) {
    _selectedIcon = Icon(
      TIcons.app,
      size: 20,
      color: context.tTheme.brandNormalColor,
    );
    _unSelectedIcon = Icon(
      TIcons.app,
      size: 20,
      color: context.tTheme.textColorPrimary,
    );
    return ExamplePage(
      title: tTitle(),
      desc: '用于在不同功能模块之间进行快速切换，位于页面底部。',
      exampleCodeGroup: 'tabBar',
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '纯文本标签栏', builder: _textTypeTabBar),
            ExampleItem(builder: _textTypeTabBar3tabs),
            ExampleItem(builder: _textTypeTabBar4tabs),
            ExampleItem(builder: _textTypeTabBar5tabs),
            ExampleItem(desc: '图标加文本标签栏', builder: _iconTextTypeTabBar),
            ExampleItem(builder: _iconTextTypeTabBar3tabs),
            ExampleItem(builder: _iconTextTypeTabBar4tabs),
            ExampleItem(builder: _iconTextTypeTabBar5tabs),
            ExampleItem(desc: '纯图标标签栏', builder: _iconTypeTabBar),
            ExampleItem(builder: _iconTypeTabBar3tabs),
            ExampleItem(builder: _iconTypeTabBar4tabs),
            ExampleItem(builder: _iconTypeTabBar5tabs),
            ExampleItem(desc: '双层级文本标签栏', builder: _expansionPanelTypeTabBar),
          ],
        ),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '弱选中标签栏', builder: _weakSelectTextTabBar),
          ExampleItem(builder: _weakSelectIconTabBar),
          ExampleItem(builder: _weakSelectIconTextTabBar),
          ExampleItem(desc: '悬浮胶囊标签栏', builder: _capsuleTabBar),
        ]),
        ExampleModule(title: '组件事件', children: [
          ExampleItem(desc: '长按触发', builder: _capsuleTabBarOnLongPress),
          ExampleItem(desc: '禁用状态', builder: _disabledTabBar),
        ]),
      ],
      test: [
        ExampleItem(desc: '自定义上边线样式', builder: _buildCustomTopStyle),
        ExampleItem(desc: '自定义选择的背景颜色', builder: _customBgColor),
        ExampleItem(desc: '设置文本标签栏背景', builder: _customBgTypeTabBar),
        ExampleItem(desc: '外部设置tabbar的选中项', builder: _setValueToTabBar),
        ExampleItem(desc: 'onTap支持重复触发', builder: _allowMultipleTaps),
        ExampleItem(desc: '支持水波纹效果', builder: _needInkWellTabBar),
        ExampleItem(
            desc: 'tabbar切换线性滑动效果', builder: _indicatorLinearAnimationTabBar),
        ExampleItem(
            desc: 'tabbar切换弹性动画效果', builder: _indicatorElasticAnimationTabBar),
      ],
    );
  }

  @Demo(group: 'tabBar')
  Widget _textTypeTabBar(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.text,
      useVerticalDivider: false,
      navigationTabs: List.generate(2, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _textTypeTabBar3tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.text,
      indicatorAnimation: TTabBarIndicatorAnimation.elastic,
      useVerticalDivider: false,
      navigationTabs: List.generate(3, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _textTypeTabBar4tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.text,
      useVerticalDivider: false,
      navigationTabs: List.generate(4, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _textTypeTabBar5tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.text,
      useVerticalDivider: false,
      navigationTabs: List.generate(5, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTextTypeTabBar(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.iconText,
      useVerticalDivider: false,
      navigationTabs: List.generate(2, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTextTypeTabBar3tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.iconText,
      useVerticalDivider: false,
      navigationTabs: List.generate(3, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTextTypeTabBar4tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.iconText,
      useVerticalDivider: false,
      navigationTabs: List.generate(4, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTextTypeTabBar5tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.iconText,
      useVerticalDivider: false,
      navigationTabs: List.generate(5, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
          tabText: label,
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () {
            onTapTab(context, label);
          },
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTypeTabBar(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.icon,
      useVerticalDivider: true,
      navigationTabs: List.generate(2, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, label);
            });
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTypeTabBar3tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.icon,
      useVerticalDivider: true,
      navigationTabs: List.generate(3, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, label);
            });
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTypeTabBar4tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.icon,
      useVerticalDivider: true,
      navigationTabs: List.generate(4, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, label);
            });
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _iconTypeTabBar5tabs(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.icon,
      useVerticalDivider: true,
      navigationTabs: List.generate(5, (index) {
        final label = '标签${index + 1}';
        return TTabBarItemConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, label);
            });
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _expansionPanelTypeTabBar(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.expansionPanel,
      useVerticalDivider: true,
      navigationTabs: [
        TTabBarItemConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TTabBarItemConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TTabBarItemConfig(
            tabText: '展开项',
            onTap: () {
              // 不触发点击事件
              onTapTab(context, '展开项');
            },
            popUpButtonConfig: TTabBarPopUpBtnConfig(
                popUpDialogConfig: TTabBarPopUpShapeConfig(
                  radius: 10,
                  arrowWidth: 16,
                  arrowHeight: 8,
                ),
                items: ['展开项一', '展开项二', '展开项三']
                    .reversed
                    .map((e) => TTabBarMenuItem(
                          value: e,
                          itemWidget: Text(
                            e,
                            style: TextStyle(
                                color: context.tTheme.textColorPrimary,
                                fontSize: 16),
                          ),
                        ))
                    .toList(),
                onChanged: (v) {
                  TToast.showText('点击了 $v', context: context);
                })),
      ],
    );
  }

  @Demo(group: 'tabBar')
  Widget _weakSelectTextTabBar(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.weakText,
      useVerticalDivider: true,
      navigationTabs: [
        TTabBarItemConfig(
          badgeConfig: TTabBarBadgeConfig(
            showBadge: true,
            tBadge: const TBadge(variant: TBadgeVariant.dot),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TTabBarItemConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TTabBarItemConfig(
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  @Demo(group: 'tabBar')
  Widget _weakSelectIconTabBar(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.weakIcon,
      useVerticalDivider: false,
      navigationTabs: [
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: TTabBarBadgeConfig(
            showBadge: true,
            tBadge: const TBadge(variant: TBadgeVariant.dot),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  @Demo(group: 'tabBar')
  Widget _weakSelectIconTextTabBar(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.weakIconText,
      useVerticalDivider: false,
      navigationTabs: [
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: TTabBarBadgeConfig(
            showBadge: true,
            tBadge: const TBadge(variant: TBadgeVariant.dot),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  @Demo(group: 'tabBar')
  Widget _capsuleTabBar(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.capsule,
        useVerticalDivider: true,
        navigationTabs: List.generate(3, (index) {
          final label = '标签${index + 1}';
          return TTabBarItemConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            tabText: label,
            onTap: () {
              onTapTab(context, label);
            },
          );
        }));
  }

  @Demo(group: 'tabBar')
  Widget _capsuleTabBarOnLongPress(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.capsule,
        useVerticalDivider: true,
        navigationTabs: List.generate(3, (index) {
          final label = '标签${index + 1}';
          return TTabBarItemConfig(
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            tabText: label,
            onTap: () {
              onTapTab(context, label);
            },
            onLongPress: () {
              print('长按了${label}');
              TToast.showText('长按了 $label', context: context);
            },
          );
        }));
  }

  @Demo(group: 'tabBar')
  Widget _disabledTabBar(BuildContext context) {
    return TTabBar(
      variant: TTabBarVariant.iconText,
      value: 0,
      navigationTabs: List.generate(3, (index) {
        return TTabBarItemConfig(
          tabText: '标签${index + 1}',
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          onTap: () => onTapTab(context, '标签${index + 1}'),
        );
      }),
    );
  }

  @Demo(group: 'tabBar')
  Widget _buildCustomTopStyle(BuildContext context) {
    return _ExampleTabBar(
      variant: TTabBarVariant.weakIconText,
      topBorder: const BorderSide(color: Colors.red, width: 5),
      barHeight: 61,
      useVerticalDivider: false,
      navigationTabs: [
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          badgeConfig: TTabBarBadgeConfig(
            showBadge: true,
            tBadge: const TBadge(variant: TBadgeVariant.dot),
            badgeTopOffset: -2,
            badgeRightOffset: -10,
          ),
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签1');
          },
        ),
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签2');
          },
        ),
        TTabBarItemConfig(
          selectedIcon: _selectedIcon,
          unselectedIcon: _unSelectedIcon,
          tabText: '标签',
          onTap: () {
            onTapTab(context, '标签3');
          },
        ),
      ],
    );
  }

  @Demo(group: 'tabBar')
  Widget _customBgColor(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.iconText,
        useVerticalDivider: false,
        selectedBgColor: context.tTheme.errorColor3,
        unselectedBgColor: context.tTheme.bgColorSecondaryContainer,
        navigationTabs: List.generate(5, (index) {
          final label = '标签${index + 1}';
          return TTabBarItemConfig(
            tabText: label,
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, label);
            },
          );
        }));
  }

  @Demo(group: 'tabBar')
  Widget _customBgTypeTabBar(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.text,
        backgroundColor: context.tTheme.successNormalColor,
        selectedBgColor: context.tTheme.errorLightColor,
        unselectedBgColor: context.tTheme.brandLightColor,
        useVerticalDivider: false,
        navigationTabs: [
          TTabBarItemConfig(
            tabText: '标签1',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TTabBarItemConfig(
            tabText: '标签2',
            unselectTabTextStyle:
                TextStyle(color: context.tTheme.textColorBrand),
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }

  var _tabBarValue = 0;

  @Demo(group: 'tabBar')
  Widget _setValueToTabBar(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Expanded(
              child: PageView(
            children: const [
              Center(child: TText('页面1，手指左滑查看页面2')),
              Center(child: TText('页面2，手指右滑查看页面1')),
            ],
            onPageChanged: (index) {
              setState(() {
                _tabBarValue = index;
              });
            },
          )),
          _ExampleTabBar(
              variant: TTabBarVariant.icon, // 设置选中索引
              value: _tabBarValue,
              onChanged: (value) {
                setState(() => _tabBarValue = value);
              },
              useVerticalDivider: true,
              navigationTabs: List.generate(2, (index) {
                final label = '标签${index + 1}';
                return TTabBarItemConfig(
                    selectedIcon: _selectedIcon,
                    unselectedIcon: _unSelectedIcon,
                    onTap: () {
                      onTapTab(context, label);
                    });
              }))
        ],
      ),
    );
  }

  @Demo(group: 'tabBar')
  Widget _allowMultipleTaps(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.text,
        useVerticalDivider: false,
        navigationTabs: [
          TTabBarItemConfig(
            allowMultipleTaps: true,
            tabText: '支持重复点击',
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TTabBarItemConfig(
            tabText: '不支持重复点击',
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }

  @Demo(group: 'tabBar')
  Widget _needInkWellTabBar(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.iconText,
        needInkWell: true,
        navigationTabs: [
          TTabBarItemConfig(
            tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TTabBarItemConfig(
            tabText: '',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TTabBarItemConfig(
            tabText: '标签',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
        ]);
  }

  @Demo(group: 'tabBar')
  Widget _indicatorLinearAnimationTabBar(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.text,
        indicatorAnimation: TTabBarIndicatorAnimation.linear,
        navigationTabs: [
          TTabBarItemConfig(
            tabText: '标签1',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TTabBarItemConfig(
            tabText: '标签2',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TTabBarItemConfig(
            tabText: '标签3',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签3');
            },
          ),
        ]);
  }

  @Demo(group: 'tabBar')
  Widget _indicatorElasticAnimationTabBar(BuildContext context) {
    return _ExampleTabBar(
        variant: TTabBarVariant.text,
        indicatorAnimation: TTabBarIndicatorAnimation.elastic,
        navigationTabs: [
          TTabBarItemConfig(
            tabText: '标签1',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签1');
            },
          ),
          TTabBarItemConfig(
            tabText: '标签2',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签2');
            },
          ),
          TTabBarItemConfig(
            tabText: '标签3',
            selectedIcon: _selectedIcon,
            unselectedIcon: _unSelectedIcon,
            onTap: () {
              onTapTab(context, '标签3');
            },
          ),
        ]);
  }
}
