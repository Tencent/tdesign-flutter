# 验收记录

基线：PR #1157 head `4a24328df66e8ff75785b9db7f0bed0e1e088fea`。验证日期：2026-10-12。原工作区的用户修改未纳入本 PR。

## 双版本

- Flutter 3.32.0 / Dart 3.8.0；官方 stable 3.47.7 / Dart 3.13.5，framework `abaf9c523780a608bd46686fd5e53740a07077f8`。
- latest 使用独立 SDK、依赖解析和源码副本，不修改调用方的 SDK 与锁文件。
- 两版本组件包及 Example 的 `flutter analyze --no-pub --fatal-infos` 均零诊断。
- 两版本最终全量回归均通过 57 组组件功能及生产覆盖率门禁，各 2815 项测试，最低覆盖率 95.55%。
- 两版本完整 Example 非 Golden 回归各 365 项通过；六组 CI 工具自测各 144 项通过。
- 两版本 Example release Web 构建通过；片段生成、Demo 结构及片段审计通过，370 个片段同步。
- 新内部边界回归 7 项通过，单独测得 helper 生产覆盖率 222/225 = 98.67%，并纳入 theme 组件测试和覆盖率清单。
- latest 专项验证附近的新版 `InputDecorationTheme` Widget：填充、最小高度 90 和密度 +4 均不控制 Input/Search 内部编辑器；无 InputDecorator，编辑器高度 24，提示词可见。此诊断留在隔离验证副本，不引入低版本不支持的 API。

## 样式及内容边界

- 对照 M2/M3，全局与附近 Material Theme 均无法注入 TD 内部按钮背景、形状、密度、反馈、文字字距、图标透明度/阴影、分隔线、列表或进度环样式。
- 显式 TD 样式继续生效，包括 ButtonStyle（密度除外）、Search 的完整 clearIconTheme、Swiper controlStyle、组件 TextStyle；回调、控制器写入、输入/清空/密码切换和 disabled/readOnly 由组件及消费者回归验证。
- 内部原生控件保留调用方内容的原始 InheritedTheme，再提供原有组件文字及图标默认值；测试同时验证 ThemeData 与附近组件主题的恢复。
- 输入提示词随控制器值更新，有独立语义且不拦截编辑器交互；不禁用字体缩放、方向、平台输入或焦点行为。
- 共享解析后逐组件处理；扫描全部组件的原生视觉入口，内部 Material 实现集中在不导出的 helper，组件公开签名不变。

## Golden

Linux/amd64，Flutter 3.32.0，使用登记比较器、字体和原始容差。先全量比较，75 个登记入口；首轮 517 张图片出现预期差异，其中 14 张整页高度变化 2–4px。差异包含完整 TD 字体/字距、图标和原生控件样式归属修正。代表性 ActionSheet、Dialog、DropdownMenu、Tabs、Collapse、Search、Slider、Input、Rate、Switch、SwipeCell 与 M2/M3 对照图已检查，没有观察到裁切或状态丢失；Collapse 中文与 Slider 数值标签的字体回退得到修正。

最终同步 523 张受控基线：355 张仅导航标题变化、154 张页面内容变化、14 张尺寸变化。Picker 四张后续联动状态仅导航标题改变，SideBar 共享输出按真实基线路径核对；未带入失败图或纯编码变化。

Search 的两项结果状态 Golden 依赖原生 decoration.hintText 查找器，首轮无法定位。改为按 TSearchBar 的公开 hintText 定位后，先补比较两张结果状态图，再仅更新已验收的排版差异；latest 两项实际输入与结果检查亦通过。

仅更新本次有意差异，随后不带更新参数全量复跑。最终 75 个登记入口（去重后 74 组执行）全部通过，合计 668 项测试。复跑未使用 --update-goldens，未调整容差。

## 迁移及风险

此项属于 breaking：外部 Material 默认与显式配置不再是 TD 内置样式入口；依赖该路径的应用应迁移到已有 TD Token、组件 ThemeExtension 或实例样式。调用方自定义内容仍保留自身主题行为。规则已写入 CONTRIBUTING 与组件 Review skill；旧 Button Spec 的泛化 Material 覆盖规则由本 Spec 取代。

未新增公开配置。CI 和交付状态以 PR 最终远端 head 的实际结果为准。

## 源码指纹

相对上述基线的 75 个变更 Dart 文件（含新增 helper 与回归）按路径排序，依次连接 `path + NUL + file bytes + NUL` 的 SHA-256：`b80feabf32b9f8f6335cb556ecee359d93c428b1ffdf749756a6fa32708c528f`。
