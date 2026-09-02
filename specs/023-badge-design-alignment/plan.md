# 实施方案

## 技术方案

- 将 `TBadgeVariant.small` 拆为独立 `TBadgeSize`，避免形态与尺寸双重所有权。
- 继续复用 Material `Badge` 处理普通、圆点、方形和气泡的 child 锚定；角标使用 `Stack + CustomPainter` 按公开枚举指定的物理左右方位贴合内容边角。
- 中/大尺寸从 `fontMarkExtraSmall`、`fontMarkSmall` 的字号和行高取得；颜色、文字样式、padding、alignment、offset 继续遵循实例、局部 Theme、全局 Theme、Token 的覆盖链。
- Demo 使用 `TCellGroup` 表达连续角标 Cell，builder 只展示可复制的组件组合。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/badge/` | 新形态、尺寸与位置解析 |
| 调用方 | Tabs 与仓库 Demo/测试 | 迁移 `small`，复制新增字段 |
| 测试 | Badge 组件、Demo、Golden | 根因、契约和视觉回归 |
| 示例 | `example/lib/page/t_badge_page.dart` | 按 Figma 重建公开 Demo |
| 文档 | Spec、dartdoc、生成 API/示例 | 记录 breaking 迁移 |

## API 变化

- breaking：删除 `TBadgeVariant.small`，改用 `size: TBadgeSize.medium/large`。
- 新增：Square、Bubble、Ribbon、Triangle 形态枚举。
- 新增：`TBadgeSize` 与 `TBadge.size`。
- 新增：实例级 `TBadge.offset`。

## 风险与取舍

- 当前包为 `1.0.0-alpha.1`；选择一次性收敛 `small`，避免长期保留冲突状态源。
- `border` 与形态正交且已有独立主题配置，保留该能力但从 Demo 的 Square 语义中移除。
- 角标绘制不依赖平台字体基线；画布尺寸从 Badge Size 派生，文字仍由 `TText` 渲染并在受限区域内缩放。
- Square 2px 与 Bubble 左下 1px 是设计稿专有几何；颜色、字体、通用圆角和描边继续走 Theme/Token。
- 设计稿中的 Circle 使用 `normal` 表达：单字符呈圆形，多字符自然扩展为胶囊形，不新增重复形态枚举。

## 验证策略

- 单元测试：形态、尺寸、偏移、主题优先级、可见性、RTL、文本缩放。
- Demo 测试：完整分组、文案、实例数量、顺序与关键参数。
- 静态检查：Flutter 3.32.0 与 latest `flutter analyze`。
- 人工验收：Android 真机与 Figma 固定节点逐项截图核对。
