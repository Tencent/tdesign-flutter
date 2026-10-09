## API

### TCell

单元格组件。

#### 构造方法

##### TCell

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

单元格组。

#### 构造方法

##### TCellGroup

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| builder | TCellGroupBuilder? | - | 自定义单元格外层构建器。 | 否 |
| cells | List&lt;TCell&gt; | - | 单元格列表。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| scrollable | bool | false | 是否使用可滚动列表。 | 否 |
| title | Widget? | - | 组标题。 | 否 |
| variant | TCellGroupVariant? | - | 组视觉形态；未设置时为 `TCellGroupVariant.standard`。 | 否 |


### TCellThemeData

Cell 与 CellGroup 的组件级 ThemeExtension。

仅保存视觉和布局默认值，不保存内容、回调或列表数据。
文字样式按字段覆盖全局 Token 派生的组件默认值；未配置字段保持默认。

#### 构造方法

##### TCellThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| titleStyle | TextStyle? | - | 字段含义：标题文字样式。 调用时的空值行为见方法说明。 | 否 |
| requiredStyle | TextStyle? | - | 字段含义：必填标记样式。 调用时的空值行为见方法说明。 | 否 |
| subtitleStyle | TextStyle? | - | 字段含义：副标题文字样式。 调用时的空值行为见方法说明。 | 否 |
| noteStyle | TextStyle? | - | 字段含义：右侧说明文字样式。 调用时的空值行为见方法说明。 | 否 |
| groupTitleStyle | TextStyle? | - | 字段含义：单元格组标题样式。 调用时的空值行为见方法说明。 | 否 |
| arrowColor | Color? | - | 字段含义：箭头颜色。 调用时的空值行为见方法说明。 | 否 |
| borderColor | Color? | - | 字段含义：分隔线颜色。 调用时的空值行为见方法说明。 | 否 |
| groupBorderColor | Color? | - | 字段含义：单元格组边框颜色。 调用时的空值行为见方法说明。 | 否 |
| backgroundColor | Color? | - | 字段含义：默认背景色。 调用时的空值行为见方法说明。 | 否 |
| pressedColor | Color? | - | 字段含义：按压背景色。 调用时的空值行为见方法说明。 | 否 |
| padding | EdgeInsetsGeometry? | - | 字段含义：单元格内边距。 调用时的空值行为见方法说明。 | 否 |
| cardBorderRadius | BorderRadius? | - | 字段含义：卡片组圆角。 调用时的空值行为见方法说明。 | 否 |
| cardPadding | EdgeInsetsGeometry? | - | 字段含义：卡片组内边距。 调用时的空值行为见方法说明。 | 否 |
| titlePadding | EdgeInsetsGeometry? | - | 字段含义：组标题内边距。 调用时的空值行为见方法说明。 | 否 |
| showBottomBorder | bool? | - | 字段含义：是否显示 Cell 底部分隔线。 调用时的空值行为见方法说明。 | 否 |
| height | double? | - | 字段含义：Cell 固定高度。 调用时的空值行为见方法说明。 | 否 |
| groupBordered | bool? | - | 字段含义：是否显示组外边框。 调用时的空值行为见方法说明。 | 否 |
| showLastDivider | bool? | - | 字段含义：是否显示最后一个 Cell 后的分隔线。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TCellThemeData | - | - | - |


##### TCellThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TCellThemeData? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TCellThemeData | - | - | - |


### TCellAlign

单元格内容垂直对齐方式。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| top | TCellAlign | - | 顶部对齐。 | - |
| center | TCellAlign | - | 居中对齐。 | - |
| bottom | TCellAlign | - | 底部对齐。 | - |


### TCellGroupVariant

单元格组视觉形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| standard | TCellGroupVariant | - | 通栏形态。 | - |
| card | TCellGroupVariant | - | 卡片形态。 | - |


### TCellGroupBuilder

单元格包装构建器。

位置参数：`context, cell, index`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| cell | TCell | - | - | 是 |
| index | int | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |
