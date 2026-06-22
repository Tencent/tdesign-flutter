# TStepper — v1.0 定稿

> Sprint **S2** | 控制类 **C** | Material: IconButton+TextField
> 源码：`lib/src/components/stepper` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 连续值控件薄包装 |
| Material | IconButton+TextField |
| Theme | `TStepperThemeData` |
| 禁用 | 整颗 Stepper 不可用: onChanged: null |
| L4 | 构造器 L4 → `TStepperThemeData` |

## 受控

`value` + `onChanged`（含 `onChangeStart`/`End` 等）。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TStepperSize | 尺寸 |
| TStepperController | 可选命令式控制 |
| min / max / step | 数值边界与步长 |
| disableInput | 禁用中间数字输入框 |
| onBlur | 输入框失焦 |
| onOverlimit | 超限回调 |
| eventController | 内部事件流（可选） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | C 类受控 |
| TStepperTheme | colorScheme | 原 `theme` 枚举 |
| theme | colorScheme | 命名对齐 v1.0 |
| disabled | onChanged: null | 整颗禁用 |
| inputWidth | TStepperThemeData | L4 → Theme |
| value | value（必填受控） | 移除与 defaultValue 双轨 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| defaultValue | 初值由父 State 持有，不用 Widget 级 defaultValue |
| disabled | 改用 `onChanged: null` |

### 新增

| 符号 | 说明 |
| --- | --- |
| TStepperThemeData | L4 按钮区/输入区样式 |
| TStepperOverlimitType | 保留公开 enum |

### export

- **保留**：`TStepper`、`TStepperSize`、`TStepperController`、`TStepperOverlimitType`、`TStepperThemeData`
- **移出**：`TStepperTheme`（enum）、`defaultValue`/`disabled` 废弃参数相关 export（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TStepperThemeData` · Material: **IconButton+TextField** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| 按钮区 | Material **`IconButtonTheme`** | +/- 图标按钮 |
| 输入区 | Material **`InputDecorationTheme`** | 中间数字框；`disableInput`→`enabled: false` |
| `inputWidth` / `iconVariant` / `overlimitBehavior` | TDesign **`TStepperThemeData`** | 步进器布局与超限策略 |
| `colorScheme` | TDesign 实例 | 原 `TStepperTheme` 枚举 |
