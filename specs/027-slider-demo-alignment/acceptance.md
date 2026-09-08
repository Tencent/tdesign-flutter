# 验收记录

- Flutter 基线：`d2ff7a0aa5317c0f5412848610f2a1ae05b6dfa7`
- 小程序基线：`fe14543572bc7233226b2f08db6fc1424cd81ed2`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/slider/slider.html`
- 设计基线：Figma `mdBVCCVGERhxoZLle2eLT0`，节点 `24386:5254`；走查标注要求 Gy4 未激活轨道、Gy1 thumb 描边、数值与 thumb 对齐，垂直示例从顶部 0 向下递增。
- API Review：单/双值类型、受控值和禁用入口保持收敛；不新增垂直或胶囊 API。修复 `showThumbValue` 静态展示、显式 `ColorScheme` 优先级、默认 thumb、禁用轨道及禁用数值视觉。

## 验证结果

- Flutter 3.32.0 / 3.47.0：严格 `flutter analyze` 零告警；组件与清单测试各 25 项、Demo 测试各 5 项通过。
- 生产源码覆盖率：`209/209 = 100.00%`。
- 固定 Linux + Flutter 3.32.0：组件 Golden 1 项、Demo 明暗 Golden 2 项通过；更新后均立即无更新复跑。
- 示例代码生成检查通过；GitHub/CNB 共用的组件、Demo 与视觉测试清单自测通过。

## 未验证项

- Android/iOS 系统字体逐像素差异不由 Linux Golden 证明。
