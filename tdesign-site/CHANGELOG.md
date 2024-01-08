---
title: 更新日志
spline: explain
toc: false
docClass: timeline
---

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
