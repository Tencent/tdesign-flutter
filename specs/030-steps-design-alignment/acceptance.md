# 验收记录

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
- `variant` 只负责 `defaultTheme`、`dot`、`display` 视觉结构，`status` 只负责当前步骤的 `process/error` 业务状态。
- `customTitle/customContent` 明确覆盖字符串便利字段；`icon/errorIcon` 保持强类型 `IconData`。
- 删除持有业务状态的 `TStepsThemeData`；颜色与字体使用 `context.tTheme` 语义 Token，固定节点/连线尺寸记录为组件设计常量。

## Golden 人工检查

- light/dark 均为 375×3067 完整长页，三组顺序与新版 Figma 一致。
- 水平/垂直默认、图标、点状及自定义内容完整；错误态包含默认、图标、点状三种。
- 垂直可选择默认前三项实心、当前项空心；纯展示四项均实心且无箭头。
- 独立 Steps CJK 子集消除 Linux 缺字方框；深色仅改变语义颜色，不改变结构。
- 共享导航 Golden 在 macOS 的全画布字体抗锯齿差异未被误更新，保留 Linux 权威基线。

## 待完成

- 独立 GitHub/CNB PR、Issue #1027 Steps 条目关联及 CodeBuddy Review。
