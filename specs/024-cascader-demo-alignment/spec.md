# Cascader 公开 Demo 对齐

## 背景

Flutter Cascader 的公开 Demo 原先以常规能力分组，未覆盖小程序公开页面的类型与进阶实例，也没有明确说明 typed option、搜索与弹层的 Flutter 所有权边界。首轮对齐后又发现所有场景都被 Demo 改成确认式提交、次级标题以路径长度猜测内部层级、打开状态缺少 Golden，组件还会继承 Material 控件的隐式布局与图标默认值。

## 目标

- 按当前小程序公开页面顺序覆盖基础、选项卡、初始值、自定义数据映射、次级标题、任意层选择和搜索，并用 Chrome 复现完成行为。
- 以 Figma `24386:5246` 的 step/tab、1-4 层、subtitle 和 close-btn 变体作为可见结构基线。
- 保持 `TCascader` 为严格受控的平铺层级面板；Popup、搜索输入、提交策略和原始数据映射由 Flutter Widget 组合完成。
- 由组件内部活动层级选择次级标题，不公开第二套层级状态源。
- 补齐 Demo 结构、交互、打开状态 light/dark Golden 与组件回归证据。

## 非目标

- 不复制小程序的 `visible`、`title`、`closeBtn`、`defaultValue`、`keys`、`filterable` 等弹层或动态对象参数。
- 不改变 `TCascaderVariant.tab` 的既有默认值，避免无必要的 breaking change；公开基础实例显式使用 step。
- 不增加 `initialValue`、Controller 或公开 `activeLevel`。

## 行为契约

- `value + onChanged` 继续构成严格受控路径；`onChanged == null` 是整体禁用入口。
- `variant` 唯一表达 step / tab 导航形态。
- `subtitles` 是按内部活动层级读取的不可变内容配置，不让调用方控制活动层级。
- 原始字段映射在创建 `TCascaderOption` 的边界完成。
- 基础、tab、初始值、字段映射、次级标题和搜索在选中末级后提交并关闭；任意层示例由 Popup 关闭按钮提交当前草稿，点击蒙层不提交。
- `TCascaderOption.children` 按 Flutter Widget 不可变配置约定使用；数据变化时替换 option/list，不支持原地变更。
- 选项列表由组件固定为零 padding，不继承宿主 `MediaQuery` 安全区；弹层边界由组合层负责。
- TSearchBar 自身提供 TextField 所需的 Material 渲染上下文，使其无需 Demo 额外包装，
  同时不向 Popup 的其他子组件注入 Material 默认视觉。

## 验收标准

- 页面仅出现「类型 / 进阶」两组七个触发实例，顺序与小程序一致。
- step、tab、初始路径、typed mapping、活动层级次级标题、任意层提交、末级自动完成和搜索均有功能断言。
- “查看代码”展示真实 `TPopup + TCascader` 状态组合，不引用未展示的私有核心方法。
- 组件测试、Demo 功能测试、打开与关闭状态 light/dark Golden、覆盖率和双版本 analyze 通过。
