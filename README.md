<p align="center">
  <a href="https://tdesign.tencent.com/" target="_blank">
    <img alt="TDesign Logo" width="200" src="https://tdesign.gtimg.com/site/TDesign.png" />
  </a>
</p>

TDesign Flutter技术栈组件库，适合在移动端项目中使用。

# 特性

- 提供TDesign设计风格的Flutter UI组件库
- 支持根据App设计风格定制主题
- 提供常用Icon库，支持定制替换
- 根据TDesign规范定义颜色组，可在TDColors中查看，方便适配TDesign规范的组件
- 色值声明类可以添加默认颜色，实时查看色值默认显示效果

# 使用方法
- 在pubbspec.yaml引入依赖。

    dependencies:
      tdesign_flutter:
        git: https://github.com/TDesignOteam/tdesign-flutter.git
    
- 在文件头部引入：import 'package:tdesign_flutter/td_export.dart'; // 组件库相关的，只需要引入这个文件，里面暴露td前缀所有需要的类
- 可通过json文件配置颜色/字体尺寸/字体样式/圆角/阴影等主题样式。通过TDTheme.of(context)或者TDTheme.defaultData()获取主题数据。建议组件都使用TDTheme.of(context)的，不需要跟随局部主题的组件，才可以使用TDTheme.defaultData()。
    
    颜色，字体，圆角等使用示例：
    TDTheme.of(context).brandNormalColor
    TDTheme.defaultData().fontM
- TDesign的Icon不跟随主题，都是ttf格式：

    使用示例：
    TDIcon(TDIcons.activity)
    
- 使用示例：example/lib/tdesign/page

# 开发规范
- 组件命名规范：以TD为前缀，组件名称、API名称参考TDesign现有组件和API命名，可以根据flutter原生Widget的特点进行修改。组件API以满足设计要求和使用为准，可根据flutter特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯Dart代码规范。
- 对于系统原有组件，如Text,Image等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃TDesign控件。
- 示例页面尽量使用ExampleWidget+ExampleItem组合，在ExampleItem的desc写明示例描述；页面写完后，在main.dart中将页面注册进examplePageList即可。


# 其他技术栈实现
- 桌面端 Vue 3 实现：[web-vue-next](https://github.com/Tencent/tdesign-vue-next)
- 桌面端 Vue 实现： [web-react](https://github.com/Tencent/tdesign-vue)
- 移动端小程序实现： [小程序](https://github.com/Tencent/tdesign-miniprogram)

# 开源协议

TDesign 遵循 [MIT 协议](https://github.com/TDesignOteam/tdesign-flutter/blob/main/LICENSE)