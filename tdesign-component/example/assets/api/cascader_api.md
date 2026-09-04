## API
### TCascader
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<List<Object?>>? | - | 选中路径变化回调；为 null 时禁用。 |
| options | List<TCascaderOption> | - | 根选项列表。 |
| placeholder | String | '请选择' | 未选择层级的占位文案。 |
| subtitles | List<String> | const [] | 各层级的次级标题。 组件按内部活动层级读取对应内容，因此调用方无需持有或控制层级状态。 |
| value | List<Object?> | - | 受控选中路径。 |
| variant | TCascaderVariant | TCascaderVariant.tab | 导航展示形态。 |


### TCascaderOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TCascaderOption> | const [] | 子选项。 |
| disabled | bool | false | 是否禁用。 |
| label | String | - | 展示文案。 |
| value | Object? | - | 选项值。 |


### TCascaderThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeTextStyle | TextStyle? | - | 当前活动导航文案样式。 |
| backgroundColor | Color? | - | 背景色。 |
| borderRadius | double? | - | 圆角。 |
| disabledTextStyle | TextStyle? | - | 禁用文案样式。 |
| dividerColor | Color? | - | 分隔线颜色。 |
| height | double? | - | 组件高度。 |
| indicatorColor | Color? | - | 末级选中图标颜色。 |
| navigationPadding | EdgeInsetsGeometry? | - | 导航区域内边距。 |
| textStyle | TextStyle? | - | 普通文案样式。 |


### TCascaderVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| step | 纵向步骤导航。 |
| tab | 横向标签导航。 |
