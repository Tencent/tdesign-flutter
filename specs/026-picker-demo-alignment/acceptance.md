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

### 受控契约与主题边界（本地修复）

- 独立列和联动列均新增“父级不回传、不重建”回归，修复前期望初始索引 0、实际停在 8；修复后全部列停止滚动再恢复受控值。既有三列连续拖动和惯性回归继续通过。
- TPickerThemeData 保持 const 构造，新增有限正高度与正项数的调试断言，补齐默认 200 逻辑像素、5 项及行高关系。输入与手工快照列表按不可变契约使用，不做防御性深拷贝；组件回调快照不可修改已由测试验证。
- 公开 API 数量不变。行为兼容性：父级不接受新值时不再停留在候选项，已有依赖该旧行为的调用方必须回传 value；发布时应按 breaking 行为变更说明。onColumnScrollEnd 仍表示停止时的候选快照，并非接受确认。
- Flutter 3.32.0 Linux 与 3.47.0 macOS 均通过 45 项组件回归、9 项 Demo 回归和严格 flutter analyze --fatal-infos；生产覆盖率均为 368/373 = 98.66%。Linux 3.32 的 14 项 Golden 测试（18 张图片）精确比较通过，差异为 0，无基线更新。
- 本轮未重新运行手机测试。

### 联动滚动中断修复

#### 回归与 Golden 补齐

- 组件持续手势/惯性用例参数化覆盖首列、中间列、末列，检查受控回传后控制器身份、连续位移、前置列值与控制器保持不变，以及后续列重置。
- 真实地区 Demo 弹层三列分别覆盖持续拖动、松手后的位移、取消重开恢复初值、确认重开保留草稿。与组件层的长列表惯性测试互补。
- Flutter 3.32.0 Linux 与 3.47.0 macOS 各通过 15 项 Picker Widget 测试和 9 项 Demo 测试；新增测试严格静态分析双版本均无问题。11 项 CI 调度/覆盖率工具自测通过，现有 CI 文件登记已包含全部新增用例。
- 新增深浅色各三张联动后 Golden：广东/深圳/南山区、广东/东莞/东城街道、北京/北京/东城区。通过实际拖动触发，并先断言受控值；固定 375×812、DPR 1、字体缩放 1 和现有中文测试字体。检查六张实际图，无缺字、裁切或选中条错位；原有十二张基线不变。
- Linux Flutter 3.32.0 无更新参数复跑 9 项 Demo + 14 项 Golden 测试全部通过；14 项 Golden 测试共比较 18 张基线，使用默认精确比较器，差异为 0，未增加容差。
- 隔离容器挂载修复前 `c4b53e4a` 的 Picker 源码回放：三项组件用例均因控制器被替换失败，三项 Demo 用例均因原控制器脱离滚轮失败。当前修复版六项均通过，证明能拦截已知回归；不以这些测试或 Golden 代替真机帧耗时验证。

- 新增持续手势与惯性回归：修复前首次回传后原控制器已被替换，断言失败；修复后连续 move 可跨越多项，松手后位置继续变化，下级值始终属于当前分支。
- 父级接受联动值时保留当前及前置列的控制器与 key，只替换后续列；语义更新复用滚轮 child，避免每帧重建整列。不新增公开 API，不调整样式或 Demo 布局。
- Flutter 3.32.0 和 3.47.0 各通过 40 项组件回归及 6 项 Demo 测试。3.32 Picker 生产覆盖率 353/359 = 98.33%。3.32 SDK 的 dart analyze --fatal-infos 和 3.47 flutter analyze --fatal-infos 均无问题。
- Android 真机运行 3.32 profile 修复版，三列地区拖动从广东跨越浙江至河北，下级同步为石家庄/长安区。持续手势与惯性由回归测试验证；未采集真机帧耗时，不宣称稳定满帧。本次未修改或重新执行 Golden。

