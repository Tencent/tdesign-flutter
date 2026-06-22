# TSlider — v1.0 定稿

> Sprint **S2** | 控制类 **C** | Material: Slider/RangeSlider
> 源码：`lib/src/components/slider` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 连续值控件薄包装 |
| Material | Slider/RangeSlider |
| Theme | `TSliderThemeData` |
| 禁用 | `onChanged: null`（或省略 `onChanged` ≈ 禁用）。 |
| L4 | 构造器 L4 → `TSliderThemeData` |

## 受控

`value` + `onChanged`（含 `onChangeStart`/`End` 等）。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| Position | 尺寸/位置枚举保留 |
| rightLabel | 右侧标签 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| boxDecoration | TSliderThemeData | L4 → Theme |
| leftLabel | label | 命名对齐 v1.0 |
| onChange | onChanged | 对齐 Material |
| onTap | onTap | REMOVE（Material Slider 无此项；交互走 `onChanged`） |
| sliderThemeData | TSliderThemeData | L4 → Theme |
| onThumbTextTap | onThumbTextTap | REMOVE（Material 无；低频，文档组合示例替代） |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TSlider`、`TRangeSlider`、`TSliderThemeData`、`Position`（滑块位置 enum）
- **移出**：旧普通类 `TSliderThemeData`（非 Extension）、`slider/_shapes/` 内部 Shape（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TSliderThemeData` · Material: **Slider/RangeSlider** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `activeTrackColor` / `inactiveTrackColor` / `disabledActiveTrackColor` / `disabledInactiveTrackColor` | Material **`SliderThemeData`** | 轨道三态色 |
| `thumbColor` / `overlayColor` / `valueIndicatorColor` | Material **`SliderThemeData`** | thumb 与 overlay |
| `trackHeight` / `thumbShape` / `overlayShape` / `valueIndicatorShape` / `showValueIndicator` | Material **`SliderThemeData`** | 形状与尺寸；capsule 通过自定义 `SliderComponentShape` |
| `activeTickMarkColor` / `inactiveTickMarkColor` / `tickMarkShape` | Material **`SliderThemeData`** | 刻度（`divisions` 配合） |
| `variant`（normal / capsule） | TDesign **`TSliderThemeData`** | Material 无 TDesign 胶囊 thumb 语义枚举 |
| `boxDecoration` | TDesign 扩展 | 滑条**外层容器**装饰；Material `Slider` 无 wrapper decoration |
| `labelStyle` / thumb 文案 | TDesign 扩展 | `label`/`rightLabel` 布局与 thumb 上数值文案；Material 仅 `SliderThemeData.valueIndicatorTextStyle` |
