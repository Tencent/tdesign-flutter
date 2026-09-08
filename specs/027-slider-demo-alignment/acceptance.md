# 验收记录

- Flutter 基线：`ccace5c61383dc2c4fd5392f41222e65b54d8010`
- 小程序基线：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/slider/slider.html`
- API Review：单/双值类型、受控值和禁用入口保持收敛；不新增垂直或胶囊 API。修复 `showThumbValue` 静态展示、显式 `ColorScheme` 优先级、默认 thumb、禁用轨道及禁用数值视觉。

## 验证结果

- Flutter 3.32.0 / 3.47.0：严格 `flutter analyze` 零告警；组件与清单测试各 25 项、Demo 测试各 5 项通过。
- 生产源码覆盖率：`209/209 = 100.00%`。
- 固定 Linux + Flutter 3.32.0：组件 Golden 1 项、Demo 明暗 Golden 2 项通过；更新后均立即无更新复跑。
- 示例代码生成检查通过；GitHub/CNB 共用的组件、Demo 与视觉测试清单自测通过。

## 未验证项

- Android/iOS 系统字体逐像素差异不由 Linux Golden 证明。
