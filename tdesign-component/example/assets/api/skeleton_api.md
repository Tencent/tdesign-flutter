## API

### TSkeleton

在内容加载前展示页面结构的占位组件。

#### 主题配置

组件主题通过 `TSkeletonThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TSkeletonThemeData` 说明。

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

骨架屏的行列布局。

#### 构造方法

##### TSkeletonLayout

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| rows | List&lt;List&lt;TSkeletonBlock&gt;&gt; | - | 每个内层列表表示一行骨架块。 | 是 |
| rowSpacing | double? | - | 行间距；未设置时读取组件主题和 TDesign token。 | 否 |


### TSkeletonBlockStyle

单个骨架块的视觉样式。

#### 构造方法

##### TSkeletonBlockStyle

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| borderRadius | double? | - | 骨架块圆角；优先于 `shape` 和组件主题。 | 否 |
| color | Color? | - | 骨架块颜色；优先于组件主题。 | 否 |
| shape | TSkeletonBlockShape | TSkeletonBlockShape.rounded | 骨架块形状。 | 否 |


### TSkeletonBlock

骨架屏中的一个占位块。

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


### TSkeletonThemeData

骨架屏组件级 ThemeExtension。

仅保存占位块的视觉和布局默认值；动画、延迟与具体布局由实例决定。

#### 构造方法

##### TSkeletonThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| blockColor | Color? | - | 占位块背景色。 未配置时使用 bgColorSecondaryContainer Token。 | 否 |
| borderRadius | double? | - | 普通占位块圆角。 未配置时使用 radiusSmall Token，必须大于或等于 0。 | 否 |
| highlightColor | Color? | - | 渐变动画高亮色。 未配置时使用 bgColorSecondaryContainerActive Token。 | 否 |
| rowSpacing | double? | - | 多行布局的默认行间距。 未配置时使用 spacer2 Token，必须大于或等于 0。 | 否 |


#### 实例方法

##### TSkeletonThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| blockColor | Color? | - | 字段含义：占位块背景色。 未配置时使用 bgColorSecondaryContainer Token。 调用时的空值行为见方法说明。 | 否 |
| highlightColor | Color? | - | 字段含义：渐变动画高亮色。 未配置时使用 bgColorSecondaryContainerActive Token。 调用时的空值行为见方法说明。 | 否 |
| borderRadius | double? | - | 字段含义：普通占位块圆角。 未配置时使用 radiusSmall Token，必须大于或等于 0。 调用时的空值行为见方法说明。 | 否 |
| rowSpacing | double? | - | 字段含义：多行布局的默认行间距。 未配置时使用 spacer2 Token，必须大于或等于 0。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSkeletonThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TSkeletonThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TSkeletonThemeData? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSkeletonThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TSkeletonAnimation

骨架屏动画。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| gradient | TSkeletonAnimation | - | 高亮渐变扫过骨架块。 | - |
| flashed | TSkeletonAnimation | - | 骨架块透明度闪烁。 | - |


### TSkeletonVariant

骨架屏预设形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| avatar | TSkeletonVariant | - | 头像占位。 | - |
| image | TSkeletonVariant | - | 图片占位。 | - |
| text | TSkeletonVariant | - | 双行文本占位。 | - |
| paragraph | TSkeletonVariant | - | 四行段落占位。 | - |


### TSkeletonBlockShape

骨架块形状。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| rounded | TSkeletonBlockShape | - | 使用组件主题或 TDesign token 提供的圆角。 | - |
| circle | TSkeletonBlockShape | - | 圆形或胶囊形。 | - |
| rectangle | TSkeletonBlockShape | - | 无圆角矩形。 | - |
