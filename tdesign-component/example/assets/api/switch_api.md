## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSwitch
#### 简介
严格受控的开关组件。

`value` 由父级持有；`onChanged` 为 null 时禁用；`loading` 为 true 时
显示加载指示器并禁用交互。文字、图标和加载内容无法由 Material Switch
完整表达，因此底层保留 TDesign 自定义开关实现。

#### 声明

```dart
class TSwitch extends StatelessWidget
```

#### 默认构造方法


```dart
const TSwitch({
  super.key,
  required this.value,
  this.onChanged,
  this.size,
  this.variant,
  this.loading = false,
  this.openText,
  this.closeText,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| closeText | String? | - | text 形态的关闭文案。 null 时显示“关”；仅关闭态文本内容形态使用。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loading | bool | false | 是否处于加载状态；加载时显示指示器并禁用交互。 | 否 |
| onChanged | ValueChanged&lt;bool&gt;? | - | 开关状态变更回调；为 null 时禁用。 | 否 |
| openText | String? | - | text 形态的开启文案。 null 时显示“开”；仅开启态文本内容形态使用。 | 否 |
| size | TSwitchSize? | - | 开关尺寸；未传时为 `TSwitchSize.medium`。 | 否 |
| value | bool | - | 受控开关状态。 | 是 |
| variant | TSwitchVariant? | - | 开关内容形态；未传时为 `TSwitchVariant.filled`。 | 否 |


### TSwitchThemeData
#### 简介
TSwitch 组件级 ThemeExtension

通过 Theme 子树注入，控制子树默认样式。

#### 声明

```dart
class TSwitchThemeData extends ThemeExtension<TSwitchThemeData>
```

#### 默认构造方法


```dart
const TSwitchThemeData({
  this.trackOnColor,
  this.trackOffColor,
  this.disabledTrackOnColor,
  this.disabledTrackOffColor,
  this.thumbColor,
  this.disabledThumbColor,
  this.loadingColor,
  this.thumbContentOnColor,
  this.thumbContentOffColor,
  this.thumbContentOnFont,
  this.thumbContentOffFont,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| disabledThumbColor | Color? | - | 禁用或加载时滑块填充色；未设置时随明暗模式取白色层级。 | 否 |
| disabledTrackOffColor | Color? | - | 禁用时关闭态轨道颜色；未设置时使用全局禁用组件背景色。 | 否 |
| disabledTrackOnColor | Color? | - | 禁用时开启态轨道颜色；未设置时使用全局禁用品牌色。 | 否 |
| loadingColor | Color? | - | 加载指示器颜色；未设置时浅色为品牌色、深色为最高层级白色。 | 否 |
| thumbColor | Color? | - | 可交互时滑块填充色；未设置时使用全局反色文字 Token。 与滑块内图标或文字的颜色无关。 | 否 |
| thumbContentOffColor | Color? | - | 关闭态滑块内容颜色。 未配置时使用 textColorDisabled Token。 | 否 |
| thumbContentOffFont | TextStyle? | - | 关闭态滑块内容文本样式。 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。 | 否 |
| thumbContentOnColor | Color? | - | 开启态滑块内容颜色。 未配置时使用 brandColor Token。 | 否 |
| thumbContentOnFont | TextStyle? | - | 开启态滑块内容文本样式。 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。 | 否 |
| trackOffColor | Color? | - | 关闭态轨道颜色。 未配置时使用 bgColorSecondaryContainerActive Token。 | 否 |
| trackOnColor | Color? | - | 开启态轨道颜色。 未配置时使用 brandColor Token。 | 否 |


#### 实例方法

##### TSwitchThemeData.copyWith

```dart
TSwitchThemeData copyWith({
  Color? trackOnColor,
  Color? trackOffColor,
  Color? disabledTrackOnColor,
  Color? disabledTrackOffColor,
  Color? thumbColor,
  Color? disabledThumbColor,
  Color? loadingColor,
  Color? thumbContentOnColor,
  Color? thumbContentOffColor,
  TextStyle? thumbContentOnFont,
  TextStyle? thumbContentOffFont,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TSwitchThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| trackOnColor | Color? | - | 字段含义：开启态轨道颜色。 未配置时使用 brandColor Token。 调用时的空值行为见方法说明。 | 否 |
| trackOffColor | Color? | - | 字段含义：关闭态轨道颜色。 未配置时使用 bgColorSecondaryContainerActive Token。 调用时的空值行为见方法说明。 | 否 |
| disabledTrackOnColor | Color? | - | 字段含义：禁用时开启态轨道颜色；未设置时使用全局禁用品牌色。 调用时的空值行为见方法说明。 | 否 |
| disabledTrackOffColor | Color? | - | 字段含义：禁用时关闭态轨道颜色；未设置时使用全局禁用组件背景色。 调用时的空值行为见方法说明。 | 否 |
| thumbColor | Color? | - | 字段含义：可交互时滑块填充色；未设置时使用全局反色文字 Token。 与滑块内图标或文字的颜色无关。 调用时的空值行为见方法说明。 | 否 |
| disabledThumbColor | Color? | - | 字段含义：禁用或加载时滑块填充色；未设置时随明暗模式取白色层级。 调用时的空值行为见方法说明。 | 否 |
| loadingColor | Color? | - | 字段含义：加载指示器颜色；未设置时浅色为品牌色、深色为最高层级白色。 调用时的空值行为见方法说明。 | 否 |
| thumbContentOnColor | Color? | - | 字段含义：开启态滑块内容颜色。 未配置时使用 brandColor Token。 调用时的空值行为见方法说明。 | 否 |
| thumbContentOffColor | Color? | - | 字段含义：关闭态滑块内容颜色。 未配置时使用 textColorDisabled Token。 调用时的空值行为见方法说明。 | 否 |
| thumbContentOnFont | TextStyle? | - | 字段含义：开启态滑块内容文本样式。 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| thumbContentOffFont | TextStyle? | - | 字段含义：关闭态滑块内容文本样式。 未配置时使用 fontBodyMedium 字号 Token，Token 为空时回退为 14 逻辑像素。 调用时的空值行为见方法说明。 | 否 |


##### TSwitchThemeData.lerp

```dart
TSwitchThemeData lerp(ThemeExtension<TSwitchThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TSwitchThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSwitchThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TSwitchSize
#### 简介
开关尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大尺寸。 |
| medium | 中尺寸。 |
| small | 小尺寸。 |


### TSwitchVariant
#### 简介
开关内容形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| filled | 无滑块内容的填充开关。 |
| text | 滑块内显示开关文案。 |
| icon | 滑块内显示开关图标。 |
