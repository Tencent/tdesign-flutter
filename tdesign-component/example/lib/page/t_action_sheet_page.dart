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
        color: TTheme.of(context).bgColorSecondaryContainer,
        borderRadius: BorderRadius.circular(TTheme.of(context).radiusDefault),
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
List<TActionSheetItem> _gridItems = [
  TActionSheetItem(
      label: '微信',
      icon: Image.asset('assets/img/t_action_sheet_1.png'),
      group: '分享至'),
  TActionSheetItem(
      label: '朋友圈',
      icon: Image.asset('assets/img/t_action_sheet_2.png'),
      group: '分享至'),
  TActionSheetItem(
      label: 'QQ',
      icon: Image.asset('assets/img/t_action_sheet_3.png'),
      group: '分享至'),
  TActionSheetItem(
      label: '企业微信',
      icon: Image.asset('assets/img/t_action_sheet_4.png'),
      group: '分享至'),
  TActionSheetItem(
      label: '收藏',
      icon: const IconWithBackground(icon: TIcons.star),
      group: '分享至'),
  TActionSheetItem(
      label: '刷新',
      icon: const IconWithBackground(icon: TIcons.refresh),
      group: '分享至'),
  TActionSheetItem(
      label: '下载',
      icon: const IconWithBackground(icon: TIcons.download),
      group: '分享至'),
  TActionSheetItem(
      label: '复制',
      icon: const IconWithBackground(icon: TIcons.queue),
      group: '分享至'),
];

class TActionSheetPage extends StatelessWidget {
  const TActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '由用户操作后触发的一种特定的模态弹出框 ，呈现一组与当前情境相关的两个或多个选项。',
      exampleCodeGroup: 'action_sheet',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
            ignoreCode: true,
            desc: '列表型动作面板',
            builder: (BuildContext context) {
              return const Column(
                // spacing: 16,
                children: [
                  CodeWrapper(builder: _buildBaseListActionSheet),
                  SizedBox(height: 16),
                  CodeWrapper(builder: _buildDescListActionSheet),
                  SizedBox(height: 16),
                  CodeWrapper(builder: _buildIconListActionSheet),
                  SizedBox(height: 16),
                  CodeWrapper(builder: _buildBadgeListActionSheet),
                  SizedBox(height: 16),
                  CodeWrapper(builder: _buildItemDescriptionListActionSheet),
                ],
              );
            },
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '宫格型动作面板',
            builder: (BuildContext context) {
              return const Column(
                // spacing: 16,
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
                // spacing: 16,
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
                  // spacing: 16,
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
    );
  }
}

