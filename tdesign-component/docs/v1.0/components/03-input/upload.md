# TUpload — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: image_picker
> 源码：`lib/src/components/upload` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | image_picker |
| Theme | `TUploadThemeData` |
| 禁用 | 废弃 Widget 级 `disabled`。 |
| L4 | `type` → **`TUploadThemeData`** |

## 受控

无受控 value；按子交互控件控制类处理。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| width | 图片宽度 |
| TUploadValidatorError | 保留 |
| max | 保留 |
| type | 保留 |
| variant 枚举 | 由 `TUploadMediaType` 迁移 |
| onPressed | 由 `onClick` 迁移 |
| onChanged | 由 `onChange` 迁移 |
| files | 保留 — 受控列表 |
| multiple | 保留 |
| onCancel / onError / onValidate | 保留 — 生命周期回调 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TUploadMediaType | variant 枚举 | 对齐 Material |
| TUploadType | variant 枚举 | 对齐 Material |
| TUploadBoxType | variant 枚举 | 对齐 Material |
| onClick | onPressed | 命名对齐 v1.0 |
| onChange | onChanged | 命名对齐 v1.0 |
| disabled | onPressed: null | Material 禁用 |
| height | TUploadThemeData | L4 → Theme |
| wrapSpacing | TUploadThemeData | L4 → Theme |
| wrapRunSpacing | TUploadThemeData | L4 → Theme |
| wrapAlignment | TUploadThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TUploadFileStatus | 内部状态枚举，v1.0 不公开 |

### 新增

_无_

### export

- **保留**：`TUpload`、`TUploadThemeData`、`TUploadValidatorError`
- **移出**：`TUploadFileStatus` 内部状态 enum（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TUploadThemeData` · Material: **image_picker** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `files` / `onChanged` | 受控列表 | C 类；Form **`TFormField<List<TUploadFile>>`** |
| `max` / `mediaType` / `sizeLimit` / `multiple` | 实例 KEEP | 上传业务约束 |
| `onUploadTap` / `onCancel` / `onError` / `onValidate` / `onMaxLimitReached` | 实例回调 | KEEP |
| `onPressed: null` | 上传区禁用 | 替代 0.2.x `disabled`；删除/预览子动作分别置 null |
| 选图/拍图 | **`image_picker`** | 平台能力；非 Material Widget |
| `width` / `height` / `wrapSpacing` / `wrapRunSpacing` / `wrapAlignment` | **`TUploadThemeData`** | 缩略图网格 L4 |
| `type` / variant 枚举 | TDesign 扩展 | 展示形态（卡片/网格等） |
