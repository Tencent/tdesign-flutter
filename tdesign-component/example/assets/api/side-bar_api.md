## API
### TDSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| badge | TDBadge? | - | 徽标 |
| disabled | bool | false | 是否禁用 |
| icon | IconData? | - | 图标 |
| textStyle | TextStyle? | - | 标签样式 |
| label | String | '' | 标签 |
| value | int | -1 | 值 |

```
```
 ### TDSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| value | int? | - | 选项值 |
| defaultValue | int? | - | 默认值 |
| selectedColor | Color? | - | 选中值后颜色 |
| children | List<TDSideBarItem> | const [] | 单项 |
| onChanged | ValueChanged<int>? | - | 选中值发生变化（Controller控制） |
| onSelected | ValueChanged<int>? | - | 选中值发生变化（点击事件） |
| height | double? | - | 高度 |
| controller | TDSideBarController? | - | 控制器 |
| contentPadding | EdgeInsetsGeometry? | - | 自定义文本框内边距 |
| selectedTextStyle | TextStyle? | - | 选中样式 |
| style | TDSideBarStyle | TDSideBarStyle.normal | 样式 |
