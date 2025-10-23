## API
### TDSideBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TDBadge? | - | 徽标 |
| disabled | bool | false | 是否禁用 |
| icon | IconData? | - | 图标 |
| key |  | - |  |
| label | String | '' | 标签 |
| textStyle | TextStyle? | - | 标签样式 |
| value | int | -1 | 值 |

```
```
 ### TDSideBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TDSideBarItem> | const [] | 单项 |
| contentPadding | EdgeInsetsGeometry? | - | 自定义文本框内边距 |
| controller | TDSideBarController? | - | 控制器 |
| defaultValue | int? | - | 默认值 |
| height | double? | - | 高度 |
| key |  | - |  |
| loading | bool? | - | 加载效果 |
| loadingWidget | Widget? | - | 自定义加载动画 |
| onChanged | ValueChanged<int>? | - | 选中值发生变化（Controller控制） |
| onSelected | ValueChanged<int>? | - | 选中值发生变化（点击事件） |
| selectedBgColor | Color? | - | 选择的背景颜色 |
| selectedColor | Color? | - | 选中值后颜色 |
| selectedTextStyle | TextStyle? | - | 选中样式 |
| style | TDSideBarStyle | TDSideBarStyle.normal | 样式 |
| unSelectedBgColor | Color? | - | 未选择的背景颜色 |
| unSelectedColor | Color? | - | 未选中颜色 |
| value | int? | - | 选项值 |
