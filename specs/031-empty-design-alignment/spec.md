# Empty 设计对齐与 API 收敛

## 证据与目标

- Figma Empty `24386:5266`；小程序 `origin/develop@cc2384cc5`。
- 公开 Demo 仅保留图标、自定义图片、带操作三种设计场景。
- 删除重复描述内容存在性的 `variant`；操作区直接由 Widget 组合。

## 行为契约

- 图片优先于图标，描述始终可选；操作 Widget 非空时以 32 间距展示。
- 默认图标 96，图标/图片到描述间距分别为 22/16。
- Theme 只保存描述文字的具体颜色和字体，不保存按钮语义配色。

## Breaking changes

- 删除 `TEmptyVariant`、`variant`、`operationText`、`onPressed`。
- `customOperationWidget` 收敛并改名为 `operation`。

## 验收

- [ ] 组件、Demo、覆盖率、双版本 analyze/test 通过。
- [ ] Flutter 3.32.0 Linux light/dark Golden 更新并复验通过。
