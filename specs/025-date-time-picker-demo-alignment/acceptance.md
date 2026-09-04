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

## B1 月日接受值惯性回归（2026-09-04）

- 修复前新增真实 fling 回归失败：保留 year=2024 接受结果后原 DateTimePickerWheelState 已销毁；修复后同一 State 保留且回调次数 >1。
- 另验证只修改隐藏计算年 2024→2025 时滚轮重建、完整日期同步；原有拒绝原值恢复及普通年月日接受惯性回归继续通过。
- Flutter 3.32.0 Linux 与本机 3.47.0 严格 analyze 零告警，146 项组件测试、11 项工具自测、5 项 Demo 测试通过。
- Flutter 3.32.0 Linux 20 项 Demo Golden 无更新参数通过；生产覆盖率 668/688=97.09%。未新增 API，未改变图片基线；真机未测。

## 2026-09-04 Review 收尾（本地）

- 核心片段包含格式化实现、九种场景配置、初始值及 State/setState 接入说明；生成器 `--check` 通过。
- 新增代码面板回归：固定 375px 手机视口，逐项滚动打开九个面板，核对面板 Markdown 实际加载当前生成资产；不增加 URL 禁用或文案规范断言。全页测试辅助壳反复换 model 不适用于本项，使用真实滚动路径避免该假阳性。
- Flutter 3.32.0 和已安装 3.47.0：6 项 Demo 功能测试通过（包含原有取消、确认、拖动）；严格 analyze 无诊断。
- Linux Flutter 3.32.0：首次比较 2 项整页通过、18 项打开态失败，旧基线仍为 182px 滚轮。核对实际图、旧图和仓库 Figma 证据后，同步已修复的 200px 滚轮打开态；未改变组件源码或放宽容差。更新后立即无更新参数复跑，20 项全部通过，严格像素比较差异为 0。
- 共享测试保留在 Picker 与 DateTimePicker 各自套件中，以维持独立消费回归；未删除旧测试或扩增 API。
- 本轮未执行 Android/iOS 真机或实时 Figma 测量；Widget 面板测试与 Linux Golden 不等于真机验收。
- 生成的核心片段直接装入所声明的最小 State 宿主，Flutter 3.47.0 编译及确认回传烟测通过；临时宿主已移除，不维护第二份示例。

## 2026-09-04 Typography verification

- Live Figma Properties: 28591:37823 (section title) = Title/Large, PingFang SC Semibold, 18px/26px, weight 600; 39079:22146 (Cell title) = Body/Large, PingFang SC Regular, 16px/24px, weight 400.
- Compact section titles now use fontTitleLarge instead of hardcoded 700/18/26, with explicit TextTheme.titleLarge overrides preserved. Cell typography remains unchanged.
- Added final TextStyle assertions for section and Cell typography, plus custom TD token and explicit TextTheme inheritance tests. Flutter 3.32.0 Linux and 3.47.0: 14 functional tests passed each; strict analysis passed.
- All 72 related Golden tests passed on Linux 3.32.0 without updates or tolerance changes. The test font did not produce a pixel difference for 600 versus 700; TextStyle assertions directly guard this contract.
- Built and installed the corrected Android app and opened DateTimePicker on the connected phone. Platform glyphs are not claimed to be pixel-identical to PingFang SC.

## 主题与受控回滚修复验证（2026-09-05）

- Flutter 3.32 隔离环境：Picker 与 DateTimePicker 登记测试共 182 项通过；DateTimePicker 生产代码覆盖率 97.17%，Picker 97.51%。
- Flutter 3.47：相关组件、日期算法及主题测试通过；`dart analyze --fatal-infos` 无诊断。
- Picker 与 DateTimePicker 深浅色 Demo Golden 共 34 项通过，原基线无变化。
