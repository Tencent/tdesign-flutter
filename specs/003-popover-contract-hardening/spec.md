# TPopover：交互、主题、尺寸与浮层边界契约补强

## 元信息

- 初始记录基线：develop@541f76435e0a492f9f392fe98f72e72167b24516
- Demo 复核基线：develop@fb26b8d5
- 影响组件：TPopover、TPopoverWidget、TPopoverThemeData
- 状态：实现、Demo 与自动化验收完成，目标设备人工验收待执行

## 背景

TPopover 已公开点击、长按、主题背景色、最小/最大尺寸和十二种 placement，但原实现存在公开参数未执行、主题字段未消费、最大高度被当作固定高度以及边缘位置越出可用视口的问题。现有测试主要验证“能够渲染”，没有验证这些 API 的实际效果，因此测试全绿仍可能留下运行时契约缺口。

此外，Popover 使用 root Overlay 并持有触发节点的 BuildContext。触发节点在浮层展示期间销毁时，组件不能继续使用失效坐标，也不能永久保留 OverlayEntry、滚动监听或未完成的 Future。

## 目标

- 使 onTap、onLongTap 与公开文档一致，点击气泡内容时各自准确触发。
- 使 TPopoverThemeData.backgroundColor 真正控制气泡和箭头背景色。
- 明确 width、height、minWidth、maxWidth、maxHeight 的尺寸语义。
- 在有效锚点场景中约束 Popover 到安全区、键盘和 viewport 可用范围内。
- placement 指定方向空间不足而反方向充足时，自动翻转到同轴对应方向。
- 两侧空间都不足时才平移到 viewport 内，并补偿箭头使其继续指向锚点。
- 保持外部点击关闭、滚动关闭和底层滚动的既有行为。
- 触发节点销毁后隐藏并最终回收 Overlay，完成 showPopover 返回的 Future。
- 用聚焦 Widget/Golden 测试覆盖上述公共行为。
- 用可操作 Demo 覆盖事件、主题尺寸、窄屏边界、键盘和锚点销毁场景。
- 公开 Demo 默认仅展示小程序公开页的“组件类型 / 组件样式”矩阵；交互与边界场景仅在内部测试模式展示。
- 公开 Demo 的 21 个触发按钮使用与小程序 `size="large"` 一致的 48dp 大尺寸。
- 每个公开 Demo 分别保留 light/dark 展开态 Golden，不以闭合整页截图替代浮层验收。

## 非目标

- 不新增 Controller、handle 或新的公开关闭 API。
- 不改变十二种 TPopoverPlacement 的枚举和方向含义。
- 不改变 contentWidget 必须具有确定外框尺寸的契约。
- 不重构 Popup、DropdownMenu 或其他 Overlay 组件。
- 不为了复用内部诊断 Demo 而扩大 TPopover 组件公开 API；`showInternalExamples` 仅是 Example 页的测试开关。

## 范围

### 涉及

- tdesign-component/lib/src/components/popover/t_popover.dart
- tdesign-component/lib/src/components/popover/t_popover_widget.dart
- tdesign-component/lib/src/components/popover/t_popover_theme_data.dart
- tdesign-component/test/components/popover/t_popover_test.dart
- tdesign-component/example/lib/page/t_popover_page.dart
- tdesign-component/example/test/popover_page_test.dart
- tdesign-component/example/test/popover_demo_golden_test.dart
- tdesign-component/example/assets/code/popover.*.txt
- Popover 与 Popup 主题、Overlay 的直接关联测试。
- 小程序实际页截图与 Flutter 3.32.0 Linux 明暗整页 Golden。

### 不涉及

- TPopover 公共参数增删。
- Example 页面视觉重做。
- 站点组件 README 的手工维护；API Markdown 仍由生成链负责。
- 自动 placement 翻转与锚点跟随动画。

## 行为契约

### 内容与事件

- content 和 contentWidget 沿用现有可选参数；contentWidget 使用时必须提供确定的 width、height，或由现有组件主题提供对应确定尺寸。
- 配置 onTap 后，点击气泡实际内容区域调用一次回调，并传入当前 content。
- 配置 onLongTap 后，长按气泡实际内容区域调用一次回调，并传入当前 content。
- 未配置回调时不创建会吞掉事件的透明手势区域，外部点击和底层滚动行为保持不变。
- 回调只负责通知，不隐式关闭 Popover；关闭仍由外部点击、滚动、返回键或生命周期路径决定。

