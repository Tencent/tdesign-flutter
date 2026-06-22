# TTimeCounter — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: 自绘
> 源码：`lib/src/components/time-counter` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | 自绘 |
| Theme | `TTimeCounterThemeData` |
| 禁用 | 容器/展示无统一 bool。 |
| L4 | `theme` → **`TTimeCounterThemeData`** |

## 受控

无受控 value；按子交互控件控制类处理。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| size | 尺寸 |
| direction | 保留 |
| controller | 保留 |
| time | 保留 — 计时时长（ms） |
| format | 保留 |
| content | 保留 — 自定义展示 |
| autoStart | 保留 |
| onChanged | 由 `onChange` 迁移 |
| onFinish | 保留 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | 命名对齐 v1.0 |
| style | TTimeCounterThemeData | L4 → Theme |
| millisecond | TTimeCounterThemeData | L4 → Theme |
| splitWithUnit | TTimeCounterThemeData | L4 → Theme |
| theme | TTimeCounterThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TTimeCounter`、`TTimeCounterThemeData`
- **移出**：`TTimeCounterStyle`、`t_time_counter_style.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TTimeCounterThemeData` · Material: **自绘** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `time` / `format` / `content` | **实例 KEEP** | 倒计时/正计时核心数据 |
| `onChanged` / `onFinish` | **实例 KEEP** | tick 与完成回调 |
| `controller` | **实例 KEEP** | 开始/暂停/重置 |
| `style` / 数字块 L4 / `theme`→`variant` | TDesign **`TTimeCounterThemeData`** | 视觉默认 |
