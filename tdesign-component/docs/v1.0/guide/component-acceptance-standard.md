# 组件整体工作验收标准（v1.0）

> 组件从设计定稿到落地交付的**整体工作验收标准**，覆盖 API 实现、样式、测试、文档、Demo 五个维度。
> 各维度的详细规则以对应权威文档为准：
> - 测试 / 覆盖率 → [testing.md](./testing.md)
> - Theme / 样式优先级 → [theme.md](./theme.md)
> - 组件 md 编写 → [component-doc.md](./component-doc.md)
> - 注释生成文档 → [doc-generation.md](./doc-generation.md)
> - 升级全流程 → [component-upgrade-sop.md](./component-upgrade-sop.md)

---

## 一、核心验收项（4 条）

- [ ] **API 实现**：所有 API 均按已定稿方案实现；**样式保持与之前的 tdesign-flutter 一致**（视觉表现不回退）。
- [ ] **Theme 覆盖**：Theme Token 支持 **全局 `Theme.of`** 与 **组件级 `Theme.of`** 两层注入；`style` 能按优先级顺序**正确覆盖**样式（实例 > 组件 Theme > Material > Token）。
- [ ] **测试覆盖率**：**每个组件行覆盖率均达到 95% 及以上**。
- [ ] **文档注释**：至少对每个**暴露的 API** 都有清晰的中文 `///` 注释规范；可使用 `demo_tool`（tdesign_flutter_tools）从中生成 table 形式的 API 文档。

---

## 二、补充验收项（7 条）

- [ ] **A. Demo / Example**：`example/lib/page/t_{x}_page.dart` 至少含——基础用法 / 配色尺寸对比 / Theme 子树注入 / 禁用态 / 交互；在 `config.dart` 注册并标 `(V1.0)`；可展示片段加 `@Demo(group:)`，group 与 `exampleCodeGroup` 同字面量，能生成 `example/assets/code/` 代码块。
- [ ] **B. 控制类 & 禁用写法**：A 类 `onPressed: null` = 禁用；B·C·F 类 `onChanged: null` = 禁用；D 类 `enabled: false` / `readOnly: true`；E 类不调 `show` 即不显；**不暴露统一 `disabled` 构造器**。
- [ ] **C. export 收敛**：仅 export Widget / ThemeExtension / Controller / 必要 enum；`*Style` 与内部类**不 export**（否则生成文档会带出内部样式类）。
- [ ] **D. 生成文档与设计稿一致**：`demo_tool` 生成的 table 文档，其内容与 `docs/v1.0/components/*.md` 的 **§1 定稿一致**（以 §1 为唯一基准）。
- [ ] **E. CI 双端真机 + Golden**：`flutter test` / `dart analyze` 零 ERROR；`example` 在 **Android 16（API 36）** / **iOS 26** 各跑一轮；P0 组件（TButton / TSlider / TTabBar）留存 Golden 关键态截图。
- [ ] **F. 样式 resolve 单入口**：`build` 内**禁止**内联颜色/尺寸计算，统一走 `t_{x}_resolve.dart`；子树覆盖用 `Theme.of(context).mergeExtension(...)`（**不用** `copyWith(extensions:)` 覆盖）。
- [ ] **G. Web 网页验收**：`example` 经 `flutter run -d chrome` 在 **Web（Chrome）** 可正常加载；组件在网页端**渲染无布局溢出 / 错位**；交互（点击、滚动、弹层 `show`）可用；字体与图标正常显示、**无控制台报错**；Theme 子树注入在 Web 端同样生效；窄屏（如 375 宽）下不破损。

---

## 三、总体通过门槛

同时满足以下条件，方视为组件交付完成：

1. **一、核心验收项** 4 条全部勾选；
2. **二、补充验收项** 7 条全部勾选；
3. `flutter test` 全绿、`dart analyze` 零 ERROR；
4. 行覆盖率 ≥ 95%，CI 3.32 + 3.44 双矩阵通过；
5. `example` 在 Android 16 / iOS 26 各跑通一轮；
6. `demo_tool/all_build.sh` 跑通，Example「i」API 与组件 md §1 一致。

> 说明：本节为「整体工作验收标准」的总入口；逐项判定细则见各权威文档对应章节。

---

## 四、Theme 接入验证方法

> 方案本身见 [theme.md](./theme.md)（四层架构 + 优先级 + 子树覆盖）。本节只回答「**怎么验证实现者按规则接了 Token / Theme**」——实现者只需照 theme.md 接入，无需自创主题机制。

验收方按下述三档验证：

### 档 1 · 静态核查（grep 排硬伤）

| 核查项 | 期望 | 出处 |
|---|---|---|
| 构造器 `themeData:` | **无**（禁止该参数） | theme.md §2.1 |
| `copyWith(extensions:` | **无**，改用 `mergeExtension(...)` | theme.md §3 |
| `TTheme.of(` / `TTheme._singleData` 残留 | 无（旧 API 已删） | theme.md §5 |
| `build` 内 `Colors.` / `Color(` 硬编码色（非 P0 逃逸舱） | 无（应从 Token / Theme 读） | theme.md §2.1 |

### 档 2 · Widget 单测（验证 Token 真被读 + 优先级正确）

- **Token 真读取**：测试中把 `TThemeData` 某主色改为特定值（如 `purple`），渲染组件后断言该色取自 Token 而非常量；断言失败即「硬编码，未接 Token」。
- **优先级覆盖**：逐级覆盖断言 **P0 实例 > P1 组件 Theme > P2 Material > P4 Token**（口诀：实例 > 组件 > Material > Token）。
- **子树 merge**：用 `Theme.of(context).mergeExtension(T{Xxx}ThemeData(...))` 包一颗组件，断言构造器未传项被 Theme 覆盖（对应 testing.md Tier1 子树）。

### 档 3 · 真机 / Web 目测 + Golden

- 切 **light / dark** 两套 Token，组件随 Token 变化；窄屏 / **Web（Chrome）** 不破损（对应补充项 G）。
- 主题相关关键态留存 Golden 截图。
