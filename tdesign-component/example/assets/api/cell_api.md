## API
### TDCellStyle
#### 简介
单元格组件样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowColor | Color? | - | 箭头颜色 |
| backgroundColor | Color? | - | 默认状态背景颜色 |
| borderedColor | Color? | - | 单元格边框颜色 |
| cardBorderRadius | BorderRadius? | - | 卡片模式边框圆角 |
| cardPadding | EdgeInsets? | - | 卡片模式内边距 |
| clickBackgroundColor | Color? | - | 点击状态背景颜色 |
| context | BuildContext? | - | 传递context，会生成默认样式 |
| descriptionStyle | TextStyle? | - | 内容描述文字样式 |
| groupBorderedColor | Color? | - | 单元格组边框颜色 |
| groupTitleStyle | TextStyle? | - | 单元组标题文字样式 |
| leftIconColor | Color? | - | 左侧图标颜色 |
| noteStyle | TextStyle? | - | 说明文字样式 |
| padding | EdgeInsets? | - | 单元格内边距 |
| requiredStyle | TextStyle? | - | 必填星号文字样式 |
| rightIconColor | Color? | - | 右侧图标颜色 |
| titleBackgroundColor | Color? | - | 单元格组标题背景颜色 |
| titlePadding | EdgeInsets? | - | 单元格组标题内边距 |
| titleStyle | TextStyle? | - | 标题文字样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDCellStyle.cellStyle  | 生成单元格默认样式 |

```
```
 ### TDCell
#### 简介
单元格组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TDCellAlign? | TDCellAlign.middle | 内容的对齐方式，默认居中对齐。可选项：top/middle/bottom |
| arrow | bool? | false | 是否显示右侧箭头 |
| bordered | bool? | true | 是否显示下边框，仅在TDCellGroup组件下起作用 |
| description | String? | - | 下方内容描述文字 |
| descriptionWidget | Widget? | - | 下方内容描述组件 |
| disabled | bool? | false | 禁用 |
| height | double? | - | 高度 |
| hover | bool? | true | 是否开启点击反馈 |
| image | ImageProvider? | - | 主图 |
| imageCircle | double? | 50 | 主图圆角，默认50（圆形） |
| imageSize | double? | - | 主图尺寸 |
| imageWidget | Widget? | - | 主图组件 |
| key |  | - |  |
| leftIcon | IconData? | - | 左侧图标，出现在单元格标题的左侧 |
| leftIconWidget | Widget? | - | 左侧图标组件 |
| note | String? | - | 和标题同行的说明文字 |
| noteMaxLine | int | 1 | 说明文字组件 最大行数 |
| noteMaxWidth | double? | - | 说明文字组件 最大宽度，超过部分显示省略号，防止文字溢出 |
| noteWidget | Widget? | - | 说明文字组件 |
| onClick | TDCellClick? | - | 点击事件 |
| onLongPress | TDCellClick? | - | 长按事件 |
| required | bool? | false | 是否显示表单必填星号 |
| rightIcon | IconData? | - | 最右侧图标 |
| rightIconWidget | Widget? | - | 最右侧图标组件 |
| showBottomBorder | bool? | false | 是否显示下边框（建议TDCellGroup组件下false，避免与bordered重叠） |
| style | TDCellStyle? | - | 自定义样式 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |

```
```
 ### TDCellGroup
#### 简介
单元格组组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bordered | bool? | false | 是否显示组边框 |
| builder | CellBuilder? | - | cell构建器，可自定义cell父组件，如Dismissible |
| cells | List<TDCell> | - | 单元格列表 |
| isShowLastBordered | bool? | false | 是否显示最后一个cell的下边框 |
| key |  | - |  |
| scrollable | bool? | false | 可滚动 |
| style | TDCellStyle? | - | 自定义样式 |
| theme | TDCellGroupTheme? | TDCellGroupTheme.defaultTheme | 单元格组风格。可选项：default/card |
| title | String? | - | 单元格组标题 |
| titleWidget | Widget? | - | 单元格组标题组件 |
