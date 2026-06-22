# TSteps — v1.0 定稿

> Sprint **S3** | 控制类 **C** | Material: Stepper
> 源码：`lib/src/components/steps` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 连续值控件薄包装 |
| Material | Stepper |
| Theme | `TStepsThemeData` |
| 禁用 | `readOnly: true` 表示不可点击切换步骤（流程展示态）。整颗不可改 `value` 时用 `onChanged: null`（C 类）。 |
| L4 | 构造器 L4 → `TStepsThemeData` |

## 受控

`value` + `onChanged`（含 `onChangeStart`/`End` 等）。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TStepsDirection | KEEP：L1 语义枚举 |
| direction | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| activeIndex | value | 命名对齐 v1.0 |
| status | TStepsThemeData | L4 → Theme |
| simple | TStepsThemeData | L4 → Theme |
| verticalSelect | TStepsThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TStepsStatus | 内部状态枚举，v1.0 不公开 |

### 新增

_无_

### export

- **保留**：`TSteps`、`TStepsDirection`、`TStepsThemeData`
- **移出**：`TStepsStatus` 内部状态 enum（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TStepsThemeData` · Material: **Stepper** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `steps` | Material **`Stepper.steps`** | 实例步骤数据 KEEP |
| `currentStep` 语义 | Material **`Stepper.currentStep`** | 映射 **`value`** |
| `onStepTapped` | Material **`Stepper`** | 映射 **`onChanged`**；`readOnly: true` 时不触发 |
| `type` / `controlsBuilder` | Material **`Stepper`** | TDesign **`simple`** / 自绘 → Theme |
| `direction` | Material **`StepperType`** | 实例 **`TStepsDirection`** KEEP |
| `status` / `verticalSelect` | TDesign **`TStepsThemeData`** | L4 |
