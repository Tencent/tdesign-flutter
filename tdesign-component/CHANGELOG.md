
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
