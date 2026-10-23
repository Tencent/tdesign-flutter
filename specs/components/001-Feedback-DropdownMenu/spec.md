# DropdownMenu 设计说明

<a id="record-001-anchored-overlay"></a>
<a id="record-011-official-demos"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

触发栏与浮层在滚动、变换及快速切换时容易脱离或遗留资源。

下拉菜单的触发栏、面板和遮罩需要在滚动、嵌套 Navigator、面板切换和动态内容高度变化时保持同一锚点关系。原实现的切换和自动定位状态较简单，容易出现面板跳变、方向抖动、旧面板关闭回调误触发、浮层脱离触发栏或关闭 Future 未完成等问题。

DropdownMenu 已具备锚点、普通滚动跟随和自动方向能力，但边界拉伸滤镜下仍可复现菜单与面板分离；Example 页面壳、多选展开态和组件默认视觉也与 Figma `24386:5279` 存在差异。设计稿同时记录了“选中项 icon 位置不一致”和“展开后滚动导致菜单与面板分离”两个问题。

- “单选选中后文字仍为黑色”在当前 `origin/develop@b8a4bec7d` 无法复现：组件默认链已令选中文字与 24dp 勾选图标共同使用品牌主色。本轮补充组件与公开 Demo 的直接颜色断言，防止后续只保留图标颜色。
- “分栏禁用项应为 `#EEEEEE`”可复现，且根因位于组件默认值：禁用项错误地由禁用文字色叠加 12% 透明度推导背景。本轮改为语义 Token `bgColorComponentDisabled`；Demo 不传颜色、不承担遮盖。
- 本轮没有新增、删除或修改公开 API，属于组件默认视觉修复，不是 breaking change。

## 范围与非目标

### 目标

- 稳定维护触发栏、面板和遮罩之间的锚定关系。
- 切换菜单项时保持一个连续、可预测的面板表面。
- 支持 above、below 和 auto placement，并在内容高度或可用空间变化时重新计算。
- 正确处理滚动、键盘、安全区、根/嵌套 Overlay、焦点、返回键和 dispose。
- 在系统关闭动画时保持可访问的交互行为。

- 补齐官方单选、1/2/3 列多选和禁用 Demo。
- 公开 Demo 只保留小程序页面实际展示的“组件类型”和“组件状态”。
- 使用紧凑页面壳，并按 Figma 展示 15 个三列选项及 348px 展开面板。
- 对齐触发项、单选项和多选项的字体、图标、间距、分隔线与状态色。
- 复核锚定滚动、状态所有权、Theme 与 Controller，不为设计对齐新增公开 API。
- 自定义面板、向上展开、scrollable 和 ThemeData 能力保留在组件 API 与聚焦测试中，不作为公开 Demo 矩阵。

### 涉及

- tdesign-component/lib/src/components/dropdown_menu/t_dropdown_menu.dart
- tdesign-component/test/components/dropdown_menu/t_dropdown_menu_test.dart
- 面板切换动画、Overlay 生命周期、自动定位、滚动监听、焦点和指针事件。

- DropdownMenu 组件默认样式、Example 页、组件与 Example 测试、生成代码片段和 Golden。
- DropdownMenu Spec、站点说明、回归登记与测试字体冲突。

### 不涉及

- 不新增独立的业务筛选状态管理。
- 不改变 TDropdownMenuItem、TDropdownMenuController 的既有公共使用方式。
- 不改变组件主题字段的语义。

- 其他组件的浮层实现。
- 站点组件 README 的手工修改。

- 不删除 Flutter 已有组件能力；动画时长允许未指定以正确继承主题，兼容性见 plan.md。
- 不新增与现有 `TDropdownThemeData` 重复的逐实例样式参数。
- 不把 Figma 组件属性机械映射为 Flutter API。

- 其他组件或底层 Overlay。

## 最终方案与行为契约

### 锚定与 Overlay

- 菜单打开后，触发栏、面板和遮罩随同一祖先滚动容器移动。
- 支持嵌套 Overlay 和 root Overlay。
- 触发栏离开视口后，浮层应移除或关闭，不遗留脱离锚点的面板。
- 同一 Navigator 下同时只保留一个活动菜单。

### Placement

- below 始终从触发栏下方展开，above 始终从上方展开。
- auto 根据面板实际高度、键盘和安全区后的上下可用空间选择方向。
- 自动方向在临界空间附近使用滞后策略，避免滚动或重建造成来回抖动。
- 面板高度或活动面板内容变化后，自动方向可以重新测量。
- 触发项箭头方向必须与最终展开方向一致。

