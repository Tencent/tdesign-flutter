# 组件 md 编写规范（v1.0）

> **已定稿（2025-06）** · S1 样板：[button.md](../components/01-base/button.md)
> 全局 API / Theme / 禁用规则 → [api.md](../foundation/api.md) · [theme.md](../foundation/theme.md) · [controlled.md](../foundation/controlled.md)

本文记录 **单篇组件 md** 的结构、图例、去重原则与章节模板。逐组件只写 **与全局规则的差异**；全局机制不重复展开。

---

## 1. 文档目标

| 读者 | 目标 |
|---|---|
| 新写 v1.0 | 只看 **§1 + §3**，拿到当前制定的完整 API 与 Theme 配法 |
| 0.2.x 升级 | 只看 **§2 + §3 末列**，知道从哪改到哪 |
| 维护 export | **§1 export** + [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) |

**原则**：同一事实只出现一次；§1 写「当前规范」，§2 写「变更路径」，§3 写「样式落点」。

---

## 2. 章节结构（S1 三板）

```
文首（元信息 + 读法 + 图例链到 §4）
## 架构（表或 1 段：实现 · Theme 类名指向 §3）
## 控制方案（控制类 A–F / `—`；链 controlled.md）
§1  v1.0 定稿 API（当前规范）
§2  0.2.x → v1.0
§3  Theme
§4  实现约定 · 测试与 Example 契约（可选；S1 起 Button / Divider / Fab 已含）
```

与其它组件 md 旧编号（§1 API · §2 Theme）不同；**以 S1 样板为准**，文首读法须写清。
**`## 控制方案`**：全库统一章节名（**禁止** `## 受控`）；A–F 可写受控要点，`—` 类写无闭环 / 通知型说明（→ [controlled.md](../foundation/controlled.md)）。

| 章节 | 写什么 | 不写什么 |
|---|---|---|
| **§1** | v1.0 构造器/类型/export 全量事实 | 不写升级步骤、不重复 §2 表 |
| **§2** | 仅相对 0.2.x **变了什么** | 不重复 §1 已列的 v1.0 参数表 |
| **§3** | Theme 选型 + 字段表（末列对接 0.2.x） | 不写 Dart 示例代码块 |
| **§4** | 单路径 resolve/绘制 + 组件专项必测 + Example 契约 | 不重复 [testing.md](./testing.md) CI/覆盖率全文；链全局规则 |

---

## 3. 文首模板

```markdown
# T{Xxx} — v1.0 定稿

> Sprint **Sx** | 控制类 **A–F** · 源码：`lib/src/components/...` · [guide](../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（L4 见 §3 末列）

**图例** → [component-doc.md §4](./component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

---

## 架构

（1 段或表：实现方式 · Theme 类名指向 §3）

## 控制方案

（控制类 **A–F** 或 **`—`**；禁用规则；链 [controlled.md](../foundation/controlled.md)）
```

- **控制类**、**Sprint**、**源码路径** 必填。
- **读法** 固定两句，只改组件名或 L4 提示（E 类可写「命令式 show 见 §1」）。

---

## 4. 决策图例（固定 6 个，不新增）

| 图例 | 含义 | 典型落点 |
|---|---|---|
| ✏️ | 改名 | 参数/枚举/typedef 换名，语义不变 |
| 🔀 | 合并 | 多参数合一（如 `icon` + `iconWidget` → `icon`） |
| 📦 | 迁入 Theme | 0.2.x 构造器 L4 → `T{Xxx}ThemeData` |
| 🗑️ | 移除 | 构造器删除；语义可能由其它参数承担（如 `disabled` → `onPressed: null`） |
| ✨ | 新增 | 0.2.x 无同名/同型项 |
| 🚫 | 移出 export | 不再可从 `tdesign_flutter.dart` import |

### 4.1 §1「决策」列规则

- 表头第一列：**决策**。
- **有变更**的入参/类型/工厂：标 ✏️ / 🔀 / ✨。
- **与 0.2.x 同名同义保留**：决策列 **留空**（不另设「保留」图标）。
- §1 导语须写：**无图例项 = 与 0.2.x 同名同义保留**；详情见 §2。

### 4.2 易混归类（撰写时必查）

