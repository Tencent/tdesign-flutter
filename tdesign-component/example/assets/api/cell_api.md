## API
### TCell
#### 简介
单元格组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TCellAlign? | - | 内容垂直对齐方式。 |
| arrow | bool | false | 是否显示右箭头。 |
| enableFeedback | bool | true | 点击时是否显示背景反馈。 |
| image | Widget? | - | 单元格左侧图片区。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| note | Widget? | - | 右侧说明内容。 |
| onLongPress | GestureLongPressCallback? | - | 长按回调。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击行为。 |
| prefix | Widget? | - | 标题左侧内容。 |
| required | bool | false | 是否显示必填标记。 |
| subtitle | Widget? | - | 副标题区。 |
| title | Widget? | - | 标题区。 |
| trailing | Widget? | - | 最右侧内容。 |


### TCellGroup
#### 简介
单元格组。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builder | TCellGroupBuilder? | - | 自定义单元格外层构建器。 |
| cells | List<TCell> | - | 单元格列表。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| scrollable | bool | false | 是否使用可滚动列表。 |
| title | Widget? | - | 组标题。 |
| variant | TCellGroupVariant? | - | 组视觉形态；未设置时为 `TCellGroupVariant.standard`。 |


### TCellThemeData
#### 简介
Cell 与 CellGroup 的组件级 ThemeExtension。
仅保存视觉和布局默认值，不保存内容、回调或列表数据。
文字样式按字段覆盖全局 Token 派生的组件默认值；未配置字段保持默认。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowColor | Color? | - | 箭头颜色。 |
| backgroundColor | Color? | - | 默认背景色。 |
| borderColor | Color? | - | 分隔线颜色。 |
| cardBorderRadius | BorderRadius? | - | 卡片组圆角。 |
| cardPadding | EdgeInsetsGeometry? | - | 卡片组内边距。 |
| groupBorderColor | Color? | - | 单元格组边框颜色。 |
| groupBordered | bool? | - | 是否显示组外边框。 |
| groupTitleStyle | TextStyle? | - | 单元格组标题样式。 |
| height | double? | - | Cell 固定高度。 |
| noteStyle | TextStyle? | - | 右侧说明文字样式。 |
| padding | EdgeInsetsGeometry? | - | 单元格内边距。 |
| pressedColor | Color? | - | 按压背景色。 |
| requiredStyle | TextStyle? | - | 必填标记样式。 |
| showBottomBorder | bool? | - | 是否显示 Cell 底部分隔线。 |
| showLastDivider | bool? | - | 是否显示最后一个 Cell 后的分隔线。 |
| subtitleStyle | TextStyle? | - | 副标题文字样式。 |
| titlePadding | EdgeInsetsGeometry? | - | 组标题内边距。 |
| titleStyle | TextStyle? | - | 标题文字样式。 |


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