- Popup 默认总高 240，扣除 58 高标题栏后滚轮只剩 182，内部仍按 200 计算高亮位置；新增真实弹层回归已复现期望 200、实际 182 的失败。Demo 总高改为当前 Picker 主题高度加标题栏高度，保留独立平铺组件的状态与尺寸所有权。
- TPopupHeader 默认标题样式清除路由缺省的黄色双下划线，保留子 Widget 显式装饰；移除 Demo 中 Material 包装。未新增公共 API 或硬编码状态颜色。
- 修复版本在同一 Android 手机打开三列地区选择器，浅色/深色均确认标题无黄色下划线、选中条与选中文字居中。回归测试断言真实滚轮高 200、高亮条 343×40 且中心一致；Popup 测试同时验证默认无装饰与调用者显式下划线。
- Flutter 3.32 与 3.47 的 6 项 Picker Demo 功能回归通过；3.32 Popup 契约测试 6 项通过，严格 analyze 无告警。Linux 3.32 的 10 张打开态 Golden 因修正总高而更新，2 张整页图不变；更新后全部 12 项 Golden 与 6 项功能测试精确复跑通过。

### 示例代码面板与 Android 真机验收（2026-09-04）

- 四个代码入口通过现有 methodName 展示实际 `_cell` 核心组合，包含 Cell 触发、标签解析、Popup/Header、Picker 草稿、取消/确认。片段注明参数、初始值和父级接入；它是核心片段，不是独立应用，不提供外部源码地址指引。
- 新增代码面板 Widget 回归，实际打开四个入口读取渲染的 Markdown；沿用 picker_demo_test.dart 在 GitHub/CNB 的双版本登记。Flutter 3.32.0 与 3.47.0 各 10 项 Demo 回归通过，严格 analyze --fatal-infos 无诊断；生成器及 --check 通过。未改组件生产源码或公开 API，本轮无新增 breaking change。
- 抽取时曾因 builder context 与 State.context 的主题层级差异造成标题文字 Golden 差异，已恢复原 State.context。Flutter 3.32.0 Linux 最终 10 项 Demo + 14 项 Golden 测试通过，18 张基线精确比较，差异 0，未更新基线或容差。
- Android 16 真机运行当前应用及集成测试通过：五个示例逐一滚动、取消、重开恢复、确认、重开保留；四个代码面板显示核心组合，实际向下滚动可看到 Popup 与确认逻辑；深色地区弹层亦检查滚轮高 200，浅色五个示例检查默认项高 40。浅/深色截图人工检查无高亮错位、黄色下划线或缺字；不等同于与 Figma 逐像素一致，也不是人工手指拖动的性能测量。
- 真机复跑：在 tdesign-component/example 执行 `flutter drive --driver=test_driver/picker_example.dart --target=integration_test/picker_example_test.dart -d <device-id>`。需要连接已授权设备；integration_test 来自 Flutter SDK，仅为开发依赖。截图写入 `build/picker-device-evidence/`，driver 返回 true 仅表示截图已保存，不代表自动视觉通过。手机测试恢复原主题设置。
- 真机截图：picker-page.png、picker-area.png、picker-area-dark.png、picker-code.png、picker-code-composition.png（以上输出目录）。以上为本地验证结果，远端 CI 状态须在推送后独立确认。

### CNB Review 建议修订

- 保留四个代码入口共用实际 `_cell` 组合，不退回仅包含触发器的片段；输入数据与确认回调由方法参数显式提供。
- 移除四个未展示的 `_buildBase/Time/Area/Title` 生成注解，由生成器清理无入口片段。移除示例中的外部源码地址指引，不扩增组件或 Example API。
- 发布说明须记录 `breaking(picker): 父级未接收 onChanged 时滚轮停止后恢复受控值`；调用方应在 onChanged 中更新状态并回传 value，弹层组合先更新草稿，确认后再写入业务状态。
- 本轮本地复验：Flutter 3.32.0 严格分析无诊断，10 项 Picker Demo 测试通过，包含四个代码面板；生成器 --check 与 git diff --check 通过。本轮仅改注解、示例说明与文档，未改变运行布局或更新 Golden。

## 主题覆盖修复验证（2026-09-05）

- Flutter 3.47：`flutter test test/components/picker`，43 项通过。
- Flutter 3.47：`dart analyze --fatal-infos`，无诊断。
- Flutter 3.32 隔离环境：Picker 与 DateTimePicker 登记测试共 182 项通过；Picker 生产代码覆盖率 97.51%。
- Picker 与 DateTimePicker 深浅色 Demo Golden 共 34 项通过，原基线无变化。
