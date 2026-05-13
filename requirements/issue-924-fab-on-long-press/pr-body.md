## Summary

- `TFab` 新增 `onLongPress` 回调，对外暴露长按事件（向后兼容，不影响原有 `onClick`）。
- `example` 的 FAB 页面补充长按示例，便于验收与回归。

## Root Cause

- `TFab` 内部 `InkWell` 仅绑定 `onTap`，组件 API 未提供长按回调参数，导致业务侧无法接入长按交互。

## Fix Plan

- 在 `TFab` 上新增 `VoidCallback? onLongPress` 参数并透传到 `InkWell.onLongPress`。
- 补充示例页面用法，方便开发者验证与参考。

## Test Plan

- `dart analyze tdesign-component/lib/src/components/fab/t_fab.dart`
- 运行 `tdesign-component/example`，进入 `TFabPage`，长按 “LongPress 长按事件” 示例 FAB，观察控制台输出 `TFab onLongPress`。

### 🔗 相关 Issue

https://github.com/Tencent/tdesign-flutter/issues/924

### 🤔 这个 PR 的性质是？

- [ ] 日常 bug 修复
- [x] 新特性提交
- [ ] 文档改进
- [x] 演示代码改进
- [ ] 组件样式/交互改进
- [ ] CI/CD 改进
- [ ] 重构
- [ ] 代码风格优化
- [ ] 测试用例
- [ ] 分支合并
- [ ] 其他

### 📝 更新日志

- feat(TFab): expose `onLongPress` callback

- [x] 本条 PR 不需要纳入 Changelog

### ☑️ 请求合并前的自查清单

- [x] pr目标分支为develop分支，请勿直接往main分支合并
- [x] 标题格式为：`组件类名`: 修改描述（示例：`TBottomTabBar`: 修复iconText模式，底部溢出2.5像素）
- [x] ”相关issue“处带上修复的issue链接
- [x] 相关文档已补充或无须补充
