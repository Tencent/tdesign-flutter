## API

### TResult

用于展示成功、警告、失败或默认结果状态的内容块。

#### 主题配置

组件主题通过 `TResultThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TResultThemeData` 配置项。

#### 构造方法

##### TResult

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| description | String? | - | 描述文本，用于提供额外信息；为空时不占布局空间。 | 否 |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| status | TResultStatus | TResultStatus.info | 当前结果状态，决定默认图标、颜色和无障碍语义，默认为 `TResultStatus.info`。 | 否 |
| title | String | '' | 标题文本，显示结果的主要信息，默认标题为空字符串 | 否 |


### TResultStatus

结果状态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| info | TResultStatus | - | 默认信息状态。 | - |
| success | TResultStatus | - | 成功结果状态。 | - |
| warning | TResultStatus | - | 警告结果状态。 | - |
| error | TResultStatus | - | 错误结果状态。 | - |


### TResultThemeData

结果组件级 ThemeExtension

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| descriptionStyle | TextStyle? | - | 描述文字样式 未配置时使用 fontBodyMedium / textColorSecondary Token。 | 否 |
| iconSize | double? | - | 默认状态图标尺寸；自定义 icon 不使用该字段。 未配置时为 80 逻辑像素，必须大于 0。 | 否 |
| titleStyle | TextStyle? | - | 标题文字样式；默认使用 fontTitleMedium / textColorPrimary Token。 | 否 |
