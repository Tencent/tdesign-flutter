## API
### TProgress

#### 工厂构造方法

##### TProgress.button

创建按钮外观的线性进度条。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |
| onTap | VoidCallback? | - | 点击 `button` 或 `microButton` 进度条时触发。 其他只读形态不会响应点击。 |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `microButton` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。其他只读形态 不会响应长按。 |


##### TProgress.circular

创建环形进度条。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |


##### TProgress.linear

创建线性进度条。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |


##### TProgress.microButton

创建带按钮语义和紧凑圆环外观的进度操作。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |
| onTap | VoidCallback? | - | 点击 `button` 或 `microButton` 进度条时触发。 其他只读形态不会响应点击。 |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `microButton` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。其他只读形态 不会响应长按。 |


##### TProgress.microCircular

创建紧凑、只读的环形进度条。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |


##### TProgress.plump

创建百分比显示在进度条内部的胶囊形进度条。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| status | TProgressStatus | TProgressStatus.normal | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| gradient | LinearGradient? | - | 线性填充渐变。 仅用于 `TProgressVariant.linear`、`TProgressVariant.plump` 和 `TProgressVariant.button`，并优先于 Theme 和 `status` 的默认颜色。 |
| label | Widget? | - | 进度条标签。 未指定时，常规状态显示百分比；warning、error、success 在线性与 环形形态只显示状态图标，plump 形态保留内部百分比并在外侧显示图标； `TProgressVariant.microCircular` 默认不显示标签。 |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `microButton` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。其他只读形态 不会响应长按。 |
| onTap | VoidCallback? | - | 点击 `button` 或 `microButton` 进度条时触发。 其他只读形态不会响应点击。 |
| semanticsLabel | String? | - | 辅助技术播报的进度条名称。 |
| semanticsValue | String? | - | 辅助技术播报的进度值；未指定时由 `value` 格式化为百分比。 |
| status | TProgressStatus | - | 当前任务状态，决定默认颜色和状态标签，默认为 `TProgressStatus.normal`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| variant | TProgressVariant | - | 进度条形态 |


### TProgressVariant
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
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 常规进行中状态。 |
| warning | 警告状态。 |
| error | 错误状态。 |
| success | 成功状态。 |
