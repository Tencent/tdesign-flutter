# 组件崩溃扫描复核与处置报告

## 结论

`component-crash-scan-full.md` 不能直接作为 429 个已确认缺陷使用。

原因有三类：

1. 扫描基于 2026-07-30 的源码，当前分支在 ImageViewer、Swiper、Popup、
   Theme 与 Overlay 等位置已经发生变化。
2. 报告使用 Flutter 3.38.9，当前仓库工具链为 Flutter 3.32.0；涉及 SDK
   assert、布局和路由内部实现的结论必须在项目支持矩阵中分别验证。
3. 报告把以下情况统一计入“风险”：真实组件缺陷、仅 release 缺少防御、
   调用方违反构造契约、Flutter 原生祖先要求、无界布局使用约束，以及需要
   产品决定的降级行为。这些情况不能使用同一种修复方式。

本轮逐项复核了报告中的 39 个高危项，并对可以保持合法输入行为不变的项目
直接修复。中低风险先处理了能由源码和测试明确证明的 Text、Popup、Toast
等根因；其余项目保留为后续专项，不按“429 个都是真实崩溃”处理。

最终验证：`flutter analyze` 无问题；完整 `flutter test` 共 2088 项全部通过。
新增 Popup/Progress 组合布局、ActionSheet/Dialog/Drawer 真实路由和
Progress M2/M3 隔离快照，并完成人工视觉核对。

## 39 个高危项复核

| 报告编号 | 当前结论 | 处置 |
|---|---|---|
| action_sheet-01 | 真实 | 已修复空列表 `chunks.first` 越界并补测试 |
| action_sheet-02 | 真实 | Popup 关闭动画期间统一 `IgnorePointer`，补重复点击不重复回调、不弹宿主页测试 |
| backtop-01 | 不应作为组件缺陷 | 外部 `ScrollController` 已被调用方 dispose 属所有权违约；组件无法可靠监听外部对象 dispose，补文档比吞异常合理 |
| button-01 | 真实 | `Icon(null)` 不再被 `!` 强解包，保留 Flutter 空白占位语义 |
| checkbox-01 | 真实但需布局决策 | 见“方案 A” |
| collapse-01 | 真实，已按显式高度契约修复 | 见“方案 B” |
| date_time_picker-01 | 真实 | controller 未 attach 时不读取 `selectedItem`；同步修复窄范围步进脱钩 |
| drawer-01 | 真实，已按页面级高度语义修复 | 见“方案 C” |
| dropdown_menu-01 | 真实的 release 防御缺口 | 运行期统一使用 `columns.clamp(1, 3)`，避免零/负步长死循环 |
| fab-01、fab-02 | 真实 | 所有位置更新统一走安全 clamp，反向区间退化到起点 |
| image-01 | 真实 | `src`、`imageFile` 同为空时稳定显示 placeholder |
| image_viewer-01～03 | 已过期 | 当前入口已对空 images、越界 index、labels 长度做运行期校验 |
| input-01 | 真实 | 多行默认 `minLines` 不再超过较小的 `maxLines` |
| loading-01 | 真实 | 使用 `Overlay.maybeOf`，插入成功后才设置全局 showing 状态，失败不污染后续调用 |
| notice_bar-01 | 真实 | 非有限/非正 speed 回退默认速度，并补 controller attach 守卫 |
| picker-01、picker-02 | 真实 | 联动受控值回写后重建依赖列，并对旧下标增加范围防御 |
| popover-01 | 真实的尺寸契约缺口，已收敛 | 自定义 Widget 保持显式尺寸契约，文本与自定义内容统一进入同一定位管线；见“方案 D” |
| popover-02 | 真实 | anchor 必须 mounted、attached、hasSize 且为 RenderBox 后才读取坐标 |
| popup-01 | 真实但影响所有 Overlay 尺寸 | 见“方案 E” |
| progress-01 | 机制真实，默认宽度无唯一答案 | 见“方案 F” |
| radio-01 | 真实但需布局决策 | 与 Checkbox 合并到“方案 A” |
| rate-01 | 真实的 release 防御缺口 | count/value 在内部归一化后再参与循环、clamp 与文案索引 |
| search-01 | 真实，已明确 `autoHeight` 语义并修复 | 见“方案 G” |
| sidebar-01 | 真实 | GlobalKey 改按条目下标唯一分配，不再使用可重复业务 value |
| slider-01、slider-02 | 真实的 release 防御缺口 | 刻度仅在 `divisions` 为正数时构建，移除可空强解包 |
| stepper-01 | 真实的 release 防御缺口 | min/max 先归一化，所有按钮状态、键盘类型和 clamp 使用同一边界 |
| swipe_cell-07 | 机制真实，但报告把 OOM 后果写成确定结论过强 | 见“方案 H” |
| swiper-01～03 | 已过期 | 当前代码已运行期拒绝非正 itemCount/空 children，并校验正 autoplayInterval；已按缓存 count 同步 controller |
| tabbar-01 | 真实 | 空 popup items 直接渲染空态，不再 `List.generate(-1)` |
| table-01 | 真实，已按列宽总和策略修复 | 见“方案 I” |
| tabs-01 | 真实 | 与 `_tabKeys.length` 比较，支持同一 List 实例原地增删 |
| toast-01 | 真实 | 同 toastId 使用替换语义，先完整回收旧 Timer、OverlayEntry 和遮罩 |