### 切换与关闭

- 同一菜单切换项时，旧面板和新面板之间保持连续切换，不出现空白闪烁。
- 快速连续切换最终只保留最后一个活动面板。
- 被中断的打开、切换和关闭操作，其返回的 Future 都必须完成。
- 切换过程中不应错误触发旧索引的关闭回调。
- 非 dismissible 遮罩下，点击或拖动允许交互的一侧不应意外关闭菜单。

### 交互与生命周期

- 外部点击、Escape 和系统返回关闭菜单，但不弹出当前页面。
- 触发项和面板焦点、语义状态在打开/关闭后正确更新和恢复。
- 动态移除或禁用当前打开项时，菜单安全关闭。
- 外部 Controller 被替换后，旧 Overlay 被清理，新 Controller 继续可用。
- dispose 时移除 Overlay、监听器和动画资源，不触发错误回调。
- MediaQuery.disableAnimations 为真时，动画时长为零。

- 单选 Demo 按官方顺序展示“全部产品”和“默认排序”，产品选项包含一个禁用项。
- 多选 Demo 在同一个菜单栏中分别传入 `columns: 1/2/3`；三列展开态展示 12 个普通项、3 个禁用项和 348px 面板，不人为设置 280px 上限。
- 状态组的两个禁用 trigger 点击后都不展开。
- 公开发布页与 Golden 排除内部调试区块；Debug 默认展示策略按 Demo 工程 Spec 执行。
- 默认触发栏高 48px，图文间距 4px，箭头读取 size7，默认 20dp 图标容器；激活文字使用 `fontMarkMedium`，其他文字使用 `fontBodyMedium`。
- 单选项高 56px、水平内边距 16px、文字使用 `fontBodyLarge`、底部分隔线 0.5px；选中文字与 24px TDesign check 均使用品牌主色。
- 多选项高 40px、圆角与颜色取现有语义 Token；禁用背景默认使用 `bgColorComponentDisabled`（默认浅色值 `#EEEEEE`）；水平内边距 16px、横纵间距 12px；内容区为左/上/右/下 `16/12/16/16`。
- 页面滚动时，菜单栏、面板与遮罩作为同一锚定单元移动；锚点离开视口时不残留分离面板。
- 范围内滚动、仿射滤镜边界拉伸及回弹时，面板和遮罩均严格贴合菜单边缘；保留小数逻辑像素坐标，不以 1px 容差或接缝遮盖代替正确定位。
- 仅祖先变换更新、菜单子树未重建时仍能跟随，面板点击保持有效；不关闭菜单、不禁用页面拉伸，不新增公开 API 或定位状态源。非仿射 Impeller shader 路径需真机单独验收，不属于仿射回归的已验证范围。

### 实现审查后的补充契约

- 多选每列选项等宽，列间距独立占用空间并读取 spacer12；RTL、非整数宽度和末行不足列数时保持网格对齐。
- 遮罩保留配置颜色自身的透明度，动画仅乘以展开进度；未配置时仍为黑色 60%，showOverlay=false 时完全透明。
- animationDuration=null 表示继承组件主题，再回退 200ms；显式 200ms、其他时长与零时长均优先于主题。系统 disableAnimations 始终优先。
- 多选已提交值变化时，仅同步尚未修改的草稿；脏草稿保留用户编辑，取消后重开使用最新已提交值。
- 保留 OverlayEntry + Follower、现有滚动/焦点/关闭时序与严格几何断言，不因修复布局或配置而更换锚定架构。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 保留 OverlayEntry 与锚定跟随架构，而不在 Demo 修正位置；实际几何与生命周期必须由组件负责。 |
| 保留的边界与代价 | 自动 placement 使用滞后与重新测量，接受实现复杂度以避免临界视口反复跳向。 |

### 设计演变中的关键理由

- Overlay 状态机复杂度增加，但换取快速切换和异步关闭操作的确定性。
- 自动 placement 依赖实际布局测量，因此采用 post-frame 重新计算。
- 监听祖先滚动通知需要过滤来源，避免无关滚动刷新浮层。
- 同一 Navigator 的活动菜单表是静态作用域，dispose 和异常路径必须清理。

