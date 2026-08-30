# Popup 蒙层配置收敛 - 验收记录

## 自动化验证

- Flutter 3.32.0 与 latest 3.47.0：`flutter analyze --no-pub --fatal-infos` 均为 0 error / 0 warning。
- Flutter 3.32.0 与 latest 3.47.0：Popup 完整组件回归 194 项通过。
- 新增穿透交互用例验证 `showOverlay=true, preventTap=false` 时背景收到点击，`onClick` 不触发，Popup 不因蒙层点击关闭。
- Popup 生产源码覆盖率：`607/624 = 97.28%`。

## 人工验收

- [x] `TPopupOverlayConfig` 公开类存在，字段与默认值符合契约。
- [x] `TPopupOptions` 构造器及各命名工厂均可接收 `overlay`，不传时行为与现状一致。
- [x] `showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 六个散参已从 `TPopupOptions` 移除。
- [x] `overlay.showOverlay: true` 时渲染可见半透明蒙层，颜色/透明度可由 `color` / `opacity` 控制。
- [x] `overlay.preventTap` 拦截背景交互与 `showOverlay` 显示蒙层解耦；`preventTap=false, showOverlay=false` 时不渲染蒙层/拦截层。
- [x] `overlay.effectiveCloseOnClick` 仅在显示且拦截蒙层点击时可为 true。
- [x] `overlay.onClick` 仅在可点击的可见蒙层上触发；穿透模式不触发并由背景接收点击。
- [x] theme 的 `barrierColor` / `barrierOpacity` 作为 `TPopupOverlayConfig.color` / `opacity` 的默认值生效。
- [x] ActionSheet / Dialog / Drawer 迁移到新 API 后行为不变。
- [x] 站点 README 与 example API 文档已同步。

## 未覆盖项 / 后续项

- 非 center 方向的关闭按钮（`closeBtn`）支持（后续迭代）。
- `preventScrollThrough` 阻止背景滚动（后续迭代）。
- `TPopupOverlayConfig` 的 zIndex / blur 高级扩展（后续迭代）。
- 默认尺寸策略对齐（top/bottom 内容自适应 / left/right 全高）（后续迭代）。
- center 缩放动画从 scale(0) 对齐到 scale(.6)（后续迭代）。

## 结论

- [x] 已满足 spec.md 验收标准
