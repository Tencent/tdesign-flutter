## API
### TStepper
#### 简介
步进器
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | TStepperController? | - | Stepper控制器 |
| defaultValue | int? | 0 | 默认值 |
| disabled | bool | false | 禁用全部操作 |
| disableInput | bool | false | 禁用输入框 |
| eventController | StreamController<TStepperEventType>? | - | 事件控制器 |
| inputWidth | double? | - | 禁用全部操作 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| max | int | 100 | 最大值 |
| min | int | 0 | 最小值 |
| onBlur | VoidCallback? | - | 输入框失去焦点时触发 |
| onChange | ValueChanged<int>? | - | 数值发生变更时触发 |
| onOverlimit | TStepperOverlimitFunction? | - | 数值超出限制时触发 |
| size | TStepperSize | TStepperSize.medium | 组件尺寸 |
| step | int | 1 | 步长 |
| theme | TStepperTheme | TStepperTheme.normal | 组件风格 |
| value | int? | 0 | 值 |


### TStepperSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | - |
| medium | - |
| large | - |


### TStepperTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | - |
| filled | - |
| outline | - |


### TStepperIconType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| remove | - |
| add | - |


### TStepperOverlimitType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| minus | - |
| plus | - |


### TStepperEventType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| cleanValue | - |


### TStepperOverlimitFunction
#### 类型定义

```dart
typedef TStepperOverlimitFunction = void Function(TStepperOverlimitType type);
```


### TTapFunction
#### 类型定义

```dart
typedef TTapFunction = void Function();
```
