# Toast：新增可见遮罩（showOverlay / TOverlayConfig）与展示位置（placement）对齐 TDesign Mobile

## 背景

在 Issue #50 的调研（见 `t_toast.dart` 现状与小程序 `tdesign.tencent.com/miniprogram/components/toast` 对比）中，当前 Flutter `TToast` 与小程序 Toast 存在以下核心差距：

1. **无可见遮罩（showOverlay）**：现有实现只有"透明 `preventTap` 拦点击层"（`Colors.transparent`），没有小程序 `showOverlay` 提供的**可见半透明蒙层**能力，导致 cover demo 无法实现。
2. **遮罩属性无收敛口**：现有 `preventTap` 是散落在 6 个 `showXxx` 上的 `bool?`，没有统一的"蒙层行为"配置；小程序侧 `overlayProps`（遮罩颜色、透明度、是否拦点击、zIndex 等）无从透传。
3. **无 placement（top/middle/bottom）**：小程序 Toast 支持 `placement: top / middle / bottom` 三种位置，Flutter 侧固定 `Center` 居中，无法顶部/底部展示。

## 目标

- 新增公开类 `TOverlayConfig`，统一收敛"是否显示可见蒙层（showOverlay）、蒙层颜色、蒙层透明度、是否拦截背景点击（preventTap）"。
- **收敛散参**：将原先散落在各 `showXxx` 上的 `bool? preventTap` **移除**，统一收敛到 `TOverlayConfig` 单一口子，形成**单一真源**（不兼容收敛版）。
- 每个 `showXxx` 方法只保留 **1 个可选参数** `TOverlayConfig? overlay`（默认 null，未传时行为与现状一致）。
- `_showOverlay` 统一解析 `TOverlayConfig`：可见蒙层颜色由 `showOverlay ? (color ?? black@opacity) : transparent` 决定；拦截点击由 `preventTap` 决定，与蒙层是否可见解耦。
- 新增展示位置 `placement`（top / middle / bottom），对齐小程序 `placement` 语义。
- **移除旧 `preventTap: bool?` 参数**（breaking change），既有调用需迁移为 `overlay: TOverlayConfig(preventTap: true)`。

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
- tdesign-site/docs/components/toast/README.md（同步新 API 与 demo 结构、修正过时引用；文档变更随本 PR 提交，但**不写入 PR 更新日志**——文档调整属用户无需感知的变更）

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

- `showText` / `showIconText` / `showLoading` / `showLoadingWithoutText` 直接接收 `TOverlayConfig? overlay` 并透传给 `_showOverlay`。
- `showSuccess` / `showWarning` / `showFail` 经由 `showIconText` 委托处透传 `overlay`。
- **移除 `bool? preventTap` 参数**（不兼容收敛版）：拦截点击只能通过 `overlay: TOverlayConfig(preventTap: true)` 开启。
- 各方法保留 `TToastPlacement placement = TToastPlacement.middle` 可选参数。

### _showOverlay 统一解析

- 拦截点击统一由 `TOverlayConfig.preventTap` 决定（单一真源）：`finalPreventTap = (overlay ?? const TOverlayConfig()).preventTap`。
- 蒙层是否可见：`overlay?.showOverlay ?? false`。
- 蒙层颜色：`overlay != null && overlay.showOverlay ? (overlay.color ?? Colors.black.withValues(alpha: overlay.opacity)) : Colors.transparent`。
- 布局：
  - 有可见蒙层或需要拦点击（`showOverlay || preventTap`）时用 `Stack` + 全屏蒙层 `Container`，Toast 按 `placement` 对齐；
  - 否则直接 `Align(alignment: placementOffset, child: widget)`。
- 位置：`placement` 决定 Toast 的垂直位置（水平恒居中，垂直百分比偏移，对齐小程序 / mobile-vue）：
  - `top` → `FractionalOffset(0.5, 0.25)`（距顶 25%）
  - `middle` → `FractionalOffset(0.5, 0.5)`（正中）
  - `bottom` → `FractionalOffset(0.5, 0.75)`（距底 25%）
  - 百分比定位天然避让安全区，**不叠加 SafeArea**（移除原实现）。

### 兼容性（不兼容收敛版）

- 不传 `overlay`、不传 `placement`（默认 middle）时，行为与现状完全一致（居中、无可见蒙层）。
- **breaking change**：移除 `showXxx` 上的 `bool? preventTap` 参数。既有调用 `preventTap: true` 需迁移为 `overlay: TOverlayConfig(preventTap: true)`。
- 更新日志中该条使用 `breaking` commit type（`- breaking(toast): 移除 preventTap 参数，改用 overlay`）提醒用户迁移。

## 验收标准

- [ ] `TOverlayConfig` 公开类存在，字段与默认值符合契约。
- [ ] 每个 `showXxx` 均可接收 `overlay` 与 `placement`，不传时行为与现状一致。
- [ ] `showOverlay: true` 时渲染可见半透明蒙层，颜色/透明度可由 `TOverlayConfig.color` / `opacity` 控制；未传 `opacity` 时默认 0.2 派生黑色蒙层。
- [ ] `preventTap` 拦截点击与 `showOverlay` 可见蒙层解耦；两者均关闭时不渲染蒙层/拦截层（直接 Align）。
- [ ] `placement: top / middle / bottom` 分别对齐顶部 / 居中 / 底部；`placement` 与 `overlay` 组合时位置仍生效。
- [ ] 所有 `showXxx`（showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText）均透传 `overlay` 与 `placement`。
- [ ] `TOverlayConfig.preventTap: true` 生效（透明拦截层）。
- [ ] 旧 `bool? preventTap` 参数已从所有 `showXxx` 移除，迁移为 `TOverlayConfig`。
- [ ] 示例页对齐小程序 demo（含显示遮罩、多行文字、竖向图标、加载自定义等）。
- [ ] 纯文字 / 带图标 / 加载类 Toast 的默认最大宽度对齐小程序与 mobile-vue（`max-width: 185px`，Flutter `maxWidth` 默认值由 191 调整为 185），并统一 `_TTextToast` 与 `_TIconTextToast` / `_TToastLoading` 的取值口径（不再使用 `191.scale` 缩放写法）。
- [ ] 纯文字 Toast（`_TTextToast`）默认 padding 对齐小程序 / mobile-vue（`LTRB(24,16,24,16)` → `LTRB(22,14,22,14)`，水平 22 / 垂直 14）。
- [ ] 带图标横向 Toast（`_TIconTextToast` horizontal）默认 padding 对齐小程序 / mobile-vue（水平 24 → 22，垂直保持 14，即 `LTRB(22,14,22,14)`）。
- [ ] 加载带文字 Toast（`_TToastLoading`）默认 min 尺寸对齐小程序 / mobile-vue（110×110 → 102×102），默认 padding 改为水平 24 / 垂直 0（`EdgeInsets.symmetric(horizontal: 24)`）。
- [ ] toast 相关单元 / Widget 测试通过。
- [ ] flutter analyze 与 git diff --check 通过。
