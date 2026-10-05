## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 链接内容，通常为 `Text`。 |
| colorPreset | TLinkColorPreset? | - | 内置配色预设；未设置时默认为 `TLinkColorPreset.defaultTheme`。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调；为 null 时链接为禁用态。 |
| prefixIcon | Widget? | - | 前置图标；为 null 时不占位。 |
| semanticLabel | String? | - | 无障碍语义标签。 |
| size | TLinkSize? | - | 链接尺寸；未设置时默认为 `TLinkSize.medium`。 |
| suffixIcon | Widget? | - | 后置图标；为 null 时不占位。 |
| tooltip | String? | - | 鼠标悬浮提示。 |
| underline | bool? | - | 是否显示下划线；未设置时为 false。 |


### TLinkThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| iconGap | double? | - | 前/后图标与内容之间的间距。 |
| iconSize | double? | - | 图标尺寸。 |
| textStyle | TextStyle? | - | 链接文字样式；字号、行高与字重默认由实例尺寸对应 Token 提供。 |


### TLinkColorPreset
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | 品牌主色链接。 |
| defaultTheme | 默认文本色链接。 |
| danger | 危险操作链接。 |
| warning | 警告提示链接。 |
| success | 成功状态链接。 |


### TLinkSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸链接。 |
| medium | 中尺寸链接。 |
| large | 大尺寸链接。 |
