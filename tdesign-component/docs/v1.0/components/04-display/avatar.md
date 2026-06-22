# TAvatar — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: CircleAvatar
> 源码：`lib/src/components/avatar` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | CircleAvatar |
| Theme | `TAvatarThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TAvatarThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TAvatarSize | 尺寸/位置枚举保留 |
| size | 头像尺寸 |
| type | KEEP：L1–L3 高频 / Material 同名 |
| text | KEEP：L1–L3 高频 / Material 同名 |
| icon | KEEP：L1–L3 高频 / Material 同名 |
| fit | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TAvatarType | variant 枚举 | 对齐 Material |
| TAvatarShape | TAvatarThemeData | L4 → Theme |
| onTap | onPressed | 命名对齐 v1.0 |
| shape | TAvatarThemeData | L4 → Theme |
| radius | TAvatarThemeData | L4 → Theme |
| avatarSize | TAvatarThemeData | L4 → Theme |
| avatarDisplayBorder | TAvatarThemeData | L4 → Theme |
| backgroundColor | TAvatarThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TAvatar`、`TAvatarSize`、`TAvatarThemeData`
- **移出**：内部绘制 helper、未公开 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TAvatarThemeData` · Material: **CircleAvatar** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundImage` / `foregroundImage` | Material **`CircleAvatar`** | 实例 **`avatarUrl`** / **`defaultUrl`** / 资源列表 |
| `child` | Material **`CircleAvatar`** | 实例 **`displayText`** / **`icon`** / **`avatarDisplayWidget`** |
| `radius` / `backgroundColor` / `foregroundColor` | Material **`CircleAvatar`** | 默认 → **`TAvatarThemeData`**；`shape` 同理 |
| `avatarDisplayList` / 组叠 | TDesign 扩展 | 头像组业务槽位 **KEEP** |
| `avatarSize` / `avatarDisplayBorder` | TDesign **`TAvatarThemeData`** | L4 默认 |
