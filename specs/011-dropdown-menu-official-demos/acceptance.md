# 验收记录

下方按阶段保留历史结果；当前实现审查修复与兼容性结论见末节。

## 验证环境

- 分支：基于 `origin/develop` 的本地审查工作树
- 提交：待提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart latest

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dropdown_menu --coverage` | PASS，61 tests | `LH=925` / `LF=941` = 98.30% |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.32.0；覆盖公开矩阵、禁用交互及三列展开尺寸 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.47.0 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |
| `dart run tool/generate_example_code.dart` | PASS | 同步更新三列多选示例片段 |
| CNB 同款 `docker/flutter-3.32.0` Linux 镜像更新并复跑 `dropdown_menu_page_golden_test.dart` | PASS，6 + 6 tests | 整页、单选展开及三列多选展开的 light/dark 基线由 Linux 生成，并无更新参数复跑 |
| 回归调度器工具测试 | PASS，10 tests | DropdownMenu 组件、覆盖率、Demo 功能和视觉回归登记同步 |
| Flutter 3.47.0 组件与 Demo 非视觉测试（历史结果） | PASS，59 + 3 tests | 当时采用 1px 容差；其“引擎舍入”归因已撤回，见下方锚定容差复核 |

## 人工验收

- [x] 官方 Demo 的两个公开分组已在运行截图中复核，Flutter 扩展分组已移出公开页，证据见 [visual-comparison.md](visual-comparison.md)。
- [x] 单选及三列多选菜单在点击后完成 Figma 与 Flutter light/dark 展开态核对。

## 未覆盖项与后续工作

- 未新增公共 API；单选值和多选值继续由 `value` / `values` 与回调管理，`controller` 只承担跨树开关命令，避免重复状态源。
- `placement`、overlay 配置、自定义 trigger/panel 仍有独立职责，本次不删除既有公开能力；默认视觉变化不构成公开 API 签名 breaking change。
- 已复现的边界拉伸仿射滤镜与跨 Overlay Follower 几何分离已修复，结果见末节；非仿射 Impeller shader 路径与真机像素表现仍未验证，不能由当前测试推断通过。
- 向上展开、custom trigger、scrollable 与局部 Theme 属于 Flutter 扩展能力，不作为小程序公开矩阵的一对一视觉场景；组件聚焦测试继续覆盖这些路径。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@fb26b8d5`，并根据固定基线源码纠正原审查误判：官方状态组是两个禁用菜单，不是“一禁用一可用”。
- Demo 已用现有 API 收敛为“全部产品 + 默认排序”、同栏 1/2/3 列多选和两个禁用菜单；页面不再附加 Flutter 扩展或内部单元测试分组。
- CI 同款 Flutter 3.32.0 Linux：页面与单选点击展开态 light/dark Golden 共 4 项、4 个功能测试，更新后复跑共 8 tests 通过。
- Flutter 3.32.0 与 3.47.0：59 个组件测试、3 个 Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：生产组件源码相对 develop 无差异，没有新增或调整公共 API。
- 完整滚动官方 Web 预览确认页面在双禁用菜单后结束；Flutter 已移除扩展与内部测试分组。CI 同款 Flutter 3.32.0 Linux 重建 375×812 明暗整页及点击后展开态 Golden，并在不带 `--update-goldens` 时复跑 4/4 通过；截图证据已同步更新。

## 2026-09-03 Figma 对齐与冲突解决复验

- 已合并 `origin/develop@ed6ac81d`，CI 测试清单与 Golden 字体字符集合采用双方并集，5 个冲突文件均已消解。
- Figma 标注的 48px 菜单栏、4px 文本图标间距、24px 箭头/勾选图标、56px 单选行、16px 选项文字及三列 12px 间距已由 token/theme 默认链实现并加入直接断言。
- 设计稿三列面板改为 12 个正常项、3 个禁用项和底部操作栏；理论高度 348px，Flutter 的 0.5px 分割线使实测高度为 348.5px。
- `CompositedTransformFollower` 与 `ScrollNotificationObserver` 的既有实现覆盖普通滚动跟随，未为此增加第二套定位 API；当时未识别边界拉伸滤镜的分离，后续复核和修复见下文。
- Flutter 3.32.0 与 3.47.0 的 61 个组件测试、4 个 Demo 功能测试及严格 analyze 均通过；生产覆盖率 98.30%。Flutter 3.32.0 Linux 的 6 张 Golden 更新后无更新参数复跑 6/6 通过。

