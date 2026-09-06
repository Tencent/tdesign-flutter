# Drawer 设计与交互契约收敛

## 背景

当前 Flutter Drawer 公开 Demo 的“带图标”和“带标题”按钮文案与实际内容互换，基础示例使用 30 项且默认从右侧打开，与小程序公开 Demo 的左侧 8 项操作模式不一致。生产组件的列表正文、图标间距、标题与底部间距仍未对齐当前设计；Theme 同时保存边框和反馈开关，与实例状态重复。

## 设计证据

- 新 Figma 分支：`TDesign for mobile` Drawer 移动端展示节点 `24386:5238`，画布为 375 × 1024，公开 Demo 含基础、图标、大小标题、左右方向和底部插槽 7 个入口。
- Figma 组件集合由 `showOverlay`、`placement = left | right`、`title`、`prefixIcon`、`footer` 等状态组合；375 的实例宽度包含蒙层，实际面板宽度仍为 280。
- 小程序 develop 公开 Demo 仅有基础、图标、标题、底部插槽 4 个场景，且全部从左侧打开；`visible` 受控，分别监听 `item-click` 与 `overlay-click`。
- 跨端差异策略：公开 Demo 的分组和 7 个入口优先对齐新 Figma；抽屉打开后的 8 项列表、蒙层关闭与底部长列表操作模式对齐小程序，不机械复制 `visible` API。
- 小程序当前样式：面板宽 280、标题内边距 24/16/8、菜单正文 Body Large、菜单内边距上 16 / 右 0 / 下 16 / 左 16、图标 24 且右间距 8、底部区底边距 20、分隔线从 16 开始。

## 目标

- 修正公开 Demo 文案和内容映射，按新 Figma 覆盖基础、图标、大小标题、左右方向和底部插槽 7 个入口。
- `TDrawer` 收敛为声明式 `StatelessWidget`；独立的 `showTDrawer(...)` 负责 Popup 展示，不机械复制小程序 DOM/slot API。
- 由 `showTDrawer(...)` 唯一拥有 `placement`、蒙层、顶部偏移与展示生命周期；`TDrawer` 拥有内容、按压反馈和分隔线；Theme 只保存具体颜色、尺寸、间距和文字样式。
- 补齐 `onOverlayClick` 与 `destroyOnClose`，让公开操作语义可以直接表达。
- 补齐组件、Demo、覆盖率与 Flutter 3.32 Linux light/dark Golden 门禁。

## 非目标

- 不把小程序 `visible` 复制成组件状态；Flutter 浮层入口继续通过 `TDrawerHandle` 管理生命周期。
- 不复制 `using-custom-navbar`、z-index、CSS class 或字符串图标。
- 不改变 Popup 的公共契约。
- 不手工维护 `CHANGELOG.md`。

## 范围

- `TDrawer`、`showTDrawer`、`TDrawerHandle`、`TDrawerItem`、`TDrawerThemeData`。
- Drawer 公开 Demo、生成 API/示例资产、组件与 Demo 测试、Golden、集中式回归清单。

## 行为契约

- `TDrawer` 是可用于 `Scaffold.drawer` / `Scaffold.endDrawer` 的声明式 Widget，只持有内容与组件视觉/交互参数。
- `showTDrawer(...)` 的 `placement` 非空默认 `right`；Demo 的基础与图标示例显式使用小程序公开示例的 `left`，左右方向都有回归。
- `showTDrawer(...)` 的 `showOverlay`、`closeOnOverlayClick` 非空默认 `true`；`onOverlayClick` 每次有效蒙层点击触发一次，是否关闭只由 `closeOnOverlayClick` 决定。
- `showTDrawer(...)` 的 `destroyOnClose` 非空默认 `false` 并透传 Popup；`onClose` 在一次展示周期真正结束后触发；`topInset` 替代旧 `drawerTop`。
- `TDrawer.enableFeedback`、`TDrawer.showDivider`、`TDrawer.showLastDivider` 为组件实例状态，非空默认 `true`，Theme 不保存同义开关。
- `showDivider` 控制菜单项分隔线，不在列表四周额外绘制整圈边框；末项是否显示分隔线由 `showLastDivider` 决定。
- 标题 Widget 默认按文字方向起始侧对齐；面板实例或 Theme 背景色同时作为菜单项未显式配置背景时的默认值。
- 默认面板宽 280；正文使用 Body Large，菜单内边距为 `EdgeInsets.fromLTRB(16, 16, 0, 16)`；图标间距 8；标题内边距为 `EdgeInsets.fromLTRB(16, 24, 16, 8)`；底部区默认仅保留 20 底边距；分隔线缩进 16、厚度 0.5。
- `child` 继续作为完全自定义内容并优先于 `items` / `title` / `footer`；`TDrawerItem.content` 仅替换该项正文，仍可与图标组合。
- 实例具体字段优先于 `TDrawerThemeData`，Theme 具体字段优先于 TDesign Token 和设计内置值。
- `TDrawerThemeData.lerp` 对宽度、间距和尺寸使用运行时有效默认值插值；两侧均未配置时继续保持 `null`，由消费端读取 Token。依赖当前主题 Token 的颜色和文字样式在一侧未配置时采用离散切换，避免把 `null` 错当作 0 或透明色。
- `TDrawer` 与 `TDrawerThemeData` 拒绝非正宽度；`showTDrawer` 拒绝负数 `topInset`；Theme 中图标尺寸、图标间距、分隔线缩进和厚度不得为负数。

## Breaking changes

- 删除 `TDrawerWidget`，声明式用法改为 `TDrawer(...)`。
- 删除 `TDrawer(BuildContext, ...).show()`；浮层用法改为 `showTDrawer(context, drawer: TDrawer(...), ...)`。
- `placement`、`showOverlay`、`closeOnOverlayClick`、`onOverlayClick`、`useSafeArea`、`destroyOnClose`、`onClose` 从组件构造器移动到 `showTDrawer(...)`。
- `drawerTop` 删除，由 `showTDrawer.topInset` 替代。

## 验收标准

- [x] 公开 Demo 的分组、按钮文案与构建内容一一对应，7 个 Figma 入口完整，基础与图标示例保留小程序的左侧 8 项模式。
- [x] Demo 覆盖左右方向、大小标题、图标和底部长列表，并通过真实打开、点击蒙层关闭测试。
- [x] 组件测试覆盖蒙层回调、关闭策略、destroyOnClose、方向、句柄、Theme 优先级和设计尺寸。
- [x] Theme 测试覆盖默认值到显式值的双向插值、两侧均为空及非法尺寸。
- [x] Drawer 手写生产源码覆盖率达到 95%。
- [x] API 文档与公开示例代码生成检查通过；5 个代码面板包含复现示例所需的数据和交互入口，不依赖未展示的私有 helper。
- [x] Flutter 3.32.0 与 latest 的组件、Demo 测试及全量 analyze 通过。
- [x] Flutter 3.32.0 Linux 的 375 × 1024 Demo 整页、7 个打开态 light/dark、共享 navigation light/dark 与 Popup Consumer Golden 均在最终源码上通过。
