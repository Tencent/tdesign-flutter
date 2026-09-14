# Footer 设计对齐与 API 收敛

## 证据与目标

- Figma Footer `24386:5265`；小程序 `origin/develop@cc2384cc5`。
- Demo 收敛为基础、链接、品牌三组；链接组含单链接与双链接，品牌组含两个设计实例。
- 删除与内容重复的必填 `variant`，改用 Flutter Widget 组合 Logo 与链接。

## 行为契约

- `logo` 非空时优先展示；否则 `links` 与 `text` 可组合。
- 链接保持自身固有宽度：单个链接与多链接均在同一行内水平居中，不因外层收缩包围盒被压缩而逐字换行；链接组整体超出可用宽度时按 `Wrap` 换行，分隔线只出现在同一行的相邻链接之间。
- 多链接间绘制分隔线；版权文字保持单行省略。
- Theme 高度作为可选的外层布局约束；未配置时由内容自然撑开，与小程序 Footer 的内容驱动布局一致。

## Breaking changes

- 删除 `TFooterVariant` 和构造器位置参数。
- `logo` 从资源路径改为 `Widget?`，`links` 改为 `List<Widget>`，删除 `width`。

## 验收

- [x] 组件、Demo、覆盖率、双版本 analyze/test 通过。
- [x] Flutter 3.32.0 Linux light/dark Golden 更新并复验通过。
- [x] 链接组在 375 逻辑宽度下保持单行并水平居中，窄容器下未被压缩换行。