## 本轮额外确认并直接修复的中低风险

- `date_time_picker-02`：步进对齐点落在 max 之外时回退 min。
- `popup-02`：关闭 handle 时使用 `route.isCurrent` 判断；业务页面位于 Popup
  上方时移除 Popup route，不再 pop 业务页面。
- `popup-08`：不再在每个动画帧创建未 dispose 的 `CurvedAnimation`。
- `toast-04`：无 Overlay 时安全返回，不做空值强解包。
- `toast-05`：OverlayEntry 在 remove 后 dispose。
- `text-01`：GlobalKey 只绑定外层 TText，不再同时下发到内部 Text。
- `text-02`：网络字体回退路径保留 `textSpan`，不再把富文本变为空内容。
- `text-06`：调用方未显式设置缩放时恢复继承 MediaQuery 的无障碍字号。

## 方案处置

### 方案 A：Checkbox / Radio 的无界宽度（已确认并修复）

已使用 `LayoutBuilder` 做双路径：

- 有界宽度保持现有 `Expanded`、ellipsis 和整行点击区域，避免现有视觉变化。
- 无界宽度不再创建 flex child，使用 `MainAxisSize.min` 按内容自然收缩。

新增测试分别锁定无界宽度可布局，以及有界宽度仍填满父级；原有 Card、左右
内容方向和 Group 布局测试继续通过。不能全局直接把 `Expanded` 改成
`Flexible`，否则有界页面的分配规则也会改变。

### 方案 B：Collapse body 生命周期（崩溃项已修复）

`bodyHeight` 与懒加载解决的是两个不同问题：

1. 增加可选 `bodyHeight`，为 ListView 等滚动 body 提供明确的视口高度；
   这可以直接解决无界高度，但不会减少折叠态的构建成本。
2. 增加可选 `lazyLoad`。启用后在首次展开前不挂载 body；首次展开后继续保留
   body，以保留输入框、滚动位置和业务 State。若还需要“每次折叠都销毁”，应
   另设 `maintainState`，不能与首次懒加载混为一个开关。

为兼容现有生命周期，`lazyLoad` 应默认 false。仅增加 `bodyHeight` 不能替代
懒加载，因为当前 `AnimatedCrossFade` 会同时维护两个 child。

本轮已增加 `bodyHeight`，其高度包含内容内边距，并以 ListView 回归测试锁定
有界视口。`lazyLoad` 属于性能和生命周期能力，没有明确产品需求时不随崩溃
修复一起引入；这是当前唯一仍需产品确认的增强项，不影响崩溃修复完成度。

### 方案 C：Drawer 高度（已修复）

Drawer 的产品语义应是页面级 100% 可用高度，不应在无界父级下退化成内容
高度。正常 Scaffold/Popup 路径使用父级给出的最大高度；父级高度无界时使用
`MediaQuery` 的页面视口高度兜底。长菜单仍由 Drawer 内部滚动，不跟随外层
滚动。SafeArea 继续由 Popup 路由统一负责，DrawerWidget 不重复扣除安全区或
键盘 `viewInsets`。

