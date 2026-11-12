# 视觉依据与验收范围

以下保留原候选的设计依据、环境及结论，运行截图已清理。后续视觉回归引用 [Golden 测试](../../../tdesign-component/example/test/loading/loading_demo_golden_test.dart)及[基线目录](../../../tdesign-component/example/test/loading/goldens/)；已有基线不表示当前候选已执行或覆盖全部场景。

## 2026-09-15 Issue #1027 差异标记

完整修改前、修改后与独立像素差异图保存在 GitHub PR #1126 描述的附件中，不作为 Spec 二进制文件提交。

浅色差异共 704px（0.17%），只落在纯图标、横向图文、竖向图文的 3 个 activity 指示器。circle、point、custom、文字、间距、尺寸和速度区域均未变化。该结果来自组件默认 Token 修复，Demo 没有注入黑色样式。

- 小程序基线：`tdesign-miniprogram@1.16.0`，提交 `ae55fb050b7a9474c33752b45b71c741f37ed872`。
- 小程序截图：微信开发者工具 RC 2.02.2607161，iOS 模拟视口。
- Flutter 截图：Flutter 3.32.0 Linux，375dp、DPR 1、受控 CJK / Roboto / TIcons 字体。

结论：公开页的三个分组、左对齐布局、纯图标四种指示器、横竖文字、三档尺寸与速度调整顺序一致；custom 指示器使用小程序 Demo 同一张 `logo2.png` 本地资产，速度滑块常驻显示 800 且交互后更新。Flutter 保留框架原生布局与字体差异，本轮未新增公开 API。
