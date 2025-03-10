## API

### TDCellGroup
#### 默认构造方法
| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
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

### TDCellStyle
#### 默认构造方法
  
| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| context | BuildContext? | - | 传递context，会生成默认样式 |
| leftIconColor | Color? | - | 左侧图标颜色 |
| rightIconColor | Color? | - | 右侧图标颜色 |
| titleStyle | TextStyle? | - | 标题文字样式 |
| requiredStyle | TextStyle? | - | 必填星号文字样式 |
| descriptionStyle | TextStyle? | - | 内容描述文字样式 |
| noteStyle | TextStyle? | - | 说明文字样式 |
| arrowColor | Color? | - | 箭头颜色 |
| borderedColor | Color? | - | 单元格边框颜色 |
| groupBorderedColor | Color? | - | 单元格组边框颜色 |
| backgroundColor | Color? | - | 默认状态背景颜色 |
| clickBackgroundColor | Color? | - | 点击状态背景颜色 |
| groupTitleStyle | TextStyle? | - | 单元组标题文字样式 |
| padding | EdgeInsets? | - | 单元格内边距 |
| cardBorderRadius | BorderRadius? | - | 卡片模式边框圆角 |
| cardPadding | EdgeInsets? | - | 卡片模式内边距 |
| titlePadding | EdgeInsets? | - | 单元格组标题内边距 |