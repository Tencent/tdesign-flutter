# Checkbox 样式尺寸 token 化

## 背景

`TCheckbox` 与其共享卡片布局仍直接使用 20 / 24 / 28、48 / 56 / 64、56 / 82 等样式尺寸。默认主题下视觉正确，但这些值不会随 TDesign 间距、字体和行高 token 调整，与仓库“样式属性定义在主题中”的约定不一致。

## 目标

- Checkbox 三档块高与指示器尺寸由 TDesign token 计算。
- Checkbox 单项及卡片组高度由字体、行高和间距 token 计算。
- 共享选择卡片的边框、角标尺寸与角标圆角由 TDesign token 计算。
- 默认主题下保持现有视觉尺寸和行为不变。

## 非目标

- 不新增或修改 Checkbox 公开构造参数。
- 不改变选中、半选、禁用、回调、分割线或布局语义。
- 不把绘制比例、路径控制点等纯几何关系伪装为样式 token。
- 不调整 Radio 的公开 API 或默认行为。

## 范围

### 涉及

- `TCheckbox` 内部尺寸解析。
- `TSelectionCard` 与 `TSelectionCardGroupLayout` 的内部尺寸解析。
- Checkbox 与共享卡片组件测试。

### 不涉及

- Checkbox Demo 结构、文案和交互。
- 新增 ThemeExtension 字段。
- 其他组件的样式重构。

## 行为契约

- 默认主题下 small / medium / large 带文案 Checkbox 高度仍为 48 / 56 / 64dp，指示器仍为 20 / 24 / 28dp。
- 默认主题下无副标题 / 有副标题的选择卡片高度仍为 56 / 82dp。
- 默认主题下选择卡片边框仍为 1.5dp、角标圆角仍为 4dp；纵向 / 横向角标仍分别为 28 / 24dp，勾选图标仍为角标的一半。
- 覆盖相关 TDesign spacer、字体或行高 token 后，上述尺寸随 token 重新计算。
- 绘制器中的无量纲比例和路径控制点不属于可配置样式尺寸，不纳入 token 化范围。

## 验收标准

- [ ] 默认主题下 Checkbox 与卡片尺寸无视觉变化。
- [ ] 自定义 token 能改变 Checkbox 块高、指示器、卡片高度、边框与角标尺寸。
- [ ] Checkbox 受控交互、禁用、半选和 Group 行为测试保持通过。
- [ ] Flutter 3.32.0 与 latest 的相关功能测试及 analyze 零告警。
- [ ] Flutter 3.32.0 Linux 的 Checkbox light/dark Golden 无差异通过。
