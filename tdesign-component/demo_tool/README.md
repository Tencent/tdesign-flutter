# api_tool：基于smart_cli实现的组件库生成工具

## 组件注释规范

**注意：** 生成工具有待完善，目前先按工具代码规范编写代码，如有不满足的场景，再修改工具。

编写规范需注意：

- 构造方法为类名下的第一行代码，且不能有注释。成员字段需写在构造方法后面。
- 成员变量的注释需要用 `///`，不能用 `//`。
- 构造方法不能标注 `@override`。

### 组件widget注释示例

```dart
/// 组件简介（必须）
```

### 组件属性注释示例

```dart
/// 属性简介（必须）
```

## 组件库工具使用方法

### 初始化工具调用命令

```bash
./bin/api_tool_xxx generate \
    --file                相对ui_component目录的组件文件路径 \
    --folder              相对ui_component目录的组件文件夹路径 \
    --name                组件名，多个组件名之间用英文,分割 \
    --folder-name         [可选]生成的组件示例文件夹名称，默认生成的文件夹名称是第一个name参数的下划线表示 \
    --[no-]only-api       是否只更新api文件 \
    --[no-]use-grammar    是否采用语法分析器，默认采用词法分析
```

### 初始化命令

**前置条件：** 在 `demo_tool/version` 中填入对应 Dart SDK 的版本号。

初始化命令有以下 3 种使用方式：

1. **初始化一个组件文件中的一个组件示例**  
   如果没有指定 `--folder-name`，默认文件夹名称是第一个 `name` 参数的下划线表示。示例：

   ```bash
   ./demo_tool/bin/api_tool_xxx generate --file lib/src/components/tags/td_tag.dart --name TDTag --folder-name tag --only-api
   ```

2. **把一个文件中的多个组件合并生成一份示例数据**  
   API 说明生成在一个文件中。如果没有指定 `--folder-name`，默认文件夹名称是第一个 `name` 参数的下划线表示。

   ```bash
   ./demo_tool/bin/api_tool_xxx generate --file lib/checkbox/custom_check_box.dart --name SquareCheckbox,TECheckBox --folder-name checkbox2
   ```

3. **把一个文件夹中的多个组件合并生成一份示例数据**  
   API 说明生成在一个文件中。如果没有指定 `--folder-name`，默认文件夹名称是第一个 `name` 参数的下划线表示。

   ```bash
   ./demo_tool/bin/api_tool_xxx generate --folder lib/setting --name SettingItemWidget,SettingTowRowCellWidget,SettingLeftTextCellWidget,SettingCheckBoxCellWidget,SettingTowTextCellWidget,SettingTowLineTextCellWidget,SettingGroupWidget,SettingGroupTextWidget --folder-name setting
   ```

如果想只更新 API 文档，那么在上述初始化的命令之后增加参数 `--only-api` 即可。

默认采用词法分析，如果想采用语法分析的方式生成代码，那么在上述初始化的命令之后增加参数 `--use-grammar` 即可。

## 演示代码

### 生成逻辑

演示代码依赖 Flutter AOP 能力，通过解析 `@Demo` 注解所在的方法自动生成。因此，组件示例的写法要求将可显示的部分提取成独立方法，并添加 `@Demo` 注解。示例：

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

@Demo(group: 'button')
TDButton _buildNormalClickButton(BuildContext context) {
  return TDButton(
    content: '强按钮',
    style: TDButtonStyle.primary(),
    onTap: onTap,
    onLongPress: onLongPress,
  );
}
```

其中，`group` 参数需与 `exampleCodeGroup` 参数一致，为直接的字符串赋值，不能是变量引用或者字符串拼接。

## Flutter AOP

提交 PR 后，将会触发流水线自动打包 APK，流水线配置了 AOP 能力。
