---
title: 更新日志
spline: explain
toc: false
docClass: timeline
---


## 🌈 0.2.5 `2025-09-12` 
### 🐞 Bug Fixes
- `TDPopover`: 添加圆角属性自定义 @jflin19990707 ([#727](https://github.com/Tencent/tdesign-flutter/pull/727))
- `TDForm`: 增加表单自定义背景颜色属性，按钮部分可为空 @jflin19990707 ([#730](https://github.com/Tencent/tdesign-flutter/pull/730))
- `TDConfirmDialog`: 弹窗支持自定义宽度，按钮增加自定义样式属性 @jflin19990707 ([#724](https://github.com/Tencent/tdesign-flutter/pull/724))
- `TDPicker`: 支持初始化和后续动态加载适量数据，修复卡顿问题@123dw-bot([#728](https://github.com/Tencent/tdesign-flutter/pull/728))
-  `TDSideBar`增加自定义未选中颜色 @jflin19990707 ([#723](https://github.com/Tencent/tdesign-flutter/pull/723))
### 🚧 Others
- docs: 优化仓库大小 @RSS1102


## 🌈 0.2.4 `2025-08-14` 
### 🚀 Features
- `TDUpload`: 支持设置多图间距和对其方式 @cyjaysong ([#677](https://github.com/Tencent/tdesign-flutter/pull/677))
- `TDTreeSelect`: 新增自定义宽度和最大行数字段，修复第二级宽度固定，长文本溢出问题 @123dw-bot ([#694](https://github.com/Tencent/tdesign-flutter/pull/694))
- `TDDropdownMenu`: 增加TDDropdownItemController，允许外部重置和更改下拉选项 @Luozf12345 ([#697](https://github.com/Tencent/tdesign-flutter/pull/697))
- `TDStepper`:Stepper增加controller参数，可用于实时修改value @Luozf12345 ([#699](https://github.com/Tencent/tdesign-flutter/pull/699))

### 🐞 Bug Fixes
- `TDIndexes`: 修复自定义索引无法响应点击事件 @epoll-j ([#692](https://github.com/Tencent/tdesign-flutter/pull/692))
- `TDPopup`: 修复close方法触发两次bug @epoll-j ([#690](https://github.com/Tencent/tdesign-flutter/pull/690))
- `TDSideBar`:修复TDSideBar组件初始化后children无法更新的问题 @Luozf12345 ([#698](https://github.com/Tencent/tdesign-flutter/pull/698))

### 🚧 Others
- `其他`:恢复对flutter SDK 3.32版本的默认适配


## 🌈 0.2.3 `2025-07-09` 
### 🚀 Features
- `TDPicker`: 支持切换时优先保持级联的选项值 @epoll-j ([#666](https://github.com/Tencent/tdesign-flutter/pull/666))
- `TDTable`: 支持行默认选中 @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))
- `TDCalendar`: 增加自定义日期单元格功能 @epoll-j ([#667](https://github.com/Tencent/tdesign-flutter/pull/667))
- `TDForm`: 增加Form 表单组件 @shizhe2018 @SimonWuZY ([#620](https://github.com/Tencent/tdesign-flutter/pull/620))
- `TDTable`: TDTableCol属性配置分离，空数据配置分离 @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))
### 🐞 Bug Fixes
- `TDTable`: 解决表头未选中图标显示问题，禁用状态下全选选中状态问题 @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))
- `TDTable`: 表格空数据问题 @ccXxx1aoBai ([#671](https://github.com/Tencent/tdesign-flutter/pull/671))
- `TDDialog`: 弹窗遮挡键盘问题 @jflin19990707 ([#669](https://github.com/Tencent/tdesign-flutter/pull/669))
- `TDCollapse`: collapse demo页面名称修改 @jflin19990707 ([#670](https://github.com/Tencent/tdesign-flutter/pull/670))
- `TDDropdownMenu`: 嵌套路由场景 弹窗位置计算错误 @hcanyz ([#648](https://github.com/Tencent/tdesign-flutter/pull/648))

## 🌈 0.2.2 `2025-06-13`

### 🚀 Features

- `TDTable`: 支持表格行选择、自定义行高 @ccXxx1aoBai ([#594](https://github.com/Tencent/tdesign-flutter/pull/594))
- `TDTreeSelect`: 支持局部多选 @epoll-j ([#587](https://github.com/Tencent/tdesign-flutter/pull/587))
- `TDCell`: 支持自定义高度，底部分割线 @ccXxx1aoBai ([#611](https://github.com/Tencent/tdesign-flutter/pull/611))
- `TDNoticeBar`: 支持自定义文字行数 @ccXxx1aoBai ([#611](https://github.com/Tencent/tdesign-flutter/pull/611))
- `TDBottomTabBar`: TDButtonBottomTabBar 中的 onTap 支持重复点击 @epoll-j @RSS1102([#586](https://github.com/Tencent/tdesign-flutter/pull/586))
- `TDBottomTabBar`: 实现点击水波纹效果 @RSS1102 ([#626](https://github.com/Tencent/tdesign-flutter/pull/626))
- `TDAvatar` 增加自定义BoxFit参数 @shizhe2018 ([#633](https://github.com/Tencent/tdesign-flutter/pull/633))

### 🐞 Bug Fixes

- `TDDatePicker`: 修复时间选择器分钟级时间数据展示问题- 优化小时、分钟、秒的选择范围计算逻辑 @epoll-j ([#585](https://github.com/Tencent/tdesign-flutter/pull/585))
- `TDSearchBar`: 支持设置onTapOutside回调 @cyjaysong ([#608](https://github.com/Tencent/tdesign-flutter/pull/608))
- `TDDropdownMenu`:  支持修改选中icon颜色 @jflin19990707 ([#631](https://github.com/Tencent/tdesign-flutter/pull/631))
- `TDTabBar`: fix:TDBottomTabBarBasicType.iconText模式下，text icon 冲突问题 @jflin19990707 ([#628](https://github.com/Tencent/tdesign-flutter/pull/628))
- `TDEmpty`: 支持操作按钮自定义样式 @jflin19990707 ([#624](https://github.com/Tencent/tdesign-flutter/pull/624))
- `TDToast`: toast支持自定义文案 @jflin19990707 ([#625](https://github.com/Tencent/tdesign-flutter/pull/625))
- `TDPopup`: 修改_measureChildHeight方法用于修复child无法修改弹窗高度 @Jzow ([#591](https://github.com/Tencent/tdesign-flutter/pull/591))
- `TDCascader` 修改查询data数据为空状态处理 @shizhe2018 ([#635](https://github.com/Tencent/tdesign-flutter/pull/635))

### 🚧 Others

- [其他]适配flutter 3.32版本 @Luozf12345 ([#636](https://github.com/Tencent/tdesign-flutter/pull/636))



## 🌈 0.2.0 `2025-05-08`
### 🚀 Features
- `TDCellGroup`: 添加单元格组标题背景颜色`titleBackgroundColor`属性. @runoob-coder ([#539](https://github.com/Tencent/tdesign-flutter/pull/539))
- `TDLink`: link参数链接对象`LinkObj`替换为`MessageLink`，调整`TDLink`样式，新增点击回调； @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))
- `TDBottomTabBar`: 新增自定义标题支持到步骤条组件 @RSS1102 ([#576](https://github.com/Tencent/tdesign-flutter/pull/576))
- `TDSlider`: 添加滑块点击事件 `onTap` @RSS1102 ([#527](https://github.com/Tencent/tdesign-flutter/pull/527))
- `TDCascader`: 添加右上角"确定"按钮，支持选择任意选项 @Luozf12345
- `ImageViewer`: 支持单张图片删除 @ccXxx1aoBai ([#581](https://github.com/Tencent/tdesign-flutter/pull/581))
- `TDPopup`: 为Popup组件添加标题、左文本、右文本和关闭按钮自定义尺寸属性 @Jzow ([#582](https://github.com/Tencent/tdesign-flutter/pull/582))
- `TDBottomTabBarTabConfig`: 添加长按 tab 触发事件`onLongPress` @RSS1102 ([#580](https://github.com/Tencent/tdesign-flutter/pull/580))

### 🐞 Bug Fixes
- `TDFooter`: 修复页脚链接模式时内容溢出问题 @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))
- `TDUpload`: 修复文件大小限制错误 @epoll-j ([#544](https://github.com/Tencent/tdesign-flutter/pull/544))
- `TDImageViewer`: 增加Swiper组件属性透传，增加点击事件及部分样式属性，支持自定义按钮 @ccXxx1aoBai ([#561](https://github.com/Tencent/tdesign-flutter/pull/561))
- `TDSlider`: 修复是胶囊类型且有区间时，滑块无法拖动到边缘以及数值和刻度展示问题 @qfish ([#567](https://github.com/Tencent/tdesign-flutter/pull/567))
- `TDInput`: 修复非中文标签Input框宽度计算缺陷 @Jzow ([#564](https://github.com/Tencent/tdesign-flutter/pull/564))
- `TDPopup`: 修复无法通过child中的height来修改弹出层高度 @Jzow ([#571](https://github.com/Tencent/tdesign-flutter/pull/571))
- `TDDropdownMenu`: 修复特定情况下的单选失效 @1jialong ([#575](https://github.com/Tencent/tdesign-flutter/pull/575))
- `TDToast`: 修复Toast多行文字不生效的问题 @Luozf12345
- `TDPopup`: 修复Popup外层没有Scaffold时展示文字有横线的问题 @Luozf12345

###  🚧 Others
- `TDFooter`: 重构 `TDFooter` 组件；将 `LinkObj` 类移除，直接使用 `TDLink` 类；移除了 `isWithUnderline` 参数，改为在 `TDLink` 中设置链接样式； @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))



## 🌈 0.1.9 `2025-03-31`
### 🚀 Features
- `TDProgress`: 新增`Progress 进度条`组件 @CORCTON ([#307](https://github.com/Tencent/tdesign-flutter/pull/307))
- `TDMessage`: 新增`Message 全局提示`组件 @chendingya ([#316](https://github.com/Tencent/tdesign-flutter/pull/316))
- `TDSkeleton`: 新增`Skeleton 骨架屏`组件 @Ezer015 ([#317](https://github.com/Tencent/tdesign-flutter/pull/317))
- `TDFooter`: 新增`Footer 页脚`组件 @chendingya ([#224](https://github.com/Tencent/tdesign-flutter/pull/224))
- `TDPopover`: 新增`Popover 弹出气泡`组件 @ccXxx1aoBai ([#435](https://github.com/Tencent/tdesign-flutter/pull/435))
- `TDSwitch`: 添加自定义“开/关”字体大小 @shinyina ([#217](https://github.com/Tencent/tdesign-flutter/pull/217))
- `TDDatePicker`: filterItems 参数添加，可自定义显示那些选项；itemBuilder 参数添加，用于自定义item @hkaikai ([#426](https://github.com/Tencent/tdesign-flutter/pull/426))
- `TDDrawer`: 新建TDDrawerWidget组件，可用于Scaffold中的drawer属性 @hkaikai ([#445](https://github.com/Tencent/tdesign-flutter/pull/445))
- `TDTable`: 自定义列返回当前行号 @ccXxx1aoBai ([#457](https://github.com/Tencent/tdesign-flutter/pull/457))
- `TDUpload`: upload组件支持宽高设置和快速替换配置 @HubuHito ([#462](https://github.com/Tencent/tdesign-flutter/pull/462))
- `TDButton`: 添加按钮图标位置属性 @epoll-j ([#463](https://github.com/Tencent/tdesign-flutter/pull/463))
- `TDDropdownMenu`: 支持单选(multiple == false)模式下，分栏(optionsColumns > 1)展示选项 @hkaikai ([#502](https://github.com/Tencent/tdesign-flutter/pull/502))
- `TDActionSheet`: 新增动作面板组件 @hkaikai ([#485](https://github.com/Tencent/tdesign-flutter/pull/485))
- `TDPicker`: 增加customSelectWidget参数 @epoll-j ([#495](https://github.com/Tencent/tdesign-flutter/pull/495))
- `TDSlider`: 增加修改滑轨颜色参数 @epoll-j ([#506](https://github.com/Tencent/tdesign-flutter/pull/506))
- `TDCalendar`: 添加动画滚动日历选中值位置 @hkaikai ([#509](https://github.com/Tencent/tdesign-flutter/pull/509))
- `TDStep`: 新增CustomContent参数支持Step的Content可以自定义内容 @Jzow ([#452](https://github.com/Tencent/tdesign-flutter/pull/452))
- `TDTag`: 新增fixedWidth参数固定宽度属性，可自定义Tag的宽度，修复TextOverflow.ellipsis溢出title问题 @Jzow ([#496](https://github.com/Tencent/tdesign-flutter/pull/496))
- `TDPopup`: 为底部浮层面板添加了边缘拖动控制 @Jzow ([#514](https://github.com/Tencent/tdesign-flutter/pull/514))
- `TDBadge`: Badge设置封顶的数字值 @chendingya ([#302](https://github.com/Tencent/tdesign-flutter/pull/302))
- `TDToast`：带图标类型支持设置文字行数 @ccXxx1aoBai ([#481](https://github.com/Tencent/tdesign-flutter/pull/481))


### 🐞 Bug Fixes
- `TDRefreshHeader`: 升级easy refresh到最新版本，兼容v2和v3写法；交互同步其他移动端平台 @hkaikai ([#438](https://github.com/Tencent/tdesign-flutter/pull/438))
- `TDCell`: 修复无默认样式情况下点击空白区域无反应问题；TDCellStyle默认构造方法提供context参数，可以构建默认样式；完善demo自定义样式用法 @hkaikai ([#448](https://github.com/Tencent/tdesign-flutter/pull/448))
- `TDTable`: 解决空数据图片无法显示问题 @ccXxx1aoBai ([#451](https://github.com/Tencent/tdesign-flutter/pull/451))
- `TDTabBar`: labelStyle、unselectedLabelStyle支持自定义Label的文字大小 @hkaikai ([#453](https://github.com/Tencent/tdesign-flutter/pull/453))
- `TDCalendar`: 修复定位到最后一个月时，无法定位问题 @hkaikai ([#449](https://github.com/Tencent/tdesign-flutter/pull/449))
- `TDBottomTabBar`: 修复capsule类型无法设置背景色 @epoll-j ([#497](https://github.com/Tencent/tdesign-flutter/pull/497))
- `TDCalendar`: 确定按钮添加国际化 @hkaikai ([#505](https://github.com/Tencent/tdesign-flutter/pull/505))
- `TDUpload`: 新增onMaxLimitReached函数修复自定义处理文件数量超过最大限制的Bug @Jzow ([#474](https://github.com/Tencent/tdesign-flutter/pull/474))
- `TDInput`: 新增_getTextWidth函数获取文本实际宽度和点击文本触发事件，修复buildNormalInput文本显示不全 @Jzow ([#475](https://github.com/Tencent/tdesign-flutter/pull/475))
- `TDImage`: 移除自定义宽和自定义高必填，以及默认高度和宽度尺寸72约束，让布局系统自动计算高度 @Jzow ([#499](https://github.com/Tencent/tdesign-flutter/pull/499))
- `TDConfirmDialog`: 新增布局约束和滚动支持动态计算最大高度，修复渲染失败Bug @Jzow ([#510](https://github.com/Tencent/tdesign-flutter/pull/510))
- `TDDrawer`: 新增_deleteRouter()在close函数中的调用强制清除路由，修复关闭路由无法再次打开Bug @Jzow ([#512](https://github.com/Tencent/tdesign-flutter/pull/512))
- `TDText`: 3.22鸿蒙版本text,组件不居中问题 @duleigiser ([#437](https://github.com/Tencent/tdesign-flutter/pull/437))
- `TDAlertDialog`: fix 按钮样式没有铺满 @lvjs ([#460](https://github.com/Tencent/tdesign-flutter/pull/460))


### 🚧 Others
- `TDSlider`: 演示代码拆分 @iamitis ([#245](https://github.com/Tencent/tdesign-flutter/pull/245))
- “关于我们”页面增加发版日期 @iamitis ([#304](https://github.com/Tencent/tdesign-flutter/pull/304))
- `Doc`: 更新README文件英文，新增License文件和Issue Doc模板 @Jzow ([#458](https://github.com/Tencent/tdesign-flutter/pull/458))


## 🌈 0.1.8 `2024-12-30` 
### 🚀 Features
- `TDUpload`: 新增Upload组件 @TingShine ([#405](https://github.com/Tencent/tdesign-flutter/pull/405))
- `SearchBar`: 增加键盘动作类型 @ccXxx1aoBai ([#366](https://github.com/Tencent/tdesign-flutter/pull/366))
- `Cell`: CellGroup 新增样式控制参数：cardBorderRadius(卡片模式边框圆角)、cardPadding(卡片模式内边距)、titlePadding(标题内边距) @hkaikai ([#409](https://github.com/Tencent/tdesign-flutter/pull/409))
- `DropdownMenu`: 新增装饰器配置：decoration，可自定义菜单颜色和边框 @hkaikai ([#408](https://github.com/Tencent/tdesign-flutter/pull/408))
- `ImageViewer`: 支持显示图片标题 @ccXxx1aoBai ([#411](https://github.com/Tencent/tdesign-flutter/pull/411))
- `Calendar`: 新增monthTitleBuilder参数 @hkaikai ([#419](https://github.com/Tencent/tdesign-flutter/pull/419))
- `Calendar`: 新增pickerHeight、pickerItemCount参数，用于控制时间选择组件高度 @hkaikai ([#421](https://github.com/Tencent/tdesign-flutter/pull/421))
- `Toast`: 支持自定义蒙层背景色 @ccXxx1aoBai ([#423](https://github.com/Tencent/tdesign-flutter/pull/423))
- `Rate`: 支持disabled 参数 @hkaikai ([#357](https://github.com/Tencent/tdesign-flutter/pull/357))
- `Calendar`: 修改CalendarBuilder返回值为Widget @Luozf12345 ([#396](https://github.com/Tencent/tdesign-flutter/pull/396))
- `SearchBar`: 新增只读属性与点击事件 @shizhe2018 ([#393](https://github.com/Tencent/tdesign-flutter/pull/393))
- `Dialog`: TDDialogButtonOptions新增属性字体大小 @shizhe2018 ([#381](https://github.com/Tencent/tdesign-flutter/pull/381))
- `DateTimePicker`: 新增时间单位显示属性 @shizhe2018 ([#383](https://github.com/Tencent/tdesign-flutter/pull/383))
- `Input`: 新增additionInfo 左右显示位置 @shizhe2018 ([#401](https://github.com/Tencent/tdesign-flutter/pull/401))
### 🐞 Bug Fixes
- `NoticeBar`: 解决web端文字显示异常问题 @ccXxx1aoBai ([#351](https://github.com/Tencent/tdesign-flutter/pull/351))
- `Rate`: 修复半选时，点击提示框没有触发onChange事件的问题 @hkaikai ([#361](https://github.com/Tencent/tdesign-flutter/pull/361))
- `Calendar`: 修复因月份日期行数不一致导致回显滚动位置不准确问题 @hkaikai ([#363](https://github.com/Tencent/tdesign-flutter/pull/363))
- `Calendar`: 优化min、max过大导致渲染卡顿问题 @hkaikai ([#363](https://github.com/Tencent/tdesign-flutter/pull/363))
- `Input`: 修复设置contentPadding时分割线与内容没对齐问题 @epoll-j ([#365](https://github.com/Tencent/tdesign-flutter/pull/365))
- `Table`: 解决固定列设置宽度溢出问题 @ccXxx1aoBai ([#370](https://github.com/Tencent/tdesign-flutter/pull/370))
- `Popup`: 修复点击蒙层关闭延迟问题 @hkaikai ([#380](https://github.com/Tencent/tdesign-flutter/pull/380))
- `Cascader`: 新增第一层点击选择功能 @shizhe2018 ([#355](https://github.com/Tencent/tdesign-flutter/pull/355))
- `DateTimePicker`: 新增限制时分秒 @shizhe2018 ([#362](https://github.com/Tencent/tdesign-flutter/pull/362))
- `Textarea`: 优化字数限制变化更新 @shizhe2018 ([#385](https://github.com/Tencent/tdesign-flutter/pull/385))
- `TabBar`: 修复labelStyle和unselectedLabelStyle 不生效的问题 @shizhe2018 ([#399](https://github.com/Tencent/tdesign-flutter/pull/399))
- `Picker`: 修改多层弹框，滑动无法选择颜色问题 @shizhe2018 ([#413](https://github.com/Tencent/tdesign-flutter/pull/413))
- `SearchBar`: 修复SearchBar聚集时默认位置抖动,以及光标未居中的问题 @Luozf12345 ([#417](https://github.com/Tencent/tdesign-flutter/pull/417))
- `Dialog`: 修改Dialog可以只传contentWidget,不用传title和content @Luozf12345 ([#418](https://github.com/Tencent/tdesign-flutter/pull/418))
- `TDBottomTabBar`: 修复iconText模式，底部溢出2.5像素 @epoll-j ([#422](https://github.com/Tencent/tdesign-flutter/pull/422))
### 🚧 Others
- 适配FlutterSdk3.25,最低支持版本调整为3.16.0 @shizhe2018 ([#378](https://github.com/Tencent/tdesign-flutter/pull/378))
- 修改Example英文版文案 @shizhe2018 ([#382](https://github.com/Tencent/tdesign-flutter/pull/382))
- 升级flutter_slidable版本 @Luozf12345 ([#407](https://github.com/Tencent/tdesign-flutter/pull/407))
- demo增加组件搜索功能 @Luozf12345 ([#410](https://github.com/Tencent/tdesign-flutter/pull/410))
- 更新Icons @Luozf12345 ([#420](https://github.com/Tencent/tdesign-flutter/pull/420))


## 🌈 0.1.7 `2024-10-16` 
### 🚀 Features
- `TDNoticeBar`: 新增noticeBar组件 @ccXxx1aoBai ([#162](https://github.com/Tencent/tdesign-flutter/pull/162))
- `Result`: 新增Result结果组件 @shinyina ([#220](https://github.com/Tencent/tdesign-flutter/pull/220))
- `TimeCounter`: 计时组件支持超过转换单位的时间展示，原TDCountDown组件改名为TimeCounter @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `Calendar`: 新增Calendar 日历组件 @hkaikai ([#271](https://github.com/Tencent/tdesign-flutter/pull/271))
- `Indexes`: 新增索引组件 @hkaikai ([#321](https://github.com/Tencent/tdesign-flutter/pull/321))
- `Table`: 新增table组件 @ccXxx1aoBai ([#244](https://github.com/Tencent/tdesign-flutter/pull/244))
- `Rate`: 新增Rate组件 @ hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `Dialog`: 支持自定义内容内边距和按钮 @ccXxx1aoBai ([#289](https://github.com/Tencent/tdesign-flutter/pull/289))
- `Drawer`: 支持控制分割线显隐，支持自定义抽屉背景色，支持控制显示最后一条分割线 @ccXxx1aoBai ([#278](https://github.com/Tencent/tdesign-flutter/pull/278))
- `DropdownMenu`: 新增 图标/宽度/高度/图标和文字的对齐方式 控制参数 @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `Search`: 增加action和onActionClick属性 @Ezer015 ([#263](https://github.com/Tencent/tdesign-flutter/pull/263))
- `Avatar`: 增加onTap事件 @ccXxx1aoBai ([#344](https://github.com/Tencent/tdesign-flutter/pull/344))
- `TDDropdownMenu`: TDDropdownItem新增tabBarFlex参数，控制宽度占比 @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `SearchBar`:Feature/td searchbarfix 新增光标高属性 @shizhe2018 ([#337](https://github.com/Tencent/tdesign-flutter/pull/337))
- `TimeCounter`: 添加正向计时功能 @epoll-j ([#246](https://github.com/Tencent/tdesign-flutter/pull/246))
- `NavBar `:[NavBar]支持设置底部阴影 @ccXxx1aoBai ([#284](https://github.com/Tencent/tdesign-flutter/pull/284))
- `Cell`: 添加自定义padding参数 @epoll-j ([#276](https://github.com/Tencent/tdesign-flutter/pull/276))
- `Input`: 增加onTapOutside回调 @epoll-j ([#280](https://github.com/Tencent/tdesign-flutter/pull/280))
- `Picker`: 增加自定义leftText、rightText @epoll-j ([#301](https://github.com/Tencent/tdesign-flutter/pull/301))
- `Slider`:Feature/tdslider 新增文本换行功能 @shizhe2018 ([#329](https://github.com/Tencent/tdesign-flutter/pull/329))
- `Radio`:Feature/tdRadioGroup 新增自带换行，设置行列数 @shizhe2018 ([#331](https://github.com/Tencent/tdesign-flutter/pull/331))
- `Dialog`:新增自定义输入框 @shizhe2018 ([#333](https://github.com/Tencent/tdesign-flutter/pull/333))
- `TDNavBar`:添加flexibleSpace参数 @Luozf12345 ([#341](https://github.com/Tencent/tdesign-flutter/pull/341))
- `TDSearch`:添加搜索框焦点获取及清除事件 @Luozf12345 ([#342](https://github.com/Tencent/tdesign-flutter/pull/342))


### 🐞 Bug Fixes
- `ImageViewer`: 解决defaultIndex无效问题 @ccXxx1aoBai ([#292](https://github.com/Tencent/tdesign-flutter/pull/292))
- `TimeCounter`: 修复无法重复重置问题 @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `DropdownMenu`: 调整弹出层逻辑，修复无法监听后退问题； @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `DatePicker`: 销毁时移除年月日上监控，避免内存泄露；新增onSelectedItemChanged事件 @hkaikai ([#300](https://github.com/Tencent/tdesign-flutter/pull/300))
- `SideBar`: 解决自定义选中样式文字不居中问题 @ccXxx1aoBai ([#313](https://github.com/Tencent/tdesign-flutter/pull/313))
- `Popup`: 解决快速点击蒙层多次返回问题 @ccXxx1aoBai ([#318](https://github.com/Tencent/tdesign-flutter/pull/318))
- `ImageViewer`: 解决删除首位图片显示异常问题 @ccXxx1aoBai ([#322](https://github.com/Tencent/tdesign-flutter/pull/322))
- `SideBar`: 解决延迟加载组件导致瞄点功能异常问题 @ccXxx1aoBai ([#343](https://github.com/Tencent/tdesign-flutter/pull/343))
- `TDDropdownMenu`: 优化menu显示文字超出显示省略号 @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `NoticeBar`: 解决无法跟随主题色问题 @ccXxx1aoBai ([#350](https://github.com/Tencent/tdesign-flutter/pull/350))
- `Button`: 修复设置shape为square或circle时出现overflow @epoll-j ([#257](https://github.com/Tencent/tdesign-flutter/pull/257))
- `Slider`: bugfix:修复tb_slider setState不更新问题 @arvinwli ([#298](https://github.com/Tencent/tdesign-flutter/pull/298))
- `Cascader`: 修改列表排序问题 @shizhe2018 ([#303](https://github.com/Tencent/tdesign-flutter/pull/303))
- `Popup`:解决键盘出现会遮挡Popup里的输入框 @epoll-j ([#264](https://github.com/Tencent/tdesign-flutter/pull/264))
- `Cascader`:修改联动时间限制范围逻辑 @shizhe2018 ([#242](https://github.com/Tencent/tdesign-flutter/pull/242))
- `Loading`:修复Loading显示后立即dismiss无法生效的问题 @Luozf12345 ([#340](https://github.com/Tencent/tdesign-flutter/pull/340))


### 🚧 Others
- fix: remove useless output. @Ives7 ([#311](https://github.com/Tencent/tdesign-flutter/pull/311))



## 🌈 0.1.6 `2024-07-24` 
### 🚀 Features
- `Cell`: 新增 Cell 单元格 组件 @hkaikai ([#150](https://github.com/Tencent/tdesign-flutter/pull/150))
- `Drawer`: 新增Drawer 抽屉 组件 @hkaikai ([#178](https://github.com/Tencent/tdesign-flutter/pull/178))
- `SwipeCell`: 新增SwipeCell 滑动操作 组件 @hkaikai ([#218](https://github.com/Tencent/tdesign-flutter/pull/218))
- `Steps`: 新增 Steps 步骤条 组件 @aaronmhl ([#199](https://github.com/Tencent/tdesign-flutter/pull/199))
- `ImageViewer`: 新增ImageViewer 图片预览 组件 @ccXxx1aoBai ([#187](https://github.com/Tencent/tdesign-flutter/pull/187))
- `Cascader`:新增 Cascader 级联选择器 组件@shizhe2018 ([#195](https://github.com/Tencent/tdesign-flutter/pull/195))
- `Fab`:新增 Fab 悬浮按钮 组件 @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `BackTop`:新增 BackTop 返回顶部 组件 @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `TreeSelect`:新增 TreeSelect 树形选择器 组件 @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `Collapse`:新增 Collapse 折叠面板 组件 @dorayx ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `Input`: 新增inputAction API，支持设置键盘行为；新增spacer API,可自定义组件间距 @ccXxx1aoBai ([#184](https://github.com/Tencent/tdesign-flutter/pull/184))
- `Text`: 增加全局字体配置和加载网络字体的能力 @Luozf12345 ([#232](https://github.com/Tencent/tdesign-flutter/pull/232))
- `CountDown`: 添加 开始/重置/暂停/继续 的控制功能 @hkaikai ([#175](https://github.com/Tencent/tdesign-flutter/pull/175))
- `Popup`: 支持位置，大小设置 @hkaikai ([#191](https://github.com/Tencent/tdesign-flutter/pull/191))
### 🐞 Bug Fixes
- `Toast`: 解决duration属性无效问题 @ccXxx1aoBai ([#167](https://github.com/Tencent/tdesign-flutter/pull/167))
- `Tnput`: 解决label溢出问题 @ccXxx1aoBai ([#184](https://github.com/Tencent/tdesign-flutter/pull/184))
- `Tabs`:tabs组件outlineType为capsule支持设置选中和未选中tab背景色，outlineType为card支持设置选中tab背景色 @ccXxx1aoBai 
- `Button`: 修复setState方法下属性无法改变的问题 @shizhe2018 ([#201](https://github.com/Tencent/tdesign-flutter/pull/201))
- `SearchBar`:搜索框增加控制器，允许外部清除搜索文本 @shizhe2018 ([#194](https://github.com/Tencent/tdesign-flutter/pull/194))
- `Slider`: 新增自定义Decoration样式 @shizhe2018 ([#198](https://github.com/Tencent/tdesign-flutter/pull/198))
- `Empty`: 新增文字大小样式 api @shizhe2018 ([#219](https://github.com/Tencent/tdesign-flutter/pull/219))
- `Dialog`: 新增input类型背景 @shizhe2018 ([#238](https://github.com/Tencent/tdesign-flutter/pull/238))
### 🚧 Others
- 鸿蒙编译支持 @hkaikai ([#233](https://github.com/Tencent/tdesign-flutter/pull/233))
- 修改主题适配工具 @Luozf12345
- 演示代码新增完整页面的github链接 @Luozf12345

## 🌈 0.1.5 `2024-05-31`

### 🚀 Features
- `TDDropdownMenu`:
  - add: 新增TDDropdownMenu 下拉菜单 组件 @hkaikai
- `TDTextarea`:
  - add: 新增Textarea 多行文本框 组件 @hkaikai
- `TDBottomTabBar`:
  - add:支持自定义背景颜色和icon与文本中间距离([#138](https://github.com/Tencent/tdesign-flutter/issues/138))
  - add:TDBottomTabBar支持外部设置currentIndex ([#110](https://github.com/Tencent/tdesign-flutter/issues/110))
- `TDBadge`:
  - add: TDBadge当值为0时角标显隐设置  @ccXxx1aoBai
- `TDRadio`:
  - add: TDRadio增加自定义背景色和文字颜色 @ccXxx1aoBai ([#135](https://github.com/Tencent/tdesign-flutter/issues/135))
  - add: 新增去掉左边边距API([#128](https://github.com/Tencent/tdesign-flutter/issues/128))
- `TDCheckbox`:
  - add: TDCheckbox增加自定义文字颜色
  - add: 新增去掉左边边距API
- `TDImage`:
  - add: 新增Image.file([#133](https://github.com/Tencent/tdesign-flutter/issues/133))
  - add: 允许外部自定义TDImage的fit方式([#114](https://github.com/Tencent/tdesign-flutter/issues/114))
- `TDInput`:
  - add: 新增Input清除按钮自定义尺寸 ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: 新增label文本左侧间距 ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: 新增carType类型的rightWidget ([#147](https://github.com/Tencent/tdesign-flutter/issues/32))
- `TDDivider`:
  - add: 新增分割线组件设置文字样式大小 ([#134](https://github.com/Tencent/tdesign-flutter/issues/134))
- `TDToast`:
  - add: Toast增加自定义文本长度的属性 ([#148](https://github.com/Tencent/tdesign-flutter/issues/148))
- `TDSideBar`:
  - add: 新增选中样式 ([#69](https://github.com/Tencent/tdesign-flutter/issues/69))
  - add: 新增以及自定义文本边距 ([#67](https://github.com/Tencent/tdesign-flutter/issues/67))


### 🐞 Bug Fixes
- `TDButton`:
  - fix: setState()前增加mounted判断 ([#122](https://github.com/Tencent/tdesign-flutter/issues/112))
- `TDDialog`:
  - fix: 修改Dialog只有未设置action的时候,内部才会自动关闭,如果有设置action,则关闭时机交给业务自己处理 ([#117](https://github.com/Tencent/tdesign-flutter/issues/117))

### 🚧 Others
- 增加国际化语言适配功能
- 适配3.16后文本居中,增加TDTextConfig使用文档


## 🌈 0.1.4 `2024-04-08`

### 🚀 Features
- `TDCountDown`:
  - add: 新增TDCountDown倒计时组件 @hkaikai
- `TDTheme`:
  - add: 修改主题实现方式,支持ref属性进行自定义映射
  - add: 添加默认数字字体 numberFontFamily
- `TDText`:
  - add: 添加TDText强制居中开关 kTextForceVerticalCenterEnable,可以全局禁用强制居中,防止flutter 3.16版本之后文字偏移太多([#35](https://github.com/Tencent/tdesign-flutter/issues/35))
- `TDBottomTabBar`:
  - add: 添加自定义背景颜色功能([#55](https://github.com/Tencent/tdesign-flutter/issues/55))
- `TDCheckbox`:
  - add: TDCheckbox和TDRadio支持自定义颜色([#57](https://github.com/Tencent/tdesign-flutter/issues/57))
  - add: TDCheckbox和TDRadio支持自定义字体大小([#66](https://github.com/Tencent/tdesign-flutter/issues/66))
- `TDTabBar`:
  - add: TDTabBar添加分割线的颜色和高度的自定义设置([#71](https://github.com/Tencent/tdesign-flutter/issues/71))
- `TDSwitch`:
  - add: TDSwitch 支持自定义"开/关"文案 ([#73](https://github.com/Tencent/tdesign-flutter/issues/73))
- `TDDialog`:
  - add: 添加自定义标题对齐和内容Widget的功能 ([#58](https://github.com/Tencent/tdesign-flutter/issues/58))


### 🐞 Bug Fixes
- `TDSlider`:
  - fix: 修复TDSlider单游标模式下设置showThumbValue不起作用的问题。
- `TDButton`:
  - fix: 修复TDButton外部设置主题颜色不生效的问题 ([#54](https://github.com/Tencent/tdesign-flutter/issues/54))
- `TDInput`:
  - fix: 修复TDInput的showBottomDivider不生效的问题  ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))
  - fix: TDInput去掉无效的height API,使用SizedBox来修改高度  ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))

### 🚧 Others
- example应用,添加修改主题按钮,可快速修改主题颜色


## 🌈 0.1.3 `2024-03-15`

### 🚀 Features
- `TDButton`:
  - add:支持通过TDButtonStyle.radius自定义圆角大小
- `TDPicker`:
  - add: picker组件滚动PC支持鼠标拖拽
  - add: TDPicker和TDDatePicker组件,onConfirm内部不在默认pop弹窗组件,允许外部自定义处理;OnCancel不为空时不再自动pop组件
- `TDSwitch`:
  - add: onChanged支持外部指定是否消费事件,如果已消费则内部不再处理([#27](https://github.com/Tencent/tdesign-flutter/issues/27))
- `TDBottomTabBar`:
  - add: 增加自定义标签文字样式,优化labText和icon传递参数([#49](https://github.com/Tencent/tdesign-flutter/issues/49))


### 🐞 Bug Fixes
- `TDNavBar`:
  - fix: NavBar顶部高度改为实时获取,防止最开始的时候拿不到([#34](https://github.com/Tencent/tdesign-flutter/issues/34))
- `TDDialog`:
  - fix: DialogInfo 中 contentColor 参数没有传进去 ([#37](https://github.com/Tencent/tdesign-flutter/pull/37))
- `TDButton`:
  - fix: TDButton点击禁用效果无效问题 ([#44](https://github.com/Tencent/tdesign-flutter/issues/44))
- `TDInput`:
  - fix: 删除按钮内部没有自动刷新的问题  ([#30](https://github.com/Tencent/tdesign-flutter/issues/30))
  - fix: 修复输入内容长度和inputFormatters互斥问题  ([#38](https://github.com/Tencent/tdesign-flutter/issues/38))
- `TDAlertDialog`:
  - fix: 组件的默认按钮的操作为开放 ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TDRadio`:
  - fix: 水平排列会强制添加下划线 ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TDTabBar`:
  - fix: indicatorColor不生效问题 ([#31](https://github.com/Tencent/tdesign-flutter/issues/31))

### 🚧 Others
- 优化了TDButton,TDText,TDTheme等常用组件的性能



## 🌈 0.1.2 `2024-01-08`

### 🚀 Features
- `TDImage`:
  - add:图片增加FitWidth类型，修改对应Demo页面 ([#14](https://github.com/Tencent/tdesign-flutter/pull/14))
- `TDLoading`:
  - add: 加载添加显示与隐藏的方法 ([#15](https://github.com/Tencent/tdesign-flutter/pull/15))
- `TDPopup`:
  - add: 添加自定义圆角支持 ([#17](https://github.com/Tencent/tdesign-flutter/pull/17))
- `TDAvatar`:
  - add:头像类型为字符、图标时，支持自定义背景颜色 ([#20](https://github.com/Tencent/tdesign-flutter/pull/20))

### 🐞 Bug Fixes
- `TDBottomTabBar`:
  - 添加安全区域,修复 ([#1](https://github.com/Tencent/tdesign-flutter/issues/1))
- `TDButton`:
  - update widget 可更新按钮disable状态
  - fix: 按钮点击态过短 ([#13](https://github.com/Tencent/tdesign-flutter/pull/13))
- `TDSwiper`:
  - fix: 适配swiper竖向点条状样式 ([#19](https://github.com/Tencent/tdesign-flutter/pull/19))
- `TDInput`:
  - fix: type为TDInputType.twoLine下leftLabelStyle设置不生效 ([#21](https://github.com/Tencent/tdesign-flutter/pull/21))

### 🚧 Others
- 修改最低兼容版本为3.7.0 ([#3](https://github.com/Tencent/tdesign-flutter/issues/3))

## 0.1.1

* 回退代码规范，兼容3.7.x

## 0.1.0

* 发布比较稳定的版本到pub

## 0.0.9

* 修改代码规范

## 0.0.8

* 更新 License

## 0.0.7

* 修改 example的main.dart

## 0.0.6

* 修改slider组件，使其与flutter sdk 版本解耦

## 0.0.5

* 发布到pub仓库

## 0.0.4

* 修复一些已知bug

## 0.0.3

* 删除TDText中相关package的默认值，允许package传null

## 0.0.2

* 更新ReadMe,修改引入文件为'tdesign_flutter.dart'

## 0.0.1

* 正式发布，包含TDButton等29个组件,提供TDTheme、TDIcon等基础属性
