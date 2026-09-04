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

## develop 合并与视觉复核（2026-09-04）

- 合入 develop `c6524c2c`。实际冲突为六个共享登记文件：两套 CI 功能测试入口、字体说明及组件/覆盖率/视觉调度清单；保留 Calendar 与 Picker 两边登记。组件生产源码没有冲突。
- 复核既有 Figma 分支截图与 375×812 浅色/深色 Golden。默认面板高度 200、五项、行高 40；选中条宽 343、左右 16、圆角 6；列内容宽 311，三列时每列约 103.67；上下渐隐高 48。背景、高亮、普通/选中/禁用文字使用当前 TDesign 语义 token。没有发现需要改动生产样式或扩展 API 的问题。
- Flutter 3.32.0 Linux 离线严格 analyze 通过；39 项组件测试、11 项调度/覆盖率自测、5 项 Demo 功能测试及 12 项 Golden 通过，未更新基线。Picker 生产覆盖率 336/342 = 98.25%。
- Flutter 3.47.0 严格 analyze 通过；组件与工具测试合计 54 项通过，Picker/Calendar Demo 功能测试合计 11 项通过。
- 首次 Android 真机仅打开基础单列，不能据此判断全部示例一致。复查该截图发现头部标题黄色双下划线及滚轮被压缩；此前无偏差的结论撤回。
- 视觉参考仍为已保存 Figma 截图，未重新读取节点属性；不声称跨平台逐像素一致。

## 真机问题修复

- Popup 默认总高 240，扣除 58 高标题栏后滚轮只剩 182，内部仍按 200 计算高亮位置；新增真实弹层回归已复现期望 200、实际 182 的失败。Demo 总高改为当前 Picker 主题高度加标题栏高度，保留独立平铺组件的状态与尺寸所有权。
- TPopupHeader 默认标题样式清除路由缺省的黄色双下划线，保留子 Widget 显式装饰；移除 Demo 中 Material 包装。未新增公共 API 或硬编码状态颜色。
- 修复版本在同一 Android 手机打开三列地区选择器，浅色/深色均确认标题无黄色下划线、选中条与选中文字居中。回归测试断言真实滚轮高 200、高亮条 343×40 且中心一致；Popup 测试同时验证默认无装饰与调用者显式下划线。
- Flutter 3.32 与 3.47 的 6 项 Picker Demo 功能回归通过；3.32 Popup 契约测试 6 项通过，严格 analyze 无告警。Linux 3.32 的 10 张打开态 Golden 因修正总高而更新，2 张整页图不变；更新后全部 12 项 Golden 与 6 项功能测试精确复跑通过。
