# Popup left/right 圆角与动画时长对齐

## 背景

在 Popup 跨端对照 Review（Issue #72）中发现两处与官方（小程序、Mobile Vue）不一致的 UI 表现：

1. **left/right 圆角差异**：官方 left/right 为无圆角全高矩形；Flutter 当前对 left 施加右缘圆角、right 施加左缘圆角。
2. **动画时长差异**：官方默认动画时长 300ms；Flutter 当前默认 240ms，且与仓库其他浮层组件（如 message、progress）的 300ms 不一致。

维护者已拍板对齐这两项。

## 目标

- left/right 默认无圆角（对齐官方全高矩形），但保留通过 `TPopupThemeData.panelRadius` / `TPopupOptions.radius` 自定义圆角的能力（tokenTheme 可自定义）。
- Popup 默认动画时长由 240ms 调整为 300ms，与官方及其他浮层组件对齐。

## 非目标

- 不改变 top/bottom/center 的圆角默认行为（仍默认主题大圆角）。
- 不改变动画曲线（本次仅对齐时长，不改 decelerate/easeOut 曲线）。
- 不调整面板默认尺寸、遮罩、安全区等其他表现。

## 范围

### 涉及

- `tdesign-component/lib/src/components/popup/_popup_shell.dart`（圆角逻辑）
- `tdesign-component/lib/src/components/popup/_popup_route.dart`（动画时长默认值）
- `tdesign-component/lib/src/components/popup/t_popup.dart`（动画时长默认值）
- `tdesign-component/lib/src/components/popup/t_popup_options.dart`（dartdoc）
- `tdesign-component/lib/src/components/popup/t_popup_theme_data.dart`（dartdoc）
- 测试：`tdesign-component/test/t_popup_coverage_test.dart`
- 文档：`tdesign-site/docs/components/popup/README.md`、`example/assets/api/popup_api.md`

### 不涉及

- 不涉及 ActionSheet / Dialog / Drawer 等复用 Popup 的组件行为改动。
- 不涉及 Popup API 名称 / 签名变更。

## 行为契约

### 圆角

- `TPopupPlacement.top`、`TPopupPlacement.bottom`、`TPopupPlacement.center`：默认使用全局主题大圆角（`theme.radiusExtraLarge`），`TPopupOptions.radius` 或 `TPopupThemeData.panelRadius` 可覆盖。
- `TPopupPlacement.left`、`TPopupPlacement.right`：
  - 未显式设置 `radius`（含未设置 `TPopupThemeData.panelRadius`）时，面板为**无圆角全高矩形**（`BorderRadius` 为 null）。
  - 显式设置 `radius` 或经 `TPopupThemeData.panelRadius` 注入时，left 应用右缘圆角、right 应用左缘圆角。

### 动画时长

- `TPopupOptions.animationDuration` 未设置、且 `TPopupThemeData.transitionDuration` 未设置时，默认动画时长为 **300ms**（原 240ms）。
- 显式设置任一者时以显式值为准。

## 验收标准

- [ ] left/right 未设置 radius 时面板渲染为无圆角矩形。
- [ ] left/right 设置 radius 或 `TPopupThemeData.panelRadius` 时应用对应内缘圆角。
- [ ] top/bottom/center 圆角默认行为不变。
- [ ] 默认动画时长为 300ms。
- [ ] 相关 dartdoc、站点文档、api 文档同步更新。
- [ ] `flutter analyze --fatal-infos` 0 error / 0 warning / 0 info（Flutter 3.32.0 与 latest）。
- [ ] focused 测试通过，行覆盖率不下降。
