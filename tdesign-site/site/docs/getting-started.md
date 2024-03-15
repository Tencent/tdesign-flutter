---
title: Flutter
description: TDesign Flutter组件库。
spline: explain
---

## 预览

TDesign Flutter组件示例应用
<br/>
Android请扫码下载预览 ↓
<br/>
<img width="260" src="/flutter/assets/qrcode/tdesign_apk_qrcode.png" />
<br/>
iOS请运行项目预览 ↓
<br/>
[https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component](https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component)

## 使用方法
- 在pubbspec.yaml引入依赖。
```yaml
  dependencies:
    tdesign_flutter: ^0.1.0
```
    
- 在文件头部引入：`import 'package:tdesign_flutter/tdesign_flutter.dart'; // 组件库相关的，只需要引入这个文件，里面暴露td前缀所有需要的类`
- 可通过json文件配置颜色/字体尺寸/字体样式/圆角/阴影等主题样式。通过`TDTheme.of(context)或者TDTheme.defaultData()`获取主题数据。建议组件都使用`TDTheme.of(context)`的，不需要跟随局部主题的组件，才可以使用`TDTheme.defaultData()`。
    
    颜色，字体，圆角等使用示例：
```dart
    TDTheme.of(context).brandNormalColor
    TDTheme.defaultData().fontBodyLarge
```
- TDesign的Icon不跟随主题，都是ttf格式：

    使用示例：
    `Icon(TDIcons.activity)`
    
- 使用示例：`example/lib/page/`


## 自定义主题

设置自定义主题的方式:
```
    MaterialApp(
      theme: ThemeData(
        extensions: [TDThemeData.fromJson('test', testThemeConfig)!],
      )
      ……
    )
```
自定义主题属性,常用可设置属性键值请参考[td_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/lib/src/theme/td_default_theme.dart):
```
    String testThemeConfig = '''
      {
        "test": {
            "color": {
                "brandNormalColor": "#D7B386"
            },
            "font": {
                "fontBodyMedium": {
                    "size": 40,
                    "lineHeight": 55
                }
            }
        }
    }
  ''';
```

## 基础库版本

最低基础库版本：`^0.1.0`

## SDK依赖版本

dart: ">=2.19.0 <4.0.0"

flutter: ">=3.7.0"

## 交流反馈
<br/>
<img width="260" src="/flutter/assets/qrcode/feedback.png" />
<br/>
