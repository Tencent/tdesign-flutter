## API
### TRadio
#### 简介
单选框按钮,继承自TCheckbox，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | - |
| cardMode | bool? | - | - |
| checkBoxLeftSpace | double? | - | - |
| contentDirection | TContentDirection | TContentDirection.right | - |
| customContentBuilder | ContentBuilder? | - | - |
| customIconBuilder | IconBuilder? | - | - |
| customSpace | EdgeInsetsGeometry? | - | - |
| disableColor | Color? | - | - |
| enable | bool | true | - |
| id | String? | - | - |
| insetSpacing | double? | - | - |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| radioStyle | TRadioStyle | TRadioStyle.circle | 单选框按钮样式 |
| selectColor | Color? | - | - |
| showDivider | bool? | - | - |
| size | TCheckBoxSize | TCheckBoxSize.small | - |
| spacing | double? | - | - |
| subTitle | String? | - | - |
| subTitleColor | Color? | - | - |
| subTitleFont | Font? | - | - |
| subTitleMaxLine | int | 1 | - |
| title | String? | - | - |
| titleColor | Color? | - | - |
| titleFont | Font? | - | - |
| titleMaxLine | int | 1 | - |


### TRadioGroup
#### 简介
RadioGroup分组对象，继承自TCheckboxGroup，字段含义与父类一致
 RadioGroup应该嵌套在RadioGroup内，所有在RadioGroup的RadioButton只能有一个被选中

 cardMode: 使用卡片样式，需要配合direction 和 directionalTdRadios 使用，
 组合为横向、纵向卡片，同时需要在每个TRadio上设置cardMode参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cardMode | bool | false | - |
| child | Widget? | - | - |
| contentDirection | TContentDirection? | - | - |
| controller | TCheckboxGroupController? | - | - |
| customContentBuilder | ContentBuilder? | - | - |
| customIconBuilder | IconBuilder? | - | - |
| direction | Axis? | - | - |
| directionalTdRadios | List<TRadio>? | - | - |
| divider | Widget? | - | 自定义下划线 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onRadioGroupChange | OnRadioGroupChange? | - | - |
| passThrough | bool? | - | - |
| radioCheckStyle | TRadioStyle? | - | 勾选样式 |
| rowCount | int | 1 | 每行几列 |
| selectId | String? | - | - |
| showDivider | bool | false | 是否显示下划线 |
| spacing | double? | - | - |
| strictMode | bool | true | 严格模式下，用户不能取消勾选，只能切换选择项， |
| titleMaxLine | int? | - | - |


### TRadioStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | - |
| square | - |
| check | - |
| hollowCircle | - |


### OnRadioGroupChange
#### 类型定义

```dart
typedef OnRadioGroupChange = void Function(String? selectedId);
```
