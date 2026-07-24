## API
### TSwitch
#### 简介
严格受控的开关组件。
`value` 由父级持有；`onChanged` 为 null 时禁用。文字、图标和加载形态
无法由 Material Switch 完整表达，因此底层保留 TDesign 自定义开关实现。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeText | String? | - | text 形态的关闭文案。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool>? | - | 开关状态变更回调；为 null 时禁用。 |
| openText | String? | - | text 形态的开启文案。 |
| size | TSwitchSize? | - | 开关尺寸。 |
| value | bool | - | 受控开关状态。 |
| variant | TSwitchVariant? | - | 开关内容形态。 |


### TSwitchSize
#### 简介
开关尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大尺寸。 |
| medium | 中尺寸。 |
| small | 小尺寸。 |


### TSwitchVariant
#### 简介
开关内容形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| filled | 无滑块内容的填充开关。 |
| text | 滑块内显示开关文案。 |
| loading | 滑块内显示加载指示器，并禁用交互。 |
| icon | 滑块内显示开关图标。 |
