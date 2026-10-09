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


### TCascaderVariant

级联导航展示形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| step | TCascaderVariant | - | 纵向步骤导航。 | - |
| tab | TCascaderVariant | - | 横向标签导航。 | - |


### TCascaderThemeData

TCascader 组件级 ThemeExtension。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| activeTextStyle | TextStyle? | - | 当前活动导航及已选选项文案样式。 | 否 |
| backgroundColor | Color? | - | 背景色。 未配置时使用 bgColorContainer Token。 | 否 |
| borderRadius | double? | - | 圆角。 未配置时使用 radiusDefault Token。 | 否 |
| disabledTextStyle | TextStyle? | - | 禁用文案样式。 | 否 |
| dividerColor | Color? | - | 分隔线颜色。 未配置时使用 componentStroke Token。 | 否 |
| height | double? | - | 组件高度。 未配置时为 360 逻辑像素。 | 否 |
| indicatorColor | Color? | - | 末级选中图标颜色。 未配置时使用 brandColor Token。 | 否 |
| navigationPadding | EdgeInsetsGeometry? | - | 导航区域内边距。 null 时 step 形态左右使用 spacer2、上方为 0、下方为 4；tab 形态不增加导航内边距。 | 否 |
| textStyle | TextStyle? | - | 普通文案样式。 | 否 |
