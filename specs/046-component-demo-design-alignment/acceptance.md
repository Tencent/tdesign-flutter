# 验收记录

## 基线

- Git：`origin/develop@47e070a70bafbb99ea5722cf59c03ab5bf61ae3f`
- `tdesign-component/` 受影响已跟踪 binary diff 与未跟踪新基线联合指纹：`ce8c36ea5fb38935334f6e624f51a6788cbdc4c6da721679536af2d31db9f9bb`
- Golden：Linux amd64、Flutter 3.32.0、仓库固定字体与视口
- Latest：Flutter 3.47.0 clean snapshot
- 设计比较：统一从首个公开标题裁切，省略状态栏、Figma 头部与底部测试区域

## 自动化结果

| 门禁 | 结果 |
| --- | --- |
| Flutter 3.32.0 component 全量回归 | 通过 |
| Flutter 3.32.0 Example 全量回归 | 262/262 通过 |
| Flutter 3.47.0 component 全量回归 | 通过 |
| Flutter 3.47.0 Example 全量回归 | 262/262 通过 |
| Flutter 3.32.0 / latest 严格 analyze | 0 issues |
| 示例代码生成与 `--check` | 通过 |
| Demo 结构审计 | 60 个入口、372 个 ExampleItem、0 orphan |
| Linux Flutter 3.32.0 全量 Golden | 更新后移除更新参数，全部视觉套件通过 |
| Button 聚焦回归 | Demo 功能测试 2/2；Linux 3.32.0 Golden 4/4，更新后无更新复跑通过 |
| Progress 生产源码覆盖率 | 524/527，99.43% |
| Checkbox 生产源码覆盖率 | 393/410，95.85% |
| Swiper 生产源码覆盖率 | 478/495，96.57% |
| Popover 生产源码覆盖率 | 630/642，98.13% |

## Golden 差异归因

- 28 份设计稿证据已升级为 Figma 原图、develop 配准差异、current 配准差异、current 配准渲染、current 原图五栏；配准列只平移分段、不缩放组件，原图列保留真实页面流，避免把字体行盒造成的累计偏移误判成组件像素差异或被配准算法掩盖。
- Button 旧对比图按分组手工配准 `+6/+8/+10/+12px`，会掩盖页面流和实例位置差异，不能作为最终通过依据；后续比较统一以首个标题的实际像素边界为单一锚点，并同时报告组件外框、颜色及内容布局。
- Button“按钮形状”末项按设计稿使用铺满父容器的 0 圆角实例。Linux light/dark Golden 相对上一版均只改变 56 个像素，边界严格位于该 375×48 按钮四角；Figma 与修复后首末行蓝色范围均为 `[0,375)`、高度均为 48px。
- 最终提交包含 201 份逐文件三栏证据：179 个修改、12 个新增、10 个删除；
  `manifest.tsv` 无缺项、无像素完全相同却被提交为修改的基线，其中 103 个比较的
  最大 RGBA 通道差为 1。
- 首轮无更新参数比较共出现 119 张既有基线差异。
- 93 张仅为共享灰阶 Token 的单通道 1 级差异。
- 其余 26 张来自 Progress 最终设计重构，以及 `TCell.note` 自然宽度对 Calendar / SwipeCell 的预期布局影响。
- Cascader 的旧场景基线被按最终公开 Demo 契约删除，并新增最终场景基线；新增和删除项均保留在三栏证据与 manifest 中。
- 未发现无法归因的 Golden 漂移。

## 模拟器交互

- Progress 按钮实际点击后推进到 80%。
- Indexes 抽屉位于状态栏安全区下方，文字完整加载。
- DateTimePicker 默认值、选中行居中与弹层安全区正确。
- Swiper 控制按钮实际切页，缩放与淡化场景露出两侧卡片。
- Popover top-left / bottom-right 实际打开，气泡边缘对齐触发按钮，箭头保持约 12px 内边距。
- Popover 已打开时单击另一触发器，旧气泡关闭且新气泡在同一次点击中打开；单击当前触发器只关闭，拖动滚动不误判为外部点击。
- ImageViewer 可打开并返回关闭；拖拽和双指缩放由 25/25 指针级 Widget 测试覆盖，桌面自动化层未注入多点触控。

## 结论

当前源码不存在未归因的组件、Demo、Token 或 Golden 风险。公开 API 的 breaking 变化已在 Spec、dartdoc、生成 API 和测试中同步；本地证据满足创建 PR 条件，远端 CI 仍须以 PR 最终 head 为准。

## 2026-09-21 Button 二次像素复核

- [x] 识别旧分段配准会隐藏累计页面流差异，不再沿用该图作为 Button 通过证据。
- [x] 图文按钮相对设计稿宽出约 4px 的根因为组件默认使用 `spacer8`；移动端公共样式和设计稿均为 4px，组件默认值已改为语义 token `spacer4`。
- [x] 禁用态和尺寸示例的内部左边距被 `ExampleItem` 默认居中再次偏移，已在 Demo 层取消二次居中，首行恢复到 x=16。
- [x] Figma 的“加载中”按钮使用 24×24 图标槽；Demo 原先直接采用 `TLoading` 的 20px 默认尺寸，已在该自定义 icon 实例显式设为 24px，不改变 `TButton` 对任意自定义 Widget 的布局契约。
- [x] Linux Flutter 3.32.0 仅更新 Button Demo 与 Upload Demo 的明暗 4 份 Golden，随后无更新参数完整视觉回归全部通过；Upload 组件状态 Golden 2/2 未变化。
- [x] Flutter 3.32.0 Button 组件 123/123、Button/Upload Demo 结构与定位测试通过，组件与示例 `flutter analyze` 均为 0 告警。
- [x] Flutter 3.47.0 隔离副本中 Button + Upload 非 Golden 测试 152/152、Button Demo 定位测试及组件/示例 `flutter analyze` 全部通过。
- [x] 单锚点、不缩放、不分段平移的整页比较中，阈值为 RGB 最大通道差 `> 28` 时，develop 差异为 18.78%，当前为 14.88%；剩余红色主要包含跨渲染器字体栅格及由文字行盒造成的累计 2px 页面流差异，不能再通过分段平移隐藏。

