# 实施方案

## 技术方案

- 在 Button 内部建立单一尺寸规格解析，统一输出高度、水平/垂直内边距、字体 token 和图标尺寸。
- `TButtonResolve` 先解析完整 TDesign 规格，再按
  `实例 ButtonStyle > TButtonThemeData > 显式 Material ButtonTheme/ThemeData > token`
  合并；自动生成的 Material 投影不抢占 token 默认值。
- 默认使用 shrink-wrap tap target；对应的 Elevated/Outlined/TextButtonTheme 可通过
  `ButtonStyle.tapTargetSize` 覆盖，最后允许实例 `ButtonStyle` 覆盖。
- 渐变分支复用最终 `ButtonStyle`，以内部 tap-target RenderObject 扩展点击区而不改变
  可见装饰尺寸，并补齐 Semantics 与 InkWell 原生配置。
- `TFab` 在组合层显式传入 large / fill / primary，保留其 48dp 动作层和拖拽边界契约。
- Demo 只展示组件尺寸矩阵；通栏继续由 `SizedBox(width: double.infinity)` 表达。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `button/t_button*.dart` | 统一尺寸、主题和渐变交互契约 |
| 组合组件 | `fab/t_fab_resolve.dart` | 显式固定 Fab 的 Button 基线，避免隐式依赖 |
| 测试 | `test/components/button/` | 增加尺寸矩阵、主题优先级、渐变语义和 Golden 回归 |
| 示例 | `example/lib/page/t_button_page.dart` | 使用默认组件结果展示四档尺寸 |
| 文档 | dartdoc、Spec、生成示例资产 | 明确 filled 和 tap target 边界 |

## API 变化

- 不新增、删除或重命名公开 API。
- 默认布局行为从 Material 48dp padded tap target 改为 TDesign 精确尺寸；这是用户可感知的
  默认行为变化，按 breaking change 记录。
- 调用方需要至少 48dp 点击区时，可在对应 Material ButtonTheme 或实例
  `ButtonStyle` 中显式设置 `MaterialTapTargetSize.padded`。

## 风险与取舍

- 精确尺寸会缩小 small/extraSmall 的默认点击区域；这是 TDesign 紧凑尺寸与 Material
  最小点击区的明确取舍，Flutter 原生 padded 配置仍完整保留。
- 更新 mark 字体会改变现有 Button Golden，需要逐项确认是规格修复而非无关像素漂移。
- 自定义渐变路径需维护少量 tap-target 布局代码；测试必须覆盖 hit test 和语义，避免与
  Flutter `ButtonStyleButton` 分叉。

## 验证策略

- 单元测试：尺寸规格映射和 Theme/P0 优先级。
- Widget 测试：四档真实几何、Material 可见区域、渐变点击/长按/语义。
- Golden 测试：浅色尺寸矩阵及现有关键状态基线。
- 静态检查：组件包与 Example 的 `flutter analyze --fatal-infos`。
- 双版本：Flutter 3.32.0 和 latest 分别执行 analyze 与 Button 测试。
- 人工验收：Web Button 尺寸 Demo 与小程序逐项截图比对。
