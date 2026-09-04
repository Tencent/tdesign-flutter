# BackTop 视觉契约与 API 收敛

## 背景

当前 `TBackTop` 仅覆盖浅色圆形与半圆形，公开 Demo 通过按钮切换单个悬浮实例，未呈现 Figma 中每种形态的明暗、带文案和无文案状态。组件还把结构形态与滚动显隐阈值同时放在实例和 `TBackTopThemeData` 中，并把 `onPressed == null` 解释为禁用，导致仅传 `ScrollController` 时回顶能力不可用。

## 设计证据

- Figma：`TDesign for mobile (Community)`，BackTop 页面节点 `24386:5237`，组件集合节点 `24387:6706`。
- Figma 组件属性：`theme = round | half-round | round-dark | half-round-dark`、`icon`、`text`；圆形为 `48 × 48`，半圆形高度 `40`、无文字最小宽度 `38`、带文字宽度 `69`，半圆横向内边距 `8`、内容间距 `2`、边框 `0.5`。
- 小程序 1.16.0 在线公开 Demo 仅包含“基础返回顶部”，通过 `scroll-top` 输入和 `to-top` 事件完成受控回顶；API 默认显隐阈值为 `200`，预设样式包含 `round / half-round / round-dark / half-round-dark`。
- Flutter 的滚动状态由 `ScrollController` 所有；`onPressed` 只适合作为完成后的通知，不应成为重复的启停状态源。

## 目标

- 让生产组件直接提供 Figma 中圆形、半圆形、浅色、深色、带文案和无文案的默认视觉。
- 由实例参数唯一拥有结构、配色与显隐阈值，Theme 只保存具体视觉字段。
- 仅传 `ScrollController` 时也可点击回顶；`onPressed` 作为回顶完成后的可选通知。
- 公开 Demo 同屏覆盖 8 个设计状态，并保留真实滚动回顶流程。
- 补齐组件、Demo、覆盖率与 light/dark Golden 回归门禁。

## 非目标

- 不机械复制小程序 `fixed`、`scroll-top`、图标字符串或默认插槽；Flutter 继续由父布局和 `ScrollController` 表达这些能力。
- 不新增私有 Controller、全局滚动监听或页面级定位 API。
- 不修改其他导航组件。
- 不手工维护 `CHANGELOG.md`。

## 范围

### 涉及

- `TBackTop`、`TBackTopShape`、新增 `TBackTopColorScheme` 与 `TBackTopThemeData`。
- BackTop Example、生成示例/API 资产、组件与 Demo 测试、Golden 和集中式回归清单。

### 不涉及

- `ExamplePage` 公共基础设施。
- 小程序组件 API 的逐字段移植。
- Drawer、Indexes、Navbar、SideBar、Steps 和 TabBar。

## 行为契约

- `shape` 只表达结构形态，非空默认 `circle`；`TBackTopThemeData` 不再保存默认 shape。
- `colorScheme` 只表达同一结构下的浅色或深色预设，非空默认 `light`，Theme 不保存该选择器。
- `visibilityOffset` 非空默认 `200`；绑定 `controller` 时偏移达到阈值才显示，未绑定时始终显示。Theme 不保存显隐阈值。
- 有 `controller` 或 `onPressed` 任一动作来源时组件可点击；有已挂载的 `controller` 时先动画回顶，再调用一次 `onPressed`。动画过程中重复点击不重复完成。
- 圆形固定为 48 方形；半圆形高度 40、最小宽度 38、横向内边距 8、内容间距 2；图标 20、边框 0.5，文字使用 10px/1.2/600 的 Mark 语义。
- Light 使用容器背景、组件边框与主文本 Token；Dark 圆形使用 `grayColor13`，Dark 半圆使用 `grayColor14`，二者使用 `grayColor9` 边框与反色文本。
- `TBackTopThemeData` 只承载具体颜色、尺寸、间距和文字样式。实例没有同义视觉字段，Theme 未配置时回退 TDesign Token 或上述设计内置值。
- Theme 连续尺寸在一侧为空时以运行时内置尺寸参与插值，两侧为空保持为空；颜色与文字样式两侧为空保持为空，避免把空值插值为透明或零值。
- Demo 仅使用 `TBackTop` 自身呈现 8 个设计状态，不用外层装饰模拟组件内部背景、边框、圆角或文字。

## 验收标准

- [x] 公开 Demo 同屏呈现圆形与半圆形各 4 个设计状态，分组、文案和顺序有测试。
- [x] 真实滚动超过 200 后出现 BackTop，点击后回到顶部且回调仅触发一次。
- [x] 组件测试覆盖 shape、colorScheme、showText、显隐、回顶、Theme 优先级与插值。
- [x] BackTop 手写生产源码覆盖率达到 95%。
- [x] 示例代码生成检查和 API 生成通过。
- [x] Flutter 3.32.0 与 latest 的非视觉测试、定向 analyze 通过。
- [x] Flutter 3.32.0 Linux 的 Demo 与导航矩阵 light/dark Golden 通过。
