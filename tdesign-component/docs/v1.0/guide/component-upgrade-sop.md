# 组件升级标准操作流程（SOP）

> TDesign Flutter 0.2.x → v1.0 升级实战规范。
> 经 Base 类（S1/S2，6 个组件）与 Navigation 类（S3/S4，8 个组件）共 14 个组件升级沉淀。
> 全局设计规则 → [api.md](../foundation/api.md) · [theme.md](../foundation/theme.md) · [controlled.md](../foundation/controlled.md) · 组件 md 编写 → [component-doc.md](./component-doc.md) · 测试 → [testing.md](./testing.md)

---

## 0. 文档定位

本文不是设计规范的重复，而是**"如何把一个 0.2.x 组件升级到 v1.0"的工程操作手册**。

| 读者 | 看哪几节 |
|---|---|
| 新接手升级的开发者 | §1 → §2 → §3 → §4 → §8 |
| 升级中卡壳 | §4 模板 + §5 规则 + §7 常见坑 |
| 评审 / 验收 | §8 验收清单 |

**前提**：升级前必须先读对应组件的 v1.0 定稿 md（`docs/v1.0/components/{分类}/{组件}.md` 的 §1/§2/§3），它定义了目标 API；本文只管"怎么落地"。

---

## 1. 升级前准备

### 1.1 必读文档（按顺序）

1. 组件 v1.0 定稿 md：`docs/v1.0/components/{分类}/{组件}.md` §1（API）+ §2（0.2.x→v1.0）+ §3（Theme）
2. [api.md](../foundation/api.md)：L1–L4 四层构造器、命名映射、禁用规则、export 收敛
3. [theme.md](../foundation/theme.md)：P0–P4 优先级、子树覆盖、Material vs ThemeExtension 裁决
4. [controlled.md](../foundation/controlled.md)：A–F 控制类、value/onChanged vs controller、E 类浮层
5. [component-doc.md](./component-doc.md)：组件 md 的 §1–§4 章节模板（写升级指南时用）

### 1.2 定位三个分类标签

升级前先确认组件的标签，决定文件结构与测试覆盖：

