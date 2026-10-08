## API

### TCascader

严格受控的级联选择器。

#### 构造方法

##### TCascader

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;List&lt;Object?&gt;&gt;? | - | 选中路径变化回调；为 null 时禁用。 分支点击只发出候选路径；调用方需回写 `value`，组件才会推进活动层级。 | 否 |
| options | List&lt;TCascaderOption&gt; | - | 根选项列表。 | 是 |
| placeholder | String | '请选择' | 未选择层级的占位文案。 | 否 |
| subtitles | List&lt;String&gt; | const [] | 各层级的次级标题。 组件按内部活动层级读取对应内容，因此调用方无需持有或控制层级状态； 列表没有对应层级或对应内容为空时不显示次级标题。 | 否 |
| value | List&lt;Object?&gt; | - | 受控选中路径。 | 是 |
| variant | TCascaderVariant | TCascaderVariant.tab | 导航展示形态。 | 否 |


### TCascaderOption

级联选项。

`children` 应按 Flutter Widget 配置的不可变约定使用。数据变化时请创建新的
`TCascaderOption` 和列表，不要原地修改已有列表。

#### 构造方法

##### TCascaderOption

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;TCascaderOption&gt; | const [] | 子选项。 | 否 |
| disabled | bool | false | 是否禁用。 | 否 |
| label | String | - | 展示文案。 | 是 |
| value | Object? | - | 选项值。 | 是 |


### TCascaderThemeData

TCascader 组件级 ThemeExtension。

#### 构造方法

##### TCascaderThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| activeTextStyle | TextStyle? | - | 当前活动导航及已选选项文案样式。 | 否 |
| backgroundColor | Color? | - | 背景色。 未配置时使用 bgColorContainer Token。 | 否 |
| borderRadius | double? | - | 圆角。 未配置时使用 radiusDefault Token。 | 否 |
| disabledTextStyle | TextStyle? | - | 禁用文案样式。 | 否 |
| dividerColor | Color? | - | 分隔线颜色。 未配置时使用 componentStroke Token。 | 否 |
| height | double? | - | 组件高度。 未配置时为 360 逻辑像素。 | 否 |
| indicatorColor | Color? | - | 末级选中图标颜色。 未配置时使用 brandColor Token。 | 否 |
| navigationPadding | EdgeInsetsGeometry? | - | 导航区域内边距。 | 否 |
| textStyle | TextStyle? | - | 普通文案样式。 | 否 |


#### 实例方法

##### TCascaderThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| height | double? | - | 字段含义：组件高度。 未配置时为 360 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| backgroundColor | Color? | - | 字段含义：背景色。 未配置时使用 bgColorContainer Token。 调用时的空值行为见方法说明。 | 否 |
| borderRadius | double? | - | 字段含义：圆角。 未配置时使用 radiusDefault Token。 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：普通文案样式。 调用时的空值行为见方法说明。 | 否 |
| activeTextStyle | TextStyle? | - | 字段含义：当前活动导航及已选选项文案样式。 调用时的空值行为见方法说明。 | 否 |
| disabledTextStyle | TextStyle? | - | 字段含义：禁用文案样式。 调用时的空值行为见方法说明。 | 否 |
| indicatorColor | Color? | - | 字段含义：末级选中图标颜色。 未配置时使用 brandColor Token。 调用时的空值行为见方法说明。 | 否 |
| navigationPadding | EdgeInsetsGeometry? | - | 字段含义：导航区域内边距。 调用时的空值行为见方法说明。 | 否 |
| dividerColor | Color? | - | 字段含义：分隔线颜色。 未配置时使用 componentStroke Token。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TCascaderThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TCascaderThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TCascaderThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TCascaderThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TCascaderVariant

级联导航展示形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| step | TCascaderVariant | - | 纵向步骤导航。 | - |
| tab | TCascaderVariant | - | 横向标签导航。 | - |
