# BackTop 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

返回顶部组件的形态、状态和默认视觉需要与真实滚动行为一致。

当前 `TBackTop` 仅覆盖浅色圆形与半圆形，组件还把结构形态与滚动显隐阈值同时放在实例和 `TBackTopThemeData` 中，并把 `onPressed == null` 解释为禁用，导致仅传 `ScrollController` 时回顶能力不可用。公开 Demo 虽已有按钮切换单个悬浮实例，但页面布局、滚动目标和设计验收截图没有锁定到当前 Figma 分支。

- Figma 主基准：`TDesign for mobile` 分支 `4SdclZkcv5bPgX6pa8AsmI`，BackTop 页面节点 `24386:5237`。移动端画板固定为 `375 × 812`，包含同页两个全宽描边按钮、骨架内容，以及滚动后的圆形 / 半圆形悬浮状态。
- Figma 组件属性：`theme = round | half-round | round-dark | half-round-dark`、`icon`、`text`；圆形为 `48 × 48`，半圆形高度 `40`、无文字最小宽度 `38`、带文字宽度 `69`，半圆横向内边距 `8`、内容间距 `2`、边框 `0.5`。
- 小程序 `develop` 分支公开 Demo 包含“圆形返回顶部”和“半圆形返回顶部”两个按钮；选择后调用 `wx.pageScrollTo(duration: 300, scrollTop: 1000)`，悬浮组件点击后回顶。API 默认显隐阈值为 `200`，预设样式包含 `round / half-round / round-dark / half-round-dark`。
- Flutter 的滚动状态由 `ScrollController` 所有；`onPressed` 只适合作为完成后的通知，不应成为重复的启停状态源。

## 范围与非目标

### 目标

- 让生产组件直接提供 Figma 中圆形、半圆形、浅色、深色、带文案和无文案的默认视觉。
- 由实例参数唯一拥有结构、配色与显隐阈值，Theme 只保存具体视觉字段。
- 仅传 `ScrollController` 时也可点击回顶；`onPressed` 作为回顶完成后的可选通知。
- 公开 Demo 按 Figma 与小程序模式同屏提供两个形态按钮，选择后以 300ms 动画滚动至最多 1000，并由单个悬浮实例执行回顶。
- 8 个形态 / 配色 / 文案组合放在组件级 Golden 矩阵，不把内部状态枚举混入公开 Demo。
- 补齐组件、Demo、覆盖率与 light/dark Golden 回归门禁。

### 涉及

- `TBackTop`、`TBackTopShape`、新增 `TBackTopColorScheme` 与 `TBackTopThemeData`。
- BackTop Example、生成示例/API 资产、组件与 Demo 测试、Golden 和集中式回归清单。

### 不涉及

- 不机械复制小程序 `fixed`、`scroll-top`、图标字符串或默认插槽；Flutter 继续由父布局和 `ScrollController` 表达这些能力。
- 不新增私有 Controller、全局滚动监听或页面级定位 API。
- 不修改其他导航组件。
- 不手工维护 `CHANGELOG.md`。

- `ExamplePage` 公共基础设施。
- 小程序组件 API 的逐字段移植。
- Drawer、Indexes、Navbar、SideBar、Steps 和 TabBar。

## 最终方案与行为契约

