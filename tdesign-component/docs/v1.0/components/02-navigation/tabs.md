# Tabs — v1.0

> **源码**：`lib/src/components/tabs/` · **类名**：`TTab` · `TTabsBar` · `TTabsBarView`

Tabs 使用 Material `TabController` 管理选中态。`TTabsBar` 负责标签栏，`TTabsBarView` 负责内容区；两者传入同一 Controller，或共同使用 `DefaultTabController`。

## API

### TTab

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `text` | `String?` | — | 标签文字，与 `child` 二选一。 |
| `child` | `Widget?` | — | 自定义标签内容，与 `text` 二选一。 |
| `icon` | `Widget?` | — | 图标，可独立使用或与文字、自定义内容水平组合。 |
| `badge` | `TBadge?` | — | 锚定完整标签内容的徽标。 |
| `enabled` | `bool` | `true` | 是否可点击。 |

### TTabsBar

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `tabs` | `List<TTab>` | required | 标签列表。 |
| `controller` | `TabController?` | — | 与内容区共用的控制器。 |
| `onTap` | `ValueChanged<int>?` | — | 点击标签后的旁听回调。 |
| `variant` | `TTabsBarVariant` | `filled` | `filled`、`capsule`、`card` 三种形态。 |
| `isScrollable` | `bool` | `false` | 是否按内容宽度横向滚动；否则标签均分。 |
| `indicator` | `Decoration?` | — | 自定义指示器；为空时不展示。可用 `TTabsBarIndicator`。 |
| `decoration` | `Decoration?` | — | 栏整体装饰；非空时覆盖 Theme 背景和分割线。 |

### TTabsBarView

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `children` | `List<Widget>` | required | 内容页列表，数量须与 Controller 一致。 |
| `controller` | `TabController?` | — | 与标签栏共用的控制器。 |
| `physics` | `ScrollPhysics?` | `NeverScrollableScrollPhysics` | 内容区滑动物理特性。 |

## Theme

视觉样式统一使用 `TTabsBarThemeData`，可通过 `Theme.of(context).mergeExtension(...)` 在子树覆盖，或在全局 Theme 注册。

| 字段 | 说明 |
|---|---|
| `backgroundColor` | 标签栏背景色。 |
| `labelStyle` / `unselectedLabelStyle` | 选中与未选中文字样式。 |
| `labelPadding` | 标签内容边距。 |
| `indicator` | 默认指示器。 |
| `dividerColor` / `dividerHeight` | 分割线视觉。 |
| `selectedBgColor` / `unSelectedBgColor` | capsule 形态选中与未选中背景色。 |

覆盖优先级：组件 `decoration` / `indicator` > `TTabsBarThemeData` > Material `TabBarTheme` > TDesign token。

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TTabsBarThemeData(
      labelPadding: EdgeInsets.symmetric(horizontal: 12),
      dividerHeight: 0,
    ),
  ),
  child: TTabsBar(
    tabs: const [TTab(text: '选项1'), TTab(text: '选项2')],
    indicator: TTabsBarIndicator(indicatorColor: Colors.blue),
  ),
)
```

## 迁移说明

本版本删除 `TTabSize`、`TTab.size/contentHeight/textMargin/iconMargin/height`，以及 `TTabsBar` 的平铺尺寸、颜色、边距、分割线、指示器开关与滚动物理参数。视觉配置迁移至 `TTabsBarThemeData`；标准或定制指示器迁移为 `indicator: Decoration`；布局宽高由父组件决定。
