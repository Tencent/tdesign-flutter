## API
### TResult
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| subtitle | String? | - | 描述文本，用于提供额外信息 |
| title | String | '' | 标题文本，显示结果的主要信息，默认标题为空字符串 |
| variant | TResultVariant | TResultVariant.defaultTheme | 结果形态 |


### TResultThemeData
#### 简介
结果组件级 ThemeExtension
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| titleStyle | TextStyle? | - | 标题文字样式 |


### TResultVariant
#### 简介
结果形态
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认结果状态。 |
| success | 成功结果状态。 |
| warning | 警告结果状态。 |
| error | 错误结果状态。 |
