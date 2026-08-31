# 验收记录

## 验证环境

- 分支：rss1102/fix/pr1033-visual-evidence
- develop 合并基线：fb26b8d5
- 实现状态：PR #1033 复核中
- Flutter：3.32.0 stable
- Dart：3.8.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub --exclude-tags golden test/components/popover/t_popover_test.dart test/tool/run_visual_regression_test.dart` | 通过 | 55 tests passed，覆盖 Popover 行为、自动翻转、箭头补偿、锚点生命周期与视觉套件注册 |
| `flutter analyze lib/src/components/popover test/components/popover` | 通过 | No issues found |
| `flutter test test/popover_page_test.dart`（example） | 通过 | 4 tests passed，操作真实 Demo 覆盖事件、主题尺寸、窄屏、键盘和锚点销毁 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Demo 代码片段与源码同步 |
| `flutter analyze lib/page/t_popover_page.dart test/popover_page_test.dart`（example） | 通过 | No issues found |
| `flutter build web`（example） | 通过 | 实际 Example Web 发布入口编译成功 |
| `node scripts/check-flutter-component-contracts.mjs` | 通过 | 56 site routes have source, Example, and docs entries |
| `git diff --check` | 通过 | 无空白错误 |
| `flutter test test/popover_demo_test.dart` | 通过 | 公开 Demo 结构与 21 个触发按钮精确校验 |
| `flutter test --no-pub --update-goldens test/popover_demo_golden_test.dart --name ' light '` (Flutter 3.32.0 Linux) | 通过 | 1 张明亮整页 + 21 张明亮展开态，22 tests passed |
| `flutter test --no-pub --update-goldens test/popover_demo_golden_test.dart --name ' dark '` (Flutter 3.32.0 Linux) | 通过 | 1 张暗色整页 + 21 张暗色展开态，22 tests passed |
| 同一 Golden 命令移除 `--update-goldens` 后复跑 | 通过 | light 22 tests、dark 22 tests 均与固定基线完全匹配 |
| LCOV 覆盖率（`lib/src/components/popover/`） | 通过 | LH=498, LF=516，96.51% |
| Flutter 3.47.0：组件测试 + 视觉注册测试 | 通过 | 55 tests passed；定向 analyze 无问题 |
| Flutter 3.47.0：Demo 结构 + 交互测试 | 通过 | 清理 Example 的跨 SDK shader 缓存后 7 tests passed；定向 analyze 无问题 |
| 微信开发者工具：21 个公开展开态 | 通过 | RC 2.02.2607161、iPhone 12/13 (Pro)、390×844、DPR 3；21 张截图逐项检查 |

## 已验证行为

- [x] onTap 与 onLongTap 分别触发并收到 content
- [x] 无回调时外部点击关闭和底层滚动不受手势层阻断
- [x] 主题 backgroundColor 覆盖默认语义背景色
- [x] maxHeight 不再把短文本气泡撑到固定高度
- [x] minWidth、maxWidth 和默认 300 宽度上限继续有效
- [x] 右下角锚点的文本内容保持在 viewport 内
- [x] top 空间不足时翻转到 bottom，left 空间不足时翻转到 right
- [x] 两侧空间都不足时 clamp，箭头位移限制在圆角安全区内
- [x] light/dark 整页 Golden 已随 21 个 large 触发按钮同步更新
- [x] Popup 关联主题和 Overlay 测试无回归
- [x] Demo 中事件和自定义内容可交互，结果状态可观察
- [x] Demo 中主题尺寸、窄屏边界和键盘可用区域可验证
- [x] Demo 中移除锚点后 Overlay 消失且 Future 完成状态可观察
- [x] 公开页默认仅展示小程序的“组件类型 / 组件样式”矩阵，内部诊断场景由 Widget 测试显式开启。
- [x] 21 个公开按钮均使用与小程序 `size="large"` 对应的大尺寸；左右侧六个按钮按 `446rpx` 对应为 223dp。
- [x] 自定义内容按小程序 48dp 菜单项和 1dp 无间距分隔线布局，146dp 外框内无溢出。
- [x] 21 个公开 Demo 均有 light/dark 展开态 Golden，并已逐张检查。
- [x] 已使用微信开发者工具在 390×844、DPR 3 下截取并逐张检查小程序 21 个实际展开态，与 Flutter 3.32.0 Linux 明暗展开态 Golden 比对。

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
