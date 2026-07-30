## API
### TSwiper
#### 简介
Controller 驱动的轮播组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| allowImplicitScrolling | bool | false | - |
| autoplay | bool | false | 是否自动播放。 |
| autoplayInterval | Duration | const Duration(seconds: 3) | 自动播放每次页面稳定后重新等待的完整间隔，必须大于零。 |
| children | List<Widget>? | - | 静态页面列表；与 `itemBuilder` 二选一，且不能为空。 |
| clipBehavior | Clip | Clip.hardEdge | - |
| controller | TSwiperController? | - | 外部控制器；未提供时组件会创建并自行释放内部控制器。 |
| dragStartBehavior | DragStartBehavior | DragStartBehavior.start | - |
| itemBuilder | IndexedWidgetBuilder? | - | 按需构建页面；使用时必须同时提供正数 `itemCount`。 |
| itemCount | int? | - | `itemBuilder` 模式下的页面数量。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loop | bool | false | 是否循环滚动。 |
| nextIcon | Widget? | - | next 控制按钮的自定义图标。 仅替换图标内容；点击热区、禁用状态、Tooltip 和切页行为仍由组件管理。 |
| onChanged | ValueChanged<int>? | - | 当前实际展示页发生变化时触发。 |
| padEnds | bool | true | - |
| pageEffect | TSwiperPageEffect? | - | 页面视觉效果；为空时从组件主题解析。 |
| pageSnapping | bool | true | - |
| pagination | TSwiperPaginationVariant? | - | 指示器形态；为空时从组件主题解析，最终默认为 `TSwiperPaginationVariant.dots`。 |
| paginationAlignment | AlignmentGeometry? | - | 指示器对齐；横向默认底部居中，竖向默认右侧居中。 覆盖模式下控制指示器在轮播内容中的位置；外置模式下控制指示器 在下方或右侧外部区域内的对齐。 |
| paginationItemBuilder | TSwiperPaginationItemBuilder? | - | 自定义 dots 和 dotsBar 的单个标记。 组件仍负责排列、间距、选中语义和业务下标更新。 |
| paginationPlacement | TSwiperPaginationPlacement? | - | 指示器位置；为空时从组件主题解析，最终默认为覆盖在轮播内容上。 |
| physics | ScrollPhysics? | - | - |
| previousIcon | Widget? | - | previous 控制按钮的自定义图标。 仅替换图标内容；点击热区、禁用状态、Tooltip 和切页行为仍由组件管理。 |
| reverse | bool | false | - |
| scrollDirection | Axis | Axis.horizontal | 页面滚动方向。 |
| viewportFraction | double | 1 | 每个页面占视口主轴的比例，必须大于零。 |


### TSwiperController
#### 简介
控制 `TSwiper` 当前页和程序化切换。
使用 `jumpTo`、`animateTo`、`next` 和 `previous` 发起切换，通过 `index`
或监听 Controller 获取当前业务索引。一个 Controller 同时只能附加一个
`TSwiper`，由调用方创建的实例也由调用方负责释放。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| initialIndex | int | 0 | 首次附加时展示的页面。 |


### TSwiperThemeData
#### 简介
轮播组件级 ThemeExtension。
保存页面效果、指示器和切换按钮的视觉默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeColor | Color? | - | 激活项颜色。 |
| activeDotExtent | double? | - | 长条激活项在滚动主轴上的长度。 |
| controlIconSize | double? | - | 控制按钮图标尺寸。 |
| controlStyle | ButtonStyle? | - | 控制按钮样式。 |
| dotSize | double? | - | 圆点直径。 |
| dotSpacing | double? | - | 圆点间距。 |
| fractionBackgroundColor | Color? | - | 数字指示器背景色。 |
| fractionStyle | TextStyle? | - | 数字指示器文字样式。 |
| inactiveColor | Color? | - | 未激活项颜色。 |
| pageEffect | TSwiperPageEffect? | - | 默认页面切换效果。 |
| pagination | TSwiperPaginationVariant? | - | 默认指示器形态。 |
| paginationAlignment | AlignmentGeometry? | - | 默认指示器对齐方式。 |
| paginationMargin | EdgeInsetsGeometry? | - | 指示器外边距。 |
| paginationPlacement | TSwiperPaginationPlacement? | - | 默认指示器位置。 |


### TSwiperPaginationItemDetails
#### 简介
单个轮播指示器标记的状态信息。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis | - | 轮播滚动主轴。 |
| currentIndex | int | - | 当前实际展示页的业务下标。 |
| index | int | - | 当前标记对应的业务下标。 |
| itemCount | int | - | 轮播项总数。 |


### TSwiperPaginationVariant
#### 简介
轮播指示器形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 不显示指示器。 |
| dots | 圆点指示器。 |
| dotsBar | 当前项使用长条的圆点指示器。 |
| fraction | 数字指示器。 |
| controls | 前后切换按钮。 |


### TSwiperPaginationPlacement
#### 简介
指示器相对于轮播内容的位置。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| overlay | 覆盖在轮播内容上。 |
| outside | 放在轮播内容外部；横向轮播放在下方，竖向轮播放在右侧。 |


### TSwiperPageEffect
#### 简介
页面切换视觉效果。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 无额外效果。 |
| cardMargin | 卡片间距效果。 |
| scaleAndFade | 缩放和透明度效果。 |


### TSwiperPaginationItemBuilder
#### 简介
单个轮播指示器标记的构建器。
#### 类型定义

```dart
typedef TSwiperPaginationItemBuilder = Widget Function(BuildContext context, TSwiperPaginationItemDetails details);
```
