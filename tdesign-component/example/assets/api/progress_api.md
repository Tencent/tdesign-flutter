## API

### TProgress

#### 构造方法

##### TProgress.button

创建按钮外观的线性进度条。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

创建环形进度条。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |


##### TProgress.linear

创建线性进度条。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |


##### TProgress.microButton

创建带按钮语义和紧凑圆环外观的进度操作。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

创建紧凑、只读的环形进度条。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |


##### TProgress.plump

创建百分比显示在进度条内部的胶囊形进度条。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | 否 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | 否 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | 否 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 | 否 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | 否 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | 否 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 | - |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 | - |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `microButton` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。其他只读形态 不会响应长按。 | - |
| onTap | VoidCallback? | - | 点击 `button` 或 `microButton` 进度条时触发。 其他只读形态不会响应点击。 | - |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 | - |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 | - |
| status | TProgressStatus | - | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的 TProgressThemeData.color 可以覆盖状态默认色，线性渐变优先于两者。 不从 Flutter ProgressIndicatorTheme 读取颜色。 | - |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 | - |
| variant | TProgressVariant | - | 进度条形态 | - |


### TProgressVariant

进度条形态
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| linear | TProgressVariant | - | 线性进度条。 | - |
| plump | TProgressVariant | - | 百分比显示在进度条内部的胶囊形进度条。 | - |
| circular | TProgressVariant | - | 环形进度条。 | - |
| microCircular | TProgressVariant | - | 紧凑、只读的环形进度条。 | - |
| button | TProgressVariant | - | 按钮外观的线性进度条。 | - |
| microButton | TProgressVariant | - | 带按钮语义和紧凑圆环外观的进度操作。 | - |


### TProgressStatus

进度条所表达的任务状态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| normal | TProgressStatus | - | 常规进行中状态。 | - |
| warning | TProgressStatus | - | 警告状态。 | - |
| error | TProgressStatus | - | 错误状态。 | - |
| success | TProgressStatus | - | 成功状态。 | - |


### TProgressThemeData

进度条组件级 ThemeExtension

通过 Theme 子树注入，控制子树的默认视觉值。
除进度值、状态与线性渐变等实例语义外，具体绘制值优先读取组件 Theme。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
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
