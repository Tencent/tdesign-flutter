# 测试用例 — issue #900 TabBar 图标选中颜色

## TC-01：iconText 类型 — 选中 tab 图标颜色为 brandNormalColor

- **前置条件**：`TBottomTabBar` 使用 `iconText` 类型，`currentIndex=0`
- **操作**：渲染组件，读取 index=0 的图标颜色
- **期望**：图标颜色 == `TTheme.brandNormalColor`

## TC-02：iconText 类型 — 未选中 tab 图标颜色为 textColorPrimary

- **前置条件**：`TBottomTabBar` 使用 `iconText` 类型，`currentIndex=0`
- **操作**：渲染组件，读取 index=1 的图标颜色
- **期望**：图标颜色 == `TTheme.textColorPrimary`

## TC-03：iconText 类型 — 点击切换后图标颜色同步更新

- **前置条件**：`TBottomTabBar` 使用 `iconText` 类型，初始 `currentIndex=0`
- **操作**：点击 index=1 的 tab
- **期望**：index=1 图标颜色变为 `brandNormalColor`，index=0 图标颜色变为 `textColorPrimary`

## TC-04：icon 类型 — 选中 tab 图标颜色为 brandNormalColor

- **前置条件**：`TBottomTabBar` 使用 `icon` 类型，`currentIndex=0`
- **操作**：渲染组件，读取 index=0 的图标颜色
- **期望**：图标颜色 == `TTheme.brandNormalColor`

## TC-05：icon 类型 — 未选中 tab 图标颜色为 textColorPrimary

- **前置条件**：`TBottomTabBar` 使用 `icon` 类型，`currentIndex=0`
- **操作**：渲染组件，读取 index=1 的图标颜色
- **期望**：图标颜色 == `TTheme.textColorPrimary`

## TC-06：iconText 类型 — 文字颜色不受影响（回归）

- **前置条件**：`TBottomTabBar` 使用 `iconText` 类型，`currentIndex=0`
- **操作**：渲染组件，读取 index=0 和 index=1 的文字颜色
- **期望**：选中文字颜色为 `brandNormalColor`，未选中为 `textColorPrimary`（与修复前一致）

## TC-07：用户显式设置图标 color 时不被覆盖（边界）

- **前置条件**：`selectedIcon: Icon(TIcons.book, color: Colors.red)`
- **操作**：渲染组件，读取图标颜色
- **期望**：图标颜色为 `Colors.red`（用户显式颜色优先，IconTheme 不覆盖）
