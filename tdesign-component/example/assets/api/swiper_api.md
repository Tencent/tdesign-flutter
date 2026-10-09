## API

### TSwiper

Controller 驱动的轮播组件。

#### 构造方法

##### TSwiper

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| allowImplicitScrolling | bool | false | 是否允许无障碍服务请求将未显示的页面滚动到可见区域。 | 否 |
| animationCurve | Curve | Curves.easeInOut | 自动播放、内置控制按钮及 Controller 未显式覆盖时的切换动画曲线。 | 否 |
| animationDuration | Duration | kThemeAnimationDuration | 自动播放、内置控制按钮及 Controller 未显式覆盖时的切换动画时长。 | 否 |
| autoplay | bool | false | 是否自动播放。 | 否 |
| autoplayInterval | Duration | const Duration(seconds: 3) | 自动播放每次页面稳定后重新等待的完整间隔，必须大于零。 | 否 |
| children | List&lt;Widget&gt;? | - | 静态页面列表；与 `itemBuilder` 二选一，且不能为空。 | 否 |
| clipBehavior | Clip | Clip.hardEdge | 页面内容超出轮播边界时的裁剪方式。 | 否 |
| controller | TSwiperController? | - | 外部控制器；未提供时组件会创建并自行释放内部控制器。 | 否 |
| dragStartBehavior | DragStartBehavior | DragStartBehavior.start | 拖拽手势开始时的坐标解析方式。 | 否 |
| itemBuilder | IndexedWidgetBuilder? | - | 按需构建页面；使用时必须同时提供正数 `itemCount`。 | 否 |
| itemCount | int? | - | `itemBuilder` 模式下的页面数量。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loop | bool | false | 是否循环滚动。 | 否 |
| nextIcon | Widget? | - | next 控制按钮的自定义图标。 仅替换图标内容；点击热区、禁用状态、Tooltip 和切页行为仍由组件管理。 | 否 |
| onChanged | ValueChanged&lt;int&gt;? | - | 当前实际展示页发生变化时触发。 | 否 |
| padEnds | bool | true | 当 `viewportFraction` 小于 1 时，首尾页面是否保留端部留白。 | 否 |
| pageEffect | TSwiperPageEffect? | - | 页面视觉效果；为空时默认为 `TSwiperPageEffect.none`。 | 否 |
| pageSnapping | bool | true | 页面停止滚动时是否自动对齐到整页。 | 否 |
| pagination | TSwiperPaginationVariant? | - | 指示器形态；为空时默认为 `TSwiperPaginationVariant.dots`。 | 否 |
| paginationItemBuilder | TSwiperPaginationItemBuilder? | - | 自定义 dots 和 dotsBar 的单个标记。 组件仍负责排列、间距、选中语义和业务下标更新。 | 否 |
| paginationPlacement | TSwiperPaginationPlacement? | - | 指示器位置；为空时默认为覆盖在轮播内容上。 | 否 |
| physics | ScrollPhysics? | - | 页面视图使用的滚动物理效果。 未指定时使用 `PageView` 的默认物理效果。 | 否 |
| previousIcon | Widget? | - | previous 控制按钮的自定义图标。 仅替换图标内容；点击热区、禁用状态、Tooltip 和切页行为仍由组件管理。 | 否 |
| reverse | bool | false | 是否反转页面的视觉顺序和滚动方向。 | 否 |
| scrollDirection | Axis | Axis.horizontal | 页面滚动方向。 | 否 |
| viewportFraction | double | 1 | 每个页面占视口主轴的比例，必须大于零。 | 否 |


### TSwiperController

控制 `TSwiper` 当前页和程序化切换。

使用 `jumpTo`、`animateTo`、`next` 和 `previous` 发起切换，通过 `index`
或监听 Controller 获取当前业务索引。一个 Controller 同时只能附加一个
`TSwiper`，由调用方创建的实例也由调用方负责释放。

#### 构造方法

##### TSwiperController

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| initialIndex | int | 0 | 首次附加时展示的页面。 | 否 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| hasClients | bool | - | 是否已附加到一个 Swiper。 | - |
| index | int | - | 当前实际展示的业务索引。 | - |


#### 实例方法

##### TSwiperController.animateTo

位置参数：`index`


动画切换到目标页；循环模式始终向前到达目标。

未提供 `duration` 或 `curve` 时，继承所附加 `TSwiper` 的动画配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| index | int | - | - | 是 |
| duration | Duration? | - | - | 否 |
| curve | Curve? | - | - | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | - | - |


##### TSwiperController.jumpTo

位置参数：`index`


立即跳转到目标页。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| index | int | - | - | 是 |


##### TSwiperController.next

切换到下一页。

未提供 `duration` 或 `curve` 时，继承所附加 `TSwiper` 的动画配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| duration | Duration? | - | - | 否 |
| curve | Curve? | - | - | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | - | - |


##### TSwiperController.previous

切换到上一页。