@Demo(group: 'action_sheet')
Widget _buildBaseListActionSheet(BuildContext context) {
  return TButton(
    child: Text('常规列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        items: _nums.map((e) => TActionSheetItem(label: '选项$e')).toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildDescListActionSheet(BuildContext context) {
  return TButton(
    child: Text('带描述列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: _nums.map((e) => TActionSheetItem(label: '选项$e')).toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildIconListActionSheet(BuildContext context) {
  return TButton(
    child: Text('带图标列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        items: _nums
            .map((e) => TActionSheetItem(
                  label: '选项$e',
                  icon: const Icon(TIcons.app),
                ))
            .toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBadgeListActionSheet(BuildContext context) {
  return TButton(
    child: Text('带徽标列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        items: [
          TActionSheetItem(
            label: '选项一',
            badge: const TBadge(TBadgeType.redPoint),
          ),
          TActionSheetItem(
            label: '选项二',
            badge: const TBadge(TBadgeType.message, count: '8'),
          ),
          TActionSheetItem(
            label: '选项三',
            badge: const TBadge(TBadgeType.message, count: '99'),
          ),
          TActionSheetItem(
            label: '选项四',
            badge: const TBadge(TBadgeType.message, count: '99+'),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildItemDescriptionListActionSheet(BuildContext context) {
  return TButton(
    child: Text('带Cell描述常规列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        items: _nums.map((e) => TActionSheetItem(label: '选项$e',description: '描述$e')).toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBaseGridActionSheet(BuildContext context) {
  return TButton(
    child: Text('常规宫格'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        theme: TActionSheetTheme.grid,
        count: 8,
        items: _gridItems,
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildDescGridActionSheet(BuildContext context) {
  return TButton(
    child: Text('带描述宫格'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        theme: TActionSheetTheme.grid,
        count: 8,
        description: '动作面板描述文字',
        items: _gridItems,
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildPaginationGridActionSheet(BuildContext context) {
  return TButton(
    child: Text('带翻页宫格'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        theme: TActionSheetTheme.grid,
        count: 8,
        showPagination: true,
        items: [
          ..._gridItems,
          TActionSheetItem(
            label: '安卓',
            icon: const IconWithBackground(icon: TIcons.logo_android),
          ),
          TActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: TIcons.logo_apple),
          ),
          TActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: TIcons.logo_chrome),
          ),
          TActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: TIcons.logo_github),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildScrollGridActionSheet(BuildContext context) {
  return TButton(
    child: Text('多行滚动宫格'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        theme: TActionSheetTheme.grid,
        count: 8,
        scrollable: true,
        items: [
          ..._gridItems,
          TActionSheetItem(
            label: '安卓',
            icon: const IconWithBackground(icon: TIcons.logo_android),
          ),
          TActionSheetItem(
            label: 'Apple',
            icon: const IconWithBackground(icon: TIcons.logo_apple),
          ),
          TActionSheetItem(
            label: 'Chrome',
            icon: const IconWithBackground(icon: TIcons.logo_chrome),
          ),
          TActionSheetItem(
            label: 'Github',
            icon: const IconWithBackground(icon: TIcons.logo_github),
          ),
          TActionSheetItem(
            label: 'Twitter',
            icon: const IconWithBackground(icon: TIcons.logo_twitter),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildMultiScrollGridActionSheet(BuildContext context) {
  return TButton(
    child: Text('带描述多行滚动宫格'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet.showGroupActionSheet(context, items: [
        TActionSheetItem(
          label: 'Allen',
          icon: Image.asset('assets/img/t_action_sheet_5.png'),
          group: '分享给好友',
        ),
        TActionSheetItem(
          label: 'Nick',
          icon: Image.asset('assets/img/t_action_sheet_6.png'),
          group: '分享给好友',
        ),
        TActionSheetItem(
          label: 'Jacky',
          icon: Image.asset('assets/img/t_action_sheet_7.png'),
          group: '分享给好友',
        ),
        TActionSheetItem(
          label: 'Eric',
          icon: Image.asset('assets/img/t_action_sheet_8.png'),
          group: '分享给好友',
        ),
        TActionSheetItem(
          label: 'Johnsc',
          icon: Image.asset('assets/img/t_action_sheet_5.png'),
          group: '分享给好友',
        ),
        TActionSheetItem(
          label: 'Kevin',
          icon: Image.asset('assets/img/t_action_sheet_6.png'),
          group: '分享给好友',
        ),
        ..._gridItems,
      ]);
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBadgeGridActionSheet(BuildContext context) {
  return TButton(
    child: Text('带徽标宫格型'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet.showGridActionSheet(context, items: [
        TActionSheetItem(
            label: '微信',
            icon: Image.asset('assets/img/t_action_sheet_1.png'),
            badge: const TBadge(TBadgeType.message, count: 'NEW')),
        TActionSheetItem(
            label: '朋友圈',
            icon: Image.asset('assets/img/t_action_sheet_2.png')),
        TActionSheetItem(
            label: 'QQ', icon: Image.asset('assets/img/t_action_sheet_3.png')),
        TActionSheetItem(
            label: '企业微信',
            icon: Image.asset('assets/img/t_action_sheet_4.png')),
        TActionSheetItem(
            label: '收藏',
            icon: const IconWithBackground(icon: TIcons.star),
            badge: const TBadge(TBadgeType.redPoint)),
        TActionSheetItem(
            label: '刷新', icon: const IconWithBackground(icon: TIcons.refresh)),
        TActionSheetItem(
            label: '下载',
            icon: const IconWithBackground(icon: TIcons.download),
            badge: const TBadge(TBadgeType.message, count: '8')),
        TActionSheetItem(
            label: '复制', icon: const IconWithBackground(icon: TIcons.queue)),
      ]);
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBaseListStateActionSheet(BuildContext context) {
  return TButton(
    child: Text('列表型选项状态'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        items: [
          TActionSheetItem(
            label: '默认选项',
          ),
          TActionSheetItem(
            label: '自定义选项',
            textStyle: TextStyle(
              color: TTheme.of(context).brandNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '失效选项',
            onPressed: null,
          ),
          TActionSheetItem(
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
  return TButton(
    child: Text('列表型带图标状态'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        items: [
          TActionSheetItem(
            label: '默认选项',
            icon: const Icon(TIcons.app),
          ),
          TActionSheetItem(
            label: '自定义选项',
            icon: const Icon(TIcons.app),
            textStyle: TextStyle(
              color: TTheme.of(context).brandNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '失效选项',
            icon: const Icon(TIcons.app),
            onPressed: null,
          ),
          TActionSheetItem(
            label: '警告选项',
            icon: const Icon(TIcons.app),
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
  return TButton(
    child: Text('居中带徽标列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: [
          TActionSheetItem(
            label: '选项一',
            badge: const TBadge(TBadgeType.redPoint),
          ),
          TActionSheetItem(
            label: '选项二',
            badge: const TBadge(
              TBadgeType.message,
              count: '8',
            ),
          ),
          TActionSheetItem(
            label: '选项三',
            badge: const TBadge(
              TBadgeType.message,
              count: '99',
            ),
          ),
        ],
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildIconListCenterActionSheet(BuildContext context) {
  return TButton(
    child: Text('居中带图标列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        items: _nums
            .map((e) => TActionSheetItem(
                  label: '选项$e',
                  icon: const Icon(TIcons.app),
                ))
            .toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildBadgeListLeftActionSheet(BuildContext context) {
  return TButton(
    child: Text('左对齐带徽标列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        align: TActionSheetAlign.left,
        items: _nums
            .map((e) => TActionSheetItem(
                  label: '选项$e',
                  badge: const TBadge(TBadgeType.redPoint),
                ))
            .toList(),
      );
    },
  );
}

@Demo(group: 'action_sheet')
Widget _buildIconListLeftActionSheet(BuildContext context) {
  return TButton(
    child: Text('左对齐带图标列表'),
    isBlock: true,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    size: TButtonSize.large,
    onPressed: () {
      TActionSheet(
        context,
        visible: true,
        description: '动作面板描述文字',
        align: TActionSheetAlign.left,
        items: _nums
            .map((e) => TActionSheetItem(
                  label: '选项$e',
                  icon: const Icon(TIcons.app),
                ))
            .toList(),
      );
    },
  );
}
