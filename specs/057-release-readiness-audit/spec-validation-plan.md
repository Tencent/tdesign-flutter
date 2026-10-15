> 2026-10-15 后续实施：本页保留上一轮操作方案；当前实施范围、已完成检查与人工待办见实施记录，详见 [Spec 058](../058-release-preparation/acceptance.md)。本页原有“未实施”描述为上一轮阶段状态。

# 未完成 Spec 验证与操作方案

## 验证方法与结论

对原始 87 份 tasks.md 全部扫描，保存其中 57 条开放记录；逐条按当前代码、实际 CI 调度、日志、工具正式交付和仓库历史核对。结果不把“测试文件存在”或“PR 合并”当成全部验收完成。自动回归复用同一源码检查点的成功结果；本轮仅修改文档，不重跑全部 Golden。

`flutter devices --machine` 本轮只列出 macOS 和 Chrome，没有 Android/iOS 设备。未运行真机验收、未取得新的 Figma/小程序设计对照，也未核实 CNB 审查。因此这些项目继续开放。

特别确认：t_popup_consumers_golden_test.dart 包含 actionSheet/dialog/drawer 三种场景，manifest 以 --plain-name 只运行 drawer；前两种不在当前绿灯覆盖内。Spec 055 仍记录这两张历史扩展场景差异，不能通过修改登记基线来直接消掉。当前是否仍失败需 Linux 3.32.0 无更新实跑，本轮 macOS 不执行或写回像素基线。

## 原始含开放任务的全部 32 个 Spec

| Spec | 当前开放条数 | 操作或核销结论 |
|---|---:|---|
| [001-tdropdown-menu-anchored-overlay](../001-tdropdown-menu-anchored-overlay/tasks.md) | 1 | 目标设备验证窄屏、键盘、锚点跟随、四边展开/收起；记录遮罩及页面可点击区域。 |
| [003-popover-contract-hardening](../003-popover-contract-hardening/tasks.md) | 2 | 在窄屏/键盘下测试四边 placement、组合 Widget、重复关闭与页面退出；另核对最终 Review。 |
| [004-toast-contract-alignment](../004-toast-contract-alignment/tasks.md) | 1 | 查阅并记录最终 Review；合并不自动代表平台审查通过。 |
| [005-notice-bar-review](../005-notice-bar-review/tasks.md) | 1 | 真机触摸、短/长文本循环及减少动画；逐帧观察跳动和销毁后任务。 |
| [005-swipe-cell-theme-review-fixes](../005-swipe-cell-theme-review-fixes/tasks.md) | 0 | 自动检查/正式工具交付或 GitHub 提交合并待办已核销，证据见 acceptance.md。 |
| [007-message-contract-alignment](../007-message-contract-alignment/tasks.md) | 1 | 真机真实触发、默认时长关闭、重复触发替换、页面退出后不回调。 |
| [007-swipe-cell-official-alignment](../007-swipe-cell-official-alignment/tasks.md) | 1 | 浏览器真实滑动、关闭/确认/滚动联动，并与目标视觉对照。 |
| [008-pull-down-refresh-minimal-api](../008-pull-down-refresh-minimal-api/tasks.md) | 1 | 真机真实拖拽到阈值、释放、刷新完成/失败与连续操作；同尺寸对照。 |
| [009-action-sheet-official-alignment](../009-action-sheet-official-alignment/tasks.md) | 1 | 逐公开入口连续打开/选择/取消，含宫格/长列表、禁用项、安全区。 |
| [011-dropdown-menu-official-demos](../011-dropdown-menu-official-demos/tasks.md) | 1 | 目标 Impeller 设备构造非仿射 transform 后真实操作，保存 shader/渲染日志；普通仿射用例不代替。 |
| [011-search-demo-alignment](../011-search-demo-alignment/tasks.md) | 1 | 取得冻结目标的小程序深色截图，同尺寸核对文字、间距和颜色。 |
| [011-text-flutter-contract-alignment](../011-text-flutter-contract-alignment/tasks.md) | 1 | iOS/Android/Web 验证系统字体、1/1.5/2 倍缩放、混合字体、富文本与复制/选择边界。 |
| [012-upload-contract-alignment](../012-upload-contract-alignment/tasks.md) | 1 | 补最终 Review 的明确结论及反馈处理记录；本轮不以合并状态推定审查完成。 |
| [015-checkbox-demo-card-alignment](../015-checkbox-demo-card-alignment/tasks.md) | 2 | 登记 Golden 已过；补真机截图/设计对照与最终 Review 记录。 |
| [019-popup-radius-duration-alignment](../019-popup-radius-duration-alignment/tasks.md) | 1 | 自动检查已过；真机检查左右面板圆角、240ms 动画和减少动态效果。 |
| [027-component-test-manifest](../027-component-test-manifest/tasks.md) | 0 | 自动检查/正式工具交付或 GitHub 提交合并待办已核销，证据见 acceptance.md。 |
| [027-slider-demo-alignment](../027-slider-demo-alignment/tasks.md) | 0 | 自动检查/正式工具交付或 GitHub 提交合并待办已核销，证据见 acceptance.md。 |
| [028-backtop-contract-alignment](../028-backtop-contract-alignment/tasks.md) | 1 | GitHub/CI 已完成部分已拆出；取得对应 CNB PR 最终 head、Review 结论及反馈关闭记录后再核销。 |
| [028-stepper-demo-alignment](../028-stepper-demo-alignment/tasks.md) | 1 | 当前 latest 实际为 Flutter 3.47.7 已过；Android/iOS 测试键盘、IME、焦点、边界值与系统字号；核对 CNB Review。 |
| [028-tabbar-design-alignment](../028-tabbar-design-alignment/tasks.md) | 2 | 取得完整 375px Demo 目标，逐项核对九个实例；组件展板不作整页替代；核对 CNB Review。 |
| [029-drawer-design-alignment](../029-drawer-design-alignment/tasks.md) | 1 | GitHub/CI 已完成部分已拆出；取得对应 CNB PR 最终 head、Review 结论及反馈关闭记录后再核销。 |
| [030-indexes-design-alignment](../030-indexes-design-alignment/tasks.md) | 0 | 自动检查/正式工具交付或 GitHub 提交合并待办已核销，证据见 acceptance.md。 |
| [030-steps-design-alignment](../030-steps-design-alignment/tasks.md) | 1 | GitHub/CI 已完成部分已拆出；取得对应 CNB PR 最终 head、Review 结论及反馈关闭记录后再核销。 |
| [031-navbar-contract-alignment](../031-navbar-contract-alignment/tasks.md) | 1 | GitHub/CI 已完成部分已拆出；取得对应 CNB PR 最终 head、Review 结论及反馈关闭记录后再核销。 |
| [032-sidebar-design-alignment](../032-sidebar-design-alignment/tasks.md) | 2 | GitHub/CI 已完成部分已拆出；取得对应 CNB PR 最终 head、Review 结论及反馈关闭记录后再核销。 |
| [038-skeleton-design-alignment](../038-skeleton-design-alignment/tasks.md) | 0 | 自动检查/正式工具交付或 GitHub 提交合并待办已核销，证据见 acceptance.md。 |
| [045-example-code-web-mapping](../045-example-code-web-mapping/tasks.md) | 1 | 补最终 Review 的明确结论及反馈处理记录；本轮不以合并状态推定审查完成。 |
| [047-miniprogram-token-alignment](../047-miniprogram-token-alignment/tasks.md) | 4 | 按冻结目标重核真实消费链和设计歧义；旧35张失败数已核销，677队列由048合并跟踪，避免重复计数。 |
| [048-component-token-theme-ownership](../048-component-token-theme-ownership/tasks.md) | 6 | 677为阶段性消费审查队列，按状态/Theme覆盖/最终绘制分批核对并记录设计例外；未审不算缺陷；另完成0.2.7迁移指南。 |
| [050-public-api-documentation](../050-public-api-documentation/tasks.md) | 0 | 自动检查/正式工具交付或 GitHub 提交合并待办已核销，证据见 acceptance.md。 |
| [053-upload-async-picker-state](../053-upload-async-picker-state/tasks.md) | 0 | 自动检查/正式工具交付或 GitHub 提交合并待办已核销，证据见 acceptance.md。 |
| [055-tag-single-line-centering](../055-tag-single-line-centering/tasks.md) | 2 | 登记 Golden 已过；核对全组件状态矩阵与实际字形；先单独验证未执行的 ActionSheet/Dialog Popup消费场景，再补真机最终字体/交互。 |

