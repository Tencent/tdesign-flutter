# 组件 Spec

[返回总规范](../README.md) · [工程 Spec](../engineering/README.md)

本目录收录 53 个组件目录。组件名保留规范大小写，目录采用 `<编号>-<组件分类>-<组件名>`；索引按组件英文名 A–Z 排序。

同组件只维护一套契约、方案、任务与验收主文档；共享契约通过交叉引用复用，不复制正文。编号不是契约优先级，也不代表验收状态。

| 组件入口 | 类别 | 相关契约 / 事项 |
| --- | --- | --- |
| [ActionSheet](009-Feedback-ActionSheet/spec.md) | 反馈 / Feedback | [009 · ActionSheet 官方基线对齐](009-Feedback-ActionSheet/spec.md) |
| [Avatar](034-DataDisplay-Avatar/spec.md) | 数据展示 / DataDisplay | [034 · Avatar 设计对齐](034-DataDisplay-Avatar/spec.md) |
| [BackTop](028-Navigation-BackTop/spec.md) | 导航 / Navigation | [028 · BackTop 视觉契约与 API 收敛](028-Navigation-BackTop/spec.md) |
| [Badge](023-DataDisplay-Badge/spec.md) | 数据展示 / DataDisplay | [023 · Badge 设计稿对齐与 API 收敛](023-DataDisplay-Badge/spec.md) |
| [Button](009-Basic-Button/spec.md) | 基础 / Basic | [009 · Button 尺寸、形状与原生交互契约对齐](009-Basic-Button/spec.md#record-009-contract-alignment)<br>[037 · Button 禁用态与浅色描边对齐](009-Basic-Button/spec.md#record-037-disabled-theme-alignment)<br>[082 · 文案默认值](009-Basic-Button/spec.md#source-082) |
| [Calendar](023-Input-Calendar/spec.md) | 输入 / Input | [023 · Calendar 平铺面板与 Figma Demo 对齐](023-Input-Calendar/spec.md) |
| [Cascader](024-Input-Cascader/spec.md) | 输入 / Input | [024 · Cascader 公开 Demo 对齐](024-Input-Cascader/spec.md) |
| [Cell](084-DataDisplay-Cell/spec.md) | 数据展示 / DataDisplay | [084 · CellGroup 高度约束与滚动边界](084-DataDisplay-Cell/spec.md) |
| [Checkbox](015-Input-Checkbox/spec.md) | 输入 / Input | [015 · Checkbox Demo 与卡片角标对齐](015-Input-Checkbox/spec.md#record-015-demo-card-alignment)<br>[016 · Checkbox 样式尺寸 token 化](015-Input-Checkbox/spec.md#record-016-theme-token-sizes)<br>[041 · Checkbox 设计细节对齐](015-Input-Checkbox/spec.md#record-041-design-details) |
| [Collapse](030-DataDisplay-Collapse/spec.md) | 数据展示 / DataDisplay | [030 · Collapse 设计对齐](030-DataDisplay-Collapse/spec.md) |
| [DateTimePicker](025-Input-DateTimePicker/spec.md) | 输入 / Input | [025 · DateTimePicker 平铺滚轮与 Figma Demo 对齐](025-Input-DateTimePicker/spec.md#record-025-demo-alignment)<br>[056 · DateTimePicker 展示更新与滚动状态](025-Input-DateTimePicker/spec.md#record-056-label-updates) |
| [Dialog](010-Feedback-Dialog/spec.md) | 反馈 / Feedback | [010 · Dialog 官方基线对齐](010-Feedback-Dialog/spec.md)<br>[083 · Dialog 文字槽恢复与共享 Theme](010-Feedback-Dialog/spec.md#record-083-text-slot-restoration) |
| [Divider](013-Basic-Divider/spec.md) | 基础 / Basic | [013 · Divider 小程序视觉契约对齐](013-Basic-Divider/spec.md#record-013-miniprogram-alignment)<br>[038 · Divider 垂直间距对齐](013-Basic-Divider/spec.md#record-038-vertical-spacing) |
| [Drawer](029-Navigation-Drawer/spec.md) | 导航 / Navigation | [029 · Drawer 设计与交互契约收敛](029-Navigation-Drawer/spec.md) |
| [DropdownMenu](001-Feedback-DropdownMenu/spec.md) | 反馈 / Feedback | [001 · TDropdownMenu：稳定锚定浮层与菜单切换动画](001-Feedback-DropdownMenu/spec.md#record-001-anchored-overlay)<br>[011 · DropdownMenu Figma、Demo 与组件契约对齐](001-Feedback-DropdownMenu/spec.md#record-011-official-demos) |
| [Empty](031-DataDisplay-Empty/spec.md) | 数据展示 / DataDisplay | [031 · Empty 设计对齐与 API 收敛](031-DataDisplay-Empty/spec.md) |
| [Fab](010-Basic-Fab/spec.md) | 基础 / Basic | [010 · TFab 视觉与拖拽契约对齐](010-Basic-Fab/spec.md) |
| [Footer](032-DataDisplay-Footer/spec.md) | 数据展示 / DataDisplay | [032 · Footer 设计对齐与 API 收敛](032-DataDisplay-Footer/spec.md) |
| [Form](008-Input-Form/spec.md) | 输入 / Input | [008 · Form 与 Input 职责及 API 对齐](008-Input-Form/spec.md#record-008-input-contract-alignment)<br>[039 · Form 受控状态、主题与 Demo 设计细节对齐](008-Input-Form/spec.md#record-039-design-details)<br>[039 · Input 与 Form 排版对齐](039-Input-Input/spec.md) |
| [Image](033-DataDisplay-Image/spec.md) | 数据展示 / DataDisplay | [033 · Image 设计对齐与 API 收敛](033-DataDisplay-Image/spec.md) |
| [ImageViewer](035-DataDisplay-ImageViewer/spec.md) | 数据展示 / DataDisplay | [035 · ImageViewer 设计与交互对齐](035-DataDisplay-ImageViewer/spec.md) |
| [Indexes](030-Navigation-Indexes/spec.md) | 导航 / Navigation | [030 · Indexes 索引设计与契约收敛](030-Navigation-Indexes/spec.md) |
| [Input](039-Input-Input/spec.md) | 输入 / Input | [008 · Form 与 Input 职责及 API 对齐](008-Input-Form/spec.md#record-008-input-contract-alignment)<br>[039 · Input 与 Form 排版对齐](039-Input-Input/spec.md) |
| [Link](012-Basic-Link/spec.md) | 基础 / Basic | [012 · Link 小程序契约对齐](012-Basic-Link/spec.md) |
| [Loading](007-Feedback-Loading/spec.md) | 反馈 / Feedback | [007 · Loading：默认值、尺寸、Demo 与文档调整](007-Feedback-Loading/spec.md) |
| [Message](007-Feedback-Message/spec.md) | 反馈 / Feedback | [007 · Message 组件跨端 Demo 契约对齐](007-Feedback-Message/spec.md) |
| [NavBar](031-Navigation-NavBar/spec.md) | 导航 / Navigation | [031 · NavBar 设计与公开契约收敛](031-Navigation-NavBar/spec.md)<br>[082 · 标题默认值](031-Navigation-NavBar/spec.md#source-082) |
| [NoticeBar](005-Feedback-NoticeBar/spec.md) | 反馈 / Feedback | [005 · TNoticeBar Review 修复与文档补全](005-Feedback-NoticeBar/spec.md) |
| [Picker](026-Input-Picker/spec.md) | 输入 / Input | [026 · Picker 平铺滚轮与 Figma Demo 对齐](026-Input-Picker/spec.md#record-026-demo-alignment)<br>[043 · Picker 弹层布局契约](026-Input-Picker/spec.md#record-043-popup-layout) |
| [Popover](003-Feedback-Popover/spec.md) | 反馈 / Feedback | [003 · TPopover：交互、主题、尺寸与浮层边界契约补强](003-Feedback-Popover/spec.md#record-003-contract-hardening)<br>[015 · Tag 与 Popover 视觉选择器实例所有权收敛](003-Feedback-Popover/spec.md#record-015-color-scheme-instance-ownership)<br>[022 · TPopover 公开 API 收敛](003-Feedback-Popover/spec.md#record-022-public-api-convergence)<br>[027 · TPopover 双层控制模式与主题插值](003-Feedback-Popover/spec.md#record-027-controller-theme-lerp) |
| [Popup](018-Feedback-Popup/spec.md) | 反馈 / Feedback | [018 · Popup：收敛蒙层散参到 `TPopupOverlayConfig`](018-Feedback-Popup/spec.md#record-018-overlay-config)<br>[019 · Popup left/right 圆角对齐与动画时长评估](018-Feedback-Popup/spec.md#record-019-radius-duration-alignment)<br>[020 · Popup 公开 Demo 对齐](018-Feedback-Popup/spec.md#record-020-demo-alignment)<br>[021 · Popup 内容插槽收敛](018-Feedback-Popup/spec.md#record-021-slot-convergence) |
| [Progress](036-DataDisplay-Progress/spec.md) | 数据展示 / DataDisplay | [036 · Progress 设计对齐](036-DataDisplay-Progress/spec.md) |
| [PullDownRefresh](008-Feedback-PullDownRefresh/spec.md) | 反馈 / Feedback | [008 · PullDownRefresh：以最小化、Flutter 模式 API 重新设计（对齐官方行为）](008-Feedback-PullDownRefresh/spec.md) |
| [Radio](015-Input-Radio/spec.md) | 输入 / Input | [015 · Radio Demo 小程序视觉对齐](015-Input-Radio/spec.md#record-015-demo-alignment)<br>[042 · Radio 单一状态源与视觉形态重构](015-Input-Radio/spec.md#record-042-group-api-refactor) |
| [Rate](017-Input-Rate/spec.md) | 输入 / Input | [017 · Rate 契约收敛与边界修复](017-Input-Rate/spec.md) |
| [Result](037-DataDisplay-Result/spec.md) | 数据展示 / DataDisplay | [037 · Result 设计对齐](037-DataDisplay-Result/spec.md) |
| [Search](011-Input-Search/spec.md) | 输入 / Input | [011 · Search 搜索框契约对齐](011-Input-Search/spec.md) |
| [SideBar](032-Navigation-SideBar/spec.md) | 导航 / Navigation | [032 · SideBar 设计与公开契约收敛](032-Navigation-SideBar/spec.md) |
| [Skeleton](038-DataDisplay-Skeleton/spec.md) | 数据展示 / DataDisplay | [038 · Skeleton 设计对齐](038-DataDisplay-Skeleton/spec.md) |
| [Slider](027-Input-Slider/spec.md) | 输入 / Input | [027 · Slider 公开 Demo 对齐](027-Input-Slider/spec.md) |
| [Stepper](028-Input-Stepper/spec.md) | 输入 / Input | [028 · Stepper 公开 Demo 对齐](028-Input-Stepper/spec.md) |
| [Steps](030-Navigation-Steps/spec.md) | 导航 / Navigation | [030 · Steps 设计与公开契约收敛](030-Navigation-Steps/spec.md) |
| [SwipeCell](005-Feedback-SwipeCell/spec.md) | 反馈 / Feedback | [005 · TSwipeCell 组件 Review 修复](005-Feedback-SwipeCell/spec.md#record-005-theme-review-fixes)<br>[007 · TSwipeCell 官方对齐修复（跨端 Review 结论落地）](005-Feedback-SwipeCell/spec.md#record-007-official-alignment) |
| [Swiper](039-DataDisplay-Swiper/spec.md) | 数据展示 / DataDisplay | [039 · Swiper 设计与交互对齐](039-DataDisplay-Swiper/spec.md) |
| [Switch](014-Input-Switch/spec.md) | 输入 / Input | [014 · TSwitch 加载状态 API 收敛](014-Input-Switch/spec.md) |
| [TabBar](028-Navigation-TabBar/spec.md) | 导航 / Navigation | [028 · TabBar 设计稿对齐与 API 收敛](028-Navigation-TabBar/spec.md) |
| [Table](044-DataDisplay-Table/spec.md) | 数据展示 / DataDisplay | [044 · Table 设计与交互对齐](044-DataDisplay-Table/spec.md) |
| [Tabs](024-Navigation-Tabs/spec.md) | 导航 / Navigation | [024 · Tabs 视觉契约与 API 收敛](024-Navigation-Tabs/spec.md#record-024-contract-alignment)<br>[040 · Tabs 尺寸与内容区样式对齐](024-Navigation-Tabs/spec.md#record-040-size-content-alignment) |
| [Tag](003-Feedback-Popover/spec.md) | 数据展示 / DataDisplay | [015 · Tag 与 Popover 视觉选择器实例所有权收敛](003-Feedback-Popover/spec.md#record-015-color-scheme-instance-ownership) |
| [Text](011-Basic-Text/spec.md) | 基础 / Basic | [011 · TText Flutter 原生契约重构](011-Basic-Text/spec.md) |
| [TimeCounter](040-DataDisplay-TimeCounter/spec.md) | 数据展示 / DataDisplay | [040 · TimeCounter 设计与交互对齐](040-DataDisplay-TimeCounter/spec.md) |
| [Toast](004-Feedback-Toast/spec.md) | 反馈 / Feedback | [004 · Toast：默认背景色与默认时长对齐 TDesign Mobile](004-Feedback-Toast/spec.md#record-004-contract-alignment)<br>[006 · Toast：新增可见遮罩（showOverlay / TOverlayConfig）与展示位置（placement）对齐 TDesign Mobile](004-Feedback-Toast/spec.md#record-006-overlay-config-and-placement)<br>[054 · Toast 时长、位置与背景交互契约](004-Feedback-Toast/spec.md#record-054-overlay-pointer) |
| [TreeSelect](033-Input-TreeSelect/spec.md) | 输入 / Input | [033 · TreeSelect 设计与公开 Demo 对齐](033-Input-TreeSelect/spec.md) |
| [Upload](012-Input-Upload/spec.md) | 输入 / Input | [012 · Upload 小程序视觉与布局契约对齐](012-Input-Upload/spec.md#record-012-contract-alignment)<br>[053 · Upload 异步选择状态修复](012-Input-Upload/spec.md#record-053-async-picker-state) |

Tag 与 Popover 的共享契约保留在 Popover 入口下，通过两处索引关联，避免复制同一份记录。Form 与 Input 等跨组件契约同理。
