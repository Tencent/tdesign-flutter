# 运行截图比对

基线：`tdesign-miniprogram@1.16.0`（`ae55fb050b7a9474c33752b45b71c741f37ed872`），统一使用 375dp 宽视口。Flutter 截图覆盖公开页面 light/dark；系统导航栏和字体栅格属于平台合理差异。

| 小程序公开页面 | Flutter light | Flutter dark |
| --- | --- | --- |
| ![小程序页面](evidence/miniprogram-page.png) | ![Flutter 浅色页面](evidence/flutter-page-light.png) | ![Flutter 深色页面](evidence/flutter-page-dark.png) |

人工核对结论：组件类型、组件状态及各入口顺序与小程序公开 Demo 一致；Flutter 额外能力保持独立分组，未为跨端 props/events 新增公共 API。方向展开、图标切换和禁用交互由双版本 Widget 测试验证，静态页面截图不替代打开态逐像素验收。
