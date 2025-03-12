import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

class IconWithBackground extends StatelessWidget {
  final IconData icon;

  const IconWithBackground({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: TDTheme.of(context).grayColor1,
        borderRadius: BorderRadius.circular(TDTheme.of(context).radiusDefault),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 24.0,
        ),
      ),
    );
  }
}

const _nums = ['一', '二', '三', '四'];
List<TDActionSheetItem> _gridItems = [
  TDActionSheetItem(label: '微信', icon: Image.asset('assets/img/td_action_sheet_1.png'), group: '分享至'),
  TDActionSheetItem(label: '朋友圈', icon: Image.asset('assets/img/td_action_sheet_2.png'), group: '分享至'),
  TDActionSheetItem(label: 'QQ', icon: Image.asset('assets/img/td_action_sheet_3.png'), group: '分享至'),
  TDActionSheetItem(label: '企业微信', icon: Image.asset('assets/img/td_action_sheet_4.png'), group: '分享至'),
  TDActionSheetItem(label: '收藏', icon: const IconWithBackground(icon: TDIcons.star), group: '分享至'),
  TDActionSheetItem(label: '刷新', icon: const IconWithBackground(icon: TDIcons.refresh), group: '分享至'),
  TDActionSheetItem(label: '下载', icon: const IconWithBackground(icon: TDIcons.download), group: '分享至'),
  TDActionSheetItem(label: '复制', icon: const IconWithBackground(icon: TDIcons.queue), group: '分享至'),
];

class TDActionSheetPage extends StatelessWidget {
  const TDActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: TDTheme.of(context).grayColor2,
        child: ExamplePage(
          title: tdTitle(context),
          desc: '从底部弹出的模态框，提供和当前场景相关的操作动作，也支持提供信息输入和描述。',
          exampleCodeGroup: 'action_sheet',
          children: [
            ExampleModule(title: '组件类型', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '列表型动作面板',
                builder: (BuildContext context) {
                  return const Column(
                    children: [
                      CodeWrapper(builder: _buildBaseListActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildDescListActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildIconListActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildBadgeListActionSheet),
                    ],
                  );
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '宫格型动作面板',
                builder: (BuildContext context) {
                  return const Column(
                    children: [
                      CodeWrapper(builder: _buildBaseGridActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildDescGridActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildPaginationGridActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildScrollGridActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildMultiScrollGridActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildBadgeGridActionSheet),
                    ],
                  );
                },
              ),
            ]),
            ExampleModule(title: '组件状态', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '列表型选项状态',
                builder: (BuildContext context) {
                  return const Column(
                    children: [
                      CodeWrapper(builder: _buildBaseListStateActionSheet),
                      SizedBox(height: 16),
                      CodeWrapper(builder: _buildIconListStateActionSheet),
                    ],
                  );
                },
              )
            ]),
            ExampleModule(title: '组件样式', children: [
              ExampleItem(
                  ignoreCode: true,
                  desc: '列表型对齐方式',
                  builder: (BuildContext context) {
                    return const Column(
                      children: [
                        CodeWrapper(builder: _buildBadgeListCenterActionSheet),
                        SizedBox(height: 16),
                        CodeWrapper(builder: _buildIconListCenterActionSheet),
                        SizedBox(height: 16),
                        CodeWrapper(builder: _buildBadgeListLeftActionSheet),
                        SizedBox(height: 16),
                        CodeWrapper(builder: _buildIconListLeftActionSheet),
                      ],
                    );
                  })
            ])
          ],
          test: const [],
        ));
  }
}

