## API
### TDropdownMenu
#### 简介
下拉菜单
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builder | TDropdownItemBuilder<T>? | - | 下拉菜单构建器，优先级高于`items` |
| closeOnClickOverlay | bool? | true | 是否在点击遮罩层后关闭菜单 |
| direction | TDropdownMenuDirection? | TDropdownMenuDirection.auto | 菜单展开方向（down、up、auto） |
| duration | double? | 200.0 | 动画时长，毫秒 |
| isScrollable | bool? | false | 是否开启滚动列表 |
| items | List<TDropdownItem<T>>? | - | 下拉菜单 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| labelBuilder | LabelBuilder? | - | 自定义标签内容 |
| onMenuClosed | ValueChanged<int>? | - | 关闭菜单事件 |
| onMenuOpened | ValueChanged<int>? | - | 展开菜单事件 |
| showOverlay | bool? | true | 是否显示遮罩层 |


### TDropdownItem
#### 简介
下拉菜单内容
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowColor | Color? | - | 自定义箭头颜色 |
| arrowIcon | IconData? | - | 自定义箭头图标 |
| builder | TDropdownItemContentBuilder? | - | 完全自定义展示内容 |
| disabled | bool | false | 是否禁用 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 标题 |
| maxHeight | double? | - | 内容最大高度 |
| minHeight | double? | - | 内容最小高度 |
| multiple | bool | false | 是否多选 |
| onChanged | ValueChanged<T?>? | - | 单选值变化 |
| onConfirm | ValueChanged<Set<T>>? | - | 点击确认时触发 |
| onReset | VoidCallback? | - | 点击重置时触发 |
| onValuesChanged | ValueChanged<Set<T>>? | - | 多选值变化 |
| options | List<TDropdownItemOption<T>> | const [] | 不可变选项数据 |
| optionsColumns | int | 1 | 选项分栏数 |
| tabBarAlign | MainAxisAlignment? | - | 标签和箭头的对齐方式 |
| tabBarFlex | int | 1 | item 在非滚动菜单栏中的宽度占比 |
| tabBarWidth | double? | - | item 在可滚动菜单栏中的宽度 |
| value | T? | - | 单选值 |
| values | Set<T> | const {} | 多选值 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| operateHeight | double | - | 多选模式下重置和确认操作区的固定高度。 |


### TDropdownItemOption
#### 简介
不可变下拉选项
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用 |
| disabledColor | Color? | - | 禁用颜色 |
| group | String? | - | 分组名 |
| label | String | - | 选项标题 |
| selectedColor | Color? | - | 选中颜色 |
| value | T | - | 选项值 |


### TDropdownMenuDirection
#### 简介
菜单展开方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| down | 向下 |
| up | 向上 |
| auto | 根据内容高度动态展示方向 |


### TDropdownItemBuilder
#### 简介
下拉菜单构建器
#### 类型定义

```dart
typedef TDropdownItemBuilder = List<TDropdownItem<T>> Function(BuildContext context);
```


### LabelBuilder
#### 简介
自定义标签内容
#### 类型定义

```dart
typedef LabelBuilder = Widget Function(BuildContext context, String label, bool isOpened, int index);
```


### TDropdownItemContentBuilder
#### 简介
下拉菜单自定义内容构建器
#### 类型定义

```dart
typedef TDropdownItemContentBuilder = Widget Function(BuildContext context);
```
