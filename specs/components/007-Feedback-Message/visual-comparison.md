# 视觉依据与验收范围

以下保留原候选的设计依据、环境及结论，运行截图已清理。后续视觉回归引用 [Golden 测试](../../../tdesign-component/example/test/message/message_demo_golden_test.dart)及[基线目录](../../../tdesign-component/example/test/message/goldens/)；已有基线不表示当前候选已执行或覆盖全部场景。

- 小程序基线：`tdesign-miniprogram@1.16.0`，提交 `ae55fb050b7a9474c33752b45b71c741f37ed872`。
- 小程序截图：微信开发者工具 RC 2.02.2607161，iOS 模拟视口。
- Flutter 截图：Flutter 3.32.0 Linux，375dp、DPR 1、受控 CJK / Roboto / TIcons 字体。

结论：公开页仅保留“组件类型”和“组件状态”，六个类型触发项与四个状态触发项顺序一致。“关闭所有通知”不是小程序公开矩阵，已从 Flutter 公开页移除，未新增公开 API。带关闭通知的截图在点击入口、Overlay 实际展示后采集，覆盖图标、文案、按钮和关闭图标间距。

## 2026-09-15 Issue #1027 标记差异

完整修改前、修改后与独立像素差异图保存在 GitHub PR #1127 描述的附件中，不作为 Spec 二进制文件提交。

- **组件差异**：消息条从安全可视区域全宽改为左右各保留 16px 外边距。
- **Demo 差异**：“带关闭的通知”移除右侧多余的操作按钮，只保留关闭图标。
- 代表性 `message_closeable_opened_light` Golden：3,366px（1.11%）发生变化；差异图中的边界变化与按钮区域分别对应上述两项。
