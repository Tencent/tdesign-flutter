# TToast：单实例替换语义

## 背景

当前 TToast 组件在每次调用 `showText` / `showIconText` / `showSuccess` / `showWarning` / `showFail` / `showLoading` 等方法时，如果未显式传入 `toastId`，会通过 `_generateToastId()` 生成一个新的唯一 ID。不同 ID 的 Toast 可以在 Overlay 中**并存**，导致：

1. **多层 Toast 叠加**：多次触发 Toast 显示时，多个 Toast 气泡同时渲染在 Overlay 上，出现视觉重叠。
2. **背景越来越深**：Toast 默认背景色为半透明（`fontGyColor1` rgba(0,0,0,0.9)），多个半透明背景叠加后视觉上背景越来越深、越来越黑。
3. **不符合 TDesign Mobile 行为**：TDesign Mobile 的 Toast 为单实例设计，新 Toast 出现时旧的 Toast 应被移除。

## 目标

- 默认行为改为**单实例替换语义**：每次展示新 Toast 时，先移除所有已存在的 Toast 实例，再展示新的。
- 保留 `toastId` 参数能力：用户显式传入 `toastId` 时，相同 ID 的 Toast 仍按替换逻辑处理。
- 保持 `dismissToast` / `dismissAll` 手动关闭 API 不变。
- 消除多个 Toast 叠加导致背景变深的问题。

## 非目标

- 不新增、不删除、不重命名 TToast 的任何公共 API 或参数。
- 不改变 Toast 的默认时长、背景色等样式行为（这些由 spec 004-toast-contract-alignment 处理，不在本范围）。
- 不改变 `showLoading` 等加载类 Toast 的"永不自动消失"语义。
- 不改变 Toast 的淡入淡出动画等视觉体验。

## 范围

### 涉及

- `tdesign-component/lib/src/components/toast/t_toast.dart`
- `tdesign-component/test/components/toast/t_toast_test.dart`

### 不涉及

- `tdesign-component/example/` 下 toast 示例页
- 站点组件 README 的手工维护；API Markdown 由生成链负责
- 主题 token 定义

## 行为契约

### 展示语义

- 所有 show 方法（showText / showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText）在展示新 Toast 前，**先移除所有已存在的 Toast 实例**，再插入新的 Toast。
- 无论是否传入 `toastId`，默认行为都是"新 Toast 替换所有旧 Toast"。
- 传入相同 `toastId` 时，行为与上述一致（旧实例先被移除，新实例展示）。
- 传入不同 `toastId` 时，同样先移除所有旧实例，只展示最新的 Toast。

### 关闭语义

- `dismissToast(toastId)`：关闭指定 ID 的 Toast。
- `dismissAll()`：关闭所有 Toast。
- Toast 自动消失逻辑不变（duration 到期后自动移除）。

### 兼容性

- 用户如果依赖"多实例并存"的行为，将不再适用——这是本次修改的核心变化，属于 breaking change。
- `toastId` 参数仍保留，但不再用于区分并存的多个实例，仅作为实例标识。

## 验收标准

- [ ] 连续多次调用 `showText`，每次新的 Toast 会替换旧的 Toast，屏幕上始终只有一个 Toast。
- [ ] 连续多次调用 `showLoading`，同样只保留最新的 Toast。
- [ ] 传入相同 `toastId` 时，行为正确（新替换旧）。
- [ ] 传入不同 `toastId` 时，行为正确（新替换所有旧）。
- [ ] `dismissToast` 和 `dismissAll` 仍正常工作。
- [ ] toast 相关单元 / Widget 测试通过。
- [ ] flutter analyze 与 git diff --check 通过。
