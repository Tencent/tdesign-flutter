## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TLink
#### 简介
文字超链接用于跳转一个新页面，如当前项目跳转、友情链接等。
下划线、前置图标和后置图标可独立组合；路由行为由 `onPressed` 与 Flutter
Navigator / Router 组合。
### 主题配置
组件主题通过 `TLinkThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TLinkThemeData` 说明。

#### 声明

```dart
class TLink extends StatelessWidget
```

#### 默认构造方法


```dart
const TLink({
  super.key,
  this.child,
  this.prefixIcon,
  this.suffixIcon,
  this.underline,
  this.colorPreset,
  this.size,
  this.onPressed,
  this.semanticLabel,
  this.tooltip,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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


### TLinkThemeData
#### 简介
TLink 组件级主题。
通过 Theme 子树注入链接字号样式、图标尺寸和间距等具体视觉值。
尺寸档位、配色预设和下划线选择仅由 `TLink` 实例控制。

#### 声明

```dart
class TLinkThemeData extends ThemeExtension<TLinkThemeData>
```

#### 默认构造方法


```dart
const TLinkThemeData({this.textStyle, this.iconSize, this.iconGap})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| iconGap | double? | - | 前/后图标与内容之间的间距；未设置时为 4 逻辑像素。 | 否 |
| iconSize | double? | - | 图标尺寸；未设置时小、中、大尺寸分别为 14、16、18 逻辑像素。 | 否 |
| textStyle | TextStyle? | - | 链接文字样式；字号、行高与字重默认由实例尺寸对应 Token 提供。 | 否 |


#### 实例方法

##### TLinkThemeData.copyWith

```dart
TLinkThemeData copyWith({
  TextStyle? textStyle,
  double? iconSize,
  double? iconGap,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TLinkThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| textStyle | TextStyle? | - | 链接文字样式；字号、行高与字重默认由实例尺寸对应 Token 提供。 | 否 |
| iconSize | double? | - | 图标尺寸；未设置时小、中、大尺寸分别为 14、16、18 逻辑像素。 | 否 |
| iconGap | double? | - | 前/后图标与内容之间的间距；未设置时为 4 逻辑像素。 | 否 |


##### TLinkThemeData.lerp

```dart
TLinkThemeData lerp(ThemeExtension<TLinkThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TLinkThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TLinkThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TLinkColorPreset
#### 简介
链接内置配色预设，不是 Material ColorScheme。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | 品牌主色链接。 |
| defaultTheme | 默认文本色链接。 |
| danger | 危险操作链接。 |
| warning | 警告提示链接。 |
| success | 成功状态链接。 |


### TLinkSize
#### 简介
链接尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸链接。 |
| medium | 中尺寸链接。 |
| large | 大尺寸链接。 |
