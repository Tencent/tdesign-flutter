# 验收记录

## 验证环境

- 分支：cnb-issue-130（本地 develop）
- 提交：待 PR 后填写
- Flutter/Dart：3.32.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze`（本地，icons 包缺失环境） | 目标文件 0 error / 0 warning | TIcons 报错为环境缺 `tdesign_flutter_icons` 包导致，全库 443 处同类报错，非本次改动引入 |
| 单元测试（TTitle.level 映射、TParagraph 默认字号） | 已编写待 CI 验证 | `t_typography_test.dart` |
| Widget 测试（copyable 复制回调、expandable 展开收起） | 已编写待 CI 验证 | `t_typography_test.dart` |

## 人工验收

- [ ] 示例页「可复制 / 文本省略（展开收起）/ 组件类型（标题、段落）」分组视觉与交互正确
- [ ] `TTitle` h1~h6 字号映射符合 TDesign token

## 未覆盖项与后续工作

- `start` / `middle` 省略自定义绘制：本轮只做 `end`，后续单独评估。
- `ul` / `ol` 列表、`secondary` theme：候选能力，本轮不实现。
