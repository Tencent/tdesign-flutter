# 实施方案

## 技术方案

1. 在布局阶段把调用方列定义解析为带有效宽度的内部列：显式宽度保持不变，空宽度按当前可用空间均分；中间区仍由统一横向滚动协调器同步表头与数据行。
2. 把尺寸、颜色、字体和边框统一解析为“实例参数 > ThemeExtension > TDesign Token/组件默认值”，并以 `DefaultTextStyle` 为普通 `Text` 提供表头和数据默认样式。
3. 排序指示使用 TDesign 上下箭头语义，固定列在与滚动区交界处绘制分隔；加载和选择使用 `TLoading`、`TCheckbox`。
4. 新增受控的 `onRowTap`，单元格点击同时派发 cell 与 row 回调；排序、选择继续由调用方回传新状态。
5. 公开 Demo 使用紧凑页面结构，按 Figma 顺序实现全部场景；内部能力由组件测试覆盖，不再混入公开展示。
6. 用稳定 `rowKey` 解析受控选择集合，保持 `Set<T>` 作为唯一状态源；新增统一的 `TTableCellContext` 承载行列坐标和强类型数据。
7. 将表体改为固定行高的二维网格布局：先计算每个逻辑单元格的跨度和占位，再按左固定区、滚动区、右固定区分别绘制；合并区域不可跨区。
8. 列宽解析加入 `minWidth` 下限；固定 `height` 时让表头/footer 外的剩余空间成为垂直滚动视口。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/table/` | 列宽解析、视觉默认值、事件和样式 API |
| 测试 | `test/components/table/`、`example/test/` | 组件行为、Demo 结构/交互和 Golden |
| 示例 | `example/lib/page/t_table_page.dart` | 按 Figma 重建公开 Demo |
| 文档 | dartdoc、Spec、生成的 API/代码片段 | 同步公开契约与示例 |
| CI 清单 | `tool/component_test_manifest.dart` | 登记 Table 全量测试与视觉回归 |

## API 变化

- `TTableColumn.width`: `double` → `double?`，默认 `null` 表示自动均分。
- `TTable.bordered`: 新增 `bool?`，实例级覆盖 Theme 默认值。
- `TTable.stripe`: 新增 `bool?`，实例级覆盖 Theme 默认值。
- `TTable.onRowTap`: 新增 `TTableRowTap<T>?`。
- `TTable.rowKey`: 新增 `TTableRowKey<T>?`。
- `TTable.cellSpanBuilder`: 新增 `TTableCellSpanBuilder<T>?`。
- `TTable.height`: 新增 `double?`，与 `maxHeight` 互斥。
- `TTableColumn.minWidth`: 新增 `double?`。
- `TTable.onCellTap`: 改为 `void Function(TTableCellContext<T>)`。

## 风险与取舍

- 自动均分改变未显式设置列宽时的默认布局，属于有意的 breaking change；显式宽度可恢复旧的固定宽度行为。
- 合并单元格与固定列共存时只允许在同一固定区域内合并；跨区合并语义不明确且无法保持独立滚动，因此作为无效配置拒绝。
- 合并单元格需要跨行布局，表体改为一个共享纵向视口和一个中心横向视口；表头继续与中心表体同步横向偏移。
- 本机截图只作为人工比对证据；仓库 Golden 只在规定 Linux/Flutter/字体环境生成和验收。

## 验证策略

- 单元测试：有效列宽、三态排序、选择、行/单元格回调、Theme 优先级、固定列与滚动同步、控制器生命周期。
- Demo Widget 测试：标题/描述/场景顺序、实例配置、排序点击和横向拖动。
- Golden：公开 Demo 分段 light/dark 基线，在 Linux Flutter 3.32.0 环境更新后无更新复跑。
- 静态检查：Flutter 3.32.0 与 latest 分别执行 format、analyze 和相关测试。
- 人工验收：以 Figma 桌面端导出图、修复前/后截图和差异标注核对。
