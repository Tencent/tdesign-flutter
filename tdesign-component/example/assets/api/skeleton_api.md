## API
### TSkeleton

#### 工厂构造方法

##### TSkeleton.custom

使用自定义行列布局创建骨架屏。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| layout | TSkeletonLayout | - | 自定义布局；预设形态时为空。 |
| animation | TSkeletonAnimation? | - | 动画效果；为 null 时保持静态。 |
| delay | Duration | Duration.zero | 骨架屏的延迟显示时间，用于避免短请求产生闪烁。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animation | TSkeletonAnimation? | - | 动画效果；为 null 时保持静态。 |
| delay | Duration | Duration.zero | 骨架屏的延迟显示时间，用于避免短请求产生闪烁。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| variant | TSkeletonVariant? | TSkeletonVariant.text | 预设形态；自定义布局时为空。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| layout | TSkeletonLayout? | - | 自定义布局；预设形态时为空。 |


### TSkeletonLayout
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rows | List<List<TSkeletonBlock>> | - | 每个内层列表表示一行骨架块。 |
| rowSpacing | double? | - | 行间距；未设置时读取组件主题和 TDesign token。 |


### TSkeletonBlockStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| borderRadius | double? | - | 骨架块圆角；优先于 `shape` 和组件主题。 |
| color | Color? | - | 骨架块颜色；优先于组件主题。 |
| shape | TSkeletonBlockShape | TSkeletonBlockShape.rounded | 骨架块形状。 |


### TSkeletonBlock

#### 工厂构造方法

##### TSkeletonBlock.circle

圆形占位块。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | 48 | 宽度。 |
| height | double? | 48 | 高度。 |
| flex | int? | - | 同一行内的弹性因子；为 null 时按固定宽度布局。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle(shape: TSkeletonBlockShape.circle) | 视觉样式。 |


##### TSkeletonBlock.line

文本行占位块。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度。 |
| height | double? | 16 | 高度。 |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle() | 视觉样式。 |


##### TSkeletonBlock.rectangle

无圆角矩形占位块。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度。 |
| height | double? | 16 | 高度。 |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle(shape: TSkeletonBlockShape.rectangle) | 视觉样式。 |


##### TSkeletonBlock.spacer

透明间隔块。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度。 |
| height | double? | - | 高度。 |
| flex | int? | - | 同一行内的弹性因子；为 null 时按固定宽度布局。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 |
| height | double? | 16 | 高度。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle() | 视觉样式。 |
| width | double? | - | 宽度。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isSpacer | bool | - | 是否是透明间隔块。 |


### TSkeletonAnimation
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| gradient | 高亮渐变扫过骨架块。 |
| flashed | 骨架块透明度闪烁。 |


### TSkeletonVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| avatar | 头像占位。 |
| image | 图片占位。 |
| text | 双行文本占位。 |
| paragraph | 四行段落占位。 |


### TSkeletonBlockShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| rounded | 使用组件主题或 TDesign token 提供的圆角。 |
| circle | 圆形或胶囊形。 |
| rectangle | 无圆角矩形。 |
