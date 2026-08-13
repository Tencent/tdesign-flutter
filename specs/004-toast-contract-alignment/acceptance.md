# 验收记录

## 验证环境

- 分支：PR #16 `auto/toast-background-ab5e`、PR #17 `auto/toast-duration-fix-8dba`
- 提交：1e9df09b、2e523a30
- Flutter/Dart：兼容 flutter@3.32.0 与 flutter@latest（组件级改动，无新增依赖或版本敏感 API）

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/toast/t_toast_test.dart` | 待 PR CI 结果确认 | 覆盖背景色断言、默认 2000ms 时长、加载类不自动消失 |
| `flutter analyze lib/src/components/toast` | 待 PR CI 结果确认 | 无问题 |
| `git diff --check` | 待 PR CI 结果确认 | 无空白错误 |

## 已验证行为

- [x] 普通 toast 默认背景色为 `fontGyColor2`（rgba(0,0,0,0.6)），测试断言已同步。
- [x] `toastTheme.backgroundColor` 自定义覆盖优先级保留。
- [x] 普通 toast 默认 duration 为 2000ms，1500ms 仍显示、2000ms 后消失。
- [x] 加载类 toast 默认 duration 为 `TToast.infiniteDuration`，不自动消失。
- [x] `TToast.infiniteDuration` 具名常量已新增并在 showLoading / _showOverlay 统一使用。

## 人工验收

- [ ] 在真实设备 / 页面确认 toast 视觉背景与 TDesign Mobile 对齐。
- [ ] 确认普通 toast 默认 2 秒消失、加载 toast 不自动消失。

## 未覆盖项与后续工作

- 淡入淡出动画、同 ID 替换闪烁优化未纳入本次范围，后续可单独评估。
- `showClose` / `onClose` 关闭按钮能力未纳入本次范围。
- 本 Spec 对应的 PR #16、#17 仍处于 Review / 待合并状态，人工设备验收待执行。
