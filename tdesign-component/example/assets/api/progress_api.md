## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TProgress
#### 简介
展示确定或不确定任务进度的组件。

#### 声明

```dart
class TProgress extends StatelessWidget
```


#### 命名构造方法

##### TProgress.button

```dart
TProgress.button({
  Key? key,
  double? value,
  TProgressStatus status = TProgressStatus.normal,
  Widget? label,
  LinearGradient? gradient,
  String? semanticsLabel,
  String? semanticsValue,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
})
```


创建按钮外观的线性进度条。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |
| onTap | VoidCallback? | - | 点击 `button` 或 `microButton` 进度条时触发。 其他只读形态不会响应点击。 | 否 |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `microButton` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。其他只读形态 不会响应长按。 | 否 |


##### TProgress.circular

```dart
TProgress.circular({
  Key? key,
  double? value,
  TProgressStatus status = TProgressStatus.normal,
  Widget? label,
  String? semanticsLabel,
  String? semanticsValue,
})
```


创建环形进度条。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |


##### TProgress.linear

```dart
TProgress.linear({
  Key? key,
  double? value,
  TProgressStatus status = TProgressStatus.normal,
  Widget? label,
  LinearGradient? gradient,
  String? semanticsLabel,
  String? semanticsValue,
})
```


创建线性进度条。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |


##### TProgress.microButton

```dart
TProgress.microButton({
  Key? key,
  double? value,
  TProgressStatus status = TProgressStatus.normal,
  Widget? label,
  String? semanticsLabel,
  String? semanticsValue,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
})
```


创建带按钮语义和紧凑圆环外观的进度操作。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |
| onTap | VoidCallback? | - | 点击 `button` 或 `microButton` 进度条时触发。 其他只读形态不会响应点击。 | 否 |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `microButton` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。其他只读形态 不会响应长按。 | 否 |


##### TProgress.microCircular

```dart
TProgress.microCircular({
  Key? key,
  double? value,
  TProgressStatus status = TProgressStatus.normal,
  Widget? label,
  String? semanticsLabel,
  String? semanticsValue,
})
```


创建紧凑、只读的环形进度条。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |


##### TProgress.plump

```dart
TProgress.plump({
  Key? key,
  double? value,
  TProgressStatus status = TProgressStatus.normal,
  Widget? label,
  LinearGradient? gradient,
  String? semanticsLabel,
  String? semanticsValue,
})
```


创建百分比显示在进度条内部的胶囊形进度条。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `microButton` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。其他只读形态 不会响应长按。 |
| onTap | VoidCallback? | - | 点击 `button` 或 `microButton` 进度条时触发。 其他只读形态不会响应点击。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |
| status | TProgressStatus | - | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| variant | TProgressVariant | - | 进度条形态 |


### TProgressThemeData
#### 简介
进度条组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认视觉值。
除进度值、状态与线性渐变等实例语义外，具体绘制值优先读取组件 Theme。

#### 声明

```dart
class TProgressThemeData extends ThemeExtension<TProgressThemeData>
```

#### 默认构造方法


```dart
const TProgressThemeData({
  this.strokeWidth,
  this.color,
  this.backgroundColor,
  this.circleInnerBgColor,
  this.linearBorderRadius,
  this.circleSize,
  this.animationDuration,
  this.indeterminateAnimationDuration,
  this.indeterminateLinearSegmentFraction,
  this.indeterminateCircularValue,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| animationDuration | Duration? | - | 动画持续时间 未配置时为 300 毫秒。 | 否 |
| backgroundColor | Color? | - | 进度条背景色 | 否 |
| circleInnerBgColor | Color? | - | 环形进度条内圆背景色。默认浅色读取容器色、暗色透明； 宿主如需定义暗色内圆，可在组件 Theme 中显式配置。 | 否 |
| circleSize | double? | - | 环形进度条的正方形边长；未设置时由环形规格决定。 未配置时 circular 为 112、microCircular / microButton 为 24 逻辑像素。 | 否 |
| color | Color? | - | 进度条颜色 | 否 |
| indeterminateAnimationDuration | Duration? | - | 不确定进度完成一次循环的时长。 未配置时为 1200 毫秒；必须大于 Duration.zero，否则抛出 FlutterError。 | 否 |
| indeterminateCircularValue | double? | - | 不确定环形进度弧占整圈的比例。 未配置时为 0.25；必须大于 0 且小于 1。 | 否 |
| indeterminateLinearSegmentFraction | double? | - | 不确定线性进度段占轨道宽度的比例。 未配置时为 0.32；必须大于 0 且不大于 1。 | 否 |
| linearBorderRadius | BorderRadiusGeometry? | - | 条形进度条末端圆角 | 否 |
| strokeWidth | double? | - | 进度条粗细 | 否 |


#### 实例方法

##### TProgressThemeData.copyWith

```dart
TProgressThemeData copyWith({
  double? strokeWidth,
  Color? color,
  Color? backgroundColor,
  Color? circleInnerBgColor,
  BorderRadiusGeometry? linearBorderRadius,
  double? circleSize,
  Duration? animationDuration,
  Duration? indeterminateAnimationDuration,
  double? indeterminateLinearSegmentFraction,
  double? indeterminateCircularValue,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TProgressThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| strokeWidth | double? | - | 进度条粗细 | 否 |
| color | Color? | - | 进度条颜色 | 否 |
| backgroundColor | Color? | - | 进度条背景色 | 否 |
| circleInnerBgColor | Color? | - | 环形进度条内圆背景色。默认浅色读取容器色、暗色透明； 宿主如需定义暗色内圆，可在组件 Theme 中显式配置。 | 否 |
| linearBorderRadius | BorderRadiusGeometry? | - | 条形进度条末端圆角 | 否 |
| circleSize | double? | - | 环形进度条的正方形边长；未设置时由环形规格决定。 未配置时 circular 为 112、microCircular / microButton 为 24 逻辑像素。 | 否 |
| animationDuration | Duration? | - | 动画持续时间 未配置时为 300 毫秒。 | 否 |
| indeterminateAnimationDuration | Duration? | - | 不确定进度完成一次循环的时长。 未配置时为 1200 毫秒；必须大于 Duration.zero，否则抛出 FlutterError。 | 否 |
| indeterminateLinearSegmentFraction | double? | - | 不确定线性进度段占轨道宽度的比例。 未配置时为 0.32；必须大于 0 且不大于 1。 | 否 |
| indeterminateCircularValue | double? | - | 不确定环形进度弧占整圈的比例。 未配置时为 0.25；必须大于 0 且小于 1。 | 否 |


##### TProgressThemeData.lerp

```dart
TProgressThemeData lerp(
  ThemeExtension<TProgressThemeData>? other,
  double t,
)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TProgressThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TProgressThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TProgressVariant
#### 简介
进度条形态
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| linear | 线性进度条。 |
| plump | 百分比显示在进度条内部的胶囊形进度条。 |
| circular | 环形进度条。 |
| microCircular | 紧凑、只读的环形进度条。 |
| button | 按钮外观的线性进度条。 |
| microButton | 带按钮语义和紧凑圆环外观的进度操作。 |


### TProgressStatus
#### 简介
进度条所表达的任务状态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 常规进行中状态。 |
| warning | 警告状态。 |
| error | 错误状态。 |
| success | 成功状态。 |
