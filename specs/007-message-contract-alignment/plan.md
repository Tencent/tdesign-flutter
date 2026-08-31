# 实施方案

## 技术方案

### Demo 矩阵落地

重写 `tdesign-component/example/lib/page/t_message_page.dart`，按官方分组组织：

- **组件类型**：纯文字（`showIcon: false`）/ 带图标（默认图标）/ 带关闭（`showCloseButton: true` + `action`）/ 可滚动（`marquee`）/ 带按钮（`action: TLink`）/ 组件声明式（`TMessage(visible: ...)`）。
- **组件风格**：info / success / warning / error 四个 `variant`。
- 公开页仅保留上述两个小程序分组；Mobile Vue / Flutter 扩展的“关闭所有通知”不继续对外展示，底层 `handle.dismiss()` 能力不删除。

两个公开示例容器加 `@ExampleCode(group: 'message')`，由 codegen（`tool/generate_example_code.dart`）生成 `example/assets/code/message.*.txt`。

### 图标-文本间距

`t_message.dart` 中图标后间距对齐 8px，图标约束对齐 22×22，并同步 `_calculateTextWidth()` 的占位计算。

### 默认展示契约

- 声明式 `visible` 默认改为 `false`，`TMessage.show()` 显式传入 `visible: true`；只有可见阶段才启动 duration / marquee 计时器。
- 默认宽度使用安全可视区域全宽，默认纵向位置由 `MediaQuery.padding.top + kToolbarHeight` 推导，避免继续硬编码 80px。
- 默认文本使用 Theme 中的 `bodyMedium`；默认阴影内部引用 `shadowsBase` token。已有 `TMessageThemeData.elevation` 仍是显式覆盖，不在 ThemeExtension 增加同义状态。
- Overlay 维度以现有 `offset` 作为所有权边界：未传 `offset` 的默认槽位只保留当前消息；显式 offset 继续允许多消息，不新增 `single` API。
- 操作区域使用 `Widget? action` 组合槽，由传入组件完整持有外观与交互；删除 `TMessageLink`、未消费的 `uri` 及外层 `onLinkPressed`。
- `duration` 仅允许正数或 null；null 是唯一的不自动关闭表达，`Duration.zero` 不再作为同义永久态。

### 站点文档

重写 `tdesign-site/docs/components/message/README.md`：示例代码全部改用现网 API（`TMessage.show`、`TMessageVariant`、`TMessageMarquee`、`action`），API 表格对齐生成的 `message_api.md`，Demo 分组与示例页一致。

### 覆盖率

`t_message_test.dart` 补充与新增 Demo 对应的 Widget 测试（纯文字无图标、带链接、带关闭、声明式 visible 切换、多消息叠加 + 句柄关闭、间距断言等），提升 `lib/src/components/message/` 行覆盖率。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | lib/src/components/message/t_message.dart | 默认可见性、位置、宽度、阴影、字体、图标尺寸、计时与默认替换策略 |
| 测试 | test/components/message/t_message_test.dart | 补充 Demo 相关测试，提升覆盖率 |
| 示例 | example/lib/page/t_message_page.dart | 补齐官方 Demo 矩阵 |
| 示例生成 | example/assets/code/message.*.txt | 由 codegen 同步 |
| 文档 | tdesign-site/docs/components/message/README.md | 对齐现网 API 与 Demo |
| Spec | specs/007-message-contract-alignment/ | 本 Spec |

## API 变化

- `visible` 默认值从 `true` 改为 `false`。
- 删除 `TMessageLink`、`link` 与 `onLinkPressed`，新增 `Widget? action`；调用方使用 Flutter Widget 组合操作外观和行为。
- `Duration.zero` 不再表示永久展示，迁移为 `duration: null`。
- 不新增 `single` 或 Theme 同义状态。默认槽位替换由 `TMessage.show()` 内部管理；显式 offset 保留原多消息能力。

## 风险与取舍

- **默认行为变化**会影响未显式传 `visible` 的声明式调用以及默认位置连续触发；通过 dartdoc、示例和回归测试明确迁移方式。
- **跨平台坐标系不同**：小程序 `top: 0` 是页面 WebView 原点，Flutter Overlay 需结合安全区和导航栏推导等效位置，不能机械复制 0。
- **真机证据**仍需设备重连后补验；Web 触发和 Linux Golden 负责可复现回归，不替代真机 DPR 验收。

## 验证策略

- 单元 / Widget 测试：`flutter test test/components/message/`
- 静态检查：`flutter analyze --fatal-infos`
- 示例代码一致性：codegen `--check`
- 站点/组件契约：`node scripts/check-flutter-component-contracts.mjs`
- 人工验收：先点击触发默认、关闭按钮与声明式实例，再比较微信开发者工具实际页、Flutter Web 触发态和 Flutter 3.32.0 Linux 明暗 Golden；真机 DPR 单独记录。
