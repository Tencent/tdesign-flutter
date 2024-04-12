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
<img width="260" src="/flutter/assets/qrcode/td_apk_qrcode.png" />
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


# 自定义主题

## 基础用法
设置自定义主题的方式:
```
    MaterialApp(
      theme: ThemeData(
        extensions: [TDThemeData.fromJson('test', testThemeConfig)!],
      )
      ……
    )
```
自定义主题属性,常用可设置属性键值请参考[td_default_theme.dart](lib/src/theme/td_default_theme.dart):
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

## 主题生成器
如果你不想自定义太多颜色,但是想要拥有好看的自定义主题,"主题生成器"是个不错的选择.

1.进入[TDesign官网](https://tdesign.tencent.com/vue/custom-theme) ,点击下方的主题生成器,然后再右边生成器里选择想要的颜色,点击下载

![img.png](/flutter/assets/theme_generator.png)

![img.png](/flutter/assets/select_color.png)

2.此时你得到是一个theme.css文件,可以将该文件放到tdesign-component/example/shell/theme/文件夹下,把该文件夹下的css2JsonTheme.dart修改为你自己的文件名、主题名和输出路径,即可得到一个theme.json文件
![img.png](/flutter/assets/dart_modify.png)

3.将主题json加载进TDTheme,美观的自定义主题就设置完成了.
```
    // 开启多套主题功能
    TDTheme.needMultiTheme();

    var jsonString = await rootBundle.loadString('assets/theme.json');
    var _themeData = TDThemeData.fromJson('green', jsonString);
    // ……
    MaterialApp(
      title: 'TDesign Flutter Example',
      theme: ThemeData(
      extensions: [_themeData],
      home: MyHomePage(title: 'TDesign Flutter 组件库'),
    );
```

## 常见问题

- Flutter 3.16之后,修改了渲染引擎,导致启用forceVerticalCenter参数的组件字体偏移更多,不再居中.可以通过设置kTextForceVerticalCenterEnable=false来禁用字体居中功能,让组件显示与官方Text一致

## 基础库版本

最低基础库版本：`^0.1.0`

## SDK依赖版本

dart: ">=2.19.0 <4.0.0"

flutter: ">=3.7.0"

## 交流反馈
<br/>
<img width="260" src="/flutter/assets/qrcode/feedback.png" />
<br/>

# 致谢
TDesign Flutter 依赖以下组件库,感谢作者的开源贡献:

[flutter_easyrefresh](https://pub-web.flutter-io.cn/packages/easy_refresh)

[flutter_swiper](https://pub-web.flutter-io.cn/packages/flutter_swiper)
