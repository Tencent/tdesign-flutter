# SideBar 设计与公开契约收敛

## 背景

Flutter SideBar 的公开 Demo、结构状态所有权和默认宽度与新版 Figma、小程序 develop 不一致。当前 Theme 同时持有 `style`、`height`，Demo 使用 106/116dp、20 个数字条目和额外公开入口，无法逐屏验收。

## 行为契约

- `TSideBar` 继续是受控组件：`value` 由调用方持有，点击可用项仅通过 `onChanged` 报告值。
- `style` 为非空实例结构状态，枚举值为 `line`、`tag`，默认 `line`。
- `width` 为非空实例布局参数，默认 103dp；`height` 保持可空实例参数，空值占满当前屏幕高度。
- `TSideBarThemeData` 只持有可继承的颜色、文字和间距视觉值，不持有 `style`、`width`、`height`。
- 每项提供可访问的 label、selected、enabled 语义；disabled 项不触发回调。
- 默认标签使用 Body Large Token，图标 20dp，选中指示线 3×14dp，line/tag 圆角 9dp。

## Demo 契约

- 公开入口保留小程序可操作的锚点、切页、带图标、自定义样式四项。
- 详情优先按新版 Figma 使用 10 项“选项”占位数据，默认选中第二项；第二项圆点 Badge，第三项数字 Badge 8。
- 锚点与切页内容按新版 Figma 使用“标题”及 48dp 圆角方图纵向列表，行高 80dp。
- 切页第五项禁用；自定义样式使用 `tag` 结构。
- 小程序的 5 项、第四项数字 Badge 及 64dp 圆图三列宫格与新版 Figma 差异较大，记录但不覆盖 Figma 优先的公开视觉；交互仍参考小程序的受控切换、锚点同步和禁用模式。
- 不在公开 Demo 混入 loading、未选中颜色或旧“非通栏”入口；这些能力由自动化测试覆盖。

## Theme 优先级

实例视觉参数 > `TSideBarThemeData` > TDesign 语义 Token。结构状态只由实例参数持有。

## Breaking change

- `TSideBarVariant.normal` 改为 `line`，`outline` 改为 `tag`。
- `TSideBar.style` 从可空改为非空，默认 `line`。
- `TSideBarThemeData.style`、`height` 被移除。
- `TSideBar` 默认宽度从依赖父约束/最小 106dp 收敛为固定 103dp，并新增 `width` 覆盖入口。
