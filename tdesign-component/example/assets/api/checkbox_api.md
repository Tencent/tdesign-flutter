## API
### TDCheckbox
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| id | String? | - | id |
| key |  | - |  |
| title | String? | - | 文本 |
| subTitle | String? | - | 辅助文字 |
| titleFont | Font? | - | 标题字体大小 |
| subTitleFont | Font? | - | 副标题字体大小 |
| enable | bool | true | 不可用 |
| checked | bool | false | 选中状态。默认为`false` |
| titleMaxLine | int? | - | 标题的行数 |
| subTitleMaxLine | int? | 1 | 辅助文字的行数 |
| customIconBuilder | IconBuilder? | - | 自定义Checkbox显示样式 |
| customContentBuilder | ContentBuilder? | - | 完全自定义内容 |
| insetSpacing | double? | 16 | 文字和非图标侧的距离 |
| style | TDCheckboxStyle? | - | 复选框样式：圆形或方形 |
| spacing | double? | - | icon和文字的距离 |
| backgroundColor | Color? | - | 背景颜色 |
| selectColor | Color? | - | 选择颜色 |
| disableColor | Color? | - | 禁用选择颜色 |
| size | TDCheckBoxSize | TDCheckBoxSize.small | 复选框大小 |
| cardMode | bool | false | 展示为卡片模式 |
| showDivider | bool | true | 是否展示分割线 |
| contentDirection | TDContentDirection | TDContentDirection.right | 文字相对icon的方位 |
| onCheckBoxChanged | OnCheckValueChanged? | - | 切换监听 |
| titleColor | Color? | - | 标题文字颜色 |
| subTitleColor | Color? | - | 副标题文字颜色 |
| checkBoxLeftSpace | double? | - | 选项框左侧间距 |

```
```
 ### TDCheckboxGroup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child |  | - |  |
| key |  | - |  |
| onChangeGroup | OnGroupChange? | - | 状态变化监听器 |
| controller | TDCheckboxGroupController? | - | 可以通过控制器操作勾选状态 |
| checkedIds | List<String>? | - | 勾选的CheckBox id列表 |
| maxChecked | int? | - | 最多可以勾选多少 |
| titleMaxLine | int? | - | CheckBox标题的行数 |
| customContentBuilder | ContentBuilder? | - | CheckBox完全自定义内容 |
| contentDirection | TDContentDirection? | - | 文字相对icon的方位 |
| style | TDCheckboxStyle? | - | CheckBox复选框样式：圆形或方形 |
| spacing | double? | - | CheckBoxicon和文字的距离 |
| customIconBuilder | IconBuilder? | - | 自定义选择icon的样式 |
| onOverloadChecked | VoidCallback? | - | 超过最大可勾选的个数 |
