# 文档生成（v1.0）

> Example 内 API 文档与演示代码由 **`tdesign_flutter_tools`** 从源码注释生成。
> 环境 → [developer-guide.md](./developer-guide.md) · 注释对齐 §1 → [testing.md §5](./testing.md#5-注释与文档生成) · 组件 md 写法 → [component-doc.md](./component-doc.md)

---

## 1. 两套文档，勿混用

| 文档 | 路径 | 谁写 | 用途 |
|---|---|---|---|
| **v1.0 设计稿** | `docs/v1.0/components/*.md` | 人工（按 component-doc） | Sprint 定稿 API / Theme / 升级对照 |
| **生成物** | `example/assets/api/` | `tdesign_flutter_tools` | Example App 右上角「i」API 面板 |

**v1.0 原则**：实现组件时，**公开 API 中文 `///` 注释与组件 md §1 一致**；工具只扫 `tdesign_flutter.dart` **export** 的符号（见 [api.md §8](../foundation/api.md#8-exportv10-公开面)）。

**勿手工改** `tdesign-site/src/**/README.md`（站点由流水线打包生成）。

---

## 2. 生成流程

```text
源码 /// 注释 + export
    → demo_tool/all_build.sh（按组件登记）
    → example/assets/api/{folder-name}/
    → Example 内查看 / CI generate api md 步骤
```

### 2.1 本地命令

```bash
cd tdesign-component
# 全量（与 CI 一致）
sh demo_tool/all_build.sh

# 单组件（示例）
dart run tdesign_flutter_tools:main generate \
  --file lib/src/components/button/t_button.dart \
  --name TButton \
  --folder-name button \
  --output example/assets/api/ \
  --only-api
```

**前置**：`demo_tool/version` 填入当前 Dart SDK 版本（与本地 Flutter 一致）。

工具参数说明 → [demo_tool/README.md](../../demo_tool/README.md)

### 2.2 新增 / 改 API 时登记

| 步 | 做什么 |
|---|---|
| 1 | 符号加入 `lib/tdesign_flutter.dart` export（v1.0 收敛规则见 api §8） |
| 2 | 在 `demo_tool/all_build.sh` 增加一行 `generate`（或补全 `--name` 列表） |
| 3 | **`--folder-name`** 与 `example/lib/config.dart` 中该组件 **key 一致** |
| 4 | 跑 `all_build.sh`，Example 对应页点「i」核对 |

CI（`test-build.yml`）会在 build 前执行 `sh ./demo_tool/all_build.sh`。

---

## 3. 注释约束（工具可解析）

| 规则 | 说明 |
|---|---|
| 构造器位置 | 类名下**第一行**代码，构造器**上方不能有注释** |
| 字段注释 | 成员用 `///`，**不用** `//` |
| 构造器 | **不要** `@override` |
| Widget 类 | 必须有 `///` 组件简介 |
| 参数 | 每个公开构造参数 `///` 简介 |

与 v1.0 冲突时：**先满足工具可生成，再与组件 md §1 对齐命名**；词法分析不够时用 `--use-grammar`。

---

## 4. 演示代码（`@Demo`）

演示片段由 **Flutter AOP** 扫描 `@Demo` 生成，输出到 `example/assets/code/`。

| 要求 | 说明 |
|---|---|
| 提取方法 | 可展示 UI 拆成独立方法，加 `@Demo(group: 'xxx')` |
| `group` | 与 `ExamplePage` 的 `exampleCodeGroup` **同字面量**，不能是变量或拼接 |
| 查看 | Example 页切换示例后看代码区；PR 后 CI 打 APK 验收 |

AOP 与 3.44 CI 仍在演进；本地以 3.32 为准。

---

## 5. 常见问题

| 现象 | 排查 |
|---|---|
| Example「i」无 API / 缺参数 | `all_build.sh` 是否登记；`--name` 是否含该类；是否已 export |
| `folder-name` 对不上 | 与 `example/lib/config.dart` 的 key 对齐（如 `back-top` ≠ `backtop`） |
| 某参数无文档 | 是否 `///`；构造器上是否有注释挡词法解析 |
| 生成了不应公开的 Style | 检查是否仍从 `tdesign_flutter.dart` export；v1.0 应移出 export |
| 改了注释页面未更新 | 重新跑 `all_build.sh`；确认改的是 export 符号而非 `src/` 内部类 |
| 与组件 md §1 不一致 | 以 **§1 定稿** 为准改注释；§2 只写升级差异，不参与生成 |
| 演示代码未出现 | `@Demo` 的 `group` 是否与 `exampleCodeGroup` 一致；方法是否被 `ExampleItem` 引用 |

---

## 6. 发布前（文档）

- [ ] `all_build.sh` 已登记且本地跑通
- [ ] Example「i」API 与组件 md **§1** 一致
- [ ] 未 export 的符号不出现在生成物中
- [ ] 有 `@Demo` 的示例 `group` 正确

完整单组件清单 → [testing.md §6](./testing.md#6-发布前单组件)
