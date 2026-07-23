# TDesign Flutter V1.0 组件自动化验收工具

基于 [`component-acceptance-standard.md`](../../docs/v1.0/guide/component-acceptance-standard.md) 验收文档，自动检查全部 11 项验收标准（4 核心 + 7 补充）+ 3 档 Theme 验证。

## 快速开始

```powershell
# 全量执行（含 flutter test --coverage + dart analyze + API 文档生成）
cd tdesign-component
.\scripts\acceptance\run-acceptance.ps1

# 仅静态扫描（跳过测试和构建，秒级完成）
.\scripts\acceptance\run-acceptance.ps1 -SkipTests -SkipBuild

# 含 Theme 档2 Widget 测试
.\scripts\acceptance\run-acceptance.ps1 -RunThemeTest
```

## 文件结构

```
scripts/acceptance/
├── acceptance_check.dart      # Dart 验收引擎（核心，可独立运行）
├── component_meta.dart         # 57 个组件元数据配置
├── run-acceptance.ps1          # PowerShell 编排脚本（Windows 本地）
├── acceptance-report.md        # 生成的验收报告（运行后产出）
└── README.md                   # 本文档

test/acceptance/
└── theme_acceptance_test.dart  # Theme 档2 Widget 测试（Token 读取 + 优先级 + mergeExtension）

.github/workflows/
└── acceptance.yml              # CI 自动验收工作流
```

## 验收项映射

| 验收文档条目 | 检查方式 | 脚本函数 |
|-------------|---------|---------|
| **核心1** API 实现 + 样式不回退 | 档1 静态核查 + 项F | `checkStaticGrep()` `checkResolveSingleEntry()` |
| **核心2** Theme 覆盖（两层 + 优先级） | 档1 grep + 档2 Widget 测试 | `checkStaticGrep()` + `theme_acceptance_test.dart` |
| **核心3** 覆盖率 ≥ 95% | 解析 lcov.info | `checkCoverage()` |
| **核心4** 文档注释 | /// 注释扫描 | `checkDocComments()` |
| **项A** Demo 注册 | config.dart + page 文件 | `checkDemoRegistration()` |
| **项B** 禁用写法 | A/B/C 类不暴露 disabled | `checkDisabledConvention()` |
| **项C** export 收敛 | *Style 不 export | `checkExportConvergence()` |
| **项D** API 文档一致 | 生成 API vs §1 参数表 | `checkApiDocConsistency()` |
| **项E** CI 双端 + Golden | analyze + Golden + 测试 | `checkAnalyze()` `checkGoldenExistence()` `checkTestFiles()` |
| **项F** resolve 单入口 | build 无内联色值 | `checkResolveSingleEntry()` |
| **项G** Web 验收 | flutter build web | CI Job 4 |
| **档1** 静态核查 | grep 4 项硬伤 | `checkStaticGrep()` |
| **档2** Widget 单测 | Token + 优先级 + merge | `theme_acceptance_test.dart` |
| **档3** 真机/Web 目测 | 人工 | 不在自动化范围 |

## 档1 静态核查详情

| 核查项 | 期望 | 检测方法 |
|--------|------|---------|
| 构造器 `themeData:` 参数 | **无** | 正则扫描组件 .dart 文件（排除 theme_data 文件） |
| `copyWith(extensions:` | **无** | 正则扫描 lib/src（排除 t_theme.dart 实现） |
| `TTheme.of(` 残留 | **无** | 正则扫描 lib/src |
| build 内 `Colors.` 硬编码 | **无**（白名单除外） | 正则扫描，白名单：transparent/white/black 等 |

## 命令行参数

### Dart 脚本（`acceptance_check.dart`）

```bash
# 全量执行
dart run scripts/acceptance/acceptance_check.dart

# 跳过测试（不运行 flutter test / dart analyze）
dart run scripts/acceptance/acceptance_check.dart --skip-tests

# 跳过构建（不运行 all_build.sh）
dart run scripts/acceptance/acceptance_check.dart --skip-build

# 两者都跳过（仅静态扫描）
dart run scripts/acceptance/acceptance_check.dart --skip-tests --skip-build
```

### PowerShell 脚本（`run-acceptance.ps1`）

```powershell
.\run-acceptance.ps1                    # 全量
.\run-acceptance.ps1 -SkipTests         # 跳过测试
.\run-acceptance.ps1 -SkipBuild         # 跳过 API 文档生成
.\run-acceptance.ps1 -RunThemeTest      # 额外执行 Theme 档2 测试
```

## CI 自动触发

`.github/workflows/acceptance.yml` 在 PR / push 到 develop 分支时自动执行：

| Job | 内容 | 触发条件 |
|-----|------|---------|
| `static-checks` | dart analyze + 静态核查 | 始终 |
| `test-coverage` | flutter test --coverage + Theme 档2 + 全量核查 | static-checks 通过后 |
| `api-doc-consistency` | all_build.sh + API 文档比对 | static-checks 通过后 |
| `web-build` | flutter build web（项G） | static-checks 通过后 |

## 验收报告

运行后生成 `scripts/acceptance/acceptance-report.md`，包含：

- **汇总表**：检查项总数 / 通过 / 失败 / 通过率 / 总体结论
- **详细结果**：按分类分组，每项 pass/fail + 明细
- **验收标准映射表**：11 项验收标准 × 对应检查项 × 结果

## 组件元数据维护

`component_meta.dart` 定义了 57 个组件的元数据。新增组件时需在此文件添加条目：

```dart
ComponentMeta(
  dirName: 'new_component',        // lib/src/components/ 目录名
  widgetName: 'TNewComponent',     // 主 Widget 类名
  controlClass: ControlClass.a,    // 控制类（a/bc/d/e/f/display）
  hasResolve: false,               // 是否有 resolve 文件
  configKey: 'newComponent',       // config.dart 注册 key
  apiFolderName: 'new-component',  // all_build.sh --folder-name
  docPath: 'docs/v1.0/components/01-base/new-component.md',
  isP0Golden: false,               // 是否 P0 Golden 组件
)
```

## 限制与说明

1. **Colors. 白名单**：`Colors.transparent`/`Colors.white`/`Colors.black` 等被视为合法（Material 默认色），不报错。仅 `Color(0x...)`/`Color.fromARGB`/非白名单 `Colors.xxx` 报警。
2. **API 文档比对**：仅比对参数名集合是否一致，不做文本 diff。参数顺序、描述文本差异不检测。
3. **覆盖率**：按 `lib/src/components/{组件名}/` 目录聚合，非逐文件。
4. **项G Web 验收**：CI 执行 `flutter build web` 验证编译通过，但浏览器内的渲染/交互/目测需人工。
5. **档3 真机目测**：不在自动化范围内，需人工在 Android 16 / iOS 26 / Chrome 上验证。
