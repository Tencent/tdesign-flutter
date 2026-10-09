## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSwiper

#### 声明

```dart
class TSwiper extends StatefulWidget
```

#### 默认构造方法


```dart
const TSwiper({
  this.children,
  this.itemBuilder,
  this.itemCount,
  this.controller,
  this.onChanged,
  this.loop = false,
  this.autoplay = false,
  this.autoplayInterval = const Duration(seconds: 3),
  this.animationDuration = kThemeAnimationDuration,
  this.animationCurve = Curves.easeInOut,
  this.pagination,
  this.paginationPlacement,
  this.paginationItemBuilder,
  this.previousIcon,
  this.nextIcon,
  this.pageEffect,
  this.viewportFraction = 1,
  this.scrollDirection = Axis.horizontal,
  this.physics,
  this.pageSnapping = true,
  this.padEnds = true,
  this.clipBehavior = Clip.hardEdge,
  this.reverse = false,
  this.dragStartBehavior = DragStartBehavior.start,
  this.allowImplicitScrolling = false,
  super.key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| allowImplicitScrolling | bool | false | 是否允许无障碍服务请求将未显示的页面滚动到可见区域。 | 否 |
| animationCurve | Curve | Curves.easeInOut | 自动播放、内置控制按钮及 Controller 未显式覆盖时的切换动画曲线。 | 否 |
| animationDuration | Duration | kThemeAnimationDuration | 自动播放、内置控制按钮及 Controller 未显式覆盖时的切换动画时长。 必须大于 Duration.zero，否则抛出 ArgumentError。 | 否 |
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
#### 简介
控制 `TSwiper` 当前页和程序化切换。
使用 `jumpTo`、`animateTo`、`next` 和 `previous` 发起切换，通过 `index`
或监听 Controller 获取当前业务索引。一个 Controller 同时只能附加一个
`TSwiper`，由调用方创建的实例也由调用方负责释放。

#### 声明

```dart
class TSwiperController extends ChangeNotifier
```

#### 默认构造方法


```dart
TSwiperController({this.initialIndex = 0})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| initialIndex | int | 0 | 首次附加时展示的页面；必须大于或等于 0 且小于页面数，否则抛出参数或范围异常。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| hasClients | bool | - | 是否已附加到一个 Swiper。 |
| index | int | - | 当前实际展示的业务索引。 |


#### 实例方法

##### TSwiperController.animateTo

```dart
Future<void> animateTo(int index, {Duration? duration, Curve? curve})
```


动画切换到目标页；循环模式始终向前到达目标。
未提供 `duration` 或 `curve` 时，继承所附加 `TSwiper` 的动画配置。
## 返回值
所绑定轮播的切换请求完成时结束；未绑定时立即完成，不执行切换。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| index | int | - | 目标页面的业务索引，从 0 开始；循环模式向前切换到该页面。 | 是 |
| duration | Duration? | - | 本次切换动画时长；为空时使用绑定 Swiper 的动画配置。 | 否 |
| curve | Curve? | - | 本次切换动画曲线；为空时使用绑定 Swiper 的动画配置。 | 否 |


##### TSwiperController.jumpTo

```dart
void jumpTo(int index)
```


立即跳转到目标页。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| index | int | - | 目标页面的业务索引，从 0 开始；超出范围时按绑定 Swiper 的规则归一化。 | 是 |


##### TSwiperController.next

```dart
Future<void> next({Duration? duration, Curve? curve})
```


切换到下一页。
未提供 `duration` 或 `curve` 时，继承所附加 `TSwiper` 的动画配置。
## 返回值
所绑定轮播的切换请求完成时结束；未绑定时立即完成，不执行切换。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| duration | Duration? | - | 本次切换动画时长；为空时使用绑定 Swiper 的动画配置。 | 否 |
| curve | Curve? | - | 本次切换动画曲线；为空时使用绑定 Swiper 的动画配置。 | 否 |


##### TSwiperController.previous

```dart
Future<void> previous({Duration? duration, Curve? curve})
```


切换到上一页。
未提供 `duration` 或 `curve` 时，继承所附加 `TSwiper` 的动画配置。
## 返回值
所绑定轮播的切换请求完成时结束；未绑定时立即完成，不执行切换。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| duration | Duration? | - | 本次切换动画时长；为空时使用绑定 Swiper 的动画配置。 | 否 |
| curve | Curve? | - | 本次切换动画曲线；为空时使用绑定 Swiper 的动画配置。 | 否 |


### TSwiperThemeData
#### 简介
轮播组件级 ThemeExtension。
保存指示器、内容圆角和切换按钮的视觉默认值。
{@category ComponentTheme}

#### 声明

```dart
class TSwiperThemeData extends ThemeExtension<TSwiperThemeData>
```

#### 默认构造方法


