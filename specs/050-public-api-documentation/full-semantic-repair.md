# 当前 57 个组件逐项文档核查与修复

日期：2026-10-09。提交前基准 `f203cedf703158454a330bc4cf8613d897b573c7`；本轮未提交/推送/合并。

## 本轮与此前的区别

此前主要修复样本后，依靠全量生成与回归扩大了其余组件结论，这是不充分的。本轮不再以“沿用历史审查”作为状态：每个 manifest 组件均列出当前核对的公开契约、当前源码哈希和具体消费用例。当前 57/57 均有至少一个对应消费任务，三批合计 82 项；不是说每个 API 的全部业务/视觉边界都已经穷尽。

文档问题按当前实现直接修正。组件实现风险单列，不阻塞可确认的文档处理，也没有擅自变更运行逻辑。

## 已直接修正

- Toast 的七个返回说明指向真实的 `dismissToast`，不再引用不存在的 dismiss。
- Input 清除按钮与密码显隐按钮的互斥条件；TimeCounter 计时/控制器与父级声明式重置的通知区别。
- SwipeCell Future 在动画完成或被后续命令/卸载取消时都结束，不承诺目标状态仍存在。
- Radio 的重复点选通知；Upload 新增流程中同步业务异常也会转发 onError，区别于网络上传失败。
- Upload 主要 nullable Theme 字段的默认尺寸、Token 和生效场景。
- 另外对当前调用点逐项核对并补充 66 个主题字段的回退说明，涉及 14 个组件目录；实例参数优先、启用/禁用、形态和场景的不同不能套用同一默认值。
- Sidebar 的 item.value 是业务值，不自动生成 children 位置；Footer 的 links/text 可组合、logo 优先于 links；Stepper 无回调时按钮禁用、编辑器只读。
- 删除 FAB 的 T2 内部层级叙述。未机械改动已准确的简单组件文本。

这轮修改 26 个生产 Dart 文件、22 份 API 资产；两个 SDK 下全部非注释 token（包括逗号）与基准完全相同，公开签名、默认行为和实现不变。

## 当前验证

| 验证 | Flutter 3.32.0 | 本机新版 Flutter 3.47.6 |
| --- | --- | --- |
| 严格 analyze --fatal-infos | 0 issue | 0 issue |
| 当前 57 组件消费证据 | 82 项通过 | 82 项通过 |
| 现有组件非 Golden 行为 | 2707 项通过 | 2707 项通过 |
| 文档结构/typedef/审计专项 | 115 项通过 | 115 项通过 |
| 真实 Flutter API 页面 | 70 项通过 | 70 项通过 |
| generate / validate | 57 份；ERROR/WARN=0 | 57 份；ERROR/WARN=0 |
| AST 和 token | 无契约或运行 token 差异 | 无契约或运行 token 差异 |

两 SDK 全量生成逐份字节相同，并与当前资产一致。官网 18 项测试与生产构建通过；本轮浏览器逐页检查 57/57、369 类型、812 张统一五列表，无坏行、空返回说明或 API 源码代码块。官网嵌入 Demo 与设备/Golden 不据此认定通过；本轮未重复构建 Flutter Web。

## 逐组件当前证据

下列各行是本轮核对的具体范围，不是统一“通过”模板。源码路径、源码哈希及消费用例名称详见 current-semantic-ledger.json；三批原始测试保存在 semantic-evidence/。

