# Image 设计对齐与 API 收敛

## 证据与目标

- Figma Image 移动端展示 `28600:38299`（拉伸实例 `39817:45319`）；小程序固定到 `origin/develop@cc2384cc5`。
- Demo 类型为裁切、适应高、拉伸、方形、圆角方形、圆形；状态为默认/自定义加载与失败。
- 使用 Flutter 原生 `BoxFit` 表达适配，独立枚举表达形状，消除 `variant` 的两个维度重叠。
- Figma 类型首行宽度依次为 72、89、134，高度均为 72；所有相邻实例间距 24，标签与图片间距 16，第二行宽度为 264。
- 公开 Demo 只展示“01 组件类型”和“02 组件状态”，测试辅助模块不进入用户可见页面。

## 行为契约

- `fit` 非空默认 `BoxFit.fill`，`shape` 非空默认 `square`，两者可任意组合。
- 默认尺寸 72 × 72；图片、加载和失败占位均使用同一尺寸和形状。
- `src == null` 且未提供 `imageFile` 是 Flutter 的声明式加载占位；`src == ''` 表示加载失败；两种状态都允许自定义占位。
- 小程序公开 Demo 通过内部 `setData` 强制展示加载态，该手段不是公开 API；Flutter 不公开内部状态控制器。
- 默认加载和失败占位分别使用 TDesign `ellipsis`、`close` 图标；`loadingBuilder`/`errorBuilder` 仅负责动态渲染，并优先于对应静态 Widget。
- `src` 与 `imageFile` 最多提供一个，允许两者都不提供以声明加载状态。
- `onLoad` 在图片首帧成功显示后通知，`onError` 在图片加载失败后通知；每个来源生命周期最多只触发一个终态事件。
- 动画图片后续帧、Widget rebuild 和同一来源的同步缓存命中不重复通知；来源变更后重置事件状态。
- `src == null` 且未提供 `imageFile` 时不触发成功或失败事件；`src == ''` 触发一次带合成 `ArgumentError` 的 `onError`。
- `onTap` 是唯一点击入口；加载、失败和成功内容共享同一 72 × 72 命中区域，无回调时不创建手势节点。
- 网络、asset、本地文件、语义、缓存尺寸和点击回调保持原契约。

## API 收敛边界

- 删除同时编码适配与形状的 `TImageVariant`：适配只由 Flutter 原生 `BoxFit fit` 表达，形状只由 `TImageShape shape` 表达。
- `src`/`imageFile` 只负责来源与声明式状态；`loadingWidget`/`errorWidget` 提供快捷占位，builder 保留 Flutter 原生动态构建能力，优先级必须明确但不再新增平行开关。
- 小程序 `loading` 内容只对应 Flutter `loadingWidget`；`loadingBuilder` 是 Flutter 网络图片增量进度的渲染扩展，不作为小程序事件映射。
- `frameBuilder`/`errorBuilder` 只负责渲染；小程序 `load`/`error` 事件分别由 Flutter 可选 `onLoad`/`onError` 承接，不得在 builder 中执行业务副作用。
- `TImageThemeData` 只承载视觉默认值，不复制来源、状态、适配、形状或点击 API。
- 小程序的 `lazy`、WebP、长按菜单和 `t-id` 属于平台能力，不机械映射；Flutter 保留原生缓存尺寸、语义、`ImageProvider` 与点击表达。

## Breaking changes

- 删除 `TImageVariant` 与 `variant`。
- 新增 `TImageShape shape`；适配方式统一由非空 `BoxFit fit` 表达。
- 默认形状由圆角方形改为方形，默认适配为拉伸。
- 空字符串由加载态改为失败态；不传来源由断言错误改为显式加载态。

## 验收

- [ ] 迁移仓库内全部调用点且 analyze 无遗漏。
- [ ] 组件、Demo、覆盖率和双版本测试通过。
- [ ] Flutter 3.32.0 Linux 组件状态与 Demo light/dark Golden 更新并复验通过。
