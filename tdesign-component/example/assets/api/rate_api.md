## API

### TRate

严格受控的评分组件。

#### 主题配置

组件主题通过 `TRateThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TRateThemeData` 说明。

#### 构造方法

##### TRate

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| allowHalf | bool | false | 是否允许半星。 | 否 |
| count | int | 5 | 评分项数量，必须大于 0。 | 否 |
| icon | TRateIconBuilder? | - | 自定义评分图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;double&gt;? | - | 评分变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;double&gt;? | - | 结束交互时触发；指针取消时以当前受控值结束。 | 否 |
| onChangeStart | ValueChanged&lt;double&gt;? | - | 开始交互时触发；同一次指针或语义交互只触发一次。 | 否 |
| showValueIndicator | bool | true | 是否在整星点击、长按以及拖动评分时显示当前值提示。 默认为 true。半星点击的精确选择浮层不受此参数控制。 | 否 |
| texts | List&lt;String&gt;? | - | 各评分对应的辅助文案。 为 null 时不显示辅助文案；非 null 时显示。当当前评分 没有对应文案时，显示本地化的“未评分”。 | 否 |
| value | double | - | 受控评分值，必须位于 0 到 count 之间；父组件需在 onChanged 中更新该值。 | 是 |


### TRateThemeData

TRate 组件级 ThemeExtension。

#### 构造方法

##### TRateThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| iconGap | double? | - | 图标间距。 null 时使用 spacer Token。 | 否 |
| iconSize | double? | - | 图标尺寸。 null 时使用 spacer3 Token。 | 否 |
| inactiveStarColor | Color? | - | 未选中星标颜色。 | 否 |
| overlayBoxShadow | List&lt;BoxShadow&gt;? | - | 当前值提示与半星选择浮层阴影。 null 时使用 shadow1 Token；该 Token 缺失时无阴影。 | 否 |
| starColor | Color? | - | 选中星标颜色。 null 时使用 warningColor5 Token。 | 否 |
| textGap | double? | - | 图标与文案间距。 null 时使用 spacer2 Token。 | 否 |
| textStyle | TextStyle? | - | 文案样式。 | 否 |
| textWidth | double? | - | 文案宽度。 | 否 |


#### 实例方法

##### TRateThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| starColor | Color? | - | 字段含义：选中星标颜色。 null 时使用 warningColor5 Token。 调用时的空值行为见方法说明。 | 否 |
| inactiveStarColor | Color? | - | 字段含义：未选中星标颜色。 调用时的空值行为见方法说明。 | 否 |
| iconSize | double? | - | 字段含义：图标尺寸。 null 时使用 spacer3 Token。 调用时的空值行为见方法说明。 | 否 |
| iconGap | double? | - | 字段含义：图标间距。 null 时使用 spacer Token。 调用时的空值行为见方法说明。 | 否 |
| textWidth | double? | - | 字段含义：文案宽度。 调用时的空值行为见方法说明。 | 否 |
| textGap | double? | - | 字段含义：图标与文案间距。 null 时使用 spacer2 Token。 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：文案样式。 调用时的空值行为见方法说明。 | 否 |
| overlayBoxShadow | List&lt;BoxShadow&gt;? | - | 字段含义：当前值提示与半星选择浮层阴影。 null 时使用 shadow1 Token；该 Token 缺失时无阴影。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TRateThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TRateThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TRateThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TRateThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TRateIconBuilder

自定义评分图标构建器。

位置参数：`filled`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| filled | bool | - | 是否构建选中图标；半星由组件裁剪选中图标实现。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 指定选中状态的评分图标。 | - |
