# NavBar 设计与公开契约收敛

## 背景

NavBar 需要同时对照新版 Figma 的 H5/Flutter 专属移动画板、小程序公开 Demo 与 Flutter 的 `PreferredSizeWidget` 约束。现状默认显示返回箭头，与小程序 `leftArrow = false` 和 Figma 的无返回基础状态冲突；标题回退仍使用 Body Token；`useBorderStyle` 同时存在于实例与 Theme，形成结构状态的双状态源；公开 Demo 与新版 Figma 的 H5/Flutter 示例顺序和图片尺寸也未完全一致。

## 设计依据

- Figma 主基准：分支 `4SdclZkcv5bPgX6pa8AsmI`，NavBar 页面节点 `24386:5240`。H5/Flutter 与小程序分别提供 `375 × 1318` 画板，不能互相机械复制。
- 小程序参考：`develop` 分支 `packages/components/navbar/_example/` 与 `navbar.less`。默认不显示返回、内容高度 48、返回图标 24、标题使用 Title Large；搜索宽 252、图片为 `87 × 24`。
- Flutter 设计模式：组件是 `PreferredSizeWidget`，页面导航与安全区由父级 Scaffold / 路由共同拥有；小程序的 `fixed`、`placeholder`、`delta`、宿主胶囊和顶部系统偏移不移植为 Flutter API。

## 目标

- 公开 Demo 对齐 Figma 的 H5/Flutter 画板，并保持小程序的内容顺序、尺寸 Token 与真实操作反馈。
- 收敛默认返回、内容高度、标题字体、返回图标与边框结构状态。
- 明确实例、Theme、Material Theme 和 TDesign Token 的所有权与优先级。
- 建立组件、Demo、light/dark Golden、双 SDK 与 Android 真机回归证据。

## 非目标

- 不在 Flutter 中伪造微信右上角系统胶囊、iOS 状态栏或 Home Indicator。
- 不复制小程序 `fixed`、`placeholder`、`safeAreaInsetTop`、`delta`、`visible`、`zIndex` API。
- 不删除 Flutter 已有的 Widget 组合、`PreferredSizeWidget`、`belowTitleWidget`、`flexibleSpace` 和安全区能力。

## 范围

### 涉及

- `TNavBar`、`TNavBarThemeData`、NavBar Example、生成 API / 示例片段。
- NavBar 组件测试、Demo 测试、组件与页面 light/dark Golden、共享导航视觉矩阵。
- Android 真机集成操作与普通 APK 持久安装验收。

### 不涉及

- 其他导航组件的公开契约。
- 小程序宿主系统胶囊的绘制与交互。

## 行为契约

### 实例状态

- `useDefaultBack` 默认 `false`；只有显式开启时才渲染默认返回按钮。
- `height` 为非空 `double`，默认 48，同时作为 `preferredSize.height` 和内容高度的唯一来源。
- `useBorderStyle` 为非空实例结构状态，默认 `false`；Theme 不保存该布尔选择器。
- `centerTitle`、`leading`、`actions`、`titleWidget` 与 `belowTitleWidget` 继续由当前实例拥有。
- 默认返回图标为 24；点击时先通知 `onBack`，再执行 `Navigator.maybePop`。

### Theme 与样式优先级

- 标题字体默认回退 TDesign Title Large（18/26/600），不再回退 Body Large。
- `titleColor`、`backIconColor`、`titleFont`、`titleFontWeight`、`titleFontFamily`、`backgroundColor`、`padding`、`titleMargin`、`opacity`、`border`、`boxShadow` 仍可由 `TNavBarThemeData` 提供子树默认值。
- 解析优先级为构造器 > `TNavBarThemeData` > Material `AppBarTheme`（对应字段）> TDesign 语义 Token。
- `TNavBarBorder` 只定义边框的颜色、宽度、圆角与内边距，不决定是否启用边框模式。

### Demo

- “组件类型”依次展示 Figma H5/Flutter 画板中的：基础 H5、左侧多操作、右侧多操作、搜索、图片。
- “组件样式”依次展示：标题居中、标题左对齐、普通标题 / 返回文字与 28/36 大标题、自定义颜色。
- 图片固定 `87 × 24`；搜索与图片示例保留 Figma H5/Flutter 画板中的右侧操作项。
- 点击关闭、首页、更多与返回均产生可见反馈；搜索框可真实输入。

## Breaking change 分析

- `useDefaultBack` 默认值由 `true` 改为 `false`，属于默认行为变化。
- `height` 从 `double?` 收敛为 `double`；显式传 `null` 的调用需要删除该参数。
- `useBorderStyle` 从 `bool?` 收敛为 `bool`，并从 `TNavBarThemeData` 移除；依赖 Theme 开启结构模式的调用需要迁移到实例。

## 验收标准

- [x] Demo 的结构、顺序、尺寸和操作与 Figma H5/Flutter 画板一致。
- [x] Figma 与小程序的宿主胶囊、系统栏及示例差异已明确记录。
- [x] 组件与 Demo 行为测试通过，生产源码行覆盖率不低于 95%。
- [x] Flutter 3.32.0 Linux 的组件、Demo 和共享导航 light/dark 严格 Golden 通过并逐张人工核对。
- [x] Flutter 3.32.0 与 latest 全量 analyze 0 error / 0 warning，并完成必要构建。
- [x] Android 16 真机在最终代码 Hot Restart 后完成滚动、按钮回调、搜索输入和明暗主题操作；普通 APK 持久安装可从 Launcher 启动。
- [ ] 独立 GitHub / CNB PR、Issue #1027 NavBar 条目与 CodeBuddy Review 全部闭环。
