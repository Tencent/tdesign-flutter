## API
### TCheckbox
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| cardMode | bool | false | 展示为卡片模式 |
| checkBoxLeftSpace | double? | - | 选项框左侧间距 |
| checked | bool | false | 选中状态。默认为`false` 当FuiCheckBox嵌入到FuiCheckBoxGroup的时候，这个值表示初始状态，后续的状态会由Group管理 |
| contentDirection | TContentDirection | TContentDirection.right | 文字相对icon的方位 |
| customContentBuilder | ContentBuilder? | - | 完全自定义内容 |
| customIconBuilder | IconBuilder? | - | 自定义Checkbox显示样式 |
| customSpace | EdgeInsetsGeometry? | - | 自定义组件间距 |
| disableColor | Color? | - | 禁用选择颜色 |
| enable | bool | true | 不可用 |
| id | String? | - | id 当FuiCheckBox嵌入到FuiCheckBoxGroup内时，这个值需要赋值，否则不会被纳入Group管理 |
| insetSpacing | double? | 16 | 文字和非图标侧的距离 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onCheckBoxChanged | OnCheckValueChanged? | - | 切换监听 |
| selectColor | Color? | - | 选择颜色 |
| showDivider | bool | true | 是否展示分割线 |
| size | TCheckBoxSize | TCheckBoxSize.small | 复选框大小 |
| spacing | double? | - | icon和文字的距离 |
| style | TCheckboxStyle? | - | 复选框样式：圆形或方形 |
| subTitle | String? | - | 辅助文字 |
| subTitleColor | Color? | - | 副标题文字颜色 |
| subTitleFont | Font? | - | 副标题字体大小 |
| subTitleMaxLine | int? | 1 | 辅助文字的行数 |
| title | String? | - | 文本 |
| titleColor | Color? | - | 标题文字颜色 |
| titleFont | Font? | - | 标题字体大小 |
| titleMaxLine | int? | - | 标题的行数 |


### TCheckboxGroup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| checkedIds | List<String>? | - | 勾选的CheckBox id列表 |
| child | Widget | - | 可以是任意包含TCheckBox的容器，比如： ``` Row( children: [ TCheckBox(), TCheckBox(), ... ] ) ``` |
| contentDirection | TContentDirection? | - | 文字相对icon的方位 |
| controller | TCheckboxGroupController? | - | 可以通过控制器操作勾选状态 |
| customContentBuilder | ContentBuilder? | - | CheckBox完全自定义内容 |
| customIconBuilder | IconBuilder? | - | 自定义选择icon的样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxChecked | int? | - | 最多可以勾选多少 |
| onChangeGroup | OnGroupChange? | - | 状态变化监听器 |
| onOverloadChecked | VoidCallback? | - | 超过最大可勾选的个数 |
| spacing | double? | - | CheckBoxicon和文字的距离 |
| style | TCheckboxStyle? | - | CheckBox复选框样式：圆形或方形 |
| titleMaxLine | int? | - | CheckBox标题的行数 |


### TCheckboxStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | - |
| square | - |
| check | - |


### TContentDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | - |
| right | - |


### TCheckBoxSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| small | - |


### OnGroupChange
#### 类型定义

```dart
typedef OnGroupChange = void Function(List<String> checkedIds);
```


### OnCheckBoxGroupChange
#### 类型定义

```dart
typedef OnCheckBoxGroupChange = void Function(List<String> ids);
```


### IconBuilder
#### 类型定义

```dart
typedef IconBuilder = Widget? Function(BuildContext context, bool checked);
```


### ContentBuilder
#### 类型定义

```dart
typedef ContentBuilder = Widget Function(BuildContext context, bool checked, String? content);
```


### OnCheckValueChanged
#### 类型定义

```dart
typedef OnCheckValueChanged = void Function(bool selected);
```