未提供 `duration` 或 `curve` 时，继承所附加 `TSwiper` 的动画配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| duration | Duration? | - | - | 否 |
| curve | Curve? | - | - | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | - | - |


### TSwiperThemeData

轮播组件级 ThemeExtension。

保存指示器、内容圆角和切换按钮的视觉默认值。

#### 构造方法

##### TSwiperThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| activeColor | Color? | - | 激活项颜色。 | 否 |
| activeDotExtent | double? | - | 长条激活项在滚动主轴上的长度。 | 否 |
| borderRadius | BorderRadiusGeometry? | - | 轮播内容圆角。 | 否 |
| controlIconSize | double? | - | 控制按钮图标尺寸。 | 否 |
| controlStyle | ButtonStyle? | - | 控制按钮样式。 | 否 |
| dotSize | double? | - | 圆点直径。 | 否 |
| dotSpacing | double? | - | 圆点间距。 | 否 |
| fractionBackgroundColor | Color? | - | 数字指示器背景色。 | 否 |
| fractionStyle | TextStyle? | - | 数字指示器文字样式。 | 否 |
| inactiveColor | Color? | - | 未激活项颜色。 | 否 |
| paginationAlignment | AlignmentGeometry? | - | 默认指示器对齐方式。 | 否 |
| paginationMargin | EdgeInsetsGeometry? | - | 指示器外边距。 | 否 |


#### 实例方法

##### TSwiperThemeData.copyWith

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| paginationAlignment | AlignmentGeometry? | - | 字段含义：默认指示器对齐方式。 调用时的空值行为见方法说明。 | 否 |
| paginationMargin | EdgeInsetsGeometry? | - | 字段含义：指示器外边距。 调用时的空值行为见方法说明。 | 否 |
| borderRadius | BorderRadiusGeometry? | - | 字段含义：轮播内容圆角。 调用时的空值行为见方法说明。 | 否 |
| activeColor | Color? | - | 字段含义：激活项颜色。 调用时的空值行为见方法说明。 | 否 |
| inactiveColor | Color? | - | 字段含义：未激活项颜色。 调用时的空值行为见方法说明。 | 否 |
| dotSize | double? | - | 字段含义：圆点直径。 调用时的空值行为见方法说明。 | 否 |
| activeDotExtent | double? | - | 字段含义：长条激活项在滚动主轴上的长度。 调用时的空值行为见方法说明。 | 否 |
| dotSpacing | double? | - | 字段含义：圆点间距。 调用时的空值行为见方法说明。 | 否 |
| fractionStyle | TextStyle? | - | 字段含义：数字指示器文字样式。 调用时的空值行为见方法说明。 | 否 |
| fractionBackgroundColor | Color? | - | 字段含义：数字指示器背景色。 调用时的空值行为见方法说明。 | 否 |
| controlStyle | ButtonStyle? | - | 字段含义：控制按钮样式。 调用时的空值行为见方法说明。 | 否 |
| controlIconSize | double? | - | 字段含义：控制按钮图标尺寸。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSwiperThemeData | - | - | - |


##### TSwiperThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TSwiperThemeData? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSwiperThemeData | - | - | - |


### TSwiperPaginationItemDetails

单个轮播指示器标记的状态信息。

#### 构造方法

##### TSwiperPaginationItemDetails

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| axis | Axis | - | 轮播滚动主轴。 | 是 |
| currentIndex | int | - | 当前实际展示页的业务下标。 | 是 |
| index | int | - | 当前标记对应的业务下标。 | 是 |
| itemCount | int | - | 轮播项总数。 | 是 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| isActive | bool | - | 当前标记是否对应实际展示页。 | - |


### TSwiperPaginationVariant

轮播指示器形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| none | TSwiperPaginationVariant | - | 不显示指示器。 | - |
| dots | TSwiperPaginationVariant | - | 圆点指示器。 | - |
| dotsBar | TSwiperPaginationVariant | - | 当前项使用长条的圆点指示器。 | - |
| fraction | TSwiperPaginationVariant | - | 数字指示器。 | - |
| controls | TSwiperPaginationVariant | - | 前后切换按钮。 | - |


### TSwiperPaginationPlacement

指示器相对于轮播内容的位置。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| overlay | TSwiperPaginationPlacement | - | 覆盖在轮播内容上。 | - |
| outside | TSwiperPaginationPlacement | - | 放在轮播内容外部；横向轮播放在下方，竖向轮播放在右侧。 | - |


### TSwiperPageEffect

页面切换视觉效果。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| none | TSwiperPageEffect | - | 无额外效果。 | - |
| cardMargin | TSwiperPageEffect | - | 卡片间距效果。 | - |
| scale | TSwiperPageEffect | - | 相邻卡片等比缩放，当前页保持完整尺寸。 | - |
| scaleAndFade | TSwiperPageEffect | - | 相邻卡片等比缩放、淡化并向当前页两侧叠放。 | - |


### TSwiperPaginationItemBuilder

单个轮播指示器标记的构建器。

位置参数：`context, details`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| details | TSwiperPaginationItemDetails | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |
