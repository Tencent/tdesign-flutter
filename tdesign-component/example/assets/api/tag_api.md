## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TTag

#### 声明

```dart
class TTag extends StatelessWidget
```

#### 默认构造方法


```dart
const TTag(
  this.text, {
  this.colorPreset = TTagColorPreset.defaultTheme,
  this.variant = TTagVariant.dark,
  this.icon,
  this.size = TTagSize.medium,
  this.shape = TTagShape.square,
  this.needCloseIcon = false,
  this.enabled = true,
  this.onTap,
  this.onCloseTap,
  Key? key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| text | String | - | 标签内容 | 是 |
| colorPreset | TTagColorPreset | TTagColorPreset.defaultTheme | 标签预设配色。 | 否 |
| enabled | bool | true | 是否启用标签；false 时使用禁用样式并阻止标签点击与关闭图标回调。 | 否 |
| icon | IconData? | - | 前置图标，颜色与正文共用解析后的前景色；关闭图标使用独立颜色。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| needCloseIcon | bool | false | 是否显示关闭图标。 | 否 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件。 标签本身不持有列表状态；需要移除标签时，请在此回调中更新父组件的 数据源并触发重建。 | 否 |
| onTap | GestureTapCallback? | - | 标签点击回调；为空时不创建标签点击行为。 | 否 |
| shape | TTagShape | TTagShape.square | 标签外形；仅选择形状，具体圆角值由组件 Theme 或全局 Token 决定。 | 否 |
| size | TTagSize | TTagSize.medium | 标签大小 | 否 |
| variant | TTagVariant | TTagVariant.dark | 绘制形态。 | 否 |


### TSelectTag
#### 简介
严格受控的可选标签。

#### 声明

```dart
class TSelectTag extends StatelessWidget
```

#### 默认构造方法


```dart
const TSelectTag(
  this.text, {
  super.key,
  required this.value,
  this.onChanged,
  this.colorPreset = TTagColorPreset.primary,
  this.variant = TTagVariant.dark,
  this.icon,
  this.size = TTagSize.medium,
  this.shape = TTagShape.square,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| text | String | - | 标签内容。 | 是 |
| colorPreset | TTagColorPreset | TTagColorPreset.primary | 选中态预设配色。 | 否 |
| icon | IconData? | - | 标签图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;bool&gt;? | - | 选中状态变更回调；为空时禁用交互。 | 否 |
| shape | TTagShape | TTagShape.square | 标签外形；具体圆角值由组件 Theme 或全局 Token 决定。 | 否 |
| size | TTagSize | TTagSize.medium | 标签尺寸。 | 否 |
| value | bool | - | 当前选中状态。 | 是 |
| variant | TTagVariant | TTagVariant.dark | 标签绘制形态。 | 否 |


### TTagThemeData
#### 简介
标签组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认样式。
具体视觉值由组件 Theme 控制，未指定时回退全局 Token。
{@category ComponentTheme}

#### 声明

```dart
class TTagThemeData extends ThemeExtension<TTagThemeData>
```

#### 默认构造方法


```dart
const TTagThemeData({
  this.textColor,
  this.backgroundColor,
  this.dangerColor,
  this.successColor,
  this.successLightColor,
  this.font,
  this.padding,
  this.squareBorderRadius,
  this.overflow,
  this.maxLines,
  this.fixedWidth,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 所有启用 Tag 的统一背景色；优先于各配色预设的填充色。 | 否 |
| dangerColor | Color? | - | danger 预设的基础色；未设置时回退全局 errorColor。 | 否 |
| fixedWidth | double? | - | 标签固定宽度 | 否 |
| font | Font? | - | 字体尺寸和行高；未设置时随标签尺寸使用对应的全局字体 Token。 | 否 |
| maxLines | int? | - | 文字最大行数。 未设置时组件默认按紧凑标签语义使用单行。 | 否 |
| overflow | TextOverflow? | - | 文字溢出处理 | 否 |
| padding | EdgeInsets? | - | 自定义间距 | 否 |
| squareBorderRadius | double? | - | 方形标签圆角，单位为逻辑像素；未设置时所有尺寸均读取全局 `radiusSmall`（当前默认 3dp）。 | 否 |
| successColor | Color? | - | success 预设的基础色；未设置时回退全局 successColor。 | 否 |
| successLightColor | Color? | - | success 预设的浅色填充；未设置时回退全局 successColor1。 | 否 |
| textColor | Color? | - | 所有启用 Tag 的正文和前置图标颜色；优先于配色预设的全局 Token。 禁用态不受此字段影响，关闭图标继续使用独立的占位色 Token。 | 否 |


#### 实例方法

##### TTagThemeData.copyWith

```dart
TTagThemeData copyWith({
  Color? textColor,
  Color? backgroundColor,
  Color? dangerColor,
  Color? successColor,
  Color? successLightColor,
  Font? font,
  EdgeInsets? padding,
  double? squareBorderRadius,
  TextOverflow? overflow,
  int? maxLines,
  double? fixedWidth,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TTagThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| textColor | Color? | - | 所有启用 Tag 的正文和前置图标颜色；优先于配色预设的全局 Token。 禁用态不受此字段影响，关闭图标继续使用独立的占位色 Token。 | 否 |
| backgroundColor | Color? | - | 所有启用 Tag 的统一背景色；优先于各配色预设的填充色。 | 否 |
| dangerColor | Color? | - | danger 预设的基础色；未设置时回退全局 errorColor。 | 否 |
| successColor | Color? | - | success 预设的基础色；未设置时回退全局 successColor。 | 否 |
| successLightColor | Color? | - | success 预设的浅色填充；未设置时回退全局 successColor1。 | 否 |
| font | Font? | - | 字体尺寸和行高；未设置时随标签尺寸使用对应的全局字体 Token。 | 否 |
| padding | EdgeInsets? | - | 自定义间距 | 否 |
| squareBorderRadius | double? | - | 方形标签圆角，单位为逻辑像素；未设置时所有尺寸均读取全局 `radiusSmall`（当前默认 3dp）。 | 否 |
| overflow | TextOverflow? | - | 文字溢出处理 | 否 |
| maxLines | int? | - | 文字最大行数。 未设置时组件默认按紧凑标签语义使用单行。 | 否 |
| fixedWidth | double? | - | 标签固定宽度 | 否 |


##### TTagThemeData.lerp

```dart
TTagThemeData lerp(ThemeExtension<TTagThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TTagThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTagThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TTagColorPreset
#### 简介
标签内置配色预设；绘制形态由 `TTagVariant` 单独选择。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认中性色。 |
| primary | 品牌主色。 |
| warning | 警告色。 |
| danger | 危险色。 |
| success | 成功色。 |


### TTagSize
#### 简介
标签尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| extraLarge | 超大尺寸。 |
| large | 大尺寸。 |
| medium | 中等尺寸。 |
| small | 小尺寸。 |
| custom | 由 Theme padding 和字体决定尺寸。 |


### TTagShape
#### 简介
标签形状。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 小圆角矩形。 |
| round | 胶囊形。 |
| mark | 右侧胶囊标记形。 |


### TTagVariant
#### 简介
标签绘制形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| dark | 深色填充。 |
| light | 浅色填充。 |
| outline | 描边。 |
| lightOutline | 浅色描边。 |
