# Popup 公开 Demo 对齐 - 验收记录

## 自动化验证

- Flutter 3.32.0 / latest 3.47.0 严格 analyze：均为 0 error / 0 warning。
- Popup 完整组件回归在本轮 Flutter 3.32.0 复跑 169 项通过；当前覆盖率调度器口径下生产源码 `519/532 = 97.56%`。
- Popup Demo 功能测试：两个版本各 4 项通过。
- Flutter 3.32.0 Linux 明暗主题 Golden：更新后立即无更新参数复跑，2 项通过；固定 375dp、DPR 1、受控 Roboto/CJK/TIcons 字体，未保留缺字符号。
- 示例代码生成 check、回归调度器自测与 `git diff --check` 通过。

## 人工证据

- 小程序基线：`tdesign-miniprogram develop@b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`。
- Flutter 基线：PR #1037 head `b5415f7244f468d19a4bd29f04e5c4412f189486` 与 `develop@1c5ac0cc33bba821f2d831afe417e44de69fe7e8` 的集成结果。
- 已使用微信开发者工具截取 Popup 实际小程序页，与 Flutter 3.32.0 Linux 明暗整页 Golden 比对；分组、五个基础实例和两个应用实例的顺序一致。
- 视口、字体和平台组件布局存在原生差异，不将本次人工截图比对外推为逐像素同值。

## 未决项

- 小程序源码中 Popup duration 属性默认 240ms，而样式/蒙层回退使用 300ms；本次不调整，待维护者确认权威默认值。

## 安全区默认行为调整

- Popup 作为基础浮层容器默认不主动避让系统安全区，`TPopupOptions` 及五个命名工厂的 `useSafeArea` 默认值调整为 `false`。
- 需要沿用旧行为的调用方迁移为显式传入 `useSafeArea: true`；只需要保护内容时可在 `child` 内组合 Flutter 原生 `SafeArea`。
- 该项改变公开默认行为，按 breaking change 记录。
- Flutter 3.32.0 完整 Popup 回归 169 项通过，生产源码覆盖率 `519/532 = 97.56%`；Flutter 3.47.0 默认/显式安全区聚焦回归 44 项通过，两个版本严格 analyze 均为 0 error / 0 warning。
- 已重新安装到 Android 16 真机 `25113PN0EC`，应用进程保持运行，默认 Popup 可直接检查贴边效果。
