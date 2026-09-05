# 实施计划

## API 与状态所有权

- 将命令式 Drawer 的 placement / overlay 布尔值改为非空默认，并新增蒙层点击通知与销毁策略。
- 将 Widget 的边框、末行边框和按压反馈固定为实例状态；从 Theme 删除重复开关和页面顶部偏移。
- 保留宽度、颜色、文字、间距、分隔线等具体视觉字段在 Theme 中。

## 生产实现

- 复用 Popup 的左右放置、OverlayConfig、生命周期和句柄，不增加私有浮层系统。
- 按官方 Token 和尺寸修正标题、菜单正文、图标、分隔线与底部布局。
- 保持声明式 DrawerWidget 可用于 Scaffold，命令式 TDrawer 用于示例和临时浮层。

## Demo 与证据

- 公开页优先对齐新 Figma 的 375 × 1024 布局，修正文案映射和过长列表噪声。
- 使用 8 项菜单构建基础、图标、大小标题、左右和底部 7 个入口；底部场景使用 13 项验证滚动与固定操作区。
- 对固定视口整页与 7 个打开态生成 light/dark Linux Golden，补充真实交互测试。

## 验证

- Flutter 3.32.0：组件覆盖率、Demo、回归工具、API/代码生成、全量 analyze、Web build。
- Flutter latest：组件与 Demo 非视觉测试、全量 analyze。
- Flutter 3.32.0 Linux：更新 Golden 后移除更新参数精确复跑并逐张检查。
