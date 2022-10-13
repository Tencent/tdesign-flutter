# demo_tool
# 基于smart_cli实现的组件库生成工具

## 组件注释规范
### 注：生成工具有待完善，目前先按工具代码规范编写代码，如有不满足的场景，再修改工具
编写规范需注意：
- 构造方法为类名下的第一行代码，且不能有注释。成员字段需写在构造方法后面

#### 组件widget注释示例：
```
/// 组件简介（必须）
```
#### 组件属性注释示例：
```
/// 属性简介（必须）
```
#### 组件demo注释示例：
```
/// demo名称（可以为空，为空的时候默认显示组件名称）
/// demo示例介绍（可以为空）
```

## 组件库工具使用方法
### 初始化工具调用命令
```
dart tools/smart_cli/bin/main.dart generate
    --file                相对ui_component目录的组件文件路径
    --folder              相对ui_component目录的组件文件夹路径
    --name                组件名，多个组件名之间用英文,分割
    --folder-name         [可选]生成的组件示例文件夹名称,默认生成的文件夹名称是第一个name参数的下划线表示
    --[no-]only-api       是否只更新api文件
    --[no-]use-grammar    是否采用语法分析器,默认采用词法分析
```
---
### 一、 初始化命令

【前置】：在demo_tool/version中填入对应dart_sdk的版本号

初始化命令有以下 3 种使用方式：

1、初始化一个组件文件中的一个组件示例，没有--folder-name的时候，默认文件夹名称是第一个name的下划线表示，示例：

```
./demo_tool/bin/demo_tool generate --file lib/src/components/tags/td_tag.dart --name TDTag --folder-name tag --only-api
```

2、 把一个文件中的多个组件合并生成一份示例数据（api说明生成在一个文件中），没有--folder-name的时候，默认文件夹名称是第一个name的下划线表示
```
./demo_tool/bin/demo_tool generate --file lib/checkbox/custom_check_box.dart --name SquareCheckbox,TECheckBox --folder-name checkbox2
```
3、 把一个文件夹中的多个组件合并生成一份示例数据（api说明生成在一个文件中），没有--folder-name的时候，默认文件夹名称是第一个name的下划线表示
```
./demo_tool/bin/demo_tool generate --folder lib/setting --name SettingItemWidget,SettingTowRowCellWidget,SettingLeftTextCellWidget,SettingCheckBoxCellWidget,SettingTowTextCellWidget,SettingTowLineTextCellWidget,SettingGroupWidget,SettingGroupTextWidget --folder-name setting
```

如果想只更新API文档，那么在上述初始化的命令之后增加参数 `--only-api` 即可

默认采用词法分析，如果想采用语法分析的方式生成代码，那么在上述初始化的命令之后增加参数 `--use-grammar` 即可
`