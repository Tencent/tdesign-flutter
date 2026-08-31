# Loading：跨端对齐 - 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-70/feat/loading-contract-alignment-review`
- develop 基线：`ab04f68`
- Flutter/Dart：3.32.0 (Dart 3.8.0) / 3.47.0 (Dart 3.13.0)

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --fatal-infos --no-pub`（3.32.0） | ✅ 0 error / 0 warning | lib + test + example |
| `flutter analyze --fatal-infos --no-pub`（3.47.0） | ✅ 0 error / 0 warning | lib + test + example |
| `flutter test test/components/loading/t_loading_test.dart`（3.32.0） | ✅ 36/36 通过 | 包含默认值、连续尺寸和三种指示器几何契约 |
| `flutter test test/components/loading/t_loading_test.dart`（3.47.0） | ✅ 36/36 通过 | 与受影响主题测试合计 63/63 通过 |
| `flutter test --coverage test/components/loading/t_loading_test.dart` | ✅ 99.59% | Loading 目录 LF=244, LH=243 |
| `flutter test test/loading_demo_test.dart`（3.32.0） | ✅ 2/2 通过 | 公开分组、文案、实例数量与顺序；官方自定义图片与滑块拖动后常驻数值 |
| `flutter test test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart` | ✅ 11/11 通过 | 回归、覆盖率与 Golden 登记完整 |
| `dart run tool/generate_example_code.dart --check` | ✅ 通过 | custom 指示器与尺寸示例按小程序分组生成 |

## 覆盖率明细（`lib/src/components/loading/`）

| 文件 | LF/LH | 覆盖率 |
| --- | --- | --- |
| t_loading.dart | 49/48 | 97.96%（未覆盖 `colorScheme?.primary` fallback 边界） |
| t_loading_controller.dart | 20/20 | 100% |
| t_loading_theme_data.dart | 20/20 | 100% |
| t_circle_indicator.dart | 56/56 | 100% |
| t_point_indicator.dart | 42/42 | 100% |
| t_activity_indicator.dart | 57/57 | 100% |

## 人工验收

- [x] `TLoading.size` 是唯一尺寸入口，类型为 `double`、默认 20，与 `TLoadingController.show` 一致；Theme 不重复持有尺寸。
- [x] 默认 `duration` 800、默认 `axis` horizontal，与官方一致（示例页可见默认转圈速度与横向布局）。
- [x] circle 三档尺寸 24/28/32 对齐官方小程序 `48/56/64rpx`；circle、activity、point 和 custom 都以 `size` 表示外部尺寸。
- [x] 公开页收敛为小程序的三个分组；custom 指示器合并到“纯图标”，三档尺寸合并为一个示例。
- [x] 示例内容按小程序 Demo 左对齐；custom 指示器使用本地化的官方 `logo2.png`，Golden 预缓存图片后再截图，不保留未加载占位；速度滑块默认常驻展示 800，拖动后数值更新。
- [x] 已使用微信开发者工具截取小程序实际页；`double size` 最终改动已由 Flutter 3.32.0 Linux CI 复验明暗整页 Golden（run `33352953431`）。
- [x] 站点 README 文件链接、API 表、示例代码已修正，`loading_api.md` 保持生成原样。

## 未覆盖项与后续工作

- `t_loading.dart` line 92（`colorScheme?.primary` fallback）为既有边界分支，未覆盖（需构造显式非默认 ColorScheme 场景），不影响 ≥95% 门槛。
- **真机像素表现仍未实测**：已有微信开发者工具 iPhone 12/13 模拟器截图与 Linux Golden，但不将其外推为真机 DPR 结论。
- `reverse` / `pause` / `delay`（后续迭代，官方发布版未公开对应 Demo）。
- `attach`（仅 Vue 独有且发布版注释）。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@fb26b8d5`，保留 Loading 回归登记并采用 develop 的共享测试基建。
- 最终 `double size` 改动已推送；Flutter 3.32.0 Linux visual regression 在 head `8e8d68f6` 的 CI run `33352953431` 通过。
- Flutter 3.32.0 与 3.47.0：组件聚焦测试、Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：没有新增一次性 props；`size` 从枚举收敛为默认 20 的单一 `double` 参数，Theme 不提供重复尺寸入口；该公开 API 变更与既有默认视觉行为变更均按 breaking 处理。
- 公开 Demo 最终复核：按 `tdesign-miniprogram@1.16.0` 源码恢复左对齐、官方 custom 图片、横竖实例间距、纯文字单实例、24/28/32 尺寸和默认 800 的带数值滑块；Flutter 3.32.0 Linux 明暗整页 Golden 更新后已不带更新参数复跑通过。
- 站点 README 最终复核：六段代码演示与当前 Demo/生成片段同步，修正 custom 图片、文案、间距、尺寸说明、小节编号及速度滑块的现行 API 和 `2000 - value` 映射，不再保留不可编译的旧 `TSliderThemeData` 调用。
