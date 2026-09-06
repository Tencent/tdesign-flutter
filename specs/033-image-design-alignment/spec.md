# Image 设计对齐与 API 收敛

## 证据与目标

- Figma Image `24386:5269`；小程序 `origin/develop@cc2384cc5`。
- Demo 类型为裁切、适应高、拉伸、方形、圆角方形、圆形；状态为默认/自定义加载与失败。
- 使用 Flutter 原生 `BoxFit` 表达适配，独立枚举表达形状，消除 `variant` 的两个维度重叠。

## 行为契约

- `fit` 非空默认 `BoxFit.fill`，`shape` 非空默认 `square`，两者可任意组合。
- 默认尺寸 72 × 72；图片、加载和失败占位均使用同一尺寸和形状。
- 网络、asset、本地文件、语义、缓存尺寸和点击回调保持原契约。

## Breaking changes

- 删除 `TImageVariant` 与 `variant`。
- 新增 `TImageShape shape`；适配方式统一由非空 `BoxFit fit` 表达。
- 默认形状由圆角方形改为方形，默认适配为拉伸。

## 验收

- [ ] 迁移仓库内全部调用点且 analyze 无遗漏。
- [ ] 组件、Demo、覆盖率和双版本测试通过。
- [ ] Flutter 3.32.0 Linux 组件状态与 Demo light/dark Golden 更新并复验通过。
