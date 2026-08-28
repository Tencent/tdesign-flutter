# Popup left/right 圆角对齐与动画时长评估

## 背景

在 Popup 跨端对照 Review（Issue #72）中发现两处与官方（小程序、Mobile Vue）不一致的 UI 表现：

1. **left/right 圆角差异**：官方 left/right 为无圆角全高矩形；Flutter 当前对 left 施加右缘圆角、right 施加左缘圆角。
2. **动画时长来源不一致**：小程序 `duration` 属性默认值为 240ms，而 Popup 样式和蒙层回退值为 300ms；Flutter 原默认值为 240ms，本 PR 当前候选实现为 300ms，尚不能把任一值声明为唯一官方契约。

## 目标

- left/right 默认无圆角（对齐官方全高矩形），但保留通过 `TPopupThemeData.panelRadius` / `TPopupOptions.radius` 自定义圆角的能力（tokenTheme 可自定义）。
- 记录 240ms / 300ms 的来源冲突；默认动画时长须由维护者确认后再作为最终契约验收。

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

### 动画时长（待确认）

- 本 PR 当前候选实现为：`TPopupOptions.animationDuration` 与 `TPopupThemeData.transitionDuration` 均未设置时使用 300ms。
- 合并前须在 240ms 与 300ms 之间确认权威默认值，并同步实现、dartdoc、站点文档、API 文档、测试与更新日志。
- 显式设置任一者时仍以显式值为准。

## 验收标准

- [ ] left/right 未设置 radius 时面板渲染为无圆角矩形。
- [ ] left/right 设置 radius 或 `TPopupThemeData.panelRadius` 时应用对应内缘圆角。
- [ ] top/bottom/center 圆角默认行为不变。
- [ ] 维护者确认默认动画时长，并完成实现、文档和测试的一致性复核。
- [ ] 相关 dartdoc、站点文档、api 文档同步更新。
- [ ] `flutter analyze --fatal-infos` 0 error / 0 warning / 0 info（Flutter 3.32.0 与 latest）。
- [ ] focused 测试通过，行覆盖率不下降。
