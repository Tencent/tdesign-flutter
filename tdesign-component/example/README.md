# TDesign Flutter Example

组件示例 App，同时承载组件代码查看和 Web 文档示例代码。

## 示例代码片段

为需要展示源码的方法添加 `@ExampleCode(group: '...')`。`group` 必须与所在页面的 `ExamplePage.exampleCodeGroup` 一致，生成器会输出 `assets/code/<group>.<method>.txt`。

```dart
@ExampleCode(group: 'button')
Widget _buildPrimaryButton(BuildContext context) {
  return const TButton(child: TText('按钮'));
}
```

从 `tdesign-component` 目录运行：

```bash
dart run tool/generate_example_code.dart
dart run tool/generate_example_code.dart --check
```

提交示例改动时，必须一并提交生成的 `assets/code/*.txt`。`--check` 不写文件，CI 使用它检查源码片段是否过期。
