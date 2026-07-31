# CONTRIBUTING

## 目录结构

```text
tdesign-component/
├── demo_tool       // API 和演示代码
├── examples        // 组件使用示例
├── lib             // 组件库
└── tests           // 组件测试

tdesign-site/       // tdesign flutter 站点
```

## 开发规范

- 组件命名规范：以 `TD` 为前缀，组件名称、API名称参考 TDesign 现有组件和API命名，可以根据 flutter 原生 Widget 的特点进行修改。组件 API 以满足设计要求和使用为准，可根据 flutter 特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯 Dart 代码规范。
- 对于系统原有组件，如 `Text`、`Image` 等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃 TDesign 控件。
- 示例页面尽量使用 ExamplePage + ExampleModule + ExampleItem 组合，按照示例稿的布局实现；页面写完后，在 main.dart 中修改 exampleMap 对应组件的 isTodo 属性即可。
- 组件 API 和演示代码，请参考 [demo_tool/README.md](./tdesign-component/demo_tool/README.md) 文件。
- 组件内部的固定文案，都应该抽离到 TResourceDelegate 中统一管理，方便业务进行国际化适配。
- 如果使用的组件 TD 有封装，尽量使用 TD 已有组件，而非直接使用系统组件。

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
