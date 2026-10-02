# 公开 API 迁移清单（草案）

本分支移除了若干**已发布**构造参数或 `ThemeExtension` 字段，属于 breaking change；默认视觉相近不等于源码兼容。以下清单只记录本分支相对当前 `develop` 基线的迁移方向，不代表已经完成使用方编译回归。发布时须以最终 diff 复核名称、补 `breaking(...)` 提交及用户可感知的迁移说明，不能作为普通 `refactor` 发布。

| 原有写法或字段 | 替代入口 | 迁移要点 |
| --- | --- | --- |
| `TSearchBarThemeData.variant`、`TCollapseThemeData.variant` | 各实例的 `variant` | Theme 子树不能再统一选择形态；批量迁移需在相关实例逐个指定。 |
| `TTableThemeData.bordered/stripe` | `TTable.bordered/stripe` | 两项控制每张表的结构，不再从 Theme 回退。 |
| `TLinkThemeData.defaultSize/defaultColorScheme/underline` | `TLink.size/colorPreset/underline` | Theme 中其余字体与图标视觉默认值继续有效。旧 `TLink.colorScheme` 也迁至 `colorPreset`。 |
| `TCellThemeData.align/groupVariant` | `TCell.align`、`TCellGroup.variant` | 对子树的原有统一选择需显式迁到每个实例。 |
| `TInputThemeData.clearButtonMode/cursorColor/multilineMinLines` | `TInput.clearButtonMode/cursorColor`、`TTextarea.minLines` | 光标默认色仍可从显式 Material 色板或全局 Token 获取；原 Theme 中的统一选择不再生效。 |
| `TSwitchThemeData.defaultSize/defaultVariant`、`TTimeCounterThemeData.defaultSize/defaultVariant`、`TStepperThemeData.defaultSize/defaultVariant`、`TButtonThemeData.defaultSize/defaultVariant` | 对应实例的 `size/variant` | 保留组件 Theme 中具体颜色、尺寸、间距等可复用视觉值。 |
| `TDropdownMenuThemeData.animationDuration`、`TCollapseThemeData.animationDuration` | 对应实例的 `animationDuration` | 单次交互时长由实例决定；系统减少动态效果仍有最高优先级。 |
| `TCollapse.elevation` | `TCollapseThemeData.elevation` | 阴影改为子树级视觉默认值；单实例需使用局部 Theme。 |
| `TTabsBar.indicator`、`TIndexes.indexListMaxHeight`、`TSwiper.paginationAlignment` | 对应组件 Theme 字段 | 单实例定制通过仅包裹该实例的局部 `Theme`，不要在 Demo 外绘制补丁。 |
| `TIconThemeData` | Flutter `IconTheme` 与 `TIcon.size/color` | 标准 `IconTheme` 负责子树默认值；实例显式值覆盖。 |
| `TAvatar.backgroundColor/foregroundColor/textStyle`、`TAvatarGroup.dimension`；`TAvatarThemeData.size/shape/variant` | 对应具体值迁至 `TAvatarThemeData`；尺寸、形状及变体选择留在实例 | 同一子树设置颜色、文字与物理边长；逐实例配色可用局部 Theme。 |
| `TDrawer.width/backgroundColor`、`TDrawerContent.width/backgroundColor` | `TDrawerThemeData` 的宽度和背景字段 | 需用局部 Theme 设置单个抽屉的具体视觉值。 |
| `TSideBar.selectedColor/unSelectedColor/selectedTextStyle/contentPadding/selectedBgColor/unSelectedBgColor` | `TSideBarThemeData` 对应字段 | 选中项状态仍由实例控制，具体配色与内边距从 Theme 取。 |
| `TNavBar.titleColor/backIconColor/backgroundColor/padding/titleMargin/opacity/border/boxShadow` | `TNavBarThemeData` 对应字段 | 单个导航栏的定制值须通过局部 Theme 传入。 |
| `TTabBar.barHeight/dividerHeight/dividerThickness/dividerColor/selectedBgColor/unselectedBgColor/backgroundColor` | `TTabBarThemeData` 对应视觉字段 | 这些具体视觉值由子树组件 Theme 控制；单个标签栏可包裹局部 Theme。 |
| `TTabBar.topBorder/showTopBorder/centerDistance` | 无同义替代字段 | 普通标签栏默认始终绘制读取全局 `borderLevel1Color` 的顶边线；图文间距由上下/左右布局内置规则决定。这三项能力已删除，不在组件 Theme 恢复。 |
| `TTabBar.placeholder` | `TTabBar.useSafeArea` | 不再单独切换安全区占位方式；`useSafeArea: true` 时用标签栏背景色填充底部安全区，关闭时不填充。 |
| `TDialog`、`TConfirmDialog` 的 `backgroundColor/shape/elevation/width/maxHeight/contentPadding` | `TDialogThemeData` 对应字段 | 内容与按钮仍用实例参数；单对话框的面板外观用局部 Theme。 |
| `TFormItem.labelWidth/labelAlign`；`TFormThemeData.verticalAlignment/contentAlignment` | 标签宽度、文字对齐迁入 `TFormThemeData`；纵向/内容对齐留在 `TFormItem` | 子树标签排版与单个表单项区域对齐职责分开。 |
| `TPopover.offset/arrowSize/padding`；`TPopoverThemeData.showArrow` | 具体视觉尺寸迁入 `TPopoverThemeData`；`TPopover.showArrow` 保留 | 箭头有无是实例选择，尺寸与间距是子树默认值。 |
| `TAvatarThemeData.textStyle` | `TAvatarThemeData.foregroundColor` 管默认图标/文字颜色；`TAvatar.child: Text(style: ...)` 管特殊文字排版 | 默认文字的字号/字重仍随 `size` 变化；需要批量特殊排版时在调用方封装带样式的 `child`，不再为任意 `Widget child` 提供组件级 `TextStyle`。|
| `TAvatar.variant: TAvatarVariant.circle/square` | `TAvatar.shape: TAvatarShape.circle/square` | 两组枚举值一一对应；不能继续使用旧枚举类型。省略时仍默认圆形，头像组成员外框随成员 `shape`。 |
| `TSideBarItem.textStyle` | `TSideBarThemeData.textStyle` 管未选中标签，`selectedTextStyle` 管选中标签 | 原来逐项的样式须迁到 SideBar 子树 Theme；若各项确需不同排版，应使用独立组件组合方案，不再通过 SideBarItem 数据覆盖。 |
| `TSideBarThemeData.unSelectedColor` | `TSideBarThemeData.textStyle.color` | 未选中标签和图标继续共用同一个颜色；避免与 `textStyle.color` 在同一 Theme 内形成两套控制。 |
| `TTagThemeData.shape` | `TTag.shape` 或 `TSelectTag.shape` | 对原来由子树 Theme 统一选择的每个标签显式传入形状；默认仍为 `square`，圆角数值继续由 Theme 控制。 |
| `TTextSpan.font/fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor` | `TTextSpan.style: TextStyle(...)` | Span 的显式样式使用一个 Flutter 原生对象；未配置字段继续从父 Span 继承。 |
| `TTextThemeData.font` | `TTextThemeData.textStyle: TextStyle(fontSize: ..., height: ..., fontWeight: ...)` | 子树级字体只保留一个样式入口；`Font.height` 是行高与字号之比，可直接用于 `TextStyle.height`。Cascader 和 Picker 继续读取同一组件文字主题。 |
| `TPopoverAnchor.overlayColor/radius`、`TPopover.showPopover(overlayColor/radius)` | `TPopoverThemeData.barrierColor/borderRadius` | 单实例自定义用局部 `Theme` 包裹触发上下文；`borderRadius` 从 `double?` 改为 `BorderRadius?`，旧 `borderRadius: 8` 改为 `borderRadius: BorderRadius.circular(8)`，支持逐角圆角。 |
| `TPopoverThemeData.lerpDouble` | 无需外部调用；组件主题的 `lerp` 已负责插值 | 原公开静态辅助方法仅供内部使用，改为私有。 |
| `TButtonThemeData.filledStyle/outlinedStyle/textButtonStyle/ghostStyle/padding` | 对应实例 `TButton.style: ButtonStyle(...)`；子树批量默认值可使用 Flutter 的 `ElevatedButtonTheme`、`OutlinedButtonTheme`、`TextButtonTheme` | 具体颜色、描边、内边距、状态层等不再由 TDesign 组件 Theme 批量覆盖。Material 按钮主题分别作用于 fill、outline/ghost、text；outline 与 ghost 共用 `OutlinedButtonTheme`，若需分别设置，应在对应实例传入共享的 `ButtonStyle`。 |
| `TButtonThemeData.shape` | `TButton.shape` | `shape` 是圆/方等结构选择；边框的具体视觉仍可在 `TButton.style.shape` 指定。 |
| `TInputThemeData.textStyle` | `TInput.style` | 只迁移已输入文字；占位文字继续由组件 Theme 的 `hintStyle` 控制。禁用态文字仍固定读取禁用 Token。 |
| `TDialogThemeData.actionButtonStyle` | `TDialogAction.style` 或 `TConfirmDialog.buttonStyle` | 面板外观继续走组件 Theme，单个操作按钮的视觉由操作项持有。 |
| `TTabsBar.decoration` | `TTabsBarThemeData.backgroundColor/dividerColor/dividerHeight` | 容器背景和底边线由组件 Theme 控制；仅定制一个 TabsBar 时包裹局部 Theme。 |
| `TTagThemeData.fontWeight` | `TTagThemeData.font` | 字重跟随完整字体 Token；不再与其分别配置。 |
| `TSideBarThemeData.selectedColor` | `TSideBarThemeData.selectedTextStyle: TextStyle(color: ...)` | 选中文字、图标与指示线继续共用这一颜色；不设 `color` 时仍回退全局品牌色。已有 `selectedTextStyle` 时将颜色并入该对象，不再同时配置两处。 |
| `TText.fontWeight/fontFamily/textColor/isTextThrough/lineThroughColor` | `TText.style: TextStyle(...)` | 实例保留 `font` 选择 TDesign 字体预设，局部颜色、字重、字体族及删除线统一写入 `style`；`TText.rich` 同步迁移。 |
| `TPopupOverlayConfig.opacity`、`TPopupThemeData.barrierOpacity` | `TPopupOverlayConfig.color` 或 `TPopupThemeData.barrierColor` 的 alpha | 旧颜色与 opacity 相乘时，迁移后在颜色中直接表示最终 alpha；避免两次透明度叠乘。 |
| `TPopupThemeData.transitionDuration` | `TPopupOptions.animationDuration` | 动画时长由单次打开命令控制，省略时使用内置 240ms。 |
| `TSwipeCellThemeData.actionBackgroundColor/actionIconColor/actionTextStyle/actionIconSize/actionSpacing` | `TSwipeCellAction.backgroundColor/iconColor/labelStyle/iconSize/iconLabelSpacing` | 逐项视觉由对应操作项控制；子树 Theme 只保留共用的 `actionPadding`。原来仅在 Theme 批量配置的调用需逐操作项迁移。 |
| `TSwipeCellAction.spacing` | `TSwipeCellAction.iconLabelSpacing` | 含义限定为图标与标签之间的水平间距。 |

