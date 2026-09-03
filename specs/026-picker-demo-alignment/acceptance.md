# Picker 验收记录（2026-09-04）

## 分支与范围

- 原 PR #1062，分支 `rss1102/style/picker-demo-alignment`，在原 head `e06b247d` 上追加本组件改动，未合入其他组件 PR。
- 本组件保持平铺、受控面板；Popup、标题、临时值、取消/确认由调用方组合。
- Figma 分支 `4SdclZkcv5bPgX6pa8AsmI` 为视觉依据；已提交截图见 `evidence/figma-*.png`。小程序源码参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`，API/default 对照见 `spec.md`。
- 本 PR 不新增公开 API。

## 验证证据

- 合并最新 `develop` 后，Flutter 3.32.0 严格 `flutter analyze --fatal-infos --fatal-warnings` 无问题；Picker 与 DateTimePicker 共用滚轮合计 31 项组件测试、另 3 项调度器自测通过。DateTimePicker wheel 回归已登记到 Picker 套件，确保第二消费方同步使用 w600 与渐隐布局。
- 各 PR 独立工作区使用已有 Flutter 3.32.0 Linux 镜像和离线 pub 缓存生成权威 Golden，随后无更新参数复跑通过；本组件 5 项 Demo 测试和 12 项 Golden 通过。
- Golden 使用默认精确比较器；Figma 为人工视觉对照，不是 Figma 自动像素比较。拆分后的代表性打开态已复核。
- 拆分前相同组件实现还通过 Flutter 3.47.0 analyze/功能验证；生产源码覆盖率为 `333/340 = 97.94%`。此项是此前集成验证的记录，不冒充拆分后重新测量。
- 合并最新 `develop` 后，另以 Flutter 3.44.0 严格 analyze、31 项 Picker/DateTimePicker 共用滚轮测试及 3 项调度器自测和 5 项 Demo 测试复跑通过。
- 原 PR 已登记本组件的组件/Demo/覆盖率/视觉入口；共享消费测试随 Picker 套件执行。远端 CI 与独立 CNB Review 以各自 PR/Issue 记录为准。

## 复现与限制

```sh
# tdesign-component
flutter analyze --no-pub --fatal-infos
flutter test --no-pub --exclude-tags golden test/components/picker
flutter test --no-pub test/components/date_time_picker/t_date_time_picker_wheel_test.dart
# example；Golden 使用 Flutter 3.32.0 Linux
flutter test --no-pub test/picker_demo_test.dart test/picker_demo_golden_test.dart
```

未进行 Android/iOS 真机触控与系统字体验收。未安装新软件；Flutter 3.44.0 首次解析仅刷新共享 pub 缓存，随后各分支禁网验证。三个原 PR 分别推送、分别 Review。

## 本轮复审修复

- Flutter 3.47.0（本机已有 SDK，离线依赖）严格 analyze、相同组件及调度器测试、5 项 Demo 功能测试通过；本轮未在该版本执行或更新 Golden。

- 新增 4 项共享消费测试，经真实 TPicker/TDateTimePicker 验证默认及自定义 token 下的外壳底色、渐隐颜色/方向/高度、高亮色和 IgnorePointer；在本 PR 组件套件登记。
- 外壳不透出父面板底色的契约已写入内部 dartdoc 与 Spec；不新增公开 API，不改变本轮运行行为。
- Flutter 3.32.0 Linux：严格 analyze 零问题，35 项组件测试、3 项调度器自测、5 项 Demo、12 项 Golden 通过，未更新基线。
- 当前分支生产源码覆盖率重新测得 **333/340 = 97.94%**，通过 95% 门禁。此前 34 项记录包含 31 项组件与 3 项调度器测试，已修正口径。

## API 收敛修复验证（2026-09-04）

本轮 API 收敛验证：Flutter 3.32.0 Linux 与本机 Flutter 3.47.0 严格 analyze 零告警，39 项组件测试、11 项调度/覆盖率工具自测、5 项 Demo 功能测试通过；3.32 Linux 12 项 Golden 无更新参数通过，基线未改。生产代码覆盖率 336/342 = 98.25%。

- 按 componentTestSuites 当前登记逐文件运行 flutter test --no-pub --coverage，再执行 dart run tool/check_component_coverage.dart picker。工具自测单独统计，不混入组件数。
- 运行真实 Demo 功能测试和 run_visual_regression.dart 登记的 Golden；没有更新图片。Android/iOS 真机尚未验证。
- 修复前真实消费测试在自定义 fontBodyLarge=19/27 时读到 Material 默认字号而失败，修复后两消费组件的 token 与显式子树 TextTheme 均通过。共享源码及测试在两个 PR 中相同。
