---
title: ActionSheet 动作面板
description: 从底部弹出的模态框，提供和当前场景相关的操作动作，也支持提供信息输入和描述。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_action_sheet_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_action_sheet_page.dart)

### 1 组件类型

列表型动作面板

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

宫格型动作面板

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                
### 1 组件状态

列表型选项状态

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                
### 1 组件样式

列表型对齐方式

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                


## API
### TDActionSheet
#### 简介
动作面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | context | 上下文 |
| align | TDActionSheetAlign | TDActionSheetAlign.center | 对齐方式 |
| cancelText | String | '取消' | 取消按钮的文本 |
| count | int | 8 | 每页显示的项目数 |
| rows | int | 2 | 显示的行数 |
| itemHeight | double | 96.0 | 项目的行高 |
| itemMinWidth | double | 80.0 | 项目的最小宽度 |
| description | String? | - | 描述文本 |
| items | List<TDActionSheetItem> | - | ActionSheet的项目列表 |
| showCancel | bool | true | 是否显示取消按钮 |
| showPagination | bool | false | 是否显示分页 |
| scrollable | bool | false | 是否可以横向滚动 |
| theme | TDActionSheetTheme | TDActionSheetTheme.list | 主题样式 |
| visible | bool | false | 是否立即显示 |
| onCancel | VoidCallback? | - | 取消按钮的回调函数 |
| onClose | VoidCallback? | - | 关闭时的回调函数 |
| onSelected | TDActionSheetItemCallback? | - | 选择项目时的回调函数 |
| showOverlay | bool | true | 是否显示遮罩层 |
| closeOnOverlayClick | bool | true | 点击蒙层时是否关闭 |
| useSafeArea | bool | true | 使用安全区域 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showListActionSheet |  |   required BuildContext context,  required List<TDActionSheetItem> items,  TDActionSheetAlign align,  String cancelText,  bool showCancel,  VoidCallback? onCancel,  TDActionSheetItemCallback? onSelected,  bool showOverlay,  bool closeOnOverlayClick,  VoidCallback? onClose,  bool useSafeArea, | 显示列表类型面板 |
| showGridActionSheet |  |   required BuildContext context,  required List<TDActionSheetItem> items,  TDActionSheetAlign align,  String cancelText,  bool showCancel,  TDActionSheetItemCallback? onSelected,  bool showOverlay,  bool closeOnOverlayClick,  int count,  int rows,  double itemHeight,  double itemMinWidth,  bool scrollable,  bool showPagination,  VoidCallback? onCancel,  String? description,  VoidCallback? onClose,  bool useSafeArea, | 显示宫格类型面板 |
| showGroupActionSheet |  |   required BuildContext context,  required List<TDActionSheetItem> items,  TDActionSheetAlign align,  String cancelText,  bool showCancel,  TDActionSheetItemCallback? onSelected,  bool showOverlay,  bool closeOnOverlayClick,  double itemHeight,  double itemMinWidth,  VoidCallback? onCancel,  VoidCallback? onClose,  bool useSafeArea, | 显示分组类型面板 |

```
```
 ### TDActionSheetItem
#### 简介
动作面板项目
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String | - | 标提 |
| textStyle | TextStyle? | - | 标题样式 |
| icon | Widget? | - | 图标 |
| badge | TDBadge? | - | 角标 |
| disabled | bool | false | 是否禁用 |
| iconSize | double? | - | 图标大小 |
| group | String? | - | 分组，用于带描述多行滚动宫格 |


  