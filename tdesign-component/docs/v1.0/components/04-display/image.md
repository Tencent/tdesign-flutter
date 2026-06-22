# TImage — v1.0 定稿

> Sprint **S2** | 控制类 **A** | Material: Image
> 源码：`lib/src/components/image` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | Image |
| Theme | `TImageThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → `TImageThemeData` |

## 受控

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| width | 自定义宽 |
| imageFile | KEEP：L1–L3 高频 / Material 同名 |
| type | KEEP：L1–L3 高频 / Material 同名 |
| loadingWidget | KEEP：L1–L3 高频 / Material 同名 |
| errorWidget | KEEP：L1–L3 高频 / Material 同名 |
| fit | KEEP：L1–L3 高频 / Material 同名 |
| frameBuilder | KEEP：L1–L3 高频 / Material 同名 |
| loadingBuilder | KEEP：L1–L3 高频 / Material 同名 |
| errorBuilder | KEEP：L1–L3 高频 / Material 同名 |
| filterQuality | KEEP：L1–L3 高频 / Material 同名 |
| alignment | KEEP：L1–L3 高频 / Material 同名 |
| repeat | KEEP：L1–L3 高频 / Material 同名 |
| semanticLabel | KEEP：L1–L3 高频 / Material 同名 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TImageType | variant 枚举 | 对齐 Material |
| imgUrl | src | 命名对齐 v1.0 |
| assetUrl | src | 命名对齐 v1.0 |
| height | TImageThemeData | L4 → Theme |
| color | TImageThemeData | L4 → Theme |
| opacity | TImageThemeData | L4 → Theme |
| colorBlendMode | TImageThemeData | L4 → Theme |
| centerSlice | TImageThemeData | L4 → Theme |
| matchTextDirection | TImageThemeData | L4 → Theme |
| gaplessPlayback | TImageThemeData | L4 → Theme |
| excludeFromSemantics | TImageThemeData | L4 → Theme |
| isAntiAlias | TImageThemeData | L4 → Theme |
| cacheHeight | TImageThemeData | L4 → Theme |
| cacheWidth | TImageThemeData | L4 → Theme |

### 废弃

_无_

### 新增

_无_

### export

- **保留**：`TImage`、`TImageThemeData`
- **移出**：`image_widget.dart` 内部 Widget（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TImageThemeData` · Material: **Image** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `width` / `height` / `fit` / `color` / `opacity` / `filterQuality` / `alignment` | Material **`Image`** | 与 Flutter 同名，**KEEP** 构造器 |
| `frameBuilder` / `loadingBuilder` / `errorBuilder` | Material **`Image`** | 加载/错误构建器 |
| `cacheWidth` / `cacheHeight` | Material **`Image`** | 解码缓存尺寸 |
| `type`（网络/文件/资源） | TDesign 扩展或 factory | 0.2.x 多源统一为 `ImageProvider` 或命名构造 |
