## 🌈 0.1.8 `2024-12-30`
### 🚀 Features
- `TDUpload`: Added Upload component @TingShine ([#405](https://github.com/Tencent/tdesign-flutter/pull/405))
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
- `Dialog`: TDDialogButtonOptions added font size attribute @shizhe2018 ([#381](https://github.com/Tencent/tdesign-flutter/pull/381))
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
- `TDBottomTabBar`: Fixed the issue of bottom overflow by 2.5 pixels in iconText mode @epoll-j ([#422](https://github.com/Tencent/tdesign-flutter/pull/422))

### 🚧 Others
- Adapted to FlutterSdk3.25, the minimum supported version has been adjusted to 3.16.0 @shizhe2018 ([#378](https://github.com/Tencent/tdesign-flutter/pull/378))
- Modified Example English version copy @shizhe2018 ([#382](https://github.com/Tencent/tdesign-flutter/pull/382))
- Upgraded flutter_slidable version @Luozf12345 ([#407](https://github.com/Tencent/tdesign-flutter/pull/407))
- Added component search function to demo @Luozf12345 ([#410](https://github.com/Tencent/tdesign-flutter/pull/410))
- Updated Icons @Luozf12345 ([#420](https://github.com/Tencent/tdesign-flutter/pull/420))

## 🌈 0.1.7 `2024-10-16`
### 🚀 Features
- `TDNoticeBar`: Added noticeBar component @ccXxx1aoBai ([#162](https://github.com/Tencent/tdesign-flutter/pull/162))
- `Result`: Added Result component @shinyina ([#220](https://github.com/Tencent/tdesign-flutter/pull/220))
- `TimeCounter`: Timer component supports time display beyond conversion units, original TDCountDown component renamed to TimeCounter @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `Calendar`: Added Calendar component @hkaikai ([#271](https://github.com/Tencent/tdesign-flutter/pull/271))
- `Indexes`: Added Indexes component @hkaikai ([#321](https://github.com/Tencent/tdesign-flutter/pull/321))
- `Table`: Added table component @ccXxx1aoBai ([#244](https://github.com/Tencent/tdesign-flutter/pull/244))
- `Rate`: Added Rate component @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `Dialog`: Supports custom content padding and buttons @ccXxx1aoBai ([#289](https://github.com/Tencent/tdesign-flutter/pull/289))
- `Drawer`: Supports controlling the visibility of the divider, custom drawer background color, and controlling the display of the last divider @ccXxx1aoBai ([#278](https://github.com/Tencent/tdesign-flutter/pull/278))
- `DropdownMenu`: Added control parameters for icon/width/height/icon and text alignment @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `Search`: Added action and onActionClick properties @Ezer015 ([#263](https://github.com/Tencent/tdesign-flutter/pull/263))
- `Avatar`: Added onTap event @ccXxx1aoBai ([#344](https://github.com/Tencent/tdesign-flutter/pull/344))
- `TDDropdownMenu`: Added tabBarFlex parameter to TDDropdownItem to control width ratio @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
- `SearchBar`: Feature/td searchbarfix added cursor height property @shizhe2018 ([#337](https://github.com/Tencent/tdesign-flutter/pull/337))
- `TimeCounter`: Added forward timing function @epoll-j ([#246](https://github.com/Tencent/tdesign-flutter/pull/246))
- `NavBar`: [NavBar] supports setting bottom shadow @ccXxx1aoBai ([#284](https://github.com/Tencent/tdesign-flutter/pull/284))
- `Cell`: Added custom padding parameter @epoll-j ([#276](https://github.com/Tencent/tdesign-flutter/pull/276))
- `Input`: Added onTapOutside callback @epoll-j ([#280](https://github.com/Tencent/tdesign-flutter/pull/280))
- `Picker`: Added custom leftText, rightText @epoll-j ([#301](https://github.com/Tencent/tdesign-flutter/pull/301))
- `Slider`: Feature/tdslider added text wrapping function @shizhe2018 ([#329](https://github.com/Tencent/tdesign-flutter/pull/329))
- `Radio`: Feature/tdRadioGroup added built-in line wrapping, set number of rows and columns @shizhe2018 ([#331](https://github.com/Tencent/tdesign-flutter/pull/331))
- `Dialog`: Added custom input box @shizhe2018 ([#333](https://github.com/Tencent/tdesign-flutter/pull/333))
- `TDNavBar`: Added flexibleSpace parameter @Luozf12345 ([#341](https://github.com/Tencent/tdesign-flutter/pull/341))
- `TDSearch`: Added search box focus acquisition and clear events @Luozf12345 ([#342](https://github.com/Tencent/tdesign-flutter/pull/342))

### 🐞 Bug Fixes
- `ImageViewer`: Fixed defaultIndex invalid issue @ccXxx1aoBai ([#292](https://github.com/Tencent/tdesign-flutter/pull/292))
- `TimeCounter`: Fixed issue where it could not be reset repeatedly @hkaikai ([#272](https://github.com/Tencent/tdesign-flutter/pull/272))
- `DropdownMenu`: Adjusted popup layer logic, fixed issue where back button could not be listened to @hkaikai ([#297](https://github.com/Tencent/tdesign-flutter/pull/297))
- `DatePicker`: Removed monitoring on year, month, and day when destroyed to avoid memory leaks; added onSelectedItemChanged event @hkaikai ([#300](https://github.com/Tencent/tdesign-flutter/pull/300))
- `SideBar`: Fixed issue where custom selected style text was not centered @ccXxx1aoBai ([#313](https://github.com/Tencent/tdesign-flutter/pull/313))
- `Popup`: Fixed issue where multiple returns occurred when quickly clicking the mask @ccXxx1aoBai ([#318](https://github.com/Tencent/tdesign-flutter/pull/318))
- `ImageViewer`: Fixed issue where deleting the first image caused display anomalies @ccXxx1aoBai ([#322](https://github.com/Tencent/tdesign-flutter/pull/322))
- `SideBar`: Fixed issue where delayed loading components caused anchor point function anomalies @ccXxx1aoBai ([#343](https://github.com/Tencent/tdesign-flutter/pull/343))
- `TDDropdownMenu`: Optimized menu display text to show ellipsis when exceeding display limit @hkaikai ([#338](https://github.com/Tencent/tdesign-flutter/pull/338))
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
- `TDDropdownMenu`:
  - add: Added TDDropdownMenu dropdown menu component @hkaikai
- `TDTextarea`:
  - add: Added Textarea multiline text box component @hkaikai
- `TDBottomTabBar`:
  - add: Support for custom background color and distance between icon and text ([#138](https://github.com/Tencent/tdesign-flutter/issues/138))
  - add: TDBottomTabBar supports externally setting currentIndex ([#110](https://github.com/Tencent/tdesign-flutter/issues/110))
- `TDBadge`:
  - add: TDBadge badge visibility setting when value is 0 @ccXxx1aoBai
- `TDRadio`:
  - add: TDRadio added custom background color and text color @ccXxx1aoBai ([#135](https://github.com/Tencent/tdesign-flutter/issues/135))
  - add: Added API to remove left margin ([#128](https://github.com/Tencent/tdesign-flutter/issues/128))
- `TDCheckbox`:
  - add: TDCheckbox added custom text color
  - add: Added API to remove left margin
- `TDImage`:
  - add: Added Image.file ([#133](https://github.com/Tencent/tdesign-flutter/issues/133))
  - add: Allow external customization of TDImage's fit method ([#114](https://github.com/Tencent/tdesign-flutter/issues/114))
- `TDInput`:
  - add: Added custom size for Input clear button ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: Added left margin for label text ([#147](https://github.com/Tencent/tdesign-flutter/issues/147))
  - add: Added rightWidget for carType type ([#147](https://github.com/Tencent/tdesign-flutter/issues/32))
- `TDDivider`:
  - add: Added text style size setting for divider component ([#134](https://github.com/Tencent/tdesign-flutter/issues/134))
- `TDToast`:
  - add: Toast added attribute for custom text length ([#148](https://github.com/Tencent/tdesign-flutter/issues/148))
- `TDSideBar`:
  - add: Added selected style ([#69](https://github.com/Tencent/tdesign-flutter/issues/69))
  - add: Added custom text padding ([#67](https://github.com/Tencent/tdesign-flutter/issues/67))

### 🐞 Bug Fixes
- `TDButton`:
  - fix: Added mounted judgment before setState() ([#122](https://github.com/Tencent/tdesign-flutter/issues/112))
- `TDDialog`:
  - fix: Modified Dialog to only auto-close when no action is set, if action is set, closing time is handled by the business itself ([#117](https://github.com/Tencent/tdesign-flutter/issues/117))

### 🚧 Others
- Added international language adaptation function
- Adapted to 3.16 text centering, added TDTextConfig usage document



## 🌈 0.1.4 `2024-04-08`

### 🚀 Features
- `TDCountDown`:
  - add: Added TDCountDown countdown component @hkaikai
- `TDTheme`:
  - add: Modified the theme implementation method, supporting ref attribute for custom mapping
  - add: Added default number font numberFontFamily
- `TDText`:
  - add: Added TDText force center switch kTextForceVerticalCenterEnable, which can globally disable forced centering to prevent excessive text offset after flutter 3.16 version ([#35](https://github.com/Tencent/tdesign-flutter/issues/35))
- `TDBottomTabBar`:
  - add: Added custom background color feature ([#55](https://github.com/Tencent/tdesign-flutter/issues/55))
- `TDCheckbox`:
  - add: TDCheckbox and TDRadio support custom colors ([#57](https://github.com/Tencent/tdesign-flutter/issues/57))
  - add: TDCheckbox and TDRadio support custom font sizes ([#66](https://github.com/Tencent/tdesign-flutter/issues/66))
- `TDTabBar`:
  - add: TDTabBar adds custom settings for divider color and height ([#71](https://github.com/Tencent/tdesign-flutter/issues/71))
- `TDSwitch`:
  - add: TDSwitch supports custom "on/off" text ([#73](https://github.com/Tencent/tdesign-flutter/issues/73))
- `TDDialog`:
  - add: Added custom title alignment and content Widget feature ([#58](https://github.com/Tencent/tdesign-flutter/issues/58))

### 🐞 Bug Fixes
- `TDSlider`:
  - fix: Fixed an issue where TDSlider setting showThumbValue does not work.
- `TDButton`:
  - fix: Fixed an issue where the external setting of the theme color for TDButton does not take effect ([#54](https://github.com/Tencent/tdesign-flutter/issues/54))
- `TDInput`:
  - fix: Fixed an issue where TDInput's showBottomDivider does not work ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))
  - fix: Removed the invalid height API of TDInput, use SizedBox to modify the height ([#70](https://github.com/Tencent/tdesign-flutter/issues/70))

### 🚧 Others
- Example application, added a button to modify the theme, can quickly modify the theme color


## 🌈 0.1.3 `2024-03-15`

### 🚀 Features
- `TDButton`:
  - add: Support for customizing the corner radius size through TDButtonStyle.radius
- `TDPicker`:
  - add: Picker component scrolling on PC now supports mouse dragging
  - add: For TDPicker and TDDatePicker components, the onConfirm no longer defaults to pop up the component internally, allowing external customization; when OnCancel is not empty, the component will not automatically pop.
- `TDSwitch`:
  - add: onChanged now supports externally specifying whether to consume the event. If it has been consumed, it will no longer be processed internally ([#27](https://github.com/Tencent/tdesign-flutter/issues/27))
- `TDBottomTabBar`:
  - add: Added custom label text style, optimized labText and icon parameter passing ([#49](https://github.com/Tencent/tdesign-flutter/issues/49))

### 🐞 Bug Fixes
- `TDNavBar`:
  - fix: The height of NavBar is now obtained in real time to prevent it from not being available at the beginning ([#34](https://github.com/Tencent/tdesign-flutter/issues/34))
- `TDDialog`:
  - fix: The contentColor parameter in DialogInfo was not passed in ([#37](https://github.com/Tencent/tdesign-flutter/pull/37))
- `TDButton`:
  - fix: The click disable effect of TDButton is invalid ([#44](https://github.com/Tencent/tdesign-flutter/issues/44))
- `TDInput`:
  - fix: The delete button inside does not automatically refresh ([#30](https://github.com/Tencent/tdesign-flutter/issues/30))
  - fix: Fixed the mutual exclusion problem between the length of the input content and inputFormatters ([#38](https://github.com/Tencent/tdesign-flutter/issues/38))
- `TDAlertDialog`:
  - fix: The operation of the default button of the component is open ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TDRadio`:
  - fix: Horizontal arrangement will force the addition of an underline ([#40](https://github.com/Tencent/tdesign-flutter/issues/40))
- `TDTabBar`:
  - fix: The indicatorColor does not take effect ([#31](https://github.com/Tencent/tdesign-flutter/issues/31))

### 🚧 Others
- Optimized the performance of commonly used components such as TDButton, TDText, TDTheme, etc.


## 🌈 0.1.2 `2024-01-08`

### 🚀 Features
- `TDImage`:
    - add: Added FitWidth type to the image, modified the corresponding Demo page ([#14](https://github.com/Tencent/tdesign-flutter/pull/14))
- `TDLoading`:
    - add: Added methods for showing and hiding loading ([#15](https://github.com/Tencent/tdesign-flutter/pull/15))
- `TDPopup`:
    - add: Added support for customizing the round corners ([#17](https://github.com/Tencent/tdesign-flutter/pull/17))
- `TDAvatar`:
    - add: When the avatar type is character or icon, support for customizing the background color is added ([#20](https://github.com/Tencent/tdesign-flutter/pull/20))

### 🐞 Bug Fixes
- `TDBottomTabBar`:
    - Added a safe area, fixed ([#1](https://github.com/Tencent/tdesign-flutter/issues/1))
- `TDButton`:
    - update widget: Button's disable status can be updated
    - fix: Button click state is too short ([#13](https://github.com/Tencent/tdesign-flutter/pull/13))
- `TDSwiper`:
    - fix: Adapted swiper vertical dot bar style ([#19](https://github.com/Tencent/tdesign-flutter/pull/19))
- `TDInput`:
    - fix: The setting of leftLabelStyle does not take effect when type is TDInputType.twoLine ([#21](https://github.com/Tencent/tdesign-flutter/pull/21))

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

* delete default value of TDText's package prop, allow set it null value

## 0.0.2

* update ReadMe.md, modify export file is 'tdesign_flutter.dart'

## 0.0.1

* the first version, add button,text and other components.
