# 实施计划

1. 基于原 PR #1061 的分支追加 DateTimePicker 改动，保持单组件评审范围。
2. 以 Figma 页面与打开态对齐 Demo；参考小程序 API/default，保持 Flutter 平铺受控与用户组合 Popup 的边界。
3. 同步本组件的源码、Demo、dartdoc、Spec、行为测试、代码片段和 Golden。
4. 在各自分支验证 analyze、组件和 Demo 行为；使用 Flutter 3.32.0 Linux 生成并无更新参数复跑权威 Golden。
5. 推送原 PR，并单独在 CNB 使用组件 Review skill 审查。

## API 收敛实现

修复 didUpdateWidget 在 value 未变化时提前返回的问题，按当前模式和约束归一化比较；拒绝后重置 wheel 和通知去重状态，接受新值保留惯性滚动。共享字体实现复用 tExplicitTextTheme 和 fontBodyLarge。

## 月日模式接受值的惯性修复

统一比较 _createSnapshot().current 与 _snapshot.current，不再按 value 是否变化分别比较原始值和可见列。完整日期保留隐藏计算年：同年接受当前滚轮结果保持 controller，拒绝或实际计算年变化重建。无公开 API 变化。
