# 实施方案

## 技术方案

在 TSwitch 上新增必选默认值参数 `loading = false`，并从
`TSwitchVariant` 删除 `loading`。构建时先根据 `loading` 决定交互能力和
加载指示器，再由 `variant` 处理非加载内容形态，避免两个加载状态源。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | switch/t_switch.dart、t_switch_types.dart | breaking API 收敛 |
| 测试 | t_switch_test.dart、switch_page_test.dart | 更新加载态和回归覆盖 |
| 示例 | t_switch_page.dart、Golden、生成片段 | 迁移到 loading 参数 |
| 文档 | Switch API 产物、Spec | 记录新契约和迁移方式 |

## API 变化

- 新增 `TSwitch.loading`，默认 `false`。
- 删除 `TSwitchVariant.loading`。
- 迁移：`variant: TSwitchVariant.loading` 改为 `loading: true`。

## 风险与取舍

- 删除枚举值是 breaking change，不保留兼容别名，以免形成双状态源。
- loading 与 variant 同时传入时，loading 负责当前状态并覆盖滑块内容；
  loading 结束后恢复 variant 指定的内容形态。

## 验证策略

- 单元测试：加载渲染、禁用交互、variant 恢复和 API 形态。
- 集成或 Widget 测试：Demo 状态矩阵、交互及 light/dark Golden。
- 静态检查：组件包和 Example 包 flutter analyze。
- 人工验收：Android 实机查看加载、禁用、尺寸分组。
