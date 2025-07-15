---
title: 常见问题
description: 
spline: explain
---

## 版本节奏
TDesign Flutter 从0.2.0版本开始，正常情况下，每月初发一个版本，若有节假日等特殊情况再特殊处理。

新版本携带的功能，可以通过issue的标签查看，带pre_x.x.x标签的issue，则表示已开发完成，预计在x.x.x发布。

## 自定义主题
- 自定义主题用法请参考：https://tdesign.tencent.com/flutter/getting-started#%E8%87%AA%E5%AE%9A%E4%B9%89%E4%B8%BB%E9%A2%98
- 如果自定义主题未生效，请检查是否设置：TDTheme.needMultiTheme(true);
- 在启动即修改主题颜色，完整示例代码请参考：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/component_test/test_app.dart
- 在应用使用中切换主题颜色，示例代码请参考example的main.dart和home.dart：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/main.dart
- 转换完整代码：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/shell/theme/css2JsonTheme.dart

## 暗色模式
TDesignFlutter目前未内置暗色模式，请使用“自定义主题”方式自己适配。

## 文字居中
Flutter官方SDK不支持文本居中功能，若要实现通用的文字居中方案，需要修改Flutter引擎，使用成本较高，因此，TDesign采用的是一个折中方案：针对常用字体，通过在其顶部添加padding的方式，达到居中的效果。

默认计算padding的尺寸，以Pixel 4模拟器的默认字体为基准，不同机型的字体不一样，有的机型可能需要的尺寸与默认适配字体差异较大，因此会出现添加padding后，文字更不居中的问题。

TDesign Flutter 0.1.4版本开始，添加了全局变量kTextForceVerticalCenterEnable来控制是否使用内部padding，如果将全局变量kTextForceVerticalCenterEnable设为false，则显示效果与直接使用官方Text一致。(部分机型，尤其是iOS机型，将kTextForceVerticalCenterEnable设为false，可能比设为true更居中，遇到文字不居中问题，可以尝试将kTextForceVerticalCenterEnable改为false看看效果。)

TDesign Flutter 0.1.5版本之后，可以通过重写TDTextPaddingConfig的paddingRate和paddingExtraRate进行自定义适配,TDTextPaddingConfig使用方法可参考TDTextPage。如果kTextForceVerticalCenterEnable设为false也无法满足需求，则可以通过重写TDTextPaddingConfig自定义适配主流机型。

## 新增组件
如果有新增组件的想法，可以提issue，或者在已有issue补充。如果想提交代码，开发实现，可以拉负责人一起评估。

## Input相关
- 自定义高度： TDInput没有自带height参数，可以通过外部嵌套SizeBox来修改高度。不过修改高度后，内部相关高度不会等比缩放，需要业务自己同步修改。
- 输入正则：Input的FilteringTextInputFormatter.allow(RegExp(r''))的正则是匹配即将输入的单个字符串的，不是匹配已输入的整个字符串的，按字符串匹配写的正则可能导致无法输入。

## TDImage缓存问题
TDImage基于系统Image组件封装，未单独处理缓存逻辑，使用的是系统组件自带的缓存。

## Toast 使用context
目前TDToast显示需要context，如果使用的是GetX，可以考虑是否要方法记录一个全局context，再给TDToast使用。如果后续实现方案优化了context，将更新本文档。

## 内部写死的颜色或尺寸
如果发现组件内部写死了颜色或尺寸，导致无法适应业务场景，可以直接提issue优化。

## flutter 3.32以下SDK 无法运行
flutter 3.32版本的sdk代码变更很大，无法跨版本兼容，因此引入了tdesign_flutter_adaptation库。

如果你是flutter 3.32以下的sdk版本，请在项目的pubspec.yaml中添加以下依赖覆盖：
```yaml
dependency_overrides:
  tdesign_flutter_adaptation: 3.16.0
  image_picker: 1.0.8
```

如果你是tdesign_flutter 0.2.3版本，且使用了3.32版本以上的Flutter SDK，请在项目的pubspec.yaml中添加以下依赖覆盖：
```yaml
dependency_overrides:
  tdesign_flutter_adaptation: 3.32.0
  image_picker: 1.1.2
```
