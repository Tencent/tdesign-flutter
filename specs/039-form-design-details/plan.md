# 实施方案

## 技术方案

在 Form Demo 中为排布按钮和 Switch 提供语义 Token 样式；移除水平尾部对齐；性别项在两种 Form 排布下统一使用 `TRadioGroup.options` 与 `TRadioVariant.inline`；统一底部按钮顺序和配色。以 Figma `41936:17938` 的正常态初始化所有字段，重置复用同一组默认值；扩展个人简介内容区高度，保证 50 字设计文案完整显示。提交继续由 `TFormController.submit` 发起，并在现有 `TForm.onSubmit` 回调中展示成功反馈，不引入第二提交状态源。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | 无公共组件改动 | 无 |
| 测试 | Form Demo | 增加布局、主题、默认值、提交与完整重置断言；补充移动端截图入口 |
| 示例 | Form Demo | 对齐正确 Figma 节点的正常态公开展示 |
| 文档 | Spec | 记录 Demo 契约 |

## API 变化

- 无。

## 风险与取舍

- 性别项不再自行拼接手势、语义或指示器，也不保留旧 Radio 构造参数和 Theme 间距补丁；选中状态、禁用态与无障碍语义均由 `TRadioGroup` 统一负责。
- Form 只负责标签与字段的外部对齐和间距，Radio 的紧凑视觉结构由 `TRadioVariant.inline` 负责。

## 验证策略

- 单元测试：既有 Form 组件测试。
- 集成或 Widget 测试：Form Demo 默认值、提交反馈、完整重置、布局与 Golden。
- 静态检查：`flutter analyze --fatal-infos`。
- 人工验收：iPhone 模拟器与 Android 真机分别核对水平、竖向和禁用态；真机安装受设备确认阻塞时如实记录。
