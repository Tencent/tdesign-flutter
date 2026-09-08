# 验收记录

## 2026-09-08 最新 develop 同步与公开契约复审

- 已合并 `origin/develop@d2ff7a0a`，保留 Cascader、SideBar 与 Popover 的新增
  Demo、主题及回归登记；Steps 分支不再落后 develop。
- 修复垂直可选择步骤使用 `customTitle` 或仅提供 `content` 时缺少右箭头的
  问题；字符串标题与自定义标题现在共用标题行和间距，`onChange` 仍是唯一
  可选择来源。
- 重写 Steps 站点文档，删除不可编译的 `activeIndex`、`successIcon`、`simple`、
  `readOnly`、`verticalSelect`、`TStepsStatus.success` 旧用法，补充受控、
  自定义内容、错误态、纯展示及 breaking change 迁移说明。
- Flutter 3.32.0：Steps/Text 组件测试 38/38、Steps Demo 3/3 通过，严格
  analyze 零问题；组件路由、Example 与站点文档契约检查通过。
- 合并后的共享导航 Golden 同时包含 Steps 与 SideBar 变更，不能选择任一旧
  二进制基线冒充组合结果。当前先保留 develop 基线；固定 Linux + Flutter
  3.32.0 的组合基线仍需在允许挂载仓库的可信环境中重新生成并严格复跑。

## 2026-09-08 补充复审与修复

本节为本轮结果；下方真机、构建及首轮检查是历史记录，不替代本轮证据。

- 基于 PR head `79eff997` 修复；重新核对 `develop@3d5ed773` 未变化。
- 修复横纵标题、内容和序号文字将默认值作为实例 style 传入的问题。内置 defaults 低于显式 TextTheme、DefaultTextStyle、TTextThemeData；只改字体族/字号不覆盖状态色，实例自定义 Widget 仍优先。
- 新字段级解析仅对组合 defaults 生效；内部 `TTextThemeSource` 只读取原有投影快照，不导出、不持有新状态。无 defaults 的 TText 及其他组件维持原路径；试验性全局主题和共享消费者改动已撤回。
- display 横纵均为全实心节点，忽略 value/status，交互仍只看 onChange。
- 10 个公开代码入口逐个实际打开并与生成片段匹配；受控示例补充 State 初始字段和接入说明。10 份实际生成片段在最小宿主中编译/渲染，受控选择与反馈操作通过；临时拼接测试不作为独立示例实现提交。
- Flutter 3.32.0 全部非视觉组件测试 2074/2074；3.47.0 Steps/Text/工具测试 73/73，Demo 与片段编译 13/13；两版本严格 analyze 零问题。
- 生产覆盖率：Steps 238/239 = 99.58%，Text 219/222 = 98.65%。
- Linux 3.32.0：Steps 整页与共享导航明暗 4 张基线更新后严格复跑。自动 Material 行高不再覆盖默认值，整页 375×3067 → 375×3055；共享导航仅 Steps 区域减少 2px，后续内容顺移。对照实际图/基线图，未见缺字、裁切或状态缺失。未设像素容差，复跑 diff 为 0。
- 保留原路径的 Text/Button/ActionSheet 18 项结构与视觉测试通过，无需修改其基线。
- 本轮未重新进行 Android/iOS 真机逐像素核对；不能将代码/Golden 验证等同于与设计稿逐像素完全一致。最新远端 CI 与 CNB Review 以推送后的结果为准。

## 2026-09-08 develop 同步复审

- 已合并 `origin/develop@3d5ed773`；组件 API、状态所有权与 Token 路径无新增冲突，
  未发现实例默认样式向 Theme 或其他组件泄漏。
- Flutter 3.32.0 `flutter analyze --fatal-infos` 通过；组件测试 23/23、集中回归
  清单自测 13/13 通过；生产源码覆盖率 226/233 = 97.00%。
- macOS 上公开 Demo 结构测试通过；整页 Golden 因 develop 的公共导航标题样式变更
  出现 light 4.72%、dark 4.69% 的预期差异。权威基线只在 Flutter 3.32.0 Linux
  更新，等待本轮 CI 产出 Linux failure artifact 后核对并提交。

## 环境

- 分支：`rss1102/breaking/steps-design-alignment`
- 基线：`origin/develop` (`f3e14c43`)
- Figma：页面 `24386:5241`，移动端画板 `28591:34552`
- 真机：Xiaomi Android 16，ADB `40302eeb`

## 当前已完成

- [x] 新版 Figma / 小程序 / Flutter 三方差异与跨端取舍已记录。
- [x] 组件公开契约、Flutter 状态所有权与 Theme Review 已完成首轮收敛。
- [x] 真机首次安装运行并执行 uppercase `R`；浅色逐段滚动、点击，切换深色主题。
- [x] 修复垂直可选择与纯展示节点状态后再次 uppercase `R`，重新进入页面并点击复验。
- [x] Flutter 3.32.0 全包 analyze 为 0 issue；Steps focused tests 通过。
- [x] 组件测试 23/23、Demo 结构/交互 2/2、生产源码覆盖率 226/233（97.00%）通过。
- [x] Flutter 3.32.0 与 3.47.0 analyze、组件测试、Demo 测试、Web release 和 Android debug 构建通过。
- [x] Flutter 3.32 Linux light/dark Golden 2/2 生成后无更新参数严格复跑 2/2；逐张检查无缺字、无裁切。
- [x] 示例代码片段生成器完成 11 个旧片段清理、10 个新片段生成，`--check` 通过。
- [x] Android 16 真机 integration 1/1 通过；普通 APK 安装返回 `Success`，强停后冷启动到 TDesign 首页。

## API / Theme Review

- `value` 是唯一受控值；组件不内部回写，越界值仅在渲染时收敛。
- `onChange` 是唯一交互/只读开关；垂直回调同时启用点击和右箭头，不再由 Theme 或第二个布尔值控制。
- `variant` 只负责 `standard`、`dot`、`display` 视觉结构，`status` 只负责当前步骤的 `process/error` 业务状态。
- `customTitle/customContent` 明确覆盖字符串便利字段；`icon/errorIcon` 保持强类型 `IconData`。
- 删除持有业务状态的 `TStepsThemeData`；颜色与字体使用 `context.tTheme` 语义 Token，固定节点/连线尺寸记录为组件设计常量。

## Golden 人工检查

- light/dark 均为 375×3067 完整长页，三组顺序与新版 Figma 一致。
- 水平/垂直默认、图标、点状及自定义内容完整；错误态包含默认、图标、点状三种。
- 垂直可选择默认前三项实心、当前项空心；纯展示四项均实心且无箭头。
- 独立 Steps CJK 子集消除 Linux 缺字方框；深色仅改变语义颜色，不改变结构。
- 合并含 TabBar #1085 的 `develop@1de424cb` 后，GitHub Actions 在本分支
  `dac8ca16` 的 Flutter 3.32.0 Linux 任务仅产出共享导航 light/dark 两张差异图；
  人工检查确认 TabBar 新 API 渲染保持不变，差异来自 Steps 标题/内容布局向上收敛
  2px 及其后续内容等量上移。基线采用该任务 artifact 的 `testImage`，未使用 macOS
  抗锯齿结果；更新后仍需由下一轮 Linux CI 严格复跑确认差异为零。

## 待完成（当前）

- GitHub #1084 / CNB #151 已存在；`dac8ca16` 的双版本 analyze 已通过，Linux
  Golden 按最新 artifact 修正；完整 CI 与 CodeBuddy Review 待下一次推送后核验。
