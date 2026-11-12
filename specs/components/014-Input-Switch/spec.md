# Switch 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

加载状态曾作为视觉 variant，混淆业务状态与内容呈现。

`TSwitchVariant` 同时包含 `filled`、`text`、`icon` 三种内容形态和
`loading` 状态，导致同一枚举混合展示形态与交互状态。加载状态需要成为
独立且唯一的公开状态源。

## 范围与非目标

### 目标

- 以 `final bool loading` 作为 TSwitch 加载状态的唯一入口。
- `TSwitchVariant` 只保留 `filled`、`text`、`icon` 三种内容形态。
- 加载中显示加载指示器并禁用交互。
- 同步示例、测试、Golden、API 文档和迁移说明。

### 涉及

- TSwitch 构造参数、加载渲染与交互语义。
- TSwitchVariant 枚举。
- Switch 组件测试、示例测试、示例代码和 Golden。
- 生成的 Switch API 文档与代码片段。

### 不涉及

- 不新增 `disabled`，禁用仍由 `onChanged == null` 表达。
- 不引入非受控值或自定义值类型。
- 不改变尺寸、颜色和主题优先级。

- TCupertinoSwitch 公开契约。
- ExampleItem、ExamplePage 或公共 Example 抽象。

## 最终方案与行为契约

- `loading` 默认为 `false`。
- `loading == true` 时，滑块内容显示加载指示器，`onChanged` 不会触发，
  语义节点为不可交互。
- `loading == false` 时，`variant` 决定 `filled`、`text` 或 `icon` 内容形态。
- `TSwitchVariant.loading` 被删除；迁移方式为
  `variant: TSwitchVariant.loading` → `loading: true`。
- `onChanged == null` 仍是普通禁用状态的唯一入口。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | loading 是独立状态入口，variant 只表达 filled/text/icon 等呈现。 |
| 保留的边界与代价 | 保持既有回调与禁用语义，加载行为不通过 Theme 再建立一个状态源。 |

### 设计演变中的关键理由

- 删除枚举值是 breaking change，不保留兼容别名，以免形成双状态源。
- loading 与 variant 同时传入时，loading 负责当前状态并覆盖滑块内容；
  loading 结束后恢复 variant 指定的内容形态。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- TSwitchVariant 仅保留 filled、text、icon。
- TSwitch 仅通过 loading 表达加载状态，默认值为 false。
- 加载态渲染、禁用交互和语义测试通过。
- 示例、代码片段、API 文档与 Golden 同步。
- Switch 生产目录覆盖率不低于 95%。
- Flutter 3.32.0 与 latest 的 analyze/test 门禁通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
