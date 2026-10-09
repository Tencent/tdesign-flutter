## API

### TSkeleton

#### 构造方法

##### TSkeleton

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| animation | TSkeletonAnimation? | - | 动画效果；为 null 时保持静态。 | 否 |
| delay | Duration | Duration.zero | 骨架屏的延迟显示时间，用于避免短请求产生闪烁。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| variant | TSkeletonVariant | TSkeletonVariant.text | 预设形态；自定义布局时为空。 | 否 |


##### TSkeleton.custom

使用自定义行列布局创建骨架屏。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TSkeletonLayout | - | 自定义布局；预设形态时为空。 | 是 |
| animation | TSkeletonAnimation? | - | 动画效果；为 null 时保持静态。 | 否 |
| delay | Duration | Duration.zero | 骨架屏的延迟显示时间，用于避免短请求产生闪烁。 | 否 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| layout | TSkeletonLayout? | - | 自定义布局；预设形态时为空。 | - |


### TSkeletonLayout

#### 构造方法

##### TSkeletonLayout

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| rows | List&lt;List&lt;TSkeletonBlock&gt;&gt; | - | 每个内层列表表示一行骨架块。 | 是 |
| rowSpacing | double? | - | 行间距；未设置时读取组件主题和 TDesign token。 | 否 |


### TSkeletonBlockStyle

#### 构造方法

##### TSkeletonBlockStyle

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| borderRadius | double? | - | 骨架块圆角；优先于 `shape` 和组件主题。 | 否 |
| color | Color? | - | 骨架块颜色；优先于组件主题。 | 否 |
| shape | TSkeletonBlockShape | TSkeletonBlockShape.rounded | 骨架块形状。 | 否 |


### TSkeletonBlock

#### 构造方法

##### TSkeletonBlock

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| height | double? | 16 | 高度。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle() | 视觉样式。 | 否 |
| width | double? | - | 宽度。 | 否 |


##### TSkeletonBlock.circle

圆形占位块。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| width | double? | 48 | 宽度。 | 否 |
| height | double? | 48 | 高度。 | 否 |
| flex | int? | - | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle(shape: TSkeletonBlockShape.circle) | 视觉样式。 | 否 |


##### TSkeletonBlock.line

文本行占位块。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| width | double? | - | 宽度。 | 否 |
| height | double? | 16 | 高度。 | 否 |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle() | 视觉样式。 | 否 |


##### TSkeletonBlock.rectangle

无圆角矩形占位块。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| width | double? | - | 宽度。 | 否 |
| height | double? | 16 | 高度。 | 否 |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle(shape: TSkeletonBlockShape.rectangle) | 视觉样式。 | 否 |


##### TSkeletonBlock.spacer

透明间隔块。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| width | double? | - | 宽度。 | 否 |
| height | double? | - | 高度。 | 否 |
| flex | int? | - | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| isSpacer | bool | - | 是否是透明间隔块。 | - |


### TSkeletonAnimation
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| gradient | TSkeletonAnimation | - | 高亮渐变扫过骨架块。 | - |
| flashed | TSkeletonAnimation | - | 骨架块透明度闪烁。 | - |


### TSkeletonVariant
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| avatar | TSkeletonVariant | - | 头像占位。 | - |
| image | TSkeletonVariant | - | 图片占位。 | - |
| text | TSkeletonVariant | - | 双行文本占位。 | - |
| paragraph | TSkeletonVariant | - | 四行段落占位。 | - |


### TSkeletonBlockShape
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| rounded | TSkeletonBlockShape | - | 使用组件主题或 TDesign token 提供的圆角。 | - |
| circle | TSkeletonBlockShape | - | 圆形或胶囊形。 | - |
| rectangle | TSkeletonBlockShape | - | 无圆角矩形。 | - |