| 标签 | 含义 | 示例 |
|---|---|---|
| **Tier** | 实现层级：T1 包装 Material / T2 薄包装或组合 / T3 自绘 | TButton=T1，TFab=T2 内嵌 TButton，TDivider=T3 自绘 |
| **控制类** | A 动作 / B·C·F 选择 / D 输入 / E 浮层 | 见 [controlled.md §1](../foundation/controlled.md#1-控制类-a--f) |
| **Sprint** | S1 参考 / S2 基础 / S3 导航 / S4 反馈 | 决定文档详略与 Golden 优先级 |

> 标签在组件 v1.0 md 文首"架构"段已写明；若缺失，先补 md 再开工。

### 1.3 摸底 0.2.x 现状

```bash
# 1. 看 0.2.x 源码
ls tdesign-component/lib/src/components/{组件}/

# 2. 搜全仓内部引用（升级后要同步迁移）
# 用 search_content 搜：组件类名、旧枚举、旧 typedef、*_style.dart 深路径 import
```

**摸底必须产出三张清单**（写进升级指南 §文件清单）：
- 0.2.x 公开符号（Widget / enum / typedef / `*Style` 类）
- 内部引用文件清单（其它组件 / example 页面）
- 待删除文件（`*_style.dart`、内嵌资源等）

---

## 2. 升级七步流程

> 这是 Base/Navigation 两类升级验证过的固定流程，按序执行不要跳步。

```
① 定稿核对 → ② 三件套代码 → ③ 内部引用迁移 → ④ Example 页面重写
   → ⑤ 测试 → ⑥ 文档三联（md + api.md + 升级指南）→ ⑦ 验收
```

### 步 ① 定稿核对（不写代码）

- 打开组件 v1.0 md 的 §1/§2/§3，逐项核对：构造器参数、枚举值、控制类、Tier、Theme 字段
- 若 md 与 0.2.x 实际代码有出入（如 md 漏了某个 0.2.x 参数），**先补 md 再开工**，不要边写边改设计
- 产出：本次升级的"变更总览表"草稿（写入升级指南 §1）

### 步 ② 三件套代码

按 Tier 与是否有 L4 样式，落地 2–3 个文件：

| 文件 | 何时建 | 职责 |
|---|---|---|
| `t_{xxx}.dart` | 必有 | Widget 主文件：枚举、构造器、build |
| `t_{xxx}_theme_data.dart` | 有 L4 样式时 | `T{Xxx}ThemeData`（ThemeExtension）+ 相关枚举 |
| `t_{xxx}_resolve.dart` | 样式解析复杂时 | 静态解析器，单 merge 入口 |

**判定要不要 resolve 文件**：若 build 内有 ≥2 处颜色/尺寸计算，或同一逻辑在构造器与 rich 变体重复，就抽 resolve。TButton/TLink/TText/TFab 都有；TBackTop/TNavBar 等简单组件可不抽。

代码模板见 §4。

### 步 ③ 内部引用迁移

升级完主组件后，**立即**全局搜索旧符号并替换，否则 example 编译不过：

```bash
# 搜索清单（按 0.2.x 公开符号逐个搜）
# - 旧枚举名（如 TLinkStyle、TButtonType、TTabBarOutlineType）
# - 旧构造参数（如 label:、onTap:、type:、theme:、enable:）
# - 旧 typedef（如 LinkClick）
# - *_style.dart 的深路径 import
```

**迁移顺序**：lib/src 内部组件 → example/lib/page → example/lib/config → example/lib/component_test。

### 步 ④ Example 页面重写

- `example/lib/page/t_{xxx}_page.dart`：全面改用 v1.0 API，新增 Theme 子树注入 demo（见 §6.1）
- `example/lib/config.dart`：确认组件入口已注册到 `exampleMap`，标注 `(V1.0)`
- 若组件有特殊布局约束（如 TFab 必须在 Stack 内），demo 要正确包裹

### 步 ⑤ 测试

- 新建 `test/components/{xxx}/t_{xxx}_test.dart`
- 按控制类覆盖必测项（见 [testing.md §3](./testing.md#3-widget-必测按控制类)）+ Tier1 额外测 Theme 子树
- 目标：用例数 ≥ 15，全通过；dart analyze 零 ERROR

### 步 ⑥ 文档三联

| 文档 | 路径 | 内容 |
|---|---|---|
| 组件 v1.0 md | `docs/v1.0/components/{分类}/{组件}.md` | 按 [component-doc.md](./component-doc.md) §2 章节结构，补齐 §1–§4 |
| API 面板 | `example/assets/api/{组件}_api.md` | 与代码字段一致，含 ThemeExtension 说明 |
| 升级指南 | `docs/v1.0/components/{分类}/{组件}-upgrade-guide.md` | 本文 §5 的模板 |

### 步 ⑦ 验收

跑 §8 验收清单，全部勾选才算升级完成。

---

## 3. 代码规范总则

### 3.1 命名映射（0.2.x → v1.0 全局统一）

> 任何组件升级都必须套用下表，不要自创命名。详见 [api.md §2](../foundation/api.md#2-全局命名0.2x--v10)。

| 0.2.x | v1.0 | 备注 |
|---|---|---|
| `onTap` / `onClick` | `onPressed` | ListTile 系 / TabBar 仍用 `onTap`（对齐 Material） |
| `onChange` | `onChanged` | |
| `isOn` / `checked` / `currentIndex` / `activeIndex` | `value` | B/C/F 类受控 |
| `type` | `variant` | 形态类 |
| `theme`（Button） | `colorScheme: T{Xxx}ColorScheme` | 语义色 |
| `style`（枚举色） | `colorScheme` | |
| `enable` / `disabled` | 按控制类 → §3.2 | |
| `*Style` 普通样式类 | `T{Xxx}ThemeData` | 不 export `*Style` |
| `TTheme.of` | `context.tTheme`（全局 Token）/ `Theme.of(context).extension<T{Xxx}ThemeData>()`（组件 Theme） | TTheme widget 已删除 |
| `text: '...'` / `label: '...'` | `child: Text('...')` | String → Widget? |
| 构造器 L4（色/间距/圆角） | `T{Xxx}ThemeData` 或 P0 `style`/`decoration` 逃逸舱 | |

**枚举命名约定**：
- 形态枚举：`T{Xxx}Variant`（如 `TButtonVariant`、`TTabBarVariant`）
- 配色枚举：`T{Xxx}ColorScheme`（如 `TButtonColorScheme`、`TLinkColorScheme`）
- 尺寸枚举：`T{Xxx}Size`（如 `TLinkSize`）
- 形状枚举：`T{Xxx}Shape`（如 `TButtonShape`、`TBackTopShape`）

### 3.2 禁用规则（按控制类，不暴露统一 disabled）

| 控制类 | 禁用写法 | 禁止 |
|---|---|---|
| **A**（Button/Link/Cell） | `onPressed: null` / `onTap: null` | ~~`disabled: true`~~ |
| **B/C/F**（Switch/Slider/Rate/Picker） | `onChanged: null`；项级 `*.disabled` KEEP | ~~`enable: false`~~ |
| **D**（Input/Textarea） | `enabled: false` / `readOnly: true` | ~~`onChanged: null` 表禁用~~ |
| **E**（Popup/Dialog/Toast） | 不调 `show` / `visible: false` | ~~浮层 `disabled`~~ |
| Tab 等 | `enabled: false` | ~~`enable`~~ |

### 3.3 构造器四层（L1–L4）

```
L1 语义：variant / size / value / enabled        ← 进构造器
L2 内容：child / label / hintText / icon          ← 进构造器
L3 行为：onPressed / onChanged / onVisibleChange  ← 进构造器
L4 样式：色 / 字号 / padding / 圆角               ← ❌ 不进构造器，进 T{Xxx}ThemeData
```

逃逸舱：`style: ButtonStyle?` / `decoration`（Material 同名）；**是否提供** → [theme.md §2.2](../foundation/theme.md#22-p0-逃逸舱判定) 四问（**默认无**）。

**参数量目标**：动作类 6–10 · 选择类 3–5 · 输入类 12–18 · 浮层 5–8。

### 3.4 样式优先级 P0–P4

```
P0 实例 style/decoration/variant  >  P1 T{Xxx}ThemeData  >
P2 Material 子主题                 >  P3 ThemeData.colorScheme/textTheme  >  P4 Token
```

口诀：**实例 > 组件 Theme > Material > Token**。

### 3.5 注释规范

- 所有 `///` 注释用**中文**
- 公开 API 注释与组件 md §1 一致；废弃参数**不写**"仍可使用"
- 文件首加一行组件用途说明

---

## 4. 三件套代码模板

### 4.1 `t_{xxx}.dart`（主 Widget）

```dart
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_{xxx}_resolve.dart'; // 若有

/// {组件用途一句话说明}
///
/// 基于 Material [XXX] 薄包装。   ← Tier 说明
class T{Xxx} extends StatelessWidget {
  const T{Xxx}({
    super.key,
    this.child,            // L2 内容
    this.variant,          // L1 语义（可空，回退 Theme.defaultVariant）
    this.colorScheme,      // L1 语义
    this.size,             // L1 语义
    this.onPressed,        // L3 行为（A 类；null = 禁用）
    // L4 样式参数一律不进构造器
  });

  // 字段声明带中文注释
  /// 链接内容，一般是 [Text]
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // 1. 读 Theme（P1）
    final theme = Theme.of(context).extension<T{Xxx}ThemeData>();
    // 2. 委托 Resolve 解析（单路径，禁止 build 内内联颜色计算）
    final resolved = T{Xxx}Resolve.resolve(
      context: context,
      variant: variant ?? theme?.defaultVariant ?? T{Xxx}Variant.basic,
      // ...
    );
    // 3. 组装 Widget
    return ...;
  }
}

/// 形态枚举
enum T{Xxx}Variant { basic, underline, icon }

/// 语义配色
enum T{Xxx}ColorScheme { primary, defaultTheme, danger, warning, success }
```

**要点**：
- 构造器参数可空（回退 Theme），`variant`/`size`/`colorScheme` 都用 `?? theme?.defaultXxx ?? 内置默认`
- build 内**禁止**内联 `color: Colors.xxx` 计算，全部走 Resolve
- 控制类 A 的 `onPressed: null` 即禁用，不要再加 `disabled` 参数

### 4.2 `t_{xxx}_theme_data.dart`（ThemeExtension）

```dart
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// {组件名} 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。构造器参数优先于 Theme。
class T{Xxx}ThemeData extends ThemeExtension<T{Xxx}ThemeData> {
  /// 未传 [T{Xxx}.variant] 时的默认形态
  final T{Xxx}Variant? defaultVariant;

  /// 未传 [T{Xxx}.size] 时的默认尺寸
  final T{Xxx}Size? defaultSize;

  /// 文本颜色（覆盖 colorScheme 计算色）
  final Color? color;

  /// 字号
  final double? fontSize;

  const T{Xxx}ThemeData({
    this.defaultVariant,
    this.defaultSize,
    this.color,
    this.fontSize,
  });

  @override
  T{Xxx}ThemeData copyWith({
    T{Xxx}Variant? defaultVariant,
    T{Xxx}Size? defaultSize,
    Color? color,
    double? fontSize,
  }) {
    return T{Xxx}ThemeData(
      defaultVariant: defaultVariant ?? this.defaultVariant,
      defaultSize: defaultSize ?? this.defaultSize,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  T{Xxx}ThemeData lerp(ThemeExtension<T{Xxx}ThemeData>? other, double t) {
    if (other is! T{Xxx}ThemeData) return this;
    return T{Xxx}ThemeData(
      defaultVariant: t < 0.5 ? defaultVariant : other.defaultVariant,
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
      color: Color.lerp(color, other.color, t),
      fontSize: lerpDouble(fontSize, other.fontSize, t),
    );
  }
}
```

**要点**：
- 枚举类字段 lerp 用 `t < 0.5 ? a : b`；Color 用 `Color.lerp`；数值用 `lerpDouble`
- 所有字段可空（null 表示该层不覆盖，回退下一级优先级）
- `copyWith` 参数名与字段名一致，用 `?? this.xxx` 合并
- 相关枚举（`T{Xxx}Variant`/`T{Xxx}Shape`）若仅 Theme 用，放本文件顶部；若构造器也用，放主 Widget 文件

### 4.3 `t_{xxx}_resolve.dart`（样式解析器）

```dart
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// {组件名} 样式解析器
///
/// 优先级链：构造器参数 > T{Xxx}ThemeData > Token 默认值
/// 这是唯一的样式 merge 入口，build 内禁止内联颜色/尺寸计算。
class T{Xxx}Resolve {
  T{Xxx}Resolve._(); // 私有构造，禁实例化

  /// 解析文本颜色
  ///
  /// 优先级：构造器 color > Theme.color > colorScheme × disabled 映射
  static Color resolveColor({
    required BuildContext context,
    required T{Xxx}ColorScheme? colorScheme,
    required T{Xxx}ThemeData? theme,
    required bool isDisabled,
    Color? instanceColor,
  }) {
    // L1：构造器参数
    if (instanceColor != null) return instanceColor;
    // L2：Theme
    final themeColor = theme?.color;
    if (themeColor != null) return themeColor;
    // L3：colorScheme × 状态映射到 Token
    final tTheme = context.tTheme;
    final scheme = colorScheme ?? T{Xxx}ColorScheme.primary;
    return isDisabled
        ? _disabledColor(scheme, tTheme)
        : _normalColor(scheme, tTheme);
  }

  // ---- 内部颜色映射（switch 表达式）----
  static Color _normalColor(T{Xxx}ColorScheme scheme, TThemeData tTheme) {
    return switch (scheme) {
      T{Xxx}ColorScheme.primary => tTheme.brandNormalColor,
      T{Xxx}ColorScheme.danger => tTheme.errorNormalColor,
      T{Xxx}ColorScheme.warning => tTheme.warningNormalColor,
      T{Xxx}ColorScheme.success => tTheme.successNormalColor,
      T{Xxx}ColorScheme.defaultTheme => tTheme.textColorPrimary,
    };
  }

  static Color _disabledColor(T{Xxx}ColorScheme scheme, TThemeData tTheme) {
    return switch (scheme) {
      T{Xxx}ColorScheme.primary => tTheme.brandDisabledColor,
      // ... 其余映射
    };
  }
}
```

**要点**：
- 类加私有构造 `T{Xxx}Resolve._();`，所有方法 `static`
- 每个 resolve 方法顶部注释写清优先级链
- 颜色映射用 `switch` 表达式（Dart 3+），正常态/禁用态分两个私有方法
- Token 读取用 `context.tTheme`（底层 `Theme.of(context).extension<TThemeData>()`，TTheme widget 已删除）；组件 Theme 注入用 `Theme.of(context).extension<T{Xxx}ThemeData>()`

### 4.4 export 规则

在 `lib/tdesign_flutter.dart` 中：

```dart
// ✅ export 这些
export 'src/components/{xxx}/t_{xxx}.dart';
export 'src/components/{xxx}/t_{xxx}_theme_data.dart' show T{Xxx}ThemeData;

// ❌ 不 export 这些
// - *_style.dart（旧 Style 类）
// - 内部 Widget（如 TDividerPainter、TFabDraggable）
// - 旧普通类 Theme
```

新增 ThemeExtension 用 `show` 限定，避免把内部辅助类一起导出。

---

## 5. 升级指南文档模板

每个组件升级都要写一份 `{组件}-upgrade-guide.md`，放在组件 v1.0 md 同目录。**固定七节结构**（参考 link/navbar/divider 升级指南）：

```markdown
# T{Xxx} v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **{Tier}**（实现方式）· 控制类 {A–F}

---

## 1. 变更总览
（一张表：维度 | 0.2.x | v1.0 | 图例 ✏️🔀📦🗑️✨🚫）
（覆盖：枚举改名、参数改名、参数合并、L4 迁入 Theme、废弃项、新增 ThemeExtension）

## 2. 逐项代码替换
### 2.1 枚举改名（❌ 0.2.x → ✅ v1.0 代码块）
### 2.2 构造器参数对照表（0.2.x | v1.0 | 说明）
### 2.3 枚举值迁移（若有值合并/改名）
### 2.4 完整示例（❌ 0.2.x 整段 → ✅ v1.0 整段）
### 2.5 特殊迁移（如 label→child、禁用态、竖线等，按需）

## 3. Theme 注入方式
### 3.1 子树注入（Theme + copyWith extensions 代码块）
### 3.2 全局注入（MaterialApp.theme extensions 代码块）

## 4. Resolve 优先级链
（文字链 + 颜色映射表：colorScheme | 正常态 Token | 禁用态 Token）

## 5. （可选）InheritedWidget / 特殊配置
（如组件内部共享上下文、TFab 拖拽系统）

## 6. Export 变更
（一张表：符号 | v1.0 是否 export | 说明）

## 7. 升级检查清单
- [ ] 旧枚举 → 新枚举
- [ ] 旧参数 → 新参数
- [ ] ...
- [ ] 确认 tdesign_flutter.dart export 无旧符号
- [ ] 更新内部引用（列出文件）
- [ ] 更新示例页面 + API 文档
```

**图例固定 6 个**（与 [component-doc.md §4](./component-doc.md#4-决策图例固定-6-个不新增) 一致）：✏️改名 / 🔀合并 / 📦迁入Theme / 🗑️移除 / ✨新增 / 🚫移出export。

---

## 6. Demo 与内部引用迁移

### 6.1 Example 页面必含内容

`t_{xxx}_page.dart` 至少包含：

1. **基础用法**：v1.0 构造器各参数演示
2. **配色/尺寸对比**：横向滚动卡片或 Row/Wrap 展示
3. **Theme 子树注入 demo**：用 `Theme(data: Theme.of(context).mergeExtension(T{Xxx}ThemeData(...)), child: T{Xxx}(...))` 演示子树覆盖
4. **禁用态**（A/B/C/F 类）：`onPressed: null` / `onChanged: null` / `enabled: false`
5. **交互**（若有）：拖拽、显隐、回调

### 6.2 config.dart 注册

```dart
// 1. import 区（按字母序）
import 'page/t_{xxx}_page.dart';

// 2. exampleMap 对应分组
ExamplePageModel(
  text: '{组件中文名} (V1.0)',
  name: '{xxx}',
  pageBuilder: (context) => T{Xxx}Page(),
),
```

**常见坑**：升级后入口可能被误放在 `/* */` 注释块内（Icon 曾出现），注册后跑 `dart analyze example/lib/config.dart` 确认。

### 6.3 内部引用迁移顺序

```
1. lib/src/components/ 内部引用（其它组件依赖本组件）
2. example/lib/page/t_{xxx}_page.dart（本组件 demo）
3. example/lib/page/ 其它页面（如 t_footer_page 引用 TLink）
4. example/lib/config.dart（入口注册）
5. example/lib/component_test/（测试 app）
```

每改完一批跑一次 `dart analyze`，避免错误累积。

---

## 7. 常见坑与对策（实战沉淀）

### 7.1 Theme 子树注入用 copyWith 还是 mergeExtension？

```dart
// ❌ 会覆盖其它 Extension（如 TThemeData）
Theme.of(context).copyWith(extensions: [T{Xxx}ThemeData(...)])

// ✅ merge，保留其它 Extension（推荐）
Theme.of(context).mergeExtension(T{Xxx}ThemeData(...))
```

升级指南示例中两种写法都出现过（link 用 copyWith，button 用 mergeExtension），**新升级组件统一用 `mergeExtension`**。详见 [theme.md §3](../foundation/theme.md#3-子树覆盖)。

### 7.2 内嵌 TButton 的组件（T2 组合）

TFab 内嵌 TButton 时，注入 shape 不能通过 TButton 构造器（TButton shape 由 `TButtonThemeData.shape` 控制），必须用 `mergeExtension` 合并覆盖（保留父级所有 Extension）：

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    (Theme.of(context).extension<TButtonThemeData>() ?? const TButtonThemeData())
        .copyWith(shape: TButtonShape.circle),
  ),
  child: TButton(...),
)
```

否则内嵌 TButton 会用默认方形 shape。

### 7.3 Positioned 组件的 demo 包裹

自带 `Positioned` 的组件（如 TFab）必须在 `Stack` 内使用，demo 不能直接放 Row/Column。用 `Stack` 容器包裹每个示例。

### 7.4 Flutter Web 运行注意

- Debug 模式（DDC）在 Flutter 3.41.9 + Chrome 149 下卡死，**必须用 release 模式**：`flutter run -d chrome --web-port=12345 --release`
- 每次运行前清理残留进程：`taskkill /F /IM dartaotruntime.exe 2>$null`
- VPN 开启时 gstatic.com 可能超时，加 `--no-web-resources-cdn` 让 CanvasKit 从本地加载

### 7.5 内部引用搜不全的兜底

`search_content` 搜旧符号时，注意：
- 旧枚举值（如 `TLinkStyle.primary`）比枚举名（`TLinkStyle`）更易漏，两者都要搜
- `*_style.dart` 的深路径 import 要单独搜一次
- example 页面里 `text:` / `onTap:` 这种泛化参数搜出来噪音大，结合组件名过滤

### 7.6 测试用例数参考

| 组件复杂度 | 用例数 | 参考 |
|---|---|---|
| T1 简单（Link） | 15–20 | TLink 18 |
| T1 完整（Button） | 50+ | TButton 54 |
| T2 组合（Fab） | 20–25 | TFab 22 |
| T3 自绘（Divider） | 25–30 | TDivider 28 |
| 导航简单（BackTop/Indexes） | 13–31 | TBackTop 31 |
| 导航复杂（NavBar/Tab） | 25–30 | TNavBar 25 |

---

## 8. 验收清单

升级完成前逐项勾选：

### 代码
- [ ] 三件套文件齐全（主 Widget + ThemeData + Resolve[若需]）
- [ ] 构造器参数符合 L1–L3，L4 已迁入 `T{Xxx}ThemeData`
- [ ] 命名套用 §3.1 全局映射表，无自创命名
- [ ] 禁用写法符合控制类（§3.2），无 `disabled`/`enable` 构造器
- [ ] build 内无内联颜色/尺寸计算，全部走 Resolve
- [ ] 所有注释为中文，公开 API 注释与 md §1 一致
- [ ] `tdesign_flutter.dart` export 正确（Widget + `show T{Xxx}ThemeData`），无旧 `*Style` 导出

### 迁移
- [ ] lib/src 内部引用全部迁移到新 API
- [ ] example/lib/page 本组件 demo 重写为 v1.0
- [ ] example/lib/page 其它页面引用已迁移
- [ ] example/lib/config.dart 入口注册（标 `(V1.0)`）
- [ ] example/lib/component_test 已迁移

### 测试
- [ ] `test/components/{xxx}/t_{xxx}_test.dart` 已建，用例数 ≥ 15
- [ ] 覆盖控制类必测项（[testing.md §3](./testing.md#3-widget-必测按控制类)）
- [ ] Tier1 额外覆盖 Theme 子树 `mergeExtension`
- [ ] `flutter test test/components/{xxx}/` 全通过
- [ ] `dart analyze lib/src/components/{xxx}/` 零 ERROR
- [ ] `dart analyze example/lib/` 零 ERROR

### 文档
- [ ] 组件 v1.0 md §1–§4 补齐（按 [component-doc.md](./component-doc.md)）
- [ ] `example/assets/api/{组件}_api.md` 与代码字段一致，含 ThemeExtension 说明
- [ ] `docs/v1.0/components/{分类}/{组件}-upgrade-guide.md` 按本文 §5 七节模板写
- [ ] 变更总览表图例正确（✏️🔀📦🗑️✨🚫）
- [ ] 升级检查清单完整可执行

### 运行
- [ ] example demo 页面可正常渲染（release 模式）
- [ ] 组件入口在 demo 首页可见
- [ ] Theme 子树注入 demo 生效

---

## 9. 已升级组件清单与参考样板

> 升级新组件时，按 Tier / 控制类找最接近的已升级组件作样板。

### 9.1 Base 类（已完成）

| 组件 | Tier | 控制类 | 样板价值 | 源码 | v1 文档 |
|---|---|---|---|---|---|
| TButton | T1 包装 ElevatedButton | A | **S1 参考实现**，三件套最完整 | [button/](../../../lib/src/components/button/) | [link](../components/01-base/button.md) |
| TLink | T1 薄包装 InkWell+Text | A | 枚举改名 + 合并的典型 | [link/](../../../lib/src/components/link/) | [link](../components/01-base/link.md) |
| TDivider | T3 自绘 | — | 自绘组件 + Painter 抽离 | [divider/](../../../lib/src/components/divider/) | [link](../components/01-base/divider.md) |
| TFab | T2 组合（内嵌 TButton） | A | T2 组合 + 拖拽系统 + Theme 注入 shape | [fab/](../../../lib/src/components/fab/) | [link](../components/01-base/fab.md) |
| TText | T2 薄包装（Text 超集） | — | InheritedWidget + 缓存 + Resolve | [text/](../../../lib/src/components/text/) | [link](../components/01-base/text.md) |
| TIcon | T2 薄包装 | — | 资源剥离 + 包依赖 + fromName | [icon/](../../../lib/src/components/icon/) | [link](../components/01-base/icon.md) |

### 9.2 Navigation 类（已完成）

| 组件 | 控制类 | 样板价值 | v1 定稿文档 |
|---|---|---|---|
| TBackTop | A | 回到顶部按钮 + 可见性阈值 | [link](../components/02-navigation/backtop.md) |
| TNavBar | A | 对齐 AppBar 的 leading/actions 模型 | [link](../components/02-navigation/navbar.md) |
| TTabBar | B | 底部栏 value/onChanged 受控模型 | [link](../components/02-navigation/tab-bar.md) |
| TTab/TTabsBar/TTabsBarView | — | TabController 持态 + Tabs 组合结构 | [link](../components/02-navigation/tabs.md) |
| TDrawer | E | 浮层 show 入口 + child 内容槽 | [link](../components/02-navigation/drawer.md) |
| TSideBar | B | 侧边导航 value/onChanged 受控模型 | [link](../components/02-navigation/sidebar.md) |
| TSteps | — | 展示型步骤条 value 视觉状态 | [link](../components/02-navigation/steps.md) |
| TIndexes | — | 索引通知与锚点展示 | [link](../components/02-navigation/indexes.md) |

### 9.3 选样板速查

| 你的组件特征 | 看哪个样板 |
|---|---|
| T1 包装 Material 控件 + 完整三件套 | TButton |
| T1 薄包装 + 枚举改名/合并 | TLink |
| T2 组合其它 T 组件 | TFab |
| T2 薄包装 + InheritedWidget | TText |
| T3 自绘 | TDivider |
| 资源/字体剥离 | TIcon |
| A 类 + 枚举改名 | TBackTop |
| 参数对齐 Material 同名控件 | TNavBar |
| B 类受控 + value/onChanged | TTabBar / TSideBar |
| — 类通知型 / 展示型 value | TIndexes / TSteps |
| E 类浮层 + show 入口 | TDrawer |
| TabController 持态 + 内容联动 | TTabsBar / TTabsBarView |

---

## 10. 升级记录追加（每次升级后）

每完成一个组件升级，在工作记忆 `e:\tdesign-flutter-v1\.codebuddy\memory/YYYY-MM-DD.md` 追加一条记录，格式：

```markdown
## T{Xxx} 组件 v1.0 升级完成

- **Tier / 控制类**：T? / ?
- **新增文件**：t_{xxx}_theme_data.dart, t_{xxx}_resolve.dart, t_{xxx}_test.dart, {xxx}-upgrade-guide.md
- **修改文件**：t_{xxx}.dart, tdesign_flutter.dart, t_{xxx}_page.dart, config.dart, {xxx}_api.md
- **内部引用迁移**：列出文件
- **N 个测试全部通过**
```

并在 `MEMORY.md` 的"已完成的组件升级"清单追加一行。
