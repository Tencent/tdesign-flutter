# TToast：单实例替换语义与精简 API

## 背景

当前 TToast 组件在每次调用 `showText` / `showIconText` / `showSuccess` / `showWarning` / `showFail` / `showLoading` 等方法时，如果未显式传入 `toastId`，会通过 `_generateToastId()` 生成一个新的唯一 ID，并支持不同 ID 的 Toast 在 Overlay 中**并存**。这带来两类问题：

1. **多实例并存导致视觉叠加**：多次触发 Toast 显示时，多个 Toast 气泡同时渲染在 Overlay 上出现视觉重叠，且半透明背景（`fontGyColor1` rgba(0,0,0,0.9)）叠加后背景越来越深。
2. **API 冗余**：Toast 的所有形态都渲染在同一个固定位置（Overlay 居中），多个 Toast 并存时必然重叠，多实例在视觉上无意义。`toastId`、`_toastInstances`（Map）、`_generateToastId()`、`dismissToast(toastId)` 这一整套以"多实例"为假设的基础设施，在单实例语义下是冗余代码。

TDesign Mobile 的 Toast 为单实例设计，新 Toast 出现时旧的 Toast 应被移除。

## 目标

- 默认行为改为**单实例替换语义**：每次展示新 Toast 时，先移除旧的 Toast，再展示新的。
- **精简公共 API**：移除以多实例为前提的 `toastId` 参数与 `dismissToast(toastId)`，用无参的 `dismiss()` 关闭当前 Toast；保留 `dismissAll()` 兼容旧用法。
- 消除多个 Toast 叠加导致背景变深的问题。

## 非目标

- 不改变 Toast 的默认时长、背景色等样式行为（这些由 spec 004-toast-contract-alignment 处理，不在本范围）。
- 不改变 `showLoading` 等加载类 Toast 的"永不自动消失"语义。
- 不改变 Toast 的淡入淡出动画等视觉体验。
- 不引入多实例并存的能力（这正是本次要移除的方向）。

## 范围

### 涉及

- `tdesign-component/lib/src/components/toast/t_toast.dart`
- `tdesign-component/test/components/toast/t_toast_test.dart`
- `tdesign-component/example/lib/page/t_toast_page.dart`（`showLoading` 示例改用 `dismiss()`）

### 不涉及

- 站点组件 README 的手工维护；API Markdown 由生成链负责
- 主题 token 定义

## 行为契约

### 展示语义

- 所有 show 方法（showText / showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText）在展示新 Toast 前，**先移除当前已存在的 Toast**，再插入新的 Toast。
- 屏幕上同一时刻**至多存在一个 Toast**，永远只有最新展示的那个可见。
- 所有 show 方法**返回 void**，不再返回 toastId。

### 关闭语义

- `dismiss()`：关闭当前展示中的 Toast。
- `dismissAll()`：与 `dismiss()` 等价（单实例语义下没有"多个"），保留以兼容旧用法。
- Toast 自动消失逻辑不变（duration 到期后自动移除）。

### API 变化（breaking change）

- **删除** `toastId` 参数（showText / showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText 全部移除）。
- **删除** `dismissToast(String toastId)` 方法，由 `dismiss()` 替代。
- **变更** 所有 show 方法返回值由 `String` 改为 `void`。
- 新增 `dismiss()` 方法。

## 验收标准

- [ ] 连续多次调用 `showText`，每次新的 Toast 会替换旧的 Toast，屏幕上始终只有一个 Toast。
- [ ] 连续多次调用 `showLoading`，同样只保留最新的 Toast。
- [ ] `dismiss()` 能关闭当前 Toast。
- [ ] `dismissAll()` 仍正常工作（等价于 `dismiss()`）。
- [ ] 仓库内不再存在 `toastId` / `dismissToast` / `_generateToastId` 等引用。
- [ ] toast 相关单元 / Widget 测试通过。
- [ ] flutter analyze 与 git diff --check 通过。
