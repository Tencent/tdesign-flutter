---
title: 更新日志
spline: explain
toc: false
docClass: timeline
---

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

* 修改 exmaple的main.dart

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