| 组件 | 当前核对契约 | 对应公开消费用例数量 |
| --- | --- | ---: |
| button | onPressed=null 禁用长按；size/variant/colorPreset/style 独立职责 | 1 |
| divider | 竖线忽略 child/dashed；14dp 高度和方向约束 | 1 |
| fab | Stack 直接子级与 Positioned 坐标；默认动作与自定义 child | 1 |
| icon | 独立 24dp 默认、显式参数与 IconTheme 的区别 | 1 |
| link | 回调归调用方；子内容与前后图标的布局职责 | 1 |
| text | 原生 Text 配置和显式样式保留；字体加载不在绘制时隐式发生 | 1 |
| back-top | 无 controller 的回调模式；有 controller 时先滚动后完成回调 | 1 |
| drawer | showTDrawer 返回句柄的生命周期；面板主题与项目主题的回退 | 1 |
| indexes | 外部 ScrollController 的借用/释放；索引唯一性与 builder 内容 | 1 |
| navbar | PreferredSizeWidget 高度与安全区；操作项及返回回调 | 1 |
| side-bar | 条目业务值不自动生成索引；受控回调与整栏禁用 | 1 |
| steps | 命名构造对应只读/进度/可选；点击请求不隐式更新 value | 1 |
| tab-bar | null onChanged 整栏禁用且屏蔽 item 回调；300ms 默认动画 | 1 |
| tabs | DefaultTabController 依赖；onTap=null 不禁用原生标签切换 | 1 |
| calendar | cellBuilder/subtitleBuilder 的 null 区别；六行默认视窗与 Token 回退 | 3 |
| cascader | 分支路径仅为候选；父级回传才推进层级；step/tab 导航 padding 区别 | 1 |
| checkbox | 选择上限阻止新增但允许取消；受控回传与禁用文字 Token | 1 |
| picker | null itemBuilder 回退；Popup 头部占位及 show 时高度快照 | 1 |
| date-time-picker | 模式字段与 partial 值；fallback 按 DateTime 规则归一化 | 2 |
| form | 校验成功不等于业务提交；外部错误与 reset 不替业务重置受控值 | 3 |
| input | controller/focus 借用；清除与密码互斥；加权输入与状态样式回退 | 5 |
| radio | 空组回调禁用；重复已选项仍通知；启用/禁用颜色优先级 | 2 |
| rate | count/value 约束；图标尺寸/间距和提示阴影的 Token 回退 | 1 |
| search | 无焦点可清除；clear 的通知顺序；只读可聚焦不显示清除 | 2 |
| slider | null onChanged 禁用；受控 value 与 trackHeight 默认 4 | 1 |
| stepper | 受控值；null 回调禁用按钮并使编辑器只读；背景/边框回退 | 1 |
| switch | 点击只报告候选，不改变 value；loading/null 回调阻止编辑 | 1 |
| textarea | 复用 Input；minLines 被 maxLines 收敛；标题与表单标签职责 | 1 |
| tree-select | 单选路径数量和叶子解析；root/selected/disabled Token 回退 | 1 |
| upload | 整批校验/缺 size 跳过；只读列表；选择流程内同步回调错误范围；80dp 网格默认 | 4 |
| avatar | 图片/child 优先级；中号 48dp 与点击行为 | 1 |
| badge | null label 隐藏文字徽标而 dot 不读 label；锚点与配置职责 | 1 |
| cell | 单元格点击；对齐/分隔线与 CellGroup 的职责 | 1 |
| time-counter | 零值结束的显式 start；reset 暂停与广播；声明式 time/direction 重置不通知 | 3 |
| collapse | 展开请求不隐式接受 value；bodyHeight 包含 padding 与有限值约束 | 1 |
| empty | 显式 null icon 回退；image 优先与文本 Token | 1 |
| footer | links 与 text 组合；logo 优先于 links，仍可与 text 组合 | 1 |
| image | src=null 加载占位、空串失败占位；imageFile 互斥与尺寸 | 1 |
| image-viewer | 空 images 同步抛错；路由 Future 时机；导航槽位与暗色背景回退 | 1 |
| progress | 0..1 分数与百分比标签；状态/渐变优先级与可交互变体 | 1 |
| result | 自定义 icon 替代状态图标；默认 iconSize 及字体 Token | 1 |
| skeleton | 延迟显示；null 动画静态；预设与 custom 布局互斥 | 1 |
| swiper | 未附加命令无操作；实际业务索引与自动播放；尺寸/分页颜色回退 | 2 |
| table | 排序回传、可见索引和点击顺序；跨度约束；38dp 行/表头与无界宽度 | 1 |
| tag | enabled=false 阻止正文与关闭点击；关闭不代替父级移除 | 1 |
| action-sheet | 选中回调先于关闭；返回 Popup 句柄与网格配置限制 | 1 |
| dialog | typed result 与动画时机；null 动作回调不等于禁用；PopScope 关闭范围 | 2 |
| dropdown-menu | 取消请求也完成 Future；草稿不自动提交；面板高度与控制器所有权 | 1 |
| loading | 全局层不重复创建；没有 Overlay 不创建；图标/文案默认 | 1 |
| message | 默认位置替换旧句柄；dismiss 通知一次；直接 Widget 与 Overlay 模式区别 | 1 |
| notice-bar | items 优先于 content；点击区域 target 与静态/marquee 行数 | 1 |
| popover | Anchor 的展开配置快照；控制器绑定开关与关闭 Future | 1 |
| popup | result 早于关闭动画；安全区方向、主题快照、重复打开与无 Navigator | 1 |
| pull-down-refresh | 静态有界内容不等于可滚动；异常/超时 Future 与资源释放 | 2 |
| swipe-cell | 控制器不受 enabled 限制；取消动画 Future 正常结束；状态回调早于动画 | 3 |
| toast | 返回 ID 指向 dismissToast；匿名复用与具名共存；duration 哨兵 | 1 |
| theme | parse 默认映射回退与额外数据条件；copyWith null；lerp 的现有数据丢失风险 | 4 |

## 实现风险另说

- TThemeData.lerp 不保留 extraThemeData：现有事实已写明，是否修实现需要独立决定兼容性；本轮没有修组件。
- Upload 在选择流程 catch 中还处理同步业务回调异常：本轮按现有范围修正文档；是否收窄错误边界需要单独决定，不能写成“文件选择失败”来掩盖。

## 经验与状态纠正

1. 每个组件都必须有当前说法→实际调用分支→具体消费任务的证据链，不再以历史报告或全量绿色数字代替逐组件核对。
2. null/未传、空集合、禁用与只读、取消/无操作、回调与结果、快照与动态回退分别表达；不从参数类型或名字猜语义。
3. 运行时默认值写在说明，源码声明列保留 AST 默认；状态/形态/实例覆盖必须先判断再写回退。
4. 初次消费用例误用了 Link/Tag 参数名、误将 Sidebar value 视为数组索引，以及误读 Footer 子布局；这些都先按当前源码纠正用例，再修改文档，没有为了通过断言改变运行行为。
5. Stepper 的编辑节点是 EditableText 且只读，不应依靠是否存在 TextField 推断禁用；文档采用准确的按钮/编辑器分工。
6. 两 SDK 的 package_config 必须各自 pub get，不能串用；临时失败日志不应当作组件缺陷。
7. 未跑完的设计、设备、Golden 与正式远端交付明确列出，不能把当前有限范围扩大成“所有语义永远正确”。

## 剩余交付门禁（不阻塞已确认的文档修正）

- 确认正式工具实际 resolved-ref 包含候选渲染改动，并用正式脚本全量生成/--check；不能只看 ref:main 或 PR 状态。
- 推送后单独核对远端 head 和 autofix 不再次恢复旧格式。本轮未推送，也未重新确认远端 CI。
- 组件实现风险、全部 Demo 交互、设备/Figma/Golden 属于独立工作，本轮没有把它们说成已解决。

证据目录：/tmp/tdesign-doc-full-semantic-20261009/。旧 reasonableness-repair.md 与 all-presentation.md 作为前阶段记录，当前结论以本文及 current-semantic-ledger.json 为准。
