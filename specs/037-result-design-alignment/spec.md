# Result 设计对齐

## 背景

当前 Result Demo 只有一组四个带描述实例，未覆盖设计稿中的基础结果、自定义结果和页面示例。组件将 success、warning、error 等业务结果状态命名为 variant，并使用 `subtitle` 表达设计与跨端契约中的 description；默认图标尺寸、标题字号和内容间距也与设计稿不一致。

## 目标

- 公开 Demo 按移动端设计稿展示基础结果、带描述结果、自定义结果和页面示例。
- 使用单一 `status` 入口表达 info、success、warning、error 结果状态。
- 使用 `description` 表达辅助描述，避免借用 ListTile 的 subtitle 语义。
- 默认图标、字体和间距符合 Result 组件设计稿，并支持 Theme 子树覆盖必要视觉字段。

## 非目标

- 不机械复制小程序的字符串图标名、图片 URL 或页面路由 API。
- 不为静态结果组件增加回调、Controller 或业务流程状态。
- 不改变调用者传入的自定义 `icon` Widget 的尺寸和绘制方式。

## 范围

- `TResult`、`TResultThemeData` 的公开契约、默认视觉和语义。
- Result Demo、生成 API/代码片段、组件与 Demo 测试、light/dark Golden、CI 回归登记。

## 行为契约

- `status` 是结果状态的唯一入口，默认 `info`；状态决定默认图标、颜色和无障碍标签。
- `icon` 非空时完整替换默认状态图标，组件不重设其大小或颜色。
- `title`、`description` 为空时不占布局空间；非空内容按实际相邻项使用统一 12px token 间距。
- 默认状态图标为 80px；标题使用 16/24 的 title token，描述使用 14/22 的 body token。
- Theme 只承载 `iconSize`、`titleStyle`、`descriptionStyle` 等视觉覆盖，不持有 status。

## Breaking change

- `TResultVariant` 重命名为 `TResultStatus`，构造参数 `variant` 重命名为 `status`。
- `subtitle` 重命名为 `description`。
- 迁移时将 `variant: TResultVariant.success` 改为 `status: TResultStatus.success`，将 `subtitle` 改为 `description`。

## 验收标准

- [x] Demo 的分组、标题、顺序、状态和页面示例操作符合 Figma 节点 `24386:5272`。
- [x] 组件测试覆盖四种状态、自定义图标、空内容、Theme、token 和语义。
- [x] Flutter 3.32.0 与 latest 的功能测试和严格 analyze 通过。
- [x] 组件生产源码覆盖率 LH/LF 不低于 95%。
- [x] 固定 Linux Flutter 3.32.0 的 light/dark 整页 Golden 可复现。
- [x] 最终运行 Demo，进入页面示例并执行返回操作。
