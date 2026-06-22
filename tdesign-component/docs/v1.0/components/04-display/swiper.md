# TSwiper — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: PageView
> 源码：`lib/src/components/swiper` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | PageView |
| Theme | `TSwiperThemeData` |
| 禁用 | 容器/展示无统一 bool。 |
| L4 | `TSwiperThemeData` → **`TSwiperThemeData`** |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TSwiper | 轮播容器 |
| TSwiperController | 页码与 autoplay 控制 |
| TSwiperThemeData | L4 默认 |
| TSwiperPaginationVariant | 指示器形态 |
| TSwiperPageEffect | 切换效果 |
| children / itemBuilder | 子页内容（二选一） |
| value | 受控当前页 |
| onChanged | 页切换回调 |
| loop | 无限循环 |
| autoplay | 自动播放 |
| controller | 进阶控制；其余见 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| `SwiperPagination` | pagination | L4 → Theme |
| onIndexChanged | onChanged | 命名对齐 v1.0 |
| index / 当前页 | value | 命名对齐 v1.0 |
| transformer / `TPageTransformer` | pageEffect | 命名对齐 v1.0 |
| scale（Swiper 构造器） | scale（Swiper 构造器） | 并入 `pageEffect: scaleAndFade` |
| pagination.builder（`TSwiperPagination.dots` 等） | pagination | 命名对齐 v1.0 |
| pagination.alignment | paginationAlignment | 命名对齐 v1.0 |
| `TSwiperPagination.margin` | TSwiperThemeData.paginationMargin | L4 → Theme |
| `TSwiperDotsPagination.*` 色/尺寸 | TSwiperThemeData | L4 → Theme |
| `TFractionPagination.*` | TSwiperThemeData | L4 → Theme |
| `TSwiperArrowPagination.*` | TSwiperThemeData | L4 → Theme |
| autoplayDelay / delay | autoplayInterval | L4 → Theme |
| physics | physics | 新增 — Material `PageView.physics` |
| pageSnapping | pageSnapping | 新增 — Material `PageView.pageSnapping` |
| padEnds | padEnds | 新增 — Material `PageView.padEnds` |
| clipBehavior | clipBehavior | 新增 — Material `PageView.clipBehavior` |
| dragStartBehavior | dragStartBehavior | 新增 — Material `PageView.dragStartBehavior` |
| reverse | reverse | 新增 — Material `PageView.reverse` |
| allowImplicitScrolling | allowImplicitScrolling | 新增 — Material `PageView.allowImplicitScrolling` |

### 废弃

| 符号 | 原因 |
| --- | --- |
| `Swiper`（flutter_swiper） | 废弃 → v1.0 `TSwiper`（内部 `PageView`） |
| `flutter_swiper_null_safety` | v1.0 移除；改 `PageView` + 自绘指示器 |
| `Swiper` / `SwiperPagination` / `SwiperPlugin` | 不再 export / 引用 |
| `TPageTransformer` | 移出 export（附录 C）；由 `TSwiperPageEffect` 替代 |
| `TSwiperPagination` / `TSwiperDotsPagination` / `TFractionPagination` / `TSwiperArrowPagination` | 实现内聚；对外仅 enum + Theme |

### 新增

| 符号 | 说明 |
| --- | --- |
| **TSwiper** | 基于 Material `PageView` 的轮播容器 |
| **TSwiperThemeData** | 指示器默认样式、自动播放默认间隔等 L4 |
| **TSwiperPaginationVariant** | `none` / `dots` / `dotsBar` / `fraction` / `controls` |
| **TSwiperPageEffect** | `none` / `cardMargin` / `scaleAndFade`（替代 `TPageTransformer`） |
| **TSwiperController** | 可选；封装 `PageController` + 自动播放定时器 |
| children | Material `PageView` 子页列表（与 `itemBuilder` 二选一） |
| pagination | `TSwiperPaginationVariant`；默认取自 Theme |
| paginationAlignment | 指示器对齐；竖向时默认 `centerRight`，横向默认 `bottomCenter` |
| pageEffect | 卡片/缩放切换效果 |
| autoplayInterval | 自动播放间隔；默认取自 Theme |

### export

- **保留**：`TSwiper`、`TSwiperController`、`TSwiperPageEffect`、`TSwiperPaginationVariant`、`TSwiperThemeData`
- **移出**：`TPageTransformer`、`TSwiperPagination` 旧 API、`t_page_transform.dart`、`flutter_swiper_null_safety`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TSwiperThemeData` · Material: **PageView** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `children` / `itemBuilder` + `itemCount` | Material **`PageView`** | 页面内容；builder 模式对齐 `PageView.builder` |
| `controller` / `PageController.initialPage` | Material **`PageView`** | 命令式切页；与 `value` 二选一主路径，可并存由实现同步 |
| `onChanged` | Material **`PageView.onPageChanged`** | 页 index 变更通知 |
| `scrollDirection` / `reverse` | Material **`PageView`** | 轴向与方向 |
| `physics` / `pageSnapping` / `padEnds` | Material **`PageView`** | 滚动与吸附 |
| `viewportFraction` / `clipBehavior` / `dragStartBehavior` / `allowImplicitScrolling` | Material **`PageView`** | 视口与裁剪 |
| `loop` / `autoplay` / `autoplayInterval` | **TDesign 扩展** | 自动轮播；Material 无内置，Timer 实现 |
| `outer` / `pagination` / `paginationAlignment` | **TDesign 扩展** | 指示器布局与形态 |
| `pageEffect` | **TDesign 扩展** | 卡片 margin / scale+fade；Material 无直接字段 |
| dots / fraction / controls 色、尺寸、间距 | TDesign **`TSwiperThemeData`** | 0.2.x `TSwiper*Pagination` L4 迁入 |
| 组件默认样式 | TDesign **`TSwiperThemeData`** | 子树 `mergeExtension` 覆盖 |
