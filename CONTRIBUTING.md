# CONTRIBUTING

## 目录结构

```text
tdesign-component/
├── demo_tool       // API 和演示代码
├── example         // 组件使用示例
├── lib             // 组件库
└── test            // 组件测试

tdesign-site/       // tdesign flutter 站点
```

## 开发规范

- 组件命名规范：以 `T` 为前缀，组件名称、API 名称参考 TDesign 现有组件和 API 命名，可以根据 Flutter 原生 Widget 的特点进行修改。组件 API 以满足设计要求和使用为准，可根据 Flutter 特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯 Dart 代码规范。
- 对于系统原有组件，如 `Text`、`Image` 等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃 TDesign 控件。
- 示例页面尽量使用 ExamplePage + ExampleModule + ExampleItem 组合，按照示例稿的布局实现。
- 组件 API 和演示代码，请参考 [demo_tool/README.md](./tdesign-component/demo_tool/README.md) 文件。
- 组件内部的固定文案，都应该抽离到 TResourceDelegate 中统一管理，方便业务进行国际化适配。
- 如果已有 TDesign 组件封装，尽量使用现有 T 组件，而非直接使用系统组件。

## 示例代码片段

示例 App 的代码查看和 Web Markdown 都读取 `tdesign-component/example/assets/code/` 中的源码片段。将示例方法标记为 `@ExampleCode`，其中 `group` 必须与页面的 `exampleCodeGroup` 完全一致：

```dart
@ExampleCode(group: 'button')
Widget _buildPrimaryButton(BuildContext context) {
  return const TButton(child: TText('按钮'));
}
```

在 `tdesign-component` 目录执行以下命令生成片段，并将变更后的 `.txt` 文件与示例源码一起提交：

```bash
dart run tool/generate_example_code.dart
dart run tool/generate_example_code.dart --check
```

第二条命令不会写文件，用于本地和 CI 校验片段是否与源码同步。

## 贡献指南

请参考：[贡献指南](https://tdesign.tencent.com/flutter/develop)

复杂需求、公共 API 变更、组件重构和跨目录改动请先阅读并创建对应的 [Spec](./specs/README.md)；是否可以不创建 Spec，由 Review 根据实际改动判断。

## Spec 贡献流程

1. 从 `specs/_template/` 复制模板，创建 `specs/<编号>-<短名称>/` 目录；编号按顺序递增，短名称使用小写 kebab-case。
2. 在 `spec.md` 中说明背景、目标、范围、非目标、行为契约和验收标准。
3. 在 `plan.md` 中记录技术方案、影响文件、API 变化、风险和验证策略。
4. 在 `tasks.md` 中拆分实现、测试、示例和文档任务，并持续更新任务状态。
5. 完成代码和测试后，在 `acceptance.md` 中记录实际命令、测试结果、人工验收项和未覆盖风险。
6. 提交 PR 时，在正文中附上 Spec 目录链接；实现发生变化时，必须同步更新 Spec。

简单文案、格式调整和单文件局部修改不要求创建完整 Spec。Spec 只描述设计和验收，不替代代码、测试或生成文档。
