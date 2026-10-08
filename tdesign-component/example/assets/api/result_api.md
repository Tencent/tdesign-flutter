## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TResult

#### 声明

```dart
class TResult extends StatelessWidget
```

#### 默认构造方法


```dart
const TResult({
  Key? key,
  this.description,
  this.icon,
  this.status = TResultStatus.info,
  this.title = '',
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| description | String? | - | 描述文本，用于提供额外信息；为空时不占布局空间。 | 否 |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| status | TResultStatus | TResultStatus.info | 当前结果状态，决定默认图标、颜色和无障碍语义，默认为 `TResultStatus.info`。 | 否 |
| title | String | '' | 标题文本，显示结果的主要信息，默认标题为空字符串 | 否 |


### TResultStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| info | 默认信息状态。 |
| success | 成功结果状态。 |
| warning | 警告结果状态。 |
| error | 错误结果状态。 |
