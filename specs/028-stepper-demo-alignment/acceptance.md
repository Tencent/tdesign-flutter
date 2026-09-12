# 验收记录

## 2026-09-09 本地修复

- PR 基线：[GitHub #1064](https://github.com/Tencent/tdesign-flutter/pull/1064)，head `5bdc6b41fc47b9115856013ca8b9ae4159431a50`，base `ccace5c61383dc2c4fd5392f41222e65b54d8010`。
- [Figma 展示目标](https://www.figma.com/design/mdBVCCVGERhxoZLle2eLT0?node-id=28591-40152)：376 × 960，删除中间 99 示例，禁用值为 0；示例使用完整宽度的容器底色、16px 内边距，基础与禁用左对齐。
- 小程序参考版本：`fe14543572bc7233226b2f08db6fc1424cd81ed2`。[公开运行页](https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/stepper/stepper.html) 仍有 99，本次按指定设计稿处理。
- 保留现有七个构造参数、枚举和默认值。修复草稿边界与 Theme 插值，不新增 Controller、disabled、integer 或 disableInput。

## 实际验证

| 检查 | Flutter 3.32.0 / macOS | Flutter 3.47.0 / macOS |
| --- | --- | --- |
| 组件回归 | 39 项通过 | 39 项通过 |
| 完整 Demo 回归 | 7 项通过 | 7 项通过 |
| 生成器及回归工具自测 | 18 项通过 | 18 项通过 |
| 严格 flutter analyze | 0 error / 0 warning | 0 error / 0 warning |

- 四个生产文件合计行覆盖率：`330/335 = 98.51%`，组件测试全部通过。
- 行为覆盖：两端边界草稿、父组件接受/拒绝、非法草稿、即时按钮边界更新；主题双向插值、端点、实例尺寸、继承主题、TD token、copyWith、嵌套插值及 AnimatedTheme。
- 实际打开五个代码面板，验证显示内容与生成资产一致；将五份生成资产原样写为独立 Dart 文件，在最小宿主编译并操作全部十个实例，1 项测试通过。
- iPhone 16 / iOS 18.2 模拟器运行当前提交：实际点击基础、边界、三种样式和三种尺寸实例；从 0 输入合法草稿后点击减号得到 4，从 999 输入 995 后点击加号得到 996；禁用实例保持 0 且两侧按钮不可用。明暗主题切换后已修改值保持。
- 手机验收发现开启顶部代码模式会把已操作值重置。根因是 `CodeWrapper` 在显示遮罩时临时插入 `Stack`，改变 StatefulWidget 父节点结构。修复为始终保留同一 `Stack` 子树；再次上机确认基础值 3 → 4 后，开启代码模式、打开并关闭代码面板、切换主题，值均保持 4。双 SDK Demo 回归覆盖同一路径。
- 示例生成器 `--check` 通过；Stepper API 文档从源码重新生成。
- 新增组件契约测试、生成器测试和四张视觉回归的 CI 入口登记；GitHub/CNB 工具入口同步。
- 合并 `origin/develop@335b30bc` 后，用最终合并提交重新构建 iOS 应用并复跑：基础 3 → 4、最小值 0 → 1、最大值 999 → 998，三种样式与三种尺寸均各自 3 → 4；打开和关闭代码面板、查看 API 文档、切换主题后上述值全部保留。

## Linux Golden

- 环境：已有缓存镜像 `tdesign-flutter-golden-cache:3.32.0`，Linux amd64、Flutter 3.32.0、Dart 3.8.0。离线依赖使用 Git `--no-hardlinks` 适配；未修改主工作区依赖或 lockfile。
- Demo 宽 375、DPR 1，预载中文与图标字体；完整页面高 854。先检查实际明暗图片，再更新两张 Demo 基线并精确复跑。
- 原组件基线在同一环境已有字体绘制差异：亮色 848 像素（1.82%）、暗色 835 像素（1.80%）。使用 PR head 生产源码复跑后，实际图片与修复后的图片逐字节相同，确认本次修复未改变静态视觉。
  - 亮色 SHA-256：`755a5ee4676911e93f45280d0edb3f052c3ee7cf56840df2d0775ec541dd0dd8`。
  - 暗色 SHA-256：`0bc5e0b70c02f557cac4f7e57b3f8280495b951ee0b1ff4bbd6e5077f0c00ee1`。
- 校正两张组件基线并纳入视觉回归入口。在 example 目录运行 `flutter test --no-pub test/stepper_demo_golden_test.dart ../test/components/stepper/t_stepper_golden_test.dart`，四项通过，精确 diff 为 0；未放宽比较器容差。

## 验证边界与交付

- 第二套本地 SDK 是 3.47.0。首次修复已推送到 `36620b81`；手机验收修复和最新 `develop` 合并已在本地完成，推送后须等待远端 actual latest 与新 head 的 CNB review，不能沿用旧 head 的结果。
- iOS 18.2 模拟器已验证实际点击、文本输入、明暗主题和代码面板；Android/iOS 真机 IME 与系统字体仍未验证，Linux Golden 不证明这些路径。
- 公开签名、枚举和默认值保持兼容，行为变化属于既有契约修复，无迁移要求。
