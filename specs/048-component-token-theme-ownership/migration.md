# 公开 API 迁移清单（草案）

本分支移除了若干**已发布**构造参数或 `ThemeExtension` 字段，属于 breaking change；默认视觉相近不等于源码兼容。以下清单只记录本分支相对当前 `develop` 基线的迁移方向，不代表已经完成使用方编译回归。发布时须以最终 diff 复核名称、补 `breaking(...)` 提交及用户可感知的迁移说明，不能作为普通 `refactor` 发布。

| 原有写法或字段 | 替代入口 | 迁移要点 |
| --- | --- | --- |
| `TSearchBarThemeData.variant`、`TCollapseThemeData.variant` | 各实例的 `variant` | Theme 子树不能再统一选择形态；批量迁移需在相关实例逐个指定。 |
| `TTableThemeData.bordered/stripe` | `TTable.bordered/stripe` | 两项控制每张表的结构，不再从 Theme 回退。 |
| `TLinkThemeData.defaultSize/defaultColorScheme/underline` | `TLink.size/colorScheme/underline` | Theme 中其余字体与图标视觉默认值继续有效。 |
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
| `TTabBar.barHeight/dividerHeight/dividerThickness/dividerColor/topBorder/selectedBgColor/unselectedBgColor/backgroundColor/centerDistance` | `TTabBarThemeData` 对应视觉字段 | 分隔线及中心距离的默认值由组件负责；不再由实例重复覆盖。 |
| `TDialog`、`TConfirmDialog` 的 `backgroundColor/shape/elevation/width/maxHeight/contentPadding` | `TDialogThemeData` 对应字段 | 内容与按钮仍用实例参数；单对话框的面板外观用局部 Theme。 |
| `TFormItem.labelWidth/labelAlign`；`TFormThemeData.verticalAlignment/contentAlignment` | 标签宽度、文字对齐迁入 `TFormThemeData`；纵向/内容对齐留在 `TFormItem` | 子树标签排版与单个表单项区域对齐职责分开。 |
| `TPopover.offset/arrowSize/padding`；`TPopoverThemeData.showArrow` | 具体视觉尺寸迁入 `TPopoverThemeData`；`TPopover.showArrow` 保留 | 箭头有无是实例选择，尺寸与间距是子树默认值。 |
| `TAvatarThemeData.textStyle` | `TAvatarThemeData.foregroundColor` 管默认图标/文字颜色；`TAvatar.child: Text(style: ...)` 管特殊文字排版 | 默认文字的字号/字重仍随 `size` 变化；需要批量特殊排版时在调用方封装带样式的 `child`，不再为任意 `Widget child` 提供组件级 `TextStyle`。|
| `TPopoverAnchor.overlayColor/radius`、`TPopover.showPopover(overlayColor/radius)` | `TPopoverThemeData.barrierColor/borderRadius` | 单实例自定义用局部 `Theme` 包裹触发上下文；`borderRadius` 从 `double?` 改为 `BorderRadius?`，旧 `borderRadius: 8` 改为 `borderRadius: BorderRadius.circular(8)`，支持逐角圆角。 |
| `TPopoverThemeData.lerpDouble` | 无需外部调用；组件主题的 `lerp` 已负责插值 | 原公开静态辅助方法仅供内部使用，改为私有。 |

局部 Theme 的迁移形态：

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TButtonThemeData(
      outlinedStyle: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: Colors.green)),
      ),
    ),
  ),
  child: const TButton(
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    child: Text('按钮'),
  ),
)
```

`colorScheme` 只选择内置预设；组件 Theme 指定的具体描边、前景和背景会覆盖该预设。只有单个按钮要覆盖具体颜色时，使用实例 `style`。`TTextThemeData` 已恢复，没有把已发布的 Text 子树默认能力列为迁移项。

`TText` 未显式指定字体时的正文回退从 `fontBodyLarge`（16dp/24dp）改为小程序 `fontBodyMedium`（14dp/22dp）。依赖旧默认字号的调用方应在实例 `font`/`style` 或子树 `TTextThemeData.font` 中显式指定 16dp/24dp；这是默认行为变化，即使构造签名未变也须按 breaking change 发布。

`TTag` 的浅色 warning/danger/success 现分别跟随 `warningColor1`、`errorColor1`、`successColor1`；仅覆盖 `warningColorLight`、`errorColorLight`、`successColorLight` 的调用方不再改变这些 Tag。普通 outline 改为读取 `bgColorContainer` 背景，默认描边读取 `bgColorComponent`；方角由组件 `squareBorderRadius` 显式覆盖，否则读取全局 `radiusSmall`，不再固定为小程序组件变量的 8rpx。公开 Demo 的四档外盒仍为 20/24/28/40dp，字体大小为 10/12/14/14dp，文字使用相应字体 Token 行高；关闭图标跟随 `textColorPlaceholder`。另一张 Figma“Style 组件样式”页的尺寸不直接套用公开 Demo，须先裁定设计规范版本。这些默认外观和自定义 Token 消费变化都属于用户可感知的行为变更，发布时须列入 breaking 迁移说明。

发布前还需完成：逐字段最终 diff 清单、影响范围的外部调用点搜索、最终 Demo/文档替代示例编译验证、双版本与 CI 门禁。若没有明确的 breaking 版本与迁移发布安排，应停止这批字段删除，不能只靠本文消除兼容性风险。
