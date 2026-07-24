## API
### TSwiper
#### 简介
受控轮播组件。
当前页只由 `value` 决定。用户滑动、自动播放和控制按钮仅通过 `onChanged`
请求新页，不在组件内缓存业务页码。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| allowImplicitScrolling | bool | false | 是否允许隐式滚动。 |
| autoplay | bool | false | 是否自动请求下一页。 |
| autoplayInterval | Duration | const Duration(seconds: 3) | 自动播放间隔。 |
| children | List<Widget>? | - | 页面列表；与 `itemBuilder` 二选一。 |
| clipBehavior | Clip | Clip.hardEdge | 裁剪行为。 |
| dragStartBehavior | DragStartBehavior | DragStartBehavior.start | 拖动开始行为。 |
| itemBuilder | IndexedWidgetBuilder? | - | 页面构建器；与 `children` 二选一。 |
| itemCount | int? | - | 构建器模式的页面数量。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loop | bool | false | 是否循环切换。 |
| onChanged | ValueChanged<int>? | - | 请求切换页面的回调；为空时禁用手势与自动播放。 |
| padEnds | bool | true | 是否在首尾页面添加视口边距。 |
| pageEffect | TSwiperPageEffect? | - | 页面切换效果；未设置时读取 Theme。 |
| pageSnapping | bool | true | 是否吸附到整页。 |
| pagination | TSwiperPaginationVariant? | - | 指示器形态；未设置时读取 Theme 和圆点默认值。 |
| paginationAlignment | AlignmentGeometry | Alignment.bottomCenter | 指示器对齐方式。 |
| physics | ScrollPhysics? | - | 滚动物理效果。 |
| reverse | bool | false | 是否反向滚动。 |
| scrollDirection | Axis | Axis.horizontal | 滚动方向。 |
| value | int | 0 | 当前受控页索引。 |


### TSwiperThemeData
#### 简介
轮播组件级 ThemeExtension。
仅保存页面效果和指示器的视觉默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeColor | Color? | - | 激活项颜色。 |
| activeDotWidth | double? | - | 长条激活项宽度。 |
| dotSize | double? | - | 圆点直径。 |
| dotSpacing | double? | - | 圆点间距。 |
| fractionBackgroundColor | Color? | - | 数字指示器背景色。 |
| fractionStyle | TextStyle? | - | 数字指示器文字样式。 |
| inactiveColor | Color? | - | 未激活项颜色。 |
| pageEffect | TSwiperPageEffect? | - | 默认页面切换效果。 |
| pagination | TSwiperPaginationVariant? | - | 默认指示器形态。 |
| paginationMargin | EdgeInsetsGeometry? | - | 指示器外边距。 |


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


### TSwiperPageEffect
#### 简介
页面切换视觉效果。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 无额外效果。 |
| cardMargin | 卡片间距效果。 |
| scaleAndFade | 缩放和透明度效果。 |
