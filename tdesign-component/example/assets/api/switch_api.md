## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSwitch

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
| closeText | String? | - | text 形态的关闭文案。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loading | bool | false | 是否处于加载状态；加载时显示指示器并禁用交互。 | 否 |
| onChanged | ValueChanged&lt;bool&gt;? | - | 开关状态变更回调；为 null 时禁用。 | 否 |
| openText | String? | - | text 形态的开启文案。 | 否 |
| size | TSwitchSize? | - | 开关尺寸；未传时为 `TSwitchSize.medium`。 | 否 |
| value | bool | - | 受控开关状态。 | 是 |
| variant | TSwitchVariant? | - | 开关内容形态；未传时为 `TSwitchVariant.filled`。 | 否 |


### TSwitchThemeData

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
| disabledThumbColor | Color? | - | 禁用或加载时滑块填充色。 | 否 |
| disabledTrackOffColor | Color? | - | 禁用时关闭态轨道颜色。 | 否 |
| disabledTrackOnColor | Color? | - | 禁用时开启态轨道颜色。 | 否 |
| loadingColor | Color? | - | 加载指示器颜色。 | 否 |
| thumbColor | Color? | - | 可交互时滑块填充色，不影响内部图标或文字。 | 否 |
| thumbContentOffColor | Color? | - | 关闭态滑块内容颜色。 | 否 |
| thumbContentOffFont | TextStyle? | - | 关闭态滑块内容文本样式。 | 否 |
| thumbContentOnColor | Color? | - | 开启态滑块内容颜色。 | 否 |
| thumbContentOnFont | TextStyle? | - | 开启态滑块内容文本样式。 | 否 |
| trackOffColor | Color? | - | 关闭态轨道颜色。 | 否 |
| trackOnColor | Color? | - | 开启态轨道颜色。 | 否 |


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


返回类型：`TSwitchThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| trackOnColor | Color? | - | 开启时轨道颜色 | 否 |
| trackOffColor | Color? | - | 关闭时轨道颜色 | 否 |
| disabledTrackOnColor | Color? | - | 禁用时开启态轨道颜色；未设置时使用全局禁用品牌色。 | 否 |
| disabledTrackOffColor | Color? | - | 禁用时关闭态轨道颜色；未设置时使用全局禁用组件背景色。 | 否 |
| thumbColor | Color? | - | 可交互时滑块填充色；未设置时使用全局反色文字 Token。 与滑块内图标或文字的颜色无关。 | 否 |
| disabledThumbColor | Color? | - | 禁用或加载时滑块填充色；未设置时随明暗模式取白色层级。 | 否 |
| loadingColor | Color? | - | 加载指示器颜色；未设置时浅色为品牌色、深色为最高层级白色。 | 否 |
| thumbContentOnColor | Color? | - | 开启时ThumbView的颜色 | 否 |
| thumbContentOffColor | Color? | - | 关闭时ThumbView的颜色 | 否 |
| thumbContentOnFont | TextStyle? | - | 开启时ThumbView的字体样式 | 否 |
| thumbContentOffFont | TextStyle? | - | 关闭时ThumbView的字体样式 | 否 |


##### TSwitchThemeData.lerp

```dart
TSwitchThemeData lerp(ThemeExtension<TSwitchThemeData>? other, double t)
```


返回类型：`TSwitchThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSwitchThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |
