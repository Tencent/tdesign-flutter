## API
### TNavBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actions | List<TNavBarItem>? | - | 右侧操作项（对齐 AppBar.actions） |
| backgroundColor | Color? | - | 背景颜色 |
| backIconColor | Color? | - | 左边返回图标颜色 |
| belowTitleWidget | Widget? | - | NavBar 下方的 Widget |
| border | TNavBarBorder? | - | 操作项边框配置 |
| boxShadow | List<BoxShadow>? | - | 底部阴影 |
| centerTitle | bool | true | 标题是否居中 |
| flexibleSpace | Widget? | - | 固定背景 Widget |
| height | double? | - | 高度；作为 `PreferredSizeWidget.preferredSize` 的唯一高度来源 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| leading | List<TNavBarItem>? | - | 左侧操作项（对齐 AppBar.leading） |
| onBack | VoidCallback? | - | 返回事件；默认返回按钮点击时先触发该回调，再执行 Navigator.maybePop。 |
| opacity | double? | - | 透明度 |
| padding | EdgeInsetsGeometry? | - | 内部填充 |
| title | String? | - | 标题文案 |
| titleColor | Color? | - | 标题颜色 |
| titleFont | Font? | - | 标题字体尺寸 |
| titleFontFamily | FontFamily? | - | 标题字体样式 |
| titleFontWeight | FontWeight? | - | 标题字体粗细 |
| titleMargin | double? | - | 中间文案左右两边间距 |
| titleWidget | Widget? | - | 标题控件，优先级高于 `title` 文案 |
| useBorderStyle | bool? | - | 是否使用边框模式 |
| useDefaultBack | bool | true | 是否使用默认的返回按钮 |


### TNavBarItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | TBarItemAction? | - | 操作回调；`null` 表示禁用 |
| customWidget | Widget? | - | 自定义组件，优先级高于 icon，可以是任意 Widget |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色 |
| iconSize | double? | 24.0 | 图标尺寸 |
| padding | EdgeInsetsGeometry? | - | 内部填充 |


### TBarItemAction
#### 类型定义

```dart
typedef TBarItemAction = void Function();
```
