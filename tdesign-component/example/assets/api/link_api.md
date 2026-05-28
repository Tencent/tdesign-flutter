## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | link 文本的颜色，如果不设置则根据状态和风格进行计算 |
| fontSize | double? | - | link 文本的字体大小，如果不设置则根据状态和风格进行计算 |
| iconSize | double? | - | link icon 大小，如果不设置则根据状态和风格进行计算 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String | - | link 展示的文本 |
| leftGapWithIcon | double? | - | 前置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算 |
| linkClick | LinkClick? | - | link 被点击之后所采取的动作，会将uri当做参数传入到该方法当中 |
| prefixIcon | Icon? | - | 前置 icon |
| rightGapWithIcon | double? | - | 后置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算 |
| size | TLinkSize | TLinkSize.medium | link 大小 |
| state | TLinkState | TLinkState.normal | link 状态 |
| style | TLinkStyle | TLinkStyle.defaultStyle | link 风格 |
| suffixIcon | Icon? | - | 后置 icon |
| type | TLinkType | TLinkType.basic | link 类型 |
| uri | Uri? | - | link 跳转的uri |


### TLinkType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| basic | - |
| withUnderline | - |
| withPrefixIcon | - |
| withSuffixIcon | - |


### TLinkStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | - |
| defaultStyle | - |
| danger | - |
| warning | - |
| success | - |


### TLinkState
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | - |
| active | - |
| disabled | - |


### TLinkSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | - |
| medium | - |
| large | - |


### LinkClick
#### 类型定义

```dart
typedef LinkClick =  Function(Uri? uri);
```
