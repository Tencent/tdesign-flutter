## API
### TDNavBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| belowTitleWidget | Widget? | - | belowTitleWidget navbar 下方的 widget |
| border | TDNavBarItemBorder? | - | 边框 |
| boxShadow | List<BoxShadow>? | - | 底部阴影 |
| centerTitle | bool | true | 标题是否居中 |
| flexibleSpace | Widget? | - | 固定背景 |
| height | double | 48 | 高度 |
| key |  | - |  |
| leftBarItems | List<TDNavBarItem>? | - | 左边操作项 |
| onBack | VoidCallback? | - | 返回事件 |
| opacity | double | 1.0 | 透明度 |
| padding | EdgeInsetsGeometry? | - | 内部填充 |
| rightBarItems | List<TDNavBarItem>? | - | 右边操作项 |
| screenAdaptation | bool | true | 是否进行屏幕适配，默认 true |
| title | String? | - | 标题文案 |
| titleColor | Color? | - | 标题颜色 |
| titleFont | Font? | - | 标题字体尺寸 |
| titleFontFamily | FontFamily? | - | 标题字体样式 |
| titleFontWeight | FontWeight? | FontWeight.w500 | 标题字体粗细 |
| titleMargin | double | 16 | 中间文案左右两边间距 |
| titleWidget | Widget? | - | 标题控件，优先级高于 title 文案 |
| useBorderStyle | bool | false | 是否使用边框模式 |
| useDefaultBack | bool | true | 是否使用默认的返回 |

```
```
 ### TDNavBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | TDBarItemAction? | - | 操作回调 |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色 |
| iconSize | double? | 24.0 | 图标尺寸 |
| iconWidget | Widget? | - | 图标组件，优先级高于 icon |
| padding | EdgeInsetsGeometry? | - |  |
