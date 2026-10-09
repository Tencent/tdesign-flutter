## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSlider

#### 声明

```dart
class TSlider extends StatelessWidget
```

#### 默认构造方法


```dart
const TSlider({
  super.key,
  required this.value,
  this.onChanged,
  this.onChangeStart,
  this.onChangeEnd,
  this.min = 0,
  this.max = 1,
  this.divisions,
  this.showThumbValue = false,
  this.thumbFormatter,
  this.showScaleValue = false,
  this.scaleFormatter,
  this.variant = TSliderVariant.normal,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | double | 1 | 最大值。 | 否 |
| min | double | 0 | 最小值。 | 否 |
| onChanged | ValueChanged&lt;double&gt;? | - | 值变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;double&gt;? | - | 结束拖动时触发。 | 否 |
| onChangeStart | ValueChanged&lt;double&gt;? | - | 开始拖动时触发。 | 否 |
| scaleFormatter | TSliderThumbFormatter? | - | 刻度值格式化回调。 | 否 |
| showScaleValue | bool | false | 是否显示刻度值。 | 否 |
| showThumbValue | bool | false | 是否持续显示拇指上方数值。 | 否 |
| thumbFormatter | TSliderThumbFormatter? | - | 拇指上方数值格式化回调。 | 否 |
| value | double | - | 受控滑块值。 | 是 |
| variant | TSliderVariant | TSliderVariant.normal | 滑块视觉结构，默认使用标准细轨道。 | 否 |


### TRangeSlider

#### 声明

```dart
class TRangeSlider extends StatelessWidget
```

#### 默认构造方法


```dart
const TRangeSlider({
  super.key,
  required this.value,
  this.onChanged,
  this.onChangeStart,
  this.onChangeEnd,
  this.min = 0,
  this.max = 1,
  this.divisions,
  this.showThumbValue = false,
  this.thumbFormatter,
  this.showScaleValue = false,
  this.scaleFormatter,
  this.variant = TSliderVariant.normal,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| divisions | int? | - | 离散刻度数；null 表示连续。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | double | 1 | 最大值。 | 否 |
| min | double | 0 | 最小值。 | 否 |
| onChanged | ValueChanged&lt;RangeValues&gt;? | - | 范围变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;RangeValues&gt;? | - | 结束拖动时触发。 | 否 |
| onChangeStart | ValueChanged&lt;RangeValues&gt;? | - | 开始拖动时触发。 | 否 |
| scaleFormatter | TSliderThumbFormatter? | - | 刻度值格式化回调。 | 否 |
| showScaleValue | bool | false | 是否显示刻度值。 | 否 |
| showThumbValue | bool | false | 是否持续显示拇指上方数值。 | 否 |
| thumbFormatter | TSliderThumbFormatter? | - | 拇指上方数值格式化回调。 | 否 |
| value | RangeValues | - | 受控范围值。 | 是 |
| variant | TSliderVariant | TSliderVariant.normal | 滑块视觉结构，默认使用标准细轨道。 | 否 |


### TSliderVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | Standard thin track. |
| capsule | Capsule track with a 3px inset active segment and 20px thumbs. |


### TSliderThumbFormatter
#### 类型定义

```dart
typedef TSliderThumbFormatter = String Function(double value);
```
