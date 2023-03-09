## API
### TDRadio
#### 简介
单选框按钮,继承自TDCheckbox，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| id |  | - |  |
| key |  | - |  |
| title |  | - |  |
| subTitle |  | - |  |
| enable |  | true |  |
| subTitleMaxLine |  | 1 |  |
| titleMaxLine |  | 1 |  |
| checkedColor |  | - |  |
| customContentBuilder |  | - |  |
| spacing |  | - |  |
| cardMode |  | - |  |
| showDivider |  | - |  |
| size |  | TDCheckBoxSize.small |  |
| radioStyle | TDRadioStyle | TDRadioStyle.circle |  |
| contentDirection |  | TDContentDirection.right |  |
| customIconBuilder |  | - |  |

```
```
 ### TDRadioGroup
#### 简介
RadioGroup分组对象，继承自TDCheckboxGroup，字段含义与父类一致
 RadioGroup应该嵌套在RadioGroup内，所有在RadioGroup的RadioButton只能有一个被选中

 cardMode: 使用卡片样式，需要配合direction 和 directionalTdRadios 使用，
 组合为横向、纵向卡片，同时需要在每个TDRadio上设置cardMode参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| child |  | - |  |
| direction |  | - |  |
| directionalTdRadios |  | - |  |
| selectId |  | - |  |
| passThrough |  | - |  |
| cardMode |  | false |  |
| strictMode | bool | true |  |
| radioCheckStyle | TDRadioStyle? | - |  |
| titleMaxLine |  | - |  |
| customIconBuilder |  | - |  |
| customContentBuilder |  | - |  |
| spacing |  | - |  |
| contentDirection |  | - |  |
| onRadioGroupChange |  | - |  |
