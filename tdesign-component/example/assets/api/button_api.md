## API

### TButton

TD 常规按钮（V1.0），Material 薄包装。`onPressed: null` 表示禁用。

#### 构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 内容，纯文案用 `Text('...')` |
| colorScheme | TButtonColorScheme? | Theme | 配色方案（primary / danger / light / defaultTheme） |
| icon | Widget? | - | 图标（Widget 类型，IconData 需包裹为 `Icon(...)`） |
| iconPosition | TButtonIconPosition | TButtonIconPosition.left | 图标位置（left / right） |
| key | Key? | - | 组件标识，用于区分或保留组件状态 |
| onPressed | VoidCallback? | - | 点击回调，`null` 表示禁用（替代 0.2.x 的 `disabled: true`） |
| size | TButtonSize | TButtonSize.medium | 尺寸（large / medium / small / extraSmall） |
| style | ButtonStyle? | - | P0 逃逸舱，覆盖所有 resolve 结果（非日常使用） |
| variant | TButtonVariant? | Theme defaultVariant | 变体类型（fill / outline / text / ghost） |

**已移除（0.2.x → V1.0）：**
- `text` → 改用 `child: Text('...')`
- `disabled` → 改用 `onPressed: null`
- `type` / `TButtonType` → 改用 `variant` / `TButtonVariant`
- `theme` / `TButtonTheme` → 改用 `colorScheme` / `TButtonColorScheme`
- `onTap` / `TButtonEvent` → 改用 `onPressed` / `VoidCallback?`
- `shape` / `TButtonShape` → 迁入 Theme `TButtonThemeData.shape`
- `isBlock` → 布局外包 `SizedBox(width: double.infinity)`
- `onLongPress` → 外包 `GestureDetector`
- `style` / `activeStyle` / `disableStyle`（`TButtonStyle`）→ 迁入 `TButtonThemeData`
- `width` / `height` → 外包 `SizedBox` 或 P0 `style`
- `padding` / `margin` / `gradient` / `textStyle` / `disableTextStyle` → 迁入 `TButtonThemeData`
- `iconTextSpacing` → 迁入 Theme `iconSpacing`
- `iconWidget` → 合并到 `icon`

---

### TButtonThemeData

TButton 组件级 ThemeExtension。通过 `Theme.of(context).copyWith(extensions: [...])` 注入子树。

#### 字段

| 字段 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| defaultVariant | TButtonVariant | fill | 未传 `variant` 时的默认变体 |
| defaultSize | TButtonSize | medium | 未传 `size` 时的默认尺寸 |
| filledStyle | ButtonStyle? | - | P2 色板：fill 变体（仅颜色，不含 shape） |
| outlinedStyle | ButtonStyle? | - | P2 色板：outline 变体（仅颜色，不含 shape） |
| textButtonStyle | ButtonStyle? | - | P2 色板：text 变体（仅颜色，不含 shape） |
| ghostStyle | ButtonStyle? | - | P2 色板：ghost 变体（仅颜色，不含 shape） |
| shape | TButtonShape? | rectangle | 外形枚举（展开进 resolved ButtonStyle.shape，不对外 export） |
| padding | EdgeInsetsGeometry? | - | 覆盖默认 padding |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| iconSpacing | double? | 8 | 图标与文案之间的间距 |
| gradient | Gradient? | - | 渐变背景色（装饰层，非 ButtonStyle 字段） |
| textStyle | TextStyle? | - | 默认文案样式 |

**覆盖顺序：** P0 `style` > resolve > Token

---

### TButtonResolve

按钮样式解析器（内部类，不对外构造）。唯一的 `ButtonStyle` merge 入口。

#### 静态方法

| 方法 | 返回类型 | 说明 |
| --- | --- | --- |
| resolve(...) | ButtonStyle | 按优先级链合并：shape → P2 色板 → colorScheme 覆色 → size 尺寸 → Theme padding → P0 style |

---

### TButtonSize

#### 枚举值

| 名称 | 对应高度 | 说明 |
| --- | --- | --- |
| large | 48 | 大尺寸 |
| medium | 40 | 中尺寸（默认） |
| small | 32 | 小尺寸 |
| extraSmall | 28 | 极小尺寸 |

---

### TButtonVariant

> 0.2.x `TButtonType` → V1.0 `TButtonVariant`

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| fill | 填充按钮（实心背景） |
| outline | 描边按钮（边框 + 透明背景） |
| text | 文字按钮（无边框无背景） |
| ghost | 幽灵按钮（深色背景上使用） |

---

### TButtonColorScheme

> 0.2.x `TButtonTheme` → V1.0 `TButtonColorScheme`

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认配色 |
| primary | 品牌色 |
| danger | 危险色 |
| light | 浅色 |

---

### TButtonIconPosition

#### 枚举值

| 名称 | 说明 |
| --- | --- |
| left | 图标在文本左侧（默认） |
| right | 图标在文本右侧 |

---

### 已移除的类型（0.2.x）

| 0.2.x 类型 | V1.0 替代 | 说明 |
| --- | --- | --- |
| TButtonType | TButtonVariant | 换名 |
| TButtonTheme | TButtonColorScheme | 换名 |
| TButtonEvent | VoidCallback? | 换型 |
| TButtonStatus | — | 不 export，内部由 WidgetState 处理 |
| TButtonShape | TButtonThemeData.shape | 迁入 Theme，不对外 export |
| TButtonStyle | TButtonThemeData | 整类删除，样式迁入 Theme |
