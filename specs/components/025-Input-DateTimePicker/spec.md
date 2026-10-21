# DateTimePicker 设计说明

<a id="record-025-demo-alignment"></a>
<a id="record-056-label-updates"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

日期列、隐藏计算年和受控滚动回传会影响边界、标签及惯性。

- 视觉以用户提供的 Figma 分支 `4SdclZkcv5bPgX6pa8AsmI` 为准；页面壳采用 Flutter 导航栏，视口 375px。明色页面底色为设计稿 #F6F6F6，深色使用当前主题。
- 小程序 API 实现参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`，直接读取 `packages/components/calendar`、`picker`、`picker-item`、`date-time-picker` 的 props/实现/less。小程序冻结源仅解释对应阶段的跨端依据，不能替代当前设计版本验收。
- `ExamplePage.backgroundColor` 原来没有作用于 compact header，本次补齐现有参数语义，默认不传的其他页面不受影响。

## 范围与非目标

使用带可空字段的强类型日期值；隐藏计算年参与归一化但不作为额外公开状态。

## 最终方案与行为契约

### 目标与设计契约

- Figma 节点 `24386:5248`，375×1340 Demo。类型依次为年月日、年月、月日、时分秒、时分、年月日时分秒、年月日带星期；样式为带标题、无标题，共九个入口。
- 初始日期 2022-08-10、时间 12:50:23。调整步数与内嵌演示不再作为设计稿之外的公开块；步进、平铺使用继续由独立组件测试覆盖。
- 完整六列示例用现有 renderLabel 省略年份单位，保留四位年份，避免窄屏出现 `2022…`；组件默认标签规则不变。
- 滚轮与 Picker 共享 200px / 5项 / 40px、16px文字、选中600字重、边缘渐隐。Popup 标题/按钮/格式化结果均在 Demo 组合。

### API 与状态所有权审查

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

### API 收敛补充

父级重建时，即使 value 与旧值相同，也必须校正被拒绝的滚轮选择；比较按当前模式、边界、步进归一化的值，父级接受新值时保持惯性滚动。
共享滚轮普通字体回退 fontBodyLarge，选中字体回退 fontMarkLarge，显式 TTextThemeData.textStyle 按字段覆盖；不增加同义实例或 Theme 参数。

接受与拒绝路径统一比较归一化后的完整 current 日期，包括隐藏计算年；保留同一计算年接受选择不重建滚轮，仅计算年变化则必须重建。

### 代码面板完整性补充

九个入口共用核心片段，面板内说明每个场景的实际配置、初始值和父级 setState 接入；值格式化实现包含在实际生成的方法内，不依赖未展示的私有方法。组件公开 API 和运行布局不变。共享回归保留在各消费组件套件中，保证独立执行的覆盖。

### 字重核对修正

Figma 当前分支节点 28591:37823（02 组件样式）为 Title/Large，PingFang SC Semibold，18/26、600；节点 39079:22146（选择时间）为 Body/Large，16/24、400。compact Demo 分组标题由共享页面壳读取 fontTitleLarge，不另写 700；共享分组标题直接读取全局 TD `fontTitleLarge` 与主文字色，定制该标题应修改相应 TD Token；不另设组件文字主题的分组标题入口。普通 Cell 保持 fontBodyLarge，不在 DateTimePicker Demo 强制减重。共享壳改动涉及使用 compactDemo 的其他页面，需验证相应 Golden。

### 主题与受控回滚补充

- 内置文字优先使用明确的实例/组件 TDesign 样式和 Token；不从外部 Material TextTheme 或 DefaultTextStyle 反推配置，自定义内容保留其原上下文。

Picker 与 DateTimePicker 均在全部滚轮停止后恢复父级未接受的候选值；接受值不重建控制器，不中断惯性。公开 API 签名不变，DateTimePicker 不回传值时改为自动回滚，属于行为变化。

组件文案更新的根因修复契约见 [056](spec.md#record-056-label-updates)。

显式 height 仍优先；未配置时默认视窗至少 200dp，并按最终文字自然行高与 itemCount 增长，不将大字体裁切为固定 200dp。自定义 itemBuilder 的内容高度由构建器契约负责，不推测其布局。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 使用带可空字段的强类型日期值；隐藏计算年参与归一化但不作为额外公开状态。 |
| 保留的边界与代价 | 父级接受值时保留惯性，拒绝时在滚轮停止后回滚；文案更新不得重建无关控制器。 |

## 兼容性与迁移

已有 mode 与默认值保持；父级拒绝候选值时滚轮停止后自动回滚，不能表述为全部受控行为不变。依赖旧的候选停留行为的调用方应在 onChanged 中明确接收并回传值。新增 `DateMode.monthDay` 是本轮唯一公开能力扩展；依赖枚举穷尽 switch 的调用方需补充该分支，必须在变更说明中提示此源码兼容风险。选择器不新增标题、Popup、确认或取消 API。

## 验收标准

- 共用滚轮外壳自带当前子树 `bgColorContainer` 底色，不透出父面板背景；边缘渐隐使用相同底色至透明，高度取 `spacer48` 并限制在面板半高以内。定制面板色需通过当前子树 TDesign token 配置。
- `picker_consumers_theme_test.dart` 在对应组件套件中登记，分别经 TPicker 与 TDateTimePicker 验证默认/定制 token 下的底色、渐隐颜色和方向、高度、高亮色及不拦截指针。两个消费组件都能独立执行这组验证。
- 独立面板的受控、禁用、边界、主题路径通过组件测试；Demo 验证完整实例顺序、初值、真实点击/拖动、取消与确认。
- Flutter 3.32.0、3.47.0 严格 analyze 和非视觉回归；生产代码 LH/LF >=95%。
- 仅 Flutter 3.32.0 Linux 更新/比较 Golden，固定 375px、DPR 1、字体缩放 1、中文测试字体，覆盖完整页面与实际打开的各场景、light/dark。状态矩阵另设 420×180。
- 更新后立即无更新参数复跑；系统字体、Android/iOS 真机不由 Linux Golden 证明。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
