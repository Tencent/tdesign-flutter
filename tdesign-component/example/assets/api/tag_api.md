## API
### TDTagStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext? | - | 上下文，方便获取主题内容 |
| textColor | Color? | - | 文字颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| font | Font? | - | 字体尺寸 |
| fontWeight | FontWeight? | - | 字体粗细 |
| border | double | 0 | 线框粗细 |
| borderColor | Color? | - | 边框颜色 |
| borderRadius | BorderRadiusGeometry? | - | 圆角 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDTagStyle.generateFillStyleByTheme  | 根据主题生成填充Tag样式 |
| TDTagStyle.generateOutlineStyleByTheme  | 根据主题生成描边Tag样式 |
| TDTagStyle.generateDisableSelectStyle  | 根据主题生成禁用Tag样式 |

```
```
 ### TDTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | text | 标签内容 |
| theme | TDTagTheme? | - | 主题 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| textColor | Color? | - | 文字颜色, 优先级高于style的textColor |
| backgroundColor | Color? | - | 背景颜色, 优先级高于style的backgroundColor |
| font | Font? | - | 字体尺寸, 优先级高于style的font |
| fontWeight | FontWeight? | - | 字体粗细, 优先级高于style的fontWeight |
| style | TDTagStyle? | - | 标签样式 |
| size | TDTagSize | TDTagSize.medium | 标签大小 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| shape | TDTagShape | TDTagShape.square | 标签形状 |
| isLight | bool | false | 是否为浅色 |
| disable | bool | false | 是否为禁用状态 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| fixedWidth | double? | - | 标签的固定宽度 |
| key |  | - |  |

```
```
 ### TDSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | text | 标签内容 |
| theme | TDTagTheme? | - | 主题 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| selectStyle | TDTagStyle? | - | 选中的标签样式 |
| unSelectStyle | TDTagStyle? | - | 未选中标签样式 |
| disableSelectStyle | TDTagStyle? | - | 不可选标签样式 |
| onSelectChanged | ValueChanged<bool>? | - | 标签点击，选中状态改变时的回调 |
| isSelected | bool | false | 是否选中 |
| disableSelect | bool | false | 是否禁用选择 |
| size | TDTagSize | TDTagSize.medium | 标签大小 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| shape | TDTagShape | TDTagShape.square | 标签形状 |
| isLight | bool | false | 是否为浅色 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| fixedWidth | double? | - | 标签的固定宽度 |
| key |  | - |  |
