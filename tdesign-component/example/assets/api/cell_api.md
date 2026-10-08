## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TCell
#### 简介
单元格组件。

#### 声明

```dart
class TCell extends StatefulWidget
```

#### 默认构造方法


```dart
const TCell({
  this.title,
  this.subtitle,
  this.prefix,
  this.image,
  this.note,
  this.trailing,
  this.arrow = false,
  this.required = false,
  this.align,
  this.enableFeedback = true,
  this.onTap,
  this.onLongPress,
  super.key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| align | TCellAlign? | - | 内容垂直对齐方式。 | 否 |
| arrow | bool | false | 是否显示右箭头。 | 否 |
| enableFeedback | bool | true | 点击时是否显示背景反馈。 | 否 |
| image | Widget? | - | 单元格左侧图片区。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| note | Widget? | - | 右侧说明内容。 | 否 |
| onLongPress | GestureLongPressCallback? | - | 长按回调。 | 否 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击行为。 | 否 |
| prefix | Widget? | - | 标题左侧内容。 | 否 |
| required | bool | false | 是否显示必填标记。 | 否 |
| subtitle | Widget? | - | 副标题区。 | 否 |
| title | Widget? | - | 标题区。 | 否 |
| trailing | Widget? | - | 最右侧内容。 | 否 |


### TCellGroup
#### 简介
单元格组。

#### 声明

```dart
class TCellGroup extends StatelessWidget
```

#### 默认构造方法


```dart
const TCellGroup({
  required this.cells,
  this.title,
  this.variant,
  this.builder,
  this.scrollable = false,
  super.key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| builder | TCellGroupBuilder? | - | 自定义单元格外层构建器。 | 否 |
| cells | List&lt;TCell&gt; | - | 单元格列表。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| scrollable | bool | false | 是否使用可滚动列表。 | 否 |
| title | Widget? | - | 组标题。 | 否 |
| variant | TCellGroupVariant? | - | 组视觉形态；未设置时为 `TCellGroupVariant.standard`。 | 否 |


### TCellThemeData
#### 简介
Cell 与 CellGroup 的组件级 ThemeExtension。
仅保存视觉和布局默认值，不保存内容、回调或列表数据。
文字样式按字段覆盖全局 Token 派生的组件默认值；未配置字段保持默认。

#### 声明

```dart
class TCellThemeData extends ThemeExtension<TCellThemeData>
```

#### 默认构造方法


```dart
const TCellThemeData({
  this.titleStyle,
  this.requiredStyle,
  this.subtitleStyle,
  this.noteStyle,
  this.groupTitleStyle,
  this.arrowColor,
  this.borderColor,
  this.groupBorderColor,
  this.backgroundColor,
  this.pressedColor,
  this.padding,
  this.cardBorderRadius,
  this.cardPadding,
  this.titlePadding,
  this.showBottomBorder,
  this.height,
  this.groupBordered,
  this.showLastDivider,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| arrowColor | Color? | - | 箭头颜色。 | 否 |
| backgroundColor | Color? | - | 默认背景色。 | 否 |
| borderColor | Color? | - | 分隔线颜色。 | 否 |
| cardBorderRadius | BorderRadius? | - | 卡片组圆角。 | 否 |
| cardPadding | EdgeInsetsGeometry? | - | 卡片组内边距。 | 否 |
| groupBorderColor | Color? | - | 单元格组边框颜色。 | 否 |
| groupBordered | bool? | - | 是否显示组外边框。 | 否 |
| groupTitleStyle | TextStyle? | - | 单元格组标题样式。 | 否 |
| height | double? | - | Cell 固定高度。 | 否 |
| noteStyle | TextStyle? | - | 右侧说明文字样式。 | 否 |
| padding | EdgeInsetsGeometry? | - | 单元格内边距。 | 否 |
| pressedColor | Color? | - | 按压背景色。 | 否 |
| requiredStyle | TextStyle? | - | 必填标记样式。 | 否 |
| showBottomBorder | bool? | - | 是否显示 Cell 底部分隔线。 | 否 |
| showLastDivider | bool? | - | 是否显示最后一个 Cell 后的分隔线。 | 否 |
| subtitleStyle | TextStyle? | - | 副标题文字样式。 | 否 |
| titlePadding | EdgeInsetsGeometry? | - | 组标题内边距。 | 否 |
| titleStyle | TextStyle? | - | 标题文字样式。 | 否 |


#### 实例方法

##### TCellThemeData.copyWith

```dart
TCellThemeData copyWith({
  TextStyle? titleStyle,
  TextStyle? requiredStyle,
  TextStyle? subtitleStyle,
  TextStyle? noteStyle,
  TextStyle? groupTitleStyle,
  Color? arrowColor,
  Color? borderColor,
  Color? groupBorderColor,
  Color? backgroundColor,
  Color? pressedColor,
  EdgeInsetsGeometry? padding,
  BorderRadius? cardBorderRadius,
  EdgeInsetsGeometry? cardPadding,
  EdgeInsetsGeometry? titlePadding,
  bool? showBottomBorder,
  double? height,
  bool? groupBordered,
  bool? showLastDivider,
})
```


返回类型：`TCellThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| titleStyle | TextStyle? | - | 标题文字样式。 | 否 |
| requiredStyle | TextStyle? | - | 必填标记样式。 | 否 |
| subtitleStyle | TextStyle? | - | 副标题文字样式。 | 否 |
| noteStyle | TextStyle? | - | 右侧说明文字样式。 | 否 |
| groupTitleStyle | TextStyle? | - | 单元格组标题样式。 | 否 |
| arrowColor | Color? | - | 箭头颜色。 | 否 |
| borderColor | Color? | - | 分隔线颜色。 | 否 |
| groupBorderColor | Color? | - | 单元格组边框颜色。 | 否 |
| backgroundColor | Color? | - | 默认背景色。 | 否 |
| pressedColor | Color? | - | 按压背景色。 | 否 |
| padding | EdgeInsetsGeometry? | - | 单元格内边距。 | 否 |
| cardBorderRadius | BorderRadius? | - | 卡片组圆角。 | 否 |
| cardPadding | EdgeInsetsGeometry? | - | 卡片组内边距。 | 否 |
| titlePadding | EdgeInsetsGeometry? | - | 组标题内边距。 | 否 |
| showBottomBorder | bool? | - | 是否显示 Cell 底部分隔线。 | 否 |
| height | double? | - | Cell 固定高度。 | 否 |
| groupBordered | bool? | - | 是否显示组外边框。 | 否 |
| showLastDivider | bool? | - | 是否显示最后一个 Cell 后的分隔线。 | 否 |


##### TCellThemeData.lerp

```dart
TCellThemeData lerp(TCellThemeData? other, double t)
```


返回类型：`TCellThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TCellThemeData? | - | - | 是 |
| t | double | - | - | 是 |


### TCellAlign
#### 简介
单元格内容垂直对齐方式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| top | 顶部对齐。 |
| center | 居中对齐。 |
| bottom | 底部对齐。 |


### TCellGroupVariant
#### 简介
单元格组视觉形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| standard | 通栏形态。 |
| card | 卡片形态。 |


### TCellGroupBuilder
#### 简介
单元格包装构建器。
#### 类型定义

```dart
typedef TCellGroupBuilder = Widget Function(BuildContext context, TCell cell, int index);
```
