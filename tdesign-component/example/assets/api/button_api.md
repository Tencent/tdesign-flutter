## API
### TDButtonStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| frameColor | Color? | - | 边框颜色 |
| frameWidth | double? | - | 边框宽度 |
| radius | BorderRadiusGeometry? | - | 自定义圆角 |
| textColor | Color? | - | 文字颜色 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDButtonStyle.generateFillStyleByTheme  | 生成不同主题的填充按钮样式 |
| TDButtonStyle.generateGhostStyleByTheme  | 生成不同主题的幽灵按钮样式 |
| TDButtonStyle.generateOutlineStyleByTheme  | 生成不同主题的描边按钮样式 |
| TDButtonStyle.generateTextStyleByTheme  | 生成不同主题的文本按钮样式 |

```
```
 ### TDButton
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeStyle | TDButtonStyle? | - | 自定义点击样式，有则优先用它，没有则根据 type 和 theme 选取 |
| child | Widget? | - | 自控件 |
| disabled | bool | false | 禁止点击 |
| disableStyle | TDButtonStyle? | - | 自定义禁用样式，有则优先用它，没有则根据 type 和 theme 选取 |
| disableTextStyle | TextStyle? | - | 自定义不可点击状态文本样式 |
| height | double? | - | 自定义高度 |
| icon | IconData? | - | 图标icon |
| iconPosition | TDButtonIconPosition? | TDButtonIconPosition.left | 图标位置 |
| iconTextSpacing | double? | - | 自定义图标与文本之间距离 |
| iconWidget | Widget? | - | 自定义图标 icon 控件 |
| isBlock | bool | false | 是否为通栏按钮 |
| key |  | - |  |
| margin | EdgeInsetsGeometry? | - | 自定义 margin |
| onLongPress | TDButtonEvent? | - | 长按事件 |
| onTap | TDButtonEvent? | - | 点击事件 |
| padding | EdgeInsetsGeometry? | - | 自定义 padding |
| shape | TDButtonShape | TDButtonShape.rectangle | 形状：圆角，胶囊，方形，圆形，填充 |
| size | TDButtonSize | TDButtonSize.medium | 尺寸 |
| style | TDButtonStyle? | - | 自定义样式，有则优先用它，没有则根据 type 和 theme 选取。如果设置了 style，则 activeStyle 和 disableStyle 也应该设置 |
| text | String? | - | 文本内容 |
| textStyle | TextStyle? | - | 自定义可点击状态文本样式 |
| theme | TDButtonTheme? | - | 主题 |
| type | TDButtonType | TDButtonType.fill | 类型：填充，描边，文字 |
| width | double? | - | 自定义宽度 |
