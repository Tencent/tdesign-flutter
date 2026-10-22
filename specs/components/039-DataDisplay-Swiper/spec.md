# Swiper 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

自动播放、拖拽、命令动画和页面效果的时序可能相互覆盖。

当前 Flutter Swiper 已具备 Controller、循环、自动播放、分页和页面效果，但公开 Demo 的分组、实例和图片与移动端公开目标不一致，代码面板依赖隐藏辅助方法；自动播放与内置按钮也无法按实例配置切换动画时长。

## 范围与非目标

### 目标

- 公开 Demo 按“组件类型 / 组件样式 / 组件动效”展示 dots、dots-bar、fraction、controls、三种 cards、三种指示器位置和可交互动效参数。
- 使用公开 Demo 同源的本地图片，统一默认圆角、导航颜色、间距和卡片露出效果。
- 自动播放、内置控制按钮和 Controller 的默认程序化切换共享组件 `animationDuration`；Controller 显式时长仍优先。
- 验证拖拽、按钮、自动播放、循环边界、指示器位置和代码面板完整性。

### 不涉及

- 不复制小程序原生 swiper 的平台专属属性。
- 不把页面状态或交互开关放入 ThemeExtension。

## 最终方案与行为契约

1. `animationDuration` 必须大于零，默认保持 `kThemeAnimationDuration`，不改变既有调用的默认行为。
2. `TSwiperController.animateTo/next/previous` 未传 `duration` 时使用所附 Swiper 的 `animationDuration`；显式传值覆盖组件配置。
3. 自动播放和内置 controls 使用组件的 `animationDuration` 与 `animationCurve`，每次页面稳定后重新等待完整 `autoplayInterval`。
4. 用户拖拽、应用非 resumed、TickerMode 关闭和动画进行中均暂停自动播放。
5. Swiper 内容默认按 TDesign 大圆角裁剪；外置分页不被内容裁剪。
6. 默认覆盖式 dots/dots-bar 使用反色前景；卡片 Demo 显式使用品牌色导航。
7. 公开 Demo 按设计稿保留类型、指示器位置和动效参数三个分组；额外扩展能力留在组件测试，不作为公开 Demo 混入。
8. controls 使用 Flutter 工程默认视觉尺寸：圆形背景 32dp、图标 18dp，并由 `IconButton` 保留 48dp 触控区域；该值不冒充 Figma 精确标注，可由组件 Theme 覆盖。
9. 公开 Demo 的六张轮播内容均从第一页开始；fraction 保持右下角紧凑胶囊，controls 默认在内容左右两侧垂直居中，不由 Demo 外层样式修正。
10. Cards 使用 295/375 的页面占比，在组件内部保留左右各 6dp 间距，得到设计稿 283dp 中心卡片；scale 相邻卡片等比缩放至 0.8，scaleAndFade 同时等比缩放、淡化并向中心叠放。
11. 三种 Cards 效果复用同一组轮播数据；相邻页露出、缩放、淡化与叠放全部由 `TSwiperPageEffect` 实现，Demo 不按效果类型替换图片来模拟设计结果。

### API 收敛

- 保留 `children` / `itemBuilder` 二选一、`TSwiperController`、`onChanged`、分页与页面效果等现有 Flutter 契约。
- 新增 `animationDuration`、`animationCurve`，分别表达实例级运动时长和曲线；Controller 的同名命令参数只作为单次覆盖，不形成第二状态源。
- 不新增 `current`、`changeSource`、`imageLoad`、`list` 或字符串 easing；受控/命令式状态由 Controller 管理，图片事件由子 Widget 管理，曲线使用 Flutter `Curve`。
- 从 `TSwiperThemeData` 删除已发布的 `pagination`、`pageEffect`、`paginationPlacement` 行为字段，避免 Theme 与实例形成两个状态源。调用方分别迁移到 `TSwiper` 的同名实例参数；这是编译期 breaking change，不保留兼容别名。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 实例拥有行为选择，Controller 只提供单次命令覆盖；暂停和恢复绑定真实生命周期。 |
| 保留的边界与代价 | Cards 效果由组件几何实现，不通过替换 Demo 图片模拟；分页位于内容裁剪边界之外。 |

### 设计演变中的关键理由

- `animationDuration` 保持现有默认值；新增可选 API 不构成 breaking change。
- 删除 `TSwiperThemeData.pagination/pageEffect/paginationPlacement` 属于 breaking change；更新日志明确迁移到 `TSwiper` 同名实例参数，不保留会继续制造第二状态源的兼容别名。
- Controller 单次显式参数优先，避免组件配置改变已有显式调用。
- 固定 Linux Flutter 3.32.0 生成 Golden，latest 不写回像素基线。
- Flutter latest 若自动改写分析配置，验证后恢复，不带入 PR。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- Flutter 3.32.0 与 latest 下组件、Demo 功能测试及严格 analyze 通过。
- Swiper 生产代码行覆盖率不低于 95%。
- Flutter 3.32.0 Linux 浅色/深色 Golden 生成后无更新复验通过。
- 横向触控由 widget fling 验证；Web Demo 实际完成 controls 切换、垂直 autoplay 开关及参数操作。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
