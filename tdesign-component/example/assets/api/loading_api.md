## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TLoading

#### 声明

```dart
class TLoading extends StatelessWidget
```

#### 默认构造方法


```dart
const TLoading({
  Key? key,
  this.size = 20,
  this.icon = TLoadingIcon.circle,
  this.text,
  this.customIcon,
  this.refreshWidget,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 `icon`，并按当前 Loading 动画时长持续旋转。 | 否 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。 `customIcon` 不为 null 时仍优先显示自定义图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 | 否 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 | 否 |
| text | String? | - | 文案 | 否 |


### TLoadingIcon
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |
