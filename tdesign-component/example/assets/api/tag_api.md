## API
### TTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| backgroundColor | Color? | - | 背景颜色，优先级高于style的backgroundColor |
| disable | bool | false | 是否为禁用状态 |
| fixedWidth | double? | - | 标签的固定宽度 |
| font | Font? | - | 字体尺寸，优先级高于style的font |
| fontWeight | FontWeight? | - | 字体粗细，优先级高于style的fontWeight |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| isLight | bool | false | 是否为浅色 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| shape | TTagShape | TTagShape.square | 标签形状 |
| size | TTagSize | TTagSize.medium | 标签大小 |
| style | TTagStyle? | - | 标签样式 |
| textColor | Color? | - | 文字颜色，优先级高于style的textColor |
| theme | TTagTheme? | - | 主题 |


### TSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| disableSelect | bool | false | 是否禁用选择 |
| disableSelectStyle | TTagStyle? | - | 不可选标签样式 |
| fixedWidth | double? | - | 标签的固定宽度 |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| isLight | bool | false | 是否为浅色 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| isSelected | bool | false | 是否选中 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| onSelectChanged | ValueChanged<bool>? | - | 标签点击，选中状态改变时的回调 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| selectStyle | TTagStyle? | - | 选中的标签样式 |
| shape | TTagShape | TTagShape.square | 标签形状 |
| size | TTagSize | TTagSize.medium | 标签大小 |
| theme | TTagTheme? | - | 主题 |
| unSelectStyle | TTagStyle? | - | 未选中标签样式 |


### TTagStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| border | double | 0 | 线框粗细 |
| borderColor | Color? | - | 边框颜色 |
| borderRadius | BorderRadiusGeometry? | - | 圆角 |
| context | BuildContext? | - | 上下文，方便获取主题内容 |
| font | Font? | - | 字体尺寸 |
| fontWeight | FontWeight? | - | 字体粗细 |
| textColor | Color? | - | 文字颜色 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeIconColor | Color? | - | 关闭图标颜色 |


#### 工厂构造方法

##### TTagStyle.generateDisableSelectStyle

根据主题生成禁用Tag样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文，方便获取主题内容 |
| isLight | bool | - | - |
| isOutline | bool | - | - |
| shape | TTagShape | - | - |


##### TTagStyle.generateFillStyleByTheme

根据主题生成填充Tag样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文，方便获取主题内容 |
| theme | TTagTheme? | - | - |
| light | bool | - | - |
| shape | TTagShape | - | - |


##### TTagStyle.generateOutlineStyleByTheme

根据主题生成描边Tag样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文，方便获取主题内容 |
| theme | TTagTheme? | - | - |
| light | bool | - | - |
| shape | TTagShape | - | - |


### TTagTheme
#### 简介
Tag展示类型
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认 |
| primary | 常规 |
| warning | 警告 |
| danger | 危险 |
| success | 成功 |


### TTagSize
#### 简介
标签尺寸
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| extraLarge | - |
| large | - |
| medium | - |
| small | - |
| custom | - |


### TTagShape
#### 简介
标签形状
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | - |
| round | - |
| mark | - |