@Demo(group: 'action_sheet')
Widget _buildBaseListActionSheet(BuildContext context) {
  return TDButton(
    text: '常规列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: _nums.map((e) => TDActionSheetItem(label: '选项$e')).toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildDescListActionSheet(BuildContext context) {
  return TDButton(
    text: '带描述列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: _nums.map((e) => TDActionSheetItem(label: '选项$e')).toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildIconListActionSheet(BuildContext context) {
  return TDButton(
    text: '带图标列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: _nums
            .map((e) => TDActionSheetItem(
                  label: '选项$e',
                  icon: const Icon(TDIcons.app),
                ))
            .toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBadgeListActionSheet(BuildContext context) {
  return TDButton(
    text: '带徽标列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: [
          TDActionSheetItem(
            label: '选项一',
            badge: const TDBadge(TDBadgeType.redPoint),
          ),
          TDActionSheetItem(
            label: '选项二',
            badge: const TDBadge(TDBadgeType.message, count: '8'),
          ),
          TDActionSheetItem(
            label: '选项三',
            badge: const TDBadge(TDBadgeType.message, count: '99'),
          ),
          TDActionSheetItem(
            label: '选项四',
            badge: const TDBadge(TDBadgeType.message, count: '99+'),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBaseGridActionSheet(BuildContext context) {
  return TDButton(
    text: '常规宫格',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        items: _gridItems,
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildDescGridActionSheet(BuildContext context) {
  return TDButton(
    text: '带描述宫格',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        description: '动作面板描述文字',
        items: _gridItems,
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildPaginationGridActionSheet(BuildContext context) {
  return TDButton(
    text: '带翻页宫格',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        showPagination: true,
        items: [
          ..._gridItems,
          TDActionSheetItem(
            label: '安卓',
            icon: const IconWithBackground(icon: TDIcons.logo_android),
          ),
          TDActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: TDIcons.logo_apple),
          ),
          TDActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: TDIcons.logo_chrome),
          ),
          TDActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: TDIcons.logo_github),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildScrollGridActionSheet(BuildContext context) {
  return TDButton(
    text: '多行滚动宫格',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        theme: TDActionSheetTheme.grid,
        count: 8,
        scrollable: true,
        items: [
          ..._gridItems,
          TDActionSheetItem(
            label: '安卓',
            icon: const IconWithBackground(icon: TDIcons.logo_android),
          ),
          TDActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: TDIcons.logo_apple),
          ),
          TDActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: TDIcons.logo_chrome),
          ),
          TDActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: TDIcons.logo_github),
          ),
          TDActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: TDIcons.logo_github),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildMultiScrollGridActionSheet(BuildContext context) {
  return TDButton(
    text: '带描述多行滚动宫格',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet.showGroupActionSheet(context, items: [
        TDActionSheetItem(
          label: 'Allen',
          icon: Image.asset('assets/img/td_action_sheet_5.png'),
          group: '分享给好友',
        ),
        TDActionSheetItem(
          label: 'Nick',
          icon: Image.asset('assets/img/td_action_sheet_6.png'),
          group: '分享给好友',
        ),
        TDActionSheetItem(
          label: 'Jacky',
          icon: Image.asset('assets/img/td_action_sheet_7.png'),
          group: '分享给好友',
        ),
        TDActionSheetItem(
          label: 'Eric',
          icon: Image.asset('assets/img/td_action_sheet_8.png'),
          group: '分享给好友',
        ),
        TDActionSheetItem(
          label: 'Johnsc',
          icon: Image.asset('assets/img/td_action_sheet_5.png'),
          group: '分享给好友',
        ),
        TDActionSheetItem(
          label: 'Kevin',
          icon: Image.asset('assets/img/td_action_sheet_6.png'),
          group: '分享给好友',
        ),
        ..._gridItems,
      ]);
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBadgeGridActionSheet(BuildContext context) {
  return TDButton(
    text: '带徽标宫格型',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet.showGridActionSheet(context, items: [
        TDActionSheetItem(label: '微信', icon: Image.asset('assets/img/td_action_sheet_1.png'), badge: const TDBadge(TDBadgeType.message, count: 'NEW')),
        TDActionSheetItem(label: '朋友圈', icon: Image.asset('assets/img/td_action_sheet_2.png')),
        TDActionSheetItem(label: 'QQ', icon: Image.asset('assets/img/td_action_sheet_3.png')),
        TDActionSheetItem(label: '企业微信', icon: Image.asset('assets/img/td_action_sheet_4.png')),
        TDActionSheetItem(label: '收藏', icon: const IconWithBackground(icon: TDIcons.star), badge: const TDBadge(TDBadgeType.redPoint)),
        TDActionSheetItem(label: '刷新', icon: const IconWithBackground(icon: TDIcons.refresh)),
        TDActionSheetItem(label: '下载', icon: const IconWithBackground(icon: TDIcons.download), badge: const TDBadge(TDBadgeType.message, count: '8')),
        TDActionSheetItem(label: '复制', icon: const IconWithBackground(icon: TDIcons.queue)),
      ]);
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBaseListStateActionSheet(BuildContext context) {
  return TDButton(
    text: '列表型选项状态',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: [
          TDActionSheetItem(
            label: '默认选项',
          ),
          TDActionSheetItem(
            label: '自定义选项',
            textStyle: TextStyle(
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          TDActionSheetItem(
            label: '失效选项',
            disabled: true,
          ),
          TDActionSheetItem(
            label: '警告选项',
            textStyle: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
        onSelected: (item, index) {
          print('选中了：${item.label}');
        },
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildIconListStateActionSheet(BuildContext context) {
  return TDButton(
    text: '列表型带图标状态',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        items: [
          TDActionSheetItem(
            label: '默认选项',
            icon: const Icon(TDIcons.app),
          ),
          TDActionSheetItem(
            label: '自定义选项',
            icon: const Icon(TDIcons.app),
            textStyle: TextStyle(
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          TDActionSheetItem(
            label: '失效选项',
            icon: const Icon(TDIcons.app),
            disabled: true,
          ),
          TDActionSheetItem(
            label: '警告选项',
            icon: const Icon(TDIcons.app),
            textStyle: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
        onSelected: (item, index) {
          print('选中了：${item.label}');
        },
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBadgeListCenterActionSheet(BuildContext context) {
  return TDButton(
    text: '居中带徽标列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: [
          TDActionSheetItem(
            label: '选项一',
            badge: const TDBadge(TDBadgeType.redPoint),
          ),
          TDActionSheetItem(
            label: '选项二',
            badge: const TDBadge(TDBadgeType.message, count: '8',),
          ),
          TDActionSheetItem(
            label: '选项三',
            badge: const TDBadge(TDBadgeType.message, count: '99',),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildIconListCenterActionSheet(BuildContext context) {
  return TDButton(
    text: '居中带图标列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: _nums
            .map((e) => TDActionSheetItem(
                  label: '选项$e',
                  icon: const Icon(TDIcons.app),
                ))
            .toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBadgeListLeftActionSheet(BuildContext context) {
  return TDButton(
    text: '左对齐带徽标列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        align: TDActionSheetAlign.left,
        items: _nums
            .map((e) => TDActionSheetItem(
                  label: '选项$e',
                  badge: const TDBadge(TDBadgeType.redPoint),
                ))
            .toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildIconListLeftActionSheet(BuildContext context) {
  return TDButton(
    text: '左对齐带图标列表',
    isBlock: true,
    type: TDButtonType.outline,
    theme: TDButtonTheme.primary,
    size: TDButtonSize.large,
    onTap: () {
      TDActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        align: TDActionSheetAlign.left,
        items: _nums
            .map((e) => TDActionSheetItem(
                  label: '选项$e',
                  icon: const Icon(TDIcons.app),
                ))
            .toList(),
      );
    },
  );
}
