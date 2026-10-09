## API

### TLink

文字超链接用于跳转一个新页面，如当前项目跳转、友情链接等。

下划线、前置图标和后置图标可独立组合；路由行为由 `onPressed` 与 Flutter
Navigator / Router 组合。

#### 主题配置

组件主题通过 `TLinkThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TLinkThemeData` 配置项。

#### 构造方法

##### TLink

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 链接内容，通常为 `Text`。 | 否 |
| colorPreset | TLinkColorPreset? | - | 内置配色预设；未设置时默认为 `TLinkColorPreset.defaultTheme`。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onPressed | VoidCallback? | - | 点击回调；为 null 时链接为禁用态。 | 否 |
| prefixIcon | Widget? | - | 前置图标；为 null 时不占位。 | 否 |
| semanticLabel | String? | - | 无障碍语义标签。 | 否 |
| size | TLinkSize? | - | 链接尺寸；未设置时默认为 `TLinkSize.medium`。 | 否 |
| suffixIcon | Widget? | - | 后置图标；为 null 时不占位。 | 否 |
| tooltip | String? | - | 鼠标悬浮提示。 | 否 |
| underline | bool? | - | 是否显示下划线；未设置时为 false。 | 否 |


### TLinkColorPreset

链接内置配色预设，不是 Material ColorScheme。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| primary | TLinkColorPreset | - | 品牌主色链接。 | - |
| defaultTheme | TLinkColorPreset | - | 默认文本色链接。 | - |
| danger | TLinkColorPreset | - | 危险操作链接。 | - |
| warning | TLinkColorPreset | - | 警告提示链接。 | - |
| success | TLinkColorPreset | - | 成功状态链接。 | - |


### TLinkSize

链接尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TLinkSize | - | 小尺寸链接。 | - |
| medium | TLinkSize | - | 中尺寸链接。 | - |
| large | TLinkSize | - | 大尺寸链接。 | - |


### TLinkThemeData

TLink 组件级主题。

通过 Theme 子树注入链接字号样式、图标尺寸和间距等具体视觉值。
尺寸档位、配色预设和下划线选择仅由 `TLink` 实例控制。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| iconGap | double? | - | 前/后图标与内容之间的间距；未设置时为 4 逻辑像素。 | 否 |
| iconSize | double? | - | 图标尺寸；未设置时小、中、大尺寸分别为 14、16、18 逻辑像素。 | 否 |
| textStyle | TextStyle? | - | 链接文字样式；字号、行高与字重默认由实例尺寸对应 Token 提供。 | 否 |
