# Dialog 官方基线对齐

## 背景

Dialog 的核心弹层能力已存在，但默认顶边距和关闭按钮位置与 Figma 移动端设计各差 8px，居中 Popup 的 240×240 默认尺寸还会把 311dp Dialog 压窄并裁切输入框。Example 仅展示 7 个业务化场景，且 Dialog ThemeData 生产源码覆盖基线仅 78.16%。

## 目标

- 对齐 Figma Dialog 移动端展示稿的默认顶边距和关闭按钮位置。
- 公开展示官方 base、confirm、status、with-image、with-input、command 和自定义按钮全部 22 个场景。
- 对齐 Figma Demo 的页面文案、状态分组说明和各类 Dialog 打开态。
- Dialog 生产源码 LCOV 达到 95% 以上。

## 非目标

- 不机械新增 Web/小程序的 `top`/`middle`、`cancelBtn`/`confirmBtn`、`buttonLayout` 或 plugin 形态 API。
- 不改变 Dialog 的 240ms 缩放动画、结果返回和遮罩默认语义。

## 范围

### 涉及

- `TDialog` 默认可见样式。
- Dialog ThemeData 与样式 Widget 测试。
- Dialog Example 页、Example 测试和自动生成代码片段。

### 最小配套

- Dialog 使用 Flutter 标准模态路由承载居中自适应面板；不新增 Popup 公开 API，普通 Popup 的 240×240 默认契约保持不变。
- Dialog 保留现有构造与 `Future<T?>` 展示 API；仅增加可选的蒙层与关闭按钮返回值。

## 行为契约

- `TDialog.show<T>` 增加可选 `T? barrierResult`，仅在 `barrierDismissible: true` 的蒙层关闭成功时返回；`TDialog` 与 `TConfirmDialog` 增加可选 `Object? closeButtonResult`，仅用于内置关闭图标。两者默认 `null`，按钮继续使用 `TDialogAction.result`；不新增关闭回调、Controller 或组件级业务结果枚举。
- 显示仍由 Flutter 模态路由承载，蒙层使用标准 ModalBarrier/AnimatedModalBarrier；蒙层与内置关闭图标走所属 Navigator 的 `maybePop`，遵守 PopScope 拦截。操作按钮保留原有 Navigator.pop 行为；系统返回与业务 Navigator.pop 使用其原有结果，不误报为蒙层关闭。
- 命令调用 Demo 用私有结果枚举展示确认、取消、蒙层与关闭按钮的区分，并显示实际关闭来源。测试必须从公开入口打开后点击面板四周的真实蒙层，验证默认 false、显式 true、面板内点击、Future 仅完成一次与阻止返回的路径；覆盖率不能替代这些交互证据。
- Dialog Demo 全部 22 个入口均显式设置 `barrierDismissible: true`，包括反馈、确认、输入、图片及各种操作区，统一允许点击蒙层关闭；仅调整示例组合，组件全局默认 false 保持不变。
- 默认 content padding 为 `EdgeInsets.fromLTRB(24, 24, 24, 0)`。
- 默认圆角、内容留白、标题正文间距、关闭按钮偏移和操作区间距从对应 TDesign radius/spacer token 解析；实例参数与组件 Theme 仍保持更高优先级。
- Dialog 路由面板按内容自适应，默认宽度为 311dp，不再继承 Popup 的 240×240 固定尺寸。
- 关闭按钮距面板 top/end 均为 8px。
- 默认标题和正文样式保留应用 `TextTheme` 的主字体与 fallback，避免弹层丢失应用级字体覆盖。
- 带图片场景在 Example 层通过任意 `content` Widget 组合；垂直两按钮通过 `actionsWidget` 组合；不扩大基础 API。
- 带图片场景使用 160dp 设计高度；输入场景复用 `TInput`，保留灰色输入壳、16dp 顶间距和清除能力，不使用原生透明 `TextField` 近似。
- “文字按钮”使用 32dp 顶间距、56dp 高的贴边文字操作区和 0.5dp 分隔线；基础按钮继续使用 24dp 操作区内边距。
- 三个及以上操作按 `TDialogAction.role` 将主要与危险操作优先从上到下展示，同类操作保持声明顺序；未声明强调角色时不改变调用方顺序。确认类纯标题场景使用浅色确认按钮。
- 贴边文字 Footer 仅用于 1～2 个文字操作；三个及以上文字操作使用带默认操作区内边距的纵向布局。
- 普通基础操作由 Dialog 默认解析为 `fill + light`，主要与危险操作继续分别使用 `fill + primary`、`fill + danger`；显式 `text`、`outline`、`ghost` 的普通操作保留 `defaultTheme` 配色。实例 `colorScheme` 和 `style` 仍优先，不联动覆盖其他操作，不新增 API 或 Theme 选择器。颜色由 TButton 的现有 token/主题解析链提供。
- Demo 标准操作不重复声明角色已经决定的配色；纯标题确认的浅色强调仍为显式场景选择。垂直两按钮的完全自定义操作区继续由调用方组合 TButton，并使用相同的浅色次要操作样式。
- `actionsPadding` 和 `actionSpacing` 的显式实例值始终高于 token 默认值，即使数值与默认字面量相同也不得被覆盖。
- “组件状态”内逐项展示文字按钮、水平基础按钮、垂直基础按钮、多按钮和关闭按钮说明，不以一个笼统说明替代。
- 22 个官方场景均有独立可见触发入口；小程序 `openType` 通过 Flutter 既有 `TDialogAction` 自定义子项表达，不新增跨端专用 API。
- 公开页在“组件用法”后结束，不展示仅供内部验证的“单元测试”模块。

## 验收标准

- [x] 顶边距和关闭按钮偏移有 Widget 测试保护。
- [x] Example 测试证明 22 个入口公开可见，并覆盖图片、垂直按钮和自定义操作项交互。
- [x] Example 测试逐项打开并关闭 22 个入口，覆盖输入、文字按钮、图片、主操作顺序和返回结果。
- [x] Dialog 生产源码 LCOV `LH/LF >= 95%`。
- [x] Flutter 3.32.0 与 latest 的组件测试、Example 测试和严格 analyze 全部通过。
- [x] Flutter 3.32 Linux 亮暗主题 22 个 Golden（2 张整页及 10 个打开态各 2 张）在最终 Demo 调整后，无 `--update-goldens` 精确复跑 22/22 通过，未放宽容差。

## 兼容性判断

- 普通操作未指定变体时，从描边默认配色调整为填充浅色配色；显式 `fill` 且未指定配色的普通操作同样采用浅色配色，属于默认视觉 breaking change。需要旧外观时显式设置 `variant: TButtonVariant.outline, colorScheme: TButtonColorScheme.defaultTheme`；文字、描边、幽灵变体与显式样式不变。
- 关闭返回值为可选新增能力，默认值及既有 `Future<T?>` 不变，本项不引入 breaking change；不新增为 Dialog 特制的 Popup 开关；`actionsPadding` / `actionSpacing` 构造入口与公开字段允许 `null` 表示未设置，渲染时解析当前主题 token。
- 相对 develop 基线 `ed6ac81d`，三项及以上操作由声明顺序调整为主要/危险角色优先、普通角色随后，两组内部各自保持声明顺序。混合角色的默认显示顺序可能变化，属于 breaking change；全为普通角色时顺序不变，不应描述为“原先无条件倒序”。需要完全自定义展示顺序时使用既有 `actionsWidget`；不要仅为排序修改角色而同时改变配色语义。提交与 PR 标题应使用 `breaking(dialog)`。
