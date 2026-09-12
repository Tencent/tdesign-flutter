# Swiper 设计与交互对齐

## 背景

当前 Flutter Swiper 已具备 Controller、循环、自动播放、分页和页面效果，但公开 Demo 的分组、实例和图片与移动端公开目标不一致，代码面板依赖隐藏辅助方法；自动播放与内置按钮也无法按实例配置切换动画时长。

## 目标

- 公开 Demo 按“组件类型 / 组件样式”展示 dots、dots-bar、fraction、controls、两种 cards 和可交互垂直模式。
- 使用公开 Demo 同源的本地图片，统一默认圆角、导航颜色、间距和卡片露出效果。
- 自动播放、内置控制按钮和 Controller 的默认程序化切换共享组件 `animationDuration`；Controller 显式时长仍优先。
- 验证拖拽、按钮、自动播放、循环边界、垂直配置和代码面板完整性。

## 行为契约

1. `animationDuration` 必须大于零，默认保持 `kThemeAnimationDuration`，不改变既有调用的默认行为。
2. `TSwiperController.animateTo/next/previous` 未传 `duration` 时使用所附 Swiper 的 `animationDuration`；显式传值覆盖组件配置。
3. 自动播放和内置 controls 使用组件的 `animationDuration` 与 `animationCurve`，每次页面稳定后重新等待完整 `autoplayInterval`。
4. 用户拖拽、应用非 resumed、TickerMode 关闭和动画进行中均暂停自动播放。
5. Swiper 内容默认按 TDesign 大圆角裁剪；外置分页不被内容裁剪。
6. 默认覆盖式 dots/dots-bar 使用反色前景；卡片 Demo 显式使用品牌色导航。
7. 公开 Demo 仅保留目标六个条目；额外扩展能力留在组件测试，不作为公开 Demo 混入。
8. controls 使用 Flutter 工程默认视觉尺寸：圆形背景 32dp、图标 18dp，并由 `IconButton` 保留 48dp 触控区域；该值不冒充 Figma 精确标注，可由组件 Theme 覆盖。
9. 公开 Demo 的六张轮播内容均从第一页开始；fraction 保持右下角紧凑胶囊，controls 默认在内容左右两侧垂直居中，不由 Demo 外层样式修正。

## API 收敛

- 保留 `children` / `itemBuilder` 二选一、`TSwiperController`、`onChanged`、分页与页面效果等现有 Flutter 契约。
- 新增 `animationDuration`、`animationCurve`，分别表达实例级运动时长和曲线；Controller 的同名命令参数只作为单次覆盖，不形成第二状态源。
- 不新增 `current`、`changeSource`、`imageLoad`、`list` 或字符串 easing；受控/命令式状态由 Controller 管理，图片事件由子 Widget 管理，曲线使用 Flutter `Curve`。
- 从 `TSwiperThemeData` 删除已发布的 `pagination`、`pageEffect`、`paginationPlacement` 行为字段，避免 Theme 与实例形成两个状态源。调用方分别迁移到 `TSwiper` 的同名实例参数；这是编译期 breaking change，不保留兼容别名。

## 非目标

- 不复制小程序原生 swiper 的平台专属属性。
- 不把页面状态或交互开关放入 ThemeExtension。

## 验收标准

- Flutter 3.32.0 与 latest 下组件、Demo 功能测试及严格 analyze 通过。
- Swiper 生产代码行覆盖率不低于 95%。
- Flutter 3.32.0 Linux 浅色/深色 Golden 生成后无更新复验通过。
- 横向触控由 widget fling 验证；Web Demo 实际完成 controls 切换、垂直 autoplay 开关及参数操作。
