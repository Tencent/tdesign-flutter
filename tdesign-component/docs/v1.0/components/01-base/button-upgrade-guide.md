# TButton 0.2.x → V1.0 升级指南

> 基于 [button.md V1.0 定稿](./button.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | V1.0 |
|------|-------|------|
| **禁用** | `disabled: true` | `onPressed: null` |
| **变体** | `type` / `TButtonType` | `variant` / `TButtonVariant` |
| **主题色** | `theme` / `TButtonTheme` | `colorScheme` / `TButtonColorScheme` |
| **回调** | `onTap` / `TButtonEvent` | `onPressed` / `VoidCallback?` |
| **文本** | `text: 'XXX'` | `child: Text('XXX')` |
| **图标** | `icon` (IconData) + `iconWidget` (Widget) | `icon` (Widget?) 统一 |
| **样式** | `TButtonStyle` + `style`/`activeStyle`/`disableStyle` | `TButtonThemeData` (Theme) + P0 `style: ButtonStyle?` |
| **形状** | 构造器 `shape` / `TButtonShape` | Theme `TButtonThemeData.shape` |
| **通栏** | 构造器 `isBlock: true` | 外包 `SizedBox(width: double.infinity)` |
| **移除** | `disabled`/`onLongPress`/`TButtonStatus`/`TButtonEvent`/`padding`/`margin`/`gradient`(构造器) | 迁入 Theme 或移除 |

---

## 2. 逐文件代码替换

### 2.1 `lib/tdesign_flutter.dart` — export 变更

**删除：**
```dart
export 'src/components/button/t_button_style.dart';  // 🚫 整文件删除
```

**新增：**
```dart
export 'src/components/button/t_button_theme_data.dart';  // ✨ TButtonThemeData
```

**保留不变：**
```dart
export 'src/components/button/t_button.dart';
```

---

### 2.2 `t_button.dart` — 核心重构

#### 2.2.1 枚举改名

| 删 | 增 |
|----|----|
| `enum TButtonType { fill, outline, text, ghost }` | `enum TButtonVariant { fill, outline, text, ghost }` |
| `enum TButtonTheme { defaultTheme, primary, danger, light }` | `enum TButtonColorScheme { defaultTheme, primary, danger, light }` |
| `enum TButtonStatus { defaultState, active, disable }` | 🗑️ 移除 |
| `enum TButtonShape { rectangle, round, square, circle, filled }` | 🗑️ 移除（迁入 `TButtonThemeData`） |
| `typedef TButtonEvent = void Function();` | 🗑️ 移除（改用 `VoidCallback?`） |

**替换代码：**
```dart
// === 0.2.x（删除） ===
enum TButtonType { fill, outline, text, ghost }
enum TButtonTheme { defaultTheme, primary, danger, light }
enum TButtonStatus { defaultState, active, disable }
enum TButtonShape { rectangle, round, square, circle, filled }
typedef TButtonEvent = void Function();

// === V1.0（替换为） ===
/// 按钮变体
enum TButtonVariant { fill, outline, text, ghost }

/// 按钮配色方案
enum TButtonColorScheme { defaultTheme, primary, danger, light }
```

`TButtonSize` 和 `TButtonIconPosition` 保持不变。

#### 2.2.2 构造器参数对照

| 0.2.x 参数 | V1.0 参数 | 类型变化 |
|------------|----------|---------|
| `text: 'XXX'` | 🗑️ → `child: Text('XXX')` | — |
| `size: TButtonSize.medium` | 不变 | — |
| `type: TButtonType.fill` | `variant: TButtonVariant.fill` | 改名 |
| `shape: TButtonShape.rectangle` | 🗑️ → Theme `TButtonThemeData.shape` | 迁入 Theme |
| `theme: TButtonTheme.primary` | `colorScheme: TButtonColorScheme.primary` | 改名 |
| `child: xxx` | 不变 | — |
| `disabled: true` | 🗑️ → `onPressed: null` | — |
| `isBlock: true` | 🗑️ → 外包 `SizedBox` | — |
| `style: TButtonStyle(...)` | `style: ButtonStyle(...)` | **同名不同型** |
| `activeStyle: TButtonStyle(...)` | 🗑️ → Theme `TButtonThemeData.filledStyle` 等 | 迁入 Theme |
| `disableStyle: TButtonStyle(...)` | 🗑️ → Theme + WidgetStateProperty | 迁入 Theme |
| `textStyle: TextStyle(...)` | 🗑️ → Theme `TButtonThemeData.textStyle` | 迁入 Theme |
| `disableTextStyle: TextStyle(...)` | 🗑️ → Theme + WidgetStateProperty | 迁入 Theme |
| `onTap: () {}` | `onPressed: () {}` | 改名 + 改型 |
| `icon: Icons.xxx` (IconData) | `icon: Icon(Icons.xxx)` (Widget?) | 改型 |
| `iconWidget: xxx` (Widget) | 合并到 `icon` | 合并 |
| `iconTextSpacing: 8` | 🗑️ → Theme `TButtonThemeData.iconSpacing` | 迁入 Theme |
| `onLongPress: () {}` | 🗑️ → 外包 `GestureDetector` | — |
| `margin: EdgeInsets` | 🗑️ → Theme `TButtonThemeData.margin` | 迁入 Theme |
| `padding: EdgeInsets` | 🗑️ → Theme `TButtonThemeData.padding` | 迁入 Theme |
| `gradient: LinearGradient(...)` | 🗑️ → Theme `TButtonThemeData.gradient` | 迁入 Theme |
| `width` / `height` | 🗑️ → 外包 `SizedBox` 或 `style: ButtonStyle(...)` | 外包 |
| `iconPosition` | 不变 | — |

#### 2.2.3 必改的构造器示例

```dart
// === 0.2.x ===
TButton(
  text: '填充按钮',
  size: TButtonSize.large,
  type: TButtonType.fill,
  shape: TButtonShape.rectangle,
  theme: TButtonTheme.primary,
  icon: TIcons.app,
  disabled: true,
  isBlock: true,
  onTap: _onTap,
  onLongPress: _onLongPress,
  margin: EdgeInsets.symmetric(horizontal: 16),
),

// === V1.0 ===
SizedBox(
  width: double.infinity, // 替代 isBlock
  child: TButton(
    child: Text('填充按钮'), // 替代 text
    size: TButtonSize.large,
    variant: TButtonVariant.fill, // 替代 type
    colorScheme: TButtonColorScheme.primary, // 替代 theme
    icon: Icon(TIcons.app), // 替代 icon(IconData)
    onPressed: null, // 替代 disabled: true
    // shape → Theme, margin → Theme, padding → Theme
  ),
),
```

#### 2.2.4 `TButtonStyle` 整类移除

整个 `t_button_style.dart` 文件删除。其颜色生成逻辑迁入 `t_button_resolve.dart`（见 §2.3）。

---

### 2.3 `t_button_theme_data.dart` — 新建 ThemeExtension

**新建文件：** `lib/src/components/button/t_button_theme_data.dart`

继承 `ThemeExtension<TButtonThemeData>`，包含如下字段：

| 字段 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `defaultVariant` | `TButtonVariant` | `fill` | 未传 `variant` 时的默认值 |
| `defaultSize` | `TButtonSize` | `medium` | 未传 `size` 时的默认值 |
| `filledStyle` | `ButtonStyle?` | — | fill 变体的 P2 色板 |
| `outlinedStyle` | `ButtonStyle?` | — | outline 变体的 P2 色板 |
| `textButtonStyle` | `ButtonStyle?` | — | text 变体的 P2 色板 |
| `ghostStyle` | `ButtonStyle?` | — | ghost 变体的 P2 色板 |
| `shape` | `_TButtonShape?` | `rectangle` | 内部枚举（不 export） |
| `padding` | `EdgeInsetsGeometry?` | — | 覆盖默认 padding |
| `margin` | `EdgeInsetsGeometry?` | — | 外边距 |
| `iconSpacing` | `double?` | `8` | 图标文案间距 |
| `gradient` | `Gradient?` | — | 渐变装饰 |
| `textStyle` | `TextStyle?` | — | 默认文案样式 |

---

### 2.4 `t_button_resolve.dart` — 新建样式解析

**新建文件：** `lib/src/components/button/t_button_resolve.dart`

**职责：** 唯一 `ButtonStyle` merge 入口，按优先级链：

```
shape §3 → P2 色板 → colorScheme 覆色 → size 尺寸 → Theme padding → P0 style
```

**核心函数签名：**
```dart
ButtonStyle resolveButtonStyle({
  required TButtonVariant variant,
  required TButtonColorScheme? colorScheme,
  required TButtonSize size,
  required Widget? icon,
  required TButtonThemeData? theme,
  required ButtonStyle? instanceStyle,
  required BuildContext context,
})
```

---

### 2.5 Example 页面 `t_button_page.dart` — API 批量替换

#### 全局替换表

| 搜索（0.2.x） | 替换为（V1.0） |
|--------------|---------------|
| `text: 'XXX'` | `child: Text('XXX')` |
| `type: TButtonType.fill` | `variant: TButtonVariant.fill` |
| `type: TButtonType.outline` | `variant: TButtonVariant.outline` |
| `type: TButtonType.text` | `variant: TButtonVariant.text` |
| `type: TButtonType.ghost` | `variant: TButtonVariant.ghost` |
| `theme: TButtonTheme.primary` | `colorScheme: TButtonColorScheme.primary` |
| `theme: TButtonTheme.danger` | `colorScheme: TButtonColorScheme.danger` |
| `theme: TButtonTheme.light` | `colorScheme: TButtonColorScheme.light` |
| `theme: TButtonTheme.defaultTheme` | `colorScheme: TButtonColorScheme.defaultTheme` |
| `onTap:` | `onPressed:` |
| `disabled: true` | `onPressed: null` |
| `disabled: true,` + 下一行 `onTap:` | 删除 `disabled`，`onTap` → `onPressed` |
| `shape: TButtonShape.rectangle` | 删除（Theme 默认） |
| `shape: TButtonShape.round` | 删除（Theme `shape`） |
| `shape: TButtonShape.square` | 删除（Theme `shape`） |
| `shape: TButtonShape.circle` | 删除（Theme `shape`） |
| `shape: TButtonShape.filled` | 删除（Theme `shape`） |
| `icon: TIcons.xxx` | `icon: Icon(TIcons.xxx)` |
| `iconWidget: xxx` | `icon: xxx` |
| `isBlock: true` | 外包 `SizedBox(width: double.infinity)` |
| `TButtonEvent` 类型引用 | `VoidCallback?` |
| `TButtonStyle.generateXxxStyleByTheme(...)` | 🗑️（Theme 自动 resolve） |

#### 注意：含 `onTap` + `disabled: true` 的组合

```dart
// 0.2.x（带 onTap 的禁用按钮 — 可点击，传入旧 API 的兜底）
TButton(
  text: '填充按钮',
  disabled: true,
  onTap: _handleTap, // 即便 disabled 也会保留
)

// V1.0：仅保留 onPressed（设为 null 禁用）
TButton(
  child: Text('填充按钮'),
  onPressed: null, // 禁用
)
```

---

## 3. 测试方法

### 3.1 Widget 测试（必须）

| 编号 | 测试项 | 断言 |
|------|--------|------|
| T01 | 禁用（A 类） | `onPressed: null` → 按钮不可点击 |
| T02 | `variant` × `colorScheme` | fill/outline/text/ghost × primary/defaultTheme 各一态 |
| T03 | icon 行为 | 未设 size/color 时按 `size` 补齐 |
| T04 | icon 行为 | 已设 size/color 则尊重传入 |
| T05 | `iconPosition` | left / right 布局正确 |
| T06 | `shape` 五档 | rectangle · round · square · circle · filled |
| T07 | `size` 四档 | large/medium/small/extraSmall 尺寸 |
| T08 | P0 `style` 覆盖 | 实例 `style` 覆盖 Theme resolve |
| T09 | Theme 子树 | `mergeExtension(TButtonThemeData)` 覆盖构造器未传项 |
| T10 | `variant: fill` ≠ `shape: filled` | 二者正交 |

### 3.2 Golden 测试（至少 5 张）

```
test/golden/button/
├── default_fill.png        # fill + primary + 默认
├── outline_danger.png      # outline + danger
├── text_primary.png        # text + primary
├── disabled.png            # onPressed: null
├── icon_circle.png         # 纯 icon + shape: circle
```

### 3.3 运行命令

```bash
# Widget 测试
flutter test test/components/button/

# Golden 测试
flutter test --update-goldens test/components/button/

# 语法检查
flutter analyze lib/src/components/button/

# 编译验证
cd example && flutter build apk --debug
```

---

## 4. 功能测试清单

### 4.1 基础功能

- [ ] **点击响应**：`onPressed` 回调正常触发
- [ ] **禁用态**：`onPressed: null` 时按钮不可点击、呈现禁用视觉
- [ ] **所有 variant**：fill / outline / text / ghost 四种变体渲染正常
- [ ] **所有 colorScheme**：defaultTheme / primary / danger / light 四套配色
- [ ] **所有 size**：large(48) / medium(40) / small(32) / extraSmall(28) 尺寸
- [ ] **所有 shape**：rectangle / round / square / circle / filled 外形
- [ ] **icon 图标**：纯 icon、icon + 文本、icon 位置(左/右)
- [ ] **child 自定义**：传入自定义 Widget 替代 text
- [ ] **P0 style 逃逸**：实例 `style: ButtonStyle(...)` 覆盖 Theme

### 4.2 布局迁移（isBlock 替代）

- [ ] **通栏按钮**：`SizedBox(width: double.infinity)` + `TButton` 正确撑满
- [ ] **带边距通栏**：`Padding` + `SizedBox` + `TButton` 正确
- [ ] **组合按钮**：Row/Expanded 替代 isBlock 组合
- [ ] **直角通栏**：Theme `shape: filled` 替代旧 isBlock + shape: filled

### 4.3 Theme 子树

- [ ] **mergeExtension**：子树内按钮使用 Theme 默认值
- [ ] **全局 Theme**：`MaterialApp.theme` 写入 `TButtonThemeData`
- [ ] **单颗覆盖**：构造器参数覆盖 Theme 子树值

### 4.4 回归检查

- [ ] **无 `disabled` 参数**：编译时不接受 `disabled` 参数
- [ ] **无 `TButtonStatus` 引用**：代码中无残留 `TButtonStatus`
- [ ] **无 `TButtonEvent` 引用**：代码中无残留 `TButtonEvent`
- [ ] **无 `TButtonStyle` 引用**：代码中无残留 `TButtonStyle`
- [ ] **export 收敛**：仅 export TButton / TButtonThemeData / 枚举

---

## 5. 升级风险与注意事项

| 风险 | 应对 |
|------|------|
| `text` → `child: Text()` 批量替换遗漏 | 全项目 `grep 'text:'` 排查 |
| `icon` IconData → Widget 类型变化 | 编译期报错，逐个改为 `Icon(TIcons.xxx)` |
| `isBlock` 布局外包 | 注意 `Column`/`Row` 内约束传递 |
| `onLongPress` 移除 | 外包 `GestureDetector` 包裹 |
| `disabled` 语义变化 | 旧 `disabled: true` + `onTap:` → V1.0 `onPressed: null` 丢失回调 |
| `TButtonStyle` 动态代码 | 迁入 resolve 函数或 Theme |
