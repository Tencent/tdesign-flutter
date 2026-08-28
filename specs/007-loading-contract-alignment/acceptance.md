# Loading：跨端对齐 - 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-70/feat/loading-contract-alignment-review`
- 基线提交：`8f776174`
- Flutter/Dart：3.32.0 (Dart 3.8.0) / 3.47.0 (Dart 3.13.0)

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --fatal-infos`（3.32.0） | ✅ 0 error / 0 warning | lib + test + example |
| `flutter analyze --fatal-infos`（3.47.0） | ✅ 0 error / 0 warning | lib + test + example |
| `flutter test test/components/loading/t_loading_test.dart`（3.32.0） | ✅ 35/35 通过 | 收回公开 Demo 未使用的 overlay 参数后复核 |
| `flutter test test/components/loading/t_loading_test.dart`（3.47.0） | ✅ 35/35 通过 | 收回公开 Demo 未使用的 overlay 参数后复核 |
| `flutter test --coverage ...` | ✅ 99.62% | LF=261, LH=260（基线 86.15%） |
| `dart run tool/generate_example_code.dart --check` | ✅ 通过 | 新增 custom 指示器示例 |

## 覆盖率明细（`lib/src/components/loading/`）

| 文件 | LF/LH | 覆盖率 |
| --- | --- | --- |
| t_loading.dart | 69/68 | 98.55%（未覆盖 line 92：`colorScheme?.primary` fallback 边界） |
| t_loading_controller.dart | 20/20 | 100% |
| t_loading_theme_data.dart | 20/20 | 100% |
| t_circle_indicator.dart | 56/56 | 100% |
| t_point_indicator.dart | 39/39 | 100% |
| t_activity_indicator.dart | 57/57 | 100% |

## 人工验收

- [x] 默认 `duration` 800、默认 `axis` horizontal，与官方一致（示例页可见默认转圈速度与横向布局）。
- [x] circle 三档尺寸 20/22/26 对齐官方与 activity。
- [x] 示例页纯图标分组新增"自定义图标"（custom 指示器）Demo。
- [x] 站点 README 文件链接、API 表、示例代码已修正，`loading_api.md` 保持生成原样。

## 未覆盖项与后续工作

- `t_loading.dart` line 92（`colorScheme?.primary` fallback）为既有边界分支，未覆盖（需构造显式非默认 ColorScheme 场景），不影响 ≥95% 门槛。
- **真机像素表现未实测**：本环境无真机/DPR/主题截图，尺寸与间距调整基于设计数值与 Flutter 常量静态换算，需真机复核。
- `reverse` / `pause` / `delay`（后续迭代，官方发布版未公开对应 Demo）。
- `attach`（仅 Vue 独有且发布版注释）。
