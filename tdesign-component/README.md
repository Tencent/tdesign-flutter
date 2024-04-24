<p align="center">
  <a href="https://tdesign.tencent.com/" target="_blank">
    <img alt="TDesign Logo" width="200" src="https://tdesign.gtimg.com/site/TDesign.png" />
  </a>
</p>


Tencent TDesign UI component library of Flutter, suitable for use in mobile projects. 


[中文文档](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/README_zh.md)


# Features:

- Provides Flutter UI component library in TDesign design style
- Support customizing themes according to App design style
- Provides commonly used Icon library and supports customized replacement
- Define color groups according to the TDesign specification, which can be viewed in TDColors to facilitate the adaptation of components to the TDesign specification.
- The color value declaration class can add default colors and view the default display effect of color values in real time.


# Notice:

- Theme styles such as color/font size/font style/rounded corners/shadow can be configured through json files. Get theme data through `TDTheme.of(context)` or `TDTheme.defaultData()`. It is recommended that all components use `TDTheme.of(context)`Only components that do not need to follow the local theme can use `TDTheme.defaultData()`.

  Examples of usage of colors, fonts, rounded corners, etc.:
```
    TDTheme.of(context).brandNormalColor
    TDTheme.defaultData().fontBodyLarge
```

- TDesign's icons do not follow the theme, they are all in ttf format, usage examples:
```
    Icon(TDIcons.activity)
```
    
- Example: `example/lib/page/`

# SDK dependency version:

dart: ">=2.19.0 <4.0.0"

flutter: ">=3.7.0"

# Other technology stack implementations:

- Desktop Vue 3 implementation：[web-vue-next](https://github.com/Tencent/tdesign-vue-next)
- Desktop React implementation： [web-react](https://github.com/Tencent/tdesign-react)
- Implementation of miniprogram： [miniprogram](https://github.com/Tencent/tdesign-miniprogram)

# Feedback

 <img src="../feedback.png" width = "200" height = "200" alt="feedback" align=center />

# Open source agreement:

TDesign is licensed under the [MIT LICENSE](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/LICENSE)


# Acknowledgements
TDesign Flutter depends on the following component libraries. We appreciate the authors for their open-source contributions:

[flutter_easyrefresh](https://pub-web.flutter-io.cn/packages/easy_refresh)

[flutter_swiper](https://pub-web.flutter-io.cn/packages/flutter_swiper)