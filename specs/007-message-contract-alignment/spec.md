# Message 组件跨端 Demo 契约对齐

## 背景

TDesign Flutter 的 `TMessage` 组件（`tdesign-component/lib/src/components/message/`）在与 TDesign 小程序 / Mobile Vue 官方实现对齐时，存在以下差距（依据 `tdesign-miniprogram`、`tdesign-mobile-vue` 官方发布版源码逐项对照）：

1. **公开 Demo 覆盖不全**：Flutter 示例页 `t_message_page.dart` 仅覆盖"组件状态（4 主题）+ 跑马灯"，而官方存在以下公开 Demo 缺失：
   - 纯文字通知（无图标）、带关闭通知、带按钮（链接）通知 —— 对应小程序 `message/_example/base`、mobile-vue `message/demos/base.vue`；
   - 组件声明式调用（`visible` 受控）—— 对应小程序 `base/index.wxml` 的 `<t-message visible=...>`；
   - Mobile Vue 另有“关闭所有通知”扩展示例，但小程序公开 Demo 页不展示该分组，不应作为 Flutter 对齐基线。
2. **示例生成代码不同步**：`example/assets/code/` 仅含 `message._marquee.txt`，未与完整 Demo 同步。
3. **站点文档严重过期**：`tdesign-site/docs/components/message/README.md` 仍使用已废弃 API（`TMessage.showMessage`、`MessageTheme`、`MessageLink`、`MessageMarquee`、`closeBtn`、`icon`、`theme`、`onCloseBtnClick`、`onLinkClick` 等），无法编译，与现网公开 API 不一致。
4. **像素级视觉差异**：图标与文本间距 Flutter 为 10px，官方为 `@spacer`（8px）。
5. **默认展示契约未对齐**：Flutter 声明式组件默认可见、默认使用距顶 80px 的 343px 卡片、20px 图标和 Material elevation 6；小程序默认 `visible=false`，触发后在页面导航栏下方展示全宽 48px 条带，图标为 22px，并使用基础阴影。
6. **默认并发行为未收敛**：Flutter 连续调用 `show()` 会在同一位置叠加；小程序默认只保留当前一条通知。
7. **操作 API 存在非法组合**：`TMessageLink` 仅保存文案、未消费的 `uri` 与颜色，点击行为却由外层 `onLinkPressed` 提供；只传 `link` 会渲染禁用态操作，形成两个公开状态源。
8. **永久展示存在同义值**：`null` 与 `Duration.zero` 同时表示不自动关闭，无法区分永久展示与零时长，也机械暴露了跨端哨兵值差异。

## 目标

- 以小程序公开 Demo 为可见基线，收敛 Flutter Message 的两个公开分组与十个触发实例。
- 同步 `example/assets/code/` 生成示例代码。
- 修复 `tdesign-site/docs/components/message/README.md`，对齐现网公开 API。
- 对齐图标与文本间距为官方 `@spacer`（8px），并同步 marquee 文本宽度计算。
- 对齐声明式默认隐藏、3 秒自动关闭、导航栏下方全宽条带、22px 图标、body-medium 字体与基础阴影。
- 默认位置连续调用 `show()` 时替换上一条；显式传入不同 `offset` 时继续支持多消息布局，不新增 `single` 等同义公开状态。
- 使用 Flutter 原生组合的 `Widget? action` 承载消息操作，移除 `TMessageLink` 与 `onLinkPressed` 的拆分状态。
- `duration` 仅以 `null` 表示不自动关闭；非 null 时必须为正数。
- 补充组件测试，提升 `lib/src/components/message/` 手写源码行覆盖率。

## 非目标

- 不引入 `align`、`gap`、`single`、自定义 content Widget、`marquee` 的 `speed`/`loop` 语义等新 API。
- 不在小程序公开基线中展示 Mobile Vue / Flutter 扩展的“关闭所有通知”模块；底层 dismiss 能力不删除。
- 不重命名 `TMessageVariant`。
- 不将 `visible`、默认单例策略、尺寸或位置复制到 `TMessageThemeData`；Theme 只承载现有样式覆盖，避免形成第二公开状态源。

## 范围

### 涉及

- tdesign-component/lib/src/components/message/t_message.dart（默认展示契约、生命周期、并发策略与视觉 token 对齐）
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

### Demo 矩阵（小程序公开页基线）