仅定制一个 `TText` 时直接使用实例样式；批量定制子树文字仍使用 `TTextThemeData.textStyle`：

```dart
const TText('文本', style: TextStyle(color: Colors.red))
```

Button 样式的迁移形态：

```dart
TButton(
  variant: TButtonVariant.outline,
  colorPreset: TButtonColorPreset.primary,
  style: const ButtonStyle(
    side: WidgetStatePropertyAll(BorderSide(color: Colors.green)),
  ),
  child: const Text('按钮'),
)
```

`colorPreset` 只选择内置预设；具体描边、前景和背景由实例 `style` 控制。`TButtonThemeData` 仅保留 `iconTextSpacing` 和 `gradient` 这两个 `ButtonStyle` 无法等价表达的字段。`TText` 的子树默认样式由组件 Theme 控制，单实例样式由 `style` 控制；`font` 仅选择 TDesign 字体预设。

## 组件内置配色预设改名

`TButton`、`TTag`、`TSelectTag`、`TLink`、`TBackTop`、`TPopoverAnchor`、`TPopover.showPopover` 和 `TDialogAction` 的 `colorScheme:` 改为 `colorPreset:`；对应枚举 `TButton/TTag/TLink/TBackTop/TPopoverColorScheme` 改为 `TButton/TTag/TLink/TBackTop/TPopoverColorPreset`。这是源码级 breaking change，不保留同义别名。枚举成员和默认映射不变；Material 的 `ThemeData.colorScheme: ColorScheme(...)` 及其优先级不变。`variant` 仍控制填充/描边等绘制处理，`colorPreset` 仅选择内置配色，`status` 仍表达业务状态。迁移调用时须同时更改命名参数与枚举类型，不能将 Material `ColorScheme` 实例传给 `colorPreset`。

