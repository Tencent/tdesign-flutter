# 验收记录

## 设计证据

- 通用 Popup 节点 `25164:19170`：375×240。
- Picker 弹层节点 `28591:38640`：375×258。
- Picker Wrapper 节点 `28591:38642`：Y=58、H=184；头部后内容区共 200px，包含底部 16px 空间。

## 自动验证

- Flutter 3.32.0：Picker 清单全部 6 个组件测试文件通过；生产源码覆盖率 `401/412 = 97.33%`。
- Flutter 3.32.0：Picker、DateTimePicker、Form 三个 Demo 非视觉测试共 21 项通过。
- Flutter 3.47.0：Picker 弹层、主题和共享消费方聚焦测试共 39 项通过。
- Flutter 3.32.0 与 3.47.0：`flutter analyze --fatal-infos` 均为 `No issues found`。
- Flutter 3.32.0 Linux amd64：Picker + DateTimePicker 打开态 Golden 无更新复跑，34 项通过；Form Demo 明暗 Golden 与两个 Picker 弹层交互共 4 项通过。
- `dart run tool/generate_example_code.dart --check` 通过；Picker API 文档已通过 manifest 生成。
- 组件与三个 Demo 实现 diff 指纹：`7b2db205865d35a551e3286f5b82a60b9244f9a05eccab118d2c4a2a189857ec`。

## 环境说明

Golden 仅采用与 CI 一致的 `tdesign-flutter-golden-cache:3.32.0` Linux amd64 结果作为权威证据。macOS 直接比对因平台字体栅格化与 Linux 基线不同产生 3.31%–5.23% 差异，未更新或提交该平台产物。
