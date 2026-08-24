# 实施方案

## 技术方案

- 将 `TLink` 收敛为一个可组合的内容行：`underline`、`prefixIcon`、`suffixIcon` 独立解析。
- 用私有 Stateful 交互层跟踪 pressed / hovered / focused，只改变语义前景色，不新增公开状态 API。
- `TLinkResolve` 统一解析完整 TextStyle、图标尺寸、间距与三态颜色。
- `TLinkThemeData` 使用 `textStyle`、`iconSize`、`iconGap`、`underline` 和默认尺寸/颜色方案，移除互斥 variant 与左右不对称间距。
- Demo 只做官方场景编排，不覆盖组件文字、图标或交互默认值。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | Link | breaking API 与默认视觉对齐 |
| 直接消费方 | Message / Footer / Icon Demo | 迁移新 Link 契约 |
| 测试 | Link / Golden | 覆盖组合、三态、语义和 Token |
| 示例 | Link page | 与小程序 Demo 矩阵一致 |
| 文档 | dartdoc / API 资产 / Spec | 记录 breaking 迁移 |

## 风险与取舍

- 本次为 breaking change；旧 `basic` 直接删除，`underline` 迁移到同名布尔值，`icon` 通过显式 `prefixIcon` / `suffixIcon` 表达，不保留兼容分支。
- 不包含 Divider 和 Icon 的视觉重构，避免 PR 职责扩散。

## 验证策略

- 单元测试：resolver 的尺寸、三态颜色和 Theme 优先级。
- Widget 测试：组合、交互、禁用、Tooltip 与语义。
- Golden：浅色和深色官方样例及基础组件消费场景。
- 静态检查：Flutter 3.32.0 / latest analyze。
