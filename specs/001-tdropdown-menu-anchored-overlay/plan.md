# 实施方案

## 技术方案

- 使用独立的面板切换动画控制器，区分菜单整体打开/关闭和同菜单项切换。
- 为活动面板维护独立 key 和 activation epoch，避免快速切换时复用错误的面板状态。
- 通过 ScrollNotificationObserver 加祖先 ScrollPosition 监听刷新 Overlay 位置。
- 以 Navigator 作为活动菜单作用域，打开新菜单时关闭同作用域的旧菜单。
- 在自动定位中记录面板实际高度，并使用 8 像素滞后区稳定上下方向选择。
- 通过 TapRegion、指针按下/抬起位置和遮罩范围区分关闭点击与反向区域滚动。
- 在 Overlay 构建时综合触发栏矩形、键盘 inset、安全区和 viewport 边界计算面板及遮罩范围。
- 将 reduced-motion、焦点、Escape、系统返回、Controller 替换和 dispose 纳入同一生命周期状态机。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | tdesign-component/lib/src/components/dropdown_menu/t_dropdown_menu.dart | 重构浮层定位、切换动画和生命周期 |
| 测试 | tdesign-component/test/components/dropdown_menu/t_dropdown_menu_test.dart | 覆盖交互、定位、动画和边界条件 |
| 示例 | 无 | PR 未修改示例页面 |
| 文档 | 本 Spec | 记录设计和验收契约 |

## API 变化

PR #974 未新增公共参数；保留现有 placement、controller、Overlay、关闭回调和自定义 panel/trigger builder 契约。

## 风险与取舍

- Overlay 状态机复杂度增加，但换取快速切换和异步关闭操作的确定性。
- 自动 placement 依赖实际布局测量，因此采用 post-frame 重新计算。
- 监听祖先滚动通知需要过滤来源，避免无关滚动刷新浮层。
- 同一 Navigator 的活动菜单表是静态作用域，dispose 和异常路径必须清理。

## 验证策略

- Widget 测试覆盖打开、关闭、切换、滚动、定位、焦点、返回键和动态更新。
- 运行 flutter test test/components/dropdown_menu/t_dropdown_menu_test.dart。
- 运行 flutter analyze 或仓库约定的组件分析命令。
- 对窄屏、键盘、安全区、root/nested Overlay 和 reduced-motion 做人工验收。