## 2026-09-21 稳定交互状态 Golden 补齐

原始反馈清单实际包含 28 个组件；后续复核的 Message 作为第 29 个组件纳入同一矩阵。初始页 Golden 与交互后 Golden 分开登记，不以功能断言替代像素固定。

| 组件 | 稳定可见状态 | 真实触发 | Golden / 等价依据 |
| --- | --- | --- | --- |
| Button | 初始形态、禁用、加载、尺寸、主题 | 按钮点击 | 点击无新的稳定视觉状态，由页面 Golden + 功能测试覆盖 |
| Indexes | 打开、字母/数字/胶囊选中 | 点击入口与索引 | `indexes_*_opened_*` + `indexes_*_selected_*` |
| Navbar | 搜索输入、导航操作提示 | 输入、返回/关闭/首页/操作 | `navbar_search_entered_*` + toast Golden |
| SideBar | 不同类型的选中项 | 点击侧边项 | `sidebar_*_selected_item_*` |
| TabBar | 菜单打开、选中及提示 | 点击标签/更多菜单 | `tab_bar_*_opened_*` + `tab_bar_*_post_action_*` |
| Tabs | 切换后内容 | 点击选项卡 | `tabs_content_selected_*` |
| Cascader | 六类弹层、叶子选中并关闭后结果 | 点击入口、选择“南头街道” | `cascader_*_opened_*` + `cascader_vertical_selected_*` |
| CheckBox | 受控选中后页面 | 点击首个可用未选项 | `checkbox_selected_*` |
| DateTimePicker | 九类弹层、滚轮修改并确认后结果 | 拖动月份轮并点击确定 | `date_time_picker_*_opened_*` + `date_time_picker_month_confirmed_*` |
| Input | 输入并失焦后错误态 | 手机号输入 `123` 并失焦 | `input_invalid_phone_*` |
| Slider | 拖动后数值与滑块位置 | 真实水平拖动 | `slider_dragged_*` |
| Stepper | 加一后的受控值 | 点击“增加” | `stepper_incremented_*` |
| Textarea | 全部可编辑实例输入后 | 逐个真实输入并失焦 | `textarea_all_editable_post_action_*` |
| TreeSelect | 单选路径变更后 | 点击“云浮市” | `tree_select_changed_*` |
| Avatar / Badge / Empty / Footer / Image | 公开 Demo 静态状态 | 无会产生新稳定视觉的操作 | 各自页面 Golden；链接/操作回调由功能测试覆盖 |
| Collapse | 基础面板收起后 | 点击已展开标题 | `collapse_basic_closed_*` |
| ImageViewer | 打开、删除确认、双指缩放 | 点击入口/删除，两个真实 pointer 展开 | `image_viewer_actions_opened_*` + `image_viewer_delete_confirm_*` + `image_viewer_zoomed_*`；下拉关闭后与初始页等价 |
| Progress | 按钮进度自动推进至 80% | 点击开始并驱动计时 | `progress_completed_*` |
| Swiper | 下一页的图片与指示器 | 真实拖动 PageView | `swiper_next_page_*`；controls 使用同一切页渲染路径 |
| Table | 升序、横向滚动 | 点击表头、拖动横向内容 | `table_sorted_*` + `table_scrolled_*` |
| Tag | outline 可选标签选中 | 点击“未选中态” | `tag_selected_*` |
| TimeCounter | 可控时间跨秒后 | `pump` 精确推进 1 秒 | `time_counter_advanced_*` |
| DropdownMenu | 公开可展开菜单、单选提交并收起 | 点击入口、“最新产品” | `dropdown_menu_*_opened_*` + `dropdown_menu_single_selected_*`；多选选中绘制已在 opened Golden 中覆盖 |
| Popover | 12 方位、主题/类型、切换触发器 | 真实点击、从已打开触发器切换 | `popover_*_opened_*` + `popover_custom_option_post_action_*` |
| Message | 十类打开态 | 点击 Demo 按钮/函数调用 | `message_*_opened_*`；操作按钮本身不改变 Message 视觉，不重复快照 |

- [x] 新增 34 张 Flutter 3.32.0 Linux Golden：17 个操作后场景的 light / dark（Table 分为排序与滚动，ImageViewer 分为删除确认与缩放）。
- [x] Golden 均由真实 `tap` / `drag` / 双 pointer / 受控时间触发，未直接改写 Widget 内部状态。
- [x] 相同 Linux / Flutter 3.32.0 / 字体 / DPR / viewport 环境中，更新后移除 `--update-goldens` 复跑：未变的其他 14 个文件 110/110，最终 ImageViewer 8/8，当前集合合计 118/118 通过。
