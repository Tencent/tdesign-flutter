# DateTimePicker 平铺滚轮与 Figma Demo 对齐

## 目标与设计契约

- Figma 节点 `24386:5248`，375×1340 Demo。类型依次为年月日、年月、月日、时分秒、时分、年月日时分秒、年月日带星期；样式为带标题、无标题，共九个入口。
- 初始日期 2022-08-10、时间 12:50:23。调整步数与内嵌演示不再作为设计稿之外的公开块；步进、平铺使用继续由独立组件测试覆盖。
- 完整六列示例用现有 renderLabel 省略年份单位，保留四位年份，避免窄屏出现 `2022…`；组件默认标签规则不变。
- 滚轮与 Picker 共享 200px / 5项 / 40px、16px文字、选中600字重、边缘渐隐。Popup 标题/按钮/格式化结果均在 Demo 组合。

## API 与状态所有权审查

| API | 默认、空值与职责 | Flutter 判断 |
|---|---|---|
| value / onChanged | required partial typed value；空回调禁用；仅包含可见列的结果 | 唯一受控值，不增加 defaultValue 或 confirm 回调 |
| mode | 默认年月日；dateMode 与 timeMode 至少指定一个 | typed 组合优于字符串数组；新增最小 DateMode.monthDay |
| DateMode | year、month、date、monthDay | monthDay 不显示年份，结果 year=null；缺省计算年2000，允许2月29日；业务绑定年份时在接收回调后继续传 value.year |
| TimeMode | hour、minute、second；null 无时间列 | 与日期列独立组合，保留 |
| start / end | 未指定时年列范围为初始选中年±10，滚动年份时范围不漂移；monthDay 的无年份边界使用 value 的计算年，value 也无年份时使用2000 | 与小程序当前时间±10不同；保留已发布边界，避免显式计算年与 partial 边界落在不同年份 |
| steps | 各列缺省1 | 单一取值步进，保留，不复制未被设计使用的 filter |
| showWeek | false；仅影响日列标签 | 与年月日示例分开演示，保留 |
| renderLabel | 返回null使用本地化标签 | 只拥有显示，不改变值；不增加小程序 format 输出格式参数 |
| TDateTimePickerValue | year/month/day/hour/minute/second；未包含列为null；toDateTime需fallback | typed 数据边界；不增加隐藏年份状态或控制器 |
| TPickerThemeData | height / itemCount | 与 Picker 共用视觉默认，不存 mode、value、steps |

## 兼容性

所有已有 mode、默认值、受控行为保持。新增 `DateMode.monthDay` 是本轮唯一公开能力扩展；依赖枚举穷尽 switch 的调用方需补充该分支，必须在变更说明中提示此源码兼容风险。选择器不新增标题、Popup、确认或取消 API。

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

父级重建时，即使 value 与旧值相同，也必须校正被拒绝的滚轮选择；比较按当前模式、边界、步进归一化的值，父级接受新值时保持惯性滚动。
共享滚轮字体只读取显式 TextTheme，否则使用当前 TDesign fontBodyLarge 字号和行高；不增加 Theme 或实例参数。

接受与拒绝路径统一比较归一化后的完整 current 日期，包括隐藏计算年；保留同一计算年接受选择不重建滚轮，仅计算年变化则必须重建。

## 代码面板完整性补充

九个入口共用核心片段，面板内说明每个场景的实际配置、初始值和父级 setState 接入；值格式化实现包含在实际生成的方法内，不依赖未展示的私有方法。组件公开 API 和运行布局不变。共享回归保留在各消费组件套件中，保证独立执行的覆盖。

## 字重核对修正

Figma 当前分支节点 28591:37823（02 组件样式）为 Title/Large，PingFang SC Semibold，18/26、600；节点 39079:22146（选择时间）为 Body/Large，16/24、400。compact Demo 分组标题由共享页面壳读取 fontTitleLarge，不另写 700；保留调用方显式 TextTheme.titleLarge 覆盖。普通 Cell 保持 fontBodyLarge，不在 DateTimePicker Demo 强制减重。共享壳改动涉及使用 compactDemo 的其他页面，需验证相应 Golden。

## 主题与受控回滚补充

默认选中字体使用 fontMarkLarge，普通字体使用 fontBodyLarge；显式 TextTheme、DefaultTextStyle 和 TTextThemeData 按文字主题优先级覆盖默认值。高度主题由未配置状态参与动画时以 200 插值，两端均未配置时保持 null。

Picker 与 DateTimePicker 均在全部滚轮停止后恢复父级未接受的候选值；接受值不重建控制器，不中断惯性。公开 API 签名不变，DateTimePicker 不回传值时改为自动回滚，属于行为变化。
