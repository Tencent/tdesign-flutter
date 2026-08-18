# TSwipeCell 官方对齐修复 - 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-82/fix/swipe-cell-official-alignment`
- 本地 SDK：Flutter 3.32.0 stable / Dart 3.8.0
- Flutter latest：由 CI 双版本任务验证

## 已确认行为

- [x] 面板宽度来自 RenderBox 真实布局，长文字、文字缩放和自定义 builder 不需手工宽度。
- [x] 拖拽释放阈值为面板宽度 30%。
- [x] 开合统一为 600ms 与 `Cubic(0.18, 0.89, 0.32, 1)`。
- [x] 点击内容、外部和 action 自动关闭。
- [x] 展开一格自动关闭其他格。
- [x] 逻辑 start/end 支持 RTL。
- [x] `closeOnScroll`、`enabled`、`initialOpenSide` 与状态回调保留。
- [x] 第三方类型与非核心历史 API 已删除。
- [x] 展开后动态宽度、面板移除与 RTL 切换会同步校正稳定状态。
- [x] PointerCancel 不会留下半展开状态。
- [x] 关闭动画期间 action 不会重复执行，child 不会收到穿透点击。
- [x] ScrollPosition 换绑后滚动关闭仍生效。
- [x] 不同 ModalRoute 中的 SwipeCell 不互相关闭。
- [x] Action 默认文字和图标支持 Flutter 原生主题继承。

## 自动化结果

| 检查 | 结果 |
| --- | --- |
| `flutter analyze --no-pub` | 通过，0 error / warning / info |
| SwipeCell + Theme 聚焦测试 | 55/55 通过 |
| SwipeCell 手写源码行覆盖率 | 319/331，96.37% |
| `dart run tool/generate_example_code.dart --check` | 通过 |
| SwipeCell API 文档生成 | 通过，包含收敛后的 7 个公开类型 |
| `flutter run -d chrome` | 启动成功，已连接 Dart VM Service |

## 仍需人工确认

- [ ] 已启动的 Web Demo 中，中英文、图标加文字、多操作项的最终视觉。
- [ ] 快慢拖动、回拖、连续切换单元格的最终手感。
