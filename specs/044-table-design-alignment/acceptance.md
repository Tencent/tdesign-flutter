# 验收记录

## 验证环境

- 分支：`rss1102/fix/table-demo-alignment`
- 基线：`develop@0de62b9b93d9df76f51fb330217f326e7c265f90`
- Flutter/Dart：Flutter 3.32.0（Linux Golden 与本机测试）、Flutter 3.47.0（latest 双版本验证）
- Figma：桌面端，文件 `mdBVCCVGERhxoZLle2eLT0`，节点 `28633:47353`
- 小程序：`develop@6c7f054fcaef7343301f5ee284dffca33e3f5719`

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze`（组件，Flutter 3.32.0） | 通过 | 0 error / 0 warning |
| `flutter analyze`（example，Flutter 3.32.0） | 通过 | 0 error / 0 warning |
| `flutter test test/components/table/t_table_test.dart test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart`（Flutter 3.32.0） | 通过 | Table 组件、清单与回归入口均通过 |
| `flutter test test/table_page_test.dart`（Flutter 3.32.0） | 通过 | 3 项 Demo 结构、样式与交互测试 |
| Table 归一化坐标断言（Flutter 3.32.0 / Linux） | 通过 | 9 个 Table 顶部坐标与 Figma 逐项相同，高度均为 418 |
| `flutter test --update-goldens test/table_demo_golden_test.dart`（Linux Flutter 3.32.0） | 通过 | 生成 light / dark 基线 |
| `flutter test test/table_demo_golden_test.dart`（Linux Flutter 3.32.0） | 通过 | 不更新基线复跑，2 项通过 |
| `flutter analyze`（组件与 example，Flutter 3.47.0） | 通过 | 两个目录均 0 issue |
| `flutter test test/components/table/t_table_test.dart`（Flutter 3.47.0） | 通过 | 38 项通过 |
| `flutter test test/table_page_test.dart`（Flutter 3.47.0） | 通过 | 3 项通过 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [x] Figma 桌面端核对根节点、全部 9 类展示和交互稿
- [x] 核对小程序 Table 公开 Demo、API 和事件模式
- [x] 修复前后截图及差异标注
- [x] 375 宽度、418 表格高度、固定列与横向滚动人工核对

截图证据位于 `evidence/`。重新验收采用 `375 × 4484` 的同尺寸、DPR 1、无缩放坐标系：Figma 裁掉顶部 44px iOS 状态栏并在最后一张 Table 底边结束，Flutter 裁掉 Golden 尾部测试画布空白。九张 Table 的顶部坐标和 418px 高度逐项一致。详细坐标、裁剪范围、像素统计及差异归类见 `evidence/alignment-measurements.md`。

归一化差异统计为：精确 RGB 差异 17.5402%，任一 RGB 通道差异大于 16 的像素占 8.3948%。差异图仍保留字体/图标光栅和页面壳平台差异，因此结论是“布局与组件视觉契约对齐”，不是“跨渲染器逐像素相同”。

## 未覆盖项与后续工作

- 合并单元格和固定行不属于本次 Figma 公开 Demo，后续独立设计。