## 建议执行顺序

1. 先解决 CI 覆盖缺口：三份功能测试漏调度、两种 Popup 消费 Golden 被过滤；先无更新运行，再按失败定位实现或过时基线。修复方案见 ci-review.md。
2. 收敛 047/048 共用消费队列：为每项记录所属组件、默认/禁用/按压/选中、明暗模式、局部 Theme、最终取值和证据；先核对会导致公开 API 或默认行为变化的项。确认无需对应 Flutter 能力的项目记理由，不能机械补字段。
3. 设备批次 A：Input/Textarea/Form/Stepper，重点空内容粘贴、中文组合输入、焦点/选择、键盘收起后的值保留。批次 B：Popup/Popover/Dropdown/ActionSheet/Message/Toast，重点连开连关、安全区、键盘、返回键与生命周期。
4. 设备批次 C：Picker/DateTimePicker/Calendar/Swiper/Refresh/SwipeCell/Upload，重点边界值、惯性、拖动取消、异步结果、权限及离开页面。每批均覆盖正常字号和较大系统字号。
5. 设计对照单独进行：固定目标版本、viewport、字体、语言和主题，以完整公开场景逐项核对；仅有组件展板或首屏时不标整页通过。
6. 汇总 CNB/人工 Review 的最终记录；若平台记录确实不可获取，由维护者明确选用当前发布前重新审查来替代，而非篡改历史通过状态。
7. 最终 RC 冻结后按同一提交复核受影响功能、Linux 3.32.0 无更新 Golden 和设备场景。缺陷修复后只重复受影响的层级。

## 单项记录格式

场景 ID / Spec / 候选 SHA / 设备及系统 / Flutter 与依赖版本 / 语言、主题、缩放和尺寸 / 触发步骤 / 预期 / 实际 / 截图或日志 / 缺陷或接受差异依据。

通过标准是该 Spec 的实际契约得到证据；自动回归、设计与设备证据分别记录。此方案不宣称 677 项、全状态字形或全部设备验收已完成。
