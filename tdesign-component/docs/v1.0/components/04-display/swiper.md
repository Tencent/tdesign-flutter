# TSwiper

`TSwiper` 是基于 Flutter `PageView` 的受控轮播组件，不导出第三方 Swiper plugin 或 controller。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `children` | `List<Widget>?` | `null` | 页面列表，与 itemBuilder 二选一 |
| `itemBuilder` | `IndexedWidgetBuilder?` | `null` | 页面构建器 |
| `itemCount` | `int?` | `null` | 构建器模式数量 |
| `value` | `int` | `0` | 当前受控页 |
| `onChanged` | `ValueChanged<int>?` | `null` | 请求切换页面 |
| `loop` | `bool` | `false` | 循环轮播 |
| `autoplay` | `bool` | `false` | 自动请求下一页 |
| `autoplayInterval` | `Duration` | 3 秒 | 自动播放间隔 |
| `pagination` | `TSwiperPaginationVariant?` | Theme / dots | 指示器形态 |
| `paginationAlignment` | `AlignmentGeometry` | bottomCenter | 指示器位置 |
| `pageEffect` | `TSwiperPageEffect?` | Theme / none | 页面效果 |

其余滚动参数与 PageView 对齐，包括 `scrollDirection/physics/pageSnapping/padEnds/clipBehavior/reverse/dragStartBehavior/allowImplicitScrolling`。

## 控制语义

用户滑动、箭头和自动播放只调用 `onChanged`。父级回写 `value` 后页面才成为新受控状态。`onChanged` 为空时禁用手势，`autoplay` 必须提供 `onChanged`。

## Theme

`TSwiperThemeData` 只保存分页器和页面效果的视觉默认。自动播放开关、间隔、当前页与回调不进入 Theme。