- animationDuration 字段可空属于 breaking change：现有构造调用无需调整，直接读取该字段并当作 Duration 使用的代码需处理 null；若只需原始配置默认值可用 menu.animationDuration ?? const Duration(milliseconds: 200)，实际生效时长还受主题与系统减少动画设置影响。选中状态所有权、默认 200ms 和事件时序不变。
- Flutter 扩展能力不进入公开 Demo，避免被误解为官方一对一场景。

- 不整体迁移 Overlay。Flutter 3.32.0 的 RawMenuAnchor 在祖先滚动时关闭菜单，不符合现有滚动跟随契约；OverlayPortal 可改善继承与销毁归属，但不能直接替代当前仿射滤镜修正，也不能证明非仿射 shader 对齐。三处已复现根因分别在网格、颜色与默认值解析，不在 Overlay 生命周期。
- 多列改成 Expanded 选项之间插入 SizedBox，保留末行空列；不新增布局参数。
- 遮罩先解析完整 Color，再按原 alpha 乘动画进度；保留唯一黑色 60% 默认，不伪借无关 token。
- 补充 1/2/3 列、RTL、非整数宽度、末行、定制 spacer12、遮罩透明度与动画过程、实例/主题/内置时长及系统减少动画测试。仅更新多选展开态明暗 Golden。

依据：小程序 ae55fb050b7a9474c33752b45b71c741f37ed872 的 dropdown-item.wxml 使用 repeat(columns, 1fr)，LESS 独立配置 grid-gap；保留本 Spec 已冻结的 Figma 尺寸与交互契约。Flutter 的 [Follower 文档](https://api.flutter.dev/flutter/widgets/CompositedTransformFollower-class.html) 与 [OverlayPortal 文档](https://api.flutter.dev/flutter/widgets/OverlayPortal-class.html) 分别说明合成锚定及 Portal 的继承/生命周期收益；本轮不是把 Portal 视为不合理，而是不将其与三个局部修复捆绑迁移。

| 涉及 API | 状态源与优先级 | 处理 |
| --- | --- | --- |
| columns / spacer12 | columns 只控制列数，token 控制独立间距，Expanded 分配剩余宽度 | 保留 API，修复内部布局 |
| overlayColor / showOverlay | 完整颜色由 Theme 指定，showOverlay 只控制可见性，动画乘原 alpha | 保留 API，不增加 opacity 参数 |
| animationDuration | nullable 实例 > nullable Theme > 200ms；系统减少动画优先 | 修改实例字段空值契约，不增加第二默认源 |
| values / onConfirm | 外部已提交值，内部草稿，确认提交；脏草稿不被外部更新覆盖 | 保留行为，补充 dartdoc |

- 组件测试：全部 `test/components/dropdown_menu/`。
- Example 测试：官方入口矩阵、单选展开、三列 348px 展开态与禁用。
- 静态检查：Flutter 3.32.0 和 latest 严格 analyze。
- Golden：固定 Flutter 3.32.0 Linux 更新明暗整页、单选与三列展开态，并不带更新参数复跑。
- 人工验收：与 Figma `24386:5279` 和公开 Demo 的真实运行截图逐项对照。

- 未新增公共 API；单选值和多选值继续由 `value` / `values` 与回调管理，`controller` 只承担跨树开关命令，避免重复状态源。
- `placement`、overlay 配置、自定义 trigger/panel 仍有独立职责，本次不删除既有公开能力；默认视觉变化不构成公开 API 签名 breaking change。
- 已复现的边界拉伸仿射滤镜与跨 Overlay Follower 几何分离已修复，结果见末节；非仿射 Impeller shader 路径与真机像素表现仍未验证，不能由当前测试推断通过。
- 向上展开、custom trigger、scrollable 与局部 Theme 属于 Flutter 扩展能力，不作为小程序公开矩阵的一对一视觉场景；组件聚焦测试继续覆盖这些路径。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 官方入口可见，单选展开与两个禁用入口有 Example 测试。
- Figma 默认视觉、三列展开态和滚动锚定均有聚焦测试。
- DropdownMenu 生产源码 LCOV `LH/LF >= 95%`。
- Flutter 3.32.0 与 latest 的聚焦测试和严格 analyze 全部通过。
- 补充契约具备双版本回归和 Linux Golden；animationDuration 可空字段的迁移说明完整。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。


## 1.0.1 controller-binding

保持 Controller 现有后绑定覆盖行为及未绑定命令无副作用，不新增重复绑定异常；内部记录最后绑定的 owner，旧组件卸载或替换不解绑新 owner。
