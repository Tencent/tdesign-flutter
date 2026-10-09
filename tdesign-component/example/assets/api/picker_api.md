## API

### TPicker

严格受控的滚轮选择器。

独立多列使用 `TPickerColumns`，层级联动使用 `TPickerLinked`。弹层和确认
操作由调用方组合，组件本身只负责滚轮选择。标准弹层使用 `TPickerPopup.show`。

#### 构造方法

##### TPicker

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| itemBuilder | TPickerItemBuilder? | - | 自定义选项构建器。 | 否 |
| items | TPickerItems | - | 数据源。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;TPickerValue&gt;? | - | 值变化回调；为 null 时禁用。 | 否 |
| onColumnScrollEnd | void Function(int columnIndex, TPickerValue value)? | - | 某列滚动结束回调。 | 否 |
| value | List&lt;Object?&gt; | - | 各列受控值。 | 是 |


### TPickerPopup

Picker 专用弹层入口。

`TPicker` 与 `TDateTimePicker` 的滚轮仍是可独立组合的纯面板；需要设计稿中的
底部弹层时使用 `show`。该入口统一为标准 `TPopupHeader` 和完整滚轮视窗预留
高度，避免调用方按通用 Popup 默认高度拼装后压缩或裁切滚轮。

#### 静态方法

##### TPickerPopup.show

位置参数：`context`


打开包含标准头部和 Picker 滚轮的底部弹层。

弹层总高为当前 `TPickerThemeData.height`（默认 200）加
`TPopupHeader.headerHeight`（58）。`child` 通常为 `TPicker` 或
`TDateTimePicker`，其受控值、确认和取消状态仍由调用方管理。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| child | Widget | - | Picker 滚轮面板。 | 是 |
| headerBuilder | TPickerPopupHeaderBuilder | - | 标准 58px 头部构建器。 | 是 |
| inset | TPopupBottomInset? | - | 底部弹层的边缘缩进。 | 否 |
| radius | double? | - | 顶部圆角；null 时使用 Popup 主题或 TDesign 默认值。 | 否 |
| backgroundColor | Color? | - | 面板背景色；null 时使用 Popup 主题或容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为；null 时沿用 Popup 默认值。 | 否 |
| destroyOnClose | bool | false | 关闭后是否销毁弹层内容，默认 false。 | 否 |
| animationDuration | Duration? | - | 打开和关闭动画时长。 | 否 |
| onOpened | VoidCallback? | - | 打开动画完成回调。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画完成回调。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 弹层显隐变化回调。 | 否 |
| useSafeArea | bool | false | 是否避让底部安全区，默认 false。 | 否 |
| navigatorContext | BuildContext? | - | 可选的 Navigator 上下文；默认使用 `context`。 | 否 |
| useRootNavigator | bool | false | 是否使用根 Navigator，默认 false。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupHandle | - | - | - |


### TPickerOption

选择器选项。

选项及 `children` 按不可变数据使用；更新时创建新选项和新列表。

#### 构造方法

##### TPickerOption

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;TPickerOption&gt; | const [] | 联动模式下的子选项。 | 否 |
| disabled | bool | false | 是否禁用。 | 否 |
| label | String | - | 展示文案。 | 是 |
| value | Object? | - | 业务值。 | 是 |


### TPickerValue

各列当前选中项的只读快照。

组件回调产生的列表不可修改。手工构造时，调用方须提供不可变列表；
const 构造不会复制或冻结传入的 `selectedOptions` 和 `indexes`。

#### 构造方法

##### TPickerValue

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| indexes | List&lt;int&gt; | - | 各列选中索引。 | 是 |
| selectedOptions | List&lt;TPickerOption&gt; | - | 各列选中的完整选项。 | 是 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| labels | List&lt;String&gt; | - | 各列展示文案。 | - |
| values | List&lt;Object?&gt; | - | 各列业务值。 | - |


### TPickerColumns

互不联动的多列数据源。

`columns` 及每列列表不得原地修改；变更时传入新的数据源和列表。

#### 构造方法

##### TPickerColumns

位置参数：`columns`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| columns | List&lt;List&lt;TPickerOption&gt;&gt; | - | 各列选项。 | 是 |


### TPickerLinked

由 `TPickerOption.children` 描述层级关系的联动数据源。

`options` 及所有子选项列表不得原地修改；变更时创建新的数据源。

#### 构造方法

##### TPickerLinked

位置参数：`options`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| options | List&lt;TPickerOption&gt; | - | 根选项。 | 是 |


### TPickerPopupHeaderBuilder

构建 Picker 标准弹层头部。

返回类型限定为 `TPopupHeader`，使弹层尺寸计算与实际头部的
`TPopupHeader.headerHeight` 保持一致。

位置参数：`context, close`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| close | VoidCallback | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupHeader | - | - | - |


### TPickerItemBuilder

选择器子项构建器。

位置参数：`context, option, columnIndex, itemIndex, distance`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| option | TPickerOption | - | - | 是 |
| columnIndex | int | - | - | 是 |
| itemIndex | int | - | - | 是 |
| distance | double | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget? | - | - | - |