`TText` 未显式指定字体时的正文回退从 `fontBodyLarge`（16dp/24dp）改为小程序 `fontBodyMedium`（14dp/22dp）。依赖旧默认字号的调用方应在实例 `font` 或子树 `TTextThemeData.textStyle` 中显式指定 16dp/24dp；这是默认行为变化，即使构造签名未变也须按 breaking change 发布。

`TAvatarGroup` 默认外观按设计稿调整：全部成员保留原尺寸绘制，不再把头像内容缩进后整体缩放；小/中/大成员分别使用 1/2/3dp 描边，并带默认阴影。未显式设置 `TAvatar.size` 的成员与折叠头像继承组内首个**可见且显式设置尺寸**的成员，均未设置时仍为中号；被 `maxCount` 隐藏的成员不改变可见布局。现有调用无需修改构造参数，但依赖旧图像缩放、无阴影效果或混合尺寸布局的应用必须复核实际渲染；组阴影和描边宽度可用 `TAvatarThemeData.groupShadow/groupBorderWidth` 配置。这是默认行为变化，按 breaking 发布。

`TTag` 的浅色 warning/danger/success 现分别跟随 `warningColor1`、`errorColor1`、`successColor1`；仅覆盖 `warningColorLight`、`errorColorLight`、`successColorLight` 的调用方不再改变这些 Tag。普通 outline 改为读取 `bgColorContainer` 背景，默认描边读取 `bgColorComponent`；方角由组件 `squareBorderRadius` 显式覆盖，否则读取全局 `radiusSmall`，不再固定为小程序组件变量的 8rpx。公开 Demo 的四档外盒仍为 20/24/28/40dp，字体大小为 10/12/14/14dp，文字使用相应字体 Token 行高；关闭图标跟随 `textColorPlaceholder`。另一张 Figma“Style 组件样式”页的尺寸不直接套用公开 Demo，须先裁定设计规范版本。这些默认外观和自定义 Token 消费变化都属于用户可感知的行为变更，发布时须列入 breaking 迁移说明。

发布前还需完成：逐字段最终 diff 清单、影响范围的外部调用点搜索、最终 Demo/文档替代示例编译验证、双版本与 CI 门禁。若没有明确的 breaking 版本与迁移发布安排，应停止这批字段删除，不能只靠本文消除兼容性风险。