- `shape` 只表达结构形态，非空默认 `circle`；`TBackTopThemeData` 不再保存默认 shape。
- `colorPreset` 只表达同一结构下的浅色或深色预设，非空默认 `light`，Theme 不保存该选择器。
- `visibilityOffset` 非空默认 `200`；绑定 `controller` 时偏移达到阈值才显示，未绑定时始终显示。Theme 不保存显隐阈值。
- 有 `controller` 或 `onPressed` 任一动作来源时组件可点击；有已挂载的 `controller` 时先动画回顶，再调用一次 `onPressed`。动画过程中重复点击不重复完成。
- 圆形固定为 48 方形；半圆形高度 40、最小宽度 38、横向内边距 8、内容间距 2；图标 20、边框 0.5，文字使用 10px/1.2/600 的 Mark 语义。
- Light 使用容器背景、组件边框与主文本 Token；Dark 圆形使用 `grayColor13`，Dark 半圆使用 `grayColor14`，二者使用 `grayColor9` 边框与反色文本。
- `TBackTopThemeData` 只承载具体颜色、尺寸、间距和文字样式。实例没有同义视觉字段，Theme 未配置时回退 TDesign Token 或上述设计内置值。
- Theme 连续尺寸在一侧为空时以运行时内置尺寸参与插值，两侧为空保持为空；颜色与文字样式两侧为空保持为空，避免把空值插值为透明或零值。
- Demo 的悬浮控件仅使用 `TBackTop` 自身呈现，不用外层装饰模拟组件内部背景、边框、圆角或文字；宿主布局保持圆形标准浮动间距，并将半圆形直边贴齐屏幕右边缘。圆形 / 半圆形切换时关闭 Scaffold FAB 缩放过渡，避免出现设计稿和小程序均不存在的中间态。
- Demo Golden 使用 Figma 画板对应的 `375 × 812` 固定视口，分别冻结首屏、圆形滚动态与半圆形滚动态；系统状态栏不属于 Flutter `RepaintBoundary`，由真机截图补充验收。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 滚动目标与可见性由既有组件能力管理，样式选择留在实例，具体数值由 Theme/Token 解析。 |
| 保留的边界与代价 | 区分工程默认尺寸与设计确认值，保留实例或局部 Theme 的显式覆盖。 |

### 设计演变中的关键理由

- 默认绑定 Controller 后会在 200 前隐藏，属于与公开上游契约一致的用户可见默认行为变化。
- 不把小程序四个 `theme` 字符串合成一个枚举；Flutter 拆成独立 shape 与 colorPreset，四组组合均有明确设计实例。
- 不新增 `disabled`；没有动作来源时只移除点击语义，不制造设计中不存在的透明禁用态。
- `showText` 保留为标准文案状态，不新增与其重复的 String/Widget 文案入口；完整内容自定义没有本次 Figma 或公开 Demo 证据。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 公开 Demo 同屏呈现两个形态按钮，按钮顺序、300ms 滚动选择和单一悬浮实例有测试。
- 真实滚动超过 200 后出现 BackTop，点击后回到顶部且回调仅触发一次。
- 组件测试覆盖 shape、colorPreset、showText、显隐、回顶、Theme 优先级与插值。
- BackTop 手写生产源码覆盖率达到 95%。
- 示例代码生成检查和 API 生成通过。
- Flutter 3.32.0 与 latest 的非视觉测试、定向 analyze 通过。
- Flutter 3.32.0 Linux 的 `375 × 812` Demo 首屏 / 两种滚动态与组件 8 状态矩阵 light/dark 严格 Golden 通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。


## 1.0.1 backtop-completed

新增可选 onCompleted，仅在本组件发起的操作结束时，原 ScrollPosition 仍绑定原 Controller、该 Controller 仍是当前 Controller、原位置到达最小滚动边界且组件仍挂载时触发。onPressed 保持原有时机、不标记废弃；无可用滚动位置时立即通知，有位置时等待动画 Future 结束，动画中断仍可能通知。仅提供 onCompleted 不启用按钮，动画期间重复点击继续忽略。

同帧和跨帧解绑重绑原位置、临时切换 BackTop Controller 后恢复均允许完成；完成时仍解绑、位置替换、当前 Controller 不同、未到顶或卸载不通知。成功在旧 onPressed 副作用前记录，随后在发送 onCompleted 前再次检查挂载和绑定身份。旧回调修改偏移不会改写已记录的成功；旧回调跳到顶部也不将失败变成功。

不要求全程从未解绑。先前考虑的全程观察方案已被完成时状态定义取代：普通已创建 ScrollController 无法透明追加每次 attach/detach 事件接入，且用户不需要此历史约束。因此没有逐帧观察、绑定历史计数、新观察器或专用 Controller；所有权、绑定数量限制与异常规则保持原样。
