## API
### TSwitch
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeText | String? | - | text 形态的关闭文案。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool>? | - | 开关状态变更回调；为 null 时禁用。 |
| openText | String? | - | text 形态的开启文案。 |
| size | TSwitchSize? | - | 开关尺寸；未传时读取 `TSwitchThemeData.defaultSize`。 |
| value | bool | - | 受控开关状态。 |
| variant | TSwitchVariant? | - | 开关内容形态；未传时读取 `TSwitchThemeData.defaultVariant`。 |
