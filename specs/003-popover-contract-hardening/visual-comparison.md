# Popover 截图比对

- 小程序基线：`tdesign-miniprogram@1.16.0`，提交 `ae55fb050b7a9474c33752b45b71c741f37ed872`。
- 小程序截图：微信开发者工具 RC 2.02.2607161，iPhone 12/13 (Pro) 模拟视口。
- Flutter 截图：Flutter 3.32.0 Linux，375dp、DPR 1、受控 CJK / Roboto / TIcons 字体。

| 小程序实际页 | Flutter 明亮 | Flutter 暗色 |
| --- | --- | --- |
| ![Popover 小程序](evidence/miniprogram-page.png) | ![Popover Flutter 明亮](evidence/flutter-page-light.png) | ![Popover Flutter 暗色](evidence/flutter-page-dark.png) |

结论：公开页的三个类型实例、六种主题与十二种 placement 顺序一致。Flutter 专用的交互/边界诊断场景保留在 Example 页内部测试模式，不扩展 TPopover 公开 API。
