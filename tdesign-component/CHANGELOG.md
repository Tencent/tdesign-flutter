---
title: 更新日志
spline: explain
toc: false
docClass: timeline
---

## 🌈 1.0.0 `2026-10-15`

TDesign Flutter 1.0 正式发布！

本次版本围绕组件 API、主题体系、默认视觉和交互体验完成系统性升级，统一常用组件的使用方式，并增强表单、上传、选择器、图片预览、表格和轮播等能力。

### ✨ 本次发布重点

- **统一组件 API**：统一 `T` 前缀、内容插槽、回调与受控状态，梳理 Controller 和浮层职责，移除旧版兼容入口及重复配置。
- **完善主题体系**：通过全局 Token、组件 Theme、局部主题和实例配置定制样式，统一深浅色及主题切换表现。
- **提升视觉与交互一致性**：集中优化尺寸、排版、状态反馈、文字缩放和无障碍体验，使默认表现更贴合 TDesign 设计规范。
- **增强常用能力**：新增标准选择器弹层、上传列表与拖拽排序、图片预览缩放、自定义徽标，以及表格、轮播和进度条配置。

### 📖 升级到 1.0.0

**1.0 包含不兼容的 API 和默认行为调整，最低要求 Flutter ≥ 3.32.0、Dart ≥ 3.8.0。**