| 情况 | 归类 | 说明 |
|---|---|---|
| `onTap` → `onPressed` | ✏️ | 参数一对一改名 |
| `disabled` → `onPressed: null` | 🗑️ | 删参数，**非**改名为 `onPressed` |
| `text` → `child` / 工厂 | 🔀 | `child` 0.2.x 已有，**非**改名 |
| `icon` + `iconWidget` → `icon` | 🔀 | 合并进**新**入参 |
| `title` + `titleWidget` → `title: Widget?` | 🔀 | 单槽 Widget；文案用 `Text` |
| `builderContent` → `contentBuilder` | ✏️ | Builder 用 **`{语义}Builder` 后缀** → [api.md §2.1](../foundation/api.md#21-l2-内容槽widget-实例-vs-builder-回调) |
| 0.2.x `TButtonStyle? style` | 📦 | 迁入 Theme `*Style` 或 Token resolve |
| v1.0 `ButtonStyle? style` | ✨ | P0 逃逸舱；覆盖 resolved 结果，**非**日常 `shape` 入口 |
| `shape` 等 L4 | 📦 | 能力不删；**收紧到 Theme**；展开进 resolved `ButtonStyle`，**不**写入 `*Style` 模板 |

### 4.3 export 表

只列 **🚫 移出** 项；每项说明用子图例（📦/✏️/🗑️）标替换方式。
**不**重复列出 §1 已写的可 export 符号（避免 §1 类型表 + export ✅ 双份清单）。

---

## 5. §1 v1.0 定稿 API（当前规范）

### 5.1 标题与导语

```markdown
## 1. v1.0 定稿 API（当前规范）

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。无图例项 = 与 0.2.x 同名同义保留。

层级 → [api.md §1](../foundation/api.md#1-构造器四层l1l4)
```

### 5.2 构造器与工厂（一张表）

| 列 | 必填 | 说明 |
|---|---|---|
| 决策 | 是 | 见 §4.1 |
| 参数/方法 | 是 | 含 static `show*`、工厂方法单独行 |
| 层级 | 是 | L1–L3 或 P0 逃逸舱 |
| 类型 | 是 | Dart 类型 |
| 默认 | 是 | 字面默认值或 `Theme` / `defaultXxx` |
| 说明 | 是 | 简短；枚举成员可写在说明或类型列 |

- 工厂、`show` 族与构造器 **同表**，不另开小节。
- **`Key`**：Flutter Widget 基建，**不进 §1.1 表**；全库约定 → [api.md §1.1](../foundation/api.md#11-flutter-keywidget-基建)。
- **禁止**在 §1 写「相对 0.2.x：✅ N 项…」统计（那是 §2 的事）。

### 5.3 类型（一张表）

| 列 | 必填 |
|---|---|
| 决策 | 是 |
| 类型 | 是 |
| 成员 | 是（enum 列出） |
| 用于 | 构造参数名或 Theme 字段 |

### 5.4 export

🚫 移出表 + 附录 C 链接 +「替换细节 §2」一句。

---

## 6. §2 0.2.x → v1.0

### 6.1 结构（按决策分节，不建「保留」大表）

```markdown
## 2. 0.2.x → v1.0

**未改**（§1 无图例项）：`...`（一行枚举即可）

### ✏️ 改名
（表：0.2.x | v1.0 | 怎么改）

### 🔀 合并
### 🗑️ 移除

### 📦 迁入 Theme · ✨ 新增
（各一段要点，不重复 §1 表；📦 指向 §3 末列，✨ 指向 §1 图例项）
```

### 6.2 表内写法

- 每行格式：**从哪 → 到哪 → 怎么改**（文字说明，避免大段代码块）。
- 参数与枚举 **同一行** 写清（如 `type` / `TButtonType` → `variant` / `TButtonVariant`）。
- §2 **不**复制 §3 的完整 L4 字段表，只写「见 §3 末列」。

---

## 7. §3 Theme

```markdown
## 3. Theme

✨ `T{Xxx}ThemeData` = … · [theme.md](../foundation/theme.md)

（配置选型表：单颗 / 一区 / 全局 — 3 行）

覆盖顺序：构造器 P0 `style` **>** `resolve` 全量 `ButtonStyle` **>** Token · **不**以 Material `defaultStyleOf` 为起点

（字段表：决策 | 字段 | 管什么 | 0.2.x 构造参数）

（单颗破例一句：指向 §1 ✨ 逃逸舱，如有）

**S1 样板例外**：`TButton` 外形解析见 **§3.5**（非所有组件标配）。
```

### 7.1 字段表

- **一张表** 合并「Material vs TDesign」与「0.2.x 迁入对照」；末列写 0.2.x 构造参数名，无则 `—`。
- ✨：Theme 内 v1.0 新字段（如 `defaultVariant`）。
- 📦：由 0.2.x 构造器迁入的字段。
- **`*Style`**：仅作 **P2 可选**色板覆写时写明；默认 resolve 走 Token 的组件须在表中注明。
- 不为单个字段写长文专节（如 `shape`）；**`TButton` §3.5** 为 S1 外形解析例外。

### 7.2 P0 逃逸舱（写 / 评审）

是否增加构造器 `style` / `decoration` → **[theme.md §2.2](../foundation/theme.md#22-p0-逃逸舱判定) 四问判定**（**默认无**）。

| 结果 | §1 / §3 写法 |
|------|----------------|
| **无 P0**（多数） | §3「单颗」= 子树 `mergeExtension` 或 L1 `variant` 等；§1 **不出现** `T{Xxx}Style?` |
| **有 P0**（Button / Text / Input 等） | §1.1 层级列 **`P0`**；§3 覆盖顺序 **P0 > P1 > …** |

发布前核对：非 Material 逃逸舱组件若 §1 有「规划逃逸舱」一行 → **删或补四问裁决理由**。

---

## 8. 去重检查清单（发布前）

- [ ] §1 与 §2 无同一迁移行的两张表
- [ ] §1 无 0.2.x 统计、无「原 xxx」长说明
- [ ] §2「未改」仅一行，与 §1 空决策列一致
- [ ] §2 ✨ / 📦 不重复罗列 §1 已列符号
- [ ] §3 仅一张字段表（+ S1 允许 **§3.5** 外形契约）；无 §3.2/§3.3 拆分重复
- [ ] P0 逃逸舱已按 [theme.md §2.2](../foundation/theme.md#22-p0-逃逸舱判定) 四问核对（默认无；有则 §1 标 P0）
- [ ] export 只列 🚫，不列 ✅ 全集
- [ ] 无 Dart 代码块（示意用表内反引号即可）
- [ ] 文首读法与章节职责已写清（含 §4 时注明「落地与验收」）
- [ ] 有 §4 时链 [testing.md](./testing.md)；文档生成链 [doc-generation.md](./doc-generation.md)；不重复全局 CI 条文
- [ ] 附录 C、api.md、theme.md 只链一次

---

## 9. 控制类差异（撰写提示）

| 控制类 | §1 侧重 | §2 注意 | §3 |
|---|---|---|---|
| **A** | 构造器 + `onPressed` | `disabled` → 回调 `null` | 通常有 |
| **B/C/F** | `value` + `onChanged` | `enable`/`checked` 等改名 | 常有 |
| **D** | `controller` / `decoration` | L4 → Theme 或逃逸舱 | 常有 |
| **E** | **show 族** 为主表 | show 参数 L4 → Theme；**无** `visible` | 常有 |
| 无 L4 | — | — | §3 可缩短或写「无组件 Theme」 |

E 类将「构造器与工厂」改为「命令式 API（show 族）」表，列仍含决策、层级、类型。

---

## 10. 样板与推广

| 项 | 路径 |
|---|---|
| S1 参考实现 | [components/01-base/button.md](../components/01-base/button.md)（含 **§4** 测试契约） |
| S2 纯展示 / T2 | [components/01-base/text.md](../components/01-base/text.md)（**架构设计**）、[divider.md](../components/01-base/divider.md) |
| export 全量审计 | [v1.0-redesign-spec 附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) |
| 全局 API 四层 | [api.md §1](../foundation/api.md#1-构造器四层l1l4) |
| Theme 优先级 | [theme.md §2](../foundation/theme.md#2-样式优先级-p0p4) · P0 四问 [§2.2](../foundation/theme.md#22-p0-逃逸舱判定) |

新组件 md **优先复制 button.md 骨架**（含 §4），再按控制类替换 §1 主表与 §3 字段行。
