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
    TDTheme.defaultData().fontBodyLarge
- TDesign的Icon不跟随主题，都是ttf格式：

    使用示例：
    TDIcon(TDIcons.activity)
    
- 使用示例：example/lib/page/

# 开发规范
- 组件命名规范：以TD为前缀，组件名称、API名称参考TDesign现有组件和API命名，可以根据flutter原生Widget的特点进行修改。组件API以满足设计要求和使用为准，可根据flutter特点做精简或定制。
- 组件库用到的所有色值、圆角、字体字号等样式属性需全部定义在主题中。
- 代码规范遵循腾讯Dart代码规范。
- 对于系统原有组件，如Text,Image等，应兼容系统原组件功能，只能扩展，不能阉割，以免业务需要使用系统功能时，必须放弃TDesign控件。
- 示例页面尽量使用ExamplePage+ExampleModule+ExampleItem组合，按照示例稿的布局实现；页面写完后，在main.dart中将页面注册进examplePageList即可。
- 组件API和演示代码，请参考`demo_tool/README.md`文件。

# 共建流程
- 拉取开发分支：建议将项目fork到自己github,每个组件从main分支拉取对应开发分支，命名为feature/组件名小写_下划线
- 实现组件：组件中的属性请尽量使用TDTheme提供的公共属性，使用方法参考'主题-基础'页面
- 编写示例页：示例页请尽量使用ExamplePage+ExampleModule+ExampleItem组合，参考示例稿布局实现。
- 演示代码：每个组件示例，尽量将原子性代码提取成独立方法，并添加@Demo注解，方便生成演示代码。其中，@Demo注解的'group'参数需与ExamplePage的'exampleCodeGroup'参数一致。写法请参考'圆角-基础'页。
- flutterAOP: 如果可以，建议切换到flutter 3.0.5分支，并添加AOP补丁，生成演示代码。如果不方便切3.0.5分支，后续会搭建流水线生成演示代码。
- API文档：目前生成api工具不完善，不要求必须生成api文档，但请尽量添加字段的详细注释，尽量将构造方法作为类名下的第一个方法，字段放在构造方法之下，具体写法请参考TDText。
- 代码规范：开发完成后，请检查'Dart Analysis'下的提示，尽量符合代码规范。
- 合并代码: 上述检查完成后，请发起pr，并同步项目组验收。

# 其他技术栈实现
- 桌面端 Vue 3 实现：[web-vue-next](https://github.com/Tencent/tdesign-vue-next)
- 桌面端 Vue 实现： [web-react](https://github.com/Tencent/tdesign-vue)
- 移动端小程序实现： [小程序](https://github.com/Tencent/tdesign-miniprogram)

# 开源协议

TDesign 遵循 [MIT 协议](https://github.com/TDesignOteam/tdesign-flutter/blob/main/LICENSE)