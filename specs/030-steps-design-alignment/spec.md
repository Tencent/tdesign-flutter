# Steps 设计与公开契约收敛

## 背景

Flutter Steps 的公开 Demo、状态命名及只读/可选择所有权与新版 Figma、小程序公开用法不一致。旧 Demo 分为六组，缺少完整垂直图标和三种错误状态；组件同时由实例与 Theme 持有 `simple`、`readOnly`、`verticalSelect` 业务状态。

## 行为契约

- `TSteps` 保持受控组件：`value` 由调用方持有，越界值只在渲染时收敛；点击通过 `onChange` 报告索引。
- `onChange == null` 是唯一只读来源；垂直步骤条设置回调后显示右箭头并允许选择。
- `variant` 是非空视觉结构状态：`standard`、`dot`、`display`。
- `status` 是当前 `value` 的业务状态：`process` 或 `error`。
- `icon` 替换默认数字/完成图标；`customTitle`、`customContent` 分别优先于字符串便利字段。
- `display` 在横向与纵向都使用全实心节点与完成态连线，不受 `value/status` 影响；交互仍仅由 `onChange` 决定。可选择垂直 `dot` 为已完成节点实心、当前节点空心。

## Demo 契约

- 公开 Demo 按新版 Figma 收敛为“组件类型 / 组件状态 / 特殊类型”三组。
- 组件类型依次展示水平默认/图标/点状、垂直默认/图标/点状和自定义内容。
- 错误状态同屏展示默认、图标、点状三种样式。
- 特殊类型依次展示垂直可选择步骤与纯展示时间线；前者真实更新受控值并反馈选择结果，后者无点击回调。
- 可选择示例的核心片段标明 State 宿主、初始字段与 build 接入方式，展示实际运行的回调重建；不声称省略应用壳的片段可以直接运行。
- 小程序公开 Demo 仍是交互参考：保留受控/只读、横纵方向、默认/点状和自定义内容能力，但不复制动态事件对象或非受控双状态源。

## Theme 与尺寸

- Steps 不再注册持有业务状态的 ThemeExtension；默认颜色与字体读取 `context.tTheme` 语义 Token。内置文字样式通过共享解析器的低优先级 defaults 入口提供，显式 TTextThemeData、DefaultTextStyle、TextTheme 按字段覆盖，不将默认值伪装成实例覆盖。
- 22dp 默认节点、8dp 点节点、16/22dp 图标和 1dp 连线属于组件内固定设计尺寸，不作为业务状态或主题模式开放。
- 明暗主题使用同一结构，由语义 Token 驱动颜色变化。
- 组合文字解析通过内部只读投影视图辨认 Material 自动补全；不移动共享主题类、不改变无 defaults 的既有 TText 路径。只有 Steps 与 TabBar 使用该低优先级入口。

## Breaking change

- `TStepsStatus.success` 改为 `process`。
- `TStepsItemData.successIcon` 改为 `icon`。
- `TStepsVariant.defaultTheme` 改为 `standard`，避免将视觉形态误表述为主题来源。
- 移除 `TSteps.simple`、`readOnly`、`verticalSelect`，由 `variant` 与 `onChange` 表达。
- 删除只持有上述业务状态的 `TStepsThemeData`。
