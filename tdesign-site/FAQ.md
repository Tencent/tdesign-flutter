---
title: Flutter
description: TDesign Flutter组件库。
spline: explain
---

## 自定义主题
- 自定义主题用法请参考：https://tdesign.tencent.com/flutter/getting-started#%E8%87%AA%E5%AE%9A%E4%B9%89%E4%B8%BB%E9%A2%98
- 如果自定义主题未生效，请检查是否设置：TDTheme.needMultiTheme(true);
- 在启动即修改主题颜色，完整示例代码请参考：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/component_test/test_app.dart
- 在应用使用中切换主题颜色，示例代码请参考example的main.dart和home.dart：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/main.dart
- 转换完整代码：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/shell/theme/css2JsonTheme.dart

## 暗色模式
TDesignFlutter目前未内置暗色模式，请使用“自定义主题”方式自己适配。

## 文字居中
0.1.4版本:Flutter 3.16之后,修改了渲染引擎,导致启用forceVerticalCenter参数的组件字体偏移更多,不再居中.可以通过设置kTextForceVerticalCenterEnable=false来禁用字体居中功能,让组件显示与官方Text一致

0.1.5版本:适配了Android和iOS双端基础系统字体的中文居中,其他语言的字体,可以通过重写TDTextPaddingConfig的paddingRate和paddingExtraRate进行自定义适配,TDTextPaddingConfig使用方法可参考TDTextPage.

## 新增组件
如果有新增组件的想法，可以提issue，或者在已有issue补充。如果想提交代码，开发实现，可以拉负责人一起评估。

## Input相关
- 自定义高度： TDInput没有自带height参数，可以通过外部嵌套SizeBox来修改高度。不过修改高度后，内部相关高度不会等比缩放，需要业务自己同步修改。
- 输入正则：Input的FilteringTextInputFormatter.allow(RegExp(r''))的正则是匹配即将输入的单个字符串的，不是匹配已输入的整个字符串的，按字符串匹配写的正则可能导致无法输入。

## TDImage换成问题
TDImage基于系统Image组件封装，未单独处理缓存逻辑，使用的是系统组件自带的缓存。

## Toast 使用context
目前TDToast显示需要context，如果使用的是GetX，可以考虑是否要方法记录一个全局context，再给TDToast使用。如果后续实现方案优化了context，将更新本文档。

## 内部写死的颜色或尺寸
如果发现组件内部写死了颜色或尺寸，导致无法适应业务场景，可以直接提issue优化。
