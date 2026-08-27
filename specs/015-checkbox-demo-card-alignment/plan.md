# 实施方案

## 技术方案

- Demo 横向选项改用内容宽度 `Row` 和 `spaceBetween`，通过现有 `TCheckboxThemeData.customSpace` 去除横向内边距。
- Demo 的两组相邻选项使用 16dp `SizedBox`。
- `TSelectionCardGroupLayout` 在横向布局中使用私有 `InheritedWidget` 向子卡片传递角标尺寸，不扩大公开 API。
- Checkbox 标题保留 Material `TextTheme` 字体属性，但不从 `bodyLarge/bodyMedium.color` 继承语义颜色；颜色由 Checkbox Theme 与 TDesign 主/次文字 token 解析。
- Checkbox 主标题与副标题默认最大行数分别由 1 调整为 3 和 5，与小程序默认契约一致；超出后继续省略。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_selection_card.dart` / `t_check_box.dart` | 横向卡片角标、标题颜色解析与默认文案行数 |
| 测试 | Checkbox 组件与 Demo 测试 | 尺寸、结构和 Golden 回归 |
| 示例 | `t_checkbox_page.dart` | 横向布局与示例间距 |
| 文档 | 生成的 Checkbox 代码片段 | 从 Demo 源码同步 |

## API 变化

- 不新增或删除公开参数；`TCheckbox.titleMaxLines` 默认值由 1 改为 3，`subTitleMaxLines` 默认值由 1 改为 5。
- 这是用户可感知的默认布局行为变化：依赖原单行高度的使用方应显式传入 `titleMaxLines: 1` / `subTitleMaxLines: 1`。

## 风险与取舍

- 横向 `cardMode` 的角标按小程序 `48rpx` 换算为 24dp，属于用户可感知的视觉修正，但不改变 API 或交互契约。
- 私有布局上下文仅对横向卡片生效，避免影响单独使用的 `TCheckbox(cardMode: true)` 和纵向卡片。
- 默认行数增加可能改变长文案 Checkbox 的高度；保留显式行数参数作为兼容路径，并增加默认值回归测试。

## 验证策略

- 单元测试：断言默认 3/5 行、省略策略，以及纵向和横向卡片的勾选图标与角标尺寸。
- Widget 测试：验证 Demo 文案、组件数量和完整页 Golden。
- 静态检查：Flutter 3.32.0 与 latest analyze。
- 人工验收：Android 16 真机滚动、点击和截图。
