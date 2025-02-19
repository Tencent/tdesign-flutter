## API
### TDActionSheetItem
#### 简介
动作面板项目
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String | - | 标提 |
| textStyle | TextStyle? | - | 标题样式 |
| icon | Widget? | - | 图标 |
| badge | TDBadge? | - | 角标 |
| disabled | bool | false | 是否禁用 |
| iconSize | double? | - | 图标大小 |
| group | String? | - | 分组 |

```
```
 ### TDActionSheet
#### 简介
动作面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | context | 上下文 |
| align | TDActionSheetAlign | TDActionSheetAlign.center | 对齐方式 |
| cancelText | String | '取消' | 取消按钮的文本 |
| count | int | 8 | 每页显示的项目数，当[showPagination]为true时有效 |
| rows | int | 2 | 显示的行数，当[TDActionSheetItem.group]有值时无效 |
| itemHeight | double | 96.0 | 项目的行高 |
| itemMinWidth | double | 80.0 | 项目的最小宽度，当[scrollable]为true时有效 |
| description | String? | - | 描述文本 |
| items | List<TDActionSheetItem> | - | ActionSheet的项目列表 |
| showCancel | bool | true | 是否显示取消按钮 |
| showPagination | bool | false | 是否显示分页 |
| scrollable | bool | false | 是否可以横向滚动，[showPagination]为true时无效 |
| theme | TDActionSheetTheme | TDActionSheetTheme.list | 主题样式 |
| visible | bool | false | 是否立即显示 |
| onCancel | VoidCallback? | - | 取消按钮的回调函数 |
| onClose | VoidCallback? | - | 关闭时的回调函数 |
| onSelected | TDActionSheetItemCallback? | - | 选择项目时的回调函数 |
| showOverlay | bool | true | 是否显示遮罩层 |
| closeOnOverlayClick | bool | true | 点击蒙层时是否关闭 |
