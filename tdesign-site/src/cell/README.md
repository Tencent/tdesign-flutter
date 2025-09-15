---
title: Cell 单元格
description: 一行内容/功能的垂直排列方式。一行项目左侧为主要内容展示区域，右侧可增加更多操作内容。
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

[td_cell_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_cell_page.dart)

### 1 组件类型

单行单元格

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildSimple(BuildContext context) {
  // 可统一修改样式
  var style = TDCellStyle(context: context);
  return TDCellGroup(
    style: style,
    cells: [
      // 可单独修改样式
      TDCell(arrow: true, title: '单行标题', style: TDCellStyle.cellStyle(context)),
      TDCell(arrow: true, title: '单行标题', required: true, onClick: (cell) {
            print('单行标题');
          }),
      const TDCell(arrow: true, title: '单行标题', noteWidget: TDBadge(TDBadgeType.message, count: '8')),
      const TDCell(arrow: false, title: '单行标题', rightIconWidget: TDSwitch(isOn: true)),
      const TDCell(arrow: true, title: '单行标题', note: '辅助信息'),
      const TDCell(arrow: true, title: '单行标题', leftIcon: TDIcons.lock_on),
      const TDCell(arrow: false, title: '单行标题'),
    ],
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildSimple(BuildContext context) {
  // 可统一修改样式
  var style = TDCellStyle(context: context);
  return TDCellGroup(
    style: style,
    cells: [
      // 可单独修改样式
      TDCell(arrow: true, title: '单行标题', style: TDCellStyle.cellStyle(context)),
      TDCell(arrow: true, title: '单行标题', required: true, onClick: (cell) {
            print('单行标题');
          }),
      const TDCell(arrow: true, title: '单行标题', noteWidget: TDBadge(TDBadgeType.message, count: '8')),
      const TDCell(arrow: false, title: '单行标题', rightIconWidget: TDSwitch(isOn: true)),
      const TDCell(arrow: true, title: '单行标题', note: '辅助信息'),
      const TDCell(arrow: true, title: '单行标题', leftIcon: TDIcons.lock_on),
      const TDCell(arrow: false, title: '单行标题'),
    ],
  );
}</pre>

</td-code-block>
                

多行单元格

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildDesSimple(BuildContext context) {
  return const TDCellGroup(
    cells: [
      TDCell(arrow: true, title: '单行标题', description: '一段很长很长的内容文字'),
      TDCell(
          arrow: true,
          title: '单行标题',
          description: '一段很长很长的内容文字',
          required: true),
      TDCell(
          arrow: true,
          title: '单行标题',
          description: '一段很长很长的内容文字',
          noteWidget: TDBadge(TDBadgeType.message, count: '8')),
      TDCell(
          arrow: false,
          title: '单行标题',
          description: '一段很长很长的内容文字',
          rightIconWidget: TDSwitch(isOn: true)),
      TDCell(
          arrow: true, title: '单行标题', description: '一段很长很长的内容文字', note: '辅助信息'),
      TDCell(
          arrow: true,
          title: '单行标题',
          description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内',
          leftIcon: TDIcons.lock_on),
      TDCell(
          arrow: false,
          title: '单行标题',
          description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内'),
      TDCell(
          arrow: false,
          title: '多行高度不定，长文本自动换行，该选项的描述是一段很长的内容',
          description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内'),
      TDCell(
        arrow: true,
        title: '多行带头像',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/td_avatar_1.png'),
      ),
      // NetworkImage('https://tdesign.gtimg.com/mobile/demos/avatar1.png')),
      TDCell(
        arrow: true,
        title: '多行带图片',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/image.png'),
        imageCircle: 8,
      ),
    ],
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildDesSimple(BuildContext context) {
  return const TDCellGroup(
    cells: [
      TDCell(arrow: true, title: '单行标题', description: '一段很长很长的内容文字'),
      TDCell(
          arrow: true,
          title: '单行标题',
          description: '一段很长很长的内容文字',
          required: true),
      TDCell(
          arrow: true,
          title: '单行标题',
          description: '一段很长很长的内容文字',
          noteWidget: TDBadge(TDBadgeType.message, count: '8')),
      TDCell(
          arrow: false,
          title: '单行标题',
          description: '一段很长很长的内容文字',
          rightIconWidget: TDSwitch(isOn: true)),
      TDCell(
          arrow: true, title: '单行标题', description: '一段很长很长的内容文字', note: '辅助信息'),
      TDCell(
          arrow: true,
          title: '单行标题',
          description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内',
          leftIcon: TDIcons.lock_on),
      TDCell(
          arrow: false,
          title: '单行标题',
          description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内'),
      TDCell(
          arrow: false,
          title: '多行高度不定，长文本自动换行，该选项的描述是一段很长的内容',
          description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内'),
      TDCell(
        arrow: true,
        title: '多行带头像',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/td_avatar_1.png'),
      ),
      // NetworkImage('https://tdesign.gtimg.com/mobile/demos/avatar1.png')),
      TDCell(
        arrow: true,
        title: '多行带图片',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/image.png'),
        imageCircle: 8,
      ),
    ],
  );
}</pre>

</td-code-block>
                
### 1 组件样式

卡片单元格

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildCard(BuildContext context) {
  return const TDCellGroup(
    theme: TDCellGroupTheme.cardTheme,
    cells: [
      TDCell(arrow: true, title: '单行标题'),
      TDCell(arrow: true, title: '单行标题', required: true),
      TDCell(arrow: true, title: '单行标题'),
    ],
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildCard(BuildContext context) {
  return const TDCellGroup(
    theme: TDCellGroupTheme.cardTheme,
    cells: [
      TDCell(arrow: true, title: '单行标题'),
      TDCell(arrow: true, title: '单行标题', required: true),
      TDCell(arrow: true, title: '单行标题'),
    ],
  );
}</pre>

</td-code-block>
                


## API
### TDCellStyle
#### 简介
单元格组件样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext? | - | 传递context，会生成默认样式 |
| leftIconColor | Color? | - | 左侧图标颜色 |
| rightIconColor | Color? | - | 右侧图标颜色 |
| titleStyle | TextStyle? | - | 标题文字样式 |
| requiredStyle | TextStyle? | - | 必填星号文字样式 |
| descriptionStyle | TextStyle? | - | 内容描述文字样式 |
| noteStyle | TextStyle? | - | 说明文字样式 |
| arrowColor | Color? | - | 箭头颜色 |
| borderedColor | Color? | - | 单元格边框颜色 |
| groupBorderedColor | Color? | - | 单元格组边框颜色 |
| backgroundColor | Color? | - | 默认状态背景颜色 |
| clickBackgroundColor | Color? | - | 点击状态背景颜色 |
| groupTitleStyle | TextStyle? | - | 单元组标题文字样式 |
| padding | EdgeInsets? | - | 单元格内边距 |
| cardBorderRadius | BorderRadius? | - | 卡片模式边框圆角 |
| cardPadding | EdgeInsets? | - | 卡片模式内边距 |
| titlePadding | EdgeInsets? | - | 单元格组标题内边距 |
| titleBackgroundColor | Color? | - | 单元格组标题背景颜色 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDCellStyle.cellStyle  | 生成单元格默认样式 |

```
```
 ### TDCellGroup
#### 简介
单元格组组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| bordered | bool? | false | 是否显示组边框 |
| theme | TDCellGroupTheme? | TDCellGroupTheme.defaultTheme | 单元格组风格。可选项：default/card |
| title | String? | - | 单元格组标题 |
| cells | List<TDCell> | - | 单元格列表 |
| builder | CellBuilder? | - | cell构建器，可自定义cell父组件，如Dismissible |
| style | TDCellStyle? | - | 自定义样式 |
| titleWidget | Widget? | - | 单元格组标题组件 |
| scrollable | bool? | false | 可滚动 |
| isShowLastBordered | bool? | false | 是否显示最后一个cell的下边框 |

```
```
 ### TDCell
#### 简介
单元格组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| align | TDCellAlign? | TDCellAlign.middle | 内容的对齐方式，默认居中对齐。可选项：top/middle/bottom |
| arrow | bool? | false | 是否显示右侧箭头 |
| bordered | bool? | true | 是否显示下边框，仅在TDCellGroup组件下起作用 |
| description | String? | - | 下方内容描述文字 |
| descriptionWidget | Widget? | - | 下方内容描述组件 |
| hover | bool? | true | 是否开启点击反馈 |
| image | ImageProvider? | - | 主图 |
| imageSize | double? | - | 主图尺寸 |
| imageWidget | Widget? | - | 主图组件 |
| leftIcon | IconData? | - | 左侧图标，出现在单元格标题的左侧 |
| leftIconWidget | Widget? | - | 左侧图标组件 |
| note | String? | - | 和标题同行的说明文字 |
| noteWidget | Widget? | - | 说明文字组件 |
| required | bool? | false | 是否显示表单必填星号 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| onClick | TDCellClick? | - | 点击事件 |
| onLongPress | TDCellClick? | - | 长按事件 |
| style | TDCellStyle? | - | 自定义样式 |
| rightIcon | IconData? | - | 最右侧图标 |
| rightIconWidget | Widget? | - | 最右侧图标组件 |
| disabled | bool? | false | 禁用 |
| imageCircle | double? | 50 | 主图圆角，默认50（圆形） |
| showBottomBorder | bool? | false | 是否显示下边框（建议TDCellGroup组件下false，避免与bordered重叠） |
| height | double? | - | 高度 |


  