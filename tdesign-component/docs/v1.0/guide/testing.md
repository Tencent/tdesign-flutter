# 测试与注释（v1.0）

> v1.0 测试门槛与注释规范。
> 环境 / 命令 → [developer-guide.md](./developer-guide.md) · 组件 **§4** 写法 → [component-doc.md §2](./component-doc.md#2-章节结构s1-三板)
>
> **边界**：组件 md（§1–§3）定义**目标 API**；本文件的「测试 / 验收」针对**真正落地组件实现**时。若只改了组件 md（如控制方案行措辞、Theme 字段核对），对应验收是 [component-doc.md §8](./component-doc.md) 的文档验收，而非实现测试。

---

## 1. CI 与覆盖率 {#1-ci-与覆盖率}

| 项 | v1.0 目标 |
|---|---|
| Flutter SDK | ≥ **3.32.0**（最低）；CI **3.32** + **3.44** 双矩阵 |
| 覆盖率 | `lib/src` 行覆盖率 ≥ **95%** |
| 真机 / 模拟器 | `example` 至少在 **Android 16（API 36）**、**iOS 26** 各跑通一轮 |
| CI | `flutter test` + `example` 可构建 |

---

## 2. 测试分层

| 层级 | 写什么 | 在哪 |
|---|---|---|
| **全局** | 控制类通用必测、Golden 优先级、Form、注释规则 | **本文 §3–§5** |
| **组件专项** | resolve/绘制单路径、该组件必测表、Example 契约 | 组件 md **§4**（S1 样板：[button.md](../components/01-base/button.md)） |

**原则**：§4 **不重复**本文 CI/覆盖率条文；文首链 `testing.md` 一句 + §4.2 专项表。无 §4 的组件按本文 §3 + Tier 验收。

### 2.1 测试文件位置 / 运行 / 命名

**文件位置**：每个组件测试置于 `test/components/{组件名}/` 下，文件名为 `t_{组件名}_test.dart`。
- 例：`test/components/button/t_button_test.dart`、`test/components/link/t_link_test.dart`
- Golden 测试同目录，命名 `t_{组件名}_golden_test.dart`，与 Widget 测试同 PR 维护。

**如何运行**：
- 全部测试：`flutter test`
- 单个组件：`flutter test test/components/button/t_button_test.dart`
- 更新 Golden 基线（仅本地）：`flutter test --update-goldens`
- 查看覆盖率：`flutter test --coverage`（结合 `lcov` / `genhtml` 查看 `lib/src` 行覆盖率，目标 ≥ 95%）

**命名规则**：
- 文件：`t_{组件名}_test.dart`（前缀 `t_` 便于工具 / CI 识别；组件名与 `config.dart` 的 key 对齐）。
- 用例：`test('中文描述预期行为', () {...})`，同类归到 `group('子系统', () {...})`（如 `'disabled 态 onPressed: null 时不响应点击'`）。
- Golden：`expectLater(..., matchesGoldenFile('goldens/{组件名}_{状态}.png'))`。

---

## 3. Widget 必测（按控制类）

> 禁用写法 → [api.md §5](../foundation/api.md#5-禁用0.2x--v10) · 控制类 → [controlled.md](../foundation/controlled.md)

| 控制类 | 代表 | 至少覆盖 |
|---|---|---|
| **A** | Button、Link、Cell | `onPressed` / `onTap` 主路径；**`null` = 禁用**（无 `disabled` 构造器） |
| **B/C** | Switch、Slider、Rate | `value` + `onChanged` 受控；**`onChanged: null` = 禁用** |
| **D** | Input、Textarea | `controller` 主路径；`enabled: false` / `readOnly: true`（**勿**用 `onChanged: null` 表禁用） |
| **E** | Popup、Dialog、Toast | 仅 `show()` / `show*`；不调 show 即不显 |
| **F** | Picker、Calendar | `value` + `onChanged`；`onChanged: null`；项级 `*.disabled` **KEEP** |

**Tier1** 额外要求：**Theme 子树** `mergeExtension(T{Xxx}ThemeData)` 覆盖构造器未传项（见 [theme.md §3](../foundation/theme.md#3-子树覆盖)）。

**Form**：容器 `submit` / `reset` / `validate`；字段 + Form 至少一条 **`rules` 失败态** → [form.md](../foundation/form.md)。

---

## 4. Golden {#4-golden}

| 优先级 | 组件 | 说明 |
|---|---|---|
| **P0** | TButton | 默认 · primary · danger · disabled · 纯 `icon` + `shape: circle` 等（见 [button.md §4.2](../components/01-base/button.md#42-测试与-example-契约)） |
| **P0** | TSlider | normal / capsule 等关键态 |
| **P0** | TTabBar | `outlineType` 等关键组合 |
| **P1** | 其余 | 按组件 md **§4.2**「Golden」行；无 §4 则 Sprint 排期后补 |

Golden 文件放 `test/`，与 Widget 测试同 PR 维护。

---

## 5. 注释与文档生成 {#5-注释与文档生成}

| 项 | v1.0 |
|---|---|
| 扫描范围 | 仅 `tdesign_flutter.dart` **export** 符号 |
| 语言 | 中文 `///` 注释 |
| 对齐 | 注释 ↔ 组件 md **§1** |
| 废弃 | 注释不写「仍可使用」 |

流程、登记、`all_build.sh`、排错 → **[doc-generation.md](./doc-generation.md)**

---

## 6. 发布前（单组件）{#6-发布前单组件}

| 步 | 检查项 |
|---|---|
| 1 | `example` 该页 **v1.0 API** 可跑；**Android 16** / **iOS 26** 各验证一次（见 [§1](#1-ci-与覆盖率)） |
| 2 | Widget：本文 [§3](#3-widget-必测按控制类)（+ 组件 **§4.2** 若有） |
| 3 | Golden：本文 [§4](#4-golden)（+ 组件 **§4.2** 若有） |
| 4 | export 与 [api.md §8](../foundation/api.md#8-exportv10-公开面) · [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致 |
| 5 | 文档生成：`all_build.sh` 跑通、Example「i」与 §1 一致（见 [doc-generation.md §6](./doc-generation.md#6-发布前文档)） |
| 6 | Web 网页：`example` 在 **Chrome** 可加载、渲染无溢出、交互可用（见 [component-acceptance-standard.md 补充项 G](./component-acceptance-standard.md)） |

**§4 已含专项契约的组件**：Button · Divider · Fab · BackTop（实现时以各 md §4.2 为准）。

---

## 7. 验收标准与清单（索引）

> 整体工作验收标准的「总入口」见 [component-acceptance-standard.md](./component-acceptance-standard.md)；本节约列**三路验收清单去哪查**。

### 7.A 实现 / 升级验收 → component-upgrade-sop.md §8

七步流程（SOP §2）第 ⑦ 步即「跑 §8 清单，全部勾选才算完成」。清单分五类：

- **代码**：三件套齐全（主 Widget + ThemeData + Resolve[若需]）；构造器 L1–L3、L4 已迁入 Theme；命名套全局映射；禁用写法符合控制类；build 内无内联颜色/尺寸计算；中文注释与 md §1 一致；`tdesign_flutter.dart` export 正确。
- **迁移**：lib/src 内部引用全迁；example 本组件 demo 重写；其它页面引用已迁；`config.dart` 入口注册（标 `(V1.0)`）；`component_test` 已迁。
- **测试**：测试文件已建、用例 ≥ 15；覆盖控制类必测 + Tier1 子树；`flutter test` 全通过；`dart analyze` 零 ERROR。
- **文档**：组件 md §1–§4 补齐；`example/assets/api/{组件}_api.md` 与代码一致；`*-upgrade-guide.md` 按七节模板写。
- **运行**：demo 页面可渲染（release 模式）；入口可见；Theme 子树注入生效。

### 7.B 文档验收（规格 md 本身）→ component-doc.md §8

适用于「只改了组件 md」的情形。发布前去重检查清单（10 项）：

- [ ] §1 与 §2 无同一迁移行的两张表
- [ ] §1 无 0.2.x 统计、无「原 xxx」长说明
- [ ] §2「未改」仅一行，与 §1 空决策列一致
- [ ] §2 ✨/📦 不重复罗列 §1 已列符号
- [ ] §3 仅一张字段表（+ S1 允许 §3.5 外形契约）
- [ ] P0 逃逸舱已按 theme.md §2.2 四问核对（默认无；有则 §1 标 P0）
- [ ] export 只列 🚫 移出项，不列 ✅ 全集
- [ ] 无 Dart 代码块
- [ ] 文首读法与章节职责已写清（含 §4 时注明「落地与验收」）
- [ ] 有 §4 时链 testing.md；文档生成链 doc-generation.md；不重复全局 CI 条文

### 7.C 单组件发布前 → 本文 §6

见 [§6](#6-发布前单组件)：example 可跑 + 双端验证 / Widget 必测 / Golden / export 一致 / 文档生成一致。
