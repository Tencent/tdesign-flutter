# TSwitch 加载状态 API 收敛

## 背景

`TSwitchVariant` 同时包含 `filled`、`text`、`icon` 三种内容形态和
`loading` 状态，导致同一枚举混合展示形态与交互状态。加载状态需要成为
独立且唯一的公开状态源。

## 目标

- 以 `final bool loading` 作为 TSwitch 加载状态的唯一入口。
- `TSwitchVariant` 只保留 `filled`、`text`、`icon` 三种内容形态。
- 加载中显示加载指示器并禁用交互。
- 同步示例、测试、Golden、API 文档和迁移说明。

## 非目标

- 不新增 `disabled`，禁用仍由 `onChanged == null` 表达。
- 不引入非受控值或自定义值类型。
- 不改变尺寸、颜色和主题优先级。

## 范围

### 涉及

- TSwitch 构造参数、加载渲染与交互语义。
- TSwitchVariant 枚举。
- Switch 组件测试、示例测试、示例代码和 Golden。
- 生成的 Switch API 文档与代码片段。

### 不涉及

- TCupertinoSwitch 公开契约。
- ExampleItem、ExamplePage 或公共 Example 抽象。

## 行为契约

- `loading` 默认为 `false`。
- `loading == true` 时，滑块内容显示加载指示器，`onChanged` 不会触发，
  语义节点为不可交互。
- `loading == false` 时，`variant` 决定 `filled`、`text` 或 `icon` 内容形态。
- `TSwitchVariant.loading` 被删除；迁移方式为
  `variant: TSwitchVariant.loading` → `loading: true`。
- `onChanged == null` 仍是普通禁用状态的唯一入口。

## 验收标准

- [ ] TSwitchVariant 仅保留 filled、text、icon。
- [ ] TSwitch 仅通过 loading 表达加载状态，默认值为 false。
- [ ] 加载态渲染、禁用交互和语义测试通过。
- [ ] 示例、代码片段、API 文档与 Golden 同步。
- [ ] Switch 生产目录覆盖率不低于 95%。
- [ ] Flutter 3.32.0 与 latest 的 analyze/test 门禁通过。
