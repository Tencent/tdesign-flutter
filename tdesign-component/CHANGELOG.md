## 🌈 1.0.0-alpha.1 `2026-07-31`

> 这是 v1 的首个预发布版本，API 和视觉细节在正式版前仍可能调整。建议试用项目锁定
> `tdesign_flutter: 1.0.0-alpha.1`，并重点回归浮层、选择器、日历和轮播等重构组件。

### 💥 Breaking Changes

- 完成 v1 API 预发布迁移，组件统一使用 `T` 前缀并移除旧版兼容参数。
- 组件视觉默认值统一接入 Flutter `ThemeData` 与 TDesign ThemeExtension。
- 样式支持应用级 Token、全局组件 ThemeData、局部子树 ThemeData 和单实例显式参数四级控制；局部覆盖统一使用 `mergeExtension`。
- 受控组件需在回调中回写状态；业务创建的 Controller 由业务释放；Overlay 必须使用目标 Theme/Navigator 子树的 context。
- `TSwiper` 改为 `TSwiperController` 驱动；`TBadge` 使用语义化 `label` 展示数字或自定义短文本。
- Calendar 改为 `DateTime` 受控值；Picker、DateTimePicker 与 Cascader 只负责选择，标题、确认和弹层由业务组合。
- Popup 改为 `TPopupOptions + TPopupHandle`，Dialog 改为统一内容槽位与 `TDialogAction`。

### 🚀 Features

- `TSwiper` 支持 autoplay 生命周期管理、真实卡片视口、横竖布局、外置分页、自定义标记和自定义前后按钮。
- Popup、ActionSheet、NavBar、FAB 与 Message 统一安全区契约，默认启用且支持显式关闭。

### 🐞 Bug Fixes

- 修复 Popup 五向默认尺寸与 center 安全区行为。
- 修复 Checkbox、Radio 热区未围绕视觉控件居中的问题。
- 修复 ImageViewer 与 Swiper 实际页码、Controller 生命周期和动态数据同步。

## 🌈 0.2.7 `2026-01-21`
### 🚀 Features

