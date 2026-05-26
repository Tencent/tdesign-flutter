## API
### TActionSheetItem
#### 简介
动作面板项目
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 角标 |
| description | String? | - | 描述信息 |
| disabled | bool | false | 是否禁用 |
| group | String? | - | 分组，用于带描述多行滚动宫格 当[TActionSheet.theme]等于[TActionSheetTheme.group]时有效 有效时，如果该值未配置整个[TActionSheetItem]会被忽略，即不会展示 |
| icon | Widget? | - | 图标 |
| iconSize | double? | - | 图标大小 |
| label | String | - | 标题 |
| textStyle | TextStyle? | - | 标题样式 |


### TActionSheet
#### 简介
动作面板
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| align | TActionSheetAlign | TActionSheetAlign.center | 对齐方式 |
| cancelText | String? | - | 取消按钮的文本 |
| closeOnOverlayClick | bool | true | 点击蒙层时是否关闭 |
| count | int | 8 | 每页显示的项目数 当[theme]等于[TActionSheetTheme.grid]且[showPagination]为true时有效 |
| description | String? | - | 描述文本 当[theme]等于[TActionSheetTheme.grid]或[theme]等于[TActionSheetTheme.list]时有效 |
| itemHeight | double | 96.0 | 项目的行高 当[theme]等于[TActionSheetTheme.grid]或[theme]等于[TActionSheetTheme.group]时有效 |
| itemMinWidth | double | 80.0 | 项目的最小宽度 当[theme]等于[TActionSheetTheme.grid]且[scrollable]为true时有效 或当[theme]等于[TActionSheetTheme.group]时有效 |
| items | List<TActionSheetItem> | - | ActionSheet的项目列表 |
| onCancel | VoidCallback? | - | 取消按钮的回调函数 |
| onClose | VoidCallback? | - | 关闭时的回调函数 |
| onSelected | TActionSheetItemCallback? | - | 选择项目时的回调函数 |
| rows | int | 2 | 显示的行数 当[theme]等于[TActionSheetTheme.grid]时有效 |
| scrollable | bool | false | 是否可以横向滚动 当[theme]等于[TActionSheetTheme.grid]且[showPagination]为false时有效 |
| showCancel | bool | true | 是否显示取消按钮 |
| showOverlay | bool | true | 是否显示遮罩层 |
| showPagination | bool | false | 是否显示分页 当[theme]等于[TActionSheetTheme.grid]时有效 |
| theme | TActionSheetTheme | TActionSheetTheme.list | 主题样式 |
| useSafeArea | bool | true | 使用安全区域 |
| visible | bool | false | 是否立即显示 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showGridActionSheet | void | required BuildContext context, required List<TActionSheetItem> items, TActionSheetAlign align, String? cancelText, bool showCancel, TActionSheetItemCallback? onSelected, bool showOverlay, bool closeOnOverlayClick, int count, int rows, double itemHeight, double itemMinWidth, bool scrollable, bool showPagination, VoidCallback? onCancel, String? description, VoidCallback? onClose, bool useSafeArea | 显示宫格类型面板 |
| showGroupActionSheet | void | required BuildContext context, required List<TActionSheetItem> items, TActionSheetAlign align, String? cancelText, bool showCancel, TActionSheetItemCallback? onSelected, bool showOverlay, bool closeOnOverlayClick, double itemHeight, double itemMinWidth, VoidCallback? onCancel, VoidCallback? onClose, bool useSafeArea | 显示分组类型面板 |
| showListActionSheet | void | required BuildContext context, required List<TActionSheetItem> items, TActionSheetAlign align, String? cancelText, bool showCancel, VoidCallback? onCancel, TActionSheetItemCallback? onSelected, bool showOverlay, bool closeOnOverlayClick, VoidCallback? onClose, bool useSafeArea | 显示列表类型面板 |


### TActionSheetTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| list | - |
| grid | - |
| group | - |


### TActionSheetAlign
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| center | - |
| left | - |
| right | - |


### TActionSheetItemCallback
#### 类型定义

```dart
typedef TActionSheetItemCallback = void Function(TActionSheetItem item, int index);
```
