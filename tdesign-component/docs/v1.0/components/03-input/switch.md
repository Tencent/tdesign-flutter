# TSwitch — v1.0 定稿

> Sprint **S2** | 控制类 **B** | Material: Switch.adaptive
> 源码：`lib/src/components/switch` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | Switch.adaptive |
| Theme | `TSwitchThemeData` |
| 禁用 | `onChanged: null`。 |
| L4 | 构造器 L4 → `TSwitchThemeData` |

## 受控

`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TSwitchSize | 尺寸/位置枚举保留 |
| size | 尺寸：大、中、小 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TSwitchType | variant 枚举 | 对齐 Material |
| OnSwitchChanged | void Function(bool)? | 对齐 Material 回调签名 |
| enable | onChanged: null | Material 禁用 |
| isOn | value | 受控统一为 value |
| trackOnColor | TSwitchThemeData | L4 → Theme |
| trackOffColor | TSwitchThemeData | L4 → Theme |
| thumbContentOnColor | TSwitchThemeData | L4 → Theme |
| thumbContentOffColor | TSwitchThemeData | L4 → Theme |
| thumbContentOnFont | TSwitchThemeData | L4 → Theme |
| thumbContentOffFont | TSwitchThemeData | L4 → Theme |
| type | TSwitchThemeData.variant | L4 → Theme |
| onChanged | void Function(bool)? | 对齐 Material 回调签名 |
| openText | TSwitchThemeData | L4 → Theme |
| closeText | TSwitchThemeData | L4 → Theme |

### 废弃

_无_

### 新增

| 符号 | 说明 |
| --- | --- |
| TSwitchController（可选） | v1.0 新增 |

### export

- **保留**：`TSwitch`、`TSwitchSize`、`TSwitchThemeData`、`TSwitchController`（可选）
- **移出**：`TSwitchType`、`OnSwitchChanged`、`enable` 参数文档（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TSwitchThemeData` · Material: **Switch.adaptive** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `trackColor` / `thumbColor` / `overlayColor` / `splashRadius` / `materialTapTargetSize` | Material **`SwitchThemeData`** | 三态（`WidgetStateProperty`）；映射 0.2.x `trackOnColor`/`trackOffColor` 等 |
| `defaultSize` | TDesign **`TSwitchThemeData`** | Material 子主题无 TDesign 尺寸枚举（大/中/小） |
| `variant`（原 `TSwitchType`） | TDesign **`TSwitchThemeData`** | loading 等 TDesign 语义；Material `Switch` 无对应 variant |
| `openText` / `closeText` | TDesign 扩展 | Material **`Switch` 无 thumb 内文案**；0.2.x 构造器迁入 Theme |
| `thumbContentOnFont` / `thumbContentOffFont` | TDesign 扩展 | thumb 文案 `TextStyle`；Material 无 |
| `thumbContentOnColor` / `thumbContentOffColor` | TDesign 扩展 | 文案色；Material `SwitchThemeData` 无此粒度 |