## 2026-09-03 锚定容差复核

### 根因证据

- 固定 Flutter 3.47.0（framework `4cf2416426`，engine `5f77625673`），未修改生产组件实现。旧用例从 offset=250 向下拖动 5×52，最后一步越过 minScrollExtent=0，触发默认 `StretchingOverscrollIndicator`。
- 前四步菜单与面板的贴边差值均为 0；第五步第二帧菜单 top=400.9276584071243、面板 bottom=400，严格 `0.001` 断言失败，差值为 0.9276584071242837。第一帧面板 top 与菜单 bottom 已差 1.0389774159792182，旧测试只测第二帧，1px 容差也不能证明全过程正确。
- SDK 的 `StretchEffect` 在该测试环境走 `Transform(filterQuality: FilterQuality.medium)` 路径。`RenderTransform.applyPaintTransform` 用矩阵计算几何坐标，但绘制采用 ImageFilterLayer；Follower 的图层变换不能反映同样的滤镜视觉变形。不是浮点数不支持 0.5，也不是像素栅格整数取整。
- 不含 TDesign 的最小对照：Stack 中一侧是 `Transform(scaleY=1.01, alignment=topLeft)`，内部先放 100 高占位，再放 48 高的 `CompositedTransformTarget`；另一侧用同一 LayerLink 的 Follower 对齐 target.bottomLeft。`filterQuality=null` 时 target.bottom=follower.top=149.48000000000002；`filterQuality=medium` 时 target.bottom 不变而 follower.top=148，差值为 1.4800000000000182。仅切换滤镜即复现，临时诊断测试不进入正式回归清单。

### 第一阶段：仅修复测试（历史记录）

- 原方向切换用例增加顶部内容空间，初始 offset=350.5，正反向手势使用 52.25 逻辑像素。方向仍在同一次未松开的手势中由下→上→下切换，没有关闭平台滚动效果。
- DPR=1/2/3/3.25，固定 800×600 逻辑视口；直接断言初始锚点 top=149.5，证明半像素位置不会被强制取整。
- 每次移动后分别检查两帧，并在手势结束、jumpTo 后继续检查；面板和遮罩与菜单边缘使用 0.001 逻辑像素容差。接缝覆盖断言独立存在，不能代替面板本体贴边。
- 同时监听 OverscrollNotification，断言计数为 0、scroll position 未越界，防止测试再次把越界效果混入方向切换。
- 生产组件、API、Token、Demo 和 Golden 文件均不变；不属于 breaking change，没有新增用户可感知变更日志。

### 第一阶段验证结果（已由末节结果更新）

- Flutter 3.47.0：组件 64/64、Demo 4/4、调度器自测 11/11；组件与 Demo 严格 analyze 均 0 issues；组件生产覆盖率 LH/LF=925/941=98.30%。
- Flutter 3.32.0：组件 64/64、Demo 4/4；组件与 Demo 严格 analyze 均 0 issues；组件生产覆盖率 LH/LF=925/941=98.30%。SDK 切换前对组件与 Example 执行 clean，并分别恢复依赖，未复用高版本编译缓存。
- 本轮仅修改非视觉测试与验收说明，未重新生成或更新 Golden；上方 Linux Golden 结果属于前次验证，不作为边界拉伸的证据。

### 第一阶段识别的边界

普通滚动及方向翻转的严格断言通过，不等于边界拉伸问题已修复。不能通过加厚接缝、扩大容差，或静默禁用用户页面的拉伸效果来宣称修复。仿射滤镜问题已在第二阶段处理；Impeller shader 路径及真机像素表现仍未验证。

