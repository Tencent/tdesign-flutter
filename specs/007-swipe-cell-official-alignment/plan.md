# TSwipeCell 官方对齐修复 - 技术方案

## 核心结构

组件不再包装 `flutter_slidable`，内部使用 `Stack + Transform.translate` 实现水平像素拖拽：

- `child` 是唯一参与 Stack 尺寸计算的非定位子节点；
- `start` / `end` 面板使用 `PositionedDirectional` 放在逻辑侧；
- 内容和对应面板随同一像素偏移移动，关闭时面板位于裁剪区外；
- 通过面板 `RenderBox.size.width` 得到真实展开距离，不进行文字预估或比例换算；
- `TextDirection.rtl` 下反转逻辑 start/end 的偏移符号。

## 交互契约

- 拖拽释放阈值固定为实测面板宽度的 30%。
- 所有开合统一使用 `600ms + Cubic(0.18, 0.89, 0.32, 1)`。
- 点击内容、单元格外部或操作项后自动关闭。
- 展开当前单元格前自动关闭其他已展开单元格。
- `closeOnScroll=true` 时监听最近 `Scrollable` 的滚动状态并关闭。
- 直接保存并换绑 `ScrollPosition`，避免祖先重建后监听旧位置。
- `enabled=false` 只禁用手势；控制器仍可操作。
- 指针取消时恢复拖拽开始前的稳定开合状态。
- 关闭动画期间屏蔽 action 重复点击与 child 事件穿透。
- 自动互斥按当前 `ModalRoute` 隔离，不影响其他路由。

## API 收敛

- `TSwipeCell` 保留 `child`、`enabled`、`start`、`end`、`onOpenChanged`、`controller`、`initialOpenSide`、`closeOnScroll`。
- 新增自有 `TSwipeCellController.open(side)` / `close()`；一个控制器只能绑定一个单元格。
- `TSwipeCellPanel` 只保留 `children`。
- `TSwipeCellAction` 保留视觉参数、`onPressed` 与 `builder`；标准内容固定水平排列，点击后自动关闭。
- `TSwipeCellThemeData` 只保留操作项视觉默认值，动画不允许局部覆盖。
- 删除 `flutter_slidable` 依赖、re-export 和所有第三方类型暴露。

## 自适应布局

标准操作项直接按以下真实 Widget 树布局：

```text
horizontal padding + icon + spacing + label + horizontal padding
```

不使用 `TextPainter` 预估，不使用 `Flexible` 均分，也不要求自定义 `builder` 提供 `extent`。文字缩放、主题字号以及 builder 自身约束变化后，下一帧重新读取面板实际宽度。

已展开时若面板宽度或 `TextDirection` 变化，当前像素偏移同步校正到新目标；当前展开侧被删除时立即恢复关闭态。

Action 样式依次解析实例参数、`TSwipeCellThemeData`、显式 Flutter 子树/Material 主题和 TDesign Token，避免 Token 提前遮蔽 `DefaultTextStyle`、`TextTheme` 或 `IconTheme`。

## 兼容性与风险

本次主动接受 breaking change，不保留旧 API 兼容分支。主要迁移项：

- `SlidableController` 改为 `TSwipeCellController`；
- 删除纵向滑动、分组、阈值、motion、dismiss、confirm 和手动关闭开关；
- 自定义 action 删除 `extent`，改由 builder 自身布局决定宽度；
- 动画、30% 阈值、互斥与点击关闭成为固定官方行为。

实现需同时通过 Flutter 3.32.0 与 latest，并保持 `flutter analyze` 零告警。

## 验证策略

- Widget 测试覆盖真实宽度、长文案、文字缩放、builder、RTL 和窄容器。
- 交互测试覆盖 30% 阈值、展开态回拖、点击关闭、自动互斥、滚动关闭、禁用态和状态回调。
- 生命周期测试覆盖动态宽度、面板移除、RTL 切换、PointerCancel、关闭动画点击、ScrollPosition 换绑和路由隔离。
- 控制器测试覆盖未绑定、换绑和重复绑定保护。
- 组件源码行覆盖率要求 `LH/LF >= 95%`。
- Web Demo 运行后人工检查手感与操作文字显示。
