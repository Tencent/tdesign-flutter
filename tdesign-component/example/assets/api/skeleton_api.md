## API
### TSkeleton

#### 工厂构造方法

##### TSkeleton.fromRowCol

从行列框架创建骨架屏

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| animation | TSkeletonAnimation? | - | 动画效果 |
| delay | int | 0 | 延迟显示加载时间 |
| rowCol | TSkeletonRowCol | - | 自定义行列数量、宽度高度、间距等 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animation | TSkeletonAnimation? | - | 设置动画效果。 |
| delay | int | 0 | 设置延迟显示的毫秒数。 |
| key | Key? | - | 用于区分或保留组件状态。 |
| variant | TSkeletonVariant | TSkeletonVariant.text | 设置预设骨架图形态。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowCol | TSkeletonRowCol | - | 自定义行列数量、宽度高度、间距等 |


### TSkeletonRowColStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| rowSpacing | double? | - | 行间距；未设置时读取 Theme 和 Token。 |


### TSkeletonRowCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| objects | List<List<TSkeletonRowColObj>> | - | 行列对象。 |
| style | TSkeletonRowColStyle | const TSkeletonRowColStyle() | 行布局样式。 |


### TSkeletonRowColObjStyle

#### 工厂构造方法

##### TSkeletonRowColObjStyle.circle

圆形块样式。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色；未设置时读取 Theme 和 Token。 |


##### TSkeletonRowColObjStyle.rect

无圆角矩形块样式。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色；未设置时读取 Theme 和 Token。 |


##### TSkeletonRowColObjStyle.text

文本块样式。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色；未设置时读取 Theme 和 Token。 |
| borderRadius | double? | - | 自定义圆角；优先于 `shape` 和 Theme。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色；未设置时读取 Theme 和 Token。 |
| borderRadius | double? | - | 自定义圆角；优先于 `shape` 和 Theme。 |
| shape | TSkeletonBlockShape | TSkeletonBlockShape.rounded | 骨架块形状。 |


### TSkeletonRowColObj

#### 工厂构造方法

##### TSkeletonRowColObj.circle

圆形元素。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | 48 | 宽度。 |
| height | double? | 48 | 高度。 |
| flex | int? | - | 弹性因子。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle.circle() | 视觉样式。 |


##### TSkeletonRowColObj.rect

无圆角矩形元素。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度。 |
| height | double? | 16 | 高度。 |
| flex | int? | 1 | 弹性因子。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle.rect() | 视觉样式。 |


##### TSkeletonRowColObj.spacer

透明占位元素。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度。 |
| height | double? | - | 高度。 |
| flex | int? | - | 弹性因子。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |


##### TSkeletonRowColObj.text

文本元素。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double? | - | 宽度。 |
| height | double? | 16 | 高度。 |
| flex | int? | 1 | 弹性因子。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle.text() | 视觉样式。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| flex | int? | 1 | 弹性因子。 |
| height | double? | 16 | 高度。 |
| isSpacer | bool | false | 是否为透明占位元素。 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 |
| style | TSkeletonRowColObjStyle | const TSkeletonRowColObjStyle() | 视觉样式。 |
| width | double? | - | 宽度。 |


### TSkeletonBlockShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| rounded | 读取 Theme 默认圆角。 |
| circle | 圆形。 |
| square | 无圆角矩形。 |


### TSkeletonAnimation
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| gradient | 渐变 |
| flashed | 闪烁 |


### TSkeletonVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| avatar | 头像 |
| image | 图片 |
| text | 文本 |
| paragraph | 段落 |
