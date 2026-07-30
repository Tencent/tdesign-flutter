## API
### TBadge
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| border | bool | false | 是否为徽标增加对比色描边。 |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 |
| label | String? | '0' | 徽标实际展示的短文本，例如 `8`、`99+` 或 `NEW`。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击语义。 |
| showZero | bool | true | `label` 为 `0` 时是否显示徽标。 |
| variant | TBadgeVariant | TBadgeVariant.normal | 徽标形态。 |


### TBadgeVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 标准数字徽标。 |
| small | 紧凑数字徽标。 |
| dot | 不显示数字的圆点徽标。 |
