## API
### TStepper
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | num | - | 受控数值。 |
| onChanged | ValueChanged<num>? | - | 数值变化回调；为 null 时禁用。 |
| min | num | 0 | 最小值。 |
| max | num | 100 | 最大值。 |
| step | num | 1 | 步长。 |


### TStepperVariant
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| normal | 默认透明形态。 |
| filled | 填充背景形态。 |


### TStepperThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TStepperVariant? | - | 默认形态。 |
| inputWidth | double? | - | 输入框宽度。 |