- `TInput`: TInput密文模式下支持粘贴 @jflin19990707 ([#827](https://github.com/Tencent/tdesign-flutter/pull/827))
- `TDropdownMenu`: TDropdownMenu的arrowIcon颜色可自定义 @jflin19990707 ([#831](https://github.com/Tencent/tdesign-flutter/pull/831))
- `TInput`: TInput高度自适应 @jflin19990707 ([#840](https://github.com/Tencent/tdesign-flutter/pull/840))
- `TCalendar`: 允许月历控件在拖动后返回当前月份,用于延迟加载月份改变数据 @rxnh8256 ([#816](https://github.com/Tencent/tdesign-flutter/pull/816))
- `TActionSheetItem`: 支持设置cell描述信息的能力 @leenc123 ([#811](https://github.com/Tencent/tdesign-flutter/pull/811))
- `TBottomTabBar`: tabbar新增indicatorAnimation动画属性 @journeyding ([#848](https://github.com/Tencent/tdesign-flutter/pull/848))

### 🐞 Bug Fixes
- `TPopup`: 底部弹出popup重绘问题 @jflin19990707 ([#826](https://github.com/Tencent/tdesign-flutter/pull/826))
- `TDropdownMenu`: TDropdownMenu分组菜单多选模式下的返回值bug @jflin19990707 ([#828](https://github.com/Tencent/tdesign-flutter/pull/828))
- `TTable`: TTable中TDTableCol的索引BUG @jflin19990707 ([#830](https://github.com/Tencent/tdesign-flutter/pull/830))
- `TTreeSelect`: 树形选择器异步数据更新后能重新渲染；二级菜单文字过长处理一下；TSelectOption中的value改为dynamic类型 @jflin19990707 ([#834](https://github.com/Tencent/tdesign-flutter/pull/834))
- `TToast`: TToast过长溢出问题 @jflin19990707 ([#839](https://github.com/Tencent/tdesign-flutter/pull/839))
- `TDropdownItem`: TDropdownItem不兼容TDMultiCascader @jflin19990707 ([#846](https://github.com/Tencent/tdesign-flutter/pull/846))
- `TCalendar`: 自定义日期单元格组件移除padding，使之沾满并覆盖默认选中样式从而实现自定义选中以及当前日期的样式问题,并增加日期锚点属性来实现自动滚动到锚点位置 @leenc123 ([#808](https://github.com/Tencent/tdesign-flutter/pull/808))
- `DropdownMenu`: 修复 item 的 label 过长时导致显示不完全的 bug @edram ([#823](https://github.com/Tencent/tdesign-flutter/pull/823))
- `TRadio`、`TCheckbox`: 单选框、多选框多列展示问题 @jflin19990707 ([#841](https://github.com/Tencent/tdesign-flutter/pull/841))
- `TNavBar`: 优化标题栏返回图标 支持暗黑模式 @sinianbao ([#844](https://github.com/Tencent/tdesign-flutter/pull/844))

### 🚧 Others
- docs: 更新主题生成器文档，添加视频演示链接 @RSS1102 ([#833](https://github.com/Tencent/tdesign-flutter/pull/833))


## 🌈 0.2.6 `2025-11-14`
### 🚀 Features
- `TNoticeBar`: Added `content` property, deprecated and compatible with the original context property @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))
- `TButton`: Added gradient color background @jflin19990707 ([#773](https://github.com/Tencent/tdesign-flutter/pull/773))
- `TToast`: TToast supports displaying multiple toasts @jflin19990707 ([#780](https://github.com/Tencent/tdesign-flutter/pull/780))
- `TUpload`: Added custom upload listener @leenc123 ([#775](https://github.com/Tencent/tdesign-flutter/pull/775))
- `TTable`: Added custom footer property @leenc123 ([#776](https://github.com/Tencent/tdesign-flutter/pull/776))

### 🐞 Bug Fixes
- `TMultiCascader`: Fixed initialIndexes parameter not taking effect @epoll-j ([#752](https://github.com/Tencent/tdesign-flutter/pull/752))
- `TDialog`: Fixed button text overflow issue @jflin19990707 ([#772](https://github.com/Tencent/tdesign-flutter/pull/772))
- `TDateTimePicker`: Changed English configuration for date, hour, minute, second to abbreviations @jflin19990707 ([#770](https://github.com/Tencent/tdesign-flutter/pull/770))
- `TCell`: Fixed overflow issue when note is too long @jflin19990707 ([#769](https://github.com/Tencent/tdesign-flutter/pull/769))
- `TCell`: Fixed alignment issue between icon and text in the cell @runoob-coder ([#789](https://github.com/Tencent/tdesign-flutter/pull/789))
- `TProgress`: Fixed style issue when progress bar changes @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))

### 📝 Documentation
- `docs`: Optimized document format and content @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))

### 🚧 Others
- Components fully adapted to dark mode, optimized and adjusted component styles (experimental version) @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))
- `demo`: Optimized and adjusted demo example project and code demonstrations, upgraded Android build configuration and dependencies to be compatible with Flutter from `3.16.9` to the latest version (`3.35.5`), adjusted web preview iframe style to remove top margin @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))
- `web`: Overridden web dependencies, resolved version conflict with flutter_localizations, compatible with previous Flutter versions @runoob-coder ([#744](https://github.com/Tencent/tdesign-flutter/pull/744))

## 🌈 0.2.5 `2025-09-12`
### 🐞 Bug Fixes
- `TPopover`: Added custom corner radius property @jflin19990707 ([#727](https://github.com/Tencent/tdesign-flutter/pull/727))
- `TForm`: Added custom background color property for form, button part can be optional @jflin19990707 ([#730](https://github.com/Tencent/tdesign-flutter/pull/730))
- `TConfirmDialog`: Dialog supports custom width, buttons added custom style properties @jflin19990707 ([#724](https://github.com/Tencent/tdesign-flutter/pull/724))
- `TPicker`: Supports initialization and subsequent dynamic loading of appropriate data, fixes stuttering issues @123dw-bot ([#728](https://github.com/Tencent/tdesign-flutter/pull/728))
- `TSideBar`: Added custom unselected color property @jflin19990707 ([#723](https://github.com/Tencent/tdesign-flutter/pull/723))
### 🚧 Others
- docs: Optimized repository size @RSS1102

## 🌈 0.2.4 `2025-08-14`
### 🚀 Features
- `TUpload`: Support setting image spacing and alignment @cyjaysong ([#677](https://github.com/Tencent/tdesign-flutter/pull/677))
- `TTreeSelect`: Added custom width and max lines fields, fixed fixed width for second level and long text overflow issues @123dw-bot ([#694](https://github.com/Tencent/tdesign-flutter/pull/694))
- `TDropdownMenu`: Added TDropdownItemController to allow external reset and change of dropdown options @Luozf12345 ([#697](https://github.com/Tencent/tdesign-flutter/pull/697))
- `TStepper`: Added controller parameter to Stepper for real-time value modification @Luozf12345 ([#699](https://github.com/Tencent/tdesign-flutter/pull/699))

### 🐞 Bug Fixes
- `TIndexes`: Fixed issue where custom indexes could not respond to click events @epoll-j ([#692](https://github.com/Tencent/tdesign-flutter/pull/692))
- `TPopup`: Fixed bug where close method was triggered twice @epoll-j ([#690](https://github.com/Tencent/tdesign-flutter/pull/690))
- `TSideBar`: Fixed issue where children of TSideBar component could not be updated after initialization @Luozf12345 ([#698](https://github.com/Tencent/tdesign-flutter/pull/698))

### 🚧 Others
- `Misc`: Restored default adaptation for flutter SDK version 3.32



## 🌈 0.2.3 `2025-07-09`
### 🚀 Features
- `TPicker`: Supports prioritizing the retention of cascaded option values when switching @epoll-j ([#666](https://github.com/Tencent/tdesign-flutter/pull/666))
- `TTable`: Supports default row selection @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))
- `TCalendar`: Adds custom date cell functionality @epoll-j ([#667](https://github.com/Tencent/tdesign-flutter/pull/667))
- `TForm`: Adds Form component @shizhe2018 @SimonWuZY ([#620](https://github.com/Tencent/tdesign-flutter/pull/620))
- `TTable`: Separates TTableCol attribute configuration and empty data configuration @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))

### 🐞 Bug Fixes
- `TTable`: Fixes the issue with unselected icon display in table headers and the selection state problem under disabled conditions @ccXxx1aoBai ([#665](https://github.com/Tencent/tdesign-flutter/pull/665))
- `TTable`: Fixes the empty data issue in tables @ccXxx1aoBai ([#671](https://github.com/Tencent/tdesign-flutter/pull/671))
- `TDialog`: Fixes the issue where dialogs block the keyboard @jflin19990707 ([#669](https://github.com/Tencent/tdesign-flutter/pull/669))
- `TCollapse`: Updates the demo page name for collapse @jflin19990707 ([#670](https://github.com/Tencent/tdesign-flutter/pull/670))
- `TDropdownMenu`: Fixes the incorrect popup position calculation in nested routing scenarios @hcanyz ([#648](https://github.com/Tencent/tdesign-flutter/pull/648))


## 🌈 0.2.2 `2025-06-13`
### 🚀 Features
- `TTable`: Added support for row selection and custom row height. @ccXxx1aoBai ([#594](https://github.com/Tencent/tdesign-flutter/pull/594))
- `TTreeSelect`: Added partial multi-selection support. @epoll-j ([#587](https://github.com/Tencent/tdesign-flutter/pull/587))
- `TCell`: Added support for custom height and bottom divider. @ccXxx1aoBai ([#611](https://github.com/Tencent/tdesign-flutter/pull/611))
- `TNoticeBar`: Added support for custom number of text lines. @ccXxx1aoBai ([#611](https://github.com/Tencent/tdesign-flutter/pull/611))
- `TBottomTabBar`: Made onTap in TButtonBottomTabBar support repeated clicks. @epoll-j @RSS1102 ([#586](https://github.com/Tencent/tdesign-flutter/pull/586))
- `TBottomTabBar`: Implemented tap ripple effects. @RSS1102 ([#626](https://github.com/Tencent/tdesign-flutter/pull/626))
- `TAvatar`: Added custom BoxFit parameter. @shizhe2018 ([#633](https://github.com/Tencent/tdesign-flutter/pull/633))

### 🐞 Bug Fixes
- `TDatePicker`: Fixed minute-level time display issue and optimized hour/minute/second range calculation logic. @epoll-j ([#585](https://github.com/Tencent/tdesign-flutter/pull/585))
- `TSearchBar`: Added onTapOutside callback support. @cyjaysong ([#608](https://github.com/Tencent/tdesign-flutter/pull/608))
- `TDropdownMenu`: Added support for modifying selected icon color. @jflin19990707 ([#631](https://github.com/Tencent/tdesign-flutter/pull/631))
- `TTabBar`: Fixed text-icon conflict in TBottomTabBarBasicType.iconText mode. @jflin19990707 ([#628](https://github.com/Tencent/tdesign-flutter/pull/628))
- `TEmpty`: Added custom styling support for action buttons. @jflin19990707 ([#624](https://github.com/Tencent/tdesign-flutter/pull/624))
- `TToast`: Added custom text support for toast. @jflin19990707 ([#625](https://github.com/Tencent/tdesign-flutter/pull/625))
- `TPopup`: Modified _measureChildHeight method to fix inability to adjust popup height via child component. @Jzow ([#591](https://github.com/Tencent/tdesign-flutter/pull/591))
- `TCascader`: Fixed empty state handling for query data. @shizhe2018 ([#635](https://github.com/Tencent/tdesign-flutter/pull/635))

### 🚧 Others

-  Adapted for Flutter 3.32 version. @Luozf12345 ([#636](https://github.com/Tencent/tdesign-flutter/pull/636))


## 🌈 0.2.0 `2025-05-07`
### 🚀 Features
- `TCellGroup`: Added `titleBackgroundColor` property for cell group title background color. @runoob-coder ([#539](https://github.com/Tencent/tdesign-flutter/pull/539))
- `TLink`: Replaced link parameter `LinkObj` with `MessageLink`, adjusted `TLink` styles, and added click callback. @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))
- `TBottomTabBar`: Added custom title support for step bar component. @RSS1102 ([#576](https://github.com/Tencent/tdesign-flutter/pull/576))
- `TSlider`: Added slider tap event `onTap`. @RSS1102 ([#527](https://github.com/Tencent/tdesign-flutter/pull/527))
- `TCascader`: Added "Confirm" button at top-right corner to support selecting any option. @Luozf12345
- `ImageViewer`: Added single image deletion support. @ccXxx1aoBai ([#581](https://github.com/Tencent/tdesign-flutter/pull/581))
- `TPopup`: Added custom size properties for popup title, left text, right text, and close button. @Jzow ([#582](https://github.com/Tencent/tdesign-flutter/pull/582))
- `TBottomTabBarTabConfig`: Added `onLongPress` event triggered by long-pressing tabs. @RSS1102 ([#580](https://github.com/Tencent/tdesign-flutter/pull/580))

### 🐞 Bug Fixes
- `TFooter`: Fixed content overflow issue in link mode. @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))
- `TUpload`: Fixed file size limit error. @epoll-j ([#544](https://github.com/Tencent/tdesign-flutter/pull/544))
- `TImageViewer`: Added Swiper component property passthrough, click events, and style properties; supports custom buttons. @ccXxx1aoBai ([#561](https://github.com/Tencent/tdesign-flutter/pull/561))
- `TSlider`: Fixed edge drag failure and value/scale display issues in capsule type with range. @qfish ([#567](https://github.com/Tencent/tdesign-flutter/pull/567))
- `TInput`: Fixed width calculation defect for non-Chinese label input fields. @Jzow ([#564](https://github.com/Tencent/tdesign-flutter/pull/564))
- `TPopup`: Fixed inability to modify popup height via `height` in child component. @Jzow ([#571](https://github.com/Tencent/tdesign-flutter/pull/571))
- `TDropdownMenu`: Fixed single-select failure in specific scenarios. @1jialong ([#575](https://github.com/Tencent/tdesign-flutter/pull/575))
- `TToast`: Fixed multi-line text display issue. @Luozf12345
- `TPopup`: Fixed horizontal line display issue when popup lacks outer Scaffold. @Luozf12345

### 🚧 Others
- `TFooter`: Refactored `TFooter` component; Removed `LinkObj` class and directly used `TLink` class; Removed `isWithUnderline` parameter (link styles now set in `TLink`). @runoob-coder ([#554](https://github.com/Tencent/tdesign-flutter/pull/554))



## 🌈 0.1.9 `2025-03-31`
### 🚀 Features
- `TProgress`: Added `Progress` component @CORCTON ([#307](https://github.com/Tencent/tdesign-flutter/pull/307))
- `TMessage`: Added `Message` (Global Prompt) component @chendingya ([#316](https://github.com/Tencent/tdesign-flutter/pull/316))
- `TSkeleton`: Added `Skeleton` component @Ezer015 ([#317](https://github.com/Tencent/tdesign-flutter/pull/317))
- `TFooter`: Added `Footer` component @chendingya ([#224](https://github.com/Tencent/tdesign-flutter/pull/224))
- `TPopover`: Added `Popover` (Popup Bubble) component @ccXxx1aoBai ([#435](https://github.com/Tencent/tdesign-flutter/pull/435))
- `TSwitch`: Added custom "ON/OFF" font size support @shinyina ([#217](https://github.com/Tencent/tdesign-flutter/pull/217))
- `TDatePicker`: Added `filterItems` parameter for custom display options and `itemBuilder` for custom item rendering @hkaikai ([#426](https://github.com/Tencent/tdesign-flutter/pull/426))
- `TDrawer`: Created `TDrawerWidget` component compatible with Scaffold's drawer property @hkaikai ([#445](https://github.com/Tencent/tdesign-flutter/pull/445))
- `TTable`: Custom columns now return current row number @ccXxx1aoBai ([#457](https://github.com/Tencent/tdesign-flutter/pull/457))
- `TUpload`: Added width/height settings and quick replacement configuration support @HubuHito ([#462](https://github.com/Tencent/tdesign-flutter/pull/462))
- `TButton`: Added icon position property @epoll-j ([#463](https://github.com/Tencent/tdesign-flutter/pull/463))
- `TDropdownMenu`: Supported single-select mode (`multiple == false`) with multi-column display (`optionsColumns > 1`) @hkaikai ([#502](https://github.com/Tencent/tdesign-flutter/pull/502))
- `TActionSheet`: Added Action Sheet component @hkaikai ([#485](https://github.com/Tencent/tdesign-flutter/pull/485))
- `TPicker`: Added `customSelectWidget` parameter @epoll-j ([#495](https://github.com/Tencent/tdesign-flutter/pull/495))
- `TSlider`: Added track color modification parameter @epoll-j ([#506](https://github.com/Tencent/tdesign-flutter/pull/506))
- `TCalendar`: Added animated scrolling to selected value position @hkaikai ([#509](https://github.com/Tencent/tdesign-flutter/pull/509))
- `TStep`: Added `CustomContent` parameter for Step content customization @Jzow ([#452](https://github.com/Tencent/tdesign-flutter/pull/452))
- `TTag`: Added `fixedWidth` parameter and fixed `TextOverflow.ellipsis` title overflow issue @Jzow ([#496](https://github.com/Tencent/tdesign-flutter/pull/496))
- `TPopup`: Added edge drag control for bottom panel @Jzow ([#514](https://github.com/Tencent/tdesign-flutter/pull/514))
- `TBadge`: Added capped numeric value setting for Badge @chendingya ([#302](https://github.com/Tencent/tdesign-flutter/pull/302))
- `TToast`: Added multi-line text support for icon-type toasts @ccXxx1aoBai ([#481](https://github.com/Tencent/tdesign-flutter/pull/481))

### 🐞 Bug Fixes
- `TRefreshHeader`: Upgraded Easy Refresh to latest version, improved compatibility between v2/v3 syntax @hkaikai ([#438](https://github.com/Tencent/tdesign-flutter/pull/438))
- `TCell`: Fixed unresponsive click in blank area without default style; Improved default style construction and demo usage @hkaikai ([#448](https://github.com/Tencent/tdesign-flutter/pull/448))
- `TTable`: Fixed empty data image display issue @ccXxx1aoBai ([#451](https://github.com/Tencent/tdesign-flutter/pull/451))
- `TTabBar`: Added `labelStyle` and `unselectedLabelStyle` support for custom font sizes @hkaikai ([#453](https://github.com/Tencent/tdesign-flutter/pull/453))
- `TCalendar`: Fixed positioning issue when scrolling to last month @hkaikai ([#449](https://github.com/Tencent/tdesign-flutter/pull/449))
- `TBottomTabBar`: Fixed background color setting for capsule type @epoll-j ([#497](https://github.com/Tencent/tdesign-flutter/pull/497))
- `TCalendar`: Added localization for confirm button @hkaikai ([#505](https://github.com/Tencent/tdesign-flutter/pull/505))
- `TUpload`: Added `onMaxLimitReached` callback to handle file limit overflow @Jzow ([#474](https://github.com/Tencent/tdesign-flutter/pull/474))
- `TInput`: Added `_getTextWidth` function and click event to fix incomplete text display @Jzow ([#475](https://github.com/Tencent/tdesign-flutter/pull/475))
- `TImage`: Removed mandatory custom width/height constraints (default 72px) for layout auto-calculation @Jzow ([#499](https://github.com/Tencent/tdesign-flutter/pull/499))
- `TConfirmDialog`: Added layout constraints and dynamic max-height calculation with scroll support @Jzow ([#510](https://github.com/Tencent/tdesign-flutter/pull/510))
- `TDrawer`: Added `_deleteRouter()` call in close function to force clear routes @Jzow ([#512](https://github.com/Tencent/tdesign-flutter/pull/512))
- `TText`: Fixed text alignment issue in HarmonyOS 3.22 @duleigiser ([#437](https://github.com/Tencent/tdesign-flutter/pull/437))
- `TAlertDialog`: Fixed button style not filling width @lvjs ([#460](https://github.com/Tencent/tdesign-flutter/pull/460))

### 🚧 Others
- `TSlider`: Demo code splitting @iamitis ([#245](https://github.com/Tencent/tdesign-flutter/pull/245))
- Added release date to "About Us" page @iamitis ([#304](https://github.com/Tencent/tdesign-flutter/pull/304))
- `Doc`: Updated README English version, added License file and Issue Doc templates @Jzow ([#458](https://github.com/Tencent/tdesign-flutter/pull/458))



## 🌈 0.1.8 `2024-12-30`
### 🚀 Features
- `TUpload`: Added Upload component @TingShine ([#405](https://github.com/Tencent/tdesign-flutter/pull/405))
- `SearchBar`: Added keyboard action type @ccXxx1aoBai ([#366](https://github.com/Tencent/tdesign-flutter/pull/366))
- `Cell`: CellGroup added style control parameters: cardBorderRadius (card mode border radius), cardPadding (card mode padding), titlePadding (title padding) @hkaikai ([#409](https://github.com/Tencent/tdesign-flutter/pull/409))
- `DropdownMenu`: Added decorator configuration: decoration, which can customize menu color and border @hkaikai ([#408](https://github.com/Tencent/tdesign-flutter/pull/408))
- `ImageViewer`: Supports displaying image titles @ccXxx1aoBai ([#411](https://github.com/Tencent/tdesign-flutter/pull/411))
- `Calendar`: Added monthTitleBuilder parameter @hkaikai ([#419](https://github.com/Tencent/tdesign-flutter/pull/419))
- `Calendar`: Added pickerHeight, pickerItemCount parameters to control the height of the time selection component @hkaikai ([#421](https://github.com/Tencent/tdesign-flutter/pull/421))
- `Toast`: Supports customizing the overlay background color @ccXxx1aoBai ([#423](https://github.com/Tencent/tdesign-flutter/pull/423))
- `Rate`: Supports disabled parameter @hkaikai ([#357](https://github.com/Tencent/tdesign-flutter/pull/357))
- `Calendar`: Modified CalendarBuilder return value to Widget @Luozf12345 ([#396](https://github.com/Tencent/tdesign-flutter/pull/396))
- `SearchBar`: Added read-only attribute and click event @shizhe2018 ([#393](https://github.com/Tencent/tdesign-flutter/pull/393))
- `Dialog`: TDialogButtonOptions added font size attribute @shizhe2018 ([#381](https://github.com/Tencent/tdesign-flutter/pull/381))
- `DateTimePicker`: Added time unit display attribute @shizhe2018 ([#383](https://github.com/Tencent/tdesign-flutter/pull/383))
- `Input`: Added additionInfo left and right display position @shizhe2018 ([#401](https://github.com/Tencent/tdesign-flutter/pull/401))

### 🐞 Bug Fixes
- `NoticeBar`: Fixed the issue of abnormal text display on the web @ccXxx1aoBai ([#351](https://github.com/Tencent/tdesign-flutter/pull/351))
- `Rate`: Fixed the issue where the onChange event was not triggered when clicking the tooltip in half selection @hkaikai ([#361](https://github.com/Tencent/tdesign-flutter/pull/361))
- `Calendar`: Fixed the issue of inaccurate scroll position due to inconsistent number of rows in the month date @hkaikai ([#363](https://github.com/Tencent/tdesign-flutter/pull/363))
- `Calendar`: Optimized the issue of rendering lag caused by too large min and max @hkaikai ([#363](https://github.com/Tencent/tdesign-flutter/pull/363))
- `Input`: Fixed the issue where the dividing line and content were not aligned when setting contentPadding @epoll-j ([#365](https://github.com/Tencent/tdesign-flutter/pull/365))
- `Table`: Fixed the issue of overflow when setting the width of fixed columns @ccXxx1aoBai ([#370](https://github.com/Tencent/tdesign-flutter/pull/370))
- `Popup`: Fixed the issue of delay in closing when clicking on the overlay @hkaikai ([#380](https://github.com/Tencent/tdesign-flutter/pull/380))
- `Cascader`: Added the function of clicking to select the first layer @shizhe2018 ([#355](https://github.com/Tencent/tdesign-flutter/pull/355))
- `DateTimePicker`: Added restrictions on hours, minutes, and seconds @shizhe2018 ([#362](https://github.com/Tencent/tdesign-flutter/pull/362))
- `Textarea`: Optimized the update of word limit changes @shizhe2018 ([#385](https://github.com/Tencent/tdesign-flutter/pull/385))
- `TabBar`: Fixed the issue where labelStyle and unselectedLabelStyle did not take effect @shizhe2018 ([#399](https://github.com/Tencent/tdesign-flutter/pull/399))
- `Picker`: Fixed the issue of unable to select color when sliding in multi-layer pop-up @shizhe2018 ([#413](https://github.com/Tencent/tdesign-flutter/pull/413))
- `SearchBar`: Fixed the issue of SearchBar jittering at the default position when focusing, and the cursor not being centered @Luozf12345 ([#417](https://github.com/Tencent/tdesign-flutter/pull/417))
- `Dialog`: Modified Dialog to only pass contentWidget, no need to pass title and content @Luozf12345 ([#418](https://github.com/Tencent/tdesign-flutter/pull/418))
- `TBottomTabBar`: Fixed the issue of bottom overflow by 2.5 pixels in iconText mode @epoll-j ([#422](https://github.com/Tencent/tdesign-flutter/pull/422))

### 🚧 Others
- Adapted to FlutterSdk3.25, the minimum supported version has been adjusted to 3.16.0 @shizhe2018 ([#378](https://github.com/Tencent/tdesign-flutter/pull/378))
- Modified Example English version copy @shizhe2018 ([#382](https://github.com/Tencent/tdesign-flutter/pull/382))
- Upgraded flutter_slidable version @Luozf12345 ([#407](https://github.com/Tencent/tdesign-flutter/pull/407))
- Added component search function to demo @Luozf12345 ([#410](https://github.com/Tencent/tdesign-flutter/pull/410))
- Updated Icons @Luozf12345 ([#420](https://github.com/Tencent/tdesign-flutter/pull/420))

## 🌈 0.1.7 `2024-10-16`
### 🚀 Features
- `TNoticeBar`: Added noticeBar component @ccXxx1aoBai ([#162](https://github.com/Tencent/tdesign-flutter/pull/162))
- `Result`: Added Result component @shinyina ([#220](https://github.com/Tencent/tdesign-flutter/pull/220))
- `TimeCounter`: Timer component supports time display beyond conversion units, original TCountDown component renamed to TimeCounter @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `Calendar`: Added Calendar component @hkaikai ([#271](https://github.com/Tencent/tdesign-flutter/pull/271))
- `Indexes`: Added Indexes component @hkaikai ([#321](https://github.com/Tencent/tdesign-flutter/pull/321))
- `Table`: Added table component @ccXxx1aoBai ([#244](https://github.com/Tencent/tdesign-flutter/pull/244))
- `Rate`: Added Rate component @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `Dialog`: Supports custom content padding and buttons @ccXxx1aoBai ([#289](https://github.com/Tencent/tdesign-flutter/pull/289))
- `Drawer`: Supports controlling the visibility of the divider, custom drawer background color, and controlling the display of the last divider @ccXxx1aoBai ([#278](https://github.com/Tencent/tdesign-flutter/pull/278))
- `DropdownMenu`: Added control parameters for icon/width/height/icon and text alignment @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `Search`: Added action and onActionClick properties @Ezer015 ([#263](https://github.com/Tencent/tdesign-flutter/pull/263))
- `Avatar`: Added onTap event @ccXxx1aoBai ([#344](https://github.com/Tencent/tdesign-flutter/pull/344))
- `TDropdownMenu`: Added tabBarFlex parameter to TDropdownItem to control width ratio @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `SearchBar`: Feature/td searchbarfix added cursor height property @shizhe2018 ([#337](https://github.com/Tencent/tdesign-flutter/pull/337))
- `TimeCounter`: Added forward timing function @epoll-j ([#246](https://github.com/Tencent/tdesign-flutter/pull/246))
- `NavBar`: [NavBar] supports setting bottom shadow @ccXxx1aoBai ([#284](https://github.com/Tencent/tdesign-flutter/pull/284))
- `Cell`: Added custom padding parameter @epoll-j ([#276](https://github.com/Tencent/tdesign-flutter/pull/276))
- `Input`: Added onTapOutside callback @epoll-j ([#280](https://github.com/Tencent/tdesign-flutter/pull/280))
- `Picker`: Added custom leftText, rightText @epoll-j ([#301](https://github.com/Tencent/tdesign-flutter/pull/301))
- `Slider`: Feature/tdslider added text wrapping function @shizhe2018 ([#329](https://github.com/Tencent/tdesign-flutter/pull/329))
- `Radio`: Feature/tdRadioGroup added built-in line wrapping, set number of rows and columns @shizhe2018 ([#331](https://github.com/Tencent/tdesign-flutter/pull/331))
- `Dialog`: Added custom input box @shizhe2018 ([#333](https://github.com/Tencent/tdesign-flutter/pull/333))
- `TNavBar`: Added flexibleSpace parameter @Luozf12345 ([#341](https://github.com/Tencent/tdesign-flutter/pull/341))
- `TSearch`: Added search box focus acquisition and clear events @Luozf12345 ([#342](https://github.com/Tencent/tdesign-flutter/pull/342))

### 🐞 Bug Fixes
- `ImageViewer`: Fixed defaultIndex invalid issue @ccXxx1aoBai ([#292](https://github.com/Tencent/tdesign-flutter/pull/292))
- `TimeCounter`: Fixed issue where it could not be reset repeatedly @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `DropdownMenu`: Adjusted popup layer logic, fixed issue where back button could not be listened to @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `DatePicker`: Removed monitoring on year, month, and day when destroyed to avoid memory leaks; added onSelectedItemChanged event @hkaikai ([#300](https://github.com/Tencent/tdesign-flutter/pull/300))
- `SideBar`: Fixed issue where custom selected style text was not centered @ccXxx1aoBai ([#313](https://github.com/Tencent/tdesign-flutter/pull/313))
- `Popup`: Fixed issue where multiple returns occurred when quickly clicking the mask @ccXxx1aoBai ([#318](https://github.com/Tencent/tdesign-flutter/pull/318))
- `ImageViewer`: Fixed issue where deleting the first image caused display anomalies @ccXxx1aoBai ([#322](https://github.com/Tencent/tdesign-flutter/pull/322))
- `SideBar`: Fixed issue where delayed loading components caused anchor point function anomalies @ccXxx1aoBai ([#343](https://github.com/Tencent/tdesign-flutter/pull/343))
- `TDropdownMenu`: Optimized menu display text to show ellipsis when exceeding display limit @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `NoticeBar`: Fixed issue where it could not follow the theme color @ccXxx1aoBai ([#350](https://github.com/Tencent/tdesign-flutter/pull/350))
- `Button`: Fixed overflow issue when setting shape to square or circle @epoll-j ([#257](https://github.com/Tencent/tdesign-flutter/pull/257))
- `Slider`: Bugfix: Fixed issue where tb_slider setState did not update @arvinwli ([#298](https://github.com/Tencent/tdesign-flutter/pull/298))
- `Cascader`: Fixed list sorting issue @shizhe2018 ([#303](https://github.com/Tencent/tdesign-flutter/pull/303))
- `Popup`: Fixed issue where the keyboard would cover the input box in the Popup @epoll-j ([#264](https://github.com/Tencent/tdesign-flutter/pull/264))
- `Cascader`: Fixed linkage time limit range logic @shizhe2018 ([#242](https://github.com/Tencent/tdesign-flutter/pull/242))
- `Loading`: Fixed issue where dismissing Loading immediately after showing did not take effect @Luozf12345 ([#340](https://github.com/Tencent/tdesign-flutter/pull/340))

### 🚧 Others
- fix: remove useless output. @Ives7 ([#311](https://github.com/Tencent/tdesign-flutter/pull/311))



## 🌈 0.1.6 `2024-07-24`

### 🚀 Features
- `Cell`: Added Cell component @hkaikai ([#150](https://github.com/Tencent/tdesign-flutter/pull/150))
- `Drawer`: Added Drawer component @hkaikai ([#178](https://github.com/Tencent/tdesign-flutter/pull/178))
- `SwipeCell`: Added SwipeCell component @hkaikai ([#218](https://github.com/Tencent/tdesign-flutter/pull/218))
- `Steps`: Added Steps component @aaronmhl ([#199](https://github.com/Tencent/tdesign-flutter/pull/199))
- `ImageViewer`: Added ImageViewer component @ccXxx1aoBai ([#187](https://github.com/Tencent/tdesign-flutter/pull/187))
- `Cascader`: Added Cascader component @shizhe2018 ([#195](https://github.com/Tencent/tdesign-flutter/pull/195))
- `Fab`: Added Fab component @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `BackTop`: Added BackTop component @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `TreeSelect`: Added TreeSelect component @TingShine ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `Collapse`: Added Collapse component @dorayx ([#239](https://github.com/Tencent/tdesign-flutter/pull/239))
- `Input`: Added inputAction API to support setting keyboard actions; added spacer API to customize component spacing @ccXxx1aoBai ([#184](https://github.com/Tencent/tdesign-flutter/pull/184))
- `Text`: Added global font configuration and the ability to load web fonts @Luozf12345 ([#232](https://github.com/Tencent/tdesign-flutter/pull/232))
- `CountDown`: Added start/reset/pause/resume control functions @hkaikai ([#175](https://github.com/Tencent/tdesign-flutter/pull/175))
- `Popup`: Supported position and size settings @hkaikai ([#191](https://github.com/Tencent/tdesign-flutter/pull/191))

### 🐞 Bug Fixes
- `Toast`: Fixed the issue where the duration attribute was ineffective @ccXxx1aoBai ([#167](https://github.com/Tencent/tdesign-flutter/pull/167))
- `Input`: Fixed the label overflow issue @ccXxx1aoBai ([#184](https://github.com/Tencent/tdesign-flutter/pull/184))
- `Tabs`: For the tabs component, outlineType 'capsule' now supports setting selected and unselected tab background colors, and outlineType 'card' supports setting the selected tab background color @ccXxx1aoBai
- `Button`: Fixed the issue where properties could not be changed under the setState method @shizhe2018 ([#201](https://github.com/Tencent/tdesign-flutter/pull/201))
- `SearchBar`: Added a controller to the search bar, allowing external clearing of search text @shizhe2018 ([#194](https://github.com/Tencent/tdesign-flutter/pull/194))
- `Slider`: Added custom Decoration styles @shizhe2018 ([#198](https://github.com/Tencent/tdesign-flutter/pull/198))
- `Empty`: Added text size style API @shizhe2018 ([#219](https://github.com/Tencent/tdesign-flutter/pull/219))
- `Dialog`: Added input type background @shizhe2018 ([#238](https://github.com/Tencent/tdesign-flutter/pull/238))

### 🚧 Others
- HarmonyOS compilation support @hkaikai ([#233](https://github.com/Tencent/tdesign-flutter/pull/233))
- Modified theme adaptation tool @Luozf12345
- Added GitHub links for complete pages in demo code @Luozf12345



## 🌈 0.1.5 `2024-05-31`

### 🚀 Features
- `TDropdownMenu`:
  - add: Added TDropdownMenu dropdown menu component @hkaikai
- `TTextarea`:
  - add: Added Textarea multiline text box component @hkaikai
- `TBottomTabBar`:
  - add: Support for custom background color and distance between icon and text ([#138](https://github.com/Tencent/tdesign-flutter/issues/138))
  - add: TBottomTabBar supports externally setting currentIndex ([#110](https://github.com/Tencent/tdesign-flutter/issues/110))
- `TBadge`:
  - add: TBadge badge visibility setting when value is 0 @ccXxx1aoBai
- `TRadio`:
  - add: TRadio added custom background color and text color @ccXxx1aoBai ([#135](https://github.com/Tencent/tdesign-flutter/issues/135))
  - add: Added API to remove left margin ([#128](https://github.com/Tencent/tdesign-flutter/issues/128))
- `TCheckbox`:
  - add: TCheckbox added custom text color
  - add: Added API to remove left margin
- `TImage`:
  - add: Added Image.file ([#133](https://github.com/Tencent/tdesign-flutter/issues/133))
  - add: Allow external customization of TImage's fit method ([#114](https://github.com/Tencent/tdesign-flutter/issues/114))
- `TInput`:
  - add: Added custom size for Input clear button ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: Added left margin for label text ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: Added rightWidget for carType type ([#147](https://github.com/Tencent/tdesign-flutter/issues/32))
- `TDivider`:
  - add: Added text style size setting for divider component ([#134](https://github.com/Tencent/tdesign-flutter/issues/134))
- `TToast`:
  - add: Toast added attribute for custom text length ([#148](https://github.com/Tencent/tdesign-flutter/issues/148))
- `TSideBar`:
  - add: Added selected style ([#69](https://github.com/Tencent/tdesign-flutter/issues/69))
  - add: Added custom text padding ([#67](https://github.com/Tencent/tdesign-flutter/issues/67))

### 🐞 Bug Fixes
- `TButton`:
  - fix: Added mounted judgment before setState() ([#122](https://github.com/Tencent/tdesign-flutter/issues/112))
- `TDialog`:
  - fix: Modified Dialog to only auto-close when no action is set, if action is set, closing time is handled by the business itself ([#117](https://github.com/Tencent/tdesign-flutter/issues/117))

### 🚧 Others
- Added international language adaptation function
- Adapted to 3.16 text centering, added TTextConfig usage document



## 🌈 0.1.4 `2024-04-08`

### 🚀 Features
- `TCountDown`:
  - add: Added TCountDown countdown component @hkaikai
- `TTheme`:
  - add: Modified the theme implementation method, supporting ref attribute for custom mapping
  - add: Added default number font numberFontFamily
- `TText`:
  - add: Added TText force center switch kTextForceVerticalCenterEnable, which can globally disable forced centering to prevent excessive text offset after flutter 3.16 version ([#35](https://github.com/Tencent/tdesign-flutter/issues/35))
- `TBottomTabBar`:
  - add: Added custom background color feature ([#55](https://github.com/Tencent/tdesign-flutter/issues/55))
- `TCheckbox`:
  - add: TCheckbox and TRadio support custom colors ([#57](https://github.com/Tencent/tdesign-flutter/issues/57))
  - add: TCheckbox and TRadio support custom font sizes ([#66](https://github.com/Tencent/tdesign-flutter/issues/66))
- `TTabBar`:
  - add: TTabBar adds custom settings for divider color and height ([#71](https://github.com/Tencent/tdesign-flutter/issues/71))
- `TSwitch`:
  - add: TSwitch supports custom "on/off" text ([#73](https://github.com/Tencent/tdesign-flutter/issues/73))
- `TDialog`:
  - add: Added custom title alignment and content Widget feature ([#58](https://github.com/Tencent/tdesign-flutter/issues/58))

### 🐞 Bug Fixes
- `TSlider`:
  - fix: Fixed an issue where TSlider setting showThumbValue does not work.
- `TButton`:
  - fix: Fixed an issue where the external setting of the theme color for TButton does not take effect ([#54](https://github.com/Tencent/tdesign-flutter/issues/54))
- `TInput`:
  - fix: Fixed an issue where TInput's showBottomDivider does not work ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))
  - fix: Removed the invalid height API of TInput, use SizedBox to modify the height ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))

### 🚧 Others
- Example application, added a button to modify the theme, can quickly modify the theme color


## 🌈 0.1.3 `2024-03-15`

### 🚀 Features
- `TButton`:
  - add: Support for customizing the corner radius size through TButtonStyle.radius
- `TPicker`:
  - add: Picker component scrolling on PC now supports mouse dragging
  - add: For TPicker and TDatePicker components, the onConfirm no longer defaults to pop up the component internally, allowing external customization; when OnCancel is not empty, the component will not automatically pop.
- `TSwitch`:
  - add: onChanged now supports externally specifying whether to consume the event. If it has been consumed, it will no longer be processed internally ([#27](https://github.com/Tencent/tdesign-flutter/issues/27))
- `TBottomTabBar`:
  - add: Added custom label text style, optimized labText and icon parameter passing ([#49](https://github.com/Tencent/tdesign-flutter/issues/49))

### 🐞 Bug Fixes
- `TNavBar`:
  - fix: The height of NavBar is now obtained in real time to prevent it from not being available at the beginning ([#34](https://github.com/Tencent/tdesign-flutter/issues/34))
- `TDialog`:
  - fix: The contentColor parameter in DialogInfo was not passed in ([#37](https://github.com/Tencent/tdesign-flutter/pull/37))
- `TButton`:
  - fix: The click disable effect of TButton is invalid ([#44](https://github.com/Tencent/tdesign-flutter/issues/44))
- `TInput`:
  - fix: The delete button inside does not automatically refresh ([#30](https://github.com/Tencent/tdesign-flutter/issues/30))
  - fix: Fixed the mutual exclusion problem between the length of the input content and inputFormatters ([#38](https://github.com/Tencent/tdesign-flutter/issues/38))
- `TAlertDialog`:
  - fix: The operation of the default button of the component is open ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TRadio`:
  - fix: Horizontal arrangement will force the addition of an underline ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TTabBar`:
  - fix: The indicatorColor does not take effect ([#31](https://github.com/Tencent/tdesign-flutter/issues/31))

### 🚧 Others
- Optimized the performance of commonly used components such as TButton, TText, TTheme, etc.


## 🌈 0.1.2 `2024-01-08`

### 🚀 Features
- `TImage`:
    - add: Added FitWidth type to the image, modified the corresponding Demo page ([#14](https://github.com/Tencent/tdesign-flutter/pull/14))
- `TLoading`:
    - add: Added methods for showing and hiding loading ([#15](https://github.com/Tencent/tdesign-flutter/pull/15))
- `TPopup`:
    - add: Added support for customizing the round corners ([#17](https://github.com/Tencent/tdesign-flutter/pull/17))
- `TAvatar`:
    - add: When the avatar type is character or icon, support for customizing the background color is added ([#20](https://github.com/Tencent/tdesign-flutter/pull/20))

### 🐞 Bug Fixes
- `TBottomTabBar`:
    - Added a safe area, fixed ([#1](https://github.com/Tencent/tdesign-flutter/issues/1))
- `TButton`:
    - update widget: Button's disable status can be updated
    - fix: Button click state is too short ([#13](https://github.com/Tencent/tdesign-flutter/pull/13))
- `TSwiper`:
    - fix: Adapted swiper vertical dot bar style ([#19](https://github.com/Tencent/tdesign-flutter/pull/19))
- `TInput`:
    - fix: The setting of leftLabelStyle does not take effect when type is TInputType.twoLine ([#21](https://github.com/Tencent/tdesign-flutter/pull/21))

### 🚧 Others
- The minimum compatible version has been changed to 3.7.0 ([#3](https://github.com/Tencent/tdesign-flutter/issues/3))

## 0.1.1
* reset code style, can run on 3.7.x

## 0.1.0
* publisher to pub.dev stable

## 0.0.9
* update code style

## 0.0.8
* update License

## 0.0.7
* update example main.dart

## 0.0.6
* update slider component, make it is not depend on flutter sdk version

## 0.0.5
* publisher to pub.dev

## 0.0.4
* fix some bugs

## 0.0.3

* delete default value of TText's package prop, allow set it null value

## 0.0.2

* update ReadMe.md, modify export file is 'tdesign_flutter.dart'

## 0.0.1

* the first version, add button,text and other components.
