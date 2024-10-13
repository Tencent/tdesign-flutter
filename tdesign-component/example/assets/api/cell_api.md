## API
### TDCellStyle
#### 简介
单元格组件样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| leftIconColor | Color? | - | 左侧图标颜色 |
| titleStyle | TextStyle? | - | 标题文字样式 |
| requiredStyle | TextStyle? | - | 必填星号文字样式 |
| descriptionStyle | TextStyle? | - | 内容描述文字样式 |
| noteStyle | TextStyle? | - | 说明文字样式 |
| arrowColor | Color? | - | 箭头颜色 |
| borderedColor | Color? | - | 单元格边框颜色 |
| groupBorderedColor | Color? | - | 单元格组边框颜色 |
| backgroundColor | Color? | - | 默认状态背景颜色 |
| padding | EdgeInsets? | - | 单元格内边距 |


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
| key |  | - |  |
| align | TDCellAlign? | TDCellAlign.middle | 内容的对齐方式，默认居中对齐。可选项：top/middle/bottom |
| arrow | bool? | false | 是否显示右侧箭头 |
| bordered | bool? | true | 是否显示下边框，仅在TDCellGroup组件下起作用 |
| description | String? | - | 下方内容描述文字 |
| descriptionWidget | Widget? | - | 下方内容描述组件 |
| hover | bool? | true | 是否开启点击反馈 |
| image | ImageProvider? | - | 主图 |
| imageSize | double? | - | 主图尺寸 |
| imageWidget | Widget? | - | 主图组件 |
| leftIcon | IconData? | - | 左侧图标，出现在单元格标题的左侧 |
| leftIconWidget | Widget? | - | 左侧图标组件 |
| note | String? | - | 和标题同行的说明文字 |
| noteWidget | Widget? | - | 说明文字组件 |
| required | bool? | false | 是否显示表单必填星号 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| onClick | TDCellClick? | - | 点击事件 |
| onLongPress | TDCellClick? | - | 长按事件 |
| style | TDCellStyle? | - | 自定义样式 |
| rightIcon | IconData? | - | 最右侧图标 |
| rightIconWidget | Widget? | - | 最右侧图标组件 |
| disabled | bool? | false | 禁用 |
| imageCircle | double? | 50 | 主图圆角，默认50（圆形） |

```
```
 ### TDCellGroup
#### 简介
单元格组组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| bordered | bool? | false | 是否显示组边框 |
| theme | TDCellGroupTheme? | TDCellGroupTheme.defaultTheme | 单元格组风格。可选项：default/card |
| title | String? | - | 单元格组标题 |
| cells | List<TDCell> | - | 单元格列表 |
| builder | CellBuilder? | - | cell构建器，可自定义cell父组件，如Dismissible |
| style | TDCellStyle? | - | 自定义样式 |
| titleWidget | Widget? | - | 单元格组标题组件 |
| scrollable | bool? | false | 可滚动 |
| isShowLastBordered | bool? | false | 是否显示最后一个cell的下边框 |
