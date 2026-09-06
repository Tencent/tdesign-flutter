# Footer 设计对齐与 API 收敛

## 证据与目标

- Figma Footer `24386:5267`；小程序 `origin/develop@cc2384cc5`。
- Demo 收敛为基础、链接、品牌三组；链接组含单链接与双链接，品牌组含两个设计实例。
- 删除与内容重复的必填 `variant`，改用 Flutter Widget 组合 Logo 与链接。

## 行为契约

- `logo` 非空时优先展示；否则 `links` 与 `text` 可组合。
- 多链接间绘制分隔线；版权文字保持单行省略。
- Theme 高度继续作为具体布局默认值。

## Breaking changes

- 删除 `TFooterVariant` 和构造器位置参数。
- `logo` 从资源路径改为 `Widget?`，`links` 改为 `List<Widget>`，删除 `width`。

## 验收

- [ ] 组件、Demo、覆盖率、双版本 analyze/test 通过。
- [ ] Flutter 3.32.0 Linux light/dark Golden 更新并复验通过。