### 方案 D：Popover 自定义内容尺寸（已修复）

保留自定义 Widget 的显式 width/height 契约，不增加首帧 `Size.zero`、第二帧
纠正或 `contentSizeResolver` 双轨。文本内容由 TextPainter 在首帧定位前测量；
自定义内容由实例或组件主题提供确定尺寸。两种尺寸来源最终都归一为包含
padding 的外框 Size，12 个方向、箭头和容器布局共用同一定位管线。

`TPopoverThemeData.maxWidth` 已接管文本最大宽度，定位代码不再直接写死 300；
组件更新后也会重新执行自定义内容尺寸契约校验。

### 方案 E：Popup 默认最大高度

推荐为 PopupShell 增加“可用视口最大高度”约束，但不默认包
`SingleChildScrollView`。滚动所有权仍由内容组件负责，避免 ActionSheet、
Dialog、Picker 出现嵌套滚动。Popup、ActionSheet、Dialog、Drawer 已补整组
真实路由快照。

TPopup 不是 Material BottomSheet，不接入 M3 BottomSheet 高度。尺寸链已改为：

1. 实例 `width` / `height`。
2. `TPopupThemeData.edgeHeight` / `drawerWidth` / `centerSize`。
3. TDesign 默认尺寸 240 / 280。
4. 可用视口安全裁剪。

视口裁剪只限制过大的最终尺寸，不覆盖实例或主题默认值。Flutter M3
BottomSheetTheme 的约束只对原生 BottomSheet 生效，不能作为 TPopup 的候选
主题。

### 方案 F：Progress 无界宽度

不硬编码 200px。`TProgressThemeData` 已增加 `fallbackLinearWidth`：线性和
按钮进度条在横向无界时优先使用该值，未配置时使用 MediaQuery 视口宽度；
有界场景继续完全服从父级宽度。

`TProgressThemeData` 已控制粗细、颜色、轨道色、圆角、圆形尺寸、标签和动画；
Material `ProgressIndicatorThemeData` 不定义线性进度条宽度，因此无界宽度
不依赖 M3 默认值。

不确定态不再创建 Material `LinearProgressIndicator` /
`CircularProgressIndicator`，改用 TDesign 自绘轨道、移动进度段和旋转圆弧。
循环时长、线性进度段比例、圆弧比例均由 `TProgressThemeData` 控制，并已加入
Material 2 / Material 3 并排快照，避免 M3 默认几何污染。

### 方案 G：Search `autoHeight`（已修复）

推荐把 `autoHeight` 定义为“填满有界父级”：有界时使用父级最大高度，无界时
回退默认 56。这样既保留当前在有界页面中的填充语义，也不会把
`double.infinity` 传入无界布局。“内容自适应”是另一种能力，不应复用同一
参数。

### 方案 H：SwipeCell `closeOnScroll`

`closeOnScroll` 表示：SwipeCell 已滑开操作区时，只要祖先滚动容器开始滚动，
就自动关闭操作区。

- true：滚动列表时收起已展开项，离屏 item 可以正常回收，适合常规列表。
- false：列表滚动后仍保持展开状态；当前组件硬编码为 false。

已确认无需兼容旧行为：公开 `closeOnScroll`，默认 true，并透传给底层
Slidable；调用方仍可通过实例参数显式设为 false。

### 方案 I：Table 无界宽度（已修复）

无界场景采用“按列宽总和自然展开”：计算左/中/右列的声明宽度总和，不使用
`IntrinsicWidth` 扫描全部大表数据。有界场景继续填满父级。当前所有
`TTableColumn.width` 均为显式非空值（默认 120），多选模式额外计入 48 的选择
列宽；无界场景不存在扫描行内容或临时兜底宽度。

## 不建议采用的统一修复方式

- 不为所有负数、NaN、Infinity 静默 clamp；业务数据、布局参数和设计 Token
  的错误语义不同。
- 不为缺 Material、MediaQuery、Directionality、Localizations 的所有组件
  私自创建祖先；这会产生与 Flutter 原生组件不同的上下文。
- 不给无界组件统一写死 200/300 等尺寸。
- 不用 try/catch 吞掉已 dispose 的外部 controller；应遵守所有权契约。
