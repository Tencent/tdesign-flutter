# 验收记录

## 验证环境

- 分支：`rss1102/fix/site-theme-all-tokens`
- 基线：`origin/develop` (`b8a4bec7d`)
- Flutter/Dart：Flutter 3.32.0 与 3.47.0
- Node/pnpm：Node 24.15.0 / pnpm 11.20.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `corepack pnpm test:theme` | 通过 | 4 个转换契约测试 |
| `corepack pnpm site` | 通过 | Vite 生产构建；仅有既有资源路径和 chunk 大小警告 |
| `flutter test --no-pub test/web_theme_message_test.dart` | 通过 | Flutter 3.32.0，3 个测试 |
| `flutter analyze --fatal-infos` | 通过 | Flutter 3.32.0，0 issues |
| Flutter 3.47.0 聚焦测试与严格 analyze | 通过 | 双版本兼容，0 issues |
| `flutter build web --no-pub --base-href /flutter/example/` | 通过 | Flutter 3.32.0 官网子路径构建 |
| 三个调度器自测 | 通过 | 13 个测试，含 Example 测试清单登记 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [x] 官网生产构建中显示色彩、字体、圆角、阴影、尺寸五个面板
- [x] 暗色 Button Demo 加载后，字体从小号切到大号会触发 Flutter 语义树重建；标题宽度由 124.48 变为 129.67，按钮宽度由 104 变为 107.99
- [x] 重新加载页面及 iframe 后，持久化的小号配置能恢复；后续改为大号可再次同步

## 未覆盖项与后续工作

- 浏览器人工验收选择字体作为端到端代表项；其余面板由同一 MutationObserver/消息链路承载，并由纯转换单测逐组覆盖。
- 未改组件默认 Theme 或 Golden 基线；未操作远端分支或 PR。

## develop 同步验证（2026-10-06）

- Node 主题转换 5 项、文档适配 10 项通过，57 份组件文档映射检查通过。
- Flutter 3.32.0 / 3.47.0 消息解析各 3 项、回归调度器自测 19 项通过；两版本 Example 严格 analyze 无诊断，3.32.0 组件工程严格 analyze 无诊断。
- 站点生产构建通过；本轮未重新执行浏览器人工验收及 Golden。远端 CI 以同步后新提交为准。

## 当前 Token 重整验证（2026-10-06）

- Node 主题回归 10 项，文档适配 10 项；测试检查控制器包实际默认 CSS 的输出键均有当前 Flutter getter。
- Flutter 3.32.0 / 3.47.0 主题消息解析各 3 项与 Example 严格 analyze 通过。新增 fontMetric / insetShadow 解析及默认值保留断言。
- Example 生成片段 --check 通过；站点生产构建与 Flutter 3.47.0 Web 子路径发布构建通过。
- 浏览器同源开发入口下，Button 从大号切换小号，语义节点宽度由 107.99 变为 100；切回大号后往返 Divider/Button，重新加载的 Demo 保留 107.99。
- 本轮不修改组件默认 Theme 和 Golden，未更新 Golden 基线。远端 CI 以推送后 head 为准。
- 上游控制器限制：整页重载保留字号选项标签，但实际 CSS 回到默认；曾观察 Button 恢复 104。该现象不能当作桥接恢复成功，亦不由 iframe ready 握手修复。