## 2026-09-03 第二阶段：修复仿射滤镜锚定

### 实现与契约

- DropdownMenu 私有 LeaderLayer 对比 RenderObject 完整变换与图层变换，将缺失的仿射矩阵补充给原有 Follower。菜单仍经原始滤镜绘制，Follower 的命中测试、生命周期和锚点选择继续复用 Flutter 实现。
- 仅菜单打开时逐次合成解析祖先变换，避免闭合菜单额外遍历；没有新增 ticker、定位状态源或公开 API。菜单保持打开，页面拉伸效果保留。
- 原越界用例在 Flutter 3.32.0 的严格断言也能复现失败，修复后两个 SDK 均通过；说明问题不是 latest 独有，也不是不支持 0.5 逻辑像素。
- 范围内/越界拖动分别覆盖 DPR 1、2、3、3.25；逐帧检查上下翻转、面板和遮罩贴边、接缝与回弹。祖先单独变化时的普通/滤镜缩放分别覆盖向上/向下展开与点击，几何容差统一为 0.001。
- 公共 API、Token 默认链和公开 Demo 不变，不属于 breaking change。用户可感知更新日志建议：`fix(dropdown-menu): 修复越界拉伸时菜单与面板分离`；本轮未修改远端 PR 或自动生成 CHANGELOG。

### 最终自动化结果

| 验证 | Flutter 3.32.0 | Flutter 3.47.0 |
| --- | --- | --- |
| 组件功能回归 | 72/72 | 72/72 |
| 公开 Demo 功能回归 | 4/4 | 4/4 |
| 组件与 Example 严格 analyze | 0 issues | 0 issues |
| 组件生产 LCOV | 971/987 = 98.38% | 971/987 = 98.38% |

- 双 SDK 缓存隔离；组件与 Example 均单独恢复依赖。Linux 镜像为 CI 同款 Flutter 3.32.0，非视觉矩阵的高版本固定为 Flutter 3.47.0，并非对未来 latest 的保证。
- Linux Golden 无更新参数复跑 8/8：既有 6 张基线未修改，新增浅色/深色正在拉伸的展开态各一张。使用独立组件场景保留公开 Demo 的弹性滚动物理配置；截图前断言滤镜拉伸仍活跃且严格贴边，避免 settle 掩盖分离。
- 新基线已人工检查接缝、文字和图标；严格像素比较通过。非仿射 Impeller shader 及实际设备表现仍需独立验证。
- 回归调度器、视觉清单与覆盖率工具自测 11/11 通过；现有测试文件已登记，新增场景随原组件套件执行，无需新增 CI 分支。

## 2026-09-03 合并 develop 冲突复验

- 合并 `origin/develop@09ec448d`（Dialog 改动），保留 DropdownMenu 锚定修复 `6c8eeabb`。8 个冲突文件涉及 CNB/GitHub 示例 CI 清单、组件/覆盖率/视觉调度登记及 feedback 测试字体；双方组件实现无冲突。
- CI 和调度清单同时保留 Dialog、DropdownMenu；字体从已校验的 Noto Sans SC 2.004 原文件使用 fonttools 4.59.1 重新生成，双方原字体 cmap 均完整保留。
- 首轮 Linux Golden 暴露 Dialog 页面说明“断”字缺失：develop 字体的缺字轮廓为空，旧基线留下空白；原分支字体保留可见缺字轮廓，合并时将其暴露为方框。补入“断”字而不隐藏缺字提示，不改变生产组件或 Demo 文案。新字体 SHA-256 见字体 README。
- 检查真实图与差异图后，仅更新显示该说明的 Dialog 整页及三个确认场景明暗共 8 张 Golden；其他基线未改动，尤其 DropdownMenu 8 张基线全部不变。没有放宽比较容差。
- Flutter 3.32.0 Linux 与 Flutter 3.47.0：DropdownMenu 72 + Dialog 32 + 调度器工具 11，合计各 115/115；四组件 Demo 功能各 29/29；组件及 Example 严格 analyze 均 0 issues。
- Flutter 3.32.0 Linux 无更新参数复跑共享该字体的 DropdownMenu、Dialog、ActionSheet、NoticeBar Golden，共 44/44，最终精确比较无差异。
- 本轮解决合并冲突及其字体回归，没有新增公开 API；边界拉伸的非仿射 Impeller 真机验证限制仍保留。上述结果是合并后本地验证，推送后的远端 CI 和 CodeBuddy Review 需基于新 head 重新确认。

