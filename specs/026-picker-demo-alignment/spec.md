# Picker 平铺滚轮与 Figma Demo 对齐

## 目标与设计契约

- Figma 节点 `24386:5250`，移动端展示01/02；两组三个基础行、两个标题样式行，共五个入口，各行留白。
- 初值深圳市、2020 秋、广东 深圳 福田区；示例数据让选中项两侧可见完整候选，保留真实地区名称。长标签由组件单行省略处理。
- 200px / 5 项 / 每项40px；选中条左右16px、圆角6px、列内容左右32px；文字16px、选中600，普通次级色，禁用色；上下48px渐隐。
- Demo 弹层总高由滚轮主题高度（默认 200）加 TPopupHeader.headerHeight 计算，避免 Popup 默认总高压缩滚轮。TPopupHeader 的默认标题样式清除路由诊断下划线，同时保留子 Widget 显式文字装饰；Demo 直接组合 TPopupHeader/TText/TPicker，无额外 Material 包装。
- 删除四档字号缩放、颜色混合和多重透明度；保留 Flutter ListWheelScrollView 的滚动、惯性、受控同步、无障碍和禁用项回退。

## API 与状态所有权审查

| API | 默认、空值与职责 | Flutter 判断 |
|---|---|---|
| items | required；TPickerColumns 为独立列，TPickerLinked 为树联动 | 两种结构职责不同；typed option 不复制 keys 字段别名 |
| value / onChanged | required 每列值；空回调禁用 | 唯一受控状态，不增加 defaultValue/confirm |
| onColumnScrollEnd | 某列停止滚动的通知，带当前快照 | 与值改变时机不同，不承担确认/完成；保留 |
| itemBuilder | null 返回默认项；包含禁用项 | Widget 扩展覆盖默认内容；disabled 仍控制选择行为 |
| TPickerOption | label、value、children、disabled | 数据/联动/单项禁用独立，不引入外部动态字段类型 |
| TPickerValue | selectedOptions；values/labels 从选中项派生、indexes 给出位置 | 只读结果，不形成另一状态源 |
| TPickerThemeData | height/itemCount；实例无重复尺寸入口 | 默认200/5，行高由二者计算，保留 |
| TextTheme / TDesign token | 标准 bodyLarge 字体继承；颜色/渐隐/间距使用语义 token | 同时验证默认、暗色、定制字号；不增加状态配色枚举 |

## 兼容性

不新增公共 API。默认字体、渐隐和禁用项 itemBuilder 行为有可见修复；仍使用相同的受控与滚动契约。与 DateTimePicker 共用 MultiWheelLayout/PickerItemWidget，两个消费方均纳入回归。

## 组件边界

三个组件均为平铺、严格受控的面板。组件内部不创建 Popup、不显示弹层标题栏或确认按钮，不提供 visible/usePopup/autoClose/defaultValue。使用方自行组合 TPopup、标题、关闭、临时值与取消/确认；公开 Demo 的弹出效果只用于演示这种组合，不代表组件默认模式。

## 参考与默认值判断

- 视觉以用户提供的 Figma 分支 `4SdclZkcv5bPgX6pa8AsmI` 为准；页面壳采用 Flutter 导航栏，视口 375px。明色页面底色为设计稿 #F6F6F6，深色使用当前主题。
- 小程序 API 实现参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`，直接读取 `packages/components/calendar`、`picker`、`picker-item`、`date-time-picker` 的 props/实现/less。旧 PR 的小程序参考与截图保留为历史证据，不能替代本次 Figma 验收。
- `ExamplePage.backgroundColor` 原来没有作用于 compact header，本次补齐现有参数语义，默认不传的其他页面不受影响。

## 验收

- 共用滚轮外壳自带当前子树 `bgColorContainer` 底色，不透出父面板背景；边缘渐隐使用相同底色至透明，高度取 `spacer48` 并限制在面板半高以内。定制面板色需通过当前子树 TDesign token 配置。
- `picker_consumers_theme_test.dart` 在本 PR 的组件套件中登记，分别经 TPicker 与 TDateTimePicker 验证默认/定制 token 下的底色、渐隐颜色和方向、高度、高亮色及不拦截指针。两个 PR 可独立执行这组消费验证。

- 独立面板的受控、禁用、边界、主题路径通过组件测试；Demo 验证完整实例顺序、初值、真实点击/拖动、取消与确认。
- Flutter 3.32.0、3.47.0 严格 analyze 和非视觉回归；生产代码 LH/LF >=95%。
- 仅 Flutter 3.32.0 Linux 更新/比较 Golden，固定 375px、DPR 1、字体缩放 1、中文测试字体，覆盖完整页面与实际打开的各场景、light/dark。状态矩阵另设 420×180。
- 更新后立即无更新参数复跑；系统字体、Android/iOS 真机不由 Linux Golden 证明。

## API 收敛补充

联动滚轮在父级接受 onChanged 回传值时，保留变更列及其前置列的滚动控制器和 Widget 身份，仅重建后续联动列，保证连续拖动和松手惯性不被受控回传中断。外部主动修改值或替换数据源仍同步到指定选项。语义信息随滚动更新，但不逐帧重建完整滚轮子树；不增加 API 或改变主题样式。

滚轮字体仅接受显式 Material TextTheme 覆盖，默认字体字号和行高来自当前 TDesign fontBodyLarge；共享 DateTimePicker 同步验证。
