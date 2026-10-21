# Picker 设计说明

<a id="record-026-demo-alignment"></a>
<a id="record-043-popup-layout"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

联动数据、滚轮状态和业务确认容易形成多份值来源。

- 视觉以用户提供的 Figma 分支 `4SdclZkcv5bPgX6pa8AsmI` 为准；页面壳采用 Flutter 导航栏，视口 375px。明色页面底色为设计稿 #F6F6F6，深色使用当前主题。
- 小程序 API 实现参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`，直接读取 `packages/components/calendar`、`picker`、`picker-item`、`date-time-picker` 的 props/实现/less。小程序冻结源仅解释对应阶段的跨端依据，不能替代当前设计版本验收。
- `ExamplePage.backgroundColor` 原来没有作用于 compact header，本次补齐现有参数语义，默认不传的其他页面不受影响。

Figma 中通用底部 Popup 高 240px，Picker 弹层则是 58px 标准头部加 200px 滚轮，总高 258px。既有 Picker 和 DateTimePicker Demo 各自手写高度计算，Form Demo 遗漏后落到 Popup 的 240px 默认值，导致滚轮被压缩为 182px。

## 范围与非目标

### 目标

- 由 Picker 组件域统一管理标准弹层的高度契约。
- 默认弹层保持 258px，滚轮完整保持 200px。
- 自定义 `TPickerThemeData.height` 时，弹层总高同步变为滚轮高度加 58px。
- Picker、DateTimePicker 和 Form 使用同一弹层入口，不再在 Demo 中重复尺寸计算。

### 不涉及

- 新增 `TPickerPopup.show`，仅封装 Picker 专用的 Popup 路由与尺寸。
- `TPicker` 和 `TDateTimePicker` 仍是纯滚轮面板，不内置业务状态或确认/取消行为。
- 不修改 `TPopup` 通用默认高度 240px。
- 不改变 Picker 的受控值、滚动和主题契约。

## 最终方案与行为契约

### 目标与设计契约

- Figma 页面入口节点 `24386:5250`；当前文件中的移动端展示01/02节点为 `28591:38590`、`28591:38614`，尺寸分别为 375×776 和 375×812，选项文字节点为 `27213:22618`。两组三个基础行、两个标题样式行，共五个入口，各行留白。
- 初值深圳市、2020 秋、广东 深圳 福田区；地区弹层在选中项两侧依次展示天津/北京/湖南/湖北、广州/韶关/珠海/汕头、宝安区/南山区/罗湖区/光明区，与移动端展示02一致。长标签由组件单行省略处理。
- 默认字体环境下为 200px / 5 项 / 每项40px；选中条左右16px、圆角6px、列内容左右32px；文字16/24、在40px行内上下各8px并等分额外行高，选中600，普通次级色，禁用色；上下48px渐隐。
- 标准弹层由 TPickerPopup 统一为滚轮主题高度（默认 200）加 TPopupHeader.headerHeight 预留总高，避免调用方重复计算或遗漏后被 Popup 默认总高压缩滚轮。TPopupHeader 的默认标题样式清除路由诊断下划线，同时保留子 Widget 显式文字装饰。
- 删除四档字号缩放、颜色混合和多重透明度；保留 Flutter ListWheelScrollView 的滚动、惯性、受控同步、无障碍和禁用项回退。

### API 与状态所有权审查

| API | 默认、空值与职责 | Flutter 判断 |
|---|---|---|
| items | required；TPickerColumns 为独立列，TPickerLinked 为树联动 | 两种结构职责不同；typed option 不复制 keys 字段别名 |
| value / onChanged | required 每列值；空回调禁用 | 唯一受控状态，不增加 defaultValue/confirm |
| onColumnScrollEnd | 某列停止滚动的通知，带当前快照 | 与值改变时机不同，不承担确认/完成；保留 |
| itemBuilder | null 返回默认项；包含禁用项 | Widget 扩展覆盖默认内容；disabled 仍控制选择行为 |
| TPickerOption | label、value、children、disabled | 数据/联动/单项禁用独立，不引入外部动态字段类型 |
| TPickerValue | selectedOptions；values/labels 从选中项派生、indexes 给出位置 | 只读结果，不形成另一状态源 |
| TPickerThemeData | height/itemCount；实例无重复尺寸入口 | 默认200/5，行高由二者计算，保留 |
| TTextThemeData / TDesign Token | 普通 fontBodyLarge、选中 fontMarkLarge；显式组件文字主题按字段覆盖 | 同时验证默认、暗色、定制字号；不增加状态配色枚举 |

### API 收敛补充

受控值以调用方传入的 value 为准：拖动和惯性期间允许临时滚动位置；所有列停止后，若父级未接受 onChanged 的新值，即使没有触发父级重建，也恢复到传入值。父级同步接受时保留当前滚动活动；外部主动更新仍立即同步。onColumnScrollEnd 报告停止时的候选快照，不能据此判断父级已接受。此修复改变此前父级不回传时停留在候选项的行为，需在交付中说明。

TPickerThemeData 的 height 必须为有限正数、itemCount 必须大于零（调试断言）；默认分别为 200 逻辑像素与 5，行高由两者相除。保留 const 构造；输入 value、数据源嵌套列表和手工构造的快照列表遵循 Flutter 不可变输入契约，禁止原地修改，变更应提供新集合。组件发出的快照继续采用不可修改列表。

联动滚轮在父级接受 onChanged 回传值时，保留变更列及其前置列的滚动控制器和 Widget 身份，仅重建后续联动列，保证连续拖动和松手惯性不被受控回传中断。外部主动修改值或替换数据源仍同步到指定选项。语义信息随滚动更新，但不逐帧重建完整滚轮子树；不增加 API 或改变主题样式。

- 内置文字优先使用明确的实例/组件 TDesign 样式和 Token；不从外部 Material TextTheme 或 DefaultTextStyle 反推配置，自定义内容保留其原上下文。

### 示例代码展示契约

四个公开代码入口展示实际运行的 `_cell` 核心组合，包含触发 Cell、标签解析、Popup/Header、受控 Picker 草稿及确认/取消。数据、父级状态和差异配置通过参数传入，并在片段中明确说明初始值，不通过外部源码地址补充示例内容；不宣称核心片段是独立应用。共用实现从源码生成，不扩增组件或 Example 框架 API。

代码面板必须通过真实打开验证；现有双版本 Demo 套件覆盖四个入口。Android 真机与 iOS 模拟器共用 `example/integration_test/picker_example_test.dart`，通过 Flutter SDK 自带 integration_test 验证实际应用路由、五个触发器的取消/确认、深浅色展开态和代码面板；它是需设备的手动验收入口，不计入普通 CI 已通过证据。

显式 height 仍优先；未配置时默认视窗至少 200dp，并按最终文字自然行高与 itemCount 增长，不将大字体裁切为固定 200dp。自定义 itemBuilder 的内容高度由构建器契约负责，不推测其布局。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | Picker 是严格受控的平铺面板；Popup/Header 和业务草稿由调用方组合。 |
| 保留的边界与代价 | 接受回传时保留未受影响列的控制器；拒绝候选后停止滚动再回滚，平衡受控一致性与惯性体验。 |

## 兼容性与迁移

不新增公共 API。默认字体、渐隐和禁用项 itemBuilder 行为有可见修复；仍使用相同的受控与滚动契约。与 DateTimePicker 共用 MultiWheelLayout/PickerItemWidget，两个消费方均纳入回归。

## 验收标准

- 共用滚轮外壳自带当前子树 `bgColorContainer` 底色，不透出父面板背景；边缘渐隐使用相同底色至透明，高度取 `spacer48` 并限制在面板半高以内。定制面板色需通过当前子树 TDesign token 配置。
- `picker_consumers_theme_test.dart` 在对应组件套件中登记，分别经 TPicker 与 TDateTimePicker 验证默认/定制 token 下的底色、渐隐颜色和方向、高度、高亮色及不拦截指针。两个消费组件都能独立执行这组验证。
- 独立面板的受控、禁用、边界、主题路径通过组件测试；Demo 验证完整实例顺序、初值、真实点击/拖动、取消与确认。
- Flutter 3.32.0、3.47.0 严格 analyze 和非视觉回归；生产代码 LH/LF >=95%。
- 仅 Flutter 3.32.0 Linux 更新/比较 Golden，固定 375px、DPR 1、字体缩放 1、中文测试字体；关闭态页面固定 375×776，打开态固定 375×812，覆盖完整页面与实际打开的各场景、light/dark。状态矩阵另设 420×180。
- 更新后立即无更新参数复跑；系统字体、Android/iOS 真机不由 Linux Golden 证明。
- 默认主题下 Popup 总高 258px，头部 58px，滚轮 200px。
- 主题滚轮高度为 240px 时 Popup 总高 298px。
- 三个 Demo 调用链均使用 `TPickerPopup.show`。
- Picker 组件回归、三个 Demo 功能测试、严格 analyze 和必要的 Golden 比对通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
