# Message 组件跨端 Demo 契约对齐

## 背景

TDesign Flutter 的 `TMessage` 组件（`tdesign-component/lib/src/components/message/`）在与 TDesign 小程序 / Mobile Vue 官方实现对齐时，存在以下差距（依据 `tdesign-miniprogram`、`tdesign-mobile-vue` 官方发布版源码逐项对照）：

1. **公开 Demo 覆盖不全**：Flutter 示例页 `t_message_page.dart` 仅覆盖"组件状态（4 主题）+ 跑马灯"，而官方存在以下公开 Demo 缺失：
   - 纯文字通知（无图标）、带关闭通知、带按钮（链接）通知 —— 对应小程序 `message/_example/base`、mobile-vue `message/demos/base.vue`；
   - 组件声明式调用（`visible` 受控）—— 对应小程序 `base/index.wxml` 的 `<t-message visible=...>`；
   - 多消息叠加 + 关闭所有通知 —— 对应 mobile-vue `message/demos/closeAll.vue`、小程序 `single`/`gap` 多消息能力。
2. **示例生成代码不同步**：`example/assets/code/` 仅含 `message._marquee.txt`，未与完整 Demo 同步。
3. **站点文档严重过期**：`tdesign-site/docs/components/message/README.md` 仍使用已废弃 API（`TMessage.showMessage`、`MessageTheme`、`MessageLink`、`MessageMarquee`、`closeBtn`、`icon`、`theme`、`onCloseBtnClick`、`onLinkClick` 等），无法编译，与现网 `TMessage.show` / `TMessageVariant` / `TMessageLink` / `TMessageMarquee` / `showIcon` / `showCloseButton` / `onCloseButtonPressed` / `onLinkPressed` 不一致。
4. **像素级视觉差异**：图标与文本间距 Flutter 为 10px，官方为 `@spacer`（8px）。

## 目标

- 依据官方公开 Demo，补齐 Flutter Message 的 Demo 矩阵，使小程序 / Mobile Vue / Flutter 三端 Demo 一一对应。
- 同步 `example/assets/code/` 生成示例代码。
- 修复 `tdesign-site/docs/components/message/README.md`，对齐现网公开 API。
- 对齐图标与文本间距为官方 `@spacer`（8px），并同步 marquee 文本宽度计算。
- 补充组件测试，提升 `lib/src/components/message/` 手写源码行覆盖率。

## 非目标

- 不新增 / 不删除 / 不重命名 `TMessage` 的任何公共参数或类型（现有公开 API 已足以表达全部官方 Demo）。
- 不引入 `align`、`gap`、`single`、自定义 content Widget、`marquee` 的 `speed`/`loop` 语义等新 API（如未来需要，另行按仓库规范讨论）。
- 不改变 `TMessage` 默认定位（当前距顶 80px 居中卡片 vs 官方贴顶全宽条带）——该调整属于视觉 breaking change，需维护者单独拍板后另行处理。
- 不调整阴影（elevation）与图标尺寸的像素值——当前实现方式（Material elevation / 主题 Icon）属于框架差异，像素级表现需真机截图确认，不在此次断言对齐。
- 不处理 Overlay 安全区默认值等涉及默认行为的变更。

## 范围

### 涉及

- tdesign-component/lib/src/components/message/t_message.dart（图标-文本间距对齐，仅内部视觉微调，无 API 变化）
- tdesign-component/example/lib/page/t_message_page.dart（补齐官方 Demo 矩阵）
- tdesign-component/example/assets/code/message.*.txt（示例生成代码，由 codegen 同步）
- tdesign-site/docs/components/message/README.md（对齐现网 API 与 Demo）
- tdesign-component/test/components/message/t_message_test.dart（补充测试、提升覆盖率）
- specs/007-message-contract-alignment/（本 Spec）

### 不涉及

- tdesign-component/lib/src/components/message/t_message_theme_data.dart（无变更）
- 其他组件 / 跨目录改动
- 站点 API Markdown（`example/assets/api/message_api.md` 由生成链维护，无需手工改）

## 行为契约

### Demo 矩阵（三端一一对应）

| 官方分组 | 官方 Demo | Flutter 示例 | 使用 API |
| --- | --- | --- | --- |
| 组件类型 | 纯文字的通知 | 纯文字通知 | `TMessage.show(showIcon: false)` |
| 组件类型 | 带图标的通知 | 带图标通知 | `TMessage.show(showIcon: true)`（默认） |
| 组件类型 | 带关闭的通知 | 带关闭通知 | `TMessage.show(showCloseButton: true, link: ...)` |
| 组件类型 | 可滚动的通知 | 跑马灯通知 | `TMessage.show(marquee: ...)` |
| 组件类型 | 带按钮的通知 | 带链接通知 | `TMessage.show(link: TMessageLink(...))` |
| 组件类型 | 组件调用 | 组件声明式调用 | `TMessage(visible: ...)` |
| 组件风格 | 普通 / 成功 / 警示 / 错误 | 同 4 主题 | `TMessage.show(variant: ...)` |
| 关闭所有通知 | 打开多个 / 关闭所有 | 多消息叠加 + 关闭所有 | 多个 `TMessage.show` 句柄 + `handle.dismiss()` |

- 官方存在、Flutter 缺失的 Demo 必须补齐（上表各条目）。
- Flutter 示例中不携带官方平台依据的 Demo 必须删除（当前无此情况，4 主题 + 跑马灯均对应官方 Demo）。

### 图标-文本间距

- 图标与文本之间的水平间距由 10px 调整为官方 `@spacer`（8px）。
- 同步调整 marquee 文本可用宽度计算（图标分支占位由 30 改为 28）。

### 站点文档

- `tdesign-site/docs/components/message/README.md` 的示例代码、API 表格统一对齐现网公开 API（`TMessage.show`、`TMessageVariant`、`TMessageLink`、`TMessageMarquee`、`showIcon`、`showCloseButton`、`onCloseButtonPressed`、`onLinkPressed` 等）。
- 示例文件链接、Demo 分组描述与 Flutter 示例页保持一致。

### 覆盖率

- 针对 `lib/src/components/message/` 全部手写生产源码，按 `LH / LF` 计算行覆盖率，目标 ≥95% 且不低于修改前基线。
- 新增或修改逻辑须覆盖正常、边界、错误、回调和生命周期路径；禁止用无意义断言、排除文件或 `coverage:ignore` 凑数。

## 验收标准

- [ ] 官方 Demo 矩阵全部在 Flutter 示例页落地，且三端一一对应。
- [ ] `example/assets/code/message.*.txt` 与 `t_message_page.dart` 同步（codegen `--check` 通过）。
- [ ] `tdesign-site/docs/components/message/README.md` 不再包含已废弃 API，示例可编译。
- [ ] 图标-文本间距为 8px，marquee 宽度计算同步更新。
- [ ] `lib/src/components/message/` 行覆盖率 ≥95%。
- [ ] Message 相关 Widget 测试通过。
- [ ] `flutter analyze --fatal-infos` 通过。
