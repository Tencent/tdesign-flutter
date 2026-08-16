# 实施方案

## 技术方案

### Demo 矩阵落地

重写 `tdesign-component/example/lib/page/t_message_page.dart`，按官方分组组织：

- **组件类型**：纯文字（`showIcon: false`）/ 带图标（默认图标）/ 带关闭（`showCloseButton: true` + `link`）/ 可滚动（`marquee`）/ 带按钮（`link: TMessageLink`）/ 组件声明式（`TMessage(visible: ...)`）。
- **组件风格**：info / success / warning / error 四个 `variant`。
- **关闭所有通知**：用静态 `List<TMessageHandle>` 记录多个 `TMessage.show()` 返回句柄，提供"打开多个通知"与"关闭所有通知"两个操作（复用现有 `handle.dismiss()`，不新增公开 API）。

每个 Demo 方法加 `@ExampleCode(group: 'message')`，由 codegen（`tool/generate_example_code.dart`）生成 `example/assets/code/message.*.txt`。

### 图标-文本间距

`t_message.dart` 中图标后 `SizedBox(width: 10)` 改为 8，同步 `_calculateTextWidth()` 图标分支 `width -= 30` 改为 `width -= 28`。纯内部视觉微调，无公开 API 变化。

### 站点文档

重写 `tdesign-site/docs/components/message/README.md`：示例代码全部改用现网 API（`TMessage.show`、`TMessageVariant`、`TMessageLink`、`TMessageMarquee`），API 表格对齐生成的 `message_api.md`，Demo 分组与示例页一致。

### 覆盖率

`t_message_test.dart` 补充与新增 Demo 对应的 Widget 测试（纯文字无图标、带链接、带关闭、声明式 visible 切换、多消息叠加 + 句柄关闭、间距断言等），提升 `lib/src/components/message/` 行覆盖率。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | lib/src/components/message/t_message.dart | 图标-文本间距 10→8px（内部视觉微调） |
| 测试 | test/components/message/t_message_test.dart | 补充 Demo 相关测试，提升覆盖率 |
| 示例 | example/lib/page/t_message_page.dart | 补齐官方 Demo 矩阵 |
| 示例生成 | example/assets/code/message.*.txt | 由 codegen 同步 |
| 文档 | tdesign-site/docs/components/message/README.md | 对齐现网 API 与 Demo |
| Spec | specs/007-message-contract-alignment/ | 本 Spec |

## API 变化

- 无。所有官方 Demo 均可用现有公开 API 表达，不新增 / 不删除 / 不重命名任何公共参数或类型。

## 风险与取舍

- **默认定位**（距顶 80px 居中卡片 vs 官方贴顶全宽条带）为视觉 breaking change，此 PR 不处理，需维护者另行拍板。
- **阴影 / 图标尺寸 / SafeArea** 的像素级表现需真机截图确认，无法在本环境实测，标记为"未验证/阻塞"，不声称已对齐。
- **间距微调**为 8px，经官方 `@spacer` 源码确认，风险低。

## 验证策略

- 单元 / Widget 测试：`flutter test test/components/message/`
- 静态检查：`flutter analyze --fatal-infos`
- 示例代码一致性：codegen `--check`
- 站点/组件契约：`node scripts/check-flutter-component-contracts.mjs`
- 人工验收：真机查看 Demo 视觉效果
