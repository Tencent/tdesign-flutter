## API
### TDDropdownMenu
#### 简介
下拉菜单
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowIcon | IconData? | - | 自定义箭头图标 |
| builder | TDDropdownItemBuilder? | - | 下拉菜单构建器，优先级高于[items] |
| closeOnClickOverlay | bool? | true | 是否在点击遮罩层后关闭菜单 |
| decoration | Decoration? | - | 下拉菜单的装饰器 |
| direction | TDDropdownMenuDirection? | TDDropdownMenuDirection.auto | 菜单展开方向（down、up、auto） |
| duration | double? | 200.0 | 动画时长，毫秒 |
| height | double? | 48 | menu的高度 |
| isScrollable | bool? | false | 是否开启滚动列表 |
| items | List<TDDropdownItem>? | - | 下拉菜单 |
| key |  | - |  |
| labelBuilder | LabelBuilder? | - | 自定义标签内容 |
| onMenuClosed | ValueChanged<int>? | - | 关闭菜单事件 |
| onMenuOpened | ValueChanged<int>? | - | 展开菜单事件 |
| showOverlay | bool? | true | 是否显示遮罩层 |
| tabBarAlign | MainAxisAlignment? | MainAxisAlignment.center | [TDDropdownItem.label]和[arrowIcon]/[TDDropdownItem.arrowIcon]的对齐方式 |
| width | double? | - | menu的宽度 |

```
```
 ### TDDropdownItemController
#### 简介
下拉菜单控制器
```
```
 ### TDDropdownItem
#### 简介
下拉菜单内容
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowIcon | IconData? | - | 自定义箭头图标 |
| builder | TDDropdownItemContentBuilder? | - | 完全自定义展示内容 |
| controller | TDDropdownItemController? | - | 下拉菜单控制器 |
| disabled | bool? | false | 是否禁用 |
| key |  | - |  |
| label | String? | - | 标题 |
| maxHeight | double? | - | 内容最大高度 |
| minHeight | double? | - | 内容最小高度 |
| multiple | bool? | false | 是否多选 |
| onChange | ValueChanged<T?>? | - | 值改变时触发 |
| onConfirm | ValueChanged<T?>? | - | 点击确认时触发 |
| onReset | VoidCallback? | - | 点击重置时触发 |
| options | List<TDDropdownItemOption>? | const [] | 选项数据 |
| optionsColumns | int? | 1 | 选项分栏（1-3） |
| tabBarAlign | MainAxisAlignment? | - | [label]和[arrowIcon]/[TDDropdownMenu.arrowIcon]的对齐方式 |
| tabBarFlex | int? | 1 | 该item在menu上的宽度占比，仅在[TDDropdownMenu.isScrollable]为false时有效 |
| tabBarWidth | double? | - | 该item在menu上的宽度，仅在[TDDropdownMenu.isScrollable]为true时有效 |

```
```
 ### TDDropdownItemOption
#### 简介
选项数据
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool? | false | 是否禁用 |
| disabledColor | Color? | - | 禁用颜色 |
| group | String? | - | 分组，相同的为一组 |
| label | String | - | 选项标题 |
| selected | bool | false | 是否选中 |
| selectedColor | Color? | - | 选中颜色 |
| value | String | - | 选项值 |
