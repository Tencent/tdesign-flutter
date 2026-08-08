# TDropdownMenu：稳定锚定浮层与菜单切换动画

## 元信息

- 来源：[PR #974](https://github.com/Tencent/tdesign-flutter/pull/974)
- 合入提交：542d1b4c9da7e201ee9a2af35e71f67b4e79983a
- 记录基线：develop
- 影响组件：TDropdownMenu

## 背景

下拉菜单的触发栏、面板和遮罩需要在滚动、嵌套 Navigator、面板切换和动态内容高度变化时保持同一锚点关系。原实现的切换和自动定位状态较简单，容易出现面板跳变、方向抖动、旧面板关闭回调误触发、浮层脱离触发栏或关闭 Future 未完成等问题。

## 目标

- 稳定维护触发栏、面板和遮罩之间的锚定关系。
- 切换菜单项时保持一个连续、可预测的面板表面。
- 支持 above、below 和 auto placement，并在内容高度或可用空间变化时重新计算。
- 正确处理滚动、键盘、安全区、根/嵌套 Overlay、焦点、返回键和 dispose。
- 在系统关闭动画时保持可访问的交互行为。

## 非目标

- 不新增独立的业务筛选状态管理。
- 不改变 TDropdownMenuItem、TDropdownMenuController 的既有公共使用方式。
- 不改变组件主题字段的语义。

## 范围

### 涉及

- tdesign-component/lib/src/components/dropdown_menu/t_dropdown_menu.dart
- tdesign-component/test/components/dropdown_menu/t_dropdown_menu_test.dart
- 面板切换动画、Overlay 生命周期、自动定位、滚动监听、焦点和指针事件。

### 不涉及

- 其他组件的浮层实现。
- 站点组件 README 的手工修改。

## 行为契约

### 锚定与 Overlay

- 菜单打开后，触发栏、面板和遮罩随同一祖先滚动容器移动。
- 支持嵌套 Overlay 和 root Overlay。
- 触发栏离开视口后，浮层应移除或关闭，不遗留脱离锚点的面板。
- 同一 Navigator 下同时只保留一个活动菜单。

### Placement

- below 始终从触发栏下方展开，above 始终从上方展开。
- auto 根据面板实际高度、键盘和安全区后的上下可用空间选择方向。
- 自动方向在临界空间附近使用滞后策略，避免滚动或重建造成来回抖动。
- 面板高度或活动面板内容变化后，自动方向可以重新测量。
- 触发项箭头方向必须与最终展开方向一致。

### 切换与关闭

- 同一菜单切换项时，旧面板和新面板之间保持连续切换，不出现空白闪烁。
- 快速连续切换最终只保留最后一个活动面板。
- 被中断的打开、切换和关闭操作，其返回的 Future 都必须完成。
- 切换过程中不应错误触发旧索引的关闭回调。
- 非 dismissible 遮罩下，点击或拖动允许交互的一侧不应意外关闭菜单。

### 交互与生命周期

- 外部点击、Escape 和系统返回关闭菜单，但不弹出当前页面。
- 触发项和面板焦点、语义状态在打开/关闭后正确更新和恢复。
- 动态移除或禁用当前打开项时，菜单安全关闭。
- 外部 Controller 被替换后，旧 Overlay 被清理，新 Controller 继续可用。
- dispose 时移除 Overlay、监听器和动画资源，不触发错误回调。
- MediaQuery.disableAnimations 为真时，动画时长为零。
