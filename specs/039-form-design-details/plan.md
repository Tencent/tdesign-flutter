# 实施方案

## 技术方案

Form Demo 继续使用语义 Token、`TRadioGroup.options` 与 `TRadioVariant.inline` 表达 Figma `41936:17938` 的默认、水平、竖向和禁用状态；重置复用同一组默认值，提交由 `TFormController.submit` 发起并只通过 `TForm.onSubmit` 反馈成功。

组件层使用私有的受控 `FormField` 桥接状态：用户交互先更新控制器快照和 Flutter `FormFieldState`，再执行字段回调，使 `TForm.onChanged` 和字段 `onChanged` 都能读到本次值；父组件传入的新值使用 `FormFieldState.setValue` 同步，不调用 `didChange`，因此不会伪造用户交互和自动校验。清除校验复用原 `FormFieldState` 并恢复当前受控值，不更换 Key、不卸载字段子树。Controller 在 debug 模式拒绝同时绑定多个存活 Form。Theme 尺寸字段以组件真实默认值参与插值，依赖运行时 Token 的 nullable 视觉字段离散切换；必填标记样式在语义错误色上合并。标签的 `left/right` 保持物理方向，`start/end` 保持文字方向语义。

公开 Demo 拆成可独立生成的 `FormBasicDemo` 类，页面壳只负责 `ExamplePage` 注册；代码面板由类级 `@ExampleCode` 生成完整源码，测试真实打开面板并校验展示内容。禁用状态以 `TFormField.onChanged == null` 为字段统一状态源；日期和籍贯 Picker 从已确认值恢复，取消不改变表单值。视觉回归覆盖默认、竖向和禁用三种状态的 light/dark 完整页面。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `TForm`、`TFormField`、`TFormItem`、`TFormThemeData` | 修正受控同步、Controller 绑定保护、RTL 标签对齐和主题插值；不新增公开 API |
| 测试 | Form 组件、Form Demo | 覆盖状态时序、受控回退、主题、RTL、完整代码入口和六张 Golden |
| 示例 | Form Demo | 对齐正确 Figma 节点，并提供完整可复制示例 |
| 文档 | Spec | 记录组件与 Demo 行为契约及验证结果 |

## API 变化

- 无。

## 风险与取舍

- 性别项不再自行拼接手势、语义或指示器，也不保留旧 Radio 构造参数和 Theme 间距补丁；选中状态、禁用态与无障碍语义均由 `TRadioGroup` 统一负责。
- Form 只负责标签与字段的外部对齐和间距，Radio 的紧凑视觉结构由 `TRadioVariant.inline` 负责。
- `TFormField.value` 仍是最终状态源；交互回调提出的新值会短暂进入表单快照，若父级拒绝该值，帧末同步恢复为受控值。
- 颜色等运行时 Token 无法在 `ThemeExtension.lerp` 中取得有效默认色，因此 null 与显式值之间离散切换，避免产生并不存在的透明中间态。

## 验证策略

- 单元测试：Form 状态时序、外部同步、拒绝值回退、Controller、Theme、必填标记和 RTL 标签对齐。
- 集成或 Widget 测试：Form Demo 默认值、提交反馈、完整重置、布局、代码入口与 Golden。
- 静态检查：Flutter 3.32.0 与 latest 分别运行 `flutter analyze --fatal-infos`。
- 覆盖率：集中式 Form 生产源码覆盖率门禁。
- Golden：仅在 Flutter 3.32.0 Linux 生成，随后无更新参数严格复跑。
- 人工验收：iPhone 模拟器与 Android 真机分别核对水平、竖向和禁用态；真机安装受设备确认阻塞时如实记录。
