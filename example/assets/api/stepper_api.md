## API
### TDStepper
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| disableInput | bool | false | 禁用输入框 |
| disabled | bool | false | 禁用全部操作 |
| inputWidth | double | - | 输入框宽度 |
| max | int | 100 | 最大值 |
| min | int | 0 | 最小值 |
| size | TDStepperSize | TDStepperSize.medium | 组件尺寸。可选项：small/medium/large |
| step | int | 1 | 步长 |
| theme | TDStepperTheme | TDStepperTheme.normal | 组件风格。可选项：normal/filled/outline |
| value | int | 0 | 值 |
| defaultValue | int | 0 | 默认值 |
| onBlur | VoidCallback | - | 输入框失去焦点时触发 |
| onChange | ValueChanged<int> | - | 数值发生变更时触发 |
| onOverlimit | void Function(TDStepperOverlimitType type) | - | 数值超出限制时触发。TDStepperOverlimitType有minus和plus两种枚举 |
