# Calendar 平铺面板与 Figma Demo 对齐

## 目标与设计契约

- Figma 节点 `28591:36222`；两组九个实例：单选、多选、单行描述、双行描述、翻页、区间、国际化、含不可选日期、内嵌日历。
- 初值单选 2022-02-18、多选 18/20/22、区间 19～21；多选结果限制宽度并省略。内嵌参考日期固定 2023-03-10，展示三月至四月的可滚动日历。
- 弹出示例以标题“请选择日期”、右侧关闭、底部整行确认组合；关闭不提交，区间未选齐不确认。
- 普通日期使用次级文字色，禁用使用禁用色；数字居中，副标题独立定位在下方。弹出示例通过 Material 提供文字环境，单行描述使用标准 Text 继承副标题样式；双行描述复用 cellBuilder，显示顶部节日和底部价格，无需新增 prefix API。
- 国际化示例显式加载应用的 Localizations delegates；测试配置与应用一致的资源代理，并断言 SUN/MON，避免仅标题翻译而星期仍为中文。
- 翻页示例限定单月，并保留全局选择值；到边界禁用箭头。复用 anchorDate、minDate/maxDate、monthTitleBuilder 与 Theme 隐藏重复月标题，使用 TDesign 图标。

## API 与状态所有权审查

| API | 默认、空值与职责 | Flutter 判断 |
|---|---|---|
| value / onChanged | 必填选中列表；回调为空禁用；挂载不回调 | 唯一受控状态，保留 |
| variant | single 默认，multiple/range 改变选择行为 | 已发布选择模式，不增加另一 type/status；命名历史债务不在本次重命名 |
| minDate / maxDate | 默认 1970-01-01～2100-12-31，按自然日、允许单日范围 | 小程序默认今天～半年后；保留 Flutter 既有边界，不因 UI 修复改变用户数据范围 |
| firstDayOfWeek | `TCalendarFirstDayOfWeek.sunday` 默认 | 使用星期枚举，避免无效整数；枚举顺序与内部星期索引一致 |
| anchorDate / animateTo | 可见月份定位 / 默认无动画 | 不拥有选择值；保留声明式定位 |
| onMonthChanged | 可见月份通知 | 不重复选择通知；保留 |
| cellBuilder / subtitleBuilder | 整格替换 / 默认日期下方内容；整格优先 | 用 builder 表达内容，不引入业务节日字段 |
| monthTitleBuilder | 默认本地化年月 | 保留 Widget 组合；语言走 Localizations |
| TCalendarThemeData | height、decoration、weekday/day/today/month/subtitle 字体、cellDecoration、cellHeight、monthTitleHeight、verticalGap、bodyPadding、weekdayGap、centreColor | 只存视觉；实例无同义字段；保留既有 Theme 覆盖 |

## 兼容性

不增加组件构造参数，不引入 Popup 模式。原 PR 的自然日边界修复与六行默认高度保留；本轮改变默认日期文字色和描述布局，属于可见样式修复，既有显式 dayStyle/subtitleStyle/cellBuilder 继续可用。

## 组件边界

三个组件均为平铺、严格受控的面板。组件内部不创建 Popup、不显示弹层标题栏或确认按钮，不提供 visible/usePopup/autoClose/defaultValue。使用方自行组合 TPopup、标题、关闭、临时值与取消/确认；公开 Demo 的弹出效果只用于演示这种组合，不代表组件默认模式。

## 参考与默认值判断

- 视觉以用户提供的 Figma 分支 `4SdclZkcv5bPgX6pa8AsmI` 为准；页面壳采用 Flutter 导航栏，视口 375px。明色页面底色为设计稿 #F6F6F6，深色使用当前主题。
- 小程序 API 实现参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`，直接读取 `packages/components/calendar`、`picker`、`picker-item`、`date-time-picker` 的 props/实现/less。旧 PR 的小程序参考与截图保留为历史证据，不能替代本次 Figma 验收。
- `ExamplePage.backgroundColor` 原来没有作用于 compact header，本次补齐现有参数语义，默认不传的其他页面不受影响。

## 验收

- 独立面板的受控、禁用、边界、主题路径通过组件测试；Demo 验证完整实例顺序、初值、真实点击/拖动、取消与确认。
- Flutter 3.32.0、3.47.0 严格 analyze 和非视觉回归；生产代码 LH/LF >=95%。
- 仅 Flutter 3.32.0 Linux 更新/比较 Golden，固定 375px、DPR 1、字体缩放 1、中文测试字体，覆盖完整页面与实际打开的各场景、light/dark。状态矩阵另设 420×180。
- 更新后立即无更新参数复跑；系统字体、Android/iOS 真机不由 Linux Golden 证明。

## API 收敛补充

日期格模型改为不可变快照，仅暴露 date/selectType/isLastDayOfMonth；删除可写 DateSelectTypeNotifier 和 typeNotifier。调用方通过 value/onChanged 更新选择；直接构造模型改传 selectType，属于 breaking API 收敛。variant 保留原名，仅表示选择模式，不新增同义入口。
