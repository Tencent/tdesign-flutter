# 验收记录

基线：当前工作区 `e724cd0c474f14106ee0e5c14b496afabeddb86d`，保留用户已有修改。

## 源码与环境

- 验证日期：2026-10-12。
- 生产和测试范围二进制 diff SHA-256：`9415ceb2513a0fd957ef2dc7ab2d1597aa15936d9043a679e71ddf060918944c`；命令为 `git diff --binary --no-ext-diff HEAD -- tdesign-component/lib/src/components/{button,input,table} tdesign-component/test/components/{button,input,table} | shasum -a 256`。
- 低版本：Flutter 3.32.0 / Dart 3.8.0；高版本：官方 stable tag 3.47.7 / Dart 3.13.5，framework `abaf9c523780a608bd46686fd5e53740a07077f8`。
- latest 使用独立 SDK、独立源码副本并重新执行 `flutter pub get --offline`；没有覆盖用户 SDK、锁文件或既有覆盖率。
- Linux Golden 使用 `tdesign-flutter-golden-cache:3.32.0`、linux/amd64、挂载隔离 Pub 缓存；重新解析组件与 Example 依赖。字体和比较器沿用已登记测试的设置，未修改容差或基线。

## 双版本功能验证

| 检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 组件包 `flutter analyze --no-pub --fatal-infos` | 0 issues | 0 issues |
| Example `flutter analyze --no-pub --fatal-infos` | 0 issues | 0 issues |
| Button/Input/Table 功能回归 | 223 项通过 | 包含于下行 |
| Checkbox/Radio/Fab/Dialog/DropdownMenu/Form/Search/Textarea 与调度器自测 | 395 项通过 | 与三组件合并运行，619 项通过 |
| Button/Input/Textarea/Table/Fab/Dialog/Form/DropdownMenu/Search Demo，排除 Golden | 60 项通过 | 60 项通过 |

latest 的 619 项包含额外的版本专项检查：显式 `InputDecorationTheme.visualDensity=+4` 不改变内置编辑器尺寸，但调用方 suffix 仍能读取原装饰主题密度。该诊断测试位于隔离验证副本，不将仅适用于新版 SDK 的 API 引入仓库的双版本测试源码。

主要命令：

```sh
flutter test --no-pub test/components/button test/components/input test/components/table --exclude-tags golden --coverage --coverage-path=/private/tmp/td-density-332-lcov.info
flutter test --no-pub test/components/checkbox test/components/radio test/components/fab test/components/dialog test/components/dropdown_menu test/components/form test/components/search test/components/textarea test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart --exclude-tags golden
flutter test --no-pub test/button test/input test/textarea test/table test/fab test/dialog test/form test/dropdown_menu test/search --exclude-tags golden
```

第二条在组件包执行，第三条在 Example 执行；latest 合并前两条的测试文件并增加上述版本专项检查。所有新增回归均位于已有 manifest 登记的测试文件中。

## 生产覆盖率

| 范围 | 3.32.0 LH/LF | 3.47.7 LH/LF |
| --- | --- | --- |
| Button | 459/468 = 98.08% | 459/468 = 98.08% |
| Input | 310/321 = 96.57% | 317/321 = 98.75% |
| Table | 427/427 = 100% | 427/427 = 100% |

独立 LCOV 只按组件生产目录过滤，未把 Demo 行计入覆盖率。Linux 3.32.0 三组件功能测试另通过 223 项，覆盖率与上表低版本相同。

## 视觉与生成文档

- Linux 3.32.0 完成组件/Example analyze 和非视觉检查后，无更新参数运行 Table 组件 Golden 2 项及上述九组 Demo Golden 108 项，合计 **110 项通过**，未修改任何 Golden。
- `dart run tool/generate_example_code.dart --check` 通过；未修改 Demo 源码。
- 从 Button、Input dartdoc 经 `tdesign_flutter_tools:main generate --only-api --strict-names --get-comments` 重新生成对应 API 文件，核对输出内容正确。
- 最终 Example `flutter build web --no-pub --release --no-web-resources-cdn` 通过；使用新本机端口避免旧 Service Worker 缓存。在 375×812、DPR 1、字体缩放 1、浏览器缩放 1、浅色主题下核对实际桌面 Web 截图：四档恢复 48/40/32/28，纯图标方形和圆形恢复 48×48。
- 运行截图与前后对比保存在本任务 artifact 目录 `density-fix/`，不是 Golden 基线。

## 行为与交付边界

- Button 的实例密度无效，其他实例样式、内容原主题和点击行为经回归验证；普通和渐变四档、三种抽样形状均验证。
- Input 内置编辑器与清除/密码按钮隔离密度；编辑、清除、密码切换和前后缀主题保留通过。既有 disabled/readOnly、错误样式与 Form/Textarea 消费者回归通过。
- Table 移除无效包装后，选择指示器、列宽、颜色与选择回调通过，视觉基线不变。
- Checkbox、Radio 生产与测试源码未修改，现有密度隔离测试通过。
- 属于本地验证，远端 CI 以 PR 最终 head 的实际结果为准。未扩大为全库密度审计。
- 用户可感知日志候选：`breaking(button): 按钮布局不再受 Material 视觉密度影响，显式 style.visualDensity 不生效`；`breaking(input): 输入框内置编辑器和操作按钮不再受 Material 视觉密度影响`。Table 内部整理不单独写用户日志，CHANGELOG 未手工修改。

## PR 分支复核

PR 分支基于 `origin/develop@faab46b2a447a336bdb9e5b42ff9d556f171bc0d`。新增的 Upload/Toast 上游提交未改变本次生产与测试范围；最终 diff 指纹与上文一致。独立 worktree 仅包含密度隔离修改，3.32.0 组件包严格 analyze 与 223 项聚焦测试再次通过。

最终 develop 基线的 latest 3.47.7 组件包严格 analyze 零诊断，三组件及新版装饰密度专项测试 224 项通过。

## PR CI 文档展示修正

首次 PR CI 的 Flutter 3.32 功能任务中，组件测试及各组件生产覆盖率均通过；工具测试发现 `TInput` 新增类级说明出现在首张 API 表前，违反 `api_presentation_test.dart` 的展示契约。将密度说明移至公开构造方法 dartdoc 并重新生成 API，保留用户可见说明，未改动运行逻辑或 Golden 基线。

修正后两套 SDK 的 `api_presentation_test.dart` 各 57 项全部通过，组件包严格分析均为 0 issues。修正只影响注释与生成文档，运行逻辑及既有视觉验证不变。
