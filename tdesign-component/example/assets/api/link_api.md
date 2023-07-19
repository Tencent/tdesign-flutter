## API
### TDLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| label | String | - | link 展示的文本 |
| uri | Uri? | - | link 跳转的uri |
| prefixIcon | Icon? | - | 前置 icon |
| suffixIcon | Icon? | - | 后置 icon |
| linkClick | LinkClick? | - | link 被点击之后所采取的动作，会将uri当做参数传入到该方法当中 |
| type | TDLinkType | TDLinkType.basic | link 类型 |
| style | TDLinkStyle | TDLinkStyle.defaultStyle | link 风格 |
| state | TDLinkState | TDLinkState.normal | link 状态 |
| size | TDLinkSize | TDLinkSize.medium | link 大小 |
| color | Color? | - | link 文本的颜色，如果不设置则根据状态和风格进行计算 |
| iconSize | double? | - | link icon 大小，如果不设置则根据状态和风格进行计算 |
| fontSize | double? | - | link 文本的字体大小，如果不设置则根据状态和风格进行计算 |
| leftGapWithIcon | double? | - | 前置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算 |
| rightGapWithIcon | double? | - | 后置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算 |
