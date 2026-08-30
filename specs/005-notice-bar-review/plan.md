# TNoticeBar Review 修复 - 技术方案

## 问题与方案

### 1. 水平滚动距离使用屏幕宽度（P1）

**现状**：`_scroll()` 中 `scrollDistance = _getContextWidth() + (_size!.width - _effectivePadding.horizontal)`，其中 `_size = MediaQuery.of(context).size` 是整屏宽度。

**方案**：改用 `_getEmptyWidth()`（通过 `_contentKey` 测量的公告栏可视区宽度），即
`scrollDistance = _getContextWidth() + _getEmptyWidth()`。

`_getEmptyWidth()` 内部已有兜底：当 `_contentKey.currentContext` 尚未挂载（首次 build）时回退到 `_size!.width - padding.horizontal`，保证首帧不崩。

### 2. speed 语义与计时（P1）

**现状**：水平滚动每个 tick 固定 `animateTo(offset, duration: 1s)`，`offset` 每 tick 加 `_effectiveSpeed`。动画耗时恒为 1s，实际速率 = 每个 tick 位移 / 1s。当每个 tick 前进 `speed` 像素时，速率 = `speed` px/s。

**方案**：保留"每个 tick 前进 `speed` 像素 + 动画 1s"的横向模型，确保速率恒为 `speed` px/s；tick 回调等待当前动画完成后再处理下一段，避免同一回调内的动画互相追赶。垂直轮播不复用 `speed`，使用组件内部固定 500ms 切换动画，公开 `interval` 只控制两次切换之间的等待时间。

> 结论：`speed` 只表示横向 px/s；垂直轮播由 `interval` 控制节奏，两个维度不再复用同一参数。

### 3. 尺寸语义统一（P2）

`_getContextWidth()` 返回文本宽度（`_key` 处第一个文本 `SizedBox`），`_getEmptyWidth()` 返回可视区宽度（`_contentKey` 的 Expanded 区域）。两者职责清晰，本次在 `_scroll()` 与 `_getFontSize()` 中统一使用：
- `_getContextWidth()` → 文本宽度，用于计算滚动总距离。
- `_getEmptyWidth()` → 可视区宽度，用于计算滚动总距离与文本布局 `maxWidth`（原 `_getFontSize` 用 `_size!.width`，改为可视区宽度，避免窄容器内文本按屏宽换行）。

### 4. 冗余 getter（轻微）

删除 `_effectiveMarquee`、`_effectiveInterval`，直接用 `widget.marquee`、`widget.interval`。保留 `_effectiveSpeed`（含 `speed > 0` 兜底）。

## 影响范围与 API 变化

- 公开 API：删除 `left`、`right`、`prefixIcon`、`TNoticeBarVariant` 和 `TNoticeBarThemeData.variant`；新增实例 `status`、Widget 插槽 `prefix` / `operation` 与点击目标 `operation`。
- 内部实现：`_scroll`、`_getFontSize`、getter 清理。
- 测试：新增滚动距离回归测试、variant 色值校验。
- 文档：站点 README 同步为当前 API。

## 5. 公开 Demo 矩阵

按 `tdesign-miniprogram@1.16.0` 的公开页面边界调整 `ExampleModule` / `ExampleItem`：

- `01 组件类型`：纯文字、带图标、带关闭、带入口（2 个实例）、自定义样式、自定义内容。
- `02 组件状态`：单个 Example builder 组合普通、成功、警示、错误 4 个实例。
- `03 可滚动公告栏`：单个 Example builder 组合无图标水平、带图标水平、垂直 3 个实例。

Demo 使用收敛后的公开 API；内部点击回调由组件聚焦测试覆盖，公开页面关闭 `showTestModule`，避免 debug 截图出现非官方分组。

## Breaking change 分析

- 本次删除并重命名已发布公开 API，同时改变默认前缀图标、interval 与纵向轮播启用条件，属于 **breaking change**。
- 迁移方式：`left` → `prefix`；`prefixIcon: iconData` → `prefix: Icon(iconData)`；`right` → `operation`；Theme 中的 `variant` → 实例 `status`。
- 水平滚动距离从屏宽改为可视区宽仍属于缺陷修复。

## 风险与验证策略

- 滚动距离依赖 `_contentKey` 在 post-frame 后的测量；若测量为 0（首帧）会回退兜底值，首帧无崩溃风险。
- 通过 `flutter analyze` 静态校验改动文件。
- 通过新增单元测试验证滚动距离与 variant 色值。
- CI（flutter 3.32.0 与 latest）构建验证。

## Flutter 双版本兼容

- 改动仅涉及标准 `ScrollController`、`Timer`、`TextPainter` API，在 `flutter@3.32.0` 与 `flutter@latest` 中均可用且行为一致。
- 未引入新依赖或新 API。
