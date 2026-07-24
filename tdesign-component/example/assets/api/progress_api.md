## API
### TProgress
#### 简介
展示确定或不确定任务进度的非交互组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | Widget? | - | 进度条标签。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| variant | TProgressVariant | - | 进度条形态 |


### TProgressThemeData
#### 简介
进度条组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认样式。
构造器参数优先于 Theme。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration? | - | 动画持续时间 |
| backgroundColor | Color? | - | 进度条背景色 |
| circleRadius | double? | - | 环形进度条半径 |
| color | Color? | - | 进度条颜色 |
| labelWidgetAlignment | Alignment? | - | 自定义标签对齐方式 |
| labelWidgetWidth | double? | - | 自定义标签宽度 |
| linearBorderRadius | BorderRadiusGeometry? | - | 条形进度条末端圆角 |
| progressLabelPosition | TProgressLabelPosition? | - | 标签显示位置 |
| showLabel | bool? | - | 是否显示标签 |
| strokeWidth | double? | - | 进度条粗细 |


### TProgressVariant
#### 简介
进度条形态
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| linear | 线性进度条。 |
| circular | 环形进度条。 |
| micro | 紧凑环形进度条。 |
| button | 按钮外观的线性进度条，不提供点击行为。 |


### TProgressLabelPosition
#### 简介
标签位置
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| inside | 标签位于进度条内部。 |
| left | 标签位于进度条左侧。 |
| right | 标签位于进度条右侧。 |