```dart
const TSwiperThemeData({
  this.paginationAlignment,
  this.paginationMargin,
  this.borderRadius,
  this.activeColor,
  this.inactiveColor,
  this.dotSize,
  this.activeDotExtent,
  this.dotSpacing,
  this.fractionStyle,
  this.fractionBackgroundColor,
  this.controlStyle,
  this.controlIconSize,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| activeColor | Color? | - | 激活项颜色。 null 时使用 textColorAnti Token。 | 否 |
| activeDotExtent | double? | - | 长条激活项在滚动主轴上的长度。 未配置时为 20 逻辑像素，必须大于 0。 | 否 |
| borderRadius | BorderRadiusGeometry? | - | 轮播内容圆角。 null 时使用 radiusLarge Token 构造圆角。 | 否 |
| controlIconSize | double? | - | 控制按钮图标尺寸。 未配置时为 18 逻辑像素，必须大于 0。 | 否 |
| controlStyle | ButtonStyle? | - | 控制按钮样式。 | 否 |
| dotSize | double? | - | 圆点直径。 未配置时为 6 逻辑像素，必须大于 0。 | 否 |
| dotSpacing | double? | - | 圆点间距。 未配置时为 5 逻辑像素，必须大于或等于 0。 | 否 |
| fractionBackgroundColor | Color? | - | 数字指示器背景色。 null 时使用 textColorPlaceholder Token。 | 否 |
| fractionStyle | TextStyle? | - | 数字指示器文字样式。 | 否 |
| inactiveColor | Color? | - | 未激活项颜色。 | 否 |
| paginationAlignment | AlignmentGeometry? | - | 默认指示器对齐方式。 未配置时 controls 居中，其他类型横向轮播为 bottomCenter、纵向轮播为 centerRight。 | 否 |
| paginationMargin | EdgeInsetsGeometry? | - | 指示器外边距。 未配置时普通指示器四边为 12；controls 沿滚动轴两端为 15 逻辑像素。 | 否 |


#### 实例方法

##### TSwiperThemeData.copyWith

```dart
TSwiperThemeData copyWith({
  AlignmentGeometry? paginationAlignment,
  EdgeInsetsGeometry? paginationMargin,
  BorderRadiusGeometry? borderRadius,
  Color? activeColor,
  Color? inactiveColor,
  double? dotSize,
  double? activeDotExtent,
  double? dotSpacing,
  TextStyle? fractionStyle,
  Color? fractionBackgroundColor,
  ButtonStyle? controlStyle,
  double? controlIconSize,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TSwiperThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| paginationAlignment | AlignmentGeometry? | - | 默认指示器对齐方式。 未配置时 controls 居中，其他类型横向轮播为 bottomCenter、纵向轮播为 centerRight。 | 否 |
| paginationMargin | EdgeInsetsGeometry? | - | 指示器外边距。 未配置时普通指示器四边为 12；controls 沿滚动轴两端为 15 逻辑像素。 | 否 |
| borderRadius | BorderRadiusGeometry? | - | 轮播内容圆角。 null 时使用 radiusLarge Token 构造圆角。 | 否 |
| activeColor | Color? | - | 激活项颜色。 null 时使用 textColorAnti Token。 | 否 |
| inactiveColor | Color? | - | 未激活项颜色。 | 否 |
| dotSize | double? | - | 圆点直径。 未配置时为 6 逻辑像素，必须大于 0。 | 否 |
| activeDotExtent | double? | - | 长条激活项在滚动主轴上的长度。 未配置时为 20 逻辑像素，必须大于 0。 | 否 |
| dotSpacing | double? | - | 圆点间距。 未配置时为 5 逻辑像素，必须大于或等于 0。 | 否 |
| fractionStyle | TextStyle? | - | 数字指示器文字样式。 | 否 |
| fractionBackgroundColor | Color? | - | 数字指示器背景色。 null 时使用 textColorPlaceholder Token。 | 否 |
| controlStyle | ButtonStyle? | - | 控制按钮样式。 | 否 |
| controlIconSize | double? | - | 控制按钮图标尺寸。 未配置时为 18 逻辑像素，必须大于 0。 | 否 |


##### TSwiperThemeData.lerp

```dart
TSwiperThemeData lerp(TSwiperThemeData? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TSwiperThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TSwiperThemeData? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TSwiperPaginationItemDetails
#### 简介
单个轮播指示器标记的状态信息。

#### 声明

```dart
class TSwiperPaginationItemDetails
```

#### 默认构造方法


```dart
const TSwiperPaginationItemDetails({
  required this.index,
  required this.currentIndex,
  required this.itemCount,
  required this.axis,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| axis | Axis | - | 轮播滚动主轴。 | 是 |
| currentIndex | int | - | 当前实际展示页的业务下标。 | 是 |
| index | int | - | 当前标记对应的业务下标。 | 是 |
| itemCount | int | - | 轮播项总数。 | 是 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isActive | bool | - | 当前标记是否对应实际展示页。 |


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
| scale | 相邻卡片等比缩放，当前页保持完整尺寸。 |
| scaleAndFade | 相邻卡片等比缩放、淡化并向当前页两侧叠放。 |


### TSwiperPaginationItemBuilder
#### 简介
单个轮播指示器标记的构建器。
`context` 轮播指示器的构建上下文。
`details` 当前标记的索引、选中态及指示器配置。
## 返回值
当前轮播指示器标记内容。
#### 类型定义

```dart
typedef TSwiperPaginationItemBuilder = Widget Function(BuildContext context, TSwiperPaginationItemDetails details);
```
