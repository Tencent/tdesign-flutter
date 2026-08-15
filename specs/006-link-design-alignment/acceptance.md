# 验收记录

## 验证环境

- 分支：待补充（CNB 平台 PR 分支）
- 提交：待补充
- Flutter/Dart：3.32.0 与 latest 双版本（CI 兜底）

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze` | 待 CI | 目标 0 error / 0 warning |
| `flutter test test/components/link/t_link_test.dart` | 待 CI | T05 断言 TIcons.link findsNothing |
| `dart run tool/generate_example_code.dart --check` | 待 CI | 示例快照一致性 |

## 人工验收

- [ ] 对照 h5 <https://tdesign.tencent.com/mobile-vue/mobile.html#/link> 逐项比对示例结构与文案。
- [ ] 确认「后置图标」示例仅展示后缀跳转图标，无默认前置链接图标。
- [ ] 确认页脚单个链接页脚展示不变（显式 prefixIcon 补齐）。

## 未覆盖项与后续工作

- 无。