| 官方分组 | 官方 Demo | Flutter 示例 | 使用 API |
| --- | --- | --- | --- |
| 组件类型 | 纯文字的通知 | 纯文字通知 | `TMessage.show(showIcon: false)` |
| 组件类型 | 带图标的通知 | 带图标通知 | `TMessage.show(showIcon: true)`（默认） |
| 组件类型 | 带关闭的通知 | 带关闭通知 | `TMessage.show(showCloseButton: true, action: TLink(...))` |
| 组件类型 | 可滚动的通知 | 跑马灯通知 | `TMessage.show(marquee: ...)` |
| 组件类型 | 带按钮的通知 | 带操作通知 | `TMessage.show(action: TLink(...))` |
| 组件类型 | 组件调用 | 组件声明式调用 | `TMessage(visible: ...)` |
| 组件风格 | 普通 / 成功 / 警示 / 错误 | 同 4 主题 | `TMessage.show(variant: ...)` |

- 官方存在、Flutter 缺失的 Demo 必须补齐（上表各条目）。
- Flutter 公开页不携带小程序公开基线的扩展 Demo，如“关闭所有通知”，不继续对外展示。
- 调试模块默认不出现在公开页。

### 图标-文本间距

- 图标与文本之间的水平间距由 10px 调整为官方 `@spacer`（8px）。
- 图标尺寸由 20×22 调整为 22×22，同步调整 marquee 文本可用宽度计算。

### 默认展示与生命周期

- 声明式 `TMessage.visible` 默认值由 `true` 调整为 `false`；`TMessage.show()` 内部显式创建可见实例。
- `duration` 默认保持 3 秒；仅 `null` 表示不自动关闭，非 null 时必须为正数。
- 默认消息宽度占满安全可视区域，纵向位置为系统安全区与 Flutter 页面导航栏之后；显式 `offset` 仍按既有规则受安全区约束。
- 默认文本使用 TDesign `body-medium`，默认阴影内部引用 `shadowsBase` token；已有 `TMessageThemeData.elevation` 显式配置仍优先，不新增同义 Theme 字段。
- 连续调用 `TMessage.show()` 且未传 `offset` 时，新消息替换上一条。显式传入不同 `offset` 的多消息能力保留。

### 站点文档

- `tdesign-site/docs/components/message/README.md` 的示例代码、API 表格统一对齐现网公开 API（`TMessage.show`、`TMessageVariant`、`TMessageMarquee`、`action`、`showIcon`、`showCloseButton`、`onCloseButtonPressed` 等）。
- 示例文件链接、Demo 分组描述与 Flutter 示例页保持一致。

### Breaking change 分析

- `visible` 默认值从 `true` 改为 `false`：依赖 `const TMessage(...)` 默认立即展示的调用方需显式传入 `visible: true`。
- `link: TMessageLink(...)` 与 `onLinkPressed` 替换为 `action: Widget`；操作组件自行持有外观和点击行为。
- `Duration.zero` 不再表示永久展示；永久展示必须迁移为 `duration: null`。
- 默认几何、阴影、字号和图标尺寸变化会更新可见快照。
- 未传 `offset` 的连续 `show()` 从重叠改为替换；依赖并排展示的调用方需继续使用已有的显式 `offset`。
- 未新增与实例状态同义的 Theme / `single` 字段。

### 覆盖率

- 针对 `lib/src/components/message/` 全部手写生产源码，按 `LH / LF` 计算行覆盖率，目标 ≥95% 且不低于修改前基线。
- 新增或修改逻辑须覆盖正常、边界、错误、回调和生命周期路径；禁止用无意义断言、排除文件或 `coverage:ignore` 凑数。

## 验收标准

- [ ] 小程序公开 Demo 的两个分组、十个实例、顺序与文案在 Flutter 示例页落地。
- [ ] 公开页不展示“关闭所有通知”扩展模块，且不因 Demo 对齐新增公开 API。
- [ ] 明暗主题整页 Golden 在 Flutter 3.32.0 Linux 可复现，且与小程序实际页截图完成人工比对。
- [ ] `example/assets/code/message.*.txt` 与 `t_message_page.dart` 同步（codegen `--check` 通过）。
- [ ] `tdesign-site/docs/components/message/README.md` 不再包含已废弃 API，示例可编译。
- [ ] 图标-文本间距为 8px，marquee 宽度计算同步更新。
- [ ] 声明式默认隐藏；命令式触发后默认显示，并在 3 秒后完成关闭与 Overlay 销毁。
- [ ] 默认消息在导航栏下方全宽展示，图标 22px、body-medium 与基础阴影均有 Widget / Golden 证据。
- [ ] 默认位置连续触发只保留当前消息；显式 offset 多消息仍可用，且未新增同义公开状态。
- [ ] `lib/src/components/message/` 行覆盖率 ≥95%。
- [ ] Message 相关 Widget 测试通过。
- [ ] `flutter analyze --fatal-infos` 通过。
