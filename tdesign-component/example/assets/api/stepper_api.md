## API
### TStepper
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| max | num | 100 | 最大值。 |
| min | num | 0 | 最小值。 |
| onChanged | ValueChanged<num>? | - | 数值变化回调；为 null 时禁用。 |
| step | num | 1 | 步长。 |
| value | num | - | 受控数值。 |
