# DateTimePicker 验收记录（2026-09-04）

## 分支与范围

- 原 PR #1061，分支 `rss1102/style/date-time-picker-demo-alignment`，在原 head `4be2e8e1` 上追加本组件改动，未合入其他组件 PR。
- 本组件保持平铺、受控面板；Popup、标题、临时值、取消/确认由调用方组合。
- Figma 分支 `4SdclZkcv5bPgX6pa8AsmI` 为视觉依据；已提交截图见 `evidence/figma-*.png`。小程序源码参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`，API/default 对照见 `spec.md`。
- DateTimePicker 复用 Picker 内部滚轮；本 PR 包含保证自身 UI 的两处共用渲染修复，与 Picker PR 保持相同实现。新增 DateMode.monthDay 对穷尽 switch 调用方存在源码兼容风险。

## 验证证据

- 合并最新 `develop` 后，Flutter 3.32.0 严格 `flutter analyze --fatal-infos --fatal-warnings` 无问题，134 项组件测试及 3 项调度器自测通过；其中新增回归覆盖月日模式下无年份范围以受控值年份计算边界。
- 各 PR 独立工作区使用已有 Flutter 3.32.0 Linux 镜像和离线 pub 缓存生成权威 Golden，随后无更新参数复跑通过；本组件 5 项 Demo 测试和 20 项 Golden 通过。
- Golden 使用默认精确比较器；Figma 为人工视觉对照，不是 Figma 自动像素比较。拆分后的代表性打开态已复核。
- 拆分前相同组件实现还通过 Flutter 3.47.0 analyze/功能验证；生产源码覆盖率为 `661/681 = 97.06%`。此项是此前集成验证的记录，不冒充拆分后重新测量。
- 合并最新 `develop` 后，另以 Flutter 3.44.0 严格 analyze、134 项组件测试、3 项调度器自测和 5 项 Demo 测试复跑通过。
- 原 PR 已登记本组件的组件/Demo/覆盖率/视觉入口；共享消费测试随 DateTimePicker 套件执行。远端 CI 与独立 CNB Review 以各自 PR/Issue 记录为准。

## 复现与限制

```sh
# tdesign-component
flutter analyze --no-pub --fatal-infos
flutter test --no-pub --exclude-tags golden test/components/date_time_picker
# example；Golden 使用 Flutter 3.32.0 Linux
flutter test --no-pub test/date_time_picker_demo_test.dart test/date_time_picker_demo_golden_test.dart
```

未进行 Android/iOS 真机触控与系统字体验收。未安装新软件；Flutter 3.44.0 首次解析仅刷新共享 pub 缓存，随后各分支禁网验证。三个原 PR 分别推送、分别 Review。

## 本轮复审修复

- Flutter 3.47.0（本机已有 SDK，离线依赖）严格 analyze、相同组件及调度器测试、5 项 Demo 功能测试通过；本轮未在该版本执行或更新 Golden。

- 新增 monthDay 的 value/start/end 均无年份回归，直接断言当前值和范围使用 2000，并保留 2 月 29 日。
- 本 PR 独立登记 4 项共享消费测试，覆盖真实 TPicker/TDateTimePicker 的默认及自定义底色、渐隐颜色/方向/高度、高亮色和 IgnorePointer。共享原语注释与 Spec 明确不透明底色契约。
- Flutter 3.32.0 Linux：严格 analyze 零问题，139 项组件测试、3 项调度器自测、5 项 Demo、20 项 Golden 通过，未更新基线。
- 当前分支生产源码覆盖率重新测得 **669/689 = 97.10%**，通过 95% 门禁。此前 137 项记录包含 134 项组件与 3 项调度器测试，已修正口径。

## API 收敛修复验证（2026-09-04）

本轮 API 收敛验证：Flutter 3.32.0 Linux 与本机 Flutter 3.47.0 严格 analyze 零告警，144 项组件测试、11 项调度/覆盖率工具自测、5 项 Demo 功能测试通过；3.32 Linux 20 项 Golden 无更新参数通过，基线未改。生产代码覆盖率 670/690 = 97.10%。

- 按 componentTestSuites 当前登记逐文件运行 flutter test --no-pub --coverage，再执行 dart run tool/check_component_coverage.dart date_time_picker。工具自测单独统计，不混入组件数。
- 运行真实 Demo 功能测试和 run_visual_regression.dart 登记的 Golden；没有更新图片。Android/iOS 真机尚未验证。
- 修复前真实消费测试在自定义 fontBodyLarge=19/27 时读到 Material 默认字号而失败，修复后两消费组件的 token 与显式子树 TextTheme 均通过。共享源码及测试在两个 PR 中相同。
- 修复前父级拒绝后保留 2024-07-15 而非 2024-06-15；修复后重复选择、父级原值重建均回到正确月份，原有接受值连续惯性滚动回归通过。初次 Golden 命令误用不存在的组件文件，已改用仓库登记的 Demo Golden 入口完成验证。
