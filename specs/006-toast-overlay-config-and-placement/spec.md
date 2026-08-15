# Toast：新增可见遮罩（showOverlay / TOverlayConfig）与展示位置（placement）对齐 TDesign Mobile

## 背景

在 Issue #50 的调研（见 `t_toast.dart` 现状与小程序 `tdesign.tencent.com/miniprogram/components/toast` 对比）中，当前 Flutter `TToast` 与小程序 Toast 存在以下核心差距：

1. **无可见遮罩（showOverlay）**：现有实现只有"透明 `preventTap` 拦点击层"（`Colors.transparent`），没有小程序 `showOverlay` 提供的**可见半透明蒙层**能力，导致 cover demo 无法实现。
2. **遮罩属性无收敛口**：现有 `preventTap` 是散落在 6 个 `showXxx` 上的 `bool?`，没有统一的"蒙层行为"配置；小程序侧 `overlayProps`（遮罩颜色、透明度、是否拦点击、zIndex 等）无从透传。
3. **无 placement（top/middle/bottom）**：小程序 Toast 支持 `placement: top / middle / bottom` 三种位置，Flutter 侧固定 `Center` 居中，无法顶部/底部展示。

## 目标

- 新增公开类 `TOverlayConfig`，统一收敛"是否显示可见蒙层（showOverlay）、蒙层颜色、蒙层透明度、是否拦截背景点击（preventTap）"。
- 每个 `showXxx` 方法只新增 **1 个可选参数** `TOverlayConfig? overlay`（默认 null，零负担、非 breaking）。
- `_showOverlay` 统一解析 `TOverlayConfig`：可见蒙层颜色由 `showOverlay ? (color ?? black@opacity) : transparent` 决定；拦截点击由 `preventTap` 决定，与蒙层是否可见解耦。
- 新增展示位置 `placement`（top / middle / bottom），对齐小程序 `placement` 语义。
- 保留旧 `preventTap: bool?` 参数做向后兼容（有 `overlay` 时以 `overlay.preventTap` 为准，否则沿用旧布尔参数）。

## 非目标

- 不新增 `overlayProps` 平铺散参数（用 `TOverlayConfig` 具名类收敛）。
- 不实现 zIndex / blur 等高级遮罩能力（留作 `TOverlayConfig` 未来扩展字段）。
- 不实现 `close` / `destroy` 回调事件（列为后续项，本次聚焦遮罩 + 位置）。
- 不改动 Popup、Dialog、ActionSheet 等其他 Overlay 组件。
- 不改变加载类 Toast（showLoading / showLoadingWithoutText）的"永不自动消失"语义。

## 范围

### 涉及

- tdesign-component/lib/src/components/toast/t_toast.dart
- tdesign-component/test/components/toast/t_toast_test.dart
- tdesign-component/example/lib/page/t_toast_page.dart
- tdesign-site/docs/components/toast/README.md

### 不涉及

- 其他 Overlay 组件（ActionSheet / Dialog / Drawer）
- `tdesign-component/CHANGELOG.md`（由 CLI 自动生成）

## 行为契约

### TOverlayConfig

新增公开类：

```dart
class TOverlayConfig {
  final bool showOverlay;  // 是否显示可见半透明蒙层（默认 false）
  final Color? color;      // 蒙层颜色（null 时由 opacity 派生黑色蒙层）
  final double opacity;    // 蒙层透明度（默认 0.2，0~1）
  final bool preventTap;   // 是否拦截背景点击（默认 false）
  const TOverlayConfig({...});
}
```

- `showOverlay == true` 时展示可见蒙层，颜色 = `color ?? Colors.black.withValues(alpha: opacity)`。
- `showOverlay == false` 时不展示可见蒙层（透明层仍可由 `preventTap` 决定是否拦点击）。
- `preventTap == true` 时全屏层拦截背景点击，与蒙层是否可见解耦。

### showXxx 签名

- `showText` / `showIconText` / `showLoading` / `showLoadingWithoutText` 直接新增 `TOverlayConfig? overlay` 并透传给 `_showOverlay`。
- `showSuccess` / `showWarning` / `showFail` 经由 `showIconText` 委托处透传 `overlay`。
- 保留现有 `bool? preventTap` 参数，不删除（向后兼容旧调用）。
- 各方法新增 `TToastPlacement placement = TToastPlacement.middle` 可选参数。

### _showOverlay 统一解析

- `preventTap` 合并：`overlay?.preventTap ?? false` 与旧 `preventTap ?? false` 取**或**（任一要求拦点击即拦，避免两者都设置时互相覆盖）。
- 蒙层是否可见：`overlay?.showOverlay ?? false`。
- 蒙层颜色：`overlay != null && overlay.showOverlay ? (overlay.color ?? Colors.black.withValues(alpha: overlay.opacity)) : Colors.transparent`。
- 布局：
  - 有可见蒙层或需要拦点击（`showOverlay || preventTap`）时用 `Stack` + 全屏蒙层 `Container`，Toast 按 `placement` 对齐；
  - 否则直接 `Align(alignment: placementAlignment, child: widget)`。
- 位置：`placement` 决定 Toast 在屏幕上的对齐方式：
  - `top` → `Alignment.topCenter`（带顶部安全距）
  - `middle` → `Alignment.center`
  - `bottom` → `Alignment.bottomCenter`（带底部安全距）

### 兼容性

- 不传 `overlay`、不传 `placement`（默认 middle）时，行为与现状完全一致（居中、无可见蒙层）。
- `preventTap: true`（不传 overlay）仍铺透明拦截层，行为不变。
- 新增类型与可选参数，**非 breaking**。

## 验收标准

- [ ] `TOverlayConfig` 公开类存在，字段与默认值符合契约。
- [ ] 每个 `showXxx` 均可接收 `overlay` 与 `placement`，不传时行为与现状一致。
- [ ] `showOverlay: true` 时渲染可见半透明蒙层，颜色/透明度可由 `TOverlayConfig.color` / `opacity` 控制。
- [ ] `preventTap` 拦截点击与 `showOverlay` 可见蒙层解耦。
- [ ] `placement: top / middle / bottom` 分别对齐顶部 / 居中 / 底部。
- [ ] 旧 `preventTap: true` 调用仍生效（透明拦截层）。
- [ ] 示例页对齐小程序 demo（含显示遮罩、多行文字、竖向图标、加载自定义等）。
- [ ] toast 相关单元 / Widget 测试通过。
- [ ] flutter analyze 与 git diff --check 通过。
