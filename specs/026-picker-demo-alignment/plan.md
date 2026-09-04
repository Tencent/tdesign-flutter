# 实施计划

1. 基于原 PR #1062 的分支追加 Picker 改动，保持单组件评审范围。
2. 以 Figma 页面与打开态对齐 Demo；参考小程序 API/default，保持 Flutter 平铺受控与用户组合 Popup 的边界。
3. 同步本组件的源码、Demo、dartdoc、Spec、行为测试、代码片段和 Golden。
4. 在各自分支验证 analyze、组件和 Demo 行为；使用 Flutter 3.32.0 Linux 生成并无更新参数复跑权威 Golden。
5. 推送原 PR，并单独在 CNB 使用组件 Review skill 审查。

## API 收敛实现

复用 tExplicitTextTheme 过滤 Flutter 自动默认字体，以 fontBodyLarge 提供默认字号/行高；保留显式子树 TextTheme 覆盖。共享源码和消费测试与 DateTimePicker PR 一致。

## 示例展示修复

通过已有 ExampleItem.methodName 将四个代码入口绑定到真实 `_cell` 组合。标签解析与弹层方法在该函数内部定义，使生成器不需要递归扫描或新增注解配置。数据与父级确认回调显式传入，调用处保留原 State.context，避免抽取代码改变主题继承。使用核心片段形式，注释声明数据、初始值、状态接入和完整文件入口。

现有 Demo 测试新增真实代码面板覆盖，沿用双版本 CI 登记；新增设备集成测试及截图 driver 作为可重复的 Android 验收入口，integration_test 仅为 SDK 开发依赖。截图输出到 example/build/picker-device-evidence，不作为 Golden 基线。
