# API 文档生成

API 生成配置统一维护在 [`../tool/components.json`](../tool/components.json)。每项配置描述组件源码位置、API 类型和是否读取注释；它同时是站点组件契约检查的 API 来源。

从 `tdesign-component` 目录执行：

```bash
bash demo_tool/all_build.sh
node tool/generate_api.mjs --dry-run
node tool/generate_api.mjs --check
```

`all_build.sh` 仅保留为兼容入口，实际调用 `tool/generate_api.mjs`。新增或迁移组件时先更新 `tool/components.json`，再生成并提交 `example/assets/api/<component>_api.md`。

## 文档范围与注释规范

`tool/components.json` 登记组件及其公开类、枚举、typedef、扩展和顶层函数。公开范围以 `lib/tdesign_flutter.dart` 的导出为准，包括 `part`、转导出和 `show` / `hide`；`@internal` 和 `@visibleForTesting` 成员不作为使用方 API。

生成文档分别展示默认、命名和 factory 构造函数、参数及必填项、字段和访问器、静态/实例方法、控制器、辅助类型及 Theme。公开扩展也会生成属性和方法说明。主题配置说明随对应 ThemeData 一起生成，不另写参数表。没有独立 Theme 的组件在类注释及站点使用说明中写明其共用 Theme 或全局 Token。

- 使用标准 `///` dartdoc；构造函数可以有注释，也不限制成员声明顺序。
- 类注释说明用途；字段注释说明语义、生效条件、空值含义、相关字段和优先关系。
- 声明默认值由 analyzer 提取。运行时的组件 Theme / 全局 Token 回退写在注释中，不能把它当作构造默认值。
- `this.field` 参数复用字段注释；没有对应字段的参数使用参数内 `///`，或在可调用成员注释中以 `[parameterName]` 开头单独说明。
- 公开方法说明返回值、状态变化、完成时机和重复调用语义。标注 `@override` 的继承契约不需要重复拷贝框架文档；有自定义行为时应单独说明。
- 方法参数不能仅凭同名字段推断说明；自定义 `copyWith` / `lerp` / Token 查询运算符也必须有 dartdoc。声明签名保留泛型约束与位置/命名参数，参数表独立展示各可调用成员的完整契约。
- `getComments` 只控制类简介；参数与成员说明始终读取 dartdoc。
- 不编辑 `example/assets/api/*_api.md`，修复应来自源码、manifest 或独立生成工具。

核对清单和生成结果：

```bash
dart run tool/audit_api_docs.dart
dart run tool/audit_api_docs.dart --json
```

`generate_api.mjs --check` 在临时目录生成并比较资产，不改写已提交文件；正式工具版本需支持当前清单。

`--sync` 可按公开导出更新组件归属和声明清单，但仍需 Review 注释语义和生成差异。
站点通过 `{{ flutter-api <component-slug> }}` 读取同一份 API assets；示例和使用说明仍维护在站点 Markdown。

## 历史入口

`demo_tool/all_build.sh` 兼容原有调用方式；旧二进制 `api_tool_xxx`、`demo_tool/version` 和词法解析限制不再用于当前生成流程。解析或展示能力应在独立 `tdesign_flutter_tools` 仓库修复，正式版本进入声明的 ref 后再生成本仓库产物。

## 演示代码

### 生成逻辑

演示代码由普通 Dart analyzer 脚本生成。组件示例的写法要求将可显示的部分提取成独立方法，并添加 `@ExampleCode` 注解。示例：

```dart
@Override
Widget build(BuildContext context) {
  return ExamplePage(
    exampleCodeGroup: 'button',
    children: [
      ExampleModule(
        title: '默认',
        children: [
          ExampleItem(
            desc: '可点击',
            builder: _buildNormalClickButton
          )
        ]
      )
    ]
  );
}

@ExampleCode(group: 'button')
TButton _buildNormalClickButton(BuildContext context) {
  return TButton(
    content: '强按钮',
    style: TButtonStyle.primary(),
    onTap: onTap,
    onLongPress: onLongPress,
  );
}
```

其中，`group` 参数需与 `exampleCodeGroup` 参数一致，为直接的字符串赋值，不能是变量引用或者字符串拼接。

生成或校验示例代码片段：

```bash
dart run tool/generate_example_code.dart
dart run tool/generate_example_code.dart --check
```

生成的 `example/assets/code/*.txt` 需要与源码一同提交；CI 会使用 `--check` 校验它们是否同步。
