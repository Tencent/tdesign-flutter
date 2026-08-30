# 实施方案

## 技术方案

### 圆角对齐（left/right 无圆角 + tokenTheme 可自定义）

在 `_popup_shell.dart` 的 `build` 中，根据 placement 决定默认圆角来源：

- top/bottom/center：`radius = options.radius ?? theme.radiusExtraLarge`（保持原行为）。
- left/right：`radius = options.radius`（`TPopupThemeData.panelRadius` 已在 `t_popup.dart` show 中注入到 `options.radius`）。

`_borderRadius` 改为接收 `double?`：left/right 在 `radius == null` 时返回 `null`（`Container` 无圆角），否则返回内缘圆角。

### 动画时长对齐

将 `_popup_route.dart` 中的默认动画时长恢复为 240ms。小程序运行时把默认 `duration` 传给 Popup 样式和蒙层，故公开属性的 240ms 是有效基线；300ms 仅为参数缺失时的内部回退。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `_popup_shell.dart` | left/right 默认无圆角 |
| 组件 | `_popup_route.dart` / `t_popup.dart` | 默认动画时长保持 240ms |
| 测试 | `t_popup_coverage_test.dart` | 新增圆角与动画时长 focused 测试 |
| 文档 | `README.md` / `popup_api.md` / dartdoc | 更新默认值说明 |

## API 变化

- 无公开 API 名称 / 签名 / 参数变更。
- 仅默认行为变化（left/right 圆角默认值、动画时长默认值）。

## 风险与取舍

- **breaking change**：left/right 由有内缘圆角变为无圆角，可能影响既有页面的视觉表现，需在 PR 更新日志明确标记；动画时长恢复原有 240ms，不构成额外默认行为变化。
- 迁移策略：需要 left/right 圆角的用户可通过 `TPopupThemeData.panelRadius` 或 `TPopupOptions.radius` 显式设置，保持兼容。

## 验证策略

- 单元测试：`t_popup_coverage_test.dart` 覆盖 left/right 默认无圆角、设置 radius 有圆角和 240ms 默认动画时长。
- 静态检查：`flutter analyze --fatal-infos`（Flutter 3.32.0 与 latest）。
- 人工验收：真机确认 left/right 无圆角表现与动画时长。