从 0.2.7 升级时，请先阅读 **[0.2.7 → 1.0 迁移指南](https://tdesign.tencent.com/flutter/migration-1-0)**（[仓库版本](https://github.com/Tencent/tdesign-flutter/blob/release/1.0.0/tdesign-site/site/docs/migration-0.2.7-to-1.0.md)），按项目实际使用的组件迁移公共配置、参数、回调与业务流程。不能仅通过替换 `TD` 前缀完成升级；编译通过后，还需回归默认视觉、受控状态、确认/取消和异步操作。

### 🚨 Breaking Changes

- **公共 API 与运行环境**
  - 最低环境要求调整为 Flutter ≥ 3.32.0、Dart ≥ 3.8.0，移除历史 Flutter 版本适配依赖。（[#976](https://github.com/Tencent/tdesign-flutter/pull/976)）
  - 组件统一迁移到 `T` 前缀 API，移除旧构造、样式及辅助类型的兼容入口；从 0.2.7 升级时需按迁移指南调整参数、回调与业务组合，不能仅替换前缀。（[#907](https://github.com/Tencent/tdesign-flutter/pull/907)、[#967](https://github.com/Tencent/tdesign-flutter/pull/967)）
- `TThemeData`
  - 统一全局 Token、组件 Theme、局部主题和实例配置的职责，移除重复的样式与行为入口；内置文字、图标、控件、Tooltip、反馈及滚动表现由 TDesign 配置控制，不再继承外部 Material/M2/M3 的默认或显式配置，自定义内容保留调用方主题。（[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
  - 调整语义 Token 名称及默认颜色、字体、间距和圆角；`grayColor3/5/11` 分别调整为 `#E7E7E7`、`#C5C5C5`、`#383838`，Gy4 修正为 `#DCDCDC`。依赖旧 Token 或默认视觉的应用需复核主题。（[#1104](https://github.com/Tencent/tdesign-flutter/pull/1104)、[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
  - 主题复制统一使用 `copyWith(name: ..., spacerMap: ...)`，移除旧复制包装、`ofColor/ofFont/ofCorner/ofFontFamily/ofShadow/ofExtra` 和公开 `parseThemeData`；`copyWith/lerp` 返回 `TThemeData`。（[#1152](https://github.com/Tencent/tdesign-flutter/pull/1152)）
- `TIcon / TIcons`：图标迁移到 `TIcon` 与独立图标包的 `TIcons`；旧 `all` 改为 `allIconsMap`，部分旧图标名称不再提供同名常量，替代方式见迁移指南；独立 `TIcon` 默认尺寸为 24dp，颜色为主文字色。（[#967](https://github.com/Tencent/tdesign-flutter/pull/967)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TButton`
  - 统一尺寸、点击热区和圆角，移除 `filled` 与 `margin`；配色选择参数由 `colorScheme` 改为 `colorPreset`。（[#1039](https://github.com/Tencent/tdesign-flutter/pull/1039)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
  - 调整禁用态文字、描边与浅色描边背景，图标和文字默认间距由 8dp 改为 4dp；内置布局使用标准密度，`style.visualDensity` 不再生效，其他受支持的实例样式仍可配置。（[#1103](https://github.com/Tencent/tdesign-flutter/pull/1103)、[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
- `TText`
  - 普通文本与富文本统一对齐 Flutter 原生 Text 契约，内容参数改为必填；移除组件内字体下载、块背景、线性缩放、独立 package 和全局配置入口，改用原生能力组合。（[#1042](https://github.com/Tencent/tdesign-flutter/pull/1042)）
  - 移除实例级 `fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor`，单实例样式改用 `style: TextStyle(...)`，`font` 仍用于选择字体 Token；默认正文由 16dp/24dp 改为 14dp/22dp。（[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TDivider`：统一默认线条、文字、间距和垂直尺寸；垂直分割线默认左右间距由 8dp 改为 16dp。（[#1044](https://github.com/Tencent/tdesign-flutter/pull/1044)、[#1101](https://github.com/Tencent/tdesign-flutter/pull/1101)）
- `TLink`：移除互斥的 `variant`，改为独立组合下划线及前后图标；统一尺寸、状态和无障碍行为，配色参数由 `colorScheme` 改为 `colorPreset`。（[#1043](https://github.com/Tencent/tdesign-flutter/pull/1043)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TFab`
  - 默认动作层统一为 large/fill/primary，纯图标使用圆形、图文使用胶囊形；默认使用 TDesign add 图标、spacer4 和 shadowsMiddle，不再受父级 `TButtonThemeData` 影响，完整自定义使用 `child`。（[#1040](https://github.com/Tencent/tdesign-flutter/pull/1040)）
  - 调整 `TFabBounds` 在 right/bottom 坐标系下的 start/end 方向映射，并增加非负有限值校验。（[#1040](https://github.com/Tencent/tdesign-flutter/pull/1040)）
- `TForm`：字段约束统一使用 `validator`，移除 `TFormField.rules`；横向标签字号改为 16px，竖向保持 14px，表单根节点默认使用容器背景色。（[#1038](https://github.com/Tencent/tdesign-flutter/pull/1038)、[#1102](https://github.com/Tencent/tdesign-flutter/pull/1102)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TInput`
  - 移除 `label/multiline/showClearButton/decoration`，统一标签、多行输入、清除按钮及样式配置入口；仅有前置图标时，图标与输入内容间距改为 16px。（[#1038](https://github.com/Tencent/tdesign-flutter/pull/1038)、[#1102](https://github.com/Tencent/tdesign-flutter/pull/1102)）
  - 内置文字、提示词、选择高亮和默认编辑菜单使用 TDesign 配置；原生编辑、复制、选择、键盘与自定义前后缀内容保持原有职责。（[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
- `TTextarea`：移除 Material `decoration` 透传，由组件 Theme 管理容器与输入视觉；内置标题默认横排，原竖排效果使用 `layout: TTextareaLayout.vertical`，内置编辑视觉使用 TDesign 配置。（[#1038](https://github.com/Tencent/tdesign-flutter/pull/1038)、[#1111](https://github.com/Tencent/tdesign-flutter/pull/1111)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
- `TSearchBar`：取消按钮、自动聚焦和样式入口统一为 `actionText/onActionPressed/autofocus/TSearchBarThemeData`；内置文字、操作和编辑视觉使用 TDesign 配置。（[#1051](https://github.com/Tencent/tdesign-flutter/pull/1051)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
- `TCheckbox / TCheckboxGroup`
  - 默认指示器由方形改为圆形；普通模式默认显示分割线，末项和卡片模式不绘制分割线。需要旧效果时，显式配置方形主题或 `showDivider: false`。（[#1048](https://github.com/Tencent/tdesign-flutter/pull/1048)）
  - 带文案的普通模式最小高度按尺寸改为 48/56/64dp；标题和副标题默认最大行数改为 3/5，文字颜色由组件 Theme 或语义 Token 控制；横向卡片角标和勾选图标分别改为 24dp、12dp。（[#1048](https://github.com/Tencent/tdesign-flutter/pull/1048)）
- `TRadio / TRadioGroup`
  - 选中状态统一由 `TRadioGroup` 管理，数据项用法迁移到 `TRadioGroup.options`，通过 `child` 组合自定义布局；使用 `inline/block/card` variant 替代旧 `groupValue/onChanged/cardMode` 配置。（[#1119](https://github.com/Tencent/tdesign-flutter/pull/1119)）
  - 默认选中标记改为实心勾选图标，支持 `iconType` 配置；标题和副标题默认最大行数改为 3/5，普通模式默认显示分割线，卡片模式不显示分割线。（[#1049](https://github.com/Tencent/tdesign-flutter/pull/1049)）
- `TSwitch`：加载态改为独立 `loading` 参数，移除 `TSwitchVariant.loading`；未选中轨道默认使用组件背景激活色。（[#1050](https://github.com/Tencent/tdesign-flutter/pull/1050)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TRate`：移除 `TRateThemeData.showText`，评分文案统一由 `texts` 控制；整星点击、长按和拖动默认显示评分提示，可通过 `showValueIndicator: false` 关闭。（[#1056](https://github.com/Tencent/tdesign-flutter/pull/1056)）
- `TUpload`：文件点击回调统一为 `onFileTap`，取代 `onPreview/onRetry`。（[#1047](https://github.com/Tencent/tdesign-flutter/pull/1047)）
- `TCalendar`：`firstDayOfWeek` 改为 `TCalendarFirstDayOfWeek` 枚举，日期格模型改为不可变快照；使用日期受控值并通过 `value/onChanged` 更新，弹层与确认流程由业务组合。（[#942](https://github.com/Tencent/tdesign-flutter/pull/942)、[#953](https://github.com/Tencent/tdesign-flutter/pull/953)、[#1059](https://github.com/Tencent/tdesign-flutter/pull/1059)）
- `TPicker`：选择内容与弹层、标题和确认流程分离；父级未接收并回写 `onChanged` 时，滚轮停止后恢复受控 `value`，标准弹层可通过 `TPickerPopup` 组合。（[#921](https://github.com/Tencent/tdesign-flutter/pull/921)、[#926](https://github.com/Tencent/tdesign-flutter/pull/926)、[#1062](https://github.com/Tencent/tdesign-flutter/pull/1062)、[#1121](https://github.com/Tencent/tdesign-flutter/pull/1121)）
- `TDateTimePicker`：选择内容与业务确认流程分离，按受控值回写；弹层与标题操作使用 `TPickerPopup` 或 `TPopup` 组合。（[#921](https://github.com/Tencent/tdesign-flutter/pull/921)、[#926](https://github.com/Tencent/tdesign-flutter/pull/926)、[#1121](https://github.com/Tencent/tdesign-flutter/pull/1121)）
- `TCascader`：分支点击后等待调用方回写 `value` 再推进层级，业务需在 `onChanged` 中接收并回写候选路径。（[#1060](https://github.com/Tencent/tdesign-flutter/pull/1060)）
- `TPopup`
  - 统一使用 `TPopupOptions + TPopupHandle` 管理展示、关闭和结果；蒙层配置集中到 `TPopupOverlayConfig`，透明度写入颜色 alpha，动画时长使用 `TPopupOptions.animationDuration`。（[#946](https://github.com/Tencent/tdesign-flutter/pull/946)、[#1037](https://github.com/Tencent/tdesign-flutter/pull/1037)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
  - bottom/center 默认只展示 `child`，标题和操作通过 `headerBuilder + TPopupHeader` 组合，移除旧标题和确认/取消构建参数；生命周期使用 `onVisibleChange/onOpened/onClosed`。（[#1037](https://github.com/Tencent/tdesign-flutter/pull/1037)）
  - left/right 默认改为无圆角全高矩形；`useSafeArea` 默认改为 `false`，如需安全区避让须显式开启。（[#1037](https://github.com/Tencent/tdesign-flutter/pull/1037)）
- `TPopover`
  - 内容统一为必填 `Widget content`，默认位置为 `top`，按真实内容尺寸定位；`onTap/onLongTap` 改为无参数回调，内部 `TPopoverWidget` 不再作为公开入口。（[#1033](https://github.com/Tencent/tdesign-flutter/pull/1033)）
  - 配色选择从 Theme 移至实例，最终参数统一为 `colorPreset`，预设类型使用 `TPopoverColorPreset`；旧 dark/info/error 对应 defaultTheme/primary/danger。（[#1058](https://github.com/Tencent/tdesign-flutter/pull/1058)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TActionSheet`
  - 入口收敛为 `showList/showGrid`，移除分组入口；选择回调改为 `onSelected(item)`，`TActionSheetItem.value` 需提供稳定业务值。（[#1030](https://github.com/Tencent/tdesign-flutter/pull/1030)）
  - 宫格布局统一为互斥的 `TActionSheetGridLayout.fixed/paged/scroll`，内容固定居中；`itemHeight` 改为 `gridItemHeight`，移除 Theme 中的布局和状态字段，文字样式不再隐式覆盖图标颜色。（[#1030](https://github.com/Tencent/tdesign-flutter/pull/1030)）
  - 徽标最终统一为 `TBadgeConfig?`，按列表标题或宫格图标提供默认定位，自定义外观使用徽标配置组合。（[#1030](https://github.com/Tencent/tdesign-flutter/pull/1030)、[#1141](https://github.com/Tencent/tdesign-flutter/pull/1141)）
- `TDialog`：普通操作默认改为浅色填充；`actionsPadding/actionSpacing` 改为可空并从主题 Token 解析默认值；三项及以上混合角色操作默认按主要/危险优先排序。（[#1036](https://github.com/Tencent/tdesign-flutter/pull/1036)）
- `TDrawer`
  - 命令式入口改为 `showTDrawer`，内容使用声明式 `TDrawer`，移除 `TDrawerWidget`；方向、蒙层、顶部偏移和生命周期由展示入口管理。（[#1080](https://github.com/Tencent/tdesign-flutter/pull/1080)）
  - `hover/bordered/isShowLastBordered` 分别改为 `enableFeedback/showDivider/showLastDivider`；统一标题、正文、图标、分隔线及底部间距，`showDivider` 仅控制菜单项分隔线。（[#1080](https://github.com/Tencent/tdesign-flutter/pull/1080)）
- `TToast`
  - 移除 `infiniteDuration`，零或负时长统一表示不自动关闭；加载提示默认展示 2000ms。（[#1154](https://github.com/Tencent/tdesign-flutter/pull/1154)）
  - 遮罩参数 `preventTap` 改为 `preventScrollThrough`，用于禁止背景点击与滚动；middle 中心位置改为 Overlay 高度的 45%，按内容真实尺寸定位。（[#1154](https://github.com/Tencent/tdesign-flutter/pull/1154)）
- `TMessage`
  - 移除 `visible`，声明式展示由父级插入或移除组件；永久展示使用 `duration: null`，默认 3 秒自动关闭；默认位置连续展示替换上一条，显式不同 offset 可保留多条消息。（[#1035](https://github.com/Tencent/tdesign-flutter/pull/1035)）
  - `variant/TMessageVariant` 改为 `status/TMessageStatus`，操作区统一为 `Widget? action`；移除 `TMessageLink/link/onLinkPressed` 和 `defaultOffset`，统一默认条带、图标、字体与阴影视觉。（[#1035](https://github.com/Tencent/tdesign-flutter/pull/1035)）
- `TNoticeBar`
  - 前后内容统一为 `prefix/operation`，移除旧 `left/prefixIcon/right`；状态改由实例 `status` 驱动，移除 `TNoticeBarVariant` 及对应 Theme 字段。（[#1032](https://github.com/Tencent/tdesign-flutter/pull/1032)）
  - 轮播周期默认由 3 秒改为 2 秒；垂直轮播由 `direction + items` 驱动，非空 `items` 优先于 `content`，`operation` 可与 `suffixIcon` 共存。（[#1032](https://github.com/Tencent/tdesign-flutter/pull/1032)）
- `TLoading`：`size` 改为逻辑像素数值，默认 20，移除 `TLoadingSize`；动画默认时长由 2000ms 改为 800ms，图文排列默认由竖向改为横向。（[#1031](https://github.com/Tencent/tdesign-flutter/pull/1031)）
- `TSwipeCell`
  - 移除 `flutter_slidable`，控制器收敛为 `open(side)/close()`，移除二次确认、拖拽移除及互斥组等历史 API；操作项外观统一由 `TSwipeCellAction` 配置，`spacing` 改为 `iconLabelSpacing`，自定义 builder 不可混用内置视觉参数。（[#1021](https://github.com/Tencent/tdesign-flutter/pull/1021)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
  - 默认开关阈值由面板宽度的 50% 改为 30%，动画时长由 200ms 改为 600ms；图标尺寸改为 20、图文间距改为 8，新增默认左右内边距 16。（[#1021](https://github.com/Tencent/tdesign-flutter/pull/1021)）
- `TPullDownRefresh`：统一使用 `TPullDownRefresh`，移除 `TRefreshHeader/TRefreshThemeData`；默认 `loadingBarHeight=50`、`maxBarHeight=80`，触发阈值由 48 改为 50。（[#1029](https://github.com/Tencent/tdesign-flutter/pull/1029)）
- `TTabsBar`：形态统一为 `line/tag/card`，调整 Tag 主题字段和默认视觉；移除 `TTab.badge`，改用 `TTab(child: TBadge(child: ...))` 组合。（[#1072](https://github.com/Tencent/tdesign-flutter/pull/1072)）
- `TTabBar`
  - 将 `variant` 拆分为 `type/itemStyle/style`，`useVerticalDivider` 改为 `split`；移除重复的 Theme 与实例配置及内部适配类型，包括 `centerDistance/showTopBorder/topBorder/placeholder`。（[#1085](https://github.com/Tencent/tdesign-flutter/pull/1085)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
  - 徽标统一使用 `TBadgeConfig?`，替代旧 `TTabBarBadgeConfig/badgeConfig`，按文本、图标和图文模式提供默认定位；双层菜单默认宽度下限改为 107px，显式 `popUpWidth` 仍可覆盖。（[#1085](https://github.com/Tencent/tdesign-flutter/pull/1085)、[#1138](https://github.com/Tencent/tdesign-flutter/pull/1138)、[#1141](https://github.com/Tencent/tdesign-flutter/pull/1141)）
- `TSideBar`：`style` 改为非空 `variant`（line/tag），默认宽度改为 103；徽标使用 `TBadgeConfig?`，默认定位在文字右上角；移除 Theme 的 `style/height/selectedColor`，选中样式统一通过 `selectedTextStyle` 配置。（[#1083](https://github.com/Tencent/tdesign-flutter/pull/1083)、[#1141](https://github.com/Tencent/tdesign-flutter/pull/1141)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TNavBar`
  - 默认不显示返回按钮，返回图标改为 24；标题统一为 `Widget? title`，默认使用 Title Large，提供 `onBack` 时不再自动返回；移除独立字体配置、`TBarItemAction` 和 `TNavBarItem.toWidget`。（[#1082](https://github.com/Tencent/tdesign-flutter/pull/1082)）
  - `height/useBorderStyle` 收敛为非空实例参数；`TNavBarThemeData.copyWith` 使用强类型参数，传入 `null` 表示保留原值。（[#1082](https://github.com/Tencent/tdesign-flutter/pull/1082)、[#1136](https://github.com/Tencent/tdesign-flutter/pull/1136)）
- `TIndexes`：吸顶、方向和胶囊模式统一由组件实例管理，移除 Theme 中的同义状态入口；调整侧栏、按压提示和锚点的默认尺寸、字体、颜色及间距。（[#1081](https://github.com/Tencent/tdesign-flutter/pull/1081)）
- `TBackTop`：`shape/visibilityOffset` 使用非空实例默认值，移除 Theme 同义状态；`onPressed` 改为回顶完成通知，配色参数统一为 `colorPreset`。（[#1079](https://github.com/Tencent/tdesign-flutter/pull/1079)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TSteps`：使用 `TSteps.progress/selectable/display` 区分进度、可选择和纯展示模式，以 `indicator/onChange` 替代 `simple/readOnly/verticalSelect`；`success` 状态更名为 `process`，`successIcon` 更名为 `icon`，移除持有业务模式的 Theme。（[#1084](https://github.com/Tencent/tdesign-flutter/pull/1084)）
- `TBadge`：默认形态更名为 `circle`，移除 `TBadgeVariant.small`，尺寸使用 `TBadgeSize.medium/large`；统一预设、自定义及组合组件的徽标配置语义。（[#1071](https://github.com/Tencent/tdesign-flutter/pull/1071)、[#1141](https://github.com/Tencent/tdesign-flutter/pull/1141)）
- `TTag`
  - 移除 Theme 中的配色及 `isLight/isOutline`，实例使用 `colorPreset` 和 `variant`；四种旧布尔组合分别对应 dark/light/outline/lightOutline。（[#1058](https://github.com/Tencent/tdesign-flutter/pull/1058)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
  - 统一填充、描边、图标及关闭图标的尺寸和间距，方形圆角默认读取 `radiusSmall`；依赖旧尺寸的布局需复核。（[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TAvatarGroup`：调整默认描边、阴影及可见成员的尺寸继承，依赖旧头像缩放或描边表现的布局需复核。（[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TCell`：有主内容时，`note` 改用受约束的自然宽度分配。（[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)）
- `TCollapse`：展开状态统一由 `List<T> value/onChanged` 管理，移除旧 Panel 状态和索引回调 API。（[#1089](https://github.com/Tencent/tdesign-flutter/pull/1089)）
- `TImage`：形状和适配方式分别使用 `TImageShape` 与 `BoxFit`，默认改为方形和拉伸填充。（[#1087](https://github.com/Tencent/tdesign-flutter/pull/1087)）
- `TImageViewer`：关闭完成通过 `TImageViewer.show` 返回的 Future 感知，移除 `onClose` 和无实际蒙层区域的 `barrierDismissible`。（[#1091](https://github.com/Tencent/tdesign-flutter/pull/1091)）
- `TSwiper`
  - 分页、分页位置和页面效果由实例参数管理，移除 Theme 中的同义字段；控制图标尺寸统一使用 `controlStyle.iconSize`，移除 `controlIconSize`，控制按钮不再使用 `visualDensity`。（[#1095](https://github.com/Tencent/tdesign-flutter/pull/1095)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
  - 调整卡片缩放和淡化效果，使相邻卡片等比缩放、淡化并露出。（[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)）
- `TProgress`：使用 `.linear/.plump/.circular/.microCircular/.button/.microButton` 六个命名构造函数替代 `variant`；按形态统一有效参数、尺寸、圆角、标签位置和交互语义，线性进度百分比默认显示在右侧。（[#1092](https://github.com/Tencent/tdesign-flutter/pull/1092)、[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)）
- `TTable`：默认列宽改为自动均分，`TTableColumn.width` 改为可空；`onCellTap` 改用 `TTableCellContext`。（[#1140](https://github.com/Tencent/tdesign-flutter/pull/1140)）
- `TTreeSelect`：调整默认列宽，避免在 375px 容器中使用两列或三列布局时水平溢出。（[#1065](https://github.com/Tencent/tdesign-flutter/pull/1065)）
- `TResult`：状态统一为 `status/TResultStatus`，描述改为 `description`，替代旧 `variant/TResultVariant/subtitle`。（[#1093](https://github.com/Tencent/tdesign-flutter/pull/1093)）
- `TSkeleton`：预设构造的 `variant` 改为非空，原 `variant: null` 改用 `TSkeleton()`；自定义布局使用 `TSkeleton.custom(layout: ...)`。（[#1094](https://github.com/Tencent/tdesign-flutter/pull/1094)）
- `TFooter`：移除 `variant/width`，通过 `logo/links/text` 组合内容，未设置高度时由内容自然撑开；品牌内容可与说明文案共存，调整链接分隔间距和颜色。（[#1088](https://github.com/Tencent/tdesign-flutter/pull/1088)、[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)）
- `TEmpty`：移除场景枚举和内置操作参数，使用 `operation` Widget 组合操作区。（[#1086](https://github.com/Tencent/tdesign-flutter/pull/1086)）
- `TDropdownMenu`：`animationDuration` 改为可空，显式值优先于主题；单选和多选选项区默认最大高度改为 280dp，超出后在面板内滚动，可通过 `maxHeight` 覆盖。（[#1034](https://github.com/Tencent/tdesign-flutter/pull/1034)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）

### 🚀 Features

- `TButton`：新增渐变背景能力。（[#1005](https://github.com/Tencent/tdesign-flutter/pull/1005)、[#1007](https://github.com/Tencent/tdesign-flutter/pull/1007)、[#1010](https://github.com/Tencent/tdesign-flutter/pull/1010)、[#1018](https://github.com/Tencent/tdesign-flutter/pull/1018)、[#1021](https://github.com/Tencent/tdesign-flutter/pull/1021)）
- `TIcon / TIcons`：图标包升级至 0.0.6，新增 `tablet`、`tablet-filled` 图标。（[#1045](https://github.com/Tencent/tdesign-flutter/pull/1045)）
- `TText`：支持 `TextScaler`、语义标识和文本选区颜色，未显式设置缩放时遵循系统无障碍策略。（[#1042](https://github.com/Tencent/tdesign-flutter/pull/1042)）
- `TForm`：支持字段级校验、清除校验状态和外部错误注入。（[#1038](https://github.com/Tencent/tdesign-flutter/pull/1038)）
- `TSearchBar`：支持加权字数限制、受控操作按钮、焦点回调和实例级文字对齐。（[#1051](https://github.com/Tencent/tdesign-flutter/pull/1051)）
- `TUpload`：新增列表布局 `TUploadLayout.list`、长按拖拽排序 `draggable` 和可重试失败状态 `retryableError`。（[#1047](https://github.com/Tencent/tdesign-flutter/pull/1047)）
- `TDateTimePicker`：新增月日选择模式。（[#1061](https://github.com/Tencent/tdesign-flutter/pull/1061)）
- `TPicker`：新增 `TPickerPopup.show`，统一 Picker 与 DateTimePicker 的标准弹层尺寸和配置。（[#1121](https://github.com/Tencent/tdesign-flutter/pull/1121)）
- `TCascader`：支持按活动层级展示次级标题。（[#1060](https://github.com/Tencent/tdesign-flutter/pull/1060)）
- `TPopover`：新增 `TPopoverAnchor` 与 `TPopoverController`，支持 `open/close/isOpen` 控制展示。（[#1099](https://github.com/Tencent/tdesign-flutter/pull/1099)）
- `TDialog`：新增可选 `barrierResult/closeButtonResult`，用于区分蒙层与关闭按钮的关闭来源。（[#1036](https://github.com/Tencent/tdesign-flutter/pull/1036)）
- `TDrawer`：`showTDrawer` 新增蒙层点击通知 `onOverlayClick` 和关闭后销毁策略 `destroyOnClose`。（[#1080](https://github.com/Tencent/tdesign-flutter/pull/1080)）
- `TToast`：支持可见半透明蒙层，并可独立控制是否拦截背景交互。（[#1018](https://github.com/Tencent/tdesign-flutter/pull/1018)、[#1154](https://github.com/Tencent/tdesign-flutter/pull/1154)）
- `TSwipeCell`：面板展开后，点击本格或外部区域可自动关闭。（[#1021](https://github.com/Tencent/tdesign-flutter/pull/1021)）
- `TPullDownRefresh`：默认启用 3 秒刷新超时，超时通过 `onStateChanged(timeout)` 通知并自动结束刷新，`refreshTimeout: null` 可关闭；配置 `onLoadMore` 后支持按 `lowerThreshold` 触底加载。（[#1029](https://github.com/Tencent/tdesign-flutter/pull/1029)）
- `TTabsBar`：新增 small/large 尺寸和 `disabledLabelStyle` 禁用标签样式入口。（[#1072](https://github.com/Tencent/tdesign-flutter/pull/1072)、[#1100](https://github.com/Tencent/tdesign-flutter/pull/1100)）
- `TTabBar`：新增 `iconTextLayout`，支持图标与文字左右排列。（[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TIndexes`：新增 `initialIndex` 初始定位与 `useSafeArea` 安全区配置；竖向索引条超高时支持滚动和点击选择，未溢出时支持拖动选择。（[#1081](https://github.com/Tencent/tdesign-flutter/pull/1081)、[#1117](https://github.com/Tencent/tdesign-flutter/pull/1117)、[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- `TBackTop`：新增 light/dark 配色预设及视觉定制字段。（[#1079](https://github.com/Tencent/tdesign-flutter/pull/1079)）
- `TBadge`：新增方形、气泡、左右带状角标和左右三角角标，支持位置偏移；通过 `TBadge.custom/TBadgeConfig` 统一预设、自定义和组合徽标。（[#1071](https://github.com/Tencent/tdesign-flutter/pull/1071)、[#1106](https://github.com/Tencent/tdesign-flutter/pull/1106)、[#1141](https://github.com/Tencent/tdesign-flutter/pull/1141)）
- `TTag`：支持在组件 Theme 中分别定制 danger/success 基础色和 success 浅色填充。（[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TAvatar`：新增形状、实例颜色及字符文字样式配置。（[#1090](https://github.com/Tencent/tdesign-flutter/pull/1090)）
- `TAvatarGroup`：新增成员尺寸和方向感知的层叠配置。（[#1090](https://github.com/Tencent/tdesign-flutter/pull/1090)）
- `TCollapse`：新增 `leadingBuilder/trailingBuilder` 组合标题前后内容；`expandIconBuilder` 可替换展开图标，显式传入 `null` 可隐藏。（[#1089](https://github.com/Tencent/tdesign-flutter/pull/1089)）
- `TImage`：新增 `onLoad/onError` 事件，空来源显示加载态、空字符串显示失败态；完善图片类型及默认、自定义加载和失败提示。（[#1087](https://github.com/Tencent/tdesign-flutter/pull/1087)）
- `TImageViewer`：支持双击、双指缩放和下拉关闭，放大时自动暂停切图与轮播。（[#1091](https://github.com/Tencent/tdesign-flutter/pull/1091)）
- `TSwiper`：支持实例级切换时长、动画曲线和相邻卡片缩放效果。（[#1095](https://github.com/Tencent/tdesign-flutter/pull/1095)）
- `TProgress`：支持常规、警告、错误和成功状态、状态图标、百分比、线性渐变，以及辅助技术可读的进度描述。（[#1092](https://github.com/Tencent/tdesign-flutter/pull/1092)）
- `TTable`：新增 `onRowTap`、实例级 `bordered/stripe`、行 key、合并单元格、列最小宽度和固定高度，优化排序、固定列及横向滚动交互。（[#1140](https://github.com/Tencent/tdesign-flutter/pull/1140)）
- `TResult`：统一内置状态图标、字号与间距，支持通过 `iconSize/descriptionStyle` 定制图标和描述样式。（[#1093](https://github.com/Tencent/tdesign-flutter/pull/1093)）
- `TSlider`：新增 normal/capsule 视觉形态，统一胶囊轨道、游标和刻度绘制。（[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）

### 🐞 Bug Fixes

- `TThemeData`：修复稀疏自定义深色 JSON 的未配置背景、文字及引用错误回退为浅色 Token 的问题。（[#1169](https://github.com/Tencent/tdesign-flutter/pull/1169)）
- `TButton`
  - 修复渐变 outline/ghost 按钮尺寸与普通按钮不一致，以及 Loading 图标未继承按钮前景色的问题。（[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
  - 修复实例样式仅覆盖部分状态时丢失默认配色、边框或尺寸，以及幽灵按钮文字与描边未跟随自定义反色主题的问题。（[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)、[#1169](https://github.com/Tencent/tdesign-flutter/pull/1169)）
- `TText`：修复实例与组件 Theme 的样式优先级、子 Span 样式继承，以及内置单行文字在固定内容槽中的垂直偏移，保留多行正文、显式排版和自定义内容。（[#1042](https://github.com/Tencent/tdesign-flutter/pull/1042)、[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- `TFontLoader`：并发加载共享 Future，加载失败可重试，并拒绝同名字体切换 URL。（[#1042](https://github.com/Tencent/tdesign-flutter/pull/1042)）
- `TForm`：修复校验时机、错误状态和 placeholder 的主题优先级，以及横排表单标签的间距与行高。（[#1038](https://github.com/Tencent/tdesign-flutter/pull/1038)、[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
- `TInput`
  - 修复密文模式无法粘贴、错误态清除图标配色，以及超长标签、图形/短信验证码操作区和输入内容的对齐与分割线问题。（[#1005](https://github.com/Tencent/tdesign-flutter/pull/1005)、[#1007](https://github.com/Tencent/tdesign-flutter/pull/1007)、[#1010](https://github.com/Tencent/tdesign-flutter/pull/1010)、[#1018](https://github.com/Tencent/tdesign-flutter/pull/1018)、[#1021](https://github.com/Tencent/tdesign-flutter/pull/1021)、[#1102](https://github.com/Tencent/tdesign-flutter/pull/1102)、[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
  - 修复输入及提示文字的自然行框布局，保留原生编辑、焦点、选择与前后插槽内容。（[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- `TTextarea`：修复横排标签与输入提示文字未对齐的问题。（[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
- `TSearchBar`：修复背景高度、禁用操作文字、只读态清除按钮及中文输入法组合文本截断问题。（[#1051](https://github.com/Tencent/tdesign-flutter/pull/1051)）
- `TCheckbox / TCheckboxGroup`：修复单行、多行和卡片文案对齐、禁用未选样式、卡片间距及分割线起点和残留线问题；方形指示器圆角修正为 1.5px。（[#1104](https://github.com/Tencent/tdesign-flutter/pull/1104)、[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)、[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
- `TRadio / TRadioGroup`：修复群组分割线、横向间距、未选禁用态、状态文案和卡片内容安全间距。（[#1119](https://github.com/Tencent/tdesign-flutter/pull/1119)）
- `TSwitch`：修复长状态文案被额外缩字或不可读省略的问题，保留显式尺寸和两种状态的组件字号。（[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- `TRate`：修复整星小数归一化、半星及 RTL 命中、拖动清零、交互生命周期、读屏信息和长文案布局；统一辅助文案的垂直对齐、默认颜色及未显式配置的字体属性。（[#1056](https://github.com/Tencent/tdesign-flutter/pull/1056)、[#1070](https://github.com/Tencent/tdesign-flutter/pull/1070)、[#1108](https://github.com/Tencent/tdesign-flutter/pull/1108)）
- `TStepper`：修复编辑草稿后加减按钮边界状态未及时更新、数字跨平台垂直对齐、三档尺寸行高，以及未设置主题字段时的尺寸和颜色插值问题。（[#1064](https://github.com/Tencent/tdesign-flutter/pull/1064)、[#1122](https://github.com/Tencent/tdesign-flutter/pull/1122)）
- `TUpload`：修复异步或重复选择时覆盖最新文件、丢失已添加文件，以及使用过期回调和文件限制的问题；区分选择器错误与业务回调异常。（[#1151](https://github.com/Tencent/tdesign-flutter/pull/1151)、[#1153](https://github.com/Tencent/tdesign-flutter/pull/1153)）
- `TCalendar`：修复日期文字默认颜色，日期、星期和月份区域按内容适配，保留显式高度、自定义 builder 和日期选择能力。（[#1118](https://github.com/Tencent/tdesign-flutter/pull/1118)、[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- `TPicker`
  - 修复受控值更新导致拖动和惯性中断，以及选项文字跨平台对齐、滚轮高度不足、弹层内容裁切和滚动后中心项偏移的问题。（[#1062](https://github.com/Tencent/tdesign-flutter/pull/1062)、[#1120](https://github.com/Tencent/tdesign-flutter/pull/1120)、[#1121](https://github.com/Tencent/tdesign-flutter/pull/1121)、[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
  - 修复局部文字主题覆盖选中状态样式及高度主题插值异常；自定义 `itemBuilder` 保留调用方滚动配置和内置滚轮交互。（[#1076](https://github.com/Tencent/tdesign-flutter/pull/1076)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
- `TDateTimePicker`：修复候选值被父级拒绝后的自动回滚，以及文案回调或展示配置更新导致滚轮重建、连续拖动和惯性中断的问题。（[#1061](https://github.com/Tencent/tdesign-flutter/pull/1061)、[#1159](https://github.com/Tencent/tdesign-flutter/pull/1159)）
- `TCascader`：修复受控交互、键盘操作、层级面板尺寸与主题回退，以及层级图标颜色和标题间距。（[#1060](https://github.com/Tencent/tdesign-flutter/pull/1060)、[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
- `TPopup`：修复标题默认出现诊断下划线的问题，保留显式文字装饰。（[#1062](https://github.com/Tencent/tdesign-flutter/pull/1062)）
- `TPopover`：修复角落气泡及箭头的 12px 边缘间距、切换触发器后首次点击只关闭旧气泡，以及动态主题切换时可空样式被错误插值为透明色或零值的问题。（[#1099](https://github.com/Tencent/tdesign-flutter/pull/1099)、[#1129](https://github.com/Tencent/tdesign-flutter/pull/1129)、[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)）
- `TActionSheet`：修复列表自适应高度、带描述项高度、空描述占位和长列表滚动；统一宫格图标槽位、描述间距、分页指示点、取消区及分隔线。（[#1030](https://github.com/Tencent/tdesign-flutter/pull/1030)、[#1123](https://github.com/Tencent/tdesign-flutter/pull/1123)）
- `TDialog`：修复长内容缺少可见滚动条和关闭图标实际边距不正确的问题。（[#1124](https://github.com/Tencent/tdesign-flutter/pull/1124)）
- `TToast`：修复允许背景交互时可见蒙层仍拦截点击的问题。（[#1154](https://github.com/Tencent/tdesign-flutter/pull/1154)）
- `TMessage`：修复图标与文字间距及默认左右外边距，跑马灯宽度和结束位置适配显式字体、字距与系统文字缩放，避免结束后残留文字。（[#1035](https://github.com/Tencent/tdesign-flutter/pull/1035)、[#1127](https://github.com/Tencent/tdesign-flutter/pull/1127)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
- `TNoticeBar`：修复跑马灯滚动距离及首帧宽度计算；前缀与正文间距统一跟随 `spacer8`，避免自定义图标缺少间距，并修复主题过渡时尺寸归零或颜色变透明的问题。（[#1032](https://github.com/Tencent/tdesign-flutter/pull/1032)、[#1128](https://github.com/Tencent/tdesign-flutter/pull/1128)）
- `TLoading`：修复 `customIcon` 在 `icon` 为空时的显示优先级，使其持续旋转并响应动画时长更新；修正 activity 指示器默认颜色。（[#1031](https://github.com/Tencent/tdesign-flutter/pull/1031)、[#1126](https://github.com/Tencent/tdesign-flutter/pull/1126)）
- `TFab`：修复拖拽返回起点附近的误触，磁吸改为可取消的平滑动画，新拖拽或布局变化可终止旧动画。（[#1040](https://github.com/Tencent/tdesign-flutter/pull/1040)）
- `TSwipeCell`：修复外层文字样式错误覆盖操作项默认反色文字的问题。（[#1131](https://github.com/Tencent/tdesign-flutter/pull/1131)）
- `TPullDownRefresh`：修复暗色模式下刷新状态文案层级过亮的问题。（[#1145](https://github.com/Tencent/tdesign-flutter/pull/1145)）
- `TTabsBar`：修复自定义标签使用 Column/Expanded 时的高度约束异常，保持内置标签居中及默认胶囊高度。（[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- `TTabBar`：修复一次手势触发重复选中回调、指示器动画模式切换及连续切换时的位置跳变，并校正胶囊圆角和弱选中徽标定位；修复局部文字及菜单主题覆盖、面板背景和可空主题字段插值问题。（[#1085](https://github.com/Tencent/tdesign-flutter/pull/1085)、[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
- `TSideBar`：修复徽标偏离文字右上角，以及字体放大时远端选中项无法准确滚动显露的问题，不增加额外选择回调；修复主题过渡时回退样式被半透明颜色或零内边距临时覆盖的问题。（[#1135](https://github.com/Tencent/tdesign-flutter/pull/1135)、[#1137](https://github.com/Tencent/tdesign-flutter/pull/1137)、[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- `TIndexes`：修复主题切换时固定默认尺寸在动画中间态跳变的问题。（[#1137](https://github.com/Tencent/tdesign-flutter/pull/1137)）
- `TNavBar`：明确标题 Widget 自带样式优先于默认标题样式，修复主题切换时间距、边框和阴影跳变。（[#1082](https://github.com/Tencent/tdesign-flutter/pull/1082)、[#1136](https://github.com/Tencent/tdesign-flutter/pull/1136)）
- `TSteps`：修复局部文字主题覆盖失效和横向纯展示节点状态不一致的问题。（[#1084](https://github.com/Tencent/tdesign-flutter/pull/1084)）
- `TBadge`：修复中文、跨平台及文本缩放下的垂直对齐、默认位置和尺寸偏差，以及 bubble 被 Material 胶囊形状错误裁剪的问题。（[#1070](https://github.com/Tencent/tdesign-flutter/pull/1070)、[#1071](https://github.com/Tencent/tdesign-flutter/pull/1071)、[#1106](https://github.com/Tencent/tdesign-flutter/pull/1106)、[#1107](https://github.com/Tencent/tdesign-flutter/pull/1107)、[#1141](https://github.com/Tencent/tdesign-flutter/pull/1141)）
- `TAvatar / TAvatarGroup`：修复头像组形状裁剪、双向层叠、非法尺寸边界、成员尺寸、徽标圆点规格及主题动画插值问题。（[#1090](https://github.com/Tencent/tdesign-flutter/pull/1090)、[#1141](https://github.com/Tencent/tdesign-flutter/pull/1141)）
- `TTag`：修复配色和方角在动态主题切换时的中间帧跳变或意外半透明。（[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TCell`：修复辅助信息默认字号、右侧插槽对齐，以及局部文字 Theme 覆盖部分字段时丢失默认字号、行高和字重的问题。（[#1026](https://github.com/Tencent/tdesign-flutter/pull/1026)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TCollapse`：修复标题默认字重被上层主题意外加粗的问题。（[#1143](https://github.com/Tencent/tdesign-flutter/pull/1143)）
- `TImageViewer`：图片加载失败时显示错误占位，优化关闭动效、全屏背景、页码及顶部操作按钮的尺寸和交互状态。（[#1091](https://github.com/Tencent/tdesign-flutter/pull/1091)）
- `TSwiper`：修复默认圆角、卡片露出、fraction 胶囊、控制按钮及外置分页布局；修复显式按钮样式合并、状态回退与主题过渡，保留自定义图标及图层的调用方主题。（[#1095](https://github.com/Tencent/tdesign-flutter/pull/1095)、[#1157](https://github.com/Tencent/tdesign-flutter/pull/1157)）
- `TProgress`：修复按钮形态轨道和渐变绘制，以及自定义 Material 主色错误改写状态语义色，以及环形内圆在主题切换时跳变或意外半透明的问题。（[#1092](https://github.com/Tencent/tdesign-flutter/pull/1092)、[#1146](https://github.com/Tencent/tdesign-flutter/pull/1146)）
- `TResult`：修复主题切换时图标尺寸不稳定和部分文字样式覆盖丢失默认属性的问题；自定义插图保留原始比例，内置状态提供可读语义。（[#1093](https://github.com/Tencent/tdesign-flutter/pull/1093)）
- `TSkeleton`：统一占位色、16dp 行间距、图片圆角和 2 秒闪烁动效，改善预设与加载过程的视觉一致性。（[#1094](https://github.com/Tencent/tdesign-flutter/pull/1094)）
- `TSlider / TRangeSlider`：修复轨道、滑块、数值标签及禁用态配色，数值提示常驻显示，垂直标签保持正向；修复 Flutter 3.47 下连续/离散滑块的提示兼容问题。（[#1010](https://github.com/Tencent/tdesign-flutter/pull/1010)、[#1063](https://github.com/Tencent/tdesign-flutter/pull/1063)）
- `TTreeSelect`：补齐选中根节点左侧指示条。（[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
- `TTimeCounter`：修复动态启停、方向切换、终点回调和毫秒格式处理异常，统一三档尺寸及方形、圆形和单位倒计时展示。（[#1096](https://github.com/Tencent/tdesign-flutter/pull/1096)）
- `TDropdownMenu`：修复多列宽度不一致、蒙层透明度丢失、仿射滤镜越界拉伸时菜单与面板分离，以及禁用项背景和单选项错误文字高亮问题；统一菜单触发项与筛选面板的默认视觉。（[#1034](https://github.com/Tencent/tdesign-flutter/pull/1034)、[#1125](https://github.com/Tencent/tdesign-flutter/pull/1125)、[#1144](https://github.com/Tencent/tdesign-flutter/pull/1144)）
- **组件文字布局**：修复 Tag、Switch、选择卡片、ActionSheet、Progress、Refresh 和 Upload 等组件在默认尺寸下的文字裁切，保留显式尺寸与原生交互。（[#1160](https://github.com/Tencent/tdesign-flutter/pull/1160)）
- **Flutter 版本兼容**：修复 DropdownMenu、CupertinoSwitch 和 Swiper 的跨版本 API 兼容问题，兼顾 Flutter 3.32 与较新版本的行为。（[#1010](https://github.com/Tencent/tdesign-flutter/pull/1010)）

## 🌈 1.0.0-alpha.1 `2026-07-31`

> 这是 v1 的首个预发布版本，API 和视觉细节在正式版前仍可能调整。建议试用项目锁定
> `tdesign_flutter: 1.0.0-alpha.1`，并重点回归浮层、选择器、日历和轮播等重构组件。

### 💥 Breaking Changes

- 完成 v1 API 预发布迁移，组件统一使用 `T` 前缀并移除旧版兼容参数。
- 组件视觉默认值统一接入 Flutter `ThemeData` 与 TDesign ThemeExtension。
- 样式支持应用级 Token、全局组件 ThemeData、局部子树 ThemeData 和单实例显式参数四级控制；局部覆盖统一使用 `mergeExtension`。
- 受控组件需在回调中回写状态；业务创建的 Controller 由业务释放；Overlay 必须使用目标 Theme/Navigator 子树的 context。
- `TSwiper` 改为 `TSwiperController` 驱动；`TBadge` 使用语义化 `label` 展示数字或自定义短文本。
- Calendar 改为 `DateTime` 受控值；Picker、DateTimePicker 与 Cascader 只负责选择，标题、确认和弹层由业务组合。
- Popup 改为 `TPopupOptions + TPopupHandle`，Dialog 改为统一内容槽位与 `TDialogAction`。

### 🚀 Features

- `TSwiper` 支持 autoplay 生命周期管理、真实卡片视口、横竖布局、外置分页、自定义标记和自定义前后按钮。
- Popup、ActionSheet、NavBar、FAB 与 Message 统一安全区契约，默认启用且支持显式关闭。

### 🐞 Bug Fixes

- 修复 Popup 五向默认尺寸与 center 安全区行为。
- 修复 Checkbox、Radio 热区未围绕视觉控件居中的问题。
- 修复 ImageViewer 与 Swiper 实际页码、Controller 生命周期和动态数据同步。

## 🌈 0.2.7 `2026-01-21`

### 🚀 Features

- `TInput`: TInput密文模式下支持粘贴 @jflin19990707 ([#827](https://github.com/Tencent/tdesign-flutter/pull/827))
- `TDropdownMenu`: TDropdownMenu的arrowIcon颜色可自定义 @jflin19990707 ([#831](https://github.com/Tencent/tdesign-flutter/pull/831))
- `TInput`: TInput高度自适应 @jflin19990707 ([#840](https://github.com/Tencent/tdesign-flutter/pull/840))
- `TCalendar`: 允许月历控件在拖动后返回当前月份,用于延迟加载月份改变数据 @rxnh8256 ([#816](https://github.com/Tencent/tdesign-flutter/pull/816))
- `TActionSheetItem`: 支持设置cell描述信息的能力 @leenc123 ([#811](https://github.com/Tencent/tdesign-flutter/pull/811))
- `TBottomTabBar`: tabbar新增indicatorAnimation动画属性 @journeyding ([#848](https://github.com/Tencent/tdesign-flutter/pull/848))

### 🐞 Bug Fixes

- `TPopup`: 底部弹出popup重绘问题 @jflin19990707 ([#826](https://github.com/Tencent/tdesign-flutter/pull/826))
- `TDropdownMenu`: TDropdownMenu分组菜单多选模式下的返回值bug @jflin19990707 ([#828](https://github.com/Tencent/tdesign-flutter/pull/828))
- `TTable`: TTable中TDTableCol的索引BUG @jflin19990707 ([#830](https://github.com/Tencent/tdesign-flutter/pull/830))
- `TTreeSelect`: 树形选择器异步数据更新后能重新渲染；二级菜单文字过长处理一下；TSelectOption中的value改为dynamic类型 @jflin19990707 ([#834](https://github.com/Tencent/tdesign-flutter/pull/834))
- `TToast`: TToast过长溢出问题 @jflin19990707 ([#839](https://github.com/Tencent/tdesign-flutter/pull/839))
- `TDropdownItem`: TDropdownItem不兼容TDMultiCascader @jflin19990707 ([#846](https://github.com/Tencent/tdesign-flutter/pull/846))
- `TCalendar`: 自定义日期单元格组件移除padding，使之沾满并覆盖默认选中样式从而实现自定义选中以及当前日期的样式问题,并增加日期锚点属性来实现自动滚动到锚点位置 @leenc123 ([#808](https://github.com/Tencent/tdesign-flutter/pull/808))
- `DropdownMenu`: 修复 item 的 label 过长时导致显示不完全的 bug @edram ([#823](https://github.com/Tencent/tdesign-flutter/pull/823))
- `TRadio`、`TCheckbox`: 单选框、多选框多列展示问题 @jflin19990707 ([#841](https://github.com/Tencent/tdesign-flutter/pull/841))
- `TNavBar`: 优化标题栏返回图标 支持暗黑模式 @sinianbao ([#844](https://github.com/Tencent/tdesign-flutter/pull/844))

### 🚧 Others

- docs: 更新主题生成器文档，添加视频演示链接 @RSS1102 ([#833](https://github.com/Tencent/tdesign-flutter/pull/833))

## 🌈 0.2.6 `2025-11-14`

### 🚀 Features

- `TNoticeBar`: Added `content` property, deprecated and compatible with the original context property @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))
- `TButton`: Added gradient color background @jflin19990707 ([#773](https://github.com/Tencent/tdesign-flutter/pull/773))
- `TToast`: TToast supports displaying multiple toasts @jflin19990707 ([#780](https://github.com/Tencent/tdesign-flutter/pull/780))
- `TUpload`: Added custom upload listener @leenc123 ([#775](https://github.com/Tencent/tdesign-flutter/pull/775))
- `TTable`: Added custom footer property @leenc123 ([#776](https://github.com/Tencent/tdesign-flutter/pull/776))

### 🐞 Bug Fixes

- `TMultiCascader`: Fixed initialIndexes parameter not taking effect @epoll-j ([#752](https://github.com/Tencent/tdesign-flutter/pull/752))
- `TDialog`: Fixed button text overflow issue @jflin19990707 ([#772](https://github.com/Tencent/tdesign-flutter/pull/772))
- `TDateTimePicker`: Changed English configuration for date, hour, minute, second to abbreviations @jflin19990707 ([#770](https://github.com/Tencent/tdesign-flutter/pull/770))
- `TCell`: Fixed overflow issue when note is too long @jflin19990707 ([#769](https://github.com/Tencent/tdesign-flutter/pull/769))
- `TCell`: Fixed alignment issue between icon and text in the cell @runoob-coder ([#789](https://github.com/Tencent/tdesign-flutter/pull/789))
- `TProgress`: Fixed style issue when progress bar changes @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))

### 📝 Documentation

- `docs`: Optimized document format and content @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))

### 🚧 Others

- Components fully adapted to dark mode, optimized and adjusted component styles (experimental version) @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))
- `demo`: Optimized and adjusted demo example project and code demonstrations, upgraded Android build configuration and dependencies to be compatible with Flutter from `3.16.9` to the latest version (`3.35.5`), adjusted web preview iframe style to remove top margin @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))
- `web`: Overridden web dependencies, resolved version conflict with flutter_localizations, compatible with previous Flutter versions @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))

## 🌈 0.2.5 `2025-09-12`

### 🐞 Bug Fixes

- `TPopover`: Added custom corner radius property @jflin19990707 ([#727](https://github.com/Tencent/tdesign-flutter/pull/727))
- `TForm`: Added custom background color property for form, button part can be optional @jflin19990707 ([#730](https://github.com/Tencent/tdesign-flutter/pull/730))
- `TConfirmDialog`: Dialog supports custom width, buttons added custom style properties @jflin19990707 ([#724](https://github.com/Tencent/tdesign-flutter/pull/724))
- `TPicker`: Supports initialization and subsequent dynamic loading of appropriate data, fixes stuttering issues @123dw-bot ([#728](https://github.com/Tencent/tdesign-flutter/pull/728))
- `TSideBar`: Added custom unselected color property @jflin19990707 ([#723](https://github.com/Tencent/tdesign-flutter/pull/723))

### 🚧 Others

- docs: Optimized repository size @RSS1102

## 🌈 0.2.4 `2025-08-14`

### 🚀 Features

- `TUpload`: Support setting image spacing and alignment @cyjaysong ([#677](https://github.com/Tencent/tdesign-flutter/pull/677))
- `TTreeSelect`: Added custom width and max lines fields, fixed fixed width for second level and long text overflow issues @123dw-bot ([#694](https://github.com/Tencent/tdesign-flutter/pull/694))
- `TDropdownMenu`: Added TDropdownItemController to allow external reset and change of dropdown options @Luozf12345 ([#697](https://github.com/Tencent/tdesign-flutter/pull/697))
- `TStepper`: Added controller parameter to Stepper for real-time value modification @Luozf12345 ([#699](https://github.com/Tencent/tdesign-flutter/pull/699))

### 🐞 Bug Fixes

- `TIndexes`: Fixed issue where custom indexes could not respond to click events @epoll-j ([#692](https://github.com/Tencent/tdesign-flutter/pull/692))
- `TPopup`: Fixed bug where close method was triggered twice @epoll-j ([#690](https://github.com/Tencent/tdesign-flutter/pull/690))
- `TSideBar`: Fixed issue where children of TSideBar component could not be updated after initialization @Luozf12345 ([#698](https://github.com/Tencent/tdesign-flutter/pull/698))

### 🚧 Others

- `Misc`: Restored default adaptation for flutter SDK version 3.32

## 🌈 0.2.3 `2025-07-09`

### 🚀 Features

- `TPicker`: Supports prioritizing the retention of cascaded option values when switching @epoll-j ([#666](https://github.com/Tencent/tdesign-flutter/pull/666))
- `TTable`: Supports default row selection @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))
- `TCalendar`: Adds custom date cell functionality @epoll-j ([#667](https://github.com/Tencent/tdesign-flutter/pull/667))
- `TForm`: Adds Form component @shizhe2018 @SimonWuZY ([#620](https://github.com/Tencent/tdesign-flutter/pull/620))
- `TTable`: Separates TTableCol attribute configuration and empty data configuration @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))

### 🐞 Bug Fixes

- `TTable`: Fixes the issue with unselected icon display in table headers and the selection state problem under disabled conditions @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))
- `TTable`: Fixes the empty data issue in tables @ccXxx1aoBai ([#671](https://github.com/Tencent/tdesign-flutter/pull/671))
- `TDialog`: Fixes the issue where dialogs block the keyboard @jflin19990707 ([#669](https://github.com/Tencent/tdesign-flutter/pull/669))
- `TCollapse`: Updates the demo page name for collapse @jflin19990707 ([#670](https://github.com/Tencent/tdesign-flutter/pull/670))
- `TDropdownMenu`: Fixes the incorrect popup position calculation in nested routing scenarios @hcanyz ([#648](https://github.com/Tencent/tdesign-flutter/pull/648))

## 🌈 0.2.2 `2025-06-13`

### 🚀 Features

- `TTable`: Added support for row selection and custom row height. @ccXxx1aoBai ([#594](https://github.com/Tencent/tdesign-flutter/pull/594))
- `TTreeSelect`: Added partial multi-selection support. @epoll-j ([#587](https://github.com/Tencent/tdesign-flutter/pull/587))
- `TCell`: Added support for custom height and bottom divider. @ccXxx1aoBai ([#611](https://github.com/Tencent/tdesign-flutter/pull/611))
- `TNoticeBar`: Added support for custom number of text lines. @ccXxx1aoBai ([#611](https://github.com/Tencent/tdesign-flutter/pull/611))
- `TBottomTabBar`: Made onTap in TButtonBottomTabBar support repeated clicks. @epoll-j @RSS1102 ([#586](https://github.com/Tencent/tdesign-flutter/pull/586))
- `TBottomTabBar`: Implemented tap ripple effects. @RSS1102 ([#626](https://github.com/Tencent/tdesign-flutter/pull/626))
- `TAvatar`: Added custom BoxFit parameter. @shizhe2018 ([#633](https://github.com/Tencent/tdesign-flutter/pull/633))

### 🐞 Bug Fixes

- `TDatePicker`: Fixed minute-level time display issue and optimized hour/minute/second range calculation logic. @epoll-j ([#585](https://github.com/Tencent/tdesign-flutter/pull/585))
- `TSearchBar`: Added onTapOutside callback support. @cyjaysong ([#608](https://github.com/Tencent/tdesign-flutter/pull/608))
- `TDropdownMenu`: Added support for modifying selected icon color. @jflin19990707 ([#631](https://github.com/Tencent/tdesign-flutter/pull/631))
- `TTabBar`: Fixed text-icon conflict in TBottomTabBarBasicType.iconText mode. @jflin19990707 ([#628](https://github.com/Tencent/tdesign-flutter/pull/628))
- `TEmpty`: Added custom styling support for action buttons. @jflin19990707 ([#624](https://github.com/Tencent/tdesign-flutter/pull/624))
- `TToast`: Added custom text support for toast. @jflin19990707 ([#625](https://github.com/Tencent/tdesign-flutter/pull/625))
- `TPopup`: Modified \_measureChildHeight method to fix inability to adjust popup height via child component. @Jzow ([#591](https://github.com/Tencent/tdesign-flutter/pull/591))
- `TCascader`: Fixed empty state handling for query data. @shizhe2018 ([#635](https://github.com/Tencent/tdesign-flutter/pull/635))

### 🚧 Others

- Adapted for Flutter 3.32 version. @Luozf12345 ([#636](https://github.com/Tencent/tdesign-flutter/pull/636))

## 🌈 0.2.0 `2025-05-07`

### 🚀 Features

- `TCellGroup`: Added `titleBackgroundColor` property for cell group title background color. @runoob-coder ([#539](https://github.com/Tencent/tdesign-flutter/pull/539))
- `TLink`: Replaced link parameter `LinkObj` with `MessageLink`, adjusted `TLink` styles, and added click callback. @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))
- `TBottomTabBar`: Added custom title support for step bar component. @RSS1102 ([#576](https://github.com/Tencent/tdesign-flutter/pull/576))
- `TSlider`: Added slider tap event `onTap`. @RSS1102 ([#527](https://github.com/Tencent/tdesign-flutter/pull/527))
- `TCascader`: Added "Confirm" button at top-right corner to support selecting any option. @Luozf12345
- `ImageViewer`: Added single image deletion support. @ccXxx1aoBai ([#581](https://github.com/Tencent/tdesign-flutter/pull/581))
- `TPopup`: Added custom size properties for popup title, left text, right text, and close button. @Jzow ([#582](https://github.com/Tencent/tdesign-flutter/pull/582))
- `TBottomTabBarTabConfig`: Added `onLongPress` event triggered by long-pressing tabs. @RSS1102 ([#580](https://github.com/Tencent/tdesign-flutter/pull/580))

### 🐞 Bug Fixes

- `TFooter`: Fixed content overflow issue in link mode. @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))
- `TUpload`: Fixed file size limit error. @epoll-j ([#544](https://github.com/Tencent/tdesign-flutter/pull/544))
- `TImageViewer`: Added Swiper component property passthrough, click events, and style properties; supports custom buttons. @ccXxx1aoBai ([#561](https://github.com/Tencent/tdesign-flutter/pull/561))
- `TSlider`: Fixed edge drag failure and value/scale display issues in capsule type with range. @qfish ([#567](https://github.com/Tencent/tdesign-flutter/pull/567))
- `TInput`: Fixed width calculation defect for non-Chinese label input fields. @Jzow ([#564](https://github.com/Tencent/tdesign-flutter/pull/564))
- `TPopup`: Fixed inability to modify popup height via `height` in child component. @Jzow ([#571](https://github.com/Tencent/tdesign-flutter/pull/571))
- `TDropdownMenu`: Fixed single-select failure in specific scenarios. @1jialong ([#575](https://github.com/Tencent/tdesign-flutter/pull/575))
- `TToast`: Fixed multi-line text display issue. @Luozf12345
- `TPopup`: Fixed horizontal line display issue when popup lacks outer Scaffold. @Luozf12345

### 🚧 Others

- `TFooter`: Refactored `TFooter` component; Removed `LinkObj` class and directly used `TLink` class; Removed `isWithUnderline` parameter (link styles now set in `TLink`). @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))

## 🌈 0.1.9 `2025-03-31`

### 🚀 Features

- `TProgress`: Added `Progress` component @CORCTON ([#307](https://github.com/Tencent/tdesign-flutter/pull/307))
- `TMessage`: Added `Message` (Global Prompt) component @chendingya ([#316](https://github.com/Tencent/tdesign-flutter/pull/316))
- `TSkeleton`: Added `Skeleton` component @Ezer015 ([#317](https://github.com/Tencent/tdesign-flutter/pull/317))
- `TFooter`: Added `Footer` component @chendingya ([#224](https://github.com/Tencent/tdesign-flutter/pull/224))
- `TPopover`: Added `Popover` (Popup Bubble) component @ccXxx1aoBai ([#435](https://github.com/Tencent/tdesign-flutter/pull/435))
- `TSwitch`: Added custom "ON/OFF" font size support @shinyina ([#217](https://github.com/Tencent/tdesign-flutter/pull/217))
- `TDatePicker`: Added `filterItems` parameter for custom display options and `itemBuilder` for custom item rendering @hkaikai ([#426](https://github.com/Tencent/tdesign-flutter/pull/426))
- `TDrawer`: Created `TDrawerWidget` component compatible with Scaffold's drawer property @hkaikai ([#445](https://github.com/Tencent/tdesign-flutter/pull/445))
- `TTable`: Custom columns now return current row number @ccXxx1aoBai ([#457](https://github.com/Tencent/tdesign-flutter/pull/457))
- `TUpload`: Added width/height settings and quick replacement configuration support @HubuHito ([#462](https://github.com/Tencent/tdesign-flutter/pull/462))
- `TButton`: Added icon position property @epoll-j ([#463](https://github.com/Tencent/tdesign-flutter/pull/463))
- `TDropdownMenu`: Supported single-select mode (`multiple == false`) with multi-column display (`optionsColumns > 1`) @hkaikai ([#502](https://github.com/Tencent/tdesign-flutter/pull/502))
- `TActionSheet`: Added Action Sheet component @hkaikai ([#485](https://github.com/Tencent/tdesign-flutter/pull/485))
- `TPicker`: Added `customSelectWidget` parameter @epoll-j ([#495](https://github.com/Tencent/tdesign-flutter/pull/495))
- `TSlider`: Added track color modification parameter @epoll-j ([#506](https://github.com/Tencent/tdesign-flutter/pull/506))
- `TCalendar`: Added animated scrolling to selected value position @hkaikai ([#509](https://github.com/Tencent/tdesign-flutter/pull/509))
- `TStep`: Added `CustomContent` parameter for Step content customization @Jzow ([#452](https://github.com/Tencent/tdesign-flutter/pull/452))
- `TTag`: Added `fixedWidth` parameter and fixed `TextOverflow.ellipsis` title overflow issue @Jzow ([#496](https://github.com/Tencent/tdesign-flutter/pull/496))
- `TPopup`: Added edge drag control for bottom panel @Jzow ([#514](https://github.com/Tencent/tdesign-flutter/pull/514))
- `TBadge`: Added capped numeric value setting for Badge @chendingya ([#302](https://github.com/Tencent/tdesign-flutter/pull/302))
- `TToast`: Added multi-line text support for icon-type toasts @ccXxx1aoBai ([#481](https://github.com/Tencent/tdesign-flutter/pull/481))

### 🐞 Bug Fixes

- `TRefreshHeader`: Upgraded Easy Refresh to latest version, improved compatibility between v2/v3 syntax @hkaikai ([#438](https://github.com/Tencent/tdesign-flutter/pull/438))
- `TCell`: Fixed unresponsive click in blank area without default style; Improved default style construction and demo usage @hkaikai ([#448](https://github.com/Tencent/tdesign-flutter/pull/448))
- `TTable`: Fixed empty data image display issue @ccXxx1aoBai ([#451](https://github.com/Tencent/tdesign-flutter/pull/451))
- `TTabBar`: Added `labelStyle` and `unselectedLabelStyle` support for custom font sizes @hkaikai ([#453](https://github.com/Tencent/tdesign-flutter/pull/453))
- `TCalendar`: Fixed positioning issue when scrolling to last month @hkaikai ([#449](https://github.com/Tencent/tdesign-flutter/pull/449))
- `TBottomTabBar`: Fixed background color setting for capsule type @epoll-j ([#497](https://github.com/Tencent/tdesign-flutter/pull/497))
- `TCalendar`: Added localization for confirm button @hkaikai ([#505](https://github.com/Tencent/tdesign-flutter/pull/505))
- `TUpload`: Added `onMaxLimitReached` callback to handle file limit overflow @Jzow ([#474](https://github.com/Tencent/tdesign-flutter/pull/474))
- `TInput`: Added `_getTextWidth` function and click event to fix incomplete text display @Jzow ([#475](https://github.com/Tencent/tdesign-flutter/pull/475))
- `TImage`: Removed mandatory custom width/height constraints (default 72px) for layout auto-calculation @Jzow ([#499](https://github.com/Tencent/tdesign-flutter/pull/499))
- `TConfirmDialog`: Added layout constraints and dynamic max-height calculation with scroll support @Jzow ([#510](https://github.com/Tencent/tdesign-flutter/pull/510))
- `TDrawer`: Added `_deleteRouter()` call in close function to force clear routes @Jzow ([#512](https://github.com/Tencent/tdesign-flutter/pull/512))
- `TText`: Fixed text alignment issue in HarmonyOS 3.22 @duleigiser ([#437](https://github.com/Tencent/tdesign-flutter/pull/437))
- `TAlertDialog`: Fixed button style not filling width @lvjs ([#460](https://github.com/Tencent/tdesign-flutter/pull/460))

### 🚧 Others

- `TSlider`: Demo code splitting @iamitis ([#245](https://github.com/Tencent/tdesign-flutter/pull/245))
- Added release date to "About Us" page @iamitis ([#304](https://github.com/Tencent/tdesign-flutter/pull/304))
- `Doc`: Updated README English version, added License file and Issue Doc templates @Jzow ([#458](https://github.com/Tencent/tdesign-flutter/pull/458))

## 🌈 0.1.8 `2024-12-30`

### 🚀 Features

- `TUpload`: Added Upload component @TingShine ([#405](https://github.com/Tencent/tdesign-flutter/pull/405))
- `SearchBar`: Added keyboard action type @ccXxx1aoBai ([#366](https://github.com/Tencent/tdesign-flutter/pull/366))
- `Cell`: CellGroup added style control parameters: cardBorderRadius (card mode border radius), cardPadding (card mode padding), titlePadding (title padding) @hkaikai ([#409](https://github.com/Tencent/tdesign-flutter/pull/409))
- `DropdownMenu`: Added decorator configuration: decoration, which can customize menu color and border @hkaikai ([#408](https://github.com/Tencent/tdesign-flutter/pull/408))
- `ImageViewer`: Supports displaying image titles @ccXxx1aoBai ([#411](https://github.com/Tencent/tdesign-flutter/pull/411))
- `Calendar`: Added monthTitleBuilder parameter @hkaikai ([#419](https://github.com/Tencent/tdesign-flutter/pull/419))
- `Calendar`: Added pickerHeight, pickerItemCount parameters to control the height of the time selection component @hkaikai ([#421](https://github.com/Tencent/tdesign-flutter/pull/421))
- `Toast`: Supports customizing the overlay background color @ccXxx1aoBai ([#423](https://github.com/Tencent/tdesign-flutter/pull/423))
- `Rate`: Supports disabled parameter @hkaikai ([#357](https://github.com/Tencent/tdesign-flutter/pull/357))
- `Calendar`: Modified CalendarBuilder return value to Widget @Luozf12345 ([#396](https://github.com/Tencent/tdesign-flutter/pull/396))
- `SearchBar`: Added read-only attribute and click event @shizhe2018 ([#393](https://github.com/Tencent/tdesign-flutter/pull/393))
- `Dialog`: TDialogButtonOptions added font size attribute @shizhe2018 ([#381](https://github.com/Tencent/tdesign-flutter/pull/381))
- `DateTimePicker`: Added time unit display attribute @shizhe2018 ([#383](https://github.com/Tencent/tdesign-flutter/pull/383))
- `Input`: Added additionInfo left and right display position @shizhe2018 ([#401](https://github.com/Tencent/tdesign-flutter/pull/401))

### 🐞 Bug Fixes

- `NoticeBar`: Fixed the issue of abnormal text display on the web @ccXxx1aoBai ([#351](https://github.com/Tencent/tdesign-flutter/pull/351))
- `Rate`: Fixed the issue where the onChange event was not triggered when clicking the tooltip in half selection @hkaikai ([#361](https://github.com/Tencent/tdesign-flutter/pull/361))
- `Calendar`: Fixed the issue of inaccurate scroll position due to inconsistent number of rows in the month date @hkaikai ([#363](https://github.com/Tencent/tdesign-flutter/pull/363))
- `Calendar`: Optimized the issue of rendering lag caused by too large min and max @hkaikai ([#363](https://github.com/Tencent/tdesign-flutter/pull/363))
- `Input`: Fixed the issue where the dividing line and content were not aligned when setting contentPadding @epoll-j ([#365](https://github.com/Tencent/tdesign-flutter/pull/365))
- `Table`: Fixed the issue of overflow when setting the width of fixed columns @ccXxx1aoBai ([#370](https://github.com/Tencent/tdesign-flutter/pull/370))
- `Popup`: Fixed the issue of delay in closing when clicking on the overlay @hkaikai ([#380](https://github.com/Tencent/tdesign-flutter/pull/380))
- `Cascader`: Added the function of clicking to select the first layer @shizhe2018 ([#355](https://github.com/Tencent/tdesign-flutter/pull/355))
- `DateTimePicker`: Added restrictions on hours, minutes, and seconds @shizhe2018 ([#362](https://github.com/Tencent/tdesign-flutter/pull/362))
- `Textarea`: Optimized the update of word limit changes @shizhe2018 ([#385](https://github.com/Tencent/tdesign-flutter/pull/385))
- `TabBar`: Fixed the issue where labelStyle and unselectedLabelStyle did not take effect @shizhe2018 ([#399](https://github.com/Tencent/tdesign-flutter/pull/399))
- `Picker`: Fixed the issue of unable to select color when sliding in multi-layer pop-up @shizhe2018 ([#413](https://github.com/Tencent/tdesign-flutter/pull/413))
- `SearchBar`: Fixed the issue of SearchBar jittering at the default position when focusing, and the cursor not being centered @Luozf12345 ([#417](https://github.com/Tencent/tdesign-flutter/pull/417))
- `Dialog`: Modified Dialog to only pass contentWidget, no need to pass title and content @Luozf12345 ([#418](https://github.com/Tencent/tdesign-flutter/pull/418))
- `TBottomTabBar`: Fixed the issue of bottom overflow by 2.5 pixels in iconText mode @epoll-j ([#422](https://github.com/Tencent/tdesign-flutter/pull/422))

### 🚧 Others

- Adapted to FlutterSdk3.25, the minimum supported version has been adjusted to 3.16.0 @shizhe2018 ([#378](https://github.com/Tencent/tdesign-flutter/pull/378))
- Modified Example English version copy @shizhe2018 ([#382](https://github.com/Tencent/tdesign-flutter/pull/382))
- Upgraded flutter_slidable version @Luozf12345 ([#407](https://github.com/Tencent/tdesign-flutter/pull/407))
- Added component search function to demo @Luozf12345 ([#410](https://github.com/Tencent/tdesign-flutter/pull/410))
- Updated Icons @Luozf12345 ([#420](https://github.com/Tencent/tdesign-flutter/pull/420))

## 🌈 0.1.7 `2024-10-16`

### 🚀 Features

- `TNoticeBar`: Added noticeBar component @ccXxx1aoBai ([#162](https://github.com/Tencent/tdesign-flutter/pull/162))
- `Result`: Added Result component @shinyina ([#220](https://github.com/Tencent/tdesign-flutter/pull/220))
- `TimeCounter`: Timer component supports time display beyond conversion units, original TCountDown component renamed to TimeCounter @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `Calendar`: Added Calendar component @hkaikai ([#271](https://github.com/Tencent/tdesign-flutter/pull/271))
- `Indexes`: Added Indexes component @hkaikai ([#321](https://github.com/Tencent/tdesign-flutter/pull/321))
- `Table`: Added table component @ccXxx1aoBai ([#244](https://github.com/Tencent/tdesign-flutter/pull/244))
- `Rate`: Added Rate component @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `Dialog`: Supports custom content padding and buttons @ccXxx1aoBai ([#289](https://github.com/Tencent/tdesign-flutter/pull/289))
- `Drawer`: Supports controlling the visibility of the divider, custom drawer background color, and controlling the display of the last divider @ccXxx1aoBai ([#278](https://github.com/Tencent/tdesign-flutter/pull/278))
- `DropdownMenu`: Added control parameters for icon/width/height/icon and text alignment @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `Search`: Added action and onActionClick properties @Ezer015 ([#263](https://github.com/Tencent/tdesign-flutter/pull/263))
- `Avatar`: Added onTap event @ccXxx1aoBai ([#344](https://github.com/Tencent/tdesign-flutter/pull/344))
- `TDropdownMenu`: Added tabBarFlex parameter to TDropdownItem to control width ratio @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `SearchBar`: Feature/td searchbarfix added cursor height property @shizhe2018 ([#337](https://github.com/Tencent/tdesign-flutter/pull/337))
- `TimeCounter`: Added forward timing function @epoll-j ([#246](https://github.com/Tencent/tdesign-flutter/pull/246))
- `NavBar`: [NavBar] supports setting bottom shadow @ccXxx1aoBai ([#284](https://github.com/Tencent/tdesign-flutter/pull/284))
- `Cell`: Added custom padding parameter @epoll-j ([#276](https://github.com/Tencent/tdesign-flutter/pull/276))
- `Input`: Added onTapOutside callback @epoll-j ([#280](https://github.com/Tencent/tdesign-flutter/pull/280))
- `Picker`: Added custom leftText, rightText @epoll-j ([#301](https://github.com/Tencent/tdesign-flutter/pull/301))
- `Slider`: Feature/tdslider added text wrapping function @shizhe2018 ([#329](https://github.com/Tencent/tdesign-flutter/pull/329))
- `Radio`: Feature/tdRadioGroup added built-in line wrapping, set number of rows and columns @shizhe2018 ([#331](https://github.com/Tencent/tdesign-flutter/pull/331))
- `Dialog`: Added custom input box @shizhe2018 ([#333](https://github.com/Tencent/tdesign-flutter/pull/333))
- `TNavBar`: Added flexibleSpace parameter @Luozf12345 ([#341](https://github.com/Tencent/tdesign-flutter/pull/341))
- `TSearch`: Added search box focus acquisition and clear events @Luozf12345 ([#342](https://github.com/Tencent/tdesign-flutter/pull/342))

### 🐞 Bug Fixes

- `ImageViewer`: Fixed defaultIndex invalid issue @ccXxx1aoBai ([#292](https://github.com/Tencent/tdesign-flutter/pull/292))
- `TimeCounter`: Fixed issue where it could not be reset repeatedly @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `DropdownMenu`: Adjusted popup layer logic, fixed issue where back button could not be listened to @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `DatePicker`: Removed monitoring on year, month, and day when destroyed to avoid memory leaks; added onSelectedItemChanged event @hkaikai ([#300](https://github.com/Tencent/tdesign-flutter/pull/300))
- `SideBar`: Fixed issue where custom selected style text was not centered @ccXxx1aoBai ([#313](https://github.com/Tencent/tdesign-flutter/pull/313))
- `Popup`: Fixed issue where multiple returns occurred when quickly clicking the mask @ccXxx1aoBai ([#318](https://github.com/Tencent/tdesign-flutter/pull/318))
- `ImageViewer`: Fixed issue where deleting the first image caused display anomalies @ccXxx1aoBai ([#322](https://github.com/Tencent/tdesign-flutter/pull/322))
- `SideBar`: Fixed issue where delayed loading components caused anchor point function anomalies @ccXxx1aoBai ([#343](https://github.com/Tencent/tdesign-flutter/pull/343))
- `TDropdownMenu`: Optimized menu display text to show ellipsis when exceeding display limit @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `NoticeBar`: Fixed issue where it could not follow the theme color @ccXxx1aoBai ([#350](https://github.com/Tencent/tdesign-flutter/pull/350))
- `Button`: Fixed overflow issue when setting shape to square or circle @epoll-j ([#257](https://github.com/Tencent/tdesign-flutter/pull/257))
- `Slider`: Bugfix: Fixed issue where tb_slider setState did not update @arvinwli ([#298](https://github.com/Tencent/tdesign-flutter/pull/298))
- `Cascader`: Fixed list sorting issue @shizhe2018 ([#303](https://github.com/Tencent/tdesign-flutter/pull/303))
- `Popup`: Fixed issue where the keyboard would cover the input box in the Popup @epoll-j ([#264](https://github.com/Tencent/tdesign-flutter/pull/264))
- `Cascader`: Fixed linkage time limit range logic @shizhe2018 ([#242](https://github.com/Tencent/tdesign-flutter/pull/242))
- `Loading`: Fixed issue where dismissing Loading immediately after showing did not take effect @Luozf12345 ([#340](https://github.com/Tencent/tdesign-flutter/pull/340))

### 🚧 Others

- fix: remove useless output. @Ives7 ([#311](https://github.com/Tencent/tdesign-flutter/pull/311))

## 🌈 0.1.6 `2024-07-24`

### 🚀 Features

- `Cell`: Added Cell component @hkaikai ([#150](https://github.com/Tencent/tdesign-flutter/pull/150))
- `Drawer`: Added Drawer component @hkaikai ([#178](https://github.com/Tencent/tdesign-flutter/pull/178))
- `SwipeCell`: Added SwipeCell component @hkaikai ([#218](https://github.com/Tencent/tdesign-flutter/pull/218))
- `Steps`: Added Steps component @aaronmhl ([#199](https://github.com/Tencent/tdesign-flutter/pull/199))
- `ImageViewer`: Added ImageViewer component @ccXxx1aoBai ([#187](https://github.com/Tencent/tdesign-flutter/pull/187))
- `Cascader`: Added Cascader component @shizhe2018 ([#195](https://github.com/Tencent/tdesign-flutter/pull/195))
- `Fab`: Added Fab component @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `BackTop`: Added BackTop component @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `TreeSelect`: Added TreeSelect component @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `Collapse`: Added Collapse component @dorayx ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `Input`: Added inputAction API to support setting keyboard actions; added spacer API to customize component spacing @ccXxx1aoBai ([#184](https://github.com/Tencent/tdesign-flutter/pull/184))
- `Text`: Added global font configuration and the ability to load web fonts @Luozf12345 ([#232](https://github.com/Tencent/tdesign-flutter/pull/232))
- `CountDown`: Added start/reset/pause/resume control functions @hkaikai ([#175](https://github.com/Tencent/tdesign-flutter/pull/175))
- `Popup`: Supported position and size settings @hkaikai ([#191](https://github.com/Tencent/tdesign-flutter/pull/191))

### 🐞 Bug Fixes

- `Toast`: Fixed the issue where the duration attribute was ineffective @ccXxx1aoBai ([#167](https://github.com/Tencent/tdesign-flutter/pull/167))
- `Input`: Fixed the label overflow issue @ccXxx1aoBai ([#184](https://github.com/Tencent/tdesign-flutter/pull/184))
- `Tabs`: For the tabs component, outlineType 'capsule' now supports setting selected and unselected tab background colors, and outlineType 'card' supports setting the selected tab background color @ccXxx1aoBai
- `Button`: Fixed the issue where properties could not be changed under the setState method @shizhe2018 ([#201](https://github.com/Tencent/tdesign-flutter/pull/201))
- `SearchBar`: Added a controller to the search bar, allowing external clearing of search text @shizhe2018 ([#194](https://github.com/Tencent/tdesign-flutter/pull/194))
- `Slider`: Added custom Decoration styles @shizhe2018 ([#198](https://github.com/Tencent/tdesign-flutter/pull/198))
- `Empty`: Added text size style API @shizhe2018 ([#219](https://github.com/Tencent/tdesign-flutter/pull/219))
- `Dialog`: Added input type background @shizhe2018 ([#238](https://github.com/Tencent/tdesign-flutter/pull/238))

### 🚧 Others

- HarmonyOS compilation support @hkaikai ([#233](https://github.com/Tencent/tdesign-flutter/pull/233))
- Modified theme adaptation tool @Luozf12345
- Added GitHub links for complete pages in demo code @Luozf12345

## 🌈 0.1.5 `2024-05-31`

### 🚀 Features

- `TDropdownMenu`:
  - add: Added TDropdownMenu dropdown menu component @hkaikai
- `TTextarea`:
  - add: Added Textarea multiline text box component @hkaikai
- `TBottomTabBar`:
  - add: Support for custom background color and distance between icon and text ([#138](https://github.com/Tencent/tdesign-flutter/issues/138))
  - add: TBottomTabBar supports externally setting currentIndex ([#110](https://github.com/Tencent/tdesign-flutter/issues/110))
- `TBadge`:
  - add: TBadge badge visibility setting when value is 0 @ccXxx1aoBai
- `TRadio`:
  - add: TRadio added custom background color and text color @ccXxx1aoBai ([#135](https://github.com/Tencent/tdesign-flutter/issues/135))
  - add: Added API to remove left margin ([#128](https://github.com/Tencent/tdesign-flutter/issues/128))
- `TCheckbox`:
  - add: TCheckbox added custom text color
  - add: Added API to remove left margin
- `TImage`:
  - add: Added Image.file ([#133](https://github.com/Tencent/tdesign-flutter/issues/133))
  - add: Allow external customization of TImage's fit method ([#114](https://github.com/Tencent/tdesign-flutter/issues/114))
- `TInput`:
  - add: Added custom size for Input clear button ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: Added left margin for label text ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: Added rightWidget for carType type ([#147](https://github.com/Tencent/tdesign-flutter/issues/32))
- `TDivider`:
  - add: Added text style size setting for divider component ([#134](https://github.com/Tencent/tdesign-flutter/issues/134))
- `TToast`:
  - add: Toast added attribute for custom text length ([#148](https://github.com/Tencent/tdesign-flutter/issues/148))
- `TSideBar`:
  - add: Added selected style ([#69](https://github.com/Tencent/tdesign-flutter/issues/69))
  - add: Added custom text padding ([#67](https://github.com/Tencent/tdesign-flutter/issues/67))

### 🐞 Bug Fixes

- `TButton`:
  - fix: Added mounted judgment before setState() ([#122](https://github.com/Tencent/tdesign-flutter/issues/112))
- `TDialog`:
  - fix: Modified Dialog to only auto-close when no action is set, if action is set, closing time is handled by the business itself ([#117](https://github.com/Tencent/tdesign-flutter/issues/117))

### 🚧 Others

- Added international language adaptation function
- Adapted to 3.16 text centering, added TTextConfig usage document

## 🌈 0.1.4 `2024-04-08`

### 🚀 Features

- `TCountDown`:
  - add: Added TCountDown countdown component @hkaikai
- `TTheme`:
  - add: Modified the theme implementation method, supporting ref attribute for custom mapping
  - add: Added default number font numberFontFamily
- `TText`:
  - add: Added TText force center switch kTextForceVerticalCenterEnable, which can globally disable forced centering to prevent excessive text offset after flutter 3.16 version ([#35](https://github.com/Tencent/tdesign-flutter/issues/35))
- `TBottomTabBar`:
  - add: Added custom background color feature ([#55](https://github.com/Tencent/tdesign-flutter/issues/55))
- `TCheckbox`:
  - add: TCheckbox and TRadio support custom colors ([#57](https://github.com/Tencent/tdesign-flutter/issues/57))
  - add: TCheckbox and TRadio support custom font sizes ([#66](https://github.com/Tencent/tdesign-flutter/issues/66))
- `TTabBar`:
  - add: TTabBar adds custom settings for divider color and height ([#71](https://github.com/Tencent/tdesign-flutter/issues/71))
- `TSwitch`:
  - add: TSwitch supports custom "on/off" text ([#73](https://github.com/Tencent/tdesign-flutter/issues/73))
- `TDialog`:
  - add: Added custom title alignment and content Widget feature ([#58](https://github.com/Tencent/tdesign-flutter/issues/58))

### 🐞 Bug Fixes

- `TSlider`:
  - fix: Fixed an issue where TSlider setting showThumbValue does not work.
- `TButton`:
  - fix: Fixed an issue where the external setting of the theme color for TButton does not take effect ([#54](https://github.com/Tencent/tdesign-flutter/issues/54))
- `TInput`:
  - fix: Fixed an issue where TInput's showBottomDivider does not work ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))
  - fix: Removed the invalid height API of TInput, use SizedBox to modify the height ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))

### 🚧 Others

- Example application, added a button to modify the theme, can quickly modify the theme color

## 🌈 0.1.3 `2024-03-15`

### 🚀 Features

- `TButton`:
  - add: Support for customizing the corner radius size through TButtonStyle.radius
- `TPicker`:
  - add: Picker component scrolling on PC now supports mouse dragging
  - add: For TPicker and TDatePicker components, the onConfirm no longer defaults to pop up the component internally, allowing external customization; when OnCancel is not empty, the component will not automatically pop.
- `TSwitch`:
  - add: onChanged now supports externally specifying whether to consume the event. If it has been consumed, it will no longer be processed internally ([#27](https://github.com/Tencent/tdesign-flutter/issues/27))
- `TBottomTabBar`:
  - add: Added custom label text style, optimized labText and icon parameter passing ([#49](https://github.com/Tencent/tdesign-flutter/issues/49))

### 🐞 Bug Fixes

- `TNavBar`:
  - fix: The height of NavBar is now obtained in real time to prevent it from not being available at the beginning ([#34](https://github.com/Tencent/tdesign-flutter/issues/34))
- `TDialog`:
  - fix: The contentColor parameter in DialogInfo was not passed in ([#37](https://github.com/Tencent/tdesign-flutter/pull/37))
- `TButton`:
  - fix: The click disable effect of TButton is invalid ([#44](https://github.com/Tencent/tdesign-flutter/issues/44))
- `TInput`:
  - fix: The delete button inside does not automatically refresh ([#30](https://github.com/Tencent/tdesign-flutter/issues/30))
  - fix: Fixed the mutual exclusion problem between the length of the input content and inputFormatters ([#38](https://github.com/Tencent/tdesign-flutter/issues/38))
- `TAlertDialog`:
  - fix: The operation of the default button of the component is open ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TRadio`:
  - fix: Horizontal arrangement will force the addition of an underline ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TTabBar`:
  - fix: The indicatorColor does not take effect ([#31](https://github.com/Tencent/tdesign-flutter/issues/31))

### 🚧 Others

- Optimized the performance of commonly used components such as TButton, TText, TTheme, etc.

## 🌈 0.1.2 `2024-01-08`

### 🚀 Features

- `TImage`:
  - add: Added FitWidth type to the image, modified the corresponding Demo page ([#14](https://github.com/Tencent/tdesign-flutter/pull/14))
- `TLoading`:
  - add: Added methods for showing and hiding loading ([#15](https://github.com/Tencent/tdesign-flutter/pull/15))
- `TPopup`:
  - add: Added support for customizing the round corners ([#17](https://github.com/Tencent/tdesign-flutter/pull/17))
- `TAvatar`:
  - add: When the avatar type is character or icon, support for customizing the background color is added ([#20](https://github.com/Tencent/tdesign-flutter/pull/20))

### 🐞 Bug Fixes

- `TBottomTabBar`:
  - Added a safe area, fixed ([#1](https://github.com/Tencent/tdesign-flutter/issues/1))
- `TButton`:
  - update widget: Button's disable status can be updated
  - fix: Button click state is too short ([#13](https://github.com/Tencent/tdesign-flutter/pull/13))
- `TSwiper`:
  - fix: Adapted swiper vertical dot bar style ([#19](https://github.com/Tencent/tdesign-flutter/pull/19))
- `TInput`:
  - fix: The setting of leftLabelStyle does not take effect when type is TInputType.twoLine ([#21](https://github.com/Tencent/tdesign-flutter/pull/21))

### 🚧 Others

- The minimum compatible version has been changed to 3.7.0 ([#3](https://github.com/Tencent/tdesign-flutter/issues/3))

## 0.1.1

- reset code style, can run on 3.7.x

## 0.1.0

- publisher to pub.dev stable

## 0.0.9

- update code style

## 0.0.8

- update License

## 0.0.7

- update example main.dart

## 0.0.6

- update slider component, make it is not depend on flutter sdk version

## 0.0.5

- publisher to pub.dev

## 0.0.4

- fix some bugs

## 0.0.3

- delete default value of TText's package prop, allow set it null value

## 0.0.2

- update ReadMe.md, modify export file is 'tdesign_flutter.dart'

## 0.0.1

- the first version, add button,text and other components.
