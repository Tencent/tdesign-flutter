# 验收记录

- Flutter 基线：`ccace5c61383dc2c4fd5392f41222e65b54d8010`
- 小程序基线：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/slider/slider.html`
- API Review：单/双值类型、受控值、禁用和主题组合已收敛，生产源码无需修改。

## 验证结果

- Flutter 3.32.0 / 3.47.0：组件测试 18 项、Demo 测试 4 项通过，严格
  `flutter analyze` 零告警。
- 生产源码覆盖率：`108/108 = 100.00%`。
- 固定 Linux + Flutter 3.32.0 明暗 Golden 各 1 张，更新后立即无更新复跑通过。
- GitHub/CNB Demo 列表一致，回归/覆盖率/视觉矩阵工具自测通过。

## 未验证项

- Android/iOS 系统字体逐像素差异不由 Linux Golden 证明。
