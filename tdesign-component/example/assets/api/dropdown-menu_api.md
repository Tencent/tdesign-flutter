## API
### TDDropdownMenu
#### 简介
下拉菜单
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| builder | TDDropdownItemBuilder | - | 下拉菜单构建器 |
| closeOnClickOverlay | bool? | true | 是否在点击遮罩层后关闭菜单 |
| direction | TDDropdownMenuDirection? | TDDropdownMenuDirection.auto | 菜单展开方向（down、up、auto） |
| duration | double? | 200.0 | 动画时长，毫秒 |
| showOverlay | bool? | true | 是否显示遮罩层 |
| arrowIcon | IconData? | - | 自定义箭头图标 |
| onMenuOpened | ValueChanged<int>? | - | 展开菜单事件 |
| onMenuClosed | ValueChanged<int>? | - | 关闭菜单事件 |

```
```
 ### TDDropdownItem
#### 简介
下拉菜单
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| disabled | bool? | false | 是否禁用 |
| label | String? | - | 标题 |
| multiple | bool? | false | 是否多选 |
| options | List<TDDropdownItemOption>? | const [] | 选项数据 |
| builder | TDDropdownItemContentBuilder? | - | 完全自定义展示内容 |
| optionsColumns | int? | 1 | 选项分栏（1-3） |
| onChange | ValueChanged<T?>? | - | 值改变时触发 |
| onConfirm | ValueChanged<T?>? | - | 点击确认时触发 |
| onReset | VoidCallback? | - | 点击重置时触发 |
| minHeight | double? | - | 内容最小高度 |
| maxHeight | double? | - | 内容最大高度 |

```
```
 ### TDDropdownItemOption
#### 简介
选项数据
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| value | String | - | 选项值 |
| label | String | - | 选项标题 |
| disabled | bool? | false | 是否禁用 |
| group | String? | - | 分组，相同的为一组 |
| selected | bool? | false | 是否选中 |
