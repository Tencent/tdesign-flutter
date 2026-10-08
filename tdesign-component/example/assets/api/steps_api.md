## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSteps

#### 声明

```dart
class TSteps extends StatelessWidget
```


#### 命名构造方法

##### TSteps.display

```dart
const TSteps.display({
  super.key,
  required this.steps,
  this.direction = TStepsDirection.vertical,
})
```


纯展示步骤条。
所有节点和连线均使用完成态，不接收进度、状态或交互参数。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| steps | List&lt;TStepsItemData&gt; | - | 步骤条数据 | 是 |
| direction | TStepsDirection | TStepsDirection.vertical | 步骤条方向 | 否 |


##### TSteps.progress

```dart
const TSteps.progress({
  super.key,
  required this.steps,
  this.value = 0,
  this.direction = TStepsDirection.horizontal,
  this.status = TStepsStatus.process,
  this.indicator = TStepsIndicator.standard,
  this.onChange,
})
```


普通进度步骤条。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| steps | List&lt;TStepsItemData&gt; | - | 步骤条数据 | 是 |
| value | int | 0 | 进度或可选择步骤条当前激活的索引；越界值会收敛到有效范围。 | 否 |
| direction | TStepsDirection | TStepsDirection.horizontal | 步骤条方向 | 否 |
| status | TStepsStatus | TStepsStatus.process | 进度步骤条当前 `value` 对应步骤的状态。 | 否 |
| indicator | TStepsIndicator | TStepsIndicator.standard | 进度步骤条的指示器样式。 | 否 |
| onChange | ValueChanged&lt;int&gt;? | - | 为空时只读；非空时只报告用户点击的索引；当前进度仍由调用方更新 `value` 控制。 | 否 |


##### TSteps.selectable

```dart
const TSteps.selectable({
  super.key,
  required this.steps,
  required this.value,
  required ValueChanged<int> onChange,
})
```


垂直可选择步骤条。
固定使用点状指示器并显示右侧箭头：已完成节点实心，
当前与未完成节点空心。`onChange` 只报告用户选择的索引，
调用方需要更新 `value` 完成受控重建。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| steps | List&lt;TStepsItemData&gt; | - | 步骤条数据 | 是 |
| value | int | - | 进度或可选择步骤条当前激活的索引；越界值会收敛到有效范围。 | 是 |
| onChange | ValueChanged&lt;int&gt; | - | 用户选择步骤时触发；调用方通过更新 `value` 实现受控模式。 `TSteps.progress` 中为空时只读，非空时不改变指示器视觉； `TSteps.selectable` 中必填。`TSteps.display` 不接收此参数。 | 是 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| direction | TStepsDirection | - | 步骤条方向 |
| indicator | TStepsIndicator | - | 进度步骤条的指示器样式。 |
| onChange | ValueChanged&lt;int&gt;? | - | 用户选择步骤时触发；调用方通过更新 `value` 实现受控模式。 `TSteps.progress` 中为空时只读，非空时不改变指示器视觉； `TSteps.selectable` 中必填。`TSteps.display` 不接收此参数。 |
| status | TStepsStatus | - | 进度步骤条当前 `value` 对应步骤的状态。 |
| steps | List&lt;TStepsItemData&gt; | - | 步骤条数据 |
| value | int | - | 进度或可选择步骤条当前激活的索引；越界值会收敛到有效范围。 |


### TStepsItemData

#### 声明

```dart
class TStepsItemData
```

#### 默认构造方法


```dart
const TStepsItemData({
  this.title,
  this.content,
  this.icon,
  this.errorIcon,
  this.customContent,
  this.customTitle,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| content | String? | - | 内容 | 否 |
| customContent | Widget? | - | 自定义内容 | 否 |
| customTitle | Widget? | - | 自定义标题 | 否 |
| errorIcon | IconData? | - | 失败图标 | 否 |
| icon | IconData? | - | 步骤图标；未设置时使用数字或状态图标。 | 否 |
| title | String? | - | 标题 | 否 |


### TStepsDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 水平方向 |
| vertical | 垂直方向 |


### TStepsIndicator
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| standard | 标准的数字或图标步骤条。 |
| dot | 点状进度指示器；横向与纵向均以当前节点实心表达进度。 在 `TSteps.progress` 中是否传入 `TSteps.onChange` 不改变该视觉语义。 |


### TStepsStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| process | 当前步骤进行中。 |
| error | 错误状态 |
