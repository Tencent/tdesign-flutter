# Checkbox Demo 与卡片角标对齐

## 背景

Checkbox Flutter Demo 需要以官方站内的小程序实际运行画面为基准。除横向文案、项间距和卡片角标外，实际截图还确认了普通示例应使用圆形指示器，纵向列表的分割线不应引入额外垂直留白，位置示例文案应均为“多选”，横向示例应呈现为连续容器。

## 目标

- 横向普通选项在 375dp 手机视口完整显示三个文案。
- 基础、横向、全选、禁用、位置和非通栏示例使用圆形指示器。
- 纵向列表分割线不携带默认外边距，不在选项间产生额外空白。
- 位置示例两项文案均为“多选”。
- 横向普通选项使用同一连续背景容器。
- Checkbox 只从 Material `TextTheme` 继承字体属性；主标题颜色按 `titleColor -> textColorPrimary`，副标题颜色按 `subTitleColor -> textColorSecondary` 解析。
- Checkbox 主标题默认最多 3 行、副标题默认最多 5 行，超出后省略，与小程序默认值一致。
- 两组样式示例按公开 Demo 保留 16dp 项间距。
- 横向卡片将小程序的 `48rpx` 按 375dp 基准换算为 24dp，纵向卡片继续使用 28dp。

## 非目标

- 不新增 Checkbox 公开 API。
- 不在 Demo 中展示远程图片图标。
- 不改变 Checkbox 的选中状态、回调或禁用语义。

## 范围

### 涉及

- Checkbox Demo 横向选项、样式间距和卡片示例。
- `TSelectionCardGroupLayout` 横向布局的内部角标样式。
- 组件测试、Demo 测试、生成片段和 Golden。

### 不涉及

- Checkbox 公开构造参数、ThemeData 字段和文档 API。
- 其他组件的卡片视觉。

## 行为契约

- `TCheckboxGroup.cardMode` 为 `true` 且 `direction` 为 `Axis.horizontal` 时，内部卡片角标区域为 24dp，勾选图标为 12dp。
- 纵向卡片角标继续为 28dp，勾选图标继续为 14dp。
- 新样式不改变卡片点击、选中、禁用或语义行为。
- `TCheckbox.titleMaxLines` 默认值为 3，`subTitleMaxLines` 默认值为 5；显式传值仍优先。
- Demo 不通过新增公开 API 获得对齐效果。

## 验收标准

- [ ] 375dp 视口的横向选项完整显示“多选标题 / 多选标题 / 上限四字”。
- [ ] 普通示例的圆形指示器与官方运行画面一致。
- [ ] 纵向列表分割线不产生额外垂直间距。
- [ ] 位置示例文案和横向容器层级与官方运行画面一致。
- [ ] Material `TextTheme.color` 不覆盖 Checkbox 主/副标题语义颜色，字体属性仍正常继承。
- [ ] Checkbox 默认主标题 3 行、副标题 5 行，超出后省略。
- [ ] 两组示例的相邻选项间距为 16dp。
- [ ] 横向与纵向卡片角标尺寸分别为 24dp 和 28dp。
- [ ] Flutter 3.32.0 与 latest analyze 零告警，相关测试通过。
- [ ] 完整页 light/dark Golden 与 Android 真机复核无截断或溢出。
