# TNoticeBar Review 修复 - 技术方案

## 问题与方案

### 1. 水平滚动距离使用屏幕宽度（P1）

**现状**：`_scroll()` 中 `scrollDistance = _getContextWidth() + (_size!.width - _effectivePadding.horizontal)`，其中 `_size = MediaQuery.of(context).size` 是整屏宽度。

**方案**：改用 `_getEmptyWidth()`（通过 `_contentKey` 测量的公告栏可视区宽度），即
`scrollDistance = _getContextWidth() + _getEmptyWidth()`。

`_getEmptyWidth()` 内部已有兜底：当 `_contentKey.currentContext` 尚未挂载（首次 build）时回退到 `_size!.width - padding.horizontal`，保证首帧不崩。

### 2. speed 语义与计时（P1）

**现状**：水平滚动每个 tick 固定 `animateTo(offset, duration: 1s)`，`offset` 每 tick 加 `_effectiveSpeed`。动画耗时恒为 1s，实际速率 = 每个 tick 位移 / 1s。当每个 tick 前进 `speed` 像素时，速率 = `speed` px/s。

**方案**：保留"每个 tick 前进 `speed` 像素 + 动画 1s"的模型，确保速率恒为 `speed` px/s；为降低 `Timer.periodic` 与 `await animateTo` 叠加的时序漂移，tick 回调中 `await` 动画完成后再安排下一次前进，避免动画互相追赶。垂直 step 的时长已按 `位移 / speed` 计算（`time = height / speed * 1000`），保持不变。

> 结论：`speed` 语义（px/s）经核对在当前实现中已成立，本次主要是修正**滚动距离**这一实际错误，并固化速率计算与注释说明，避免后续回归。

### 3. 尺寸语义统一（P2）

`_getContextWidth()` 返回文本宽度（`_key` 处第一个文本 `SizedBox`），`_getEmptyWidth()` 返回可视区宽度（`_contentKey` 的 Expanded 区域）。两者职责清晰，本次在 `_scroll()` 与 `_getFontSize()` 中统一使用：
- `_getContextWidth()` → 文本宽度，用于计算滚动总距离。
- `_getEmptyWidth()` → 可视区宽度，用于计算滚动总距离与文本布局 `maxWidth`（原 `_getFontSize` 用 `_size!.width`，改为可视区宽度，避免窄容器内文本按屏宽换行）。

### 4. 冗余 getter（轻微）

删除 `_effectiveMarquee`、`_effectiveInterval`，直接用 `widget.marquee`、`widget.interval`。保留 `_effectiveSpeed`（含 `speed > 0` 兜底）。

## 影响范围与 API 变化

- 公开 API：**无变化**。不改动 `TNoticeBar` 构造参数、`TNoticeBarThemeData`、`TNoticeBarVariant`、`TNoticeBarTapTarget`。
- 内部实现：`_scroll`、`_getFontSize`、getter 清理。
- 测试：新增滚动距离回归测试、variant 色值校验。
- 文档：站点 README 同步为当前 API。

## Breaking change 分析

- 不改变公开 API 签名、默认行为，未删除能力，**非 breaking change**。
- 水平滚动距离行为变化（从屏宽→可视区宽）属于缺陷修复，修正后表现更符合预期，不构成对既有调用方的破坏。

## 风险与验证策略

- 滚动距离依赖 `_contentKey` 在 post-frame 后的测量；若测量为 0（首帧）会回退兜底值，首帧无崩溃风险。
- 通过 `flutter analyze` 静态校验改动文件。
- 通过新增单元测试验证滚动距离与 variant 色值。
- CI（flutter 3.32.0 与 latest）构建验证。

## Flutter 双版本兼容

- 改动仅涉及标准 `ScrollController`、`Timer`、`TextPainter` API，在 `flutter@3.32.0` 与 `flutter@latest` 中均可用且行为一致。
- 未引入新依赖或新 API。
