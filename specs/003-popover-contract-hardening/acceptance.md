# 验收记录

## 验证环境

- 分支：develop
- 基线提交：541f76435e0a492f9f392fe98f72e72167b24516
- 实现状态：工作区未提交
- Flutter：3.32.0 stable
- Dart：3.8.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/popover/t_popover_test.dart test/components/popover/t_popover_golden_test.dart test/components/popup/t_popup_widget_test.dart test/components/popup/t_feedback_theme_data_test.dart test/components/popup/t_popup_theme_test.dart` | 通过 | 68 tests passed，覆盖 Popover、Golden、自动翻转、箭头补偿、锚点生命周期与关联 Popup/主题路径 |
| `flutter analyze lib/src/components/popover test/components/popover` | 通过 | No issues found |
| `flutter test test/popover_page_test.dart`（example） | 通过 | 4 tests passed，操作真实 Demo 覆盖事件、主题尺寸、窄屏、键盘和锚点销毁 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Demo 代码片段与源码同步 |
| `flutter analyze lib/page/t_popover_page.dart test/popover_page_test.dart`（example） | 通过 | No issues found |
| `flutter build web`（example） | 通过 | 实际 Example Web 发布入口编译成功 |
| `node scripts/check-flutter-component-contracts.mjs` | 通过 | 56 site routes have source, Example, and docs entries |
| `git diff --check` | 通过 | 无空白错误 |

## 已验证行为

- [x] onTap 与 onLongTap 分别触发并收到 content
- [x] 无回调时外部点击关闭和底层滚动不受手势层阻断
- [x] 主题 backgroundColor 覆盖默认语义背景色
- [x] maxHeight 不再把短文本气泡撑到固定高度
- [x] minWidth、maxWidth 和默认 300 宽度上限继续有效
- [x] 右下角锚点的文本内容保持在 viewport 内
- [x] top 空间不足时翻转到 bottom，left 空间不足时翻转到 right
- [x] 两侧空间都不足时 clamp，箭头位移限制在圆角安全区内
- [x] light/dark Golden 未变化
- [x] Popup 关联主题和 Overlay 测试无回归
- [x] Demo 中事件和自定义内容可交互，结果状态可观察
- [x] Demo 中主题尺寸、窄屏边界和键盘可用区域可验证
- [x] Demo 中移除锚点后 Overlay 消失且 Future 完成状态可观察

## 人工验收

- [ ] 窄屏下十二种 placement 的内容和箭头均可接受
- [ ] 刘海屏、圆角屏和底部安全区内不裁切
- [ ] 键盘弹出后底部 Popover 不被遮挡
- [x] Widget 测试确认 contentWidget 内部菜单项可点击并更新状态
- [x] Widget 测试确认列表锚点移除时 Popover 自动关闭且 Future 完成
- [ ] 目标设备页面跳转时 Popover 自动关闭且无视觉残留

## 未覆盖项与后续工作

- 锚点 Element unmounted 后会通过私有生命周期守卫复用幂等 dismiss，自动移除 OverlayEntry、清理监听器并完成 showPopover Future；已由 Widget 测试覆盖。
- placement 仅做同轴反向翻转，不会在纵向和横向之间跨轴选择。
- 超长文本在 maxHeight 下的滚动、裁切或省略策略尚未形成公共契约，本次不扩展。
- 目标设备人工验收尚未执行，因此本 Spec 暂不标记为完全关闭。
