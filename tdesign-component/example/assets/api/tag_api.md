## API
### TTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| colorPreset | TTagColorPreset | TTagColorPreset.defaultTheme | 标签预设配色。 |
| enabled | bool | true | 是否使用禁用视觉状态。 |
| icon | IconData? | - | 前置图标，颜色与正文共用解析后的前景色；关闭图标使用独立颜色。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 是否显示关闭图标。 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件。 标签本身不持有列表状态；需要移除标签时，请在此回调中更新父组件的 数据源并触发重建。 |
| onTap | GestureTapCallback? | - | 标签点击回调；为空时不创建标签点击行为。 |
| shape | TTagShape | TTagShape.square | 标签外形；仅选择形状，具体圆角值由组件 Theme 或全局 Token 决定。 |
| size | TTagSize | TTagSize.medium | 标签大小 |
| variant | TTagVariant | TTagVariant.dark | 绘制形态。 |


### TSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容。 |
| colorPreset | TTagColorPreset | TTagColorPreset.primary | 选中态预设配色。 |
| icon | IconData? | - | 标签图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool>? | - | 选中状态变更回调；为空时禁用交互。 |
| shape | TTagShape | TTagShape.square | 标签外形；具体圆角值由组件 Theme 或全局 Token 决定。 |
| size | TTagSize | TTagSize.medium | 标签尺寸。 |
| value | bool | - | 当前选中状态。 |
| variant | TTagVariant | TTagVariant.dark | 标签绘制形态。 |


### TTagThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 所有启用 Tag 的统一背景色；优先于各配色预设的填充色。 |
| dangerColor | Color? | - | danger 预设的基础色；未设置时回退全局 errorColor。 |
| fixedWidth | double? | - | 标签固定宽度 |
| font | Font? | - | 字体尺寸和行高；未设置时随标签尺寸使用对应的全局字体 Token。 |
| maxLines | int? | - | 文字最大行数。 未设置时组件默认按紧凑标签语义使用单行。 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| padding | EdgeInsets? | - | 自定义间距 |
| squareBorderRadius | double? | - | 方形标签圆角，单位为逻辑像素；未设置时所有尺寸均读取全局 `radiusSmall`（当前默认 3dp）。 |
| successColor | Color? | - | success 预设的基础色；未设置时回退全局 successColor。 |
| successLightColor | Color? | - | success 预设的浅色填充；未设置时回退全局 successColor1。 |
| textColor | Color? | - | 所有启用 Tag 的正文和前置图标颜色；优先于配色预设的全局 Token。 禁用态不受此字段影响，关闭图标继续使用独立的占位色 Token。 |


### TTagColorPreset
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认中性色。 |
| primary | 品牌主色。 |
| warning | 警告色。 |
| danger | 危险色。 |
| success | 成功色。 |


### TTagSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| extraLarge | 超大尺寸。 |
| large | 大尺寸。 |
| medium | 中等尺寸。 |
| small | 小尺寸。 |
| custom | 由 Theme padding 和字体决定尺寸。 |


### TTagShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 小圆角矩形。 |
| round | 胶囊形。 |
| mark | 右侧胶囊标记形。 |


### TTagVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| dark | 深色填充。 |
| light | 浅色填充。 |
| outline | 描边。 |
| lightOutline | 浅色描边。 |
