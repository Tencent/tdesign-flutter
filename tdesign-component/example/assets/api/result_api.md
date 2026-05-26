## API
### TResult
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| description | String? | - | 描述文本，用于提供额外信息 |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| theme | TResultTheme | TResultTheme.defaultTheme | 主题样式，默认主题样式为defaultTheme |
| title | String | '' | 标题文本，显示结果的主要信息，默认标题为空字符串 |
| titleStyle | TextStyle? | - | 自定义字体样式，用于设置标题文本的样式 |


### TResultTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | - |
| success | - |
| warning | - |
| error | - |
