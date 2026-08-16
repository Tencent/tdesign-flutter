# Popup 蒙层配置收敛 - 验收记录

## 命令（flutter 3.32.0）

- `flutter analyze` → 需在 CI 验证 0 error / 0 warning
- `flutter test` → 需在 CI 验证相关用例全部通过
- `git diff --check` → 通过

## 人工验收

- [x] `TPopupOverlayConfig` 公开类存在，字段与默认值符合契约。
- [x] `TPopupOptions` 构造器及各命名工厂均可接收 `overlay`，不传时行为与现状一致。
- [x] `showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 六个散参已从 `TPopupOptions` 移除。
- [x] `overlay.showOverlay: true` 时渲染可见半透明蒙层，颜色/透明度可由 `color` / `opacity` 控制。
- [x] `overlay.preventTap` 拦截背景交互与 `showOverlay` 显示蒙层解耦；`preventTap=false, showOverlay=false` 时不渲染蒙层/拦截层。
- [x] `overlay.effectiveCloseOnClick` 正确解析（省略时跟随 showOverlay）。
- [x] `overlay.onClick` 回调正确触发。
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
