## API
### TBadge
#### 简介
在内容右上角展示数字或圆点状态。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| border | bool | false | 是否为徽标增加对比色描边。 |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 |
| count | int | 0 | 当前数量。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCount | int | 99 | 最大显示数量，超出后显示 `[maxCount]+`。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击语义。 |
| showZero | bool | true | `count` 为 0 时是否显示徽标。 |
| variant | TBadgeVariant | TBadgeVariant.normal | 徽标形态。 |


### TBadgeThemeData
#### 简介
Material `BadgeThemeData` 未覆盖的 TDesign 徽标视觉默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| borderColor | Color? | - | 开启边框时使用的颜色。 |
| borderWidth | double? | - | 开启边框时使用的宽度。 |


### TBadgeVariant
#### 简介
徽标形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 标准数字徽标。 |
| small | 紧凑数字徽标。 |
| dot | 不显示数字的圆点徽标。 |
