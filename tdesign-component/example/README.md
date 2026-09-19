# TDesign Flutter Example

组件示例 App，同时承载组件代码查看和 Web 文档示例代码。

## 示例代码片段

为需要展示源码的方法或独立 Widget 添加 `@ExampleCode(group: '...')`。`group` 必须与所在页面的 `ExamplePage.exampleCodeGroup` 一致，生成器会输出 `assets/code/<group>.<name>.txt`。

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

有状态或依赖数据的示例优先使用类级注解。生成器会携带当前文件的 imports 和对应 `State<Widget>`；示例所需的数据与 helper 应放在该 Widget/State 内，不能依赖页面壳的私有声明。Web 组件文档通过 `{{ flutter-example-group <group> }}` 展开该组件全部生成资产，单片段映射只作为调试能力保留。
