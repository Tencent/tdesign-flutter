# Cascader 公开 Demo 对齐

## 背景

Flutter Cascader 的公开 Demo 原先以常规能力分组，未覆盖小程序公开页面的类型与进阶实例，也没有明确说明 typed option、搜索与弹层的 Flutter 所有权边界。

## 目标

- 按小程序 `b60cdc8a1dce1f06dd45cb4e41eefd31c674e514` 的公开页面顺序覆盖基础、选项卡、初始值、自定义数据映射、次级标题、任意层确认和搜索。
- 保持 `TCascader` 为严格受控的层级面板；Popup、搜索输入、确认策略和原始数据映射由 Flutter Widget 组合完成。
- 补齐 Demo 结构、交互、light/dark Golden 与组件回归证据。

## 非目标

- 不复制小程序的 `visible`、`title`、`closeBtn`、`defaultValue`、`keys`、`filterable` 等弹层或动态对象参数。
- 不改变 `TCascaderVariant.tab` 的既有默认值，避免无必要的 breaking change；公开基础实例显式使用 step。
- 不改变 `TCascaderOption` 的 typed、immutable 数据模型。

## 行为契约

- `value + onChanged` 继续构成严格受控路径；`onChanged == null` 是整体禁用入口。
- `variant` 唯一表达 step / tab 导航形态。
- 原始字段映射在创建 `TCascaderOption` 的边界完成。
- 搜索结果、逐级副标题、Popup 取消/确认和允许中间层确认属于调用方编排。

## 验收标准

- 页面仅出现「类型 / 进阶」两组七个触发实例，顺序与小程序一致。
- step、tab、初始路径、typed mapping、次级标题、任意层确认和搜索均有功能断言。
- 组件测试、Demo 功能测试、light/dark Golden、覆盖率和双版本 analyze 通过。
