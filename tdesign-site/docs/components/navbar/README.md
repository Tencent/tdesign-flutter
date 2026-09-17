---
title: NavBar 导航栏
description: 用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

完整 Demo 源码见 [t_navbar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/t_navbar_page.dart)。

### 基础导航栏

`title` 接受任意 Widget。默认不显示返回按钮，需要时显式开启
`useDefaultBack`；未提供 `onBack` 时会调用 `Navigator.maybePop`。

```dart
const TNavBar(
  title: Text('标题文字'),
  useDefaultBack: true,
)
```

### 左右操作项

`leading` 和 `actions` 接受 `TNavBarItem` 列表。`onTap: null` 表示禁用，
不需要额外的 `disabled` 参数。

```dart
TNavBar(
  title: const Text('标题文字'),
  useDefaultBack: true,
  onBack: () {
    // 提供 onBack 后，由调用方完全接管返回行为。
    Navigator.maybePop(context);
  },
  leading: [
    TNavBarItem(
      icon: TIcons.close,
      onTap: () => TToast.showText('点击了关闭', context: context),
    ),
  ],
  actions: [
    TNavBarItem(
      icon: TIcons.home,
      onTap: () => TToast.showText('点击了首页', context: context),
    ),
    TNavBarItem(
      icon: TIcons.ellipsis,
      onTap: () => TToast.showText('点击了更多', context: context),
    ),
  ],
)
```

### 自定义标题内容

搜索框、图片等内容直接通过 `title` 组合，不需要 Navbar 专属搜索或图片 API。

```dart
TNavBar(
  centerTitle: false,
  titleMargin: 0,
  title: Theme(
    data: Theme.of(context).mergeExtension(
      const TSearchBarThemeData(variant: TSearchBarVariant.round),
    ),
    child: TSearchBar(
      hintText: '搜索预设文案',
      onChanged: (value) {
        // 处理搜索内容。
      },
    ),
  ),
  actions: [
    TNavBarItem(
      icon: TIcons.ellipsis,
      onTap: () => TToast.showText('点击了更多', context: context),
    ),
  ],
)
```

图片标题同样使用 Widget 组合：

```dart
const TNavBar(
  centerTitle: false,
  titleMargin: 0,
  title: TImage(
    src: 'assets/img/t_brand.png',
    width: 87,
    height: 24,
    fit: BoxFit.contain,
  ),
)
```

### 双层标题

`belowTitleWidget` 位于 `height` 定义的内容高度内。使用较高的下层内容时，
需要同步增大 `height`。

```dart
TNavBar(
  height: 80,
  centerTitle: false,
  titleMargin: 8,
  title: TText('返回', font: context.tTheme.fontBodyLarge),
  belowTitleWidget: SizedBox(
    height: 36,
    child: TText(
      '标题文字',
      font: Font(size: 28, lineHeight: 36),
      fontWeight: FontWeight.w600,
    ),
  ),
  leading: [
    TNavBarItem(
      icon: TIcons.chevron_left,
      onTap: () => Navigator.maybePop(context),
    ),
  ],
)
```

### 边框操作区

`useBorderStyle` 决定是否启用边框结构，`border` 只配置具体样式。

```dart
TNavBar(
  title: const Text('标题文字'),
  useBorderStyle: true,
  border: const TNavBarBorder(
    width: 1,
    radius: 22,
    padding: EdgeInsets.symmetric(horizontal: 4),
  ),
  actions: [
    TNavBarItem(icon: TIcons.home, onTap: () {}),
    TNavBarItem(icon: TIcons.ellipsis, onTap: () {}),
  ],
)
```

### Theme 与优先级

样式解析顺序是：构造器参数 > `TNavBarThemeData` > Material
`AppBarTheme` > TDesign Token。`height` 和 `useBorderStyle` 是实例结构契约，
不由 Theme 控制。

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TNavBarThemeData(
      titleColor: Colors.white,
      backgroundColor: Colors.blue,
      titleMargin: 12,
      opacity: 0.9,
    ),
  ),
  child: const TNavBar(title: Text('标题文字')),
)
```

`copyWith` 只替换非空参数，传入 `null` 与省略参数都会保留原值。需要清除
某个配置时，请重新构造 `TNavBarThemeData`，只传入仍需保留的字段。

### 顶部安全区

`useSafeArea` 默认为 false。只有导航栏直接位于页面顶部、并且外层没有处理
系统安全区时才开启；`height` 始终表示内容高度，安全区只计入实际渲染高度。

## API

### TNavBar

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | Widget? | - | 标题内容 |
| leading | List\<TNavBarItem\>? | - | 左侧操作项 |
| actions | List\<TNavBarItem\>? | - | 右侧操作项 |
| centerTitle | bool | true | 标题是否居中 |
| useDefaultBack | bool | false | 是否显示默认返回按钮 |
| onBack | VoidCallback? | - | 默认返回按钮回调，仅在 `useDefaultBack` 为 true 时生效 |
| belowTitleWidget | Widget? | - | 标题区域下方内容，占用 `height` 内部空间 |
| flexibleSpace | Widget? | - | 位于导航栏内容下层的背景 Widget |
| titleColor | Color? | - | 标题默认颜色；标题自身显式颜色优先 |
| backIconColor | Color? | - | 默认返回图标颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| height | double | 48 | 内容高度及 `preferredSize.height` |
| padding | EdgeInsetsGeometry? | - | 内部填充 |
| titleMargin | double? | - | 标题与两侧内容的间距 |
| opacity | double? | - | 背景颜色透明度，未配置时为 1 |
| useBorderStyle | bool | false | 是否启用操作项边框结构 |
| border | TNavBarBorder? | - | 操作项边框配置，仅在边框模式下生效 |
| boxShadow | List\<BoxShadow\>? | - | 底部阴影 |
| useSafeArea | bool | false | 是否在实际渲染高度中加入顶部安全区 |

### TNavBarItem

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色 |
| onTap | VoidCallback? | - | 点击回调；null 表示禁用 |
| iconSize | double? | 24 | 图标尺寸；null 时由 `IconTheme` 决定 |
| padding | EdgeInsetsGeometry? | - | 操作项内部填充 |
| customWidget | Widget? | - | 自定义内容，优先级高于 `icon` |

### TNavBarBorder

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| width | double | 1 | 边框及分隔线宽度 |
| radius | double | 22 | 边框圆角 |
| color | Color? | - | 边框颜色；未配置时使用 TDesign Token |
| padding | EdgeInsetsGeometry? | - | 边框内部填充 |

### TNavBarThemeData

可配置 `titleColor`、`backIconColor`、`backgroundColor`、`padding`、
`titleMargin`、`opacity`、`border` 和 `boxShadow`。构造器同名参数优先于
Theme；Theme 不保存高度、边框模式或业务状态。
