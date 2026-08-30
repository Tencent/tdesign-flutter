# 运行截图比对

基线：`tdesign-miniprogram@1.16.0`（`ae55fb050b7a9474c33752b45b71c741f37ed872`），统一使用 375dp 宽视口。Flutter 截图覆盖公开页面 light/dark；系统导航栏和字体栅格属于平台合理差异。

| 小程序公开页面 | Flutter light | Flutter dark |
| --- | --- | --- |
| ![小程序页面](evidence/miniprogram-page.png) | ![Flutter 浅色页面](evidence/flutter-page-light.png) | ![Flutter 深色页面](evidence/flutter-page-dark.png) |

人工核对结论：Flutter 公开页面已按小程序完整源码收敛为“组件类型 / 组件状态 / 可滚动公告栏”三个分组、8 个 Demo 块、14 个公告栏实例。逐项核对通过的内容包括：

- 页面标题、说明、分组标题、分组说明和公开顺序；
- 纯文字、默认语义图标、关闭、两种入口、自定义样式和自定义内容组合；
- 普通、成功、警示、错误四种状态的文案、语义图标和背景；
- 无图标水平滚动、带默认图标水平滚动、垂直滚动的实例顺序与初始帧；
- 375dp Flutter light/dark 整页截图无缺字、裁切或内部“单元测试”分组。

Flutter 使用现有组合与 Theme 表达这些效果，没有新增 interval、operation 等公共 API。系统导航栏、WebView 支持提示和字体栅格属于平台合理差异。静态截图仍不能证明 marquee 帧级平滑度和垂直触摸循环，这两项保留为未验证项。
