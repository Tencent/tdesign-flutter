# Steps 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

步骤状态、方向和内容组合曾与视觉 variant 和主题默认混杂。

Flutter Steps 的公开 Demo、状态命名及只读/可选择所有权与新版 Figma、小程序公开用法不一致。旧 Demo 分为六组，缺少完整垂直图标和三种错误状态；组件同时由实例与 Theme 持有 `simple`、`readOnly`、`verticalSelect` 业务状态。

## 范围与非目标

步骤当前状态和结构由实例表达，具体样式只在单一组件主题层级提供。

## 最终方案与行为契约

- `TSteps.progress` 表达普通受控进度：`value` 由调用方持有，越界值只在渲染时收敛；可选 `onChange` 只报告点击索引，不改变指示器的进度语义。
- `TSteps.selectable` 表达垂直可选择步骤：固定为点状指示器，`onChange` 必填，并显示右箭头。
- `TSteps.display` 表达纯展示：不接收 `value`、`status` 或 `onChange`，横向与纵向均显示全实心节点及完成态连线。
- `indicator` 只表达进度步骤条的指示器样式：`standard` 或 `dot`。
- `status` 是当前 `value` 的业务状态：`process` 或 `error`。
- `icon` 替换默认数字/完成图标；`customTitle`、`customContent` 分别优先于字符串便利字段。
- `progress + dot` 在横向与纵向保持相同进度语义；`selectable` 为已完成节点实心、当前节点空心。

### Demo 契约

- 公开 Demo 按新版 Figma 收敛为“组件类型 / 组件状态 / 特殊类型”三组。
- 组件类型依次展示水平默认/图标/点状、垂直默认/图标/点状和自定义内容。
- 错误状态同屏展示默认、图标、点状三种样式。
- 特殊类型依次展示垂直可选择步骤与纯展示时间线；前者真实更新受控值并反馈选择结果，后者无点击回调。
- 垂直可选择示例保持固定四项，并根据受控 `value` 派生“已完成步骤 / 当前步骤 / 未完成步骤”标题；不复制小程序通过 `count` 动态增删步骤的 Demo 数据技巧。
- 可选择示例的核心片段标明 State 宿主、初始字段与 build 接入方式，展示实际运行的回调重建；不声称省略应用壳的片段可以直接运行。
- 小程序公开 Demo 仍是交互参考：保留受控/只读、横纵方向、默认/点状和自定义内容能力，但不复制动态事件对象或非受控双状态源。

### Theme 与尺寸

- 内置文字优先使用明确的实例/组件 TDesign 样式和 Token；不从外部 Material TextTheme 或 DefaultTextStyle 反推配置，自定义内容保留其原上下文。
- 22dp 默认节点、8dp 点节点、16/22dp 图标和 1dp 连线属于组件内固定设计尺寸，不作为业务状态或主题模式开放。
- 明暗主题使用同一结构，由语义 Token 驱动颜色变化。
- 内置文字优先使用明确的实例/组件 TDesign 样式和 Token；不从外部 Material TextTheme 或 DefaultTextStyle 反推配置，自定义内容保留其原上下文。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 步骤当前状态和结构由实例表达，具体样式只在单一组件主题层级提供。 |
| 保留的边界与代价 | 保留 Widget 内容与自然尺寸，不让序号或长标题被固定几何裁剪。 |

### 设计演变中的关键理由

- 新版 Figma / 小程序 / Flutter 三方差异与跨端取舍已记录。
- 组件公开契约、Flutter 状态所有权与 Theme Review 已完成首轮收敛。
- 真机首次安装运行并执行 uppercase `R`；浅色逐段滚动、点击，切换深色主题。
- 修复垂直可选择与纯展示节点状态后再次 uppercase `R`，重新进入页面并点击复验。
- Flutter 3.32.0 全包 analyze 为 0 issue；Steps focused tests 通过。
- 组件测试 23/23、Demo 结构/交互 2/2、生产源码覆盖率 226/233（97.00%）通过。
- Flutter 3.32.0 与 3.47.0 analyze、组件测试、Demo 测试、Web release 和 Android debug 构建通过。
- Flutter 3.32 Linux light/dark Golden 2/2 生成后无更新参数严格复跑 2/2；逐张检查无缺字、无裁切。
- 示例代码片段生成器完成 11 个旧片段清理、10 个新片段生成，`--check` 通过。
- Android 16 真机 integration 1/1 通过；普通 APK 安装返回 `Success`，强停后冷启动到 TDesign 首页。

## 兼容性与迁移

- `TStepsStatus.success` 改为 `process`。
- `TStepsItemData.successIcon` 改为 `icon`。
- 移除未命名 `TSteps(...)` 构造和 `TStepsVariant`，分别改用 `TSteps.progress`、`TSteps.selectable`、`TSteps.display` 与 `TStepsIndicator`。
- 移除 `TSteps.simple`、`readOnly`、`verticalSelect`；交互由各命名构造的 `onChange` 契约表达。
- 删除只持有上述业务状态的 `TStepsThemeData`。

## 验收标准

- 默认、显式配置、关键状态与边界行为符合最终方案；功能、视觉和人工路径按适用范围分别验收。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
