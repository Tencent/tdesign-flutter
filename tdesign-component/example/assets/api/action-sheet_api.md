## API
### TDActionSheetItem
#### 简介
动作面板项目
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TDBadge? | - | 角标 |
| disabled | bool | false | 是否禁用 |
| group | String? | - | 分组，用于带描述多行滚动宫格 |
| icon | Widget? | - | 图标 |
| iconSize | double? | - | 图标大小 |
| label | String | - | 标题 |
| textStyle | TextStyle? | - | 标题样式 |

```
```
 ### TDActionSheet
#### 简介
动作面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TDActionSheetAlign | TDActionSheetAlign.center | 对齐方式 |
| cancelText | String? | - | 取消按钮的文本 |
| closeOnOverlayClick | bool | true | 点击蒙层时是否关闭 |
| context | BuildContext | context | 上下文 |
| count | int | 8 | 每页显示的项目数 |
| description | String? | - | 描述文本 |
| itemHeight | double | 96.0 | 项目的行高 |
| itemMinWidth | double | 80.0 | 项目的最小宽度 |
| items | List<TDActionSheetItem> | - | ActionSheet的项目列表 |
| onCancel | VoidCallback? | - | 取消按钮的回调函数 |
| onClose | VoidCallback? | - | 关闭时的回调函数 |
| onSelected | TDActionSheetItemCallback? | - | 选择项目时的回调函数 |
| rows | int | 2 | 显示的行数 |
| scrollable | bool | false | 是否可以横向滚动 |
| showCancel | bool | true | 是否显示取消按钮 |
| showOverlay | bool | true | 是否显示遮罩层 |
| showPagination | bool | false | 是否显示分页 |
| theme | TDActionSheetTheme | TDActionSheetTheme.list | 主题样式 |
| useSafeArea | bool | true | 使用安全区域 |
| visible | bool | false | 是否立即显示 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showGridActionSheet |  |   required BuildContext context,  required List<TDActionSheetItem> items,  TDActionSheetAlign align,  String? cancelText,  bool showCancel,  TDActionSheetItemCallback? onSelected,  bool showOverlay,  bool closeOnOverlayClick,  int count,  int rows,  double itemHeight,  double itemMinWidth,  bool scrollable,  bool showPagination,  VoidCallback? onCancel,  String? description,  VoidCallback? onClose,  bool useSafeArea, | 显示宫格类型面板 |
| showGroupActionSheet |  |   required BuildContext context,  required List<TDActionSheetItem> items,  TDActionSheetAlign align,  String? cancelText,  bool showCancel,  TDActionSheetItemCallback? onSelected,  bool showOverlay,  bool closeOnOverlayClick,  double itemHeight,  double itemMinWidth,  VoidCallback? onCancel,  VoidCallback? onClose,  bool useSafeArea, | 显示分组类型面板 |
| showListActionSheet |  |   required BuildContext context,  required List<TDActionSheetItem> items,  TDActionSheetAlign align,  String? cancelText,  bool showCancel,  VoidCallback? onCancel,  TDActionSheetItemCallback? onSelected,  bool showOverlay,  bool closeOnOverlayClick,  VoidCallback? onClose,  bool useSafeArea, | 显示列表类型面板 |
