# Popup 公开 Demo 对齐 - 验收记录

## 自动化验证

- Flutter 3.32.0 / latest 3.47.0 严格 analyze：均为 0 error / 0 warning。
- Popup 组件回归：两个版本各 194 项通过；生产源码覆盖率 `607/624 = 97.28%`。
- Popup Demo 功能测试：两个版本各 4 项通过。
- Flutter 3.32.0 Linux 明暗主题 Golden：更新后立即无更新参数复跑，2 项通过；固定 375dp、DPR 1、受控 Roboto/CJK/TIcons 字体，未保留缺字符号。
- 示例代码生成 check、回归调度器自测与 `git diff --check` 通过。

## 人工证据

- 小程序基线：`tdesign-miniprogram develop@b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`。
- Flutter 基线：PR #1037 head `b5415f7244f468d19a4bd29f04e5c4412f189486` 与 `develop@1c5ac0cc33bba821f2d831afe417e44de69fe7e8` 的集成结果。
- 已完成小程序官方 M2W 页面与 Flutter Web 的结构和交互截图比对；因内容视口不同，不作为像素级验收结论。

## 未决项

- 小程序源码中 Popup duration 属性默认 240ms，而样式/蒙层回退使用 300ms；本次不调整，待维护者确认权威默认值。
