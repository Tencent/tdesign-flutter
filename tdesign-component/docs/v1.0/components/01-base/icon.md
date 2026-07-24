# TIcon — v1.0 定稿

> Sprint **S2** | **—** 纯展示 · **T2** · 源码：`lib/src/components/icon` · 依赖 [tdesign_icons](https://pub.dev/packages/tdesign_icons) `^0.0.4`

## 资源方案

图标资源由 [`tdesign_icons`](https://pub.dev/packages/tdesign_icons) 提供，包含 TTF、`TIcons`、`TIcons.allIconsMap`。组件库 `icon/` 承载 `TIcon` + re-export `TIcons`。

**使用方案**：

| 层 | 位置 | 做什么 |
| --- | --- | --- |
| 数据 | `tdesign_icons` **v0.0.4** | `TIcons.xxx`（`IconData`） |
| 组件 | `tdesign_flutter` / `icon/` | `TIcon`、`TIconThemeData` |
| 业务 | 一行 import | `import 'package:tdesign_flutter/tdesign_flutter.dart'` |

图标名：[tdesign.tencent.com/icons](https://tdesign.tencent.com/icons)

**使用 Demo**（Theme 细节见 §2）：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';

TIcon(TIcons.home_filled)
TIcon(TIcons.home_filled, size: 24, color: Colors.blue)
TIcon.fromName('home_filled')   // TIcons.allIconsMap
```

调用链：`TIcons`（数据）→ `TIcon`（组件）→ 内部 `Icon` 渲染字体。

> 子组件（如 TButton）的 `icon:` 参数见各组件 md，可用 `Icon(TIcons.xxx)`，**不强制** `TIcon`。

**读法**：§1 API · §2 Theme · §3 测试

---

## 架构

Material `Icon` 薄包装 · 纯展示 · 默认 `size` / `color` 走 `TIconThemeData` → `IconTheme`。资源与组件分工见上文 **资源剥离 · 使用方案**。

---

## 1. API

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `icon` | `IconData` | 位置参数 |
| `size` / `color` | `double?` / `Color?` | 默认 Theme |
| `semanticLabel` | `String?` | 可选 |
| `TIcon.fromName` | 工厂 | `allIconsMap[name]` |

**export**：`TIcon` · `TIconThemeData` · `TIcons`（re-export）

---

## 2. Theme

`TIconThemeData`（`size` · `color`）配子树默认尺寸/颜色。覆盖：构造器 **>** `TIconThemeData` **>** `IconTheme`。

**子树**（`mergeExtension`）：

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TIconThemeData(size: 20, color: Colors.grey),
  ),
  child: Column(
    children: [
      TIcon(TIcons.home),              // 20 · grey
      TIcon(TIcons.setting, size: 24), // 构造器 size 优先
    ],
  ),
)
```

**全局**（`MaterialApp.theme.extensions`）：

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [TIconThemeData(size: 16)],
  ),
  // ...
)
```

> `Icon(TIcons.xxx)` 只走 `IconTheme`，**不读** `TIconThemeData`；要 Theme 统一请用 `TIcon`。

---

## 3. 测试

**实现文件**：`icon.dart` · `t_icon.dart` · `t_icon_theme_data.dart`（本库不生成 `TIcons` 或声明字体）

| 测什么 | 范围 |
| --- | --- |
| Widget | `TIcon` 渲染、`size`/`color` 构造器覆盖 |
| Theme | `TIconThemeData` 子树默认、`IconTheme` 回退 |
| 工厂 | `TIcon.fromName` 合法名 / 非法名 |
| 包拆分 | import 可用 `TIcons`；字体来自 `tdesign_icons` |
| example | 浏览/搜索 `allIconsMap`；全库图标目视抽样 |
