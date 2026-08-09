# 实施任务

- [x] 明确回调、主题、尺寸、定位和生命周期行为边界
- [x] 绑定 onTap、onLongTap，并限制手势命中区域
- [x] 落实 TPopoverThemeData.backgroundColor
- [x] 修复 minWidth、maxWidth、maxHeight 的文本尺寸语义
- [x] 增加安全区、键盘和 viewport 边界约束
- [x] 避免锚点 unmounted 后在左上角继续绘制
- [x] 补充背景色、回调、maxHeight 和右下角定位测试
- [x] 运行 Popover、Golden、关联 Popup/主题测试
- [x] 运行静态分析、组件文档契约检查和 diff 检查
- [x] 将锚点销毁接入幂等 dismiss，主动清理 OverlayEntry、监听器并完成 Future
- [x] 增加事件、自定义内容、主题尺寸、窄屏、键盘和锚点销毁 Demo
- [x] 增加 Demo Widget 测试并同步生成代码片段
- [x] 增加 placement 同轴自动翻转与双侧不足时的箭头补偿
- [x] 补充自动翻转、viewport clamp 和圆角安全区回归测试
- [ ] 在目标设备完成窄屏、键盘、四边 placement 和 contentWidget 交互人工验收
- [ ] 完成最终 Review 后关闭 Spec
