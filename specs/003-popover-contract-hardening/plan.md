# 实施方案

## 技术方案

- 在 TPopoverWidget 的实际气泡内容区域按需包装 GestureDetector，仅当 onTap 或 onLongTap 存在时创建手势识别器，避免覆盖整个 root Overlay。
- 保留 colorScheme 的文本色和语义背景 token 解析，再以 TPopoverThemeData.backgroundColor 覆盖最终背景色，使容器和箭头共用同一颜色来源。
- 将文本测量拆分为自然尺寸、显式尺寸和主题上下限：显式 width/height 保持固定；minWidth/maxWidth/maxHeight 只约束文本自然尺寸。
- TPopover.showPopover 不再把文本模式的 theme.minWidth/theme.maxHeight预先转成固定 width/height；contentWidget 模式保留现有确定尺寸兼容路径。
- 使用 MediaQuery.size、padding 和 viewInsets 计算可用 viewport；优先将空间不足的 placement 同轴翻转，两侧都不足时再把包含箭头的最终外框 clamp 到可用范围。
- 根据 clamp 后的气泡位置与锚点中心补偿箭头位移，并用圆角半径加箭头尺寸限制边缘安全区。
- 仅对有非零 RenderBox 的真实锚点执行 viewport clamp；无 RenderBox 的直接 Widget 用法保留原有定位兼容性。
- 在 build 阶段检测 unmounted 锚点并停止绘制，同时由 t_popover.dart 内部的私有生命周期守卫在 frame 结束后检查锚点状态；锚点失效时接入 TPopover.showPopover 的幂等 dismiss 路径，确保 OverlayEntry、监听器和 Future 一并清理。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件入口 | tdesign-component/lib/src/components/popover/t_popover.dart | 区分文本与 contentWidget 的主题尺寸传递 |
| 组件布局 | tdesign-component/lib/src/components/popover/t_popover_widget.dart | 事件、主题、尺寸、viewport 和锚点状态 |
| 组件主题 | tdesign-component/lib/src/components/popover/t_popover_theme_data.dart | 不改签名，落实 backgroundColor/maxHeight 既有语义 |
| 测试 | tdesign-component/test/components/popover/ | 增加公共 API 和边界回归，保留 Golden |
| 关联测试 | tdesign-component/test/components/popup/ | 验证 Overlay 和 Theme 没有回归 |
| 示例 | tdesign-component/example/lib/page/t_popover_page.dart | 增加真实可操作的事件、主题尺寸、边界、键盘和生命周期场景 |
| 示例测试与代码片段 | tdesign-component/example/test/popover_page_test.dart、example/assets/code/popover.*.txt | 自动验证 Demo 行为并同步代码查看器 |
| 文档 | 本 Spec、生成 API 文档 | 当前签名未变化，无需手工改生成文档 |

## API 变化

- 不新增、不删除公共参数或类型。
- 修复既有 onTap、onLongTap、backgroundColor、minWidth、maxWidth、maxHeight 的运行时语义。
- 回调不会自动关闭 Popover，避免引入未声明的行为变化。

## 风险与取舍

- 自动翻转只发生在同轴反方向能够完整容纳气泡时；两侧都不足时保留调用方请求方向并优先保证内容可见。
- backgroundColor 覆盖语义背景 token 后，调用方需要自行保证与语义文本色的对比度；本次没有新增 textColor API。
- maxHeight 对超长文本只限制外框高度，若未来需要滚动或省略策略，应单独定义 overflow 契约。
- 生命周期守卫只在已有 frame 上执行检查，不主动制造持续动画帧；锚点销毁发生在布局 frame 内，随后通过同一 dismiss 路径完成回收。
- contentWidget 依赖确定尺寸是现有首帧定位限制，本次不扩大到动态测量，避免引入闪烁和二次定位。

## 验证策略

- Widget 测试覆盖回调、主题背景色、maxHeight、默认宽度、外部关闭、滚动、同轴翻转、clamp 和箭头补偿。
- Example Widget 测试操作真实 Demo，覆盖事件、自定义内容、主题尺寸、窄屏、键盘和锚点销毁。
- Golden 测试覆盖 light/dark Overlay 视觉基线。
- 关联 Popup 测试覆盖 Overlay、主题扩展和尺寸行为没有回归。
- 运行 flutter analyze lib/src/components/popover test/components/popover。
- 运行 scripts/check-flutter-component-contracts.mjs 和 git diff --check。
- 运行示例代码生成器及 `--check`，保证代码查看器与 Demo 源码同步。
- 人工验收窄屏、安全区、键盘、四边 placement、contentWidget 内部交互和页面跳转销毁锚点。
