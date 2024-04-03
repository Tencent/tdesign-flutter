## API
### TDDropdownMenu
#### 简介
下拉菜单
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| items | List<TDDropdownItem<T>> | - | 下拉菜单列表 |
| closeOnClickOverlay | bool | true | 是否在点击遮罩层后关闭菜单 |
| direction | TDDropdownMenuDirection | TDDropdownMenuDirection.down | 菜单展开方向 |
| duration | double | 200.0 | 动画时长 |
| showOverlay | bool | true | 是否显示遮罩层 |
| arrowIcons | List<Icon>? | const [Icon(TDIcons.caret_up_small), Icon(TDIcons.caret_down_small)] | 自定义箭头图标[关闭,展开] |
| onMenuOpened | ValueChanged<TDDropdownItem<T>>? | - | 展开菜单事件 |
| onMenuClosed | ValueChanged<TDDropdownItem<T>>? | - | 关闭菜单事件 |

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
| keys | TDDropdownItemKeys? | - | 用来定义 value / label 在 options 中对应的字段别名 |
| label | String? | - | 标题 |
| multiple | bool? | false | 是否多选 |
| options | List<TDDropdownItemOptions<T>> | const [] | 选项数据 |
| optionsColumns | int? | 1 | 选项分栏（1-3） |
| value | T? | - | 选中值 |
| onChange | ValueChanged<T>? | - | 值改变时触发 |
| onConfirm | ValueChanged<T>? | - | 点击确认时触发 |
| onReset | ValueChanged<T>? | - | 点击重置时触发 |

```
```
 ### TDDropdownItemKeys
#### 简介
用来定义 value / label 在 options 中对应的字段别名
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| value | String? | 'value' | options的值的key |
| label | String? | 'label' | options的标题的key |

```
```
 ### TDDropdownItemOptions
#### 简介
选项数据
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| value | T | - | 选项值 |
| label | String | - | 选项标题 |
| disabled | bool? | false | 是否禁用 |
