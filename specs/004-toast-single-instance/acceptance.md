# 验收记录

## 验证环境

- 分支：rss1102/cnb-issue-15/fix/toast-single-instance
- 提交：待补充
- Flutter/Dart：兼容 flutter@3.32.0 与 flutter@latest（组件级改动，无新增依赖或版本敏感 API）

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/toast/t_toast_test.dart` | 待 PR CI 结果确认 | 覆盖单实例替换行为、dismiss 关闭 |
| `flutter analyze lib/src/components/toast` | 待 PR CI 结果确认 | 无问题 |
| `git diff --check` | 待 PR CI 结果确认 | 无空白错误 |
| 全局 grep `toastId` / `dismissToast` | 待确认 | 应无残留 |

## 已验证行为

- [ ] 连续多次 showText，只保留最新 Toast
- [ ] 连续多次 showLoading，只保留最新 Toast
- [ ] `dismiss()` 关闭当前 Toast
- [ ] `dismissAll()` 兼容（等价于 dismiss）
- [ ] 仓库内无 `toastId` / `dismissToast` 引用
- [ ] 自动消失逻辑不受影响

## 人工验收

- [ ] 在真实设备 / 页面确认多次触发 toast 不再叠加、背景不再变深

## 未覆盖项与后续工作

- 淡入淡出动画等视觉体验优化不在本范围
- loading 与普通 toast 并存场景不在本范围
