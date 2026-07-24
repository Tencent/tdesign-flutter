## API
### TTag
#### 简介
展示型标签组件，仅展示，内部不可更改自身状态
支持样式：方形/圆角/半圆/带关闭图标
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| colorScheme | TTagColorScheme? | - | 语义色 |
| enabled | bool | true | 是否使用禁用视觉状态。 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 是否显示关闭图标。 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| onTap | GestureTapCallback? | - | 标签点击回调；为空时不创建标签点击行为。 |
| size | TTagSize | TTagSize.medium | 标签大小 |


### TSelectTag
#### 简介
严格受控的可选标签。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容。 |
| colorScheme | TTagColorScheme? | - | 选中态语义色。 |
| icon | IconData? | - | 标签图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool>? | - | 选中状态变更回调；为空时禁用交互。 |
| size | TTagSize | TTagSize.medium | 标签尺寸。 |
| value | bool | - | 当前选中状态。 |


### TTagThemeData
#### 简介
标签组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认样式。
构造器参数优先于 Theme。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| colorScheme | TTagColorScheme? | - | 未传实例 colorScheme 时的默认语义色 |
| fixedWidth | double? | - | 标签固定宽度 |
| font | Font? | - | 字体尺寸 |
| fontWeight | FontWeight? | - | 字体粗细 |
| isLight | bool? | - | 是否为浅色 |
| isOutline | bool? | - | 是否为描边类型 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| padding | EdgeInsets? | - | 自定义间距 |
| shape | TTagShape? | - | 标签形状 |
| textColor | Color? | - | 文字颜色 |


### TTagSize
#### 简介
标签尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| extraLarge | 超大尺寸。 |
| large | 大尺寸。 |
| medium | 中等尺寸。 |
| small | 小尺寸。 |
| custom | 由 Theme padding 和字体决定尺寸。 |


### TTagShape
#### 简介
标签形状。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 小圆角矩形。 |
| round | 胶囊形。 |
| mark | 右侧胶囊标记形。 |


### TTagColorScheme
#### 简介
标签语义色。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认中性色。 |
| primary | 品牌主色。 |
| warning | 警告色。 |
| danger | 危险色。 |
| success | 成功色。 |
