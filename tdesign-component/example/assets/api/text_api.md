## API
### TDText
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| data | null | data | 以下系统 text 属性，释义请参考系统 [Text] 中注释 |
| font | Font? | - | 字体尺寸，包含 大小size 和 行高height |
| fontFamily | FontFamily? | - | 字体ttf |
| fontFamilyUrl | String? | - | 是否禁用懒加载 FontFamily 的能力 |
| fontWeight | FontWeight? | - | 字体粗细 |
| forceVerticalCenter | bool | false | 是否强制居中 |
| isInFontLoader | bool | false | 是否在 FontLoader 中使用 |
| isTextThrough | bool? | false | 是否是横线穿过样式（删除线） |
| key |  | - |  |
| lineThroughColor | Color? | - | 删除线颜色，对应 TestStyle 的 decorationColor |
| locale |  | - |  |
| maxLines |  | - |  |
| overflow |  | - |  |
| package | String? | - | 字体包名 |
| semanticsLabel |  | - |  |
| softWrap |  | - |  |
| strutStyle |  | - |  |
| style | TextStyle? | - | 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性 |
| textAlign |  | - |  |
| textColor | Color? | - | 文本颜色 |
| textDirection |  | - |  |
| textHeightBehavior |  | - |  |
| textScaleFactor |  | - |  |
| textWidthBasis |  | - |  |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDText.rich  | 富文本构造方法 |

```
```
 ### TDTextSpan
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children |  | - |  |
| context |  | - |  |
| font |  | - |  |
| fontFamily |  | - |  |
| fontWeight |  | - |  |
| isTextThrough |  | false |  |
| lineThroughColor |  | - |  |
| mouseCursor |  | - |  |
| onEnter |  | - |  |
| onExit |  | - |  |
| package |  | - |  |
| recognizer |  | - |  |
| semanticsLabel |  | - |  |
| style |  | - |  |
| text |  | - |  |
| textColor |  | - |  |

```
```
 ### TDTextConfiguration
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child |  | - |  |
| globalFontFamily | FontFamily? | - | 全局字体，kTextNeedGlobalFontFamily=true 时生效 |
| key |  | - |  |
| paddingConfig | TDTextPaddingConfig? | - | forceVerticalCenter=true 时，内置 padding 配置 |
