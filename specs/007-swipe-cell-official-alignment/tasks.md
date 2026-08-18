# TSwipeCell 官方对齐修复 - 任务清单

## DOING

- [ ] 在已启动的 Web Demo 中完成人工滑动与视觉验收

## DONE

- [x] 更新 Spec 为无历史兼容的最小 API 契约
- [x] 移除 `flutter_slidable` 依赖与 re-export
- [x] 新增最小 `TSwipeCellController`
- [x] 改为内部像素拖拽和官方 600ms cubic 动画
- [x] 固定面板宽度 30% 打开阈值
- [x] 操作面板改为真实 Row 布局测量
- [x] 自定义 builder 删除 `extent` 要求
- [x] 删除 Panel 的 motion / threshold / dismiss / confirm API
- [x] 删除 Action 的 autoClose / direction / confirm / id API
- [x] 固定点击内容、外部和操作项关闭
- [x] 固定展开一格时关闭其他格
- [x] 示例移除空 Theme 包装和非核心场景
- [x] 站点说明同步最小 API
- [x] 生成并校验 API 文档与示例代码片段
- [x] SwipeCell 源码行覆盖率达到 96.37%（319/331）
- [x] Flutter 3.32.0 完整 analyze 零问题
- [x] 55 个聚焦与主题契约测试通过
- [x] Chrome Web Demo 启动并连接调试服务
- [x] 动态宽度、面板移除和 LTR/RTL 切换时校正展开偏移
- [x] PointerCancel 恢复拖拽前稳定状态
- [x] 关闭动画期间阻止 action 重复执行和 child 事件穿透
- [x] 滚动监听改为精确绑定 ScrollPosition
- [x] 自动互斥限定在当前 ModalRoute
- [x] Action 补齐 DefaultTextStyle / TextTheme / IconTheme 继承