## 2026-09-03 实现审查问题修复

- 基线为 c5ef738d，本轮未提交或推送。上一轮仓库外测试复现三处缺陷：800px 测试视口中双列宽度 372/384px；自定义遮罩 alpha=0.2 被覆盖为 0.6；显式 200ms 被主题 800ms 覆盖。
- 列间距从 Expanded 内移到等宽选项之间；继续使用 spacer12，保留末行空列。遮罩按完整 Color 的 alpha 乘动画进度，默认黑色 60% 不变。动画使用 nullable 实例 > Theme > 200ms，并保留系统减少动画的最高优先级。
- 公开 API 兼容性：animationDuration 字段改为 Duration?，null 表示未指定。构造调用不变；直接读取并按非空 Duration 使用的代码需处理 null。该字段签名变化按 breaking 记录，具体迁移说明见 plan.md。没有新增参数或选择状态源；多选草稿行为不变，补充了外部值更新规则的 dartdoc。
- 评估 Flutter 3.32.0 RawMenuAnchor、OverlayPortal 和 Follower 后保留原 Overlay 架构。未改变锚点、滚动跟随、单侧遮罩、关闭时序、焦点、仿射修正或 0.001 几何容差。

| 验证 | Flutter 3.32.0 Linux | Flutter 3.47.0 macOS |
| --- | --- | --- |
| 组件功能测试 | 97/97 | 97/97 |
| 回归调度器自测 | 11/11 | 11/11 |
| Demo 功能测试 | 4/4 | 4/4 |
| 组件与 Example 严格 analyze | 0 issues | 0 issues |
| 生产源码 LH/LF | 970/986 = 98.38% | 970/986 = 98.38% |

- 命令：组件目录执行 `flutter test --no-pub test/components/dropdown_menu test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart --coverage`，随后 `dart run tool/check_component_coverage.dart dropdown_menu`；Example 运行 `flutter test --no-pub test/dropdown_menu_page_test.dart`；两目录分别运行 `flutter analyze --no-pub --fatal-infos`。
- 25 个新增组件用例覆盖 1/2/3 列、RTL/LTR、375.5px 非整数宽度、末行不足列数、默认/自定义 spacer12、实例/主题/内置动画优先级、减少动画，以及四种遮罩颜色的展开/收起 alpha 与完整 RGB。
- Linux Golden 初次比较仅两张多选展开态失败：light 15335px（5.04%）、dark 15292px（5.02%）。人工检查实际图、旧图和差异图，变化仅为等宽选项及居中文字，面板高度、按钮、页面和遮罩不变。只更新这两张基线后，不带更新参数复跑 `test/dropdown_menu_page_golden_test.dart`：8/8，精确比较最终 diff=0，无新增容差，其余 6 张不变。
- 测试隔离：Linux 使用 CI 同款 Flutter 3.32.0 镜像和独立快照，组件与 Example 分别恢复依赖；不混用 macOS/高 SDK 编译缓存。新用例继续放在已登记文件中，CI 入口及清单同步自测通过。
- 本次没有重新进行真机操作或取得新的 Figma 截图；沿用已冻结设计契约。非仿射 Impeller shader 路径仍未独立验证，不能从仿射测试或 Linux Golden 推断通过。
- 待推送时的用户日志：`fix(dropdown-menu): 修复多列选项宽度不一致`；`fix(dropdown-menu): 保留自定义遮罩透明度`；`breaking(dropdown-menu): animationDuration 改为可空以明确主题继承，修复显式时长覆盖优先级`。不手改自动生成 CHANGELOG，本轮不更新远端 PR。