### 主题优先级

- 实例显式参数优先于 TPopoverThemeData，TPopoverThemeData 优先于 TDesign token 兜底。
- colorScheme 决定默认文本色和语义背景 token。
- TPopoverThemeData.backgroundColor 非空时覆盖语义背景 token，并同时应用于气泡容器和箭头。
- barrierColor、padding、borderRadius、arrowSize、showArrow、offset 和 boxShadow 保持现有主题解析行为。
- 主题读取发生在 inherited dependencies 可用的生命周期阶段，不在 initState 中建立 Theme 依赖。

### 尺寸

- 实例 width、height 表示包含 padding 的确定外框尺寸。
- 文本内容未显式指定 width 时，minWidth 是宽度下限，maxWidth 是宽度上限；默认 maxWidth 为 300。
- maxHeight 是文本气泡外框的最大高度，不得把短文本强制撑到 maxHeight。
- contentWidget 继续使用确定宽高进行首帧定位；现有主题尺寸兼容路径不在本次删除。
- padding 大于尺寸约束时不得产生负的文本测量宽度或布局异常。

### 定位与可用视口

- top/topLeft/topRight 上方空间不足且下方充足时，分别翻转为 bottom/bottomLeft/bottomRight；bottom 系列反向规则对称。
- left/leftTop/leftBottom 与 right/rightTop/rightBottom 使用同样的同轴反向规则。
- 请求方向和反方向都不足时保留请求方向，再对最终外框执行 viewport clamp。
- clamp 后箭头沿气泡边缘移动以继续指向锚点；箭头中心不得进入圆角与箭头尺寸构成的边缘安全区。
- 锚点具有有效、非零 RenderBox 时，最终位置约束在 MediaQuery 安全区内。
- 底部边界同时考虑系统安全区和 viewInsets.bottom，避免键盘遮挡。
- 横向 placement 的总宽度、纵向 placement 的总高度包含箭头尺寸。
- 无有效 RenderBox 但上下文仍存活时保留既有兼容定位，不因边界修复改变直接构造 TPopoverWidget 的行为。
- 锚点 Element 已 unmounted 时不得继续在 (0, 0) 绘制气泡。

### 关闭与生命周期

- closeOnClickOutside 为 true 时，点击气泡外部关闭并完成 showPopover Future。
- closeOnScroll 为 true 时，祖先滚动和外部指针滚动关闭气泡；底层滚动仍可发生。
- closeOnScroll 为 false 时，滚动不关闭气泡，保持现有行为。
- 页面返回或 LocalHistoryEntry 移除时清理 OverlayEntry、滚动监听并完成 Future。
- 锚点销毁时应主动执行同一清理路径，而不只是隐藏内容；清理必须幂等。

## 验收标准

- [x] onTap、onLongTap 可触发且传入 content。
- [x] 未配置回调时不阻断外部点击关闭和底层滚动。
- [x] backgroundColor 同时控制容器和箭头的背景色来源。
- [x] 短文本在设置 maxHeight 后保持自然高度。
- [x] 文本宽度遵循 minWidth、maxWidth 和默认 300 上限。
- [x] 右下角有效锚点的 Popover 不越出可用视口。
- [x] top/bottom 与 left/right 系列在请求方向空间不足时同轴翻转。
- [x] 两侧空间都不足时执行 clamp，箭头补偿后仍受圆角安全区约束。
- [x] 锚点 unmounted 后不在左上角继续绘制。
- [x] 锚点 unmounted 后 OverlayEntry、监听器和 Future 被主动清理。
- [x] Popover、Golden、关联 Popup/主题测试通过。
- [x] Demo 可直接观察事件回调、自定义内容、主题尺寸、四角边界、键盘和锚点销毁行为。
- [x] Demo Widget 测试覆盖交互、几何边界与生命周期 Future 完成。
- [x] 公开 Demo 默认不展示“交互与边界”诊断模块，小程序公开矩阵的 21 个触发按钮顺序保持一致。
- [x] 公开 Demo 的 21 个按钮均与小程序一样使用 large 尺寸。
- [x] 明暗主题整页 Golden 与 42 张逐 Demo 展开态 Golden 在 Flutter 3.32.0 Linux 可复现。
- [x] 42 张展开态 Golden 已逐张检查，无溢出、裁切或箭头错位。
- [x] flutter analyze、组件文档契约检查和 git diff --check 通过。
